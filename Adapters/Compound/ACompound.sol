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

    function description() external view returns(string memory) {
        return("Battery x Compound Adapter");
    }
    
    function version() external view returns (uint256) {
        return(1);
    }

    function decimals() external view returns(uint8) {
        return(8);
    }

    function price() external view returns(uint256) {

    }
}