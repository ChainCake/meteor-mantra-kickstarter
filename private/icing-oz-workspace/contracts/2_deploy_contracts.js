var IcingToken = artifacts.require("./IcingToken.sol");

module.exports = function(deployer) {
  deployer.deploy(IcingToken);
};
