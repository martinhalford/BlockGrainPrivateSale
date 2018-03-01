pragma solidity ^0.4.18;

import "SafeMath.sol";

contract PrivateSale {
  using SafeMath for uint256;

  // Address of owner
  address public owner;

  // Address where funds are collected
  address public wallet;

  // Amount of wei raised
  uint256 public weiRaised;

  // Flag to accept or reject payments
  bool public isAcceptingPayments;

  // List of addresses that are whitelisted for private sale
  mapping (address => bool) public whitelist;
  uint256 public whitelistCount;

  // List of addresses that have made payments
  mapping (address => uint256) public weiPaid;

  // modifier to check owner
  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }

  // modifier to check if whitelisted address
  modifier isWhitelisted() {
      require(whitelist[msg.sender]);
      _;
  }

  // modifier to check if payments being accepted
  modifier acceptingPayments() {
    require(isAcceptingPayments);
    _;
  }

  /**
   * Constructor
   * @param _wallet Address where collected funds will be forwarded to
   */
  function PrivateSale(address _wallet) public {
    require(_wallet != address(0));
    owner = msg.sender;
    wallet = _wallet;
  }

  /**
   * @dev fallback function
   */
  function () payable isWhitelisted acceptingPayments public {

    require(msg.value != 0);
    require(msg.sender != address(0));

    // add to sender's weiPaid record
    weiPaid[msg.sender] = msg.value;

    // add to amount raised
    weiRaised = weiRaised.add(msg.value);

    // transfer funds to external wallet
    wallet.transfer(msg.value);
  }

  /**
   * @dev Start accepting payments
   */
  function acceptPayments() onlyOwner public  {
    isAcceptingPayments = true;
  }

  /**
   * @dev Stop accepting payments
   */
  function rejectPayments() onlyOwner public  {
    isAcceptingPayments = false;
  }

  /**
   * @dev Add an address to the whitelist
   * @param _user The address of the contributor
   */
  function whitelistAddress(address _user) onlyOwner public  {
    whitelist[_user] = true;
    whitelistCount++;
  }

  /**
   * @dev Add multiple addresses to the whitelist
   * @param _users The addresses of the contributor
   */
  function whitelistAddresses(address[] _users) onlyOwner public {
    for (uint i = 0; i < _users.length; i++) {
        whitelist[_users[i]] = true;
        whitelistCount++;
      }
  }

  /**
   * @dev Remove an addresses from the whitelist
   * @param _user The addresses of the contributor
   */
  function unWhitelistAddress(address _user) onlyOwner public  {
    whitelist[_user] = false;
    whitelistCount--;
  }

  /**
   * @dev Remove multiple addresses from the whitelist
   * @param _users The addresses of the contributor
   */
  function unWhitelistAddresses(address[] _users) onlyOwner public {
    for (uint256 i = 0; i < _users.length; i++) {
      whitelist[_users[i]] = false;
      whitelistCount--;
    }
  }
}
