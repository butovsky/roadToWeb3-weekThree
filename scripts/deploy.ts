import hardhat from 'hardhat';
import { ENV } from '../env.config';
import { DeployedContracts, DeployedContractsType } from './types';

async function main(contractName: DeployedContractsType) {
    await deploy(contractName);
  }
  
  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main(DeployedContracts.BRATKI_BEER_CHALLENGE).catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });


export async function deploy (contractName: DeployedContractsType) {
    const contractFactory = await hardhat.ethers.getContractFactory(contractName);
    const contract = await contractFactory.deploy();

    console.log(contract.address)

    await contract.deployed();
  
    console.log(`Contract "${contractName}" deployed to: ${contract.address}`);
    // on testnet there will be the same address
    // BUT!!! on real blockchain deploy will occur on different addresses
    // thus these contracts will be separate, even if they are similar

    return contract;
}