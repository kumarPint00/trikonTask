//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "./NFT.sol";
import "./TestToken.sol";

contract Marketplace {
    NFT public nft;
    TestToken public erc20;
   //keep the record for tokenID is listed on sale or not
    mapping(uint256 => bool) public tokenIdForSale;
    
    
    
    //keep the address of the nft buyer
    mapping(uint256 => address) public nftBuyers;
    constructor(address _nftAddress, address _erc20Address) {
        nft = NFT(_nftAddress);
        erc20 = TestToken(_erc20Address);
    }

      function buyNFT(uint256 _tokenId) public payable {
        require(msg.value >= nft.tokenPrice(_tokenId));
        address _seller = nft.ownerOf(_tokenId);
        nft.transferFrom(_seller, msg.sender, _tokenId);
        erc20.transfer(_seller, msg.value);
    }

    function sellNFT(uint256 _tokenId, address buyer) public {
        require(nft.ownerOf(_tokenId) == msg.sender);
        // uint256 _price = nft.tokenPrice(_tokenId);
        nft.transferFrom(address(this),buyer, _tokenId);

    }
}