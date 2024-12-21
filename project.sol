// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KnowledgeHubRewards {
    
    struct Contribution {
        address contributor;
        uint256 amount;
        string contentHash;
    }

    mapping(address => uint256) public rewards;
    Contribution[] public contributions;

    address public owner;

    event ContributionAdded(address indexed contributor, uint256 amount, string contentHash);
    event RewardClaimed(address indexed contributor, uint256 reward);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addContribution(string memory contentHash, uint256 reward) public onlyOwner {
        require(reward > 0, "Reward must be greater than zero");
        contributions.push(Contribution({
            contributor: msg.sender,
            amount: reward,
            contentHash: contentHash
        }));
        
        rewards[msg.sender] += reward;
        emit ContributionAdded(msg.sender, reward, contentHash);
    }

    function claimReward() public {
        uint256 amount = rewards[msg.sender];
        require(amount > 0, "No reward available");
        rewards[msg.sender] = 0;

        payable(msg.sender).transfer(amount);

        emit RewardClaimed(msg.sender, amount);
    }
}
