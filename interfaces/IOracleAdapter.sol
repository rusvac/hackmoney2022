// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracleAdapter {
    function asset() external view returns(address);
    function oracle() external view returns(address);

    function getPrice() external view returns(uint256);

    function convertAssetToCharge(
        address asset,
        uint256 amount
    ) external view returns(uint256);

    function convertChargeToAsset(
        address asset,
        uint256 amount
    ) external view returns(uint256);
}