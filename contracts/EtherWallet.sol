// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

contract EtherWallet {
    address payable public owner;
    event Received(address _sender, uint256 _amount);
    event Withdrew(address _sender, uint256 _amount);

    mapping(address => uint256) public balances;

    constructor() {
        owner = payable(msg.sender);
    }

    function withdrawal(uint256 _amount) external {
        require(msg.sender == owner, "Caller is not owner");
        payable(msg.sender).transfer(_amount);
        emit Withdrew(msg.sender, _amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        balances[msg.sender] = msg.value;
        emit Received(msg.sender, msg.value);
    }
}
