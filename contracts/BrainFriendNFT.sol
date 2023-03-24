// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BrainFriendNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint public MAX_SUPPLY = 20000;

    constructor() ERC721("BrainFriendNFT", "BFD") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://api.brainfried.xyz/tokens";
    }

    function safeMint(address to) public payable {
        require(totalSupply() < MAX_SUPPLY, "I have too many friends");
        require(balanceOf(to) == 0, "We are already friends");
        //require(msg.value > 0, "Don't be cheap.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Nothing to withdraw.");
        payable(owner()).transfer(address(this).balance);
    }

    //
    function mintMultipleNFTs(uint256 amount) public onlyOwner {
        uint256 tokenId;
        for (uint i; i < amount; ) {
            tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);

            unchecked {
                i++;
            }
        }
    }
}
