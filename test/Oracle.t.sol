// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OracleContract} from "../src/Oracle.sol";

contract OracleContractTest is Test {
    OracleContract public oracle;

    function setUp() public {
        oracle = new OracleContract();
        oracle.setFee(0.01 ether);
    }

    function test_SetFeeAsOwner() public {
        assertEq(oracle.getFee(), 0.01 ether);
        oracle.setFee(0.02 ether);
        assertEq(oracle.getFee(), 0.02 ether);
    }

     function testFail_SetFee() public {
        vm.prank(address(0));
        oracle.setFee(0.02 ether);
    }
}
