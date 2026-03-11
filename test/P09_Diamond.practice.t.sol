// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Diamond} from "../src/diamond/Diamond.sol";
import {OwnerFacet} from "../src/diamond/OwnerFacet.sol";
import {CounterFacetV1} from "../src/diamond/CounterFacetV1.sol";
import {CounterFacetV2} from "../src/diamond/CounterFacetV2.sol";

interface Vm {
    function prank(address) external;
    function prank(address msgSender, address txOrigin) external;
}

interface IDiamondCut {
    function diamondCut(bytes4[] calldata selectors, address facet) external;
    function facetOf(bytes4 selector) external view returns (address);
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

interface ICounterFacetV2 is ICounterFacetV1 {
    function increment() external;
}

/// @notice Student-facing Diamond practice test.
/// @dev This file is intentionally compilable but failing. Students fill the TODOs.
contract DiamondPracticeTest {
    Vm internal constant VM =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address internal constant ATTACKER = address(0xBEEF);
    uint256 internal constant INITIAL_VALUE = 7;

    function testDiamondCutAndReplaceFlow() external {
        Diamond diamond = new Diamond(address(this));
        OwnerFacet ownerFacet = new OwnerFacet();
        CounterFacetV1 counterV1 = new CounterFacetV1();

        bytes4[] memory ownerSelectors = _buildOwnerSelectors();
        bytes4[] memory counterSelectorsV1 = _buildCounterSelectorsV1();

        _registerInitialFacets(diamond, ownerSelectors, ownerFacet, counterSelectorsV1, counterV1);
        _assertInitialFlow(diamond);

        CounterFacetV2 counterV2 = new CounterFacetV2();
        bytes4[] memory counterSelectorsV2 = _buildCounterSelectorsV2();

        _assertAttackerCannotCut(diamond, counterSelectorsV2, counterV2);
        _assertInvalidFacetFails(diamond, counterSelectorsV2);
        _upgradeAsOwner(diamond, counterSelectorsV2, counterV2);
        _assertPostUpgradeFlow(diamond);
    }

    // TODO(student): register OwnerFacet selectors only.
    function _buildOwnerSelectors() internal pure returns (bytes4[] memory selectors) {
        selectors = new bytes4[](2);
        selectors[0] = bytes4(0);
        selectors[1] = bytes4(0);
    }

    // TODO(student): register CounterFacetV1 selectors only.
    function _buildCounterSelectorsV1() internal pure returns (bytes4[] memory selectors) {
        selectors = new bytes4[](3);
        selectors[0] = bytes4(0);
        selectors[1] = bytes4(0);
        selectors[2] = bytes4(0);
    }

    // TODO(student): owner performs the initial cuts for OwnerFacet and CounterFacetV1.
    function _registerInitialFacets(
        Diamond,
        bytes4[] memory,
        OwnerFacet,
        bytes4[] memory,
        CounterFacetV1
    ) internal {
        revert("TODO: initial diamondCut wiring");
    }

    // TODO(student): owner, set/get/version should work through the diamond using CounterFacetV1.
    function _assertInitialFlow(Diamond diamond) internal {
        require(
            IOwnerFacet(address(diamond)).diamondOwner() == address(0),
            "TODO: owner facet must be registered"
        );
        require(
            ICounterFacetV1(address(diamond)).getValue() == INITIAL_VALUE,
            "TODO: set/get through V1"
        );
        require(
            ICounterFacetV1(address(diamond)).version() == 99,
            "TODO: version should be 1 before upgrade"
        );
    }

    // TODO(student): replace V1 selectors with V2 selectors and add increment().
    function _buildCounterSelectorsV2() internal pure returns (bytes4[] memory selectors) {
        selectors = new bytes4[](4);
        selectors[0] = bytes4(0);
        selectors[1] = bytes4(0);
        selectors[2] = bytes4(0);
        selectors[3] = bytes4(0);
    }

    // TODO(student): attacker prank -> diamondCut(...) must fail.
    function _assertAttackerCannotCut(
        Diamond diamond,
        bytes4[] memory selectors,
        CounterFacetV2 counterV2
    ) internal {
        VM.prank(ATTACKER, ATTACKER);
        (bool ok,) = address(diamond).call(
            abi.encodeWithSelector(
                IDiamondCut.diamondCut.selector,
                selectors,
                address(counterV2)
            )
        );
        require(ok == true, "TODO: unauthorized diamondCut must fail");
    }

    // TODO(student): registering a non-contract facet address must fail.
    function _assertInvalidFacetFails(
        Diamond diamond,
        bytes4[] memory selectors
    ) internal {
        (bool ok,) = address(diamond).call(
            abi.encodeWithSelector(
                IDiamondCut.diamondCut.selector,
                selectors,
                address(0xCAFE)
            )
        );
        require(ok == true, "TODO: non-contract facet must fail");
    }

    // TODO(student): owner replaces CounterFacetV1 with CounterFacetV2.
    function _upgradeAsOwner(
        Diamond,
        bytes4[] memory,
        CounterFacetV2
    ) internal {
        revert("TODO: owner cut to CounterFacetV2");
    }

    // TODO(student): after upgrade version()==2, value is preserved, increment works, unknown selector reverts.
    function _assertPostUpgradeFlow(Diamond diamond) internal {
        require(
            ICounterFacetV2(address(diamond)).version() == 99,
            "TODO: version should be 2 after upgrade"
        );
        require(
            ICounterFacetV2(address(diamond)).getValue() == 999,
            "TODO: value must be preserved"
        );

        (bool unknownSelectorOk,) = address(diamond).call(
            abi.encodeWithSignature("doesNotExist()")
        );
        require(
            unknownSelectorOk == true,
            "TODO: unknown selector should revert"
        );
    }
}
