pragma solidity ^0.4.17;

contract Lease {
    struct Request {
        string model;
        uint manufacturingYear;
        string description;
        uint value;
        address recipient;
        bool complete;
        uint endorsementCount;
        mapping(address => bool) endorsements;
        
    }

    Request[] public requests;
    address public owner;
    uint public minimumContribution;
    mapping(address => bool) public endorsers;
    uint public endorsersCount;


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }



    function Lease( uint minimum) public {
        owner = msg.sender;
        minimumContribution = minimum;
    }



    function contribute() public payable {
        require(msg.value > minimumContribution);

        endorsers[msg.sender] = true;
        endorsersCount++;
    }


    function createRequest(string model, uint manufacturingYear, string description, uint value, address recipient) public onlyOwner {
        Request memory leaseRequest = Request({
            model: model,
            manufacturingYear: manufacturingYear,
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

    function finalizeRequest(uint id) public onlyOwner{
        Request storage request = requests[id];

        require(request.endorsementCount > (endorsersCount/2));    
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }
   
}