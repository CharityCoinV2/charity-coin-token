// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public donationPool;

    constructor(address _donationPool) ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1000 * 10 ** uint256(decimals()));
        donationPool = _donationPool;
    }

    // Override transfer function to deduct fees
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = amount / 100;  // 1% fee
        uint256 amountAfterFee = amount - fee;

        super.transfer(donationPool, fee);  // Send fee to donation pool
        return super.transfer(recipient, amountAfterFee);  // Send the rest to the recipient
    }

    // Override transferFrom function to deduct fees
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = amount / 100;  // 1% fee
        uint256 amountAfterFee = amount - fee;

        super.transferFrom(sender, donationPool, fee);  // Deduct fee and send to donation pool
        return super.transferFrom(sender, recipient, amountAfterFee);  // Send the rest to the recipient
    }

    // Retrieve the total supply of tokens
    function getTotalSupply() public view returns (uint256) {
        return totalSupply();
    }

    // Check the balance of a specific address
    function getBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Determine how many tokens are not held by users (i.e., held by the contract itself)
    function getUnheldTokens() public view returns (uint256) {
        return balanceOf(address(this));
    }

    // Function to return the contract's address
    function getContractAddress() public view returns (address) {
        return address(this);
    }
}
