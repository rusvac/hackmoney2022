// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Keeper is Ownable {

    mapping (address => address) public registry;

    constructor(

    ) {
        transferOwnership(msg.sender);
    }

    /*

    mapping of oracle addresses

    function to get price, run the oracle through the proper function to read it

    */

}