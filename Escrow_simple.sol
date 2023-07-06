// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Escrow {
    address public payer;
    address payable public payee; // who rec the money
    address public lawyer; //deployer of the contract

    uint256 public amount;

    constructor(
        address _payer,
        address payable _payee,
        uint256 _amount
    ) {
        payer = _payer;
        payee = _payee;
        amount = _amount;
        lawyer = msg.sender;
    }

    function deposit() public payable {
        require(msg.sender == payer, "you are not a payer");
        require(address(this).balance <= amount);
    }

    function release() public {
        require(address(this).balance == amount, "funds are not enough");
        require(msg.sender == lawyer, "you are not a lawyer");
        payee.transfer(amount);
    }

    function getBalanceOf() public view returns (uint256) {
        return address(this).balance;
    }
}
