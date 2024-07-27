# One Piece Personality dApp - Backend

## Overview

The backend of the One Piece Personality dApp is powered by a Solidity smart contract that integrates with the Core Blockchain. This contract enables users to discover their One Piece personality match and mint a unique NFT representing their assigned character. This README details the contract's structure, functionality, and deployment.

## Smart Contract Details

**Contract Name:** OnePieceMint

**License:** MIT

**Solidity Version:** ^0.8.20

**Dependencies:**

- @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
- @openzeppelin/contracts/access/Ownable.sol
- @openzeppelin/contracts/token/ERC721/ERC721.sol

## Key Features

- **Token Counter:** Keeps track of the number of NFTs minted.
- **Character Token URIs:** A list of URIs pointing to the metadata for different One Piece characters.
- **User Mappings:** Tracks which character a user is assigned, if they have minted an NFT, and the token ID of their NFT.
- **Events:** Emits events when an NFT is requested, a character trait is determined, and an NFT is minted.
- **Minting Functionality:** Allows users to mint an NFT representing their One Piece personality match.
- **Randomness:** Utilizes Keccak hashing and `block.prevrandao` to ensure fair and transparent random character assignment.
- **Soulbound Tokens:** Overrides transfer functionality to make tokens non-transferable, ensuring they remain unique to the user.

## Functions

### `mintNFT(address recipient, uint256 characterId)`

Mints a new NFT for the specified recipient with the given character ID.

**Parameters:**
- `recipient`: The address receiving the NFT.
- `characterId`: The ID of the character assigned to the NFT.

**Emits:** `NftMinted(characterId, recipient)`

### `requestNFT(uint256[5] memory answers)`

Allows a user to request an NFT by submitting their answers to the personality quiz.

**Parameters:**
- `answers`: An array of 5 answers from the user's quiz.

**Emits:** `NftRequested(msg.sender)`

### `determineCharacter(uint256[5] memory answers)`

Determines the character ID based on the user's quiz answers.

**Parameters:**
- `answers`: An array of 5 answers from the user's quiz.

**Returns:** `characterId` (the determined character ID)

**Emits:** `CharacterTraitDetermined(characterId)`

### `_getRandomNumber(uint256 seed)`

Generates a random number using Keccak hashing and `block.prevrandao`.

**Parameters:**
- `seed`: A seed value for the random number generation.

**Returns:** A random number.

### `_beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)`

Overrides the transfer functionality to make tokens non-transferable (soulbound).

**Parameters:**
- `from`: The address transferring the token.
- `to`: The address receiving the token.
- `firstTokenId`: The ID of the first token in the transfer batch.
- `batchSize`: The size of the transfer batch.

**Requires:** Tokens can only be transferred to or from the zero address.

### `tokenURI(uint256 tokenId)`

Overrides the default `tokenURI` function to provide the correct metadata URI.

**Parameters:**
- `tokenId`: The ID of the token.

**Returns:** The URI of the token's metadata.

### `supportsInterface(bytes4 interfaceId)`

Overrides the `supportsInterface` function to indicate the supported interfaces.

**Parameters:**
- `interfaceId`: The ID of the interface.

**Returns:** `true` if the interface is supported, `false` otherwise.

### `_burn(uint256 tokenId)`

Overrides the default `_burn` function to handle token burning.

**Parameters:**
- `tokenId`: The ID of the token to be burned.

## Deployment

To deploy the contract, follow these steps:

1. **Install Dependencies:** Ensure you have OpenZeppelin contracts installed.

    ```sh
    npm install @openzeppelin/contracts
    ```

2. **Compile the Contract:** Compile the Solidity code using your preferred tool (e.g., Hardhat, Truffle).

    ```sh
    npx hardhat compile
    ```

3. **Deploy the Contract:** Deploy the contract to the Core Blockchain.

    ```sh
    npx hardhat ignition deploy ./ignition/modules/deploy.js
    ```

## Events

- `NftRequested`: Emitted when a user requests an NFT.
- `CharacterTraitDetermined`: Emitted when a user's character trait is determined.
- `NftMinted`: Emitted when an NFT is minted for a user.

## Security and Best Practices

- Ensure proper access controls with the Ownable contract to restrict certain functions to the contract owner.
- Use `require` statements to validate inputs and prevent unauthorized actions.
- Follow best practices for Solidity development, such as avoiding reentrancy attacks and ensuring proper use of visibility specifiers.

## Future Enhancements

- **Expanded Character Pool:** Add more character URIs to increase the variety of NFTs.
- **Enhanced Randomness:** Explore additional sources of randomness to further improve fairness.
- **Interactivity:** Introduce interactive features allowing users to engage with their NFTs in new ways.




 