// SPDX-License-Identifier: varunarya

/** 
 * @intro This contract is written by varunarya , 11 oct 2021
 * @contact varunp.b832@gmail.com 
*/

pragma solidity ^ 0.6.12;

/** 
 * @title Voting
 * @dev Implements voting process 
*/

contract Voting{
    
    struct Data{
       address users;  // candidate
       bool isRegistered;  // to check if candidate is registred or not
       bool hadVote;       // to check if candidate is voted or not
       address toCandidate;  // to whom candidate voted
    }

    address[] totalRegisteredCandidate;
    mapping(address => Data) public getCandidateDetail; // to get candidate all details 
    mapping(address => uint256) public voteCount; // to check voteCount for candidate sperately 
    address public owner;  
    address deadAddress = 0x0000000000000000000000000000000000000000;  // null address


    constructor() public{

        owner = msg.sender;

    }


    /***
    @candidate register themself with conditions :
    -  no candidate register themself more then once
    - owner cannot take participate
    */

    function registerUser() public{

        require(
            msg.sender != owner,
            "owner cannot participate"
        );

        if (getCandidateDetail[msg.sender].isRegistered == true) {

            {
                revert();
            }
        }
        else {
            
            Data memory tempdata = Data(msg.sender, true, false, deadAddress);
            getCandidateDetail[msg.sender] = tempdata;
            totalRegisteredCandidate.push(msg.sender);
        }
    }


    /***
     @candidate votes with conditions :
     -  one user one vote 
     -  owner cannot vote
     -  candidate cannot vote to themself but can vote to others
     -  candidate should be registered themself before vote 
     */

    function castVote(address _contestant) public{

        if (msg.sender == owner || _contestant == msg.sender || 
        getCandidateDetail[msg.sender].hadVote == true || 
        getCandidateDetail[msg.sender].isRegistered == false)
        {

            {
                revert();
            }
        }
        else {
            require(getCandidateDetail[_contestant].isRegistered == true , "cannot vote to unregistred");
            voteCount[_contestant] = voteCount[_contestant] + 1;
            Data memory tempdata = Data(msg.sender, true, true, _contestant);
            getCandidateDetail[msg.sender] = tempdata;

        }

    }

    /***
    @candidate can take thier vote back with @removeVote function, with conditions :
    -  candidate must be voted to someone or had voted , who is registered as candidate
    */

    function removeVote(address _contestant) public {
        if (getCandidateDetail[msg.sender].toCandidate == _contestant) {

            voteCount[_contestant] = voteCount[_contestant] - 1;
           Data memory tempdata = Data(msg.sender, true, false, deadAddress);
            getCandidateDetail[msg.sender] = tempdata;


        }
        else {

            {
                revert();
            }
        }

    }

    /***
    @Winner function to decalre result 
    */

    function Winner()  public  view returns(address){
      
        uint256 largest = 0; 
        uint256 i;
        address winneradd;

        for (i = 0; i < totalRegisteredCandidate.length; i++) {

            if (voteCount[totalRegisteredCandidate[i]] > largest) {
                largest = voteCount[totalRegisteredCandidate[i]];
                winneradd = totalRegisteredCandidate[i];
            }
        }

        return winneradd;
    }

    /***
    @getTotalregistredCandiates in voting 
    */

    function getTotalregistredCandiates() public view returns(uint256){

        return totalRegisteredCandidate.length;
    }


}
