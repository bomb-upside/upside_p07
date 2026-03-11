// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract UUPSBoxV1 is OwnableUpgradeable, UUPSUpgradeable {
    uint256 public value;

    function initialize(uint256 initialValue, address admin) external initializer {
        __Ownable_init(admin);
        value = initialValue;
    }

    function setValue(uint256 newValue) external onlyOwner {
        value = newValue;
    }

    function version() external pure virtual returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
