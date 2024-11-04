
require('dotenv').config();
const { MNEMONIC_PHRASE, INFURA_PROJECT_ID, INFURA_BASE_URL} = process.env;

const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    development: {
     host: "127.0.0.1",    
     port: 8545,            
     network_id: "*",      
    },
    sepolia: {
        provider: () => new HDWalletProvider(MNEMONIC_PHRASE, `${INFURA_BASE_URL}/${INFURA_PROJECT_ID}`),
        network_id: 11155111,
        gas: 8000000,
    }
    
  },

  mocha: {
    timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.8.21",     
      docker: true,       
      settings: {         
       optimizer: {
         enabled: false,
         runs: 200
       },
       evmVersion: "byzantium"
      }
    }
  },

};
