// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/access/Ownable.sol";

contract SoulboundToken is ERC721, Ownable {
    mapping(uint256 => string) private _tokenNames;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // 토큰 이름을 설정하는 함수
    function _setTokenName(uint256 tokenId, string memory tokenName) internal virtual {
        _tokenNames[tokenId] = tokenName;
    }

    // 토큰 이름을 반환하는 함수
    function getTokenName(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: Name query for nonexistent token");
        return _tokenNames[tokenId];
    }

    // Override the transfer functions to prevent transfer of tokens
    function _transfer(address, address, uint256) internal virtual override {
        revert("SBT: transfer of token is not allowed");
    }

    function safeTransferFrom(address, address, uint256) public virtual override {
        revert("SBT: transfer of token is not allowed");
    }

    function safeTransferFrom(address, address, uint256, bytes memory) public virtual override {
        revert("SBT: transfer of token is not allowed");
    }

    function transferFrom(address, address, uint256) public virtual override {
        revert("SBT: transfer of token is not allowed");
    }

    // Mint a new token with name
    function mint(address to, uint256 tokenId, string memory tokenName) public onlyOwner {
        _mint(to, tokenId);
        _setTokenName(tokenId, tokenName);
    }
}
