// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Token {
	string public name;
	string public symbol;
	uint256 public decimals = 18;
	uint256 public totalSupply; // 1 million x 10^18
	
	mapping (address => uint256) public balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;

	event Transfer(
		address indexed from, 
		address indexed to, 
		uint256 value
	);

	event Approval(
		address indexed owner, 
		address indexed spender, 
		uint256 value
	);

	constructor(
		string memory _name, 
		string memory _symbol, 
		uint256 _totalSupply
	) {
		name = _name;
		symbol = _symbol;
		totalSupply = _totalSupply * (10**decimals);
		balanceOf[msg.sender] = totalSupply;
	}

	function transfer(address _to, uint256 _value) 
		public 
		returns (bool success) 
	{
		// require that sender has enough tokens to spend
		require(balanceOf[msg.sender] >= _value, 'Transfer amount exceeds balance');

		_transfer(msg.sender, _to, _value);

		return true;
	}

	function _transfer(
		address _from,
		address _to,
		uint256 _value
	) internal {
		// require that receiver is not the zero address
		require(_to != address(0), 'Invalid recipient');

		// deduct tokens from spender
		balanceOf[_from] -= _value;
		
		// credit tokens to receiver
		balanceOf[_to] += _value;

		emit Transfer(_from, _to, _value);
	}

	function approve (address _spender, uint256 _value) 
		public 
		returns (bool success) 
	{
		// require that spender is not the zero address
		require(_spender != address(0), 'Invalid spender');

		// set allowance
		allowance[msg.sender][_spender] = _value;

		emit Approval(msg.sender, _spender, _value);

		return true;
	}

	function transferFrom(
		address _from, 
		address _to, 
		uint256 _value
	) 
		public 
		returns (bool success) 
	{
		// require that sender has enough tokens to spend
		require(_value <= balanceOf[_from], 'Transfer amount exceeds balance');

		// require that sender has enough allowance to spend
		require(_value <= allowance[_from][msg.sender], 'Transfer amount exceeds allowance');

		// reset allowance
		allowance[_from][msg.sender] -= _value;

		_transfer(_from, _to, _value);

		return true;
	}
}
