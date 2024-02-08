// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";

contract PriceConverterTest is Test {
    AggregatorV3Interface public priceFeed;
    uint256 public constant ETH_PRICE_IN_USD = 2000e18;
    uint256 public constant ONE_ETH = 1e18;

    function setUp() public {
        HelperConfig helperConfig = new HelperConfig();

        address usdEthPriceFeedAddr = helperConfig.activeNetworkConfig();
        priceFeed = AggregatorV3Interface(usdEthPriceFeedAddr);
    }

    function testGetPriceShouldReturnTheCorrectPrice() public {
        uint256 price = PriceConverter.getPrice(priceFeed);

        assertEq(price, ETH_PRICE_IN_USD);
    }

    function testGetConversionRateShouldReturnTheCorrectConvRate() public {
        uint256 ethAmountInUsd = PriceConverter.getConversionRate(
            ONE_ETH,
            priceFeed
        );

        assertEq(ethAmountInUsd, ETH_PRICE_IN_USD);
    }
}
