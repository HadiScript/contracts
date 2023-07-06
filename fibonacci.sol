// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Fibonacci {

    //recursive makes much more gass

    function fib(uint256 n) external pure returns (uint256) {
        if (n == 0) {
            return 0;
        }
        uint256 fi_1 = 1;
        uint256 fi_2 = 1;
        for (uint256 i = 2; i < n; i++) {
            uint256 fi = fi_1 + fi_2;
            fi_2 = fi_1;
            fi_1 = fi;
        }
        return fi_1;
    }
}
