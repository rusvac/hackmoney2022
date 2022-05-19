// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IPlug {

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 discount,
        address initiator,
        bytes calldata params
    ) external returns (bool);

}