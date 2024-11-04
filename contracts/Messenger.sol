// SPDX-License-Identifier: MIT

pragma solidity >=0.8.21 <0.9.0;

contract Messenger {
    uint256 public numberOfUpdates;
    address public owner;
    string public message = "inital deployment";

    constructor() {
        owner = msg.sender;
        numberOfUpdates = 0;
    }

    function updateMessage(string memory _newMessage) public {
        require(msg.sender == owner, "Only owner can update the message");
        message = _newMessage;
        numberOfUpdates++;
    }

    function viewMessage() public view returns (string memory) {
        return message;
    }
}
