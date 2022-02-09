// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*****************************************************************************************************
 ██████╗░███████╗░██████╗░███████╗███╗░░██╗  ██████╗░░██╗░░░░░░░██╗░█████╗░██████╗░███████╗░██████╗
 ██╔══██╗██╔════╝██╔════╝░██╔════╝████╗░██║  ██╔══██╗░██║░░██╗░░██║██╔══██╗██╔══██╗██╔════╝██╔════╝
 ██║░░██║█████╗░░██║░░██╗░█████╗░░██╔██╗██║  ██║░░██║░╚██╗████╗██╔╝███████║██████╔╝█████╗░░╚█████╗░
 ██║░░██║██╔══╝░░██║░░╚██╗██╔══╝░░██║╚████║  ██║░░██║░░████╔═████║░██╔══██║██╔══██╗██╔══╝░░░╚═══██╗
 ██████╔╝███████╗╚██████╔╝███████╗██║░╚███║  ██████╔╝░░╚██╔╝░╚██╔╝░██║░░██║██║░░██║██║░░░░░██████╔╝
 ╚═════╝░╚══════╝░╚═════╝░╚══════╝╚═╝░░╚══╝  ╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═════╝░
  Contract Developer: Stinky
  Description: Degen Dwarfs is an ERC-721 NFT series on Ethereum Mainnet.
******************************************************************************************************/

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract DegenDwarfs is ERC721, Ownable, Pausable, ERC721Enumerable, ReentrancyGuard {
    using Counters for Counters.Counter;

    // @notice Counter for number of minted characters
    Counters.Counter public _tokenIds;    

    // Max Supply of DegenDwarfs
    uint256 public immutable maxSupply;
    // Store address and discount rate (10% off = 0.01 ether, convert to wei)
    mapping(address => uint256) private _discount;
    // If you are on the list, you can mint early
    mapping(address => bool) public _whitelist;
    // Contract managed whitelist mint start
    uint256 whitelistStart;
    // Contract managed public mint start and whitelist end
    uint256 mintStart;
    // Variable to change mint price if needed
    uint256 private _manualMintPrice;
    // Base URI used for token metadata
    string private _baseTokenUri;     
    // DegenDwarf Beneficiary address
    address private immutable beneficiary;

    constructor(
        address _beneficiary,
        string memory name,
        string memory symbol,
        uint256 wlist,
        uint256 startMint,
        string memory _tokenURI
    ) ERC721(name, symbol) {
        beneficiary = _beneficiary;
        whitelistStart = wlist;
        mintStart = startMint;
        _manualMintPrice = 69000000000000000;
        _baseTokenUri = _tokenURI;
         maxSupply = 6969;
    }

    // External function
    /*
     * @notice Claim mint discounts applied to your address
     */   
    function discount() external payable whenNotPaused nonReentrant {
        uint256 discounted = getNFTPrice() * (1e18 - _discount[_msgSender()]) / 1e18;
        require(msg.value == uint256(discounted), "ETH value incorrect");
        require(_tokenIds.current() <= maxSupply, "Mint is over");
        _tokenIds.increment();
        uint256 newCharId = _tokenIds.current();
        _safeMint(_msgSender(), newCharId);
        // delete discount
        delete _discount[_msgSender()];
    }

    /*
     * @notice Mint a Degen Dwarf NFT
     * @param _mintAmount How many NFTs would you like to batch mint?
     */    
    function claim(uint256 _mintAmount) external payable whenNotPaused nonReentrant {
        require(_mintAmount >= 1, "You must mint at least 1 NFT");
        require(_tokenIds.current() <= maxSupply, "Mint is over");        
        uint256 bundlePrice = getNFTPrice() * _mintAmount;
        require(msg.value == bundlePrice, "ETH value incorrect");
        require(whitelistStart < block.timestamp, "Whitelist minting has not started.");
        //Whitelist Phase
        if(whitelistStart < block.timestamp && mintStart > block.timestamp)
        {
            require(_whitelist[_msgSender()], "You are not on the Whitelist");
            require(_mintAmount < 3, "Whitelist can mint up to 2 Dwarfs per transaction.");
        }
        //Public Phase
        if(mintStart < block.timestamp)
            require(_mintAmount < 11, "You can mint up to 10 Dwards per transaction");

        for(uint256 i = 0; i < _mintAmount; i++)
        {
            _tokenIds.increment();
            uint256 newCharId = _tokenIds.current();
            _safeMint(_msgSender(), newCharId);
        }

        //Pay for new NFT(s)
        payable(beneficiary).transfer(bundlePrice);
        //Remove Minter from whitelist
        if(_whitelist[_msgSender()]) 
            delete _whitelist[_msgSender()];
    }    

    /*
     * @notice Change mint price
     * @param newPrice (make sure value is in wei)
     */   
    function overrideMintPrice(uint256 newPrice) external onlyOwner {
        _manualMintPrice = newPrice;
    }

    /*
     * @notice Add batch discounts
     * @param discountees an array of address 
     * @param discounted an array of the discount the addresses will receive
     */   
    function addDiscounts(address[] memory discountees, uint256[] memory discounted) external onlyOwner {
        for (uint i = 0; i < discountees.length; i++) {
            _discount[discountees[i]] = discounted[i];
          }
    }

    /*
     * @notice Add an multiple addresses to the whitelist
     * @param whitelist array of addresses
     */  
    function addWhitelist(address[] memory whitelist) external onlyOwner {
        for (uint i = 0; i < whitelist.length; i++) {
            _whitelist[whitelist[i]] = true;
          }
    }

    /*
     * @notice set the baseURI
     * @param baseURI
     */  
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenUri = baseURI;
    }  

    /* @notice Pause Degen Dwarf minting */  
    function pauseMinting() external onlyOwner {
        _pause();
    }

    /* @notice Resume Degen Dwarf minting*/  
    function unpauseMinting() external onlyOwner {
        _unpause();
    }   

    /* @notice Withdraw funds in Degen Dwarfs contract*/  
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(_msgSender()).transfer(balance);
    }

    // Public functions
    /* @notice Returns price to mint a Degen Dwarf NFT */  
    function getNFTPrice() public view returns (uint256) {
        uint256 currentSupply = _tokenIds.current();
        require(currentSupply < maxSupply, "Sale has already ended");
        return _manualMintPrice;
    }
    
    // Internal functions
    /* @notice Returns the baseURI */      
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenUri;
    }

    // Private functions
    /* @notice Returns the baseURI */         
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(_baseURI(), toString(tokenId), ".json"));
    }

    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);

        // do stuff before every transfer
        // e.g. check that vote (other than when minted) 
        // being transferred to registered candidate
    }
    
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}