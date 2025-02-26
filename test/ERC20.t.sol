// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
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

    function testInitialSupply() view public {
        assertEq(token.balanceOf(owner), 1000000 * 10 ** 18);
    }

    function testERC20Operations() public {
        vm.startPrank(owner);
        token.mint(user1, 500 * 10 ** 18);
        assertEq(token.balanceOf(user1), 500 * 10 ** 18);

        vm.startPrank(user1);

        token.burn(100 * 10 ** 18);
        
        assertEq(token.balanceOf(user1), 400 * 10 ** 18);
        assertEq(token.balanceOf(user2), 0);

        token.transfer(user2, 200 * 10 ** 18);

        assertEq(token.balanceOf(user1), 200 * 10 ** 18);
        assertEq(token.balanceOf(user2), 200 * 10 ** 18);
    }
}
