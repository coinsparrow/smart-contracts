pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Arbitrator is Ownable {

  mapping(address => bool) private aribitratorWhitelist;
  address primaryArbitrator;

  event ArbitratorAdded(address indexed newArbitrator);
  event ArbitratorRemoved(address indexed newArbitrator);
  event ChangePrimaryArbitratorWallet(address indexed newPrimaryWallet);

  function Arbitrator() public {
    primaryArbitrator = msg.sender;
  }

  modifier onlyArbitrator() {
    require(aribitratorWhitelist[msg.sender] == true || msg.sender == primaryArbitrator);
    _;
  }

  function changePrimaryArbitrator(address walletAddress) public onlyOwner {
    require(walletAddress != address(0));
    emit ChangePrimaryArbitratorWallet(walletAddress);
    primaryArbitrator = walletAddress;
  }

  function addArbitrator(address newArbitrator) public onlyOwner {
    require(newArbitrator != address(0));
    emit ArbitratorAdded(newArbitrator);
    aribitratorWhitelist[newArbitrator] = true;
  }

  function deleteArbitrator(address arbitrator) public onlyOwner {
    require(arbitrator != address(0));
    require(arbitrator != msg.sender); //ensure owner isn't removed
    emit ArbitratorRemoved(arbitrator);
    delete aribitratorWhitelist[arbitrator];
  }

  //Mainly for front-end administration
  function isArbitrator(address arbitratorCheck) external view returns(bool) {
    return (aribitratorWhitelist[arbitratorCheck] || arbitratorCheck == primaryArbitrator);
  }
}

