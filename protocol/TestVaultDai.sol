// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import "../ERC4626/ERC4626.sol";

contract TestVaultDai is Ownable, ERC4626 {

    event NewOwner(address owner);

    address public vaultAsset;

    constructor(
        address _asset
    ) ERC4626(
        IERC20Metadata(_asset)
    ) ERC20(
        "Test Vault Dai", "TvDai"
    ) {
        vaultAsset = _asset;
        transferOwnership(msg.sender);
    }

    function setNewOwner(
        address newOwner
    ) external onlyOwner {
        transferOwnership(newOwner);
        emit NewOwner(newOwner);
    }

}