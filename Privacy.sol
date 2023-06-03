// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// storage layout: https://docs.soliditylang.org/en/v0.8.10/internals/layout_in_storage.html#storage-inplace-encoding
// query storage: await web3.eth.getStorageAt(instance, 0)
// force convert and decode: first half of the bytes32 is bytes16
contract Privacy {

  bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(block.timestamp);
  bytes32[3] private data;

  constructor(bytes32[3] memory _data) {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}

contract BytesConvert {
    bytes32 public b32 = bytes32(0xf4c393f990d8a6ec14cb6eec335b501b42996efac7c2005937c926c10903a440);
    bytes16 public b16 = bytes16(b32);
}