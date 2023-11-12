// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Car {
    address public owner;
    string public model;
    address public carAddr;

    constructor(address _owner, string memory _model) payable {
        owner = _owner;
        model = _model;
        carAddr = address(this);
    }
}

contract CarFacotry {
    Car[] public cars;

    function createNewCar(
        address _owner,
        string calldata _model
    ) external payable {
        cars.push(new Car(_owner, _model));
    }
}
