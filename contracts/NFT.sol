//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFT is ERC721 {
    
    string public MyNFT;
    string public Symbol;
    string public TokenURI;
    uint256 public Id;
    //Keep the record of  NFTs
    mapping(uint256 => string) public tokenURIExists;
    mapping(uint => address) public tokenIdToOwner;
    
    
    //Keep the record for NFTs value => give id returns cost 
    mapping(uint256 => uint256) public tokenIdToValue;
    

    
    // Base URI
    string  _baseURIextended;
    
    constructor () ERC721("TestNFT", "TNFT") {
        MyNFT = "TestNFT";
        Symbol = "TNFT";
    
    }
    
    
    
    function setBaseURI(string memory baseURI_) external  {
        _baseURIextended = baseURI_;
    }
    
    
    
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require( _exists(tokenId),"ERC721Metadata: URI set of nonexistent token");
        tokenURIExists[tokenId] = _tokenURI;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }
    
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

            string memory _tokenURI = tokenURIExists[tokenId];
            string memory base = _baseURI();
            
            // If there is no base URI, return the token URI.
            if (bytes(base).length == 0) {
                return _tokenURI;
            }
            // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
            if (bytes(_tokenURI).length > 0) {
                return string(abi.encodePacked(base, _tokenURI));
            }
            // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
            // return string(abi.encodePacked(base, tokenId.toString()));
            return string(abi.encodePacked(base, tokenId));
    }
        
  
    function Mint (string memory _tokenURI, uint256 _Price) public returns (uint256)  {
        require(msg.sender != address(0));
        TokenURI = _tokenURI;
        // used as token id 
        Id ++;
        // check if a token exists with the above token id => incremented counter
        require(!_exists(Id));
        tokenIdToValue[Id] = _Price;
        _mint(msg.sender,Id);
        _setTokenURI(Id, TokenURI);
        
        return Id;
        
    }
    // event safeTransfer(msg.sender, to, tokenId);
    //   function transfer(address from, address to, uint256 tokenId) public {
    //     safeTransfer(from, to, tokenId);
    // }
    function ownerOf(uint _tokenId)override public view    returns (address owner) {
        return address(tokenIdToOwner[_tokenId]);
    }
    function getOwner(uint _tokenId) public view returns (address) {
        return address(tokenIdToOwner[_tokenId]);
    }    
    function tokenPrice (uint256 _tokenID) public view returns (uint256 Price) {
        require(!_exists(Id));
        Price = tokenIdToValue[_tokenID]; 
    } 
    
    
}