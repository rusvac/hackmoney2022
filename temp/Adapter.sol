// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "../interfaces/IAdapter.sol";

contract Adapter is 
    Ownable,
    IAdapter
    {
	using SafeMath for uint256;

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

    // PUBLIC FACING SUBSTATION FUNCTIONS

    function getRealPrice(
        address asset
    ) external view returns(uint256 amount) {
        return(
            IAdapter(
                adapter[asset]
            ).price(
                asset,
                amount
            )
        );
    }

    //rounded downward
    function convertAssetToCharge() public {

    }

    //rounded upward
    function convertChargeToAsset() public {

    }

}