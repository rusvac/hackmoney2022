// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../../../interfaces/IERC4626.sol";

import "./inter/IChainlink.sol";

/*

    Oracle Adapter - ERC4626 wrapped Simple (Chainlink)

*/

abstract contract OracleW4626 {
    using SafeMath for uint256;

    address private _asset;
    address private _oracle;
    uint256 private _oracleDecimals;

    function initOracle(
        address new_asset,
        address new_oracle
    ) internal {
        _asset = new_asset;
        _oracle = new_oracle;
        _oracleDecimals = ChainlinkOracle(_oracle).decimals();
    }

    function asset() public view returns(address) {
        return(_asset);
    }

    function oracle() public view returns(address) {
        return(_oracle);
    }

    function getPrice() public view returns(uint256) {
        uint256 sharePrice = IERC4626(_asset).convertToAssets(1);
        (,int256 price,,,) = ChainlinkOracle(_oracle).latestRoundData();
        return(uint256(price).mul(sharePrice));
    }

}