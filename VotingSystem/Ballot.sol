// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ballot {
    struct Voter {
        uint256 weight;
        bool hasVoted;
        uint256 vote;
    }

    struct Candidate {
        bytes32 name;
        uint256 votes;
    }

    address public electionAdmin;

    mapping(address => Voter) public voters;

    Candidate[] public candidates;

    constructor(bytes32[] memory candidateNames) {
        electionAdmin = msg.sender;
        candidates = new Candidate[](candidateNames.length);
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates[i].name = candidateNames[i];
            candidates[i].votes = 0;
        }
    }

    function authorizeVoter(address _voter, uint256 _weight) public {
        require(
            msg.sender == electionAdmin,
            "Only the election administrator can give right to vote."
        );
        require(!voters[_voter].hasVoted, "The voter already voted.");
        require(voters[_voter].weight == 0);
        voters[_voter].weight = _weight;
    }

    function vote(uint candidate) public {
        Voter storage voter = voters[msg.sender];
        require(voter.hasVoted == false, "The voter already voted.");
        require(voter.weight != 0, "The voter has no right to vote.");
        require(candidate < candidates.length, "Invalid proposal.");
        candidates[candidate].votes += voter.weight;
        voter.hasVoted = true;
        voter.vote = candidate;
    }

    function getWinner() public view returns (uint winner) {
        uint256 winningVote = 0;
        uint256 winningCandidate = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].votes > winningVote) {
                winningVote = candidates[i].votes;
                winningCandidate = i;
            }
        }
        winner = winningCandidate;
    }

    function getCandidateName(uint candidate) public view returns (bytes32 name) {
        require(candidate < candidates.length, "Invalid candidate.");
        name = candidates[candidate].name;
    }
}
