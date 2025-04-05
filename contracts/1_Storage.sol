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
    uint8[15] private keys;
    uint8 count;

    struct Student {
        string name;
        uint16 age;
    }

    modifier isNumAbove10(uint256 _num) {
        require(_num > 10, "Number must be > 10!!!");

        _;
    }

    constructor() {
        number = 10;
        count = 0;
    }

    // constructor(uint16 num) { // At Solidity we can't overload constructors

    // }

    function storeName(string memory _name, uint8 _num) public {
        names[_num] = _name;
        keys[count] = _num;
        count++;
    }

    function getName(uint8 _num) external view returns(string memory) {
        return names[_num];
    }

    function storeNums() public {
        for (uint8 i = 0; i < 10 ; i++) {
            nums[i] = i*2;
        }
    }

    function getNums() external view returns(uint256[10] memory) {
        return nums;
    }

    function getMapSize() public view returns(uint256) {
        // return names.length; Map hasn't length field
    }

    function store(uint256 _num) public isNumAbove10(_num) {
        // require(num > 10, "Number must be > 10!!!");
        number = _num;
    }

    function stopExecution() public pure {
        revert();
    }

    function retrieve() public view returns (uint256){
        return number;
    }

    function truncate() public pure returns (uint8) {
        uint8 num = 10;

        return num/3;
    }

    function isStringEq() public pure returns(bool) {
        string memory str1 = "123";
        string memory str2 = "ABC";

        // return keccak256(str1) == keccak256(str2); Error. Function wants binary array as a input

        // return str1 == str2; // TypeError
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }
 
    function useCycle(uint256 _limit) public pure {
        uint256 result = 0;
        string memory str = "";
        for (uint i = 0; i < _limit ; i++) {
            result += i;
            str = "SKIBIDI TOILET";
        }
    }
}