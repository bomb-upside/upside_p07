// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {DiamondStorageLib} from "./DiamondStorageLib.sol";

contract CounterFacetV1 {
    error NotOwner();

    function setValue(uint256 newValue) external {
        DiamondStorageLib.AppStorage storage ds = DiamondStorageLib.appStorage();
        if (msg.sender != ds.owner) revert NotOwner();
        ds.value = newValue;
    }

    function getValue() external view returns (uint256) {
        return DiamondStorageLib.appStorage().value;
    }

    function version() external pure virtual returns (uint256) {
        return 1;
    }
}
