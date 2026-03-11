// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {DiamondStorageLib} from "./DiamondStorageLib.sol";

contract Diamond {
    error NotOwner();
    error InvalidFacet(address facet);
    error NoFacet(bytes4 selector);

    event DiamondCut(bytes4 indexed selector, address indexed facet);

    constructor(address owner_) {
        DiamondStorageLib.appStorage().owner = owner_;
    }

    modifier onlyOwner() {
        if (msg.sender != DiamondStorageLib.appStorage().owner) revert NotOwner();
        _;
    }

    function diamondCut(bytes4[] calldata selectors, address facet) external onlyOwner {
        if (facet.code.length == 0) revert InvalidFacet(facet);
        DiamondStorageLib.AppStorage storage ds = DiamondStorageLib.appStorage();
        for (uint256 i = 0; i < selectors.length; i++) {
            ds.selectorToFacet[selectors[i]] = facet;
            emit DiamondCut(selectors[i], facet);
        }
    }

    function facetOf(bytes4 selector) external view returns (address) {
        return DiamondStorageLib.appStorage().selectorToFacet[selector];
    }

    fallback() external payable {
        address facet = DiamondStorageLib.appStorage().selectorToFacet[msg.sig];
        if (facet == address(0)) revert NoFacet(msg.sig);

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}
