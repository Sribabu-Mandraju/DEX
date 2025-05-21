// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {PriceOracle} from "./PriceOracle.sol";
import {RareCoin} from "./Rarecoin.sol";

contract TokenExchange {
    event ExchangeSuccessful(address indexed user, uint256 skillAmount, uint256 rareAmount);

    IERC20 public immutable skillcoin;
    RareCoin public immutable rarecoin;
    PriceOracle public immutable priceOracle;

    constructor(address skill, address rare, address _priceOracle) {
        skillcoin = IERC20(skill);
        rarecoin = RareCoin(rare);
        priceOracle = PriceOracle(_priceOracle);
    }

    function exchange(uint256 skillAmount) external {
        require(skillAmount > 0, "Amount must be positive");
        require(skillcoin.balanceOf(msg.sender) >= skillAmount, "Insufficient balance");

        uint256 currentRarePrice = priceOracle.getPrice();
        require(currentRarePrice > 0, "Invalid price");

        uint256 rareAmount = skillAmount / currentRarePrice;
        require(rareAmount > 0, "Amount too small to exchange");

        // Transfer tokens from user to this contract
        bool success = skillcoin.transferFrom(msg.sender, address(this), skillAmount);
        require(success, "Transfer failed");

        rarecoin.mint(msg.sender, rareAmount);
        
        emit ExchangeSuccessful(msg.sender, skillAmount, rareAmount);
    }
}