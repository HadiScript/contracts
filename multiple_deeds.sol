// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract deed {
    address lawyer;

    address public beneficiary;

    uint256 public earliest;

    uint256 public amount;

    uint256 public constant PAYOTUS = 10;
    uint256 public constant INTERVAL = 10;
    uint256 public paidPayouts;

    constructor(
        address _lawyer,
        address _beneficiary,
        uint256 fromNow
    ) payable {
        lawyer = _lawyer;
        beneficiary = _beneficiary;
        earliest = block.timestamp + fromNow;
        // let we have 100 wei send at the first time
        // but we have to pay send 100 to the 10 (becouse PAYOUTS = 10)

        // now we have the 100 wie in block and in amount vairable we are having 10 wei
        amount = msg.value / PAYOTUS;
    }

    function withdraw() public {
        require(
            msg.sender == beneficiary,
            "beneficiary only can initiate a withraw"
        );
        require(block.timestamp >= earliest, "Too early to withdraw");
        require(paidPayouts < PAYOTUS, "no payouts left");

        uint256 eligiblePayouts = (block.timestamp - earliest) / INTERVAL;

        uint256 duePayouts = eligiblePayouts - paidPayouts;
        duePayouts = duePayouts + paidPayouts > PAYOTUS
            ? PAYOTUS - paidPayouts
            : duePayouts;
        paidPayouts += duePayouts;
        payable(beneficiary).transfer(duePayouts * amount);
    }
}
