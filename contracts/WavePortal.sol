// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./helpers.sol";

contract WavePortal is Helpers {
  constructor() payable {}

  event CreatePost(Post);
  event UpdatePost(Post[] posts);
  event DeletePost(Post[] posts);

  struct Post {
    address addr;
    string message;
    bool isPostPinned;
    uint32 id;
    uint timestamp;
  }

  Post[] posts;

  mapping(address => uint) public lastPostTimestamp;
  mapping(uint => uint) postIndex;

  modifier isOwner(uint _id) {
    require(posts[postIndex[_id]].addr == msg.sender, "You do not have permission");
    _;
  }

  function getAllPosts() public view returns (Post[] memory) {
    return posts;
  }

  function createPost(string calldata _message, uint _payAmount) external {
    bool isPostPinned = false;
    uint timestamp = block.timestamp;
    uint32 id = uint32(uint(keccak256(abi.encodePacked(timestamp, msg.sender))));

    require(lastPostTimestamp[msg.sender] + 30 seconds < timestamp, "Must wait 30 seconds before posting again");

    lastPostTimestamp[msg.sender] = timestamp;
    postIndex[id] = posts.length;

    if (_payAmount > 0) {
      isPostPinned = true;
      paymentReceived(_payAmount);
    }

    generateRandomWinner();

    posts.push(Post({
      addr: msg.sender,
      id: id,
      message: _message,
      isPostPinned: isPostPinned,
      timestamp: timestamp
    }));

    emit CreatePost(posts[postIndex[id]]);
  }

  function updatePost(uint _id, string calldata _message, uint _payAmount) external isOwner(_id) {
    if (_payAmount > 0) {
      posts[postIndex[_id]].isPostPinned = true;
      paymentReceived(_payAmount);
    }

    posts[postIndex[_id]].message = _message;

    emit UpdatePost(posts);
  }

  function deletePost(uint _id) external isOwner(_id) {
    for(uint i = postIndex[_id]; i < (posts.length - 1); i++) {
      posts[i] = posts[i + 1];
      postIndex[posts[i].id] = i;
    }
    posts.pop();

    emit DeletePost(posts);
  }
}