//SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Faucet Smart Contract that allow claiming tokens with a cooldown and a drip amount
 * @author sh4dex
 * @notice You can get free tokens from this contract,
 * but you have to wait for the cooldown to expire before claiming again
 * @dev _cooldown, _dripAmount and _token are set in the constructor and
 * cannot be changed later, _lastClaim is a mapping that stores the
 * timestamp of the last claim for each address
 */

contract TokenFaucet {
    IERC20 public _token;
    address public _owner;
    uint256 public _dripAmount;
    uint256 public _cooldown;
    uint256 public constant MAX_CLAIMS = 20;
    bool internal locked;

    mapping(address claimer => uint256 timestamp) _lastClaim;
    mapping(address claimer => uint256 timesClaimed) _timesClaimed;

    //TODO: Use SafeERC20

    /**
     * @notice Emitted when tokens are claimed from the faucet
     * @param from The address of the account that is claiming tokens
     * @param to The address of the account that is receiving tokens
     * @param amount The amount of tokens being claimed
     */
    event tokensClaimed(address from, address to, uint256 amount);

    modifier NoMaxClaims() {
        if (_timesClaimed[msg.sender] >= MAX_CLAIMS) {
            revert MaxClaimsReached();
        }
        _;
    }

    modifier NoReentrancy() {
        if (!locked) {
            locked = true;
            _;
            locked = false;
        }
    }

    modifier NoTimeLeft() {
        if (block.timestamp - _lastClaim[msg.sender] < _cooldown) {
            revert CooldownNotExpired();
        }
        _;
    }

    modifier EnoughTokensToTransfer() {
        if (_token.balanceOf(address(this)) < _dripAmount) {
            revert NotEnoughTokens();
        }
        _;
    }

    error CooldownNotExpired();
    error NotEnoughTokens();
    error MaxClaimsReached();

    /**
     * @notice Creates contract with the specified token, drip amount and cooldown
     * @dev You need to deploy this contract with the address of the ERC20 token you want to distribute
     * @param tokenAddress_ The address of the ERC20 token to be distributed
     * @param dripAmount_ The amount of tokens to be distributed per claim
     * @param cooldown_ The minimum time (in seconds) that must pass between claims
     */
    constructor(address tokenAddress_, uint256 dripAmount_, uint256 cooldown_) {
        _token = IERC20(tokenAddress_);
        _owner = msg.sender;
        _dripAmount = dripAmount_;
        _cooldown = cooldown_;
    }

    /**  @notice Allows users to claim tokens from the faucet if they
     * have waited for the cooldown period and if the faucet has enough tokens to transfer
     * @dev emits a tokensClaimed event when tokens are claimed,
     * checks the EnoughTokensToTransfer and NoTimeLeft modifiers before allowing the claim
     */
    function claim()
        public
        NoTimeLeft
        EnoughTokensToTransfer
        NoMaxClaims
        NoReentrancy
    {
        //fixed reentrancy vulnerability by updating the state before transferring tokens
        _lastClaim[msg.sender] = block.timestamp;
        _timesClaimed[msg.sender]++;
        bool success = _token.transfer(msg.sender, _dripAmount);
        require(success, "Transfer Failed!");
        emit tokensClaimed(address(this), msg.sender, _dripAmount);
    }

    //TODO: Add owner functions
    //TODO: Add openzeppelin's ReentrancyGuard
}
