// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract CharityCoin is ERC20, ERC20Permit, ERC20Votes {
    uint256 public maxTransactionAmount;
    address public donationPool;

    constructor() ERC20("CharityCoin", "GIFT") ERC20Permit("CharityCoin") {
        uint256 totalSupply = 100000000 * 10 ** decimals();
        _mint(msg.sender, totalSupply);
        maxTransactionAmount = totalSupply / 20; // Set the max transaction amount to 5% of the total supply
    }

// Need to Override transfer methods to take into account Governance... 

    function setDonationPool(address _donationPool) public {
        require(donationPool == address(0), "Donation pool already set.");
        donationPool = _donationPool; // Set the charity pool address
    }

// Need to Add maxTransactionAmount Checks to the Approval/approve functions... 
// increaseAllowance... and decreaseAllowance functions... 

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (donationPool != address(0)) { // check if donation is false
            require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount.");

            uint256 donationFee = amount / 100; // Take 1% of the transaction as the donation fee
            super.transfer(donationPool, donationFee); // Send the donation fee to the donation pool

            uint256 transferAmount = amount - donationFee;
            return super.transfer(recipient, transferAmount);
        } 
        else {
            return super.transfer(recipient, amount);
        }
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) { // Need to Apply donationFee to transferFrom
        if (donationPool != address(0)) {
            require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount.");

            uint256 donationFee = amount / 100; // Take 1% of the transaction as the donation fee
            super.transferFrom(sender, donationPool, donationFee); // Send the donation fee to the donation pool

            uint256 transferAmount = amount - donationFee;
            return super.transferFrom(sender, recipient, transferAmount);
        }
        else {
            return super.transferFrom(sender, recipient, amount);
        }
    }
}