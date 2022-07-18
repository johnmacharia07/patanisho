pragma solidity ^0.4.17;

contract Lease {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint endorsementCount;
        mapping(address => bool) endorsements;
        
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public endorsers;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }


    function Lease( uint minimum) public {
        manager = msg.sender;
        minimumContribution = minimum;
    }



    function contribute() public payable {
        require(msg.value > minimumContribution);

        endorsers[msg.sender] = true;
    }


    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory leaseRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            endorsementCount: 0
        });

        requests.push(leaseRequest);
    }

function endorseRequest( uint id ) public {
    Request storage request = requests[id];

    require(endorsers[msg.sender]);
    require(!requests[id].endorsements[msg.sender]);

    request.endorsements[msg.sender] = true;
    request.endorsementCount++;

}
}