// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Diamond} from "../src/diamond/Diamond.sol";
import {OwnerFacet} from "../src/diamond/OwnerFacet.sol";
import {CounterFacetV1} from "../src/diamond/CounterFacetV1.sol";

interface Vm {
    function envUint(string calldata name) external returns (uint256);
    function envAddress(string calldata name) external returns (address);
    function startBroadcast(uint256 privateKey) external;
    function stopBroadcast() external;
}

interface IDiamondCut {
    function diamondCut(bytes4[] calldata selectors, address facet) external;
}

interface IOwnerFacet {
    function diamondOwner() external view returns (address);
    function transferDiamondOwnership(address newOwner) external;
}

interface ICounterFacetV1 {
    function setValue(uint256 newValue) external;
    function getValue() external view returns (uint256);
    function version() external view returns (uint256);
}

contract DeployDiamondScript {
    Vm internal constant VM = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() external returns (Diamond diamond, OwnerFacet ownerFacet, CounterFacetV1 counterFacet) {
        uint256 privateKey = VM.envUint("PRIVATE_KEY");
        address owner = VM.envAddress("DIAMOND_OWNER");

        VM.startBroadcast(privateKey);

        diamond = new Diamond(owner);
        ownerFacet = new OwnerFacet();
        counterFacet = new CounterFacetV1();

        bytes4[] memory ownerSelectors = new bytes4[](2);
        ownerSelectors[0] = IOwnerFacet.diamondOwner.selector;
        ownerSelectors[1] = IOwnerFacet.transferDiamondOwnership.selector;

        bytes4[] memory counterSelectors = new bytes4[](3);
        counterSelectors[0] = ICounterFacetV1.setValue.selector;
        counterSelectors[1] = ICounterFacetV1.getValue.selector;
        counterSelectors[2] = ICounterFacetV1.version.selector;

        IDiamondCut(address(diamond)).diamondCut(ownerSelectors, address(ownerFacet));
        IDiamondCut(address(diamond)).diamondCut(counterSelectors, address(counterFacet));

        VM.stopBroadcast();
    }
}
