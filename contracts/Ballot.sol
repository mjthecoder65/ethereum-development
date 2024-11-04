// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21 <0.9.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint256 voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint id = 0; id < proposalNames.length; id++) {
            proposals.push(Proposal({name: proposalNames[id], voteCount: 0}));
        }
    }

    function giveRightToVote(address voter) external {
        require(
            msg.sender == chairperson,
            "Only chair person can have a right to vote"
        );

        require(!voters[msg.sender].voted, "The voter already voted");
        require(voters[msg.sender].weight == 0);
        voters[voter].weight = 1;
    }

    function delegate(address to_address) external {
        Voter storage sender = voters[msg.sender];

        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You already voted");
        require(to_address != msg.sender, "Self-delegation is not allowed");

        while (voters[to_address].delegate != address(0)) {
            to_address = voters[to_address].delegate;

            require(to_address != msg.sender, "Found loop in delegation");
        }

        Voter storage delegate_ = voters[to_address];
        require(delegate_.weight >= 1);

        sender.voted = true;
        sender.delegate = to_address;

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint proposalId) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to zero");
        require(!sender.voted, "Already voted!");
        sender.voted = true;
        sender.vote = proposalId;
        proposals[proposalId].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;

        for (uint index = 0; index < proposals.length; index++) {
            if (proposals[index].voteCount > winningVoteCount) {
                winningVoteCount = proposals[index].voteCount;
                winningProposal_ = index;
            }
        }
    }

    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
