// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenMano is ERC20, Ownable {
    constructor(address initialOwner)
        ERC20("TokenMano", "TmK")
        Ownable(initialOwner)
    {
        mint(initialOwner, 2000);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}