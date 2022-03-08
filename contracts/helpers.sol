// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Helpers {
  uint private seed;
  address payable public owner;

  constructor() payable {
    seed = (block.timestamp + block.difficulty) % 100;
    owner = payable(msg.sender);
  }

  function paymentReceived(uint _payAmount) internal {
    uint cost = 0.001 ether;
    require(_payAmount <= cost, "Insufficient Ether provided");
    (bool success, ) = owner.call{value: _payAmount}("");
    require(success, "Failed to send money");
  }

  function generateRandomWinner() internal {
    seed = (block.timestamp + block.difficulty + seed) % 100;
    if (seed <= 50) {
      uint prizeAmount = 0.0001 ether;
      require(prizeAmount <= address(this).balance, "Contract does not have enough funds.");
      (bool success, ) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Failed to withdraw money from contract.");
    }
  }

}