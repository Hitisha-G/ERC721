// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// THE REQUIRED FUNCTIONS MUST BE IN AN ERC 721 CONTRACT
// function balanceOf(address _owner) external view returns (uint256);
// function ownerOf(uint256 _tokenId) external view returns (address);
// function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
// function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
// function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
// function approve(address _approved, uint256 _tokenId) external payable;
// function setApprovalForAll(address _operator, bool _approved) external;
// function getApproved(uint256 _tokenId) external view returns (address);
// function isApprovedForAll(address _owner, address _operator) external view returns (bool);

contract ERC721{

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    
      // Mapping from token ID to owner address
    mapping(uint => address) internal _ownerOf;

    // Mapping owner address to token count
    mapping(address => uint) internal _balanceOf;

    // Mapping from token ID to approved address
    mapping(uint => address) internal _approvals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    uint tokenId;

    struct tokenMetaData {
	uint tokenId;
	uint timeStamp;
	string tokenURI;
    }

    function transferFrom(address from,address to,uint id) public {
        require(from == _ownerOf[id], "from != owner");
        require(to != address(0), "transfer to zero address");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[id] = to;

        delete _approvals[id];

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(address from,address to,uint id) external {
        transferFrom(from, to, id);
    }

    function getApproved(uint id) external view returns (address) {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        return _approvals[id];
    }
    
    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function approve(address spender, uint id) external {
        address owner = _ownerOf[id];
        require(
            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authorized"
        );

        _approvals[id] = spender;

        emit Approval(owner, spender, id);
    }

    function _mint(address to, uint id) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[id] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    mapping(address=>tokenMetaData[]) public ownershipRecord;


    function mintToken(address recipient, string memory url) public {
        _mint(recipient, tokenId);
        ownershipRecord[recipient].push(tokenMetaData(tokenId, block.timestamp, url));
        tokenId = tokenId + 1;
    }


}
