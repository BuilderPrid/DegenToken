// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    struct Reward {
        string name;
        uint256 cost;
    }
    Reward[] public rewards; // List of available rewards
    mapping(address => mapping(uint256 => bool)) public claimedRewards;
    constructor() ERC20("Degen", "DGN") {
        rewards.push(Reward("Official Degen NFT - ", 50));
        rewards.push(Reward("Merchandise - ", 100));
        rewards.push(Reward("Credits -", 100));
    }
    function getTotalRewards() public view returns (uint256) {
        return rewards.length;
    }

    function decimals() public pure override returns(uint8){
        return 0;
    }

    function claimReward(uint256 rewardIndex) public {
        require(rewardIndex < rewards.length, "Reward index out of bounds");
        require(!claimedRewards[msg.sender][rewardIndex], "Reward already claimed");
        require(balanceOf(msg.sender) >= rewards[rewardIndex].cost, "Insufficient tokens");
        _approve(msg.sender,address(this),rewards[rewardIndex].cost);
        transfer(address(this), rewards[rewardIndex].cost);
        claimedRewards[msg.sender][rewardIndex] = true;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    function transfer(address to,uint amount) public override returns(bool){
        require(amount <= balanceOf(msg.sender), "ERC20: transfer amount exceeds balance");
        _transfer(msg.sender, to, amount);
        return false;
    }

    function shop() public view returns(Reward[] memory) {
        return rewards;
        
    }


    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}