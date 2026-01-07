// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {console} from "forge-std/console.sol";

contract DeployAndUpgradeTest is StdCheats, Test {
    DeployBox deployer;
    UpgradeBox upgrader;
    // address public OWNER = makeAddr("owner");

    // BoxV1 boxV1;
    // BoxV2 boxV2;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
    }

    function testDeployBox() public {
        (, address proxy) = deployer.run();
        uint256 expectedValue = 1;
        assertEq(expectedValue, BoxV1(proxy).version());
        assertEq(true, true);
    }

    function testDeploymentIsV1() public {
        (, address proxy) = deployer.run();
        uint256 expectedValue = 1;
        vm.expectRevert();
        BoxV2(proxy).setValue(expectedValue);
    }

    function testUpgradeWorks() public {
        (, address proxy) = deployer.run();
        console.log("Proxy Address in test:", proxy);
        address implementationAddress = upgrader.upgradeBox(proxy);
        console.log("Upgraded Implementation Address in test:", implementationAddress);

        assertEq(0, BoxV2(proxy).getValue());
        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        BoxV2(proxy).setValue(expectedValue);
        assertEq(expectedValue, BoxV2(proxy).getValue());
    }
}
