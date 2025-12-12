
pragma solidity ^0.8.21;

contract HelloWorld {
    
    string public yourName;
    
  
    constructor() public {
        yourName = "Unknown";
    }
    
    function setName(string memory nm) public{ 
     yourName = nm ; 
    } 
}