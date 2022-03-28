pragma solidity ^0.8.4;

import 'https://github.com/wakeyspace/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract freelist is Ownable{

    uint256 private _max_free_count = 10;
    mapping(address => address) private _freemint_list;  
    address[] _freemint_array;  


    function getFreeList() public onlyOwner returns(address[] memory){

        return _freemint_array;
    }

    function freelsitSize() public onlyOwner returns(uint256){

        return _freemint_array.length;
    }

    function isInFreeList(address owner) public onlyOwner returns(bool){

        return _freemint_list[owner] != address(0);
    }

    function writeMaxFreelistCount(uint256 count) public onlyOwner{

        _max_free_count = count; 
    }

     function addFreeListMembers(address[] memory owners) public onlyOwner{
           
            for (uint i = 0; i < owners.length; i++) {
            
             addFreeListMember(owners[i]);
            
            }
    }

    function addFreeListMember(address onwer) public onlyOwner{

        require(_max_free_count >= _freemint_array.length, " freelist is full");
        _freemint_array.push(onwer);
        _freemint_list[onwer] = onwer;
    }

    function removeFreeListMemeberByIndex(uint256 index) public onlyOwner{

        require(index < _freemint_array.length, " index larger than range of freelist");
        address owner = _freemint_array[index];

        delete _freemint_array[index];

        delete _freemint_list[owner];
    }

    function removeFreeListMember(address onwer) public onlyOwner{

        for(uint256 i = 0; i < _freemint_array.length - 1; i++){
            if(_freemint_array[i] == onwer){
                delete _freemint_array[i];
                break;
            }
        }
        delete _freemint_list[onwer];
    }
    

}