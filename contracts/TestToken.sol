//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./ERC20Interface.sol";
import "./SafeMathLibrary.sol";
contract TestToken is ERC20Interface {
    
    //State Variables
    using SafeMath for uint256;
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;
    address public owner;

    //State Mappings
    mapping (address => uint256) private tokenBalances;                       
    mapping (address => mapping (address => uint256)) public allowed;
    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) {
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
        totalSupply = _initialAmount.mul(10 ** uint256(decimals));
        tokenBalances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function mint(address _to, uint256 _amount) public {
        require(msg.sender == address(this));
        tokenBalances[_to] += _amount;
        emit Transfer(address(0), _to, _amount);
    }


    function transfer(address _to, uint256 _value) public override returns (bool success) {

        // Check Balance
        require(tokenBalances[msg.sender] >= _value, "insufficient funds");

        // Transfer Amount
        tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
        tokenBalances[_to] = tokenBalances[_to].add(_value);

        // Emit Event
        emit Transfer(msg.sender, _to, _value);

        // Return
        return true;
    }
      function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {

        // Check Balance
        require(allowance(_from, msg.sender) >= _value, "insufficient allowance");
        require(tokenBalances[_from] >= _value, "invalid transfer amount");

        // transfer amout
        tokenBalances[_to] = tokenBalances[_to].add(_value);
        tokenBalances[_from] = tokenBalances[_from].sub(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        // Emit Event
        emit Transfer(_from, _to, _value);

        // return
        return true;
    }
    function approve(address _spender, uint256 _value) public override returns (bool success) {

        // Check approval
        require(balanceOf(msg.sender) >= _value, "insufficient funds");

        // Provide approval
        allowed[msg.sender][_spender] = _value;

        // Emit Event
        emit Approval(msg.sender, _spender, _value);

        // Return
        return true;
    }
       function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
        function balanceOf(address _owner) public override view returns (uint256 balance) {
        return tokenBalances[_owner];
    }
}
