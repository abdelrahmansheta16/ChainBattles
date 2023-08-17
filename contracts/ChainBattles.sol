// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

// import {VRFV2WrapperConsumerBase} from "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

//ChainBattles uploaded at 0x6b1842C6786e626eA1cd213ee6000f90F9F77A11
contract ChainBattles is ERC721URIStorage {
    // event RandomNumber(uint number);
    // event TrackerEvent(Tracker tracker);
    // address constant LINK_ADDRESS = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    // address constant LINK_WRAPPER_ADDRESS =
    //     0xab18414CD93297B0d12ac29E63Ca20f515b3DB46;
    uint256 private lastRandomnessRequestId;
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Tracker {
        uint256 levels;
        uint256 hp;
        uint256 strength;
        uint256 speed;
        // Add more fields as needed
    }

    mapping(uint256 => Tracker) public tokenIdToLevels;

    constructor()
        ERC721("Chain Battles", "CBTLS")
    // VRFV2WrapperConsumerBase(LINK_ADDRESS, LINK_WRAPPER_ADDRESS)
    {

    }

    // function fulfillRandomWords(
    //     uint256 requestId,
    //     uint256[] memory randomWords
    // ) internal override {
    //     require(lastRandomnessRequestId == requestId);
    //     uint256 randomNumber = randomWords[0];
    //     emit RandomNumber(randomNumber);
    //     uint256 newItemId = _tokenIds.current();
    //     tokenIdToLevels[newItemId].hp = randomNumber % 100;
    //     tokenIdToLevels[newItemId].levels = randomNumber % 70;
    //     tokenIdToLevels[newItemId].speed = randomNumber % 50;
    //     tokenIdToLevels[newItemId].strength = randomNumber % 20;
    //     emit TrackerEvent(tokenIdToLevels[newItemId]);
    //     _setTokenURI(newItemId, getTokenURI(newItemId));
    //     lastRandomnessRequestId = 0;
    // }

    function generateCharacter(
        uint256 tokenId
    ) public view returns (string memory) {
        Tracker memory tracker = tokenIdToLevels[tokenId];
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            tracker.levels.toString(),
            "</text>",
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Hp: ",
            tracker.hp.toString(),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            tracker.strength.toString(),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            tracker.speed.toString(),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getTracker(uint256 tokenId) public view returns (Tracker memory) {
        Tracker memory tracker = tokenIdToLevels[tokenId];
        return tracker;
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        uint256 newItemId = _tokenIds.current();
        uint256 randomNumber = block.prevrandao;
        tokenIdToLevels[newItemId].hp = randomNumber % 100;
        tokenIdToLevels[newItemId].levels = randomNumber % 70;
        tokenIdToLevels[newItemId].speed = randomNumber % 50;
        tokenIdToLevels[newItemId].strength = randomNumber % 20;
        console.log("tracker levels: %d", tokenIdToLevels[newItemId].levels);
        // emit TrackerEvent(tokenIdToLevels[newItemId]);
        _setTokenURI(newItemId, getTokenURI(newItemId));
        // lastRandomnessRequestId = requestRandomness(100000, 3, 1);
    }
}
