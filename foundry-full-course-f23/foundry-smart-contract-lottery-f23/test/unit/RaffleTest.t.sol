// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract RaffleTest is Test {
    event EnteredRaffle(address indexed player);
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint64 subscriptionId;
    bytes32 gasLane;
    uint256 automationUpdateInterval;
    uint256 raffleEntranceFee;
    uint32 callbackGasLimit;
    address vrfCoordinatorV2;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();
        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
        (
            ,
            gasLane,
            automationUpdateInterval,
            raffleEntranceFee,
            callbackGasLimit,
            vrfCoordinatorV2, // link // deployerKey
            ,

        ) = helperConfig.activeNetworkConfig();
    }

    /////////////////////////
    //raffleInitializaiton //
    /////////////////////////

    function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testConstructorSetsAllVariablesCorrectly() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
        // TODO add test for subId

        assert(raffle.getGasLane() == gasLane);
        assert(raffle.getInterval() == automationUpdateInterval);
        assert(raffle.getEntranceFee() == raffleEntranceFee);
        assert(raffle.getCallbackGasLimit() == callbackGasLimit);
        assert(raffle.getVrfCoordinatorAddr() == vrfCoordinatorV2);
    }

    /////////////////////////
    // enterRaffle         //
    /////////////////////////
    function testEnterRaffleShouldRevertWhenYouDontPayEnough() public {
        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle__NotEnoughEth.selector);
        raffle.enterRaffle();
    }

    modifier enterRaffleWithPlayer() {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: raffleEntranceFee}();
        _;
    }

    function testEnterRaffleShouldRevertIfRaffleIsNotOpen()
        public
        enterRaffleWithPlayer
    {
        vm.warp(block.timestamp + automationUpdateInterval + 1);
        vm.roll(block.number + 1);
        raffle.performUpkeep("");

        vm.expectRevert(Raffle.Raffle__NotOpen.selector);
        vm.prank(PLAYER);
        raffle.enterRaffle{value: raffleEntranceFee}();
    }

    function testRaffleRecordsPlayerWhenTheyEnter()
        public
        enterRaffleWithPlayer
    {
        address recordedPlayer = raffle.getPlayer(0);
        assert(recordedPlayer == PLAYER);
    }

    function testEmitsEventOnEntrance() public {
        vm.prank(PLAYER);

        vm.expectEmit(true, false, false, false, address(raffle));
        emit EnteredRaffle(PLAYER);
        raffle.enterRaffle{value: raffleEntranceFee}();
    }

    function testFulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep(
        uint256 randomRequestId
    ) public {
        vm.expectRevert("nonexistent request");
        VRFCoordinatorV2Mock(vrfCoordinatorV2).fulfillRandomWords(
            randomRequestId,
            address(raffle)
        );
    }
}
