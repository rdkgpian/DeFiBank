const DefiBank = artifacts.require("Bank");
const { sendEther, pow } = require("./util");
const BigNumber = require('bignumber.js');
const truffleAssert = require('truffle-assertions');
const IERC20 = artifacts.require("IERC20");


contract("TokenSwap", (accounts) => {

	let bankToken;
	let bankTokenAddress = "0x7D59bC414aF341c6715cc566fFA34471bc4f9c09"	;
	let interestRate = 5;
	let usdcAddress = "0xeb8f08a975Ab53E34D8a0330E0D34de942C95926";
	let usdc;
	let instance;	
	const num = new BigNumber('1e+20');
   before('should setup the contract instance', async () => {
    instance = await DefiBank.new(bankTokenAddress, interestRate, {from: accounts[0]});
    bankToken = await IERC20.at(bankTokenAddress);
    const output = [];
    for(const acct of accounts){
      //await web3.eth.personal.unlockAccount(acct);
      await output.push(acct);
    }
    console.debug(`The number of accounts : ${accounts.length}`);
    console.table(output)
     usdc = await IERC20.at(usdcAddress);
     
     //Approving the Bank contract to transfer usdc from the wallet accounts(depositors) to itself
    for(var i =0; i<3; i++) {
    	await usdc.approve("0x560779519569d88fdf0044fc41c75c741546b4b7", new BigNumber('1e+20') , {from: accounts[i]});
  }	


    //As of now, total supply of bankToken is with accounts[0] of metamask who is the creator of the ERC20 contract
    await bankToken.transfer("0x560779519569d88fdf0044fc41c75c741546b4b7", new BigNumber('1e+24'), {from: accounts[0]});

  });

   describe("Stake and unstake test for user1", () => {

   it("View Balance", async () => {
   	const result = await instance.viewBalance(accounts[0], {from: accounts[0]});
   	console.log(result.toNumber());
   });

   it("Staking tokens", async () => {
   		await instance.stakeTokens(new BigNumber('1e+18'), {from: accounts[0]});
   	});

   	it("View Interest", async () => {
   	const result = await instance.viewAccumulatedInterest(accounts[0], {from: accounts[0]});
   	console.log(result.toNumber());
   });

   	it("Calculating interest", async () => {
   		await instance.calculateInterestToken({from: accounts[0]});
   	});

   	it("Unstaking tokens", async () => {
   		await instance.unstakeTokens(10, {from: accounts[0]});
   	});

   	it("View Interest", async () => {
   	const result = await instance.viewAccumulatedInterest(accounts[0], {from: accounts[0]});
   	console.log(result.toNumber());
   });

   	it("Calculating interest", async () => {
   		await instance.calculateInterestToken({from: accounts[0]});
   	});

   	it("View Interest", async () => {
   	const result = await instance.viewAccumulatedInterest(accounts[0], {from: accounts[0]});
   	console.log(result.toNumber());
   	});

   	it("Unstake tokens completely", async () => {
   		instance.unstakeTokensCompletely(accounts[0], {from: accounts[0]});
   	});

     it("View Balance", async () => {
   	const result = await instance.viewBalance(accounts[0], {from: accounts[0]});
   	console.log(result.toNumber());
   });

    it("View Interest", async () => {
   	const result = await instance.viewAccumulatedInterest(accounts[0], {from: accounts[0]});
   	console.log(result.toNumber());
   	});

   	});


});