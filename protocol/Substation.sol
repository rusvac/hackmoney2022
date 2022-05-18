// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../interfaces/IAdapter.sol";

contract Keeper is Ownable {
	using SafeMath for uint256;
	using SafeERC20 for IERC20;

    //      asset       contract
    mapping (address => address) public adapter;

    constructor(

    ) {
        transferOwnership(msg.sender);
    }

    /*

    mapping of oracle addresses

    function to get price, run the oracle through the proper function to read it

    */

    function price(
        address asset,
        uint256 amount
    ) external view returns(uint256) {
        return(
            IAdapter(
                adapter[asset]
            ).price(
                asset,
                amount
            )
        );
    }

    function scale(
		uint256 assets,
		uint256 iassets
	) internal view returns(uint256, uint256) {
		uint256 assetValue = assets.mul(assetPrice());
		uint256 iassetValue = iassets.mul(debtPrice());
		return(assetValue, iassetValue);
	}

}