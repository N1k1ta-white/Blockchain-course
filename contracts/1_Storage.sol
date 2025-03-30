// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    uint256 number;
    uint256[10] nums;
    mapping (uint8 => string) public names;

    function storeName(string memory _name, uint8 _num) public {
        names[_num] = _name;
    }

    function getName(uint8 _num) external view returns(string memory) {
        return names[_num];
    }

    function storeNums() public {
        for (uint8 i = 0; i<10 ;i++) {
            nums[i] = i*2;
        }
    }

    function getNums() external view returns(uint256[10] memory) {
        return nums;
    }

    function store(uint256 num) public {
        number = num;
    }

    function retrieve() public view returns (uint256){
        return number;
    }
}