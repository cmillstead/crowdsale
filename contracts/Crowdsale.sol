// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Token.sol";

contract Crowdsale {
    address public owner;
    Token public token;
    uint256 public price;
    uint256 public tokensSold;
    uint256 public maxTokens;

    event Buy(
        uint256 amount,
        address buyer
    );

    event Finalize(
        uint256 tokensSold,
        uint256 ethRaised
    );

    constructor(
        Token _token,
        uint256 _price,
        uint256 _maxTokens
    ) {
        owner = msg.sender;
        token = _token;
        price = _price;
        maxTokens = _maxTokens;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'Only owner can finalize');
        _;
    }

    receive() external payable {
        uint256 amount = msg.value / price;
        buyTokens(amount * 1e18);
    }
 
    function buyTokens(uint256 _amount) public payable {
        // require that value is equal to tokens
        require(msg.value == (_amount / 1e18) * price, 'Invalid amount sent');

        // require that contract has enough tokens
        require(token.balanceOf(address(this)) >= _amount, 'Not enough tokens in reserve');

        // send tokens to buyer
        require(token.transfer(msg.sender, _amount), 'Failed to send tokens');

        tokensSold += _amount;

        emit Buy(_amount, msg.sender);
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function finalize() public onlyOwner {
        // send remaining tokens to owner
        require(token.transfer(owner, token.balanceOf(address(this))), 'Failed to send tokens');

        // send remaining ether to owner
        uint256 value = address(this).balance;
        ( bool sent, ) = owner.call{value: value}("");
        require(sent, 'Failed to send ether');

        emit Finalize(tokensSold, value);

        // destroy contract
        selfdestruct(payable(msg.sender));
    }
}