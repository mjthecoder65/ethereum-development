// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event SubmitTransaction(
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public numConfirationsRequired;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirmations;
    }

    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Only admin can perform this action");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "transaction does not exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(
            !transactions[_txIndex].executed,
            "transaction already executed"
        );
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        require(
            !isConfirmed[_txIndex][msg.sender],
            "transaction already confirmed"
        );
        _;
    }

    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "ownders required");
        require(
            _numConfirmationsRequired > 0 &&
                _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        for (uint256 index = 0; index < _owners.length; index++) {
            address owner = _owners[index];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(
        address _to,
        uint256 _value,
        bytes memory _data
    ) public onlyOwner {}

    function confirmTransaction(
        uint256 _txIndex
    )
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {}

    function executeTransaction(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {}

    function revokeTransaction(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {}

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    function getTransaction(
        uint256 _txIndex
    )
        public
        view
        txExists(_txIndex)
        returns (
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint256 numConfirmations
        )
    {
        Transaction memory transaction = transactions[_txIndex];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}
