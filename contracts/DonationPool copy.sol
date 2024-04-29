// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract DonationPool {
    address public admin;
    mapping(address => uint256) public tokenBalances;  // Tracks token balances by token address

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
        // Ensure that the contract is allowed to transfer the specified amount on behalf of the sender
        uint256 allowed = token.allowance(msg.sender, address(this));
        require(allowed >= amount, "Check the token allowance. Approval required.");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        tokenBalances[tokenAddr] += amount;  // Update the balance for the token
        emit DonationReceived(tokenAddr, amount);
    }

    // Function to transfer any token held by this contract to any address
    function transferAnyToken(address tokenAddr, address to, uint256 amount) public onlyAdmin {
        require(tokenBalances[tokenAddr] >= amount, "Insufficient token balance");
        IERC20 token = IERC20(tokenAddr);
        require(token.transfer(to, amount), "Transfer failed");
        tokenBalances[tokenAddr] -= amount;  // Update the stored balance
        emit TokensTransferred(tokenAddr, to, amount);
    }

    // Function to check the balance of a specific token in this contract
    function getTokenBalance(address tokenAddr) public view returns (uint256) {
        return tokenBalances[tokenAddr];
    }

    // Function to get the address of this contract
    function getContractAddress() public view returns (address) {
        return address(this);
    }
}
