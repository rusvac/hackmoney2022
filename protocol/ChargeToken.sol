// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ChargeToken is Ownable, ERC20 {

    event Mint(uint256 amount);
    event Burn(uint256 amount);

    constructor(
    ) ERC20("Charge Token","CHRG") {
        transferOwnership(msg.sender);
    }

    function increaseSupply(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
        emit Mint(amount);
    }

    
    function decreaseSupply(uint256 amount) public onlyOwner {
        _burn(msg.sender, amount);
        emit Burn(amount);
    }

}