// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICharger {

    function asset() external view returns(address asset);

    function minimumRatio() external view returns(uint256);
    function maximumRatio() external view returns(uint256);

    function locked(uint256 id) external view returns(uint256);
    function hold(uint256 id) external view returns(uint256);

    function totalLocked() external view returns(uint256);

    function health(uint256 a, uint256 c) external view returns(uint256);

    function count() external returns(uint256);

    function createCharger() external returns(uint256);

    function destroy(
        uint256 id,
        bool empty
    ) external;

    function deposit(
        uint256 id,
        uint256 amount
    ) external;
    
    function withdraw(
        uint256 id,
        uint256 amount
    ) external;

    function approveBattery() external;
    function imposeOperationFee(uint256 id) external returns(bool);
}