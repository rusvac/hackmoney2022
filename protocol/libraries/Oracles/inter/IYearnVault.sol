// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface YearnVault {

    function decimals() external view returns (uint256);
    
    function underlying() external view returns (address);

    function pricePerShare() external view returns (uint256);



    // i wonder how the end point will look
    function creditPerShare() external view returns (uint256);

}
