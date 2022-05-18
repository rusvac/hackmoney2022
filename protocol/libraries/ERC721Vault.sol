// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// ERC721 with ordinal minting

contract ERC721Vault is ERC721Enumerable {
	using SafeMath for uint256;

	uint256 public vaultCount;
	
	event CreateVault(address creator, uint256 id);
	event DestroyVault(uint256 id);

    constructor(
		string memory name,
		string memory symbol
	) ERC721(name, symbol) {
		vaultCount = 0; //zero vault reserved for protocol
		_safeMint(msg.sender, vaultCount);
	}

	function _create(address to) internal returns(uint256) {
		uint256 id = vaultCount.add(1);
		
		_safeMint(to, id);
		vaultCount = id;

		emit CreateVault(to, id);
		return(id);
	}

	function _destroy(uint256 id) internal {
		_burn(id);
		emit DestroyVault(id);
	}
}