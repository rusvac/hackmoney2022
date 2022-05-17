// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Battery is ERC721 {
	using SafeERC20 for IERC20;
    using SafeMath for uint256;
    
    address public keeper;

    modifier onlyOwner(
        uint256 id
    ) {
        require(ownerOf(id) == msg.sender, "");
        _;
    }

    constructor(
        address _keeper
    ) ERC721("Recharging Borrowing Power", "BATTERY") {
        keeper = _keeper;
    }
    

    /*

    accept ASSET, increasing limit

    remove asset, decreasing limit

    allow borrowing of CHRG, increasing hold

    repaying CHRG, decreasing hold



    resolve hold function

    */

    function deposit(
        uint256 id
    ) external onlyOwner(id) {

    }

    function withdraw(
        uint256 id
    ) external onlyOwner(id) {
        
    }

    function redeem(
        uint256 id
    ) external onlyOwner(id) {
        //claim all available charges
    }



    function resolve(
        uint256 toResolve
    ) external {
        
    }
}