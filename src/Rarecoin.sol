// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RareCoin is ERC20 {
    address public exchangeAddress;
    address public owner;

    modifier onlyExchangeAddress() {
        require(msg.sender == exchangeAddress, "Unauthourized function call");
        _;
    }

    constructor() ERC20("RareCoin", "RC") {
        owner = msg.sender;
        _mint(msg.sender, 1000000 * 1e18);
    }

    function setExchangeAddress(address _exchangeAddress) public {
        require(msg.sender == owner, "only owners can call this function");
        exchangeAddress = _exchangeAddress;
    }

    function mint(address to, uint256 amount) public onlyExchangeAddress {
        _mint(to, amount);
    }
}
