// SPDX-License-Identifier: MIT

pragma solidity >=0.8.21 <0.9.0;

contract Owner {
    address payable private owner;
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner allowed to call this function"
        );
        _;
    }

    constructor() {
        owner = payable(msg.sender);
        emit OwnerSet(address(0), owner);
    }

    function changeOwner(address payable newOwner) public onlyOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    function getOwner() external view returns (address payable) {
        return owner;
    }
}
