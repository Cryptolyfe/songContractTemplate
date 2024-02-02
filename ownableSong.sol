// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SongToken is ERC1155, Ownable {
    using SafeMath for uint256;

    uint256 public constant TOTAL_SHARES = 10000; // Total shares for each song

    // Mapping to track the shares owned by each address for a specific song
    mapping(uint256 => mapping(address => uint256)) private _shares;

    // Event emitted when shares are purchased
    event SharesPurchased(address indexed buyer, uint256 indexed songId, uint256 amount);

    // Event emitted when shares are sold
    event SharesSold(address indexed seller, uint256 indexed songId, uint256 amount);

    // Event emitted when the ownership of the song contract is transferred
    event SongOwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 indexed songId);

    // Constructor: Set the URI for token metadata
    constructor() ERC1155("https://api.example.com/api/token/{id}.json") Ownable() {}

    // Function to mint shares for a specific song
    function mintShares(address account, uint256 songId, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(songId < TOTAL_SHARES, "Invalid song ID");

        // Mint shares to the specified account
        _mint(account, songId, amount, "");
        _shares[songId][account] = _shares[songId][account].add(amount);

        // Emit an event for the purchased shares
        emit SharesPurchased(account, songId, amount);
    }

    // Function to sell shares for a specific song
    function sellShares(uint256 songId, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(songId < TOTAL_SHARES, "Invalid song ID");
        require(_shares[songId][msg.sender] >= amount, "Insufficient shares");

        // Burn the sold shares
        _burn(msg.sender, songId, amount);

        // Update the shares mapping
        _shares[songId][msg.sender] = _shares[songId][msg.sender].sub(amount);

        // Emit an event for the sold shares
        emit SharesSold(msg.sender, songId, amount);
    }

    // Function to transfer ownership of the song contract
    function transferSongOwnership(address newOwner, uint256 songId) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        require(newOwner != owner(), "New owner is the current owner");
        require(songId < TOTAL_SHARES, "Invalid song ID");

        // Transfer ownership of the song contract
        transferOwnership(newOwner);

        // Emit an event for the ownership transfer
        emit SongOwnershipTransferred(owner(), newOwner, songId);
    }

    // Function to get the balance of shares for an account and a specific song
    function getSharesBalance(address account, uint256 songId) external view returns (uint256) {
        return _shares[songId][account];
    }
}
