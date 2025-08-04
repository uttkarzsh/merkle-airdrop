//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { IERC20, SafeERC20 } from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import { MerkleProof } from "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20  for IERC20;
    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_limeToken;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    constructor(bytes32 merkleRoot, IERC20 limeToken){
        i_merkleRoot = merkleRoot;
        i_limeToken = limeToken;
    }

    function claimTokens(address account, uint256 amount, bytes32[] calldata merkleProof) external{
        bytes32 leaf = keccak256(abi.encode(account, amount));
        require(MerkleProof.verify(merkleProof, i_merkleRoot, leaf), MerkleAirdrop__InvalidProof());

        i_limeToken.safeTransfer(account, amount);
    }


}