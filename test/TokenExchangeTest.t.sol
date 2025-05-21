// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployTokens} from "../script/DeployTokens.s.sol";
import {PriceOracle} from "../src/PriceOracle.sol";
import {RareCoin} from "../src/Rarecoin.sol";
import {SkillCoin} from "../src/Skillscoin.sol";
import {TokenExchange} from "../src/TokenExchange.sol";

contract DeployTokensTest is Test {
    DeployTokens deployer;
    PriceOracle priceOracle;
    RareCoin rareCoin;
    SkillCoin skillCoin;
    TokenExchange tokenExchange;

    address owner = address(0xABCD);
    address user1 = address(0x1);
    address user2 = address(0x2);
    address user3 = address(0x3);

    function setUp() public {
        vm.startPrank(owner);
        priceOracle = new PriceOracle();
        skillCoin = new SkillCoin();
        rareCoin = new RareCoin();
        tokenExchange = new TokenExchange(address(skillCoin), address(rareCoin), address(priceOracle));
        rareCoin.setExchangeAddress(address(tokenExchange));
        vm.stopPrank();
    }
    // testing price oracle

    function testPrice() public view {
        assertEq(priceOracle.getPrice(), 10);
    }

    function testOwnerForPriceOracle() public view {
        assertEq(owner, priceOracle.owner());
    }

    //testing skillcoin
    // any one can mint tokens for practice purose only
    function testMintingTokens() public {
        vm.prank(user1);
        skillCoin.mint(user2, 10);
        assertEq(skillCoin.balanceOf(user2), 10);
    }

    //testing rareCoin
    function testRareCoinOwner() public {
        assertEq(owner, rareCoin.owner());
    }

    function testExchangAddress() public {
        assertEq(address(tokenExchange), rareCoin.exchangeAddress());
    }

    function testMintngInRareCoint() public {
        vm.expectRevert();
        rareCoin.mint(user1, 10);
        //initial balance
        assertEq(rareCoin.balanceOf(user1), 0);

        vm.prank(address(tokenExchange));
        rareCoin.mint(user1, 10);
        assertEq(rareCoin.balanceOf(user1), 10);
    }

    //test tokenExchage

    function testExchange() public {
        skillCoin.mint(user1, 1000 * 1e18);
        
        vm.prank(user1);
        skillCoin.approve(address(tokenExchange), 1000 * 1e18);
        
        vm.prank(user1);
        tokenExchange.exchange(10);
        
        assertEq(skillCoin.balanceOf(address(tokenExchange)), 10);
        assertEq(rareCoin.balanceOf(user1), 1);
    }
}
