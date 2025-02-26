// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {TestToken} from "../src/ERC20.sol";

contract TestTokenTest is Test {
    TestToken token;

    address owner;
    address user1;
    address user2;

    function setUp() public {
        // Fetch default test accounts provided by Foundry
        owner = address(this); // The contract address is the owner by default
        user1 = vm.addr(1); // Fetch address 1 (used as a test account)
        user2 = vm.addr(2); // Fetch address 2 (another test account)

        // Deploy the contract
        vm.startPrank(owner);
        token = new TestToken();
        vm.stopPrank();
    }

    function testInitialSupply() public {
        assertEq(token.balanceOf(owner), 1000000 * 10 ** 18);
    }

    function testMinting() public {
        vm.prank(owner);
        token.mint(user1, 500 * 10 ** 18);
        assertEq(token.balanceOf(user1), 500 * 10 ** 18);
    }

    function testMintingNotOwnerFails() public {
        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        token.mint(user1, 100 * 10 ** 18);
    }

    function testBurning() public {
        vm.prank(user1);
        token.burn(100 * 10 ** 18);
        assertEq(token.balanceOf(user1), 400 * 10 ** 18);
    }

    function testTransfers() public {
        assertEq(token.balanceOf(user1), 400 * 10 ** 18);
        assertEq(token.balanceOf(user2), 0);

        vm.prank(user1);
        token.transfer(user2, 200 * 10 ** 18);

        assertEq(token.balanceOf(user1), 200 * 10 ** 18);
        assertEq(token.balanceOf(user2), 200 * 10 ** 18);
    }

    function testPauseTransfersFail() public {
        vm.prank(owner);
        token.pause();
        vm.expectRevert("Pausable: paused");
        token.transfer(user1, 100 * 10 ** 18);
    }

    function testUnpauseTransfersWork() public {
        vm.prank(owner);
        token.pause();
        token.unpause();

        vm.prank(user1);
        token.transfer(user2, 50 * 10 ** 18);
        assertEq(token.balanceOf(user1), 150 * 10 ** 18);
        assertEq(token.balanceOf(user2), 250 * 10 ** 18);
    }
}
