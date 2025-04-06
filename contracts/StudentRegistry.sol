// SPDX-License-Identifier: MIT
// Декларация на лиценза за интелектуална собственост на кода, трябва да е първи ред. MIT - позволява свободно използване, модифициране и разпространение на кода

// Декларация на версията на компилатора, която трябва да бъде използвана
// Тук се използва Solidity версия 0.8.20 или по-нова, но не и 0.9.0
pragma solidity ^0.8.20;


contract StudentRegistry {

    // Енум за оценките - това е стойностен тип (value type)
    enum Grade { Fail, Pass, Merit, Distinction }

    // Структура за студент - комбинира референтни и стойностни типове
    struct Student {
        string name;       // Референтен тип, намира се в storage
        uint8 age;         // Стойностен тип (uint8)
        bool enrolled;     // Стойностен тип
        Grade finalGrade;  // Енум, също стойностен тип
    }

    // ========= ДАННИ СЪХРАНЯВАНИ В ДИСТРИБУТИРАНИЯ ЛЕДЖЪР (STORAGE) =========

    uint256 public studentID = 0;  
    mapping(uint256 => Student) public students; // storage: асоциира ID с Student
    string[] public registeredNames;          

    // ========= ПОТРЕБИТЕЛСКИ ДЕФИНИРАНИ МОДИФИКАТОРИ =========

    // Позволява изпълнение само ако възрастта е 18+
    modifier minimumAge(uint8 _age) {
        require(_age >= 18, "Student must be at least 18 years old");
        _;
    }

    // Позволява изпълнение само ако името не е празно
    modifier validName(string calldata _name) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        _;
    }

    // Конструктор – изпълнява се само веднъж при създаване на контракта. Не може да се overload-не
    constructor() {
        // Добавяме предварително студент за демонстрация
        Student memory initialStudent = Student({
            name: "Ivan",
            age: 20,
            enrolled: true,
            finalGrade: Grade.Merit
        });

        students[studentID] = initialStudent;
        registeredNames.push(initialStudent.name);
        studentID++;
    }

    // ========= ФУНКЦИИ =========

    // Регистрира нов студент
    function registerStudent(string calldata _name, uint8 _age) public minimumAge(_age) validName(_name) {
        // _name е в calldata - евтин, неизменяем вход
        // newStudent е в memory - временен обект, използван само в тази функция
        Student memory newStudent = Student({
            name: _name,
            age: _age,
            enrolled: true,
            finalGrade: Grade.Pass
        });

        students[studentID] = newStudent; // запис в storage
        registeredNames.push(_name);      // добавяне в storage масив
        studentID++;
    }

    // Променя оценката на студент
    function updateGrade(uint256 _id, uint8 _grade) public {
        require(_id < studentID, "Invalid student ID");
        require(_grade <= uint8(Grade.Distinction), "Invalid grade");

        Student storage s = students[_id]; // достъп и промяна на storage
        s.finalGrade = Grade(_grade);
    }

    // Връща името на студент по негово ID (като ключ)
    function getStudentName(uint256 _id) public view returns (string memory) {
        require(_id < studentID, "Invalid student ID");
        Student storage s = students[_id];
        return s.name;
    }

    // Mасиви в паметта (memory)
    function memoryArrayExample() public pure returns (uint256) {
        // Създаване на динамичен масив в паметта
        uint256[] memory dynamicArray = new uint256[](3);
        dynamicArray[0] = 10;
        dynamicArray[1] = 20;
        dynamicArray[2] = 30;

        // Създаване на статичен масив (фиксирана дължина)
        uint256[3] memory staticArray = [uint256(1), 2, 3];

        return staticArray[2]; // достъп до стойност
    }

    // Цикъл през всички регистрирани ID-та и връщане на броя на записаните пълнолетни
    function countAdults() public view returns (uint256) {
        uint256 counter = 0;
        uint256 limit = studentID;

        for (uint256 i = 0; i < limit; i++) {
            if (students[i].age >= 18) {
                counter++;
            }
        }
        return counter;
    }

    // Сравнява името на студент с подадено име (не може с == при string!)
    // Затова използваме keccak256 хеш на двете стойности, след като ги енкоднем с abi.encodePacked, което преобразува входовете в байтови масиви.
    // Така можем да сравняваме референтни типове (като string) чрез сравнение на хешове.

    function isSameName(uint256 _id, string calldata _inputName) public view returns (bool) {
        require(_id < studentID, "Invalid ID");

        // Взимаме името от storage
        string storage storedName = students[_id].name;

        // Сравняваме чрез хеширане, защото string не може да се сравнява директно
        return keccak256(abi.encodePacked(storedName)) == keccak256(abi.encodePacked(_inputName));
    }

    // Сравнява подаден списък с ID-та със списъка на реално регистрираните студенти
    // Използва keccak256 + abi.encodePacked за сравнение
    function verifyStudentIdSequence(uint[] calldata inputIds) external view returns (bool) {
        if (inputIds.length != studentID) {
            return false;
        }

        // Създаваме нов масив в паметта с реалните ID-та: [0, 1, ..., studentID - 1]
        uint[] memory actualIds = new uint[](studentID);
        for (uint256 i = 0; i < studentID; i++) {
            actualIds[i] = i;
        }

        // Сравняваме двата масива чрез хеш
        return keccak256(abi.encodePacked(inputIds)) == keccak256(abi.encodePacked(actualIds));
    }


}

contract RegistryBase {
    string internal baseNote = "Kolko gotin kurs!";
    event Krusha(string, uint8);


    function getBaseNote() internal returns (string memory) {
        emit Krusha("Qbulka", 3);
        return baseNote;
    }
}

// Никога не ползвайте това
contract ExtendedStudentRegistry is StudentRegistry, RegistryBase {
    // Тук можем да добавим нови функции или да разширим съществуващите
    // Например, можем да добавим функция, която връща бележката от RegistryBase

    event Salata(string);

    function getNoteFromParent() internal returns (string memory) {
        emit Salata("Me6ana");
        return getBaseNote();
    }
}


contract SuperExtended is ExtendedStudentRegistry {

    event NoteReturned(string indexed);

    function getNoteFromExtended() external returns (string memory) {
        emit NoteReturned("Emit from ExtendedStudentRegistry");
        return getNoteFromParent();
    }
}