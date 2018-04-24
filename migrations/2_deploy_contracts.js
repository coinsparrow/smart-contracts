var ECRecovery = artifacts.require("../node_modules/zeppelin-solidity/contracts/ECRecovery.sol")
var CoinSparrow = artifacts.require("./CoinSparrow.sol");

module.exports = function(deployer, network, accounts) {

  deployer.deploy(ECRecovery).then(() => {
        deployer.link(ECRecovery, CoinSparrow);
        return liveDeploy(deployer, accounts);
    });
};

async function liveDeploy(deployer, accounts) {

  const MAX_SEND = 10;
  return deployer.deploy(CoinSparrow,web3.toWei(MAX_SEND, "ether")).then( async () => {
    const instance = await CoinSparrow.deployed();
    const contractAddress = await instance.address;

    console.log('--------INFO-----------------');
    console.log('Contract Address to interact:', contractAddress);
    console.log('-----------------------------');
  })
}
