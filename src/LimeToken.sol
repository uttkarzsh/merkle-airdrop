//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract LimeToken is ERC20, Ownable{
    constructor() ERC20("LimeToken", "LTK") Ownable(msg.sender) {
    }

    function mint(address account, uint256 amount) external onlyOwner{
        _mint(account, amount);
    }
}
