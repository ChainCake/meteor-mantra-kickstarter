pragma solidity ^0.4.2;

contract Job {
    address public owner;

    string public description;
    uint public payment;

    uint public quota;
    uint public hired;

    unit maxApplicants; // > than quota to make sure the creator has enough to choose from

    // key is an applicant, value is a rating. 0 by default (i.e. not reviewed), [1,5] assigned EOD
    mapping (address => uint) applicants; 

    struct Review {
        address worker;
        uint rating;
    }

    // Worker applies to the job
    function apply() public returns (bool success) {
        if (maxApplicants >= applicants.length) {return false;} // TODO: a bug, use throw instead

        applicants[msg.sender]= 0;
        return true;
    }

    function hire(address[] workers) public returns (address[] hired) {
        if (msg.sender != owner) {throw;}

        for (var i=0; i < workers.length; i++) {
            // assumption that a worker has exactly one coin, that is transferred to job creator (??)
            // at the time of hiring. It should be released after work
            // That create a lot of potential problems and should be refactored, but I want to go faster
            if (worker[i].balance > 1) {
                // at least, we should charge the owner more for creating the job to motivate him to write reviews and return coins to workers
                worker[i].transfer(1);
                hired.push(worker[i]);
            }
        }
    }

    function review(Review[] reviews) public {
        if (msg.sender != owner) {throw;}            

        for(var i=0; i < reviews.length; i++) {
            applicants[reviews[i].worker] = reviews[i].rating;
            reviews[i].worker.send(1);
        }
    }

    function destroy() { // so funds not locked in contract forever
        if (msg.sender == owner) {
            suicide(owner); // send funds to the creator
        }
    }
}