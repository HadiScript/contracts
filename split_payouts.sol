// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

// use case: let boss has to pay to all employees

contract splitPayments {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "the split payment can be issued only by the owner of the contract"
        );
        _;
    }

    function sendMoney(
        address payable[] memory recipients,
        uint256[] memory amount
    ) public payable onlyOwner {
        for (uint256 index = 0; index < recipients.length; index++) {
            require(
                recipients.length == amount.length,
                "recipients and amount array must be of the same length"
            );
            recipients[index].transfer(amount[index]);
        }
    }
}
