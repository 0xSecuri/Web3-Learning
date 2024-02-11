// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {EthBank} from "../src/EthBank.sol";

contract DeployEthBank is Script {
    function run() external returns (EthBank) {
        vm.startBroadcast();
        EthBank ethBank = new EthBank();
        vm.stopBroadcast();

        return ethBank;
    }
}
