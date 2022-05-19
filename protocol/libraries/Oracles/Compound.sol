// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract OracleCompound {

    address private _asset;
    address private _oracle;

    function initOracle(
        address new_asset,
        address new_oracle
    ) internal {
        _asset = new_asset;
        _oracle = new_oracle;
    }

    function asset() public view returns(address) {
        return(_asset);
    }

    function oracle() public view returns(address) {
        return(_oracle);
    }

    function getPrice() public view returns(uint256) {
        return(0);
    }

}