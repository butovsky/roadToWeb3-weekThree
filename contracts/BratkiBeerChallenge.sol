// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// extension for ERC721 - metadata URI is stored on-chain
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// libraries for safe types
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract BratkiBeerChallenge is ERC721URIStorage {
    using Strings for uint256; // uint256.toString();
    using Counters for Counters.Counter;
    // also, Counter is a type, and we assign functions from Counters library to the vars with such type
    Counters.Counter private _tokenIdCounter;

    uint256 maxStats = 100;

    struct Contestant {
        string name;
        uint256 beerCount; // instead of level
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    mapping(uint256 => Contestant) public tokenIdToContestant;

    address payable owner;

    constructor() ERC721 ("BratkiBeerChallenge", "BBC") {
        owner = payable(msg.sender);
    }

    // generate svg out of base64 encoded string
    function generateCharacter(Contestant memory contestant) public pure returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',contestant.name,'</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Beers: ",contestant.beerCount.toString(),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Life: ",contestant.life.toString(),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',"Strength: ",contestant.strength.toString(),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',"Speed: ",contestant.speed.toString(),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getTokenURI(uint256 tokenId, Contestant memory contestant) public pure returns (string memory) {
        bytes memory dataURI = abi.encodePacked( // dataURI aka metadata itself
        '{',
            '"name": "Bratki Beer Challenge Contestant #', tokenId.toString(), '",',
            '"description": "We wish good luck to ', contestant.name, '!",',
            '"image": "', generateCharacter(contestant), '"',
            // todo in future: set dynamic attributes to this maybe?
        '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function createRandom(uint256 number) internal view returns (uint) {
        return uint256(blockhash((block.number - 1))) % number;
    }

    function mint(string memory _name) public {
        _tokenIdCounter.increment(); // increment first in order for collection to start with 1
        uint256 newItemId = _tokenIdCounter.current();
        _safeMint(msg.sender, newItemId); // openzeppelin inherited mint function
        Contestant memory newContestant = randomizeStats(Contestant({ name: _name, beerCount: 0, speed: 0, life: 0, strength: 0 }));
        tokenIdToContestant[newItemId] = newContestant;
        _setTokenURI(newItemId, getTokenURI(newItemId, newContestant)); // another erc721 function, setting metadata
    }

    function drinkBeer(uint256 tokenId) public {
        require(_exists(tokenId) /* returns bool */, "This token seems to not exist!"); // erc721 function
        require(ownerOf(tokenId) /* returns address */ == msg.sender, "You need to be an owner of this token in order to change this property!"); // another inherited one
        tokenIdToContestant[tokenId].beerCount += 1;
        tokenIdToContestant[tokenId] = randomizeStats(tokenIdToContestant[tokenId]);
        _setTokenURI(tokenId, getTokenURI(tokenId, tokenIdToContestant[tokenId]));
    }

    function randomizeStats(Contestant memory contestant) internal view returns (Contestant memory) {
        // just for fun, random properties

        contestant.life = uint256(blockhash(block.number - 1)) % maxStats;
        contestant.speed = uint256(keccak256(abi.encodePacked(block.timestamp))) % maxStats;
        contestant.strength = uint256(keccak256(abi.encodePacked(block.number))) % maxStats;
        return contestant;
    }
}