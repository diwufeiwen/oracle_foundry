// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract OracleContract {
    address private _owner;
    uint256 private _fee = 0.01 ether;

    // mapping for storing computational logic & register
    uint256 private _logicCounter;
    mapping(uint256 => address) private _logicRegistry;
    mapping(uint256 => address) private _logicOwners;

    event LogDonate(address indexed from, uint256 amount);
    event ComputationRequested(address indexed requester, uint256 indexed id, string jsonData, uint256 logicId);
    event ResultReady(address indexed requester, uint256 indexed id, uint256 result);
    event LogicRegistered(uint256 indexed logicId, address logicAddress, address indexed owner);

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

    modifier onlyLogicOwner(uint256 logicId) {
        require(msg.sender == _logicOwners[logicId], "Only the logic owner can perform this action");
        _;
    }

    constructor() {
        _logicCounter = 0;
        _owner = msg.sender;
    }

    function registerLogic(address logicAddress) public {
        _logicCounter++;
        _logicRegistry[_logicCounter] = logicAddress;
        _logicOwners[_logicCounter] = msg.sender;
        
        emit LogicRegistered(_logicCounter, logicAddress, msg.sender);
    }

    function compute(uint256 id, string memory jsonData, uint256 logicId) public payable {
        require(msg.value >= _fee, "Insufficient fee provided");

        require(_logicRegistry[logicId] != address(0), "Logic ID does not exist");
        
        require(_logicOwners[logicId] == msg.sender, "You can only call your own registered logic");

        emit ComputationRequested(msg.sender, id, jsonData, logicId);

         // Transfer the fee to the owner or the contract itself
        payable(_owner).transfer(_fee);
        
        // If there's any excess amount sent, refund it back to the caller
        if (msg.value > _fee) {
            payable(msg.sender).transfer(msg.value - _fee);
        }
    }

    function writeResult(address requester, uint256 id, uint256 result) public onlyLogicOwner(id) {
        emit ResultReady(requester, id, result);
    }

    function setFee(uint256 newFee) public onlyOwner {
        _fee = newFee;
    }

    function getFee() public view returns (uint256)  {
        return _fee;
    }

    function withdraw(address payable recipient) public onlyOwner {
        recipient.transfer(address(this).balance);
    }

    receive() external payable {
        emit LogDonate(msg.sender, msg.value);
    }
}
