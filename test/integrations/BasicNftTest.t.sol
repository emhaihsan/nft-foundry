// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assertEq(actualName, expectedName);
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "DOG";
        string memory actualSymbol = basicNft.symbol();
        // assertEq(actualSymbol, expectedSymbol);
        assert(
            keccak256(abi.encodePacked(actualSymbol)) ==
                keccak256(abi.encodePacked(expectedSymbol))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(PUG))
        );
    }
}
