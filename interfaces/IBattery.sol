// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBattery {

    function getHold(address asset, uint256 locker) external view returns(uint256 amount);
    
    function flashResolve(address receiverAddress, uint256 batteryID) external;

    function claimCharge() external;

}