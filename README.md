# CharityCoin

CharityCoin is a decentralized ERC20 token designed to support charitable causes. With every transaction, a small donation fee is deducted and sent to a designated donation pool. This mechanism ensures continuous support for charitable causes while maintaining the token's utility and value.

## Features

- **ERC20 Token**: CharityCoin is compliant with the ERC20 standard, ensuring compatibility with existing infrastructure like wallets and exchanges.
- **Donation Mechanism**: Every transaction (both `transfer` and `transferFrom`) deducts a 1% donation fee that is sent directly to the donation pool.
- **Max Transaction Amount**: To prevent large, potentially disruptive transfers, there's a maximum transaction amount set at 5% of the total supply.
- **Donation Pool**: A separate contract that manages the collection and distribution of donations, including support for multiple ERC20 tokens.
- **Governance Ready**: The contract includes provisions for delegation, hinting at future governance capabilities.

## Contract Functions

### CharityCoin

- `transfer`: Allows users to transfer CharityCoin to another address. Deducts a 1% donation fee sent to the donation pool.
- `transferFrom`: Allows a delegate to transfer CharityCoin on behalf of a user. Also deducts the 1% donation fee.
- `setDonationPool`: Sets the donation pool address. This function can only be called once.

### DonationPool

- `donate`: Allows anyone to donate ERC20 tokens to the pool.
- `distributeDonations`: Allows the contract owner to send donations to the charity, with multi-signature requirements for added security.
- `getDonationDetails`: Retrieve donation details for a specific token.

## Future Plans

1. **Governance**: Introduce a decentralized governance mechanism allowing CharityCoin holders to propose and vote on initiatives.
2. **Charity DAO**: A decentralized autonomous organization (DAO) where token holders can vote on which charities receive donations.
3. **Staking**: Allow users to stake their CharityCoin to earn rewards, further incentivizing holding and supporting the token's value.
4. **Multi-token Donation**: Expand the donation mechanism to accept other ERC20 tokens, broadening the potential for support.
5. **Integration with Financial Platforms**: Explore possibilities of integrating with lending/credit protocols to create a socially responsible financial ecosystem.

## Getting Started

1. **Deployment**: The contract can be deployed on any Ethereum-compatible network. For testing purposes, consider using testnets like Rinkeby or Ropsten.
2. **Integration**: CharityCoin's ERC20 compliance ensures easy integration with wallets, exchanges, and other dApps.
3. **Contribute**: We welcome contributions! If you have suggestions or want to report a bug, please open an issue or submit a pull request.

## License

CharityCoin is open-source and licensed under the MIT license.
