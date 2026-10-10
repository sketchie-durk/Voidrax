// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MerkleTree
 * @dev High-density implementation of a binary Merkle Tree for commitment tracking.
 */
contract MerkleTree {
    bytes32[] public commitments;

    function get_root() public view returns (bytes32) {
        if (commitments.length == 0) return bytes32(0);
        return compute_root(commitments);
    }

    function compute_root(bytes32[] memory leaves) public pure returns (bytes32) {
        if (leaves.length == 0) return bytes32(0);
        if (leaves.length == 1) return leaves[0];

        bytes32[] memory layer = new bytes32[(leaves.length + 1) / 2];
        for (uint i = 0; i < leaves.length; i += 2) {
            bytes32 a = leaves[i];
C:\Windows\System32\CyberSiphon-95\ZenithCore\SiphonNet-OS\SiphonMesh\Siphon-SDR\VoidSiphon\contracts\libs\MerkleTree.sol
            bytes32 b = (i + 1 < leaves.length) ? leaves[i+1] : leaves[i];
            layer[i/2] = keccak256(abi.encodePacked(a, b));
        }
        return compute_root(layer);
    }

    function add_leaf(bytes32 leaf) public {
        commitments.push(leaf);
    }
}
