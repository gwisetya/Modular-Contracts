// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

library Balances{
    function move(mapping(address=>uint256) storage _addressToBalance, address _from, address _to, uint256 _amount) public {
        require(_addressToBalance[_from] >= _amount, "not enough balance"); 
        require(_addressToBalance[_to] +_amount > _addressToBalance[_to ], "overflow");
        _addressToBalance[_from] -= _amount;
        _addressToBalance[_to] += _amount; 
    }
}

contract Token{
    mapping(address => uint256) addressToBalance; 
    mapping(address => mapping(address => uint256)) allowance; 
    using Balances for mapping(address => uint256);

    event Transfer(address indexed from, address indexed to, uint256 amount); 
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    function transfer(address _to, uint256 _amount) public returns(bool){
        addressToBalance.move(msg.sender, _to, _amount);
        emit Transfer(msg.sender, _to, _amount); 
        return true;
    }

    function approve(uint256 _amount, address _spender) public {
        allowance[msg.sender][_spender] = _amount; 
        emit Approval(msg.sender, _spender, _amount);
    }

    function transferFrom(uint256 _amount, address _from ,address _to) public{
        require(allowance[_from][msg.sender] >= _amount);
        allowance[_from][msg.sender] -= _amount;
        addressToBalance.move(_from, _to, _amount); 
        emit Transfer(_from, _to, _amount);
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return addressToBalance[_owner];
    }
}