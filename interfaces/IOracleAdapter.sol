// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracleAdapter {
    function asset() external view returns(address);
    function oracle() external view returns(address);

    function getPrice() external view returns(uint256);
}