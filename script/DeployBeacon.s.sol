// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {BeaconBoxV1} from "../src/beacon/BeaconBoxV1.sol";

interface Vm {
    function envUint(string calldata name) external returns (uint256);
    function envAddress(string calldata name) external returns (address);
    function startBroadcast(uint256 privateKey) external;
    function stopBroadcast() external;
}

contract DeployBeaconScript {
    Vm internal constant VM = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run()
        external
        returns (BeaconBoxV1 impl, UpgradeableBeacon beacon, BeaconProxy proxyA, BeaconProxy proxyB)
    {
        uint256 privateKey = VM.envUint("PRIVATE_KEY");
        uint256 initialValue = VM.envUint("BEACON_INITIAL_VALUE");
        address admin = VM.envAddress("BEACON_ADMIN");
        address beaconOwner = VM.envAddress("BEACON_OWNER");

        VM.startBroadcast(privateKey);
        impl = new BeaconBoxV1();
        beacon = new UpgradeableBeacon(address(impl), beaconOwner);

        bytes memory initData = abi.encodeCall(BeaconBoxV1.initialize, (initialValue, admin));
        proxyA = new BeaconProxy(address(beacon), initData);
        proxyB = new BeaconProxy(address(beacon), initData);
        VM.stopBroadcast();
    }
}
