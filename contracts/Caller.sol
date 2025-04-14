// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.2 < 0.9.0;

contract Caller {
    uint256 num = 10;
    event MoneyReceived (uint256);
    event AddressInterraction (string, address, address);
    event ResultReturned(bool, bytes);

    function transferMoneyToTarget(address addr, uint256 amount) public {
        emit AddressInterraction("Transfer", msg.sender, tx.origin);
        address payable to = payable (addr);
        to.transfer(amount);
    }

    function sendMoney(address payable _addr, uint256 _amount) public {
        bool success = _addr.send(_amount);
        require(success, "Batko, provali se transferut!");
        emit AddressInterraction("Send", msg.sender, tx.origin);
    }

    function callTarget(address payable _addr, uint256 _amount, uint256 _gasAmount) public {
        (bool success, bytes memory data) = _addr.call{gas: _gasAmount, value: _amount}(abi.encodeWithSignature("getNum()"));
        require(success, "Batko, provali se izvikvaneto!");
        emit AddressInterraction("Call", msg.sender, tx.origin);
        emit ResultReturned(success, data);
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
    uint256 num = 8;
    event MoneyReceivedTarget (uint256);
    event AddressInterractionTarget (address, address);

    function getNum() public view returns(uint256) {
        return num;
    }

    receive() external payable { }

    fallback() external payable { 
        emit MoneyReceivedTarget(msg.value);
        // emit AddressInterractionTarget(msg.sender, tx.origin);
    }
}