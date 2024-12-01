// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@chainlink/contracts/src/v0.7/Operator.sol";

contract Oracle is Operator {
    constructor()
        Operator(0x779877A7B0D9E8603169DdbD7836e478b4624789, msg.sender) 
    {}
}
