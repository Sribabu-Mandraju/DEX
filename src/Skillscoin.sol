// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SkillCoin is ERC20 {
    constructor() ERC20("SkillsCoin", "SKL") {
        _mint(msg.sender, 10000000 * 1e18);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
