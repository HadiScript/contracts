// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Marketplace {
    enum State {
        Purchased,
        Activated,
        Deactivated
    }

    struct Course {
        uint256 id; //32
        uint256 price; //32
        bytes32 proof; //32
        address owner; //20
        State state; // 1
    }

    // maping of coursHash -> CourseData (course structure)
    mapping(bytes32 => Course) private ownedCourses;

    // mapping courseId -> CourseHash
    mapping(uint256 => bytes32) private ownedCourseHash;

    // total owned courses and id (example 5, id -> 0,1,2,3,4 )
    uint256 private totalOwnedCourse;

    // owner of the contract ( admin )
    address payable private owner;

    /// Course already purchased (already has owner)
    error CourseHasOwner();

    // above one the error /// ... statement

    /// you are not owner btw
    error onlyOwnerError();

    modifier onlyOwner() {
        if (msg.sender != getContractOwner()) {
            revert onlyOwnerError();
        }
        _;
    }

    constructor() {
        setContractOwner(msg.sender);
    }

    // function purchaseCourse(
    // bytes16 courseId,
    //  bytes32 prood 0x0000000000000000000000000000313000000000000000000000000000003130
    // )
    //     external
    //     payable
    //     returns (bytes32)
    // {
    //     // example
    //     // let say course id -> 10 (3130 byte) (10 is in asc formet)
    //     // we have to expand it to 16 bytes becourse courseId is bytes16 (mean 32 charactor long), so
    //     // 0x00000000000000000000000000003130 (32 charc)-> 16bytes

    //     // message sender 20 bytes address
    //     // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 (40 char)

    //     // keccak256(abi.encodePacked(courseId, msg.sender)) -> we hashing them to gether -> courseId (16 bytes) + address (20 bytes)
    //     // ---> 000000000000000000000000000031305B38Da6a701c568545dCfcB03FcB875f56beddC4
    //     // here is the kecak256 hash of them -> c4eaa3558504e2baa2669001b43f359b8418b44a4477ff417b4b007d7cc86e37

    //     bytes32 courseHash = keccak256(abi.encodePacked(courseId, msg.sender));
    //     return courseHash;
    // }

    function purchaseCourse(bytes16 courseId, bytes32 proof) external payable {
        bytes32 courseHash = keccak256(abi.encodePacked(courseId, msg.sender));

        if (hasCourseOwnership(courseHash)) {
            revert CourseHasOwner();
        }

        uint256 id = totalOwnedCourse++;

        // 0 => c4eaa3558504e2baa2669001b43f359b8418b44a4477ff417b4b007d7cc86e37
        ownedCourseHash[id] = courseHash;

        ownedCourses[courseHash] = Course({
            id: id,
            price: msg.value,
            proof: proof,
            owner: msg.sender,
            state: State.Purchased
        });
    }


    function activateCourse(bytes32 courseHash) external onlyOwner {}

    function transferOwnerShip(address newOwner) external onlyOwner {
        setContractOwner(newOwner);
    }

    function getCoursesCount() external view returns (uint256) {
        return totalOwnedCourse;
    }

    function getCourseHashAtIndex(uint256 index)
        external
        view
        returns (bytes32)
    {
        return ownedCourseHash[index];
    }

    function getCourseByHash(bytes32 courseHash)
        external
        view
        returns (Course memory)
    {
        return ownedCourses[courseHash];
    }

    function getContractOwner() public view returns (address) {
        return owner;
    }

    function setContractOwner(address newOwner) private {
        owner = payable(newOwner);
        // owner.transfer(10);
    }

    // private function should be inthe last
    function hasCourseOwnership(bytes32 courseHash)
        private
        view
        returns (bool)
    {
        return ownedCourses[courseHash].owner == msg.sender;
    }
}
