// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    uint256 public constant MINIMUM_USD = 5e18;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(MINIMUM_USD, fundMe.MINIMUM_USD());
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 expectedVersion = 4;
        assertEq(fundMe.getVersion(), expectedVersion);
    }
}
