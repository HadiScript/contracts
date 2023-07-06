// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract String_Manipulations {
    function length(string memory str) public pure returns (uint256) {
        // by default string havent any length property
        // but bytes have it

        // return str.length;

        bytes memory str_bytes = bytes(str);
        return str_bytes.length;
    }

    function concatinations(string memory str1, string memory str2)
        public
        pure
        returns (string memory)
    {
        bytes memory str_bytes_1 = bytes(str1);
        bytes memory str_bytes_2 = bytes(str2);

        string memory str = new string(str_bytes_1.length + str_bytes_2.length);

        bytes memory str_bytes = bytes(str);

        uint256 j = 0;

        for (uint256 i = 0; i < str_bytes_1.length; i++) {
            str_bytes[i] = str_bytes_1[i];
            j++;
        }
        for (uint256 i = 0; i < str_bytes_2.length; i++) {
            str_bytes[j] = str_bytes_2[i];
            j++;
        }

        return string(str_bytes);
    }
}
