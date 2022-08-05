import hardhat from 'hardhat'
import { ENV } from '../env.config';

export const getSigner = async () => {
    // connection to AlchemyProvider based on contract address and on API key of the network, on which the contract is deployed
    const provider = new hardhat.ethers.providers.AlchemyProvider("maticmum", ENV.MUMBAI_API_KEY);

    // private key is of the original creator of the contract, in spite of whoever the owner is now
    return new hardhat.ethers.Wallet(ENV.PRIVATE_KEY, provider);
}