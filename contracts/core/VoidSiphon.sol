// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./libs/Verifier.sol";

/**
 * @title VoidSiphon Mixer
 * @dev Implements a non-custodial privacy pool using zk-SNARKs.
 * Users deposit assets and receive a commitment. 
 * Withdrawal requires a zero-knowledge proof that the commitment exists in the Merkle tree.
 */
contract VoidSiphon {
    Verifier public immutable verifier;
    address public immutable admin;
    
    // Merkle Tree root of all commitments
    bytes32 public root;
    
    // Mapping from nullifier hash to boolean to prevent double-spending
    mapping(bytes32 => bool) public nullifiers;
    
    // Event emitted on deposit
    event Deposit(address indexed sender, bytes32 commitment, uint256 amount);
    
    // Event emitted on withdrawal
    event Withdraw(address indexed receiver, bytes32 nullifierHash, uint256 amount);

    constructor(address _verifier) {
        verifier = Verifier(_verifier);
        admin = msg.sender;
    }

    /**
     * @notice Deposit assets into the privacy pool.
     * @param commitment The zk-commitment (hash of secret + nullifier).
     */
    function deposit(bytes32 commitment) external payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");
        
        // In a full implementation, we would update the Merkle Tree here
        // and update the 'root' variable.
        
        emit Deposit(msg.sender, commitment, msg.value);
    }

    /**
     * @notice Withdraw assets using a ZK proof.
     * @param root The Merkle root at the time of deposit.
     * @param nullifierHash The hash of the nullifier to prevent double-spending.
     * @param proof The zk-SNARK proof.
     * @param receiver The address to receive the assets.
     */
    function withdraw(
        bytes32 root,
        bytes32 nullifierHash,
        uint256[] calldata proof,
        address payable receiver
    ) external {
        require(!nullifiers[nullifierHash], "Nullifier already used");
        
        // Verify the ZK proof against the provided root and nullifier
        require(verifier.verifyProof(proof, root, nullifierHash), "Invalid ZK proof");
        
        // Mark nullifier as used
        nullifiers[nullifierHash] = true;
        
        // Transfer the fixed amount (e.g., 1 ETH) to the receiver
        // In a production system, this would be the amount deposited.
        payable(receiver).transfer(1 ether);
        
        emit Withdraw(receiver, nullifierHash, 1 ether);
    }

    function updateRoot(bytes32 _newRoot) external {
        require(msg.sender == admin, "Only admin can update root");
        root = _newRoot;
    }
}
