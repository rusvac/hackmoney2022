// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./inter/IChainlink.sol";

import "./inter/IYearnVault.sol";

/*

    Oracle Adapter - Yearn Vault (Chainlink)

*/

abstract contract OracleYearn {
    using SafeMath for uint256;

    address private _yvault;
    uint256 public _ydecimals;

    address private _oracle;
    uint256 private _oracleDecimals;
    

    function initOracle(
        address yearnVaultToken,
        address chainLinkOracle
    ) internal {
        _yvault = yearnVaultToken;
        _oracle = chainLinkOracle;
        _oracleDecimals = ChainlinkOracle(_oracle).decimals();

        _ydecimals = uint8(YearnVault(_yvault).decimals());
    }

    function asset() public view returns(address) {
        return(_yvault);
    }

    function oracle() public view returns(address) {
        return(_oracle);
    }

    function getPrice() public view returns(uint256) {
        uint256 sharePrice = YearnVault(_yvault).pricePerShare();
        (,int256 price,,,) = ChainlinkOracle(_oracle).latestRoundData();
        return(uint256(price).mul(sharePrice).div(10**_ydecimals));
    }

}