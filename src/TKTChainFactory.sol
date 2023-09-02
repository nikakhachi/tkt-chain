// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts-upgradeable/contracts/access/Ownable2StepUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/token/ERC20/IERC20.sol";
import "chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";
import "./TKTChainEvent.sol";
import "./UC.sol";

/// @title EventFactory Contract
/// @author Nika Khachiashvili
contract TKTChainFactory is
    Initializable,
    Ownable2StepUpgradeable,
    UUPSUpgradeable
{
    using SafeERC20 for IERC20;

    error InvalidFee();

    event EventCreated(
        address indexed eventAddress,
        address indexed owner,
        uint256 indexed timestamp
    );

    uint256 public eventCreationFee;

    mapping(address => bool) public paymentTokens;

    FeedRegistryInterface public chainlinkFeedRegistry; /// @dev Used for getting the price of the token when paying with token
    address public constant CHAINLINK_ETH_DENOMINATION_ =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; /// @dev Used for price feed for ETH denomination

    /// @dev This is the recommendation from the OZ, uncomment it when deploying.
    /// @dev During the tests, it's better to disable it, because it makes the tests fail
    // /// @custom:oz-upgrades-unsafe-allow constructor
    // constructor() {
    //     _disableInitializers();
    // }

    /// @dev Upgradeable Contract Initializer
    /// @dev Can be called only once
    function initialize(
        uint256 _eventCreationFee,
        address _chainlinkFeedRegistry
    ) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        eventCreationFee = _eventCreationFee;
        chainlinkFeedRegistry = FeedRegistryInterface(_chainlinkFeedRegistry);
    }

    /// @notice Function for creating the event contract and paying with ETH
    function createEvent() external payable virtual returns (address) {
        if (msg.value < eventCreationFee) revert InvalidFee();
        TKTChainEvent e = new TKTChainEvent();
        emit EventCreated(address(e), msg.sender, block.timestamp);
        return address(e);
    }

    /// @notice Function for creating the event contract and paying with ERC20 tokens
    function createEvent(address _token) external virtual returns (address) {
        (, int tokenPriceInEth, , , ) = chainlinkFeedRegistry.latestRoundData(
            _token,
            CHAINLINK_ETH_DENOMINATION_
        );
        IERC20(_token).safeTransferFrom(
            msg.sender,
            address(this),
            eventCreationFee / uint256(tokenPriceInEth)
        );
        TKTChainEvent e = new TKTChainEvent();
        emit EventCreated(address(e), msg.sender, block.timestamp);
        return address(e);
    }

    /// @notice update the fee for creating the event
    function updateFee(uint256 _newEventCreationFee) external onlyOwner {
        eventCreationFee = _newEventCreationFee;
    }

    /// @notice add a token which can be used as a payment when creating an event
    function addPaymentToken(address _token) external onlyOwner {
        paymentTokens[_token] = true;
    }

    /// @notice add a tokens which can be used as a payment when creating an event
    function addPaymentTokensBatched(
        address[] calldata _tokens
    ) external onlyOwner {
        for (UC i = ZERO; i < uc(_tokens.length); i = i + ONE)
            paymentTokens[_tokens[i.unwrap()]] = true;
    }

    /// @notice remove a token which can be used as a payment when creating an event
    function removePaymentToken(address _token) external onlyOwner {
        delete paymentTokens[_token];
    }

    /// @notice remove a tokens which can be used as a payment when creating an event
    function removePaymentTokensBatched(
        address[] calldata _tokens
    ) external onlyOwner {
        for (UC i = ZERO; i < uc(_tokens.length); i = i + ONE)
            delete paymentTokens[_tokens[i.unwrap()]];
    }

    function withdrawToken(address _token) external onlyOwner {
        IERC20 token = IERC20(_token);
        token.safeTransfer(msg.sender, token.balanceOf(address(this)));
    }

    function withdrawEther() external onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }

    /// @dev Function for upgrading the contract
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    receive() external payable {}
}
