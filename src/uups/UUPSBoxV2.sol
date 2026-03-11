// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {UUPSBoxV1} from "./UUPSBoxV1.sol";

contract UUPSBoxV2 is UUPSBoxV1 {
    function increment() external onlyOwner {
        value += 1;
    }

    function version() external pure override returns (uint256) {
        return 2;
    }
}
