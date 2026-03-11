// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UUPSBoxV1} from "../src/uups/UUPSBoxV1.sol";

interface Vm {
    function envUint(string calldata name) external returns (uint256);
    function envAddress(string calldata name) external returns (address);
    function startBroadcast(uint256 privateKey) external;
    function stopBroadcast() external;
}

contract DeployUUPSScript {
    Vm internal constant VM = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() external returns (UUPSBoxV1 impl, ERC1967Proxy proxy) {
        uint256 privateKey = VM.envUint("PRIVATE_KEY");
        uint256 initialValue = VM.envUint("UUPS_INITIAL_VALUE");
        address admin = VM.envAddress("UUPS_ADMIN");

        VM.startBroadcast(privateKey);
        impl = new UUPSBoxV1();
        bytes memory initData = abi.encodeCall(UUPSBoxV1.initialize, (initialValue, admin));
        proxy = new ERC1967Proxy(address(impl), initData);
        VM.stopBroadcast();
    }
}
