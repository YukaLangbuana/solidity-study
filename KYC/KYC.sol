// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYC {

    struct Person {
        address owner;
        string name;
        string idNumber;
        string homeAddress;
        string dateOfRegistration;
        bool isVerified;
        Verification verification;
        string dateOfLastVerification;
        string dateOfNextVerification;
    }

    struct Institution {
        address owner;
        string name;
        string country;
        string institutionAddress;
        uint KYCCount;
    }

    struct Verification{
        address owner;
        string InstitutionName;
        string proofUrl;
        string dateOfVerification;
        string dateOfVerificationUpdate;
    }

    mapping(address => Person) public persons;
    mapping(address => Institution) public institutions;
    mapping(address => Verification) public verifications;

    function addPerson(string memory _name, string memory _idNumber, string memory _homeAddress, string memory _dateOfRegistration) public {
        Person memory person;
        person.owner = msg.sender;
        person.name = _name;
        person.idNumber = _idNumber;
        person.homeAddress = _homeAddress;
        person.dateOfRegistration = _dateOfRegistration;
        person.isVerified = false;
        person.verification = Verification(
            address(0),
            "",
            "",
            "",
            ""
        );
        person.dateOfLastVerification = "";
        person.dateOfNextVerification = "";
        persons[msg.sender] = person;
    }

    function addInstitution(string memory _name, string memory _country, string memory _institutionAddress) public {
        Institution memory institution;
        institution.owner = msg.sender;
        institution.name = _name;
        institution.country = _country;
        institution.institutionAddress = _institutionAddress;
        institution.KYCCount = 0;
        institutions[msg.sender] = institution;
    }

    function doIncreaseInstitutionKYCCount(address _institution) private {
        require(_institution != address(0));
        require(institutions[_institution].owner == msg.sender);
        institutions[_institution].KYCCount++;
    }

    function addVerification(string memory _InstitutionName, string memory _proofUrl) public {
        Verification memory verification;
        verification.owner = msg.sender;
        verification.InstitutionName = _InstitutionName;
        verification.proofUrl = _proofUrl;
        verification.dateOfVerification = "";
        verification.dateOfVerificationUpdate = "";
        verifications[msg.sender] = verification;
        doIncreaseInstitutionKYCCount(msg.sender);
    }


    function getPerson(address _owner) public view returns (Person memory person) {
        person = persons[_owner];
    }

}