// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

// multi signature wallet -> need multi signature for this contract (wallet)
// like just kickstarter

contract MultiSigWallet {
    address[] public approvers;
    uint256 public quorum; // how many approvers need to know for the transections
    // quorum=2 -> means we have to get two approvers permission for the transection

    struct Transfer {
        uint256 id;
        uint256 amount;
        address payable to;
        uint256 approvals;
        bool sent;
    }

    mapping(uint256 => Transfer) transfers;
    uint256 nextId;
    mapping(address => mapping(uint256 => bool)) approvals;

    constructor(address[] memory _approvers, uint256 _quorum) payable {
        approvers = _approvers;
        quorum = _quorum;
    }

    // this function is just creating transection for the future
    function createTransfer(uint256 amount, address payable to) external {
        transfers[nextId] = Transfer(nextId, amount, to, 0, false);
        nextId++;
    }

    function sendTransfer(uint256 id) external onlyApprover {
        require(transfers[id].sent == false, "transfer has already been sent");

        // approvals[msg.sender][2]
        if (approvals[msg.sender][id] == false) {
            approvals[msg.sender][id] = true;
            transfers[id].approvals++;
        }
        if (transfers[id].approvals >= quorum) {
            transfers[id].sent = true;
            address payable to = transfers[id].to;
            uint256 amount = transfers[id].amount;
            to.transfer(amount);
            return;
        }
    }

    modifier onlyApprover() {
        bool allowed = false;
        for (uint256 i; i < approvers.length; i++) {
            if (approvers[i] == msg.sender) {
                allowed = true;
            }
        }
        require(allowed == true, "only approver allowed");
        _;
    }
}
