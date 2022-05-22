// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface CompoundToken {
    function underlying() external view returns (address);

    function decimals() external view returns (uint8);
    
	function exchangeRateStored() external view returns (uint256);
}