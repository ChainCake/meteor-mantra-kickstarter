pragma solidity ^0.4.4;
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract IcingToken is StandardToken {
  string public name = 'Icing`';
  string public symbol = 'ICE';
  uint public decimals = 2;
  uint public INITIAL_SUPPLY = 42;

  function IcingToken() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
}

