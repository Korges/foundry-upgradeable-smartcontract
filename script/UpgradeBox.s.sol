// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DevOpsTools, console} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        // 1. Get proxy address
        address proxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        console.log("Upgrading Box at proxy address:", proxy);

        vm.startBroadcast();

        Upgrades.upgradeProxy(proxy, "BoxV2.sol", "");

        // Get the implementation address
        address implementationAddress = Upgrades.getImplementationAddress(proxy);

        vm.stopBroadcast();

        console.log("Implementation Address:", implementationAddress);

        return implementationAddress;
    }
}
