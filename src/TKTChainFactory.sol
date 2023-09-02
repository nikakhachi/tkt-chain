// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts-upgradeable/contracts/access/Ownable2StepUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "./TKTChainEvent.sol";

/// @title EventFactory Contract
/// @author Nika Khachiashvili
contract TKTChainFactory is
    Initializable,
    Ownable2StepUpgradeable,
    UUPSUpgradeable
{
    error InvalidFee();

    event EventCreated(
        address indexed eventAddress,
        address indexed owner,
        uint256 indexed timestamp
    );

    uint256 public eventCreationFee;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @dev Upgradeable Contract Initializer
    /// @dev Can be called only once
    function initialize(uint256 _eventCreationFee) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        eventCreationFee = _eventCreationFee;
    }

    /// @notice Function for creating the event contract
    function createEvent() external payable virtual returns (address) {
        if (msg.value < eventCreationFee) revert InvalidFee();
        TKTChainEvent e = new TKTChainEvent();
        emit EventCreated(address(e), msg.sender, block.timestamp);
        return address(e);
    }

    function updateFee(uint256 _newEventCreationFee) external onlyOwner {
        eventCreationFee = _newEventCreationFee;
    }

    /// @dev Function for upgrading the contract
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}