// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClaimKingShip {
  
  function claimKingship(address payable to) public payable {
    (bool sent,) = to.call{value: msg.value}("");
    require(sent, "Failed to send Ether");
  }
}