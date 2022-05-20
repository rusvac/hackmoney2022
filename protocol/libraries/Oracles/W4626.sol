// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Oracle {
    function decimals() external view returns (uint8);

	function latestRoundData() external view returns (
		uint80 roundId,
		int256 answer,
		uint256 startedAt,
		uint256 updatedAt,
		uint80 answeredInRound
	);
}

/*

    Oracle Adapter - ERC4626 wrapped Simple (Chainlink)

*/

abstract contract OracleW4626 {

    address private _asset;
    address private _oracle;
    uint256 private _oracleDecimals;

    function initOracle(
        address new_asset,
        address new_oracle
    ) internal {
        _asset = new_asset;
        _oracle = new_oracle;
        _oracleDecimals = Oracle(_oracle).decimals();
    }

    function asset() public view returns(address) {
        return(_asset);
    }

    function oracle() public view returns(address) {
        return(_oracle);
    }

    function getPrice() public view returns(uint256) {
        (,int256 price,,,) = Oracle(_oracle).latestRoundData();
        return(uint256(price));
    }

}