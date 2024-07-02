// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/access/Ownable.sol";

contract SoulboundToken is ERC721, Ownable {
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        if (bytes(base).length == 0) {
            return _tokenURI;
        }

        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
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

    // Mint a new token with CID
    function mint(address to, uint256 tokenId, string memory cid) public onlyOwner {
        _mint(to, tokenId);
        string memory uri = string(abi.encodePacked("https://", cid, ".ipfs.w3s.link"));
        _setTokenURI(tokenId, uri);
    }
}
