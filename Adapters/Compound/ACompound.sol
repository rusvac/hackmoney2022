// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./Oracle.sol";

contract BA_Compound is
    Ownable,
    BA_OracleCompound
    {

    constructor() {

    }

    function decimals() external view returns(uint8)
    function description() external view returns(uint8)
    function getRoundData() external view returns(uint8)
    function latestRoundData() external view returns(uint8)
    function version() external view returns (uint256)
}