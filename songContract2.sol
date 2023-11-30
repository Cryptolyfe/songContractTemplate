// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SongToken is ERC1155, Ownable(msg.sender) {
    using SafeMath for uint256;

    uint256 public constant TOKEN_SUPPLY = 100; // Total supply of song tokens

    constructor() ERC1155("https://api.example.com/api/token/{id}.json") {
        _mint(msg.sender, 0, TOKEN_SUPPLY, "");
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, 0, amount, "");
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, 0, amount);
    }
}
