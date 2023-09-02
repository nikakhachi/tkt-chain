// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Main.t.sol";

contract OwnerActionsTest is TKTChainFactoryTest {
    function testUpdateFee() public {
        factory.updateFee(2 ether);
        assertEq(factory.eventCreationFeeInEth(), 2 ether);
    }

    function testAddPaymentToken(address _token) public {
        factory.addPaymentToken(_token);
        assertTrue(factory.paymentTokens(_token));
    }

    function testRemovePaymentToken(address _token) public {
        factory.addPaymentToken(_token);
        factory.removePaymentToken(_token);
        assertFalse(factory.paymentTokens(_token));
    }

    function testAddPaymentTokensBatched(address[] memory _tokens) public {
        factory.addPaymentTokensBatched(_tokens);
        for (uint256 i = 0; i < _tokens.length; i++) {
            assertTrue(factory.paymentTokens(_tokens[i]));
        }
    }

    function testRemovePaymentTokensBatched(address[] memory _tokens) public {
        factory.addPaymentTokensBatched(_tokens);
        factory.removePaymentTokensBatched(_tokens);
        for (uint256 i = 0; i < _tokens.length; i++) {
            assertFalse(factory.paymentTokens(_tokens[i]));
        }
    }

    function testWithdrawEth() public {
        vm.prank(address(1));
        payable(address(factory)).transfer(address(1).balance);

        vm.prank(address(2));
        payable(address(factory)).transfer(address(2).balance);

        assertGe(address(factory).balance, 0);

        uint initialBalance = address(this).balance;

        factory.withdrawEther();

        assertEq(address(factory).balance, 0);
        assertGe(address(this).balance, initialBalance);
    }

    function testWithdrawToken(uint amount) public {
        deal(LINK, address(factory), amount);
        factory.withdrawToken(LINK);
        assertEq(ERC20(LINK).balanceOf(address(factory)), 0);
        assertEq(ERC20(LINK).balanceOf(address(this)), amount);
    }

    receive() external payable {}
}
