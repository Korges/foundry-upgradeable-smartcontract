// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        // 1. Get proxy address
        address proxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        console.log("Upgrading Box at proxy address:", proxy);

        address implementationAddress = upgradeBox(proxy);

        console.log("Implementation Address:", implementationAddress);

        return implementationAddress;
    }

    function upgradeBox(address proxy) public returns (address) {
        vm.startBroadcast();

        Upgrades.upgradeProxy(proxy, "BoxV2.sol", abi.encodeCall(BoxV2.initialize, ()));

        // Get the implementation address
        address implementationAddress = Upgrades.getImplementationAddress(proxy);

        vm.stopBroadcast();

        return implementationAddress;
    }
}
