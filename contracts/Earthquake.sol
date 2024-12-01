// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Earthquake is ChainlinkClient, Ownable(msg.sender) {
    using Chainlink for Chainlink.Request;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    struct EarthquakeData {
        uint256 prefCode;
        uint256 maxScale; 
        uint256 quakeScore; 
    }

    mapping(uint256 => EarthquakeData) public earthquakeInfo;

    constructor(address _oracle, address _link) {
        _setChainlinkToken(_link);
        _setChainlinkOracle(_oracle);
        jobId = "1"; 
        fee = 0.1 * 10 ** 18; 
    }

    function requestEarthquakeData() public {
        Chainlink.Request memory request = _buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        Chainlink._add(request, "post", "");
        Chainlink._add(request, "path", "data.prefectures");

        _sendChainlinkRequest(request, fee);
    }

    function fulfill(bytes32 _requestId, bytes memory _data) public recordChainlinkFulfillment(_requestId) {
        // Decode the response data into EarthquakeData[] (all numeric types)
        (EarthquakeData[] memory prefectures) = abi.decode(_data, (EarthquakeData[]));

        // Update earthquakeInfo for affected prefectures
        for (uint i = 0; i < prefectures.length; i++) {
            earthquakeInfo[prefectures[i].prefCode] = prefectures[i];
        }
    }
}
