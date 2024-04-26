// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@layerzerolabs/solidity-examples/contracts/token/oft/v2/fee/OFTWithFee.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract CharityCoin is OFTWithFee, ERC20 {

    constructor(address _lzEndpoint) OFTWithFee("CharityCoin", "GIFT", 8, _lzEndpoint){

    }
}