pragma solidity ^0.5.0;

contract Tester{

	mapping(address => uint256) public balance;

	constructor() public {

	}

	function setCurrency(uint256 val) public {
		balance[msg.sender] = val;
	}

	function whoami() public view returns (address){
		return msg.sender;
	}

	function getCurrency() public view returns(uint256){
		return balance[msg.sender];
	}

	function sendCurrency(address receiver, uint256 amount) public{
		if(balance[msg.sender] >= amount && amount%1==0){
			balance[msg.sender] -= amount;
			balance[receiver] += amount;
		}
	}
}