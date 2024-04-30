// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "contracts/DonationPool.sol";


// CharityCoin.sol
contract CharityCoin is ERC20 {

    address public owner;
    address public immutable donationPool;  // Donation pool address is immutable

    uint256 public initialSupply = 3000000000 * 10 ** decimals();  // Set initial supply
    uint256 public maxTransactionPercent = 5;  // Set a maxTransactionAmount: % of the initial supply
    uint256 public donationFeePercent = 1;  // donationFee on each transaction
    
    constructor(address _donationPool) ERC20("CharityCoin", "GIVE") {
        
        require(_donationPool != address(0), "Donation Pool cannot be zero address.");
        donationPool = _donationPool;  // Set at construction and immutable

        owner = msg.sender;

        // define total supply and assign all of them to the account owner
        _mint(owner, initialSupply);  // Mint totalSupply ONE TIME

        uint256 initialDonation = initialSupply * (5 * 10**16 / 100) / 10**16; // NEED TO FINALIZE initialDonation Amount...
        _transfer(msg.sender, donationPool, initialDonation);  // Seed the donation pool on mint

        // update pool
        IDonationPool(donationPool).updatePool(msg.sender, address(this), initialDonation);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {

        uint256 maxTransactionAmount = initialSupply * (maxTransactionPercent * 10**16 / 100) / 10**16;
        // console.log("CharityCoin -> maxTransactionAmount", initialSupply, maxTransactionPercent, maxTransactionAmount);
        require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount.");

        uint256 donationFee = 0;

        // exclude deduction if sender/recipient is owner
        if (msg.sender == donationPool || recipient == donationPool)  {

            // not allowed case
            if (msg.sender == donationPool) {
                require(msg.sender == donationPool, "Transfer out from donation pool is not allowed");
            }

            console.log("CharityCoin -> skipping donationFee");

            // update pool
            if (recipient == donationPool) {
                IDonationPool(donationPool).updatePool(msg.sender, address(this), amount);
            }
        } 
        else {
            donationFee = amount * (donationFeePercent * 10**16 / 100) / 10**16;
            _transfer(msg.sender, donationPool, donationFee);

            // update pool
            IDonationPool(donationPool).updatePool(msg.sender, address(this), donationFee);

            console.log("CharityCoin -> donationFee", donationFee);
        }

        console.log("CharityCoin -> transfer", amount - donationFee);
        return super.transfer(recipient, amount - donationFee);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {

        uint256 maxTransactionAmount = initialSupply * (maxTransactionPercent * 10**16 / 100) / 10**16;
        // console.log("CharityCoin -> maxTransactionAmount", initialSupply, maxTransactionPercent, maxTransactionAmount);
        require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTransactionAmount. ");

        uint256 donationFee = 0;

        // exclude deduction if sender/recipient is owner
        if (sender == donationPool || recipient == donationPool)  {
            console.log("CharityCoin -> skipping donationFee");

            // charity out case
            if (sender == donationPool) {
                console.log("CharityCoin -> charity out ... ");
            }

            // update pool
            if (recipient == donationPool) {
                IDonationPool(donationPool).updatePool(sender, address(this), amount);
            }
        } 
        else {
            donationFee = amount * (donationFeePercent * 10**16 / 100) / 10**16;
            _transfer(sender, donationPool, donationFee);

            // update pool
            IDonationPool(donationPool).updatePool(sender, address(this), donationFee);

            console.log("CharityCoin -> donationFee", donationFee);
        }

        console.log("CharityCoin -> transferFrom", amount - donationFee);
        return super.transferFrom(sender, recipient, amount - donationFee);
    }

}