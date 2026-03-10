# ERC20 Token Faucet

**Time-driven ERC20 token faucet implementation.**

# Author

**Thomas Sorza**
Solidity / Web3 Developer

# Overview

This project implements a simple **ERC20 token and a faucet smart contract** that allows users to claim tokens periodically with a cooldown and a maximum number of claims. The project was built using **Foundry** and **OpenZeppelin** as part of a Solidity learning and development workflow.
---

The repository contains two main smart contracts:

### THXToken.sol

An **ERC20 token implementation** built on top of OpenZeppelin.


### TokenFaucet.sol

A **time-based faucet contract** that distributes ERC20 tokens.

./img/TokenFaucetClass.png
---

# Contract Interaction 
./img/executionFlow.png
---

# Deployment

Deployment script:

script/DeployTHXToken.s.sol

## 📜 Deployed Contracts

### Arbitrum Sepolia Testnet

| Contract | Address |
|----------|---------|
| `TokenFaucet` | [`0x88E6277b1CfA68D47EB09d08F232d42A98A30942`](https://sepolia.arbiscan.io/address/0x88E6277b1CfA68D47EB09d08F232d42A98A30942) |

> 🔗 **Explorer:** [View on Arbiscan Sepolia](https://sepolia.arbiscan.io/address/0x88E6277b1CfA68D47EB09d08F232d42A98A30942)

---

# Testing

Tests are will be written in foundry (Not yet implemented).

