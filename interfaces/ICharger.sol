// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICharger {

    function locked(uint256 id) external view returns(uint256);
    function hold(uint256 id) external view returns(uint256);

}