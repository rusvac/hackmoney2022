// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./inter/IChainlink.sol";

/*

    Oracle Adapter - Simple (Chainlink)

*/

abstract contract OracleSimple {

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
        (,int256 price,,,) = ChainlinkOracle(_oracle).latestRoundData();
        return(uint256(price));
    }

}