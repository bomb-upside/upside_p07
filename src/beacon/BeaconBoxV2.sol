// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {BeaconBoxV1} from "./BeaconBoxV1.sol";

contract BeaconBoxV2 is BeaconBoxV1 {
    function increment() external onlyOwner {
        value += 1;
    }

    function version() external pure override returns (uint256) {
        return 2;
    }
}
