// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Main.t.sol";

contract EventCreationTest is TKTChainFactoryTest {
    function testCreateEvent(
        uint256 amount,
        string memory name,
        string memory desc,
        string memory uri,
        uint256 ticketSalesEndsAt,
        uint256 eventStartsAt,
        uint8 ticketTypeCount
    ) public {
        vm.assume(amount >= INITIAL_FEE && amount < address(this).balance);

        TKTChainEvent.Ticket[] memory tickets = new TKTChainEvent.Ticket[](
            ticketTypeCount
        );
        for (uint i; i < ticketTypeCount; i++) {
            tickets[i] = TKTChainEvent.Ticket(i * 1e18, i * 100);
        }

        vm.expectEmit(false, true, true, false);
        emit EventCreated(address(0), address(this), block.timestamp);
        address eventAddress = factory.createEvent{value: amount}(
            name,
            desc,
            uri,
            ticketSalesEndsAt,
            eventStartsAt,
            tickets
        );

        TKTChainEvent tktEvent = TKTChainEvent(payable(eventAddress));

        assertEq(address(factory).balance, amount);
        assertEq(factory.balanceOf(address(this)), factory.K());
        assertEq(tktEvent.name(), name);
        assertEq(tktEvent.description(), desc);
        assertEq(tktEvent.uri(0), uri);
        assertEq(tktEvent.ticketSalesEndsAt(), ticketSalesEndsAt);
        assertEq(tktEvent.ticketTypeCount(), ticketTypeCount);
        assertEq(tktEvent.eventStartsAt(), eventStartsAt);

        for (uint i; i < ticketTypeCount; i++) {
            assertEq(tktEvent.ticketTypePrices(i), i * 1e18);
            assertEq(tktEvent.ticketTypeMaxSupplies(i), i * 100);
        }
    }

    function testCreateEventWithInvalidFee(uint256 amount) public {
        vm.assume(amount < INITIAL_FEE);
        vm.expectRevert(TKTChainFactory.InvalidFee.selector);
        factory.createEvent{value: amount}(
            "name",
            "desc",
            "uri",
            0,
            0,
            new TKTChainEvent.Ticket[](0)
        );
    }

    function testCreateEventWithToken(
        string memory name,
        string memory desc,
        string memory uri,
        uint256 ticketSalesEndsAt,
        uint256 eventStartsAt,
        uint8 ticketTypeCount
    ) public {
        (, int tokenPriceInEth, , , ) = FeedRegistryInterface(
            CHAINLINK_FEED_REGISTRY
        ).latestRoundData(LINK, CHAINLINK_ETH_DENOMINATION_);

        ERC20 token = ERC20(LINK);

        uint256 tokenAmount = (INITIAL_FEE * (10 ** token.decimals())) /
            uint256(tokenPriceInEth);

        deal(LINK, address(this), tokenAmount);
        token.approve(address(factory), tokenAmount);

        TKTChainEvent.Ticket[] memory tickets = new TKTChainEvent.Ticket[](
            ticketTypeCount
        );
        for (uint i; i < ticketTypeCount; i++) {
            tickets[i] = TKTChainEvent.Ticket(i * 1e18, i * 100);
        }

        vm.expectEmit(false, true, true, false);
        emit EventCreated(address(0), address(this), block.timestamp);
        address eventAddress = factory.createEvent(
            LINK,
            name,
            desc,
            uri,
            ticketSalesEndsAt,
            eventStartsAt,
            tickets
        );

        TKTChainEvent tktEvent = TKTChainEvent(payable(eventAddress));

        assertEq(token.balanceOf(address(factory)), tokenAmount);
        assertEq(factory.balanceOf(address(this)), factory.K());
        assertEq(tktEvent.name(), name);
        assertEq(tktEvent.description(), desc);
        assertEq(tktEvent.uri(0), uri);
        assertEq(tktEvent.ticketSalesEndsAt(), ticketSalesEndsAt);
        assertEq(tktEvent.ticketTypeCount(), ticketTypeCount);
        assertEq(tktEvent.eventStartsAt(), eventStartsAt);

        for (uint i; i < ticketTypeCount; i++) {
            assertEq(tktEvent.ticketTypePrices(i), i * 1e18);
            assertEq(tktEvent.ticketTypeMaxSupplies(i), i * 100);
        }
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
        factory.createEvent(
            LINK,
            "name",
            "desc",
            "uri",
            0,
            0,
            new TKTChainEvent.Ticket[](0)
        );
    }

    function testMintingDuringEventCreationWithEther(uint8 amount) public {
        vm.assume(amount < 30); /// @dev Just to make tests fast
        for (uint i = 1; i < amount; i++) {
            factory.createEvent{value: INITIAL_FEE}(
                "name",
                "desc",
                "uri",
                0,
                0,
                new TKTChainEvent.Ticket[](0)
            );
            assertEq(
                factory.balanceOf(address(this)),
                factory.K() / factory.totalEvents()
            );
            deal(address(factory), address(this), 0);
        }
    }

    function testMintingDuringEventCreationWithToken(uint8 amount) public {
        vm.assume(amount < 30); /// @dev Just to make tests fast

        (, int tokenPriceInEth, , , ) = FeedRegistryInterface(
            CHAINLINK_FEED_REGISTRY
        ).latestRoundData(LINK, CHAINLINK_ETH_DENOMINATION_);

        ERC20 token = ERC20(LINK);

        uint256 tokenAmount = (INITIAL_FEE * (10 ** token.decimals())) /
            uint256(tokenPriceInEth);

        deal(LINK, address(this), tokenAmount * amount);
        token.approve(address(factory), tokenAmount * amount);

        for (uint i = 1; i < amount; i++) {
            factory.createEvent(
                LINK,
                "name",
                "desc",
                "uri",
                0,
                0,
                new TKTChainEvent.Ticket[](0)
            );
            assertEq(
                factory.balanceOf(address(this)),
                factory.K() / factory.totalEvents()
            );
            deal(address(factory), address(this), 0);
        }
    }
}
