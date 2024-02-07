// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    event NumberSetTo(uint256 indexed number);

    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
        emit NumberSetTo(newNumber);
    }

    function increment() public {
        number++;
    }
}
