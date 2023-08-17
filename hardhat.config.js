require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config()

module.exports = {
  solidity: "0.8.19",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.API_KEY
  }
};
