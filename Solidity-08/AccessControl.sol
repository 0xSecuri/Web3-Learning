// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant ADMIN_ROLE = keccak256(abi.encodePacked("ADMIN"));
    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant USER_ROLE = keccak256(abi.encodePacked("USER"));

    mapping(bytes32 => mapping(address => bool)) public roles;

    constructor() {
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    modifier onlyAdmin(bytes32 _role) {
        require(roles[_role][msg.sender], "Only admin");
        _;
    }

    function grantRole(
        bytes32 _role,
        address _account
    ) external onlyAdmin(ADMIN_ROLE) {
        _grantRole(_role, _account);
        emit GrantRole(_role, _account);
    }

    function revokeRole(
        bytes32 _role,
        address _account
    ) external onlyAdmin(ADMIN_ROLE) {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }

    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }
}
