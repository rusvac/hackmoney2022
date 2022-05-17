// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IAdapter {

    function price(
        address asset,
        uint256 amount
    ) external view returns ( 
        uint256 price,
        uint256 decimals
    );


}