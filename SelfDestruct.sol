// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SelfDestruct {
  
  event Received(address, uint);
  receive() external payable {
    emit Received(msg.sender, msg.value);
  }

  function kill(address payable to) public {
    selfdestruct(to);
  }

  fallback() external {

  }
}