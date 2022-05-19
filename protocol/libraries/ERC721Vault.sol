// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// ERC721 with ordinal minting

contract ERC721Vault is ERC721Enumerable {
	using SafeMath for uint256;

	uint256 public count;
	uint256 private collections;

	event CreateVault(address creator, uint256 id);
	event DestroyVault(uint256 id);

    constructor(
		string memory name,
		string memory symbol
	) ERC721(name, symbol) {
		collections = 0;
		_safeMint(msg.sender, collections);

		count  		= 1; //zero vault reserved for protocol
	}

	function _create(address to) internal returns(uint256) {
		uint256 id = count;
		count = count.add(1);

		assert(count > id);
		
		_safeMint(to, id);

		emit CreateVault(to, id);
		return(count);
	}

	function _destroy(uint256 id) internal {
		_burn(id);
		emit DestroyVault(id);
	}

	function _col() internal view returns(uint256) {
		return(collections);
	}
}