// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./libraries/ERC721Vault.sol";
import "./libraries/Oracles/Simple.sol";

import "../interfaces/IBattery.sol";

import "hardhat/console.sol";

contract Charger is 
    OracleSimple,
    ERC721Vault
    {
	using SafeERC20 for IERC20;
    using SafeMath for uint256;

    event Deposit(
        uint256 id,
        uint256 amount
    );

    event Withdraw(
        uint256 id,
        uint256 amount
    );
    

    event Operation(
        uint256 id,
        uint256 amount
    );
    
    IBattery public battery;

    mapping(uint256 => uint256) public _locked;

    uint256 public minimumRatio;
    uint256 public maximumRatio;

    modifier onlyOwner(
        uint256 id
    ) {
        require(ownerOf(id) == msg.sender, "cannot");
        _;
    }

    modifier onlyBattery() {
        require(msg.sender == address(battery), "cannot");
        _;
    }

    constructor(
        string memory name,
        string memory symbol,

        address _battery,

        address _asset,
        address _oracle,

        uint256 _min,
        uint256 _max
    ) ERC721Vault(name, symbol) {
        battery = IBattery(_battery);

        minimumRatio = _min;
        maximumRatio = _max;

        initOracle(_asset, _oracle);
    }

    /*

    accept ASSET, ++ limit

    remove asset, -- limit

 B  allow lend, ++ hold

 B  repay debt, -- hold

 B -Battery Contract
    */

    function createCharger() external returns(uint256) {
        uint256 newId = _create(msg.sender);
        console.log(newId);
        return newId;
    }

    function destroy(
        uint256 id,
        bool empty
    ) external onlyOwner(id) {
        require(locked(id) == 0 || empty, "Vault contains assets");
        require(hold(id) == 0, "Vault has an outstanding position");
        if(empty) {
            IERC20(asset()).safeTransfer(msg.sender, locked(id));
        }
        _destroy(id);
        _locked[id] = 0;
    }

    /*
        DEPOSIT
        put assets inside locker
    */
    function deposit(
        uint256 id,
        uint256 amount
    ) external onlyOwner(id) {
        IERC20(asset()).safeTransferFrom(msg.sender, address(this), amount);

        _locked[id] = _locked[id].add(amount);

        emit Deposit(id, amount);
    }



    /*
        WITHDRAW
        take assets out of locker
    */
    function withdraw(
        uint256 id,
        uint256 amount
    ) external onlyOwner(id) {
        uint256 outstanding = hold(id);
        require( outstanding == 0 ||
            health(locked(id).sub(amount), outstanding) >= minimumRatio
            , "Cannot withdraw");
        //check with battery for a hold

        _locked[id] = _locked[id].sub(amount);
        
        IERC20(asset()).safeTransfer(msg.sender, amount);

        emit Withdraw(id, amount);
    }



    // INTERNAL FUNCTIONS

    function locked(uint256 id) public view returns(uint256) {
        return(_locked[id]);
    }

    function hold(uint256 id) public view returns(uint256) {
        return(battery.getHold(address(this), id));
    }
    
    function scale(
		uint256 a,
		uint256 c
	) internal view returns(uint256, uint256) {
		uint256 assetValue = a.mul(getPrice());
		uint256 chargeValue = c.mul(battery.peg());
		return(assetValue, chargeValue);
	}

    function health(
        uint256 a,
        uint256 c
    ) public view returns(uint256) {
        (uint256 va, uint256 vi) = scale(a, c);
        return(va.mul(100).div(vi));
    }

    function _liquid(
        uint256 id
    ) public view returns(uint256) {
        return( locked(id).sub(
            hold(id).mul(battery.peg()).div(getPrice())
        ) );
    }

    function totalLocked() public view returns(uint256) {
        return(IERC20(asset()).balanceOf(address(this)));
    }

    function approveBattery() external onlyBattery {
        IERC20(asset()).approve(address(battery), type(uint256).max);
    }

    function imposeOperationFee(
        uint256 id
    ) external onlyBattery returns(bool) {
        uint256 lock = locked(id);
        uint256 coll = locked(_col());
        
        (uint256 va, uint256 vi) = scale(10000, lock.mul(50));
        uint256 comp = (vi).div(va);

        uint256 newLocked = lock.sub(comp);
        uint256 newColl   = coll.add(comp);
        assert(
            (newLocked <= lock) &&
            (coll      <= newColl)
        );

        _locked[id] = newLocked;
        _locked[_col()] = newColl;

        emit Operation(id, comp);
        return(true);
    }

}