// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./libraries/ERC721Vault.sol";

contract Charger is ERC721Vault {
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
    
    address public battery;

    address public asset;
    mapping(uint256 => uint256) public _locked;

    modifier onlyOwner(
        uint256 id
    ) {
        require(ownerOf(id) == msg.sender, "");
        _;
    }

    constructor(
        string memory name,
        string memory symbol,

        address _battery,

        address _asset
    ) ERC721Vault(name, symbol) {
        battery = _battery;
        asset = _asset;
    }

    /*

    accept ASSET, ++ limit

    remove asset, -- limit

    allow lend, ++ hold

    repay debt, -- hold

    resolve hold function (swap debt tokens for colat) -- hold

    */

    function create() external returns(uint256) {
        return(_create(msg.sender));
    }

    function destroy(
        uint256 id,
        bool empty
    ) external onlyOwner(id) {
        require(locked(id) == 0 || empty, "Vault contains assets");
        require(hold(id) == 0, "Vault has an outstanding position");
        if(empty) {
            IERC20(asset).safeTransfer(msg.sender, locked[id]);
        }
        _destroy(id);
    }

    /*
        DEPOSIT
        put assets inside locker
    */
    function deposit(
        uint256 id,
        uint256 amount
    ) external onlyOwner(id) {
        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);

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

        //check with battery for a hold

        _locked[id] = _locked[id].sub(amount);
        
        IERC20(asset).safeTransfer(msg.sender, amount);

        emit Withdraw(id, amount);
    }



    // INTERNAL FUNCTIONS

    function locked(uint256 id) public view returns(uint256) {
        return(_locked[id]);
    }

    function hold(uint256 id) public view returns(uint256) {
        return(_hold[id]);
    }

    function _liquid(
        uint256 id
    ) internal virtual returns(uint256) {
        return(
            locked[id]
        );
    }

    function _bal(
        address token
    ) internal view returns(uint256) {
        return(IERC20(token).balanceOf(address(this)));
    }

}