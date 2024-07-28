### One Piece Personality dApp Presentation

---

### Introduction to One Piece

- One Piece is an iconic anime series that has captivated fans for over 30 years.
- Known for its rich characters, captivating storylines, and themes of friendship and adventure.
- Beloved worldwide for its engaging and imaginative universe.

---

### Project Overview

- One Piece Personality dApp: A blockchain-based project that blends the world of One Piece with decentralized technology.
- Objective: Allow users to discover their One Piece personality match and mint a unique NFT representing their match.

---

### Innovation

- Unique Concept: Combines the popular One Piece anime with blockchain technology.
- Personality Matching: Users answer a personality quiz to find out which One Piece character they resemble.
- Random Character Assignment: Utilizes Keccak hashing and block.prevrandao for fair and transparent character assignment.

---

### Core Chain Integration

- Blockchain: Built on Core Blockchain.
  - Core Blockchain: Satoshi Plus consensus mechanism combines Delegated Proof of Work (DPoW), Delegated Proof of Stake (DPoS), and Non-custodial Bitcoin Staking.
  - Advantages: Ensures a secure, efficient, and decentralized network with high performance and low fees.
- Smart Contract: Written in Solidity.
  - Compatibility: Ensures compatibility with Ethereum-based applications and other blockchain services.
- Randomness Generation:
  - Keccak Hashing: Provides security through resistance to collision and pre-image attacks.
  - block.prevrandao: Utilizes the randomness beacon from the previous block for decentralized and unbiased randomness.

---

### Backend Functionality

1. Personality Match: Users take a quiz to discover their One Piece personality.
2. Character Assignment: A random One Piece character from the Luffy crew is assigned using cryptographic algorithms and blockchain data.
3. NFT Minting: A unique NFT is minted for the user, representing their assigned character.

### Smart Contract Details

- Contract Name: OnePieceMint
- License: MIT
- Solidity Version: ^0.8.20
- Key Features:
  - Token Counter: Tracks the number of NFTs minted.
  - Character Token URIs: List of URIs pointing to metadata for different One Piece characters.
  - User Mappings: Tracks character assignment, NFT minting status, and token IDs.
  - Events: Emitted for NFT requests, character determination, and NFT minting.
  - Soulbound Tokens: Overrides transfer functionality to make tokens non-transferable.
  - Functions:
    - mintNFT(address recipient, uint256 characterId): Mints a new NFT.
    - requestNFT(uint256[5] memory answers): Requests an NFT by submitting quiz answers.
    - determineCharacter(uint256[5] memory answers): Determines character ID based on quiz answers.
    - _getRandomNumber(uint256 seed): Generates a random number.
    - _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize): Overrides transfer to make tokens non-transferable.
    - tokenURI(uint256 tokenId): Provides metadata URI.
    - supportsInterface(bytes4 interfaceId): Indicates supported interfaces.
    - _burn(uint256 tokenId): Handles token burning.

---

### UI Functionality

1. User Interaction: Users answer a personality quiz through a user-friendly interface.
2. Character Matching: The dApp processes the answers to determine the user's One Piece personality match.
3. NFT Display: Once the NFT is minted, users can view and interact with their unique digital collectible.

---

### Frontend Enhancements

- Subgraph Integration: Utilizes The Graph protocol to fetch data from the blockchain efficiently.
  - Benefits: Real-time updates and efficient querying of blockchain data to enhance user experience.
- Animations and Sounds: Adds an entertaining layer to the user interaction.
  - Sounds: Background music and character-specific sounds to enhance immersion.
  - Animations: Smooth and engaging animations to entertain users during their interaction.

---

