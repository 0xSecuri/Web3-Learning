// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    uint256 public constant MINIMUM_USD = 5e18;
    uint256 public constant TWO_DOLLARS_IN_ETH = 0.001 ether;
    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    address public constant USER = address(1);

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testMinimumDollarIsFive() public {
        assertEq(MINIMUM_USD, fundMe.MINIMUM_USD());
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 expectedVersion = 4;
        assertEq(fundMe.getVersion(), expectedVersion);
    }

    function testOwnerIsSetProperly() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedWasSet() public {
        assertNotEq(address(fundMe.getPriceFeed()), address(0));
    }

    function testFundFunctionalityWorksCorrectly() public funded {
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE);
        assertEq(fundMe.getFunder(0), USER);
    }

    function testFundFunctionalityRevertsIfNotEnoughEthWasSent() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundFuncRevertsWithEthSentLessThanRequiredAmount() public {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.fund{value: TWO_DOLLARS_IN_ETH}();
    }

    function testWithdrawCanBeCalledOnlyFromOwner() public {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawShouldWorkCorrectly() public funded {
        // Arrange
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
        vm.expectRevert();
        assertEq(fundMe.getFunder(0), address(0));
        assertEq(fundMe.getAddressToAmountFunded(USER), 0);
    }
}
