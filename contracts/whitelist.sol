pragma solidity ^0.8.4;

import 'https://github.com/wakeyspace/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract whitelist is Ownable{

    uint256 private _max_whitelist_count = 200;
    mapping(address => address) private _whitelist;  
    address[] private _whitelist_array;  

    function writeMaxWhitelistCount(uint256 count) public onlyOwner{

        _max_whitelist_count = count; 
    }

    function getWhitelist() public onlyOwner returns(address[] memory){

        return _whitelist_array;
    }

    function whitelistSize() public onlyOwner returns(uint256){

        return _whitelist_array.length;
    }

    function isInWhitelist(address owner) public onlyOwner returns(bool){

        return _whitelist[owner] != address(0);
    }

    function addWhiteListMembers(address[] memory owners) public onlyOwner{
           
            for (uint i = 0; i < owners.length; i++) {
            
             addWhiteListMember(owners[i]);
            
            }
    }

    function addWhiteListMember(address onwer) public onlyOwner{

        require(_max_whitelist_count >= _whitelist_array.length, " whitelist is full");
        _whitelist_array.push(onwer);
        _whitelist[onwer] = onwer;
    }

    function removeWhiteListMemeberByIndex(uint256 index) public onlyOwner{

        require(index < _whitelist_array.length, " index larger than range of whitelist");
        address owner = _whitelist_array[index];

        delete _whitelist_array[index];

        delete _whitelist[owner];
    }

    function removeWhiteListMember(address onwer) public onlyOwner{

        for(uint256 i = 0; i < _whitelist_array.length - 1; i++){
            if(_whitelist_array[i] == onwer){
                delete _whitelist_array[i];
                break;
            }
        }
        delete _whitelist[onwer];
    }
    

}