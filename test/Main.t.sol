// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/TKTChainFactory.sol";
import "chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";
import "openzeppelin/token/ERC20/ERC20.sol";

contract TKTChainFactoryTest is Test {
    event EventCreated(
        address indexed eventAddress,
        address indexed owner,
        uint256 indexed timestamp
    );

    TKTChainFactory public factory;

    uint256 public constant INITIAL_FEE = 0.01 ether;
    address[] public initialPaymentTokens;

    address public constant CHAINLINK_FEED_REGISTRY =
        0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf;
    address public constant CHAINLINK_ETH_DENOMINATION_ =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    address public constant LINK = 0x514910771AF9Ca656af840dff83E8264EcF986CA;

    function setUp() public {
        factory = new TKTChainFactory();
        factory.initialize(INITIAL_FEE, CHAINLINK_FEED_REGISTRY);

        initialPaymentTokens = [address(1), address(2), address(3), LINK];
        factory.addPaymentTokensBatched(initialPaymentTokens);
    }
}
