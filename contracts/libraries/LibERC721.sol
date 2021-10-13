// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LibAppStorage.sol";

library LibERC721 {
    function _tokenOfOwnerByIndex(address owner, uint256 index) internal view returns (uint256) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        require(index < _balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return s._ownedTokens[owner][index];
    }

    function _balanceOf(address owner) internal view returns (uint256) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        require(owner != address(0), "ERC721: balance query for the zero address");
        return s._balances[owner];
    }

    function _ownerOf(uint256 tokenId) internal view returns (address) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        address owner = s._owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function _tokensOfOwner(address _owner) internal view returns(uint256[] memory ) {
        uint256 tokenCount = _balanceOf(_owner);
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            for (index = 0; index < tokenCount; index++) {
                result[index] = _tokenOfOwnerByIndex(_owner, index);
            }
            return result;
        }
    }

    function isReserved(uint256 tokenId) internal pure returns(uint16){
        uint256 x = (tokenId - 1) % 100;
        uint256 y = (tokenId - 1 - x) / 100;
        if((x < 15 && y < 15)
         || (x > 84 && y < 15)
         || (x < 15 && y > 84)
         || (x > 84 && y > 84)
         || (x > 44 && x < 55 && y > 44 && y < 55)){
            return 1;
        }
        return 0;
    }
}
