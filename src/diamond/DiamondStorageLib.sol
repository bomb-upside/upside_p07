// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

library DiamondStorageLib {
    bytes32 internal constant SLOT = keccak256("p07.proxy.diamond.storage");

    struct AppStorage {
        address owner;
        uint256 value;
        mapping(bytes4 => address) selectorToFacet;
    }

    function appStorage() internal pure returns (AppStorage storage ds) {
        bytes32 slot = SLOT;
        assembly {
            ds.slot := slot
        }
    }
}
