// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract TheBlockchainMessenger {
    uint256 public numberOfUpdates;
    address public owner;
    string public message;

    constructor() {
        owner = msg.sender;
        numberOfUpdates = 0;
    }

    function updateMessage(string memory _newMessage) public {
        require(msg.sender == owner, "Only owner can update the message");
        message = _newMessage;
        numberOfUpdates++;
    }
}
