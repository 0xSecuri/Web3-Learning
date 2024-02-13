# EthBank Front-End

This repository contains the HTML and CSS files for the EthBank front-end.

## Usage

To use the EthBank front-end, follow these steps:

1. Open the HTML and CSS files in VSCode
1. Install the Live Server extension for VSCode
1. Click on the "Go Live" button in the bottom right corner of the VSCode window
1. Open your web browser and go to the address below to access the EthBank front-end:

```bash
http://127.0.0.1:5500/simple-eth-bank-frontend/
```

## Configuration

Before using the EthBank front-end, you need to configure your wallet to connect to the Anvil RPC URL. Anvil is a tool that spins up a local blockchain for development purposes.

Follow these steps to configure your wallet:

1. Run Anvil locally by using the following command in your terminal

```bash
anvil
```

2. Once Anvil is running, it will generate a local blockchain environment. Accounts will pop up on the terminal.

3. Import an account into your wallet by using its private key. You can find the private key of the account displayed in the terminal after running Anvil.

4. Configure your wallet to use the Anvil RPC URL as the network. This URL should be provided by Anvil when it is running locally.

5. Switch your wallet to use the Anvil network.

6. You should now be able to interact with the EthBank front-end using your configured wallet.

## Important Note

- The EthBank front-end is intended for demonstration and testing purposes only. It may not have full functionality or security features implemented.
