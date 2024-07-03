// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {OracleContract} from "../src/Oracle.sol";

contract OracleContractScript is Script {
    OracleContract public oracle;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        oracle = new OracleContract();

        vm.stopBroadcast();
    }
}
