
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";



//Contract Deployed to 0xE0a9f0E35e41491aE471BD637E8aC945fbbeDa49
//Don't forgot to refrest metadata on OpeanSea
contract ChainBattles is ERC721URIStorage{
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    struct character{
        uint256 levels;
        uint256 hp;
        uint256 strength;
    }
    
    mapping (uint256 => character) public tokenIdtoLevels;

    event TokenMinted(uint TokenId , address owneris);

    constructor() ERC721('Chain Battles','CBTLS'){}
    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
     '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '<text x="50%" y="55%" class="base" dominant-baseline="middle" text-anchor="middle">', "Hp: ",getHp(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '</svg>'
        );
        return string(abi.encodePacked("data:image/svg+xml;base64,",Base64.encode(svg)
        )
        );
    }

    function getLevels(uint256 tokenId) public view returns (string memory){
       uint Level = tokenIdtoLevels[tokenId].levels ;
        return Level.toString();
    }
    function getHp(uint256 tokenId) public view returns (string memory){
      uint Hp = tokenIdtoLevels[tokenId].hp ;
        return Hp.toString();
    }
    function getStrength(uint256 tokenId) public view returns (string memory){
        uint Strength = tokenIdtoLevels[tokenId].strength;
        return Strength.toString();
    }
    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
    function mint()public{
        _tokenIds.increment() ;
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender,newItemId);
        character memory warrior = character(1,10,100);
        tokenIdtoLevels[newItemId] = warrior ;
        _setTokenURI(newItemId,getTokenURI(newItemId));
        emit TokenMinted(newItemId, msg.sender);
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId),"Please use existing Token");
        require(ownerOf(tokenId)== msg.sender, "You Must own this token to train it");
            uint currentLevel = tokenIdtoLevels[tokenId].levels ;
            uint currentStrength = tokenIdtoLevels[tokenId].strength ;
            uint currentHp = tokenIdtoLevels[tokenId].hp  ;
        tokenIdtoLevels[tokenId].levels = currentLevel + 1;
        tokenIdtoLevels[tokenId].hp = currentHp + currentStrength + 100*currentLevel;
        tokenIdtoLevels[tokenId].strength = currentStrength + currentLevel*5 +55; 
        _setTokenURI(tokenId,getTokenURI(tokenId));
    }

     

}