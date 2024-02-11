// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EthBank {
    error EthBank__InsufficientBalance();
    mapping(address => uint256) balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        uint256 currentBalance = balances[msg.sender];

        if (amount > currentBalance) {
            revert EthBank__InsufficientBalance();
        }

        uint256 amountToSend = balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amountToSend}("");
        require(success, "Fail while sending ETH");
    }

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }

    // Getters
    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
