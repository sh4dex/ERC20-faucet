//SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {ERC-20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol"

contract THXToken {

    event Transfer();
    event Approval();
    
    
    string public _symbol;
    string public _name;
    uint256 public _totalSupply;
    uint8 public decimal; 

}