### App.js Code Overview
```javascript
import React, { useState, useEffect } from "react";
import "./App.css";
import useSound from 'use-sound';
import { PersonalityForm } from "./components/personalityForm";
import { useWeb3, ConnectWallet } from "./components/connectWallet";
import loadingAnimation from "./loaders/loading.gif";
import bgAudio from "./sounds/bg_sound.mp3";
import logo from "./assets/onepiece_logo.png";
import luffyAudio from "./sounds/luffy.mp3";
import sanjiAudio from "./sounds/sanji.mp3";
import zoroAudio from "./sounds/zoro.mp3";
import usoppAudio from "./sounds/usopp.mp3";
import brookAudio from "./sounds/brook.mp3";
import { ApolloClient, InMemoryCache, gql } from '@apollo/client';

const client = new ApolloClient({
  uri: process.env.REACT_APP_SUBGRAPH_URL,
  cache: new InMemoryCache(),
});

function App() {
  const { web3, nftcontract, account, connectWallet, disconnectWallet, connected } = useWeb3();
  const [showPersonalityForm, setShowPersonalityForm] = useState(false);
  const [loading, setLoading] = useState(true);
  const [answers, setAnswers] = useState([]);
  const [started, setStarted] = useState(false);
  const [Minted, setMinted] = useState(false);
  const [tokenURI, setTokenURI] = useState('');
  const [character, setCharacter] = useState('');

  const [playBgSound, { stop: stopBgSound }] = useSound(bgAudio, { loop: true, volume: 0.2 });
  const [playLuffySound, { stop: stopLuffySound }] = useSound(luffyAudio, { loop: false });
  const [playSanjiSound, { stop: stopSanjiSound }] = useSound(sanjiAudio, { loop: false });
  const [playZoroSound, { stop: stopZoroSound }] = useSound(zoroAudio, { loop: false });
  const [playUsoppSound, { stop: stopUsoppSound }] = useSound(usoppAudio, { loop: false });
  const [playBrookSound, { stop: stopBrookSound }] = useSound(brookAudio, { loop: false });

  useEffect(() => {
    setTimeout(() => {
      setLoading(false);
    }, 2000);
  }, []);

  useEffect(() => {
    if (connected) {
      playBgSound();
      checkMinted();
    } else {
      stopBgSound();
    }
  }, [connected]);

  const checkMinted = async () => {
    setLoading(true);
    const bool = await nftcontract.methods.hasMinted(account).call();
    if (bool) {
      setMinted(true);
      fetchURI();
      setShowPersonalityForm(false);
    } else {
      setMinted(false);
      setShowPersonalityForm(true);
    }
    setLoading(false);
  };

  const checkMintedEvent = async (minter) => {
    const query = gql`
      query GetNftMintedEvent($minter: Bytes!) {
        nftMinteds(where: { minter: $minter }) {
          id
          characterId
          minter
          blockNumber
          blockTimestamp
          transactionHash
        }
      }
    `;

    const variables = { minter };

    let timedOut = false;
    const timeout = setTimeout(() => {
      timedOut = true;
      console.log('Timeout occurred after 60 seconds.');
    }, 60000);

    const checkEvent = async () => {
      try {
        const result = await client.query({ query, variables });
        const nftMinted = result.data.nftMinteds[0];
        if (nftMinted) {
          console.log('NFT minted successfully');
          clearTimeout(timeout);
          checkMinted();
        } else if (!timedOut) {
          setTimeout(checkEvent, 3000);
        }
      } catch (error) {
        console.error("Error querying the subgraph:", error);
        setLoading(false);
      }
    };

    setTimeout(checkEvent, 4000);
  };

  const fetchURI = async () => {
    setLoading(true);
    const tokenID = await nftcontract.methods.userTokenID(account).call();
    const metadataIpfsLink = await nftcontract.methods.tokenURI(tokenID).call();
    const response = await fetch(metadataIpfsLink);
    const metadata = await response.json();
    getCharacter(metadata);
    console.log(metadata.image);
    setTokenURI(metadata.image);
    setLoading(false);
  };

  const handleStart = () => {
    setStarted(true);
    setAnswers([]);
    console.log('Start Array', JSON.stringify(answers));
    if (connected) {
      checkMinted();
    } else {
      connectWallet();
    }
  };

  const getCharacter = (metadata) => {
    setCharacter(metadata.name);
    switch (metadata.name) {
      case "Monkey D. Luffy":
        playLuffySound();
        break;
      case "Roronoa Zoro":
        playZoroSound();
        break;
      case "Sanji":
        playSanjiSound();
        break;
      case "Brook":
        playBrookSound();
        break;
      case "Usopp":
        playUsoppSound();
        break;
      default:
        break;
    }
  };

  const handleDisconnect = () => {
    disconnectWallet();
    setStarted(false);
    setLoading(false);
    setTokenURI('');
  };

  const handleConnect = () => {
    connectWallet();
    setStarted(true

);
  };

  const handleAnswerSubmit = (answer) => {
    console.log('Received answer:', answer);
    setAnswers(prevAnswers => {
      const newAnswers = [...prevAnswers, answer];
      console.log('Current Array:', JSON.stringify(newAnswers));
      return newAnswers;
    });
  };
  const handleFormSubmit = async (answers) => {
    try {
      const gasPrice = await web3.eth.getGasPrice();
      await nftcontract.methods.requestNFT(answers)
        .send({ from: account, gasPrice })
        .on("transactionHash", (hash) => {
          console.log("Transaction sent. Transaction hash:", hash);
          setLoading(true);
        })
        .on("receipt", (receipt) => {
          console.log("Transaction successful:", receipt.transactionHash);
          checkMintedEvent(account);
        })
        .on("error", (error) => {
          console.error("Error requesting NFT:", error);
          setLoading(false);
        });
      setShowPersonalityForm(false);
    } catch (error) {
      console.error("Error during form submission:", error);
    }
  };

  return (
    <ConnectWallet>
      <div className="App">
        <div className="top-right-buttons">
          {started ? (
            connected ? (
              <button onClick={handleDisconnect}>Disconnect</button>
            ) : (
              <button onClick={handleConnect}>Connect</button>
            )
          ) : null}
        </div>
        <div className="content-container">
          {loading ? (
            <img src={loadingAnimation} alt="Loading..." />
          ) : (
            <>
              {!started ? (
                <div className="start-container">
                  <img className="logo" src={logo} alt="logo" />
                  <button className="start-button" onClick={handleStart}>Enter Grand Line</button>
                </div>
              ) : (
                <>
                  {Minted ? (
                    <div className="character-container">
                      <div className="character-image-container">
                        <img className="character-image" src={tokenURI} alt="NFT" />
                      </div>
                      <h3 className="character-name">{character}</h3>
                    </div>
                  ) : showPersonalityForm ? (
                    <PersonalityForm onSubmit={handleAnswerSubmit} showForm={setShowPersonalityForm} />
                  ) : (
                    <div className="reveal-personality">
                      <button className="reveal-button" onClick={() => handleFormSubmit(answers)}>
                        Reveal My Pirate Personality
                      </button>
                    </div>
                  )}
                </>
              )}
            </>
          )}
        </div>
      </div>
    </ConnectWallet>
  );
}

export default App;
```
---

### Future Development

- Expanded Character Pool: Add more One Piece characters to increase variety.
- New Features: Introduce personality-based interactions and character-specific abilities.
- Official Partnerships: Collaborate with the One Piece community and creators.
- Anime GamaFi: Evolve into a full-fledged anime gaming platform where users can play, earn points and token rewards, mint and even trade NFTs while enjoying the beauty and unique features of Core Blockchain.

---

### Join the Adventure!

- Participate: Discover your One Piece personality match and mint your unique NFT.
- Community: Engage with fellow One Piece fans and become part of this exciting blockchain experience.

---

### Core BTCFi Hackathon Submission

Key Points:

1. Innovation:
   - Unique concept combining One Piece with blockchain.
   - Blockchain integration leveraging Core Blockchain's features.

2. Technical Prowess:
   - Smart contracts written in Solidity.
   - Advanced cryptographic techniques for fair and transparent character assignment.

3. User Engagement:
   - Unique NFTs representing One Piece personality matches.
   - Community features fostering engagement and interaction.

4. Contribution to Core BTCFi Ecosystem:
   - Showcasing Core Blockchain's capabilities.
   - Adding an engaging application to the Core BTCFi ecosystem.

---

Thank you for your attention!
