pragma solidity ^0.4.23;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract ApprovedWithdrawer is Ownable {

  mapping(address => bool) private withdrawerWhitelist;
  address private primaryWallet;

  event WalletApproved(address indexed newAddress);
  event WalletRemoved(address indexed removedAddress);
  event ChangePrimaryApprovedWallet(address indexed newPrimaryWallet);

  constructor() public {
    primaryWallet = msg.sender;
  }

  modifier onlyApprovedWallet(address _to) {
    require(withdrawerWhitelist[_to] == true || primaryWallet == _to);
    _;
  }

  function changePrimaryApprovedWallet(address walletAddress) public onlyOwner {
    require(walletAddress != address(0));
    emit ChangePrimaryApprovedWallet(walletAddress);
    primaryWallet = walletAddress;
  }

  function addApprovedWalletAddress(address walletAddress) public onlyOwner {
    require(walletAddress != address(0));
    emit WalletApproved(walletAddress);
    withdrawerWhitelist[walletAddress] = true;
  }

  function deleteApprovedWalletAddress(address walletAddress) public onlyOwner {
    require(walletAddress != address(0));
    require(walletAddress != msg.sender); //ensure owner isn't removed
    emit WalletRemoved(walletAddress);
    delete withdrawerWhitelist[walletAddress];
  }

  //Mainly for front-end administration
  function isApprovedWallet(address walletCheck) external view returns(bool) {
    return (withdrawerWhitelist[walletCheck] || walletCheck == primaryWallet);
  }
}
