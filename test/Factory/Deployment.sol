// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Main.t.sol";

contract DeploymentTest is TKTChainFactoryTest {
    function testInitialVariables() public {
        assertEq(factory.eventCreationFeeInEth(), INITIAL_FEE);
        assertEq(
            address(factory.chainlinkFeedRegistry()),
            CHAINLINK_FEED_REGISTRY
        );
        assertEq(factory.owner(), address(this));
    }
}
