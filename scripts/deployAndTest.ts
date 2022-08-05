import hardhat from "hardhat";
import { BratkiBeerChallenge} from "../typechain-types"; // very important and cool for any kinds of interfaces!
import { deploy } from "./deploy";
import { DeployedContracts } from "./types";

// in this function we also test the contract on initialization
async function main() {

  const [owner] = await hardhat.ethers.getSigners();

  const beerChallenge = await deploy(DeployedContracts.BRATKI_BEER_CHALLENGE) as BratkiBeerChallenge;

  const names = ['uniqueoleg', 'aleksfive', 'tigdevadim', 'soteoriginal', 'sench1k', 'qabancheeck', 'butovsky']
    for (const i in names) {
        await beerChallenge.connect(owner).mint(names[i]);
        console.log(await beerChallenge.tokenIdToContestant(i));
    }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
