# Merkle Airdrop 🍃

A simple and secure **Merkle-based ERC20 airdrop contract** with integrated **EIP-712 signature verification**.  
This project distributes tokens to eligible users verified through a Merkle proof and a signed message, ensuring integrity and preventing double claims.
This project was built alongside the **Cyfrin Updraft Course.**

---

## 🧩 What It Does

The **Merkle Airdrop** contract allows eligible users to claim ERC20 tokens by proving their inclusion in a predefined Merkle tree.  
To enhance security, each claim also requires an **off-chain EIP-712 signature**, ensuring the claimant is indeed the owner of the address in the Merkle leaf.

---

## ⚙️ How It Works

1. **Merkle Tree Setup**  
   - The airdrop creator generates a Merkle tree off-chain using addresses and token amounts.  
   - The **Merkle root** is stored in the contract during deployment.  
   - Each leaf is computed as `keccak256(abi.encode(account, amount))`.

2. **Claiming Tokens**  
   - A user provides:
     - Their address and token amount.  
     - The **Merkle proof** showing inclusion in the tree.  
     - A **valid EIP-712 signature** proving ownership of the claiming address.  
   - The contract:
     - Verifies the Merkle proof against the stored root.  
     - Checks the signature matches the claimant.  
     - Ensures the user hasn’t already claimed.  
     - Transfers the allocated tokens safely using `SafeERC20`.

3. **Security Measures**
   - Prevents double claiming with the `claimed` mapping.  
   - Rejects invalid proofs or forged signatures.  
   - Uses OpenZeppelin’s `SafeERC20` for safe token transfers.

---

## 🧠 Tech Stack

- **Foundry** for smart contract development, deployment and testing 
- **OpenZeppelin** for ERC20 utilities and cryptography  
- **MerkleProof** for inclusion verification  
- **EIP-712 & ECDSA** for structured signature validation  

---

## ⚠️ Disclaimer

This project is for **educational purposes** and was built as a demonstration of secure Merkle airdrop mechanics.  
It should **not be used in production** without thorough audits and additional security measures.