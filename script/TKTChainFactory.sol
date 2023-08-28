// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "./TKTChainEvent.sol";

/// @title EventFactory Contract
/// @author Nika Khachiashvili
contract TKTChainFactory is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    event EventCreated(
        address indexed eventAddress,
        address indexed owner,
        uint256 indexed timestamp
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @dev Upgradeable Contract Initializer
    /// @dev Can be called only once
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    /// @notice Function for creating the event contract
    function createEvent() external virtual returns (address) {
        TKTChainEvent e = new TKTChainEvent();
        emit EventCreated(address(e), msg.sender, block.timestamp);
        return address(e);
    }

    /// @dev Function for upgrading the contract
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
