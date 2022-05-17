// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "";


contract Battery is Ownable {
	using SafeERC20 for IERC20;
    using SafeMath for uint256;
    
    address public keeper;

    address public charge;

    //      asset             lockerID    amount
    mapping(address => mapping(uint256 => uint256)) public hold;

    constructor(
        address _keeper,
        address _charge
    ) {
        keeper = _keeper;

        charge = _charge;

        transferOwnership(msg.sender);
    }

    /*

    allow borrowing of CHRG, increasing hold

    repaying CHRG, decreasing hold



    resolve hold function

    */


    /*
        PLACE HOLD
        place a hold on the assets, locking them
    */
    function placeHold(
        uint256 id,
        uint256 amount
    ) external onlyOwner(id) {
        //claim all available charges

        
        hold[id] = hold[id].add(amount);
    }



    /*
        RESOLVE HOLD
        resolve the hold on the assets, unlocking them
    */
    function resolveHold(
        uint256 id,
        uint256 amount
    ) external {
        uint256 amount = hold[toResolve];

        hold[toResolve] = hold[toResolve].sub(amount);
        
    }


    /*
        FLASH RESOLVE
        flashloan out the locker's assets
        resolving the hold by returning CHARGES 
                -instead of the original asset
    */
    function flashResolve(
        address receiverAddress,
        uint256 batteryID
    ) external {
        uint256 totalLocked = _locked(id);
        uint256 totalHold = _hold(id);

        uint256 availableLiquidity = _liquid(id);
        uint256 cost = _hold(id);

        IERC20(asset).safeTransfer(msg.sender, availableLiquidity);

        require(ICharger().
            ,"illegal operation");

        IERC20(charge).safeTransferFrom(
            msg.sender, 
            address(this), 
            cost
        )

    }



    function getHold(
        address asset,
        uint256 locker
    ) external returns(uint256) {
        return(hold[asset][locker]);
    }
 
}