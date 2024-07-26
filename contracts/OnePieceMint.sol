// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OnePieceMint is ERC721, Ownable, ERC721URIStorage {
    uint256 private s_tokenCounter;

    string[] internal characterTokenURIs = [
        "https://scarlet-live-iguana-759.mypinata.cloud/ipfs/QmNp4sHf4ccqPpqMBUCSG1CpFwFR4D6kgHesxc1mLs75am",
        "https://scarlet-live-iguana-759.mypinata.cloud/ipfs/QmPHaFt55PeidgCuXe2kaeRYmLaBUPE1Y7Kg4tDyzapZHy",
        "https://scarlet-live-iguana-759.mypinata.cloud/ipfs/QmP9pC9JuUpKcnjUk8GBXEWVTGvK3FTjXL91Q3MJ2rhA16",
        "https://scarlet-live-iguana-759.mypinata.cloud/ipfs/QmSnNXo5hxrFnpbyBeb7jY7jhkm5eyknaCXtr8muk31AHK",
        "https://scarlet-live-iguana-759.mypinata.cloud/ipfs/QmarkkgDuBUcnqksatPzU8uNS4o6LTbEtuK43P7Jyth9NH"
    ];

    mapping(address => uint256) private userCharacter;
    mapping(address => bool) public hasMinted; // a mapping to track if an address has already minted an NFT
    mapping(address => uint256) public s_addressToCharacter; // a mapping to map address to the character they got
    mapping(address => uint256) public userTokenID;

    event NftRequested(address requester);
    event CharacterTraitDetermined(uint256 characterId);
    event NftMinted(uint256 characterId, address minter);

    constructor() ERC721("OnePiece NFT", "OPN") {}

    // Function to mint NFT according to the character id
    function mintNFT(address recipient, uint256 characterId) internal {
        require(!hasMinted[recipient], "You have already minted your house NFT"); // Ensure the address has not minted before

        uint256 tokenId = s_tokenCounter;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, characterTokenURIs[characterId]);

        s_addressToCharacter[recipient] = characterId; // map character to address
        userTokenID[recipient] = tokenId;

        s_tokenCounter += 1;
        hasMinted[recipient] = true; // Mark the address as having minted an NFT

        emit NftMinted(characterId, recipient);
    }

    function requestNFT(uint256[5] memory answers) public {
        userCharacter[msg.sender] = determineCharacter(answers);

        uint256 randomValue = _getRandomNumber(s_tokenCounter);
        uint256 randomCharacterId = (randomValue % 5); // random number between 0 and 4
        uint256 finalCharacterId = (userCharacter[msg.sender] + randomCharacterId) % 5; // final ID will be between 0 and 4

        mintNFT(msg.sender, finalCharacterId);

        emit NftRequested(msg.sender);
    }

    function determineCharacter(uint256[5] memory answers) private returns (uint256) {
        uint256 characterId = 0;
        for (uint256 i = 0; i < 5; i++) {
            characterId += answers[i];
        }
        characterId = (characterId % 5); // Changed to modulo 5 to match zero-based indexing
        emit CharacterTraitDetermined(characterId);
        return characterId;
    }

    // Custom randomness function
 function _getRandomNumber(uint256 seed) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, block.timestamp, block.prevrandao, msg.sender)));
    }

    // Override the transfer functionality of ERC721 to make it soulbound
    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual override {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);

        require(from == address(0) || to == address(0), "Err! This is not allowed");
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
}
