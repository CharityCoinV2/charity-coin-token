// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDonationPool {
    function updatePool (address sender, address token, uint256 amount) external;
}


// DonationPool.sol
contract DonationPool {

    address public owner;

    mapping(address => mapping(address => uint256)) public donations; // tokenAddress => donorAddress => amountDonated
    mapping(address => uint256) public totalDonations; // tokenAddress => totalDonations
    address[] public tokenAddresses; // Array to store token addresses

    event Donation(address indexed donor, address indexed token, uint256 amount);  // Donation Received
    event Transfer(address indexed sender, address indexed recipient, address indexed token, uint256 amount);  // transfered to charity
    event Approval(address indexed admin, address indexed spender, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function isTokenAddressExists(address tokenAddress) internal view returns (bool) {
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            if (tokenAddresses[i] == tokenAddress) {
                return true;
            }
        }
        return false;
    }

    function updatePool (address sender, address token, uint256 amount) external {
        donations[token][sender] += amount;
        totalDonations[token] += amount;

        if (!isTokenAddressExists(token)) {
            tokenAddresses.push(token);
        }

        emit Donation(msg.sender, token, amount);
    }

    function approveSpending(address token, uint256 amount) external onlyOwner {
        // IERC20(token).approve(spender, amount);

        IERC20(token).approve(address(this), amount);

        emit Approval(msg.sender, address(this), amount);
    }

    function transferToCharity(address token, address recipient, uint256 amount) external onlyOwner {

        console.log("DonationPool -> transferToCharity", amount, recipient);

        require(amount > 0, "Amount must be greater than zero");
        require(totalDonations[token] >= amount, "Insufficient balance");

        IERC20(token).transferFrom(address(this), recipient, amount);
        totalDonations[token] -= amount;

        emit Transfer(address(this), recipient, token, amount);
    }

    // function donate(address token, uint256 amount) external {

    //     console.log("DonationPool -> donate", amount);

    //     require(amount > 0, "Amount must be greater than zero");

    //     uint256 allowance = IERC20(token).allowance(msg.sender, address(this));
    //     require(allowance >= amount, "Insufficient allowance");
        
    //     IERC20(token).transferFrom(msg.sender, address(this), amount);
    // }

    function getDonationBalance(address token, address donor) external view returns (uint256) {
        return donations[token][donor];
    }

    function getTotalDonations(address token) external view returns (uint256) {
        return totalDonations[token];
    }

    function getTokenAddresses() external view returns (address[] memory) {
        return tokenAddresses;
    }

    function getTotalDonationsForTokens() external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](tokenAddresses.length);
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            balances[i] = totalDonations[tokenAddresses[i]];
        }
        return balances;
    }
}