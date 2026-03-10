//SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenFaucet {
    IERC20 public _token;
    address public _owner;
    uint256 public _dripAmount;
    uint256 public _cooldown;

    mapping(address claimer => uint256 timestamp) _lastClaim;

    modifier NoTimeLeft() {
        if (block.timestamp - _lastClaim[msg.sender] < _cooldown) {
            revert();
        }
        _;
    }

    modifier EnoughTokensToTransfer() {
        if (_token.balanceOf(address(this)) < _dripAmount) {
            revert();
        }
        _;
    }

    event tokensClaimed(address from, address to, uint256 amount);

    constructor(address tokenAddress_, uint256 dripAmount_, uint256 cooldown_) {
        _token = IERC20(tokenAddress_);
        _owner = msg.sender;
        _dripAmount = dripAmount_;
        _cooldown = cooldown_;
    }

    function claim() public NoTimeLeft EnoughTokensToTransfer {
        _lastClaim[msg.sender] = block.timestamp;
        _token.transfer(msg.sender, _dripAmount);
        emit tokensClaimed(address(this), msg.sender, _dripAmount);
    }
}
