// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Main.t.sol";

contract EventCreationTest is TKTChainFactoryTest {
    function testCreateEvent(uint256 amount) public {
        vm.assume(amount >= INITIAL_FEE && amount < address(this).balance);

        vm.expectEmit(false, true, true, false);
        emit EventCreated(address(0), address(this), block.timestamp);
        factory.createEvent{value: amount}();

        assertEq(address(factory).balance, amount);
    }

    function testCreateEventWithInvalidFee(uint256 amount) public {
        vm.assume(amount < INITIAL_FEE);
        vm.expectRevert(TKTChainFactory.InvalidFee.selector);
        factory.createEvent{value: amount}();
    }

    function testCreateEventWithToken() public {
        (, int tokenPriceInEth, , , ) = FeedRegistryInterface(
            CHAINLINK_FEED_REGISTRY
        ).latestRoundData(LINK, CHAINLINK_ETH_DENOMINATION_);

        ERC20 token = ERC20(LINK);

        uint256 tokenAmount = (INITIAL_FEE * (10 ** token.decimals())) /
            uint256(tokenPriceInEth);

        deal(LINK, address(this), tokenAmount);
        token.approve(address(factory), tokenAmount);

        vm.expectEmit(false, true, true, false);
        emit EventCreated(address(0), address(this), block.timestamp);
        factory.createEvent(LINK);

        assertEq(token.balanceOf(address(factory)), tokenAmount);
    }

    function testCreateEventWithTokenWithInvalidFee(uint amount) public {
        (, int tokenPriceInEth, , , ) = FeedRegistryInterface(
            CHAINLINK_FEED_REGISTRY
        ).latestRoundData(LINK, CHAINLINK_ETH_DENOMINATION_);

        ERC20 token = ERC20(LINK);

        uint256 tokenAmount = (INITIAL_FEE * (10 ** token.decimals())) /
            uint256(tokenPriceInEth);

        vm.assume(amount < tokenAmount);

        deal(LINK, address(this), amount);
        token.approve(address(factory), amount);

        vm.expectRevert(bytes("SafeERC20: low-level call failed"));
        factory.createEvent(LINK);
    }
}
