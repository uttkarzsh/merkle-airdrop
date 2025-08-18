//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { IERC20, SafeERC20 } from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import { MerkleProof } from "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import { EIP712 } from "openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol";
import { ECDSA } from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop is EIP712{
    using SafeERC20  for IERC20;
    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_limeToken;
    mapping(address=>bool) private claimed;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop_InvalidSignature();

    event ClaimedToken(address account, uint256 amount);

    bytes32 MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account, uint256 amount)");

    struct AirdropClaim {
        address account;
        uint256 amount;
    }

    constructor(bytes32 merkleRoot, IERC20 limeToken) EIP712("Airdrop", "1"){
        i_merkleRoot = merkleRoot;
        i_limeToken = limeToken;
    }

    function claimTokens(address account, uint256 amount, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s) external{
        require(claimed[account]==false, MerkleAirdrop__AlreadyClaimed());
        require(_isValidSignature(account, getMessageHash(account,amount), v, r, s), MerkleAirdrop_InvalidSignature());
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        require(MerkleProof.verify(merkleProof, i_merkleRoot, leaf), MerkleAirdrop__InvalidProof());

        claimed[account] = true;
        i_limeToken.safeTransfer(account, amount);
        emit ClaimedToken(account, amount);
    }

    function getMessageHash(address account, uint256 amount) public view returns(bytes32){
        return _hashTypedDataV4(
            keccak256(abi.encode(MESSAGE_TYPEHASH, AirdropClaim({account:account, amount:amount})))
        );
    }

    function _isValidSignature(address account, bytes32 digest, uint8 v, bytes32 r, bytes32 s) internal pure returns(bool) {
        (address actualSigner,,) = ECDSA.tryRecover(digest, v, r, s);
        return account == actualSigner;
    }

    function getMerkleRoot() view public returns(bytes32){
        return i_merkleRoot;
    }

    function getTokenAddress() view public returns(IERC20){
        return i_limeToken;
    }

}