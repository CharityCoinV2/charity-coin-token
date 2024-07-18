## Ethereum Uniswap Token Swap Contracts

### Overview

This repository contains Solidity contracts for interacting with Uniswap V2 on the Ethereum blockchain. The main contract, `TestUniswap`, facilitates token swaps using the Uniswap V2 Router interface (`IUniswapV2Router`). It allows users to swap tokens and estimate minimum output amounts before executing swaps.

### Contracts

1. **TestUniswap.sol**: Allows token swaps using Uniswap V2 Router. Provides functions for swapping tokens (`swap`) and estimating minimum output amounts (`getAmountOutMin`).

2. **Interfaces/IUniswapV2Router.sol**: Interface defining functions for interacting with Uniswap V2 Router, including token swaps (`swapExactTokensForTokens`, `swapExactTokensForETH`, `swapExactETHForTokens`) and liquidity management (`addLiquidity`, `removeLiquidity`).

### Usage

- Deploy the `TestUniswap` contract to an Ethereum network.
- Interact with the deployed contract to swap tokens using the defined functions.
- Customize the contract parameters and functions as per specific token swap requirements.
- Ensure thorough testing in a testnet environment before deploying to the Ethereum mainnet.

### Security

- Audit the contract for security vulnerabilities, especially concerning token approvals and external function calls.
- Handle edge cases such as low liquidity, high gas costs, and transaction failures.

### License

This project is licensed under the MIT License - see the LICENSE file for details.
