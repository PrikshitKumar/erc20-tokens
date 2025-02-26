// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {TestToken} from "../src/ERC20.sol";

contract DeployTestToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); // Load private key from env

        vm.startBroadcast(deployerPrivateKey);
        TestToken token = new TestToken();
        vm.stopBroadcast();

        console.log("TestToken deployed at: ", address(token));
    }
}
