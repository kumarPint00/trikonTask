// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

const {ethers} =require("hardhat");

async function main() {
	
	const tokenSupply = 10000000;
	const tokenName = "TestCoin";
	const tokenDecimals = 0;
	const tokenSymbol = "TEST";
	
	// 1. Deploy Test Token
	const TestToken = await ethers.getContractFactory("TestToken");
	const Testtoken = await TestToken.deploy(tokenSupply, tokenName, tokenDecimals, tokenSymbol);
	
	await Testtoken.deployed();
	
	console.log("Test Token deployed to :", Testtoken.address);
	
	const flaggingThreshold = 5;
	
	// 2. Deploy NFT
	const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy();

	await nft.deployed();
	
	console.log("NFT Contract deployed to :", nft.address);
	
	// 3. Deploy Market
	const Market = await ethers.getContractFactory("Marketplace");
	const market = await Market.deploy("0x5FbDB2315678afecb367f032d93F642f64180aa3", '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512');
	
	await market.deployed();
	
	console.log("Market Contract deployed to :", market.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
