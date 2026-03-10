//SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";
import {THXToken} from "../src/THXToken.sol";
import {TokenFaucet} from "../src/TokenFaucet.sol";

contract DeployTHXToken is Script {
    function run() external {
        vm.startBroadcast();
        THXToken token = new THXToken(1_000_000 ether, "Thomas X Token", "THX");

        console.log("THX Token deployed at:", address(token));
        // Deploy Faucet
        TokenFaucet faucet = new TokenFaucet(
            address(token),
            1 ether, // drip amount
            86400 // cooldown (seconds = 24h)
        );
        console.log("Faucet deployed at:", address(faucet));
        // Fund the faucet
        bool success = token.transfer(address(faucet), 1_000_000 ether); //10000 * 1e18 = 10000 tokens

        vm.stopBroadcast();
    }
}
