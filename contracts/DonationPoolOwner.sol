// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract DonationPool {
    address public donationPool; // The Donation Pool Address
    address[] public owners; // The Owners of the Contract
    uint256 public requiredConfirmations; // Required number of confirmations
    uint256 public maxDonationAmount; // Maximum donation amount that can be distributed

    mapping(address => uint256) public donationsByToken; // Mapping to track the total amount of each individual coin donated
    mapping(uint256 => mapping(address => bool)) public confirmations;

    struct DistributionRequest {
        address charity;
        address token;
        uint256 amount;
        uint256 confirmations;
        bool executed;
    }

    mapping(uint256 => DistributionRequest) public distributionRequests;
    uint256 public requestCount;

    event DonationReceived(address indexed donor, address indexed token, uint256 amount); // Event to log donation details

    constructor(address[] memory _owners, uint256 _requiredConfirmations, address _donationPool) {
        require(_owners.length >= _requiredConfirmations, "Number of required confirmations must be less or equal to the number of owners.");
        owners = _owners;
        requiredConfirmations = _requiredConfirmations;
        donationPool = _donationPool; // Set the Donation Pool
    }

    // Function to allow anyone to donate ERC20 tokens to the pool
    function donate(address token, uint256 amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        donationsByToken[token] += amount; // Update the total donations for the specific token
        maxDonationAmount = IERC20(token).balanceOf(address(this)) / 10; // 10% of the total balance
        emit DonationReceived(msg.sender, token, amount); // Emit the donation amount
    }

    // Function to propose a distribution request
    function proposeDistribution(address charity, address token, uint256 amount) public onlyOwner returns (uint256) {
        require(amount <= IERC20(token).balanceOf(address(this)), "Amount exceeds balance.");
        require(amount <= maxDonationAmount, "Amount exceeds maximum allowed.");
        distributionRequests[requestCount] = DistributionRequest(charity, token, amount, 0, false);
        return requestCount++;
    }

    // Function to confirm a distribution request
    function confirmDistribution(uint256 requestId) public onlyOwner {
        require(!distributionRequests[requestId].executed, "Request already executed.");
        require(!confirmations[requestId][msg.sender], "Already confirmed.");
        confirmations[requestId][msg.sender] = true;
        distributionRequests[requestId].confirmations++;

        if (distributionRequests[requestId].confirmations >= requiredConfirmations) {
            distributionRequests[requestId].executed = true;
            IERC20(distributionRequests[requestId].token).transfer(distributionRequests[requestId].charity, distributionRequests[requestId].amount);
        }
    }

    // Modifier to restrict functions to owners only
    modifier onlyOwner() {
        require(isOwner(msg.sender), "Caller is not an owner.");
        _;
    }

    // Function to check if an address is an owner
    function isOwner(address account) public view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == account) return true;
        }
        return false;
    }

    // Function to Retrieve Donation Details
    function getDonationDetails(address token) public view returns (uint256) {
        return donationsByToken[token];
    }
}
