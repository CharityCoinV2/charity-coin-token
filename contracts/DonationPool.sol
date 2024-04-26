// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract DonationPool {
    address public donationPool; // The Donation Pool Address
    address public owner; // The Owner of the Contract
    uint256 public maxDonationAmount; // Maximum donation amount that can be distributed

    mapping(address => uint256) public donationsByToken; // Mapping to track the total amount of each individual coin donated

    event DonationReceived(address indexed donor, address indexed token, uint256); // Event to log donation details

    constructor(address _donationPool) {
        donationPool = _donationPool; // Set the Donation Pool
        owner = msg.sender; // Set the Contract Owner
    }

    // Function to allow anyone to donate ERC20 tokens to the pool
    function donate(address token, uint256 amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        donationsByToken[token] += amount; // Update the total donations for the specific token
        maxDonationAmount = IERC20(token).balanceOf(address(this)) / 10; // 10% of the total balance
        emit DonationReceived(msg.sender, token, amount); // Emit the donation amount
    }

    // Function to allow the contract owner to send the donations to the charity
    function distributeDonations(address charity, address token, uint256 donationAmount) public {
        // Ensure the caller is the owner
        require(msg.sender == owner, "Contract Owner Function Only.");
        require(donationAmount <= IERC20(token).balanceOf(address(this)), "Transfer Amount Exceeds Balance.");
        require(donationAmount <= maxDonationAmount, "Donation Amount Exceeds Maximum Allowed.");
        IERC20(token).transfer(charity, donationAmount);
    }

    // Function to Retrieve Donation Details
    function getDonationDetails(address token) public view returns (uint256) {
        return donationsByToken[token];
    }
}
