// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./libs/Verifier.sol";
import "./libs/MerkleTree.sol";

/**
 * @title Voidrax Mixer
 * @dev High-density non-custodial privacy pool using zk-SNARKs.
 * Implements an optimized Merkle Tree for commitment management.
 */
contract Voidrax {
    Verifier public immutable verifier;
    MerkleTree public immutable tree;
    address public immutable admin;
    
    bytes32 public root;
    mapping(bytes32 => bool) public nullifiers;
    
    event Deposit(address indexed sender, bytes32 commitment, uint256 amount);
    event Withdraw(address indexed receiver, bytes32 nullifierHash, uint256 amount);

    constructor(address _verifier) {
        verifier = Verifier(_verifier);
        tree = new MerkleTree();
        admin = msg.sender;
    }

    function deposit(bytes32 commitment) external payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");
        
        tree.add_leaf(commitment);
        root = tree.get_root();
        
        emit Deposit(msg.sender, commitment, msg.value);
    }

    function withdraw(
        bytes32 root,
        bytes32 nullifierHash,
        uint256[] calldata proof,
        address payable receiver
    ) external {
        require(!nullifiers[nullifierHash], "Nullifier already used");
        require(verifier.verifyProof(proof, root, nullifierHash), "Invalid ZK proof");
        
        nullifiers[nullifierHash] = true;
        payable(receiver).transfer(1 ether);
        
        emit Withdraw(receiver, nullifierHash, 1 ether);
    }

    function updateRoot(bytes32 _newRoot) external {
        require(msg.sender == admin, "Only admin can update root");
        root = _newRoot;
    }
}
