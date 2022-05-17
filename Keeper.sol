// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./Adapters/IAdapter.sol";

contract Keeper is Ownable {

    //      asset       contract
    mapping (address => address) public registry;
    mapping (address => address) public adapter;

    constructor(

    ) {
        transferOwnership(msg.sender);
    }

    /*

    mapping of oracle addresses

    function to get price, run the oracle through the proper function to read it

    */

    function price(
        address asset,
        uint256 amount
    ) external view returns(uint256) {
        return(
            IAdapter(
                adapter[asset]
            ).price(
                asset,
                amount
            )
        );
    }

}