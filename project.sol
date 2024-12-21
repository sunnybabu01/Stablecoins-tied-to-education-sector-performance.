// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationStablecoin {
    string public name = "EduStableCoin";
    string public symbol = "EDU";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event MilestoneAchieved(address indexed institution, uint256 rewardAmount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * (10 ** uint256(decimals));
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");
        balanceOf[from] -= value;
        allowance[from][msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    function rewardInstitution(address institution, uint256 rewardAmount) public onlyOwner {
        require(balanceOf[owner] >= rewardAmount, "Insufficient contract balance for rewards");
        balanceOf[owner] -= rewardAmount;
        balanceOf[institution] += rewardAmount;
        emit MilestoneAchieved(institution, rewardAmount);
    }

    function mint(uint256 amount) public onlyOwner {
        uint256 mintAmount = amount * (10 ** uint256(decimals));
        totalSupply += mintAmount; 
        balanceOf[owner] += mintAmount;
        emit Transfer(address(0), owner, mintAmount);
    }

    function burn(uint256 amount) public onlyOwner {
        uint256 burnAmount = amount * (10 ** uint256(decimals));
        require(balanceOf[owner] >= burnAmount, "Insufficient balance to burn");
        totalSupply -= burnAmount;
        balanceOf[owner] -= burnAmount;
        emit Transfer(owner, address(0), burnAmount);
    }
}
 