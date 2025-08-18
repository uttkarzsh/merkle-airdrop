//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { LimeToken } from "../src/LimeToken.sol";
import { MerkleAirdrop } from "../src/MerkleAirdrop.sol";
import { Script } from "forge-std/Script.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {

    bytes32 private s_merkleRoot = 0x5bb2de9dd5da7a345a753fbbb38b1ed30849b3e3c53f69989a38a055b3e2c757;
    uint256 private s_limeSupply = 4 * 25 * 1e18;

    function deployMerkleAirdrop() public returns (MerkleAirdrop, LimeToken){
        vm.startBroadcast();
        LimeToken token = new LimeToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRoot, IERC20(address(token)));
        token.mint(token.owner(), s_limeSupply);
        token.transfer(address(airdrop), s_limeSupply);
        vm.stopBroadcast();

        return(airdrop, token);
    }

    function run() external returns (MerkleAirdrop, LimeToken){
        return deployMerkleAirdrop();
    }
}