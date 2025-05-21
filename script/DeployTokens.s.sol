    // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PriceOracle} from "../src/PriceOracle.sol";
import {RareCoin} from "../src/Rarecoin.sol";
import {SkillCoin} from "../src/Skillscoin.sol";
import {TokenExchange} from "../src/TokenExchange.sol";

contract DeployTokens is Script {
    PriceOracle public priceOracle;
    RareCoin public rareCoin;
    SkillCoin public skillCoin;
    TokenExchange public tokenExchange;

    function run() public {
        console.log("Starting deployment...");

        vm.startBroadcast();

        // Deploy PriceOracle
        priceOracle = new PriceOracle();
        console.log("PriceOracle deployed at:", address(priceOracle));

        // Deploy RareCoin
        rareCoin = new RareCoin();
        console.log("RareCoin deployed at:", address(rareCoin));

        // Deploy SkillCoin
        skillCoin = new SkillCoin();
        console.log("SkillCoin deployed at:", address(skillCoin));

        // Deploy TokenExchange
        tokenExchange = new TokenExchange(address(skillCoin), address(rareCoin), address(priceOracle));
        console.log("TokenExchange deployed at:", address(tokenExchange));

        // Set exchange address in RareCoin
        rareCoin.setExchangeAddress(address(tokenExchange));
        console.log("Exchange address set in RareCoin");

        vm.stopBroadcast();

        console.log("Deployment completed successfully!");
    }
}
