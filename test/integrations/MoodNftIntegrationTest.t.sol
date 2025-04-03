// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft moodNft;
    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPg0KICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIvPg0KICA8ZyBjbGFzcz0iZXllcyI+DQogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4NCiAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiLz4NCiAgPC9nPg0KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+DQo8L3N2Zz4=";
    string public constant SAD_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyBpZD0iZVI3cTRvandLY1YxIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2aWV3Qm94PSIwIDAgMzAwIDMwMCIgc2hhcGUtcmVuZGVyaW5nPSJnZW9tZXRyaWNQcmVjaXNpb24iIHRleHQtcmVuZGVyaW5nPSJnZW9tZXRyaWNQcmVjaXNpb24iIHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOnRyYW5zcGFyZW50Ij48ZWxsaXBzZSByeD0iNzguMDYzMDEiIHJ5PSI3My44NjIzMSIgdHJhbnNmb3JtPSJtYXRyaXgoMS41MzM2NDUgMCAwIDEuNTkwMDUgMTUwIDE1MCkiIGZpbGw9IiNlN2VkMDAiIHN0cm9rZS13aWR0aD0iMCIvPjxlbGxpcHNlIHJ4PSIzMCIgcnk9IjMwIiB0cmFuc2Zvcm09Im1hdHJpeCguNDkwMDkgMCAwIDAuNDkwMDgzIDEwNC40OTI0MTYgMTIxLjgyMDMwMykiIHN0cm9rZS13aWR0aD0iMCIvPjxlbGxpcHNlIHJ4PSIzMCIgcnk9IjMwIiB0cmFuc2Zvcm09Im1hdHJpeCguNDkwMDkgMCAwIDAuNDkwMDgzIDE5Ni4yMDc3MDcgMTIxLjgyMDMwMykiIHN0cm9rZS13aWR0aD0iMCIvPjxwYXRoIHN0eWxlPSJtaXgtYmxlbmQtbW9kZTpkYXJrZW4iIGQ9Ik0xMDEuNjkxOTUsMjA1LjgzNDMxYzE1LjM1MTkwOC00OC4zNjI4MDUsNzguMzM4NzctNTUuMzQ3MzQ1LDkzLjExNTUyLDIuODAwNDciIHRyYW5zZm9ybT0idHJhbnNsYXRlKDEuNzUwMjkgMTEuMjAxODY3KSIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwIiBzdHJva2Utd2lkdGg9IjAuNiIvPjwvc3ZnPg==";

    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUJwWkQwaVpWSTNjVFJ2YW5kTFkxWXhJaUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSGh0Ykc1ek9uaHNhVzVyUFNKb2RIUndPaTh2ZDNkM0xuY3pMbTl5Wnk4eE9UazVMM2hzYVc1cklpQjJhV1YzUW05NFBTSXdJREFnTXpBd0lETXdNQ0lnYzJoaGNHVXRjbVZ1WkdWeWFXNW5QU0puWlc5dFpYUnlhV05RY21WamFYTnBiMjRpSUhSbGVIUXRjbVZ1WkdWeWFXNW5QU0puWlc5dFpYUnlhV05RY21WamFYTnBiMjRpSUhOMGVXeGxQU0ppWVdOclozSnZkVzVrTFdOdmJHOXlPblJ5WVc1emNHRnlaVzUwSWo0OFpXeHNhWEJ6WlNCeWVEMGlOemd1TURZek1ERWlJSEo1UFNJM015NDROakl6TVNJZ2RISmhibk5tYjNKdFBTSnRZWFJ5YVhnb01TNDFNek0yTkRVZ01DQXdJREV1TlRrd01EVWdNVFV3SURFMU1Da2lJR1pwYkd3OUlpTmxOMlZrTURBaUlITjBjbTlyWlMxM2FXUjBhRDBpTUNJdlBqeGxiR3hwY0hObElISjRQU0l6TUNJZ2NuazlJak13SWlCMGNtRnVjMlp2Y20wOUltMWhkSEpwZUNndU5Ea3dNRGtnTUNBd0lEQXVORGt3TURneklERXdOQzQwT1RJME1UWWdNVEl4TGpneU1ETXdNeWtpSUhOMGNtOXJaUzEzYVdSMGFEMGlNQ0l2UGp4bGJHeHBjSE5sSUhKNFBTSXpNQ0lnY25rOUlqTXdJaUIwY21GdWMyWnZjbTA5SW0xaGRISnBlQ2d1TkRrd01Ea2dNQ0F3SURBdU5Ea3dNRGd6SURFNU5pNHlNRGMzTURjZ01USXhMamd5TURNd015a2lJSE4wY205clpTMTNhV1IwYUQwaU1DSXZQanh3WVhSb0lITjBlV3hsUFNKdGFYZ3RZbXhsYm1RdGJXOWtaVHBrWVhKclpXNGlJR1E5SWsweE1ERXVOamt4T1RVc01qQTFMamd6TkRNeFl6RTFMak0xTVRrd09DMDBPQzR6TmpJNE1EVXNOemd1TXpNNE56Y3ROVFV1TXpRM016UTFMRGt6TGpFeE5UVXlMREl1T0RBd05EY2lJSFJ5WVc1elptOXliVDBpZEhKaGJuTnNZWFJsS0RFdU56VXdNamtnTVRFdU1qQXhPRFkzS1NJZ1ptbHNiRDBpYm05dVpTSWdjM1J5YjJ0bFBTSWpNREF3SWlCemRISnZhMlV0ZDJsa2RHZzlJakF1TmlJdlBqd3ZjM1puUGc9PSJ9";

    DeployMoodNft deployer;

    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        console.log(moodNft.tokenURI(0));

        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(SAD_SVG_URI))
        );
    }
}
