// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.2 < 0.9.0;

contract Caller {
    uint256 num = 10;
    event MoneyReceived (uint256);
    event AddressInterraction (address, address);

    function transferMoneyToTarget(address addr, uint256 amount) public {
        emit AddressInterraction(msg.sender, tx.origin);
        address payable to = payable (addr);
        to.transfer(amount);
    }

    function getNum() public view returns (uint256) {return num;}

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }

    receive() external payable { }

    fallback() external payable { 
        emit MoneyReceived(msg.value);
    }
}

contract Target {
    event MoneyReceivedTarget (uint256);
    event AddressInterractionTarget (address, address);

    fallback() external payable { 
        emit MoneyReceivedTarget(msg.value);
        emit AddressInterractionTarget(msg.sender, tx.origin);
    }
}