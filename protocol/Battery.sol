// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "../interfaces/IOracleAdapter.sol";
import "../interfaces/ICharger.sol";
import "../interfaces/IPlug.sol";

contract Battery is Ownable, AccessControl {
	using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bytes32 public constant CHARGER = keccak256("CHARGER_ROLE");

    event Discharge(
        address charger,
        uint256 id,
        uint256 amount
    );

    event ReturnCharges(
        address charger,
        uint256 id,
        uint256 amount
    );

    event BatteryRecharged(
        address charger,
        uint256 id,
        uint256 amount
    );

    address public charge;

    uint256 public peg;

    uint256 private resolutionDiscount;

    //      charger            id         amount
    mapping(address => mapping(uint256 => uint256)) public _hold;


    modifier onlyLockerOwner(
        address locker,
        uint256 id
    ) {
        require( IERC721(locker).ownerOf(id) == msg.sender
            , "do not own");
        _;
    }

    modifier imposesFee(
        address locker,
        uint256 id
    ) {
        require( ICharger(locker).imposeOperationFee(id)
            , "could not apply fee to account");
        _;
    }

    constructor(
        address _charge
    ) {
        charge = _charge;
        peg    = 100000000; //$1
        // a charge is a doller wyt this is
        resolutionDiscount = 10; //10%

        transferOwnership(msg.sender);
    }

    /*

    allow borrowing of CHRG, increasing hold

    repaying CHRG, decreasing hold



    resolve hold function

    */

    function discharge(
        address _charger,
        uint256 id,
        uint256 _amount
    ) external imposesFee(_charger, id) onlyLockerOwner(_charger, id) {
        //claim all available charges up to _amount

        ICharger charger = ICharger(_charger);

        uint256 maxCharges = _charges();
        uint256 amount = (_amount == type(uint256).max) ? maxCharges : _amount;
        require(amount <= maxCharges, "request cannot be filled");

        uint256 collateral = charger.locked(id);
        uint256 hold       = getHold(_charger, id);

        uint256 newHold    = hold.add(amount);

        require( charger.health(collateral, newHold) >= charger.minimumRatio()
            , "requesting too many");

        _addHold(_charger, id, amount);

        IERC20(charge).safeTransfer(
            msg.sender, 
            amount
        );
    }



    /*
        RESOLVE HOLD
        resolve the hold on the assets, unlocking them
    */
    function returnCharges(
        address _charger,
        uint256 id,
        uint256 _amount
    ) external imposesFee(_charger, id) onlyLockerOwner(_charger, id) {
        uint256 amount = getHold(_charger, id);

        if(_amount < type(uint256).max) {
            require(_amount <= amount
                , "unrequired payment");
            amount = _amount;
        }

        IERC20(charge).safeTransferFrom(
            msg.sender, 
            address(this), 
            amount
        );
        
        _subHold(_charger, id, amount);
    }


    /*

        FLASH RESOLVE:
            flashloan out the locker's assets
                allow receiver to trade the assets to stablecoins (charges)

            get the required amount of charges back

        this is effectively a flashloan with a REWARD instead of a FEE!!!

        the reward is equal to the differance between 
            [ASSETS GIVEN] and [CHARGES TAKEN BACK]

        this function will give the receiver $XXX worth of ASSET
        but only take back               (N%)$XXX worth of CHARGES
            {0<N<100} to include slippage, etc, 
            keep the change, bud

    */
    function recharge(
        address receiverAddress,

        address locker,
        uint256 id,

        bytes calldata params
    ) external {
        ICharger charger = ICharger(locker);
        IPlug plug = IPlug(receiverAddress);

        address asset = charger.asset();

        uint256 cost = getHold(locker, id);
        uint256 discount = cost.mul(resolutionDiscount).div(100);
    
        uint256 amountToResolve = charger.locked(id); 
        //convert [cost] to [# of ASSET]

        charger.approveBattery();
        IERC20(
            asset
        ).safeTransferFrom(locker, msg.sender, amountToResolve);

        //flashloan baby
        require(plug.executeOperation(
            asset,
            amountToResolve,
            discount,
            msg.sender,
            params
            ) ,"illegal operation");

        IERC20(charge).safeTransferFrom(
            receiverAddress, 
            address(this), 
            cost
        );

    }


    function getHold(
        address charger,
        uint256 locker
    ) public view returns(uint256) {
        return(_hold[charger][locker]);
    }

    function getLocked(
        address charger,
        uint256 locker
    ) public view returns(uint256) {
        return(ICharger(charger).locked(locker));
    }

    // INTERAL HOLD FUNCTIONS

    function _addHold(
        address charger,
        uint256 locker,
        uint256 amount
    ) internal {
        _hold[charger][locker] = getHold(charger, locker).add(amount);
    }

    function _subHold(
        address charger,
        uint256 locker,
        uint256 amount
    ) internal {
        _hold[charger][locker] = getHold(charger, locker).sub(amount);
    }
 
    
    function _charges() public view returns(uint256) {
        return(IERC20(charge).balanceOf(address(this)));
    }

}