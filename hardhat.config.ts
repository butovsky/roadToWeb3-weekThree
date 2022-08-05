import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-waffle";
import { ENV } from "./env.config";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    mumbai: { // to deploy on this network: npx hardhat run scripts/deploy.ts --network mumbai (and etc for other networks if we add anymore)
      url: ENV.MUMBAI_URL,
      accounts: [ENV.PRIVATE_KEY]
    }
  },
  etherscan: { // for verifying the smart contract
    // npx hardhat verify --network mumbai YOUR_SMARTCONTRACT_ADDRESS
    apiKey: ENV.POLYGONSCAN_API_KEY
  }
};

export default config;
