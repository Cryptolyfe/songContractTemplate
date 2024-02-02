// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// Import the SongToken contract
import "./SongToken.sol";

contract SongTokenFactory is Ownable {
    // Event emitted when a new SongToken contract is created
    event SongTokenCreated(address indexed songTokenAddress, address indexed creator);

    // Address of the SongToken contract template
    address public songTokenTemplate;

    // Mapping to track deployed SongToken contracts
    mapping(address => bool) public isSongToken;

    // Constructor: Set the SongToken template address
    constructor(address _songTokenTemplate) {
        songTokenTemplate = _songTokenTemplate;
    }

    // Function to create a new SongToken contract
    function createSongToken() external onlyOwner returns (address) {
        // Deploy a new SongToken contract
        SongToken newSongToken = new SongToken();

        // Mark the contract as created
        isSongToken[address(newSongToken)] = true;

        // Transfer ownership of the new SongToken contract to the factory owner
        newSongToken.transferOwnership(owner());

        // Emit an event for the created SongToken contract
        emit SongTokenCreated(address(newSongToken), msg.sender);

        return address(newSongToken);
    }

    // Function to mint tokens for a specific SongToken contract
    function mintSongToken(address songTokenAddress, address account, uint256 amount) external onlyOwner {
        // Ensure that the provided address is a valid SongToken contract
        require(isSongToken[songTokenAddress], "Invalid SongToken address");

        // Mint tokens in the specified SongToken contract
        SongToken(songTokenAddress).mint(account, amount);
    }

    // Function to burn tokens for a specific SongToken contract
    function burnSongToken(address songTokenAddress, address account, uint256 amount) external onlyOwner {
        // Ensure that the provided address is a valid SongToken contract
        require(isSongToken[songTokenAddress], "Invalid SongToken address");

        // Burn tokens in the specified SongToken contract
        SongToken(songTokenAddress).burn(account, amount);
    }
}

