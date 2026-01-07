// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {Upgrades} from "@openzeppelin-foundry-upgrades/Upgrades.sol";

contract DeployBox is Script {
    function run() public returns (address, address) {
        vm.startBroadcast();

        // deploy proxy + initialize atomically
        address proxy = Upgrades.deployUUPSProxy("BoxV1.sol", abi.encodeCall(BoxV1.initialize, ()));

        // Get the implementation address
        address implementationAddress = Upgrades.getImplementationAddress(proxy);

        vm.stopBroadcast();

        console.log("Implementation Address:", implementationAddress);
        console.log("Proxy Address:", proxy);

        return (implementationAddress, proxy);
    }
}
