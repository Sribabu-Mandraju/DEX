// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract PriceOracle {
    uint256 public oneRarePrice = 10; // 1 RC = 10 Skill tokens
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setPrice(uint256 _price) public {
        require(msg.sender == owner, " only admin can change the proce");
        oneRarePrice = _price;
    }

    function getPrice() public view returns (uint256) {
        return oneRarePrice;
    }
}
