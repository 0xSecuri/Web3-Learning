// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/* To prevent reentrancy attacks, one can use one of the following techniques:
   - Update the balance before sending the ETH
   - Use ReentrancyGuard, as shown in our example where we have a modifier called noReentrant
*/

contract EtherStore {
    mapping(address => uint) public balances;
    bool private locked;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    modifier noReentrant() {
        locked = true;
        _;
        locked = false;
    }

    function withdraw() public noReentrant {
        uint bal = balances[msg.sender];
        require(bal > 0);

        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore;
    address public owner;

    constructor(address _etherStoreAddr) {
        etherStore = EtherStore(_etherStoreAddr);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: msg.value}();
        etherStore.withdraw();
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Tx failed");
    }
}
