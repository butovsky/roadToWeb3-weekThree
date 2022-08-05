import * as dotenv from 'dotenv';
dotenv.config(); // connecting to .env

export const ENV = {
    MUMBAI_URL: process.env.MUMBAI_URL as string,
    PRIVATE_KEY: process.env.PRIVATE_KEY as string,
    POLYGONSCAN_API_KEY: process.env.POLYGONSCAN_API_KEY as string,
    MUMBAI_API_KEY: process.env.MUMBAI_API_KEY as string,
    BEER_CHALLENGE_CONTRACT_ADDRESS: process.env.BEER_CHALLENGE_CONTRACT_ADDRESS as string
}