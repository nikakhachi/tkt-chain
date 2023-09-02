// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TKTChainFactory.sol";

/// @title EventFactory Contract
/// @author Nika Khachiashvili
contract TKTChainFactoryV2 is TKTChainFactory {
    function version() external pure returns (string memory) {
        return "v2";
    }
}
