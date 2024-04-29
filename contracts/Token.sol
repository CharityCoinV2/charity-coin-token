// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CharityCoin is ERC20 {
    uint256 public maxTransactionAmount;
    address public immutable donationPool; // Donation pool address is immutable

    constructor(address _donationPool) ERC20("CharityCoin", "GIVE") {
        require(_donationPool != address(0), "Donation Pool cannot be zero address.");
        donationPool = _donationPool; // Set at construction and immutable

        uint256 totalSupply = 100000000 * 10 ** decimals(); // NEED TO FINALIZE totalSupply
        _mint(msg.sender, totalSupply); // Mint totalSupply ONE TIME
        
        uint256 initialDonation = totalSupply * 10 / 100; // NEED TO FINALIZE initialDonation Amount...
        _transfer(msg.sender, donationPool, initialDonation); // Seed the donation pool on mint

        maxTransactionAmount = totalSupply / 20; // Set a maxTransactionAmount of 5%
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount.");
        uint256 donationFee = amount / 100;
        _transfer(msg.sender, donationPool, donationFee);
        return super.transfer(recipient, amount - donationFee);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount.");
        uint256 donationFee = amount / 100;
        _transfer(sender, donationPool, donationFee);
        return super.transferFrom(sender, recipient, amount - donationFee);
    }
}