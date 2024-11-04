// SPDX-License-Identifier: MIT

pragma solidity >=0.8.21 <0.9.0;

import "./_Owner.sol";

contract FundMe is Owner {
    event Received(address indexed sender, uint256 amount);
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw(
        address payable to_addres,
        uint256 amount
    ) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        to_addres.transfer(amount);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    fallback() external payable {
        emit Received(msg.sender, msg.value);
    }
}
