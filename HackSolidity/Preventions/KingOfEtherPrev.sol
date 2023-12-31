// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract KingOfEther {
    address public king;
    uint public balance;
    mapping(address => uint) balances;

    function claimThrone() external payable {
        require(msg.value > balance, "Need to pay more to become the king");

        balances[king] += balance;

        balance = msg.value;
        king = msg.sender;
    }

    function withdraw() public {
        require(msg.sender != king, "Current king cannot withdraw");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ETH");
    }
}

contract DosAttack {
    function attack(KingOfEther kingOfEtherAddr) external payable {
        kingOfEtherAddr.claimThrone{value: msg.value}();
    }
}
