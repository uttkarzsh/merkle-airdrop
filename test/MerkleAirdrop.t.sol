//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { MerkleAirdrop } from "../src/MerkleAirdrop.sol";
import { LimeToken } from "../src/LimeToken.sol";
import { ZkSyncChainChecker } from "foundry-devops/src/ZkSyncChainChecker.sol";
import { DeployMerkleAirdrop } from "../script/DeployMerkleAirDrop.s.sol";
 
contract MerkleAirdropTest is ZkSyncChainChecker, Test {
    MerkleAirdrop airdrop;
    LimeToken limetoken;

    address user1; uint256 key1;
    bytes32 u1p1 = 0x8ebcc963f0588d1ded1ebd0d349946755f27e95d1917f9427a207d8935e04d4b;
    bytes32 u1p2 = 0xfb662b1311feb9dee0de19fdf6c105db030b8d708b95ef5c3357cad529af5f42;
    bytes32[] proof1 = [u1p1, u1p2];
    address user2; uint256 key2;
    address user3; uint256 key3;
    address user4; uint256 key4;
    bytes32 ROOT = 0x5bb2de9dd5da7a345a753fbbb38b1ed30849b3e3c53f69989a38a055b3e2c757;
    uint256 AMOUNT = 25 * 1e18;
    uint256 SUPPLY = 4 * AMOUNT;

    function setUp() public{
        if(!isZkSyncChain()){
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (airdrop, limetoken) = deployer.deployMerkleAirdrop();
        } else {
            limetoken = new LimeToken();
            airdrop = new MerkleAirdrop(ROOT, limetoken);
            limetoken.mint(limetoken.owner(), SUPPLY);
            limetoken.transfer(address(airdrop), SUPPLY);
        }

        (user1, key1) = makeAddrAndKey("user1");
        (user2, key2) = makeAddrAndKey("user2");
        (user3, key3) = makeAddrAndKey("user3");
        (user4, key4) = makeAddrAndKey("user4");
    }

    function testClaimTokens() public {
        uint256 initialBalanceU1 = limetoken.balanceOf(user1);
        bytes32 digest = airdrop.getMessageHash(user1, AMOUNT);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(key1, digest);
        vm.prank(user2);
        airdrop.claimTokens(user1, AMOUNT, proof1, v, r, s);
        uint256 finalBalanceU1 = limetoken.balanceOf(user1);

        console.log("Balance : ", finalBalanceU1);
        assertEq(finalBalanceU1 - initialBalanceU1, AMOUNT);
    }
}