// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {DiamondStorageLib} from "./DiamondStorageLib.sol";

contract OwnerFacet {
    error NotOwner();
    error ZeroAddress();

    function diamondOwner() external view returns (address) {
        return DiamondStorageLib.appStorage().owner;
    }

    function transferDiamondOwnership(address newOwner) external {
        DiamondStorageLib.AppStorage storage ds = DiamondStorageLib.appStorage();
        if (msg.sender != ds.owner) revert NotOwner();
        if (newOwner == address(0)) revert ZeroAddress();
        ds.owner = newOwner;
    }
}
