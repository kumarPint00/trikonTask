const { expect } = require( "chai");

const { ethers }= require("hardhat");
const {Contract, ContractFactory, Signer} =require("ethers");

let TestToken=ContractFactory;
let testtoken= Contract;
let accounts= [];

describe("Test Token", function () {
	
	beforeEach(async function () {
		// Get accounts
		accounts = await ethers.getSigners();
		// Deploy test token
		TestToken = await ethers.getContractFactory("TestToken");
		testtoken = await TestToken.deploy(10000000, "TestCoin", 0, "TEST");
		await testtoken.deployed();
	});
	
	it("Should have allocated total supply to token owner", async function () {
		const owner = await accounts[0].getAddress();
		expect(await testtoken.balanceOf(owner)).to.equal("10000000");
		
	});
	
	it("Should be able to transfer own tokens to another account ", async function () {
		const owner = await accounts[0].getAddress();
		const receiver = await accounts[1].getAddress();
		
		await testtoken.transfer(receiver, 5);
		expect(await testtoken.balanceOf(receiver)).to.equal("5");
		
	});
	
	it("Should be able to approve allowance for some spender account", async function () {
		const owner = await accounts[0].getAddress();
		const spender = await accounts[1].getAddress();
		
		await testtoken.approve(spender, 100);
		expect(await testtoken.allowance(owner, spender)).to.equal("100");
		
	});
	
	it("Should be able to spend on behalf of another account after getting approval", async function () {
		const owner = await accounts[0].getAddress();
		const spender = await accounts[1].getAddress();
		const receiver = await accounts[2].getAddress();
		
		await testtoken.approve(spender, 100);
		await testtoken.connect(accounts[1]).transferFrom(owner, receiver, 100);
		expect(await testtoken.balanceOf(receiver)).to.equal("100");
		
	});
	
});
