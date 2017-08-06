pragma solidity ^0.4.2;

contract Job {
    address public owner;

    string public description;
    uint public payment;

    uint public quota;
    address[] hired;

    uint maxApplicants; // > than quota to make sure the creator has enough to choose from
    uint appliedCount;

    // key is an applicant, value is a rating. 0 by default (i.e. not reviewed), [1,5] assigned EOD
    mapping (address => uint) applicants; 

    // Worker applies to the job
    function apply() public returns (bool success) {
        if (appliedCount >= maxApplicants) {throw;}

        applicants[msg.sender] = 0;
        appliedCount++;
        return true;
    }

    function hire(address[] workers) public returns (bool[]) {
        if (msg.sender != owner) {throw;}

        bool[] memory hiredStatus = new bool[](workers.length);
        for (var i=0; i < workers.length; i++) {
            // assumption that a worker has exactly one coin, that is transferred to job creator (??)
            // at the time of hiring. It should be released after work
            // That create a lot of potential problems and should be refactored, but I want to go faster
            hiredStatus[i] = false;
            if (workers[i].balance > 1) {
                // at least, we should charge the owner more for creating the job to motivate him to write reviews and return coins to workers
                workers[i].transfer(1);
                hiredStatus[i] = true;

                hired.push(workers[i]);
            }
        }
    }

    // TODO: redesign the API. A struct should be used, however, I got trouble with it
    // going with this to save time. Yeah, we can't use a mapping as param
    function review(address[] workers, uint[] rating) public returns (bool) {
        if (msg.sender != owner) {throw;}            

        assert (workers.length == rating.length);

        for (var i = 0; i < workers.length; i++) {
            applicants[workers[i]] = rating[i];
            // TODO: Bug, could send > 1 time
            // Also, shouldn't throw I think
            if (!workers[i].send(1)) {
                throw;
            }
        }

        for (i = 0; i < hired.length; i++) {
            if (applicants[hired[i]] <= 0) {
                return false;
            }
        }

        return true;
    }

    function destroy() { // so funds not locked in contract forever
        if (msg.sender == owner) {
            suicide(owner); // send funds to the creator
        }
        // TODO: refund workers
    }
}