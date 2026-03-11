// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {CounterFacetV1} from "./CounterFacetV1.sol";
import {DiamondStorageLib} from "./DiamondStorageLib.sol";

contract CounterFacetV2 is CounterFacetV1 {
    function increment() external {
        DiamondStorageLib.AppStorage storage ds = DiamondStorageLib.appStorage();
        if (msg.sender != ds.owner) revert NotOwner();
        ds.value += 1;
    }

    function version() external pure override returns (uint256) {
        return 2;
    }
}
