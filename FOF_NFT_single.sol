// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FablesOfFyra is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    string private _tokenBaseURI = "";
    
    Counters.Counter internal _publicCounter;

    constructor() ERC721("Fables of Fyra", "FOFNFT") {}

    function restoreCollection(address _orgContract, uint256 _count) external onlyOwner {
        for (uint256 i = 0; i < _count; i++) {
            _publicCounter.increment();
            address _receiver = IERC721(_orgContract).ownerOf(_publicCounter.current());
            _mint(_receiver, _publicCounter.current());
        }
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _tokenBaseURI = baseURI;
    }

    function airdrop(address[] memory airdropAddress, uint256 numberOfTokens) external onlyOwner {
        for (uint256 k = 0; k < airdropAddress.length; k++) {
            for (uint256 i = 0; i < numberOfTokens; i++) {
                uint256 tokenId = _publicCounter.current();
                _publicCounter.increment();
                if (!_exists(tokenId)) _safeMint(airdropAddress[k], tokenId);
            }
        }
    }

    function airdropSpecial(address to, uint256 tokenId) external onlyOwner {
        require(!_exists(tokenId), "Token already exist");
        if (!_exists(tokenId)) _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
