//SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract THXToken is ERC20 {
    /**
     * @notice Creates the custom token with Total supply, symbol,
     * name and it's instantly generated all tokens
     */
    constructor(
        uint256 totalSupply_,
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
        _mint(msg.sender, totalSupply_);
    }
}
