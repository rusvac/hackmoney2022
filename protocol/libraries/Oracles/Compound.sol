// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./inter/IChainlink.sol";

import "./inter/ICToken.sol";

/*

    Oracle Adapter - cToken wrapped Simple (Chainlink)

*/

abstract contract OracleCompound {
    using SafeMath for uint256;

    address private _asset;
    address private _oracle;
    uint256 private _oracleDecimals;
    uint256 private _decimalOffset;

    function initOracle(
        address new_asset,
        address new_oracle
    ) internal {
        _asset = new_asset;
        _oracle = new_oracle;
        _oracleDecimals = CompoundToken(_oracle).decimals();

        uint256 assetDecimal = CompoundToken(
                CompoundToken(_asset).underlying()
            ).decimals();

        _decimalOffset = assetDecimal.sub(8);

        _decimalOffset = 10**(_decimalOffset);
    }

    function asset() public view returns(address) {
        return(_asset);
    }

    function oracle() public view returns(address) {
        return(_oracle);
    }

    function getPrice() public view returns(uint256) {
        //asset / USD price
        (,int256 price,,,) = ChainlinkOracle(_oracle).latestRoundData();

        //cToken / asset price
        uint256 rate = CompoundToken(_asset).exchangeRateStored();

        uint256 sharePrice = rate.div(_decimalOffset);

        uint256 realPrice = uint256(price).mul(sharePrice);
        //cToken / USD price
        return(realPrice);
    }

}