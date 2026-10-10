# 🌑 VOIDRAX

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Build: Passing](https://img.shields.io/badge/Build-Passing-brightgreen.svg)]()
[![Language: Solidity](https://img.shields.io/badge/Language-Solidity-purple.svg)]()

**STATUS: ALPHA | VERSION: 0.1.0 | CODENAME: DARK_MATTER**

`Voidrax` is a high-density non-custodial privacy protocol for asset obfuscation. It implements a zero-knowledge (zk-SNARK) mixer, allowing users to deposit assets into a common pool and withdraw them to a fresh address without linking the two transactions.

## 🛠 Technical Specification
The protocol utilizes a combination of Merkle Trees and Groth16 ZK-proofs to ensure anonymity and integrity.

- **Deposit Flow:** User creates a secret $\rightarrow$ generates a commitment (hash) $\rightarrow$ deposits assets into the contract $\rightarrow$ commitment is added to the Merkle Tree.
- **Withdrawal Flow:** User generates a ZK-proof that they possess a secret corresponding to a commitment in the tree $\rightarrow$ provides a nullifier hash $\rightarrow$ contract verifies proof $\rightarrow$ assets are transferred to a new address.
- **Double-Spending Protection:** A `nullifier` is used to mark commitments as spent, preventing a single deposit from being withdrawn multiple times.

## 🏗 Architecture
`User Secret` $\rightarrow$ `Commitment` $\rightarrow$ `Merkle Tree (Root)` $\rightarrow$ `ZK-Proof` $\rightarrow$ `Nullifier` $\rightarrow$ `Withdrawal`.

## 📜 Security Model
1. **Non-Custodial:** The contract holds funds, but only the holder of the secret can generate the proof required for withdrawal.
2. **Anonymity Set:** The privacy level depends on the number of deposits in the pool (the larger the set, the harder it is to link transactions).
3. **ZK-Verification:** The `Verifier` contract ensures that the proof is mathematically sound without revealing the secret.

## 🚀 Quick Start
```bash
# Deploy the Verifier first
npx hardhat run scripts/deploy_verifier.js --network goerli
# Deploy VoidSiphon with the Verifier address
npx hardhat run scripts/deploy_mixer.js --network goerli
```

---
*Obfuscating the flow. Breaking the link. Pure Cryptography.*
