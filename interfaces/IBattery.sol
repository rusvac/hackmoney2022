// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBattery {

    function peg() external view returns(uint256);

    function getHold(address locker, uint256 id) external view returns(uint256 amount);

    function recharge() external;

    function resolveHold() external;
    
    function flashResolve(address receiverAddress, uint256 batteryID) external;

}