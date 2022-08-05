import * as hardhat from 'hardhat';
import abi from '../artifacts/contracts/BratkiBeerChallenge.sol/BratkiBeerChallenge.json';
import { ENV } from '../env.config';
import { getSigner } from './utils';

async function main() {
    const contractAddress = ENV.BEER_CHALLENGE_CONTRACT_ADDRESS;
    const contractAbi = abi.abi;

    const beerChallenge = new hardhat.ethers.Contract(contractAddress, contractAbi, await getSigner());

    // if you want you can pass whatever you like in terminal
    const names = ['leo', 'butovsky']
    for (const name of names) {
        console.log(await beerChallenge.mint(name));
    }
}
  
  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });