pragma solidity ^0.8.4;

import 'contracts/whitelist.sol';
import 'contracts/freelist.sol';
import 'contracts/_erc721a.sol';


contract wakey is ERC721A, whitelist, freelist {


    uint256 private _mint_status = 1;  // 0: stop mint 1: allow all mint 2: only writelist mint

    uint256 private _max_supply = 3333;

    uint256 private _max_minted_count = 2;
   
    constructor() ERC721A("wakey", "wakey") {}

    function mint(uint256 quantity) external payable {

        //totalSupply
      require(_mint_status > 0, "mint is closed");

      if(_mint_status == 2){
          require(isInWhitelist(msg.sender),"only whitelist member allow mint now");
      }

      uint256 minted_count = numberMinted(msg.sender);
      require( minted_count + quantity <= _max_minted_count, "up to max minted count");

      uint256 total_supply = totalSupply();
      require( total_supply + quantity <= _max_supply, "no enough ntfs");

      _safeMint(msg.sender, quantity);

    }

    function getAirdrop() public {

        uint256 quantity = 1;
        require(_mint_status > 0, "mint is closed");
        require(_mint_status != 2, "only whitelist mint allowed");

        require(isInFreeList(msg.sender) == true, "not in free mint list");

        uint256 minted_count = numberMinted(msg.sender);
        require( minted_count + quantity <= _max_minted_count, "up to max minted count");

        uint256 total_supply = totalSupply();
        require( total_supply + quantity <= _max_supply, "no enough ntfs");

        _safeMint(msg.sender, quantity);
    }

    //reserve nfts
    function reserveNFTs(uint256 reserve_count) public onlyOwner {

     uint256 total_supply = totalSupply();
     require( total_supply + reserve_count <= _max_supply, "no enough ntfs");

     _safeMint(msg.sender, reserve_count);

    }


    function contractURI() public view returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmVDfTqk6MSme9ZgoCLwmtNkiWqEo2zSkSvi9E5fCjixc1";
    }

    /**
     * Returns the number of tokens minted by `owner`.
     */
    function numberMinted(address owner) public view returns (uint256) {
        
        return _numberMinted(owner);
    }

    function status() public view returns(uint256){

        return _mint_status;
    }

    

     function writeStatus(uint256 status) public onlyOwner {
        
        // 0: stop mint 1: allow all mint 2: only writelist mint
        _mint_status = status;  
    }

    function writeMaxSupply(uint256 supply) public onlyOwner{

        _max_supply = supply; 
    }

     function writeMaxMintCount(uint256 mintCount) public onlyOwner{

        _max_minted_count = mintCount; 
    }
}
