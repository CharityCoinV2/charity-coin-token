
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract DonationPool {
    address public admin;
    mapping(address => uint256) public tokenBalances;  // Tracks token balances

    event DonationReceived(address token, uint256 amount);
    event TokensTransferred(address token, address to, uint256 amount);

    constructor() {
        admin = msg.sender; // Set the creator of the contract as the admin
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    // Function to accept donations
    function donateTokens(address tokenAddr, uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero.");
        IERC20 token = IERC20(tokenAddr);
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer from failed. Check allowance and balance.");
        tokenBalances[tokenAddr] += amount;  // Update the balance
        emit DonationReceived(tokenAddr, amount);
    }

    // Function to transfer tokens to any address
    function transferTokens(address tokenAddr, address to, uint256 amount) public {
        require(msg.sender == admin, "Only admin can transfer tokens.");
        require(tokenBalances[tokenAddr] >= amount, "Insufficient balance.");
        IERC20 token = IERC20(tokenAddr);
        require(token.transfer(to, amount), "Transfer failed");
        tokenBalances[tokenAddr] -= amount;  // Update the stored balance
        emit TokensTransferred(tokenAddr, to, amount);
    }

    // Function to check the balance of a specific token
    function getTokenBalance(address tokenAddr) public view returns (uint256) {
        return IERC20(tokenAddr).balanceOf(address(this));
    }

    // Function to get the address of this contract
    function getContractAddress() public view returns (address) {
        return address(this);
    }
}
