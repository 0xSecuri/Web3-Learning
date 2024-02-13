# EthBank Smart Contract

This is a simple Ethereum smart contract called EthBank that acts as a basic bank for handling deposits and withdrawals of Ether.

## Contract Details

- **License**: MIT
- **Solidity Version**: ^0.8.17

## Contract Features

- Allows users to deposit Ether into their account.
- Allows users to withdraw Ether from their account, provided they have sufficient balance.
- Handles insufficient balance errors.

## Deployment

Deploy the EthBank contract to your local Anvil node using the following command:

```bash
make DeployEthBank
```

## Usage

Interact with the deployed contract using the following options:

- Using [cast](https://book.getfoundry.sh/cast/#:~:text=Cast%20is%20Foundry's%20command%2Dline,all%20from%20your%20command%2Dline!)

- Using Front-End developed for this contrac: refer to [the front-end README.md](https://github.com/0xSecuri/Web3-Learning/blob/main/simple-eth-bank-frontend/README.md) for instructions.
