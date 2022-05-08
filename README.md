# DeFiBank

## Introducton
This is a starter project to automate the savings account functionality of a bank. Basically, when we keep our money in the savings account, interest gets credited to our account at the end of each day.
Here, the user is depositing USDC in his account and the interest he earns (at a fixed rate) is in the bankToken (token used by DeFi Bank). 

# Assumption
Here we have taken 1:1 peg for USDC and bankToken. In future, when bankToken is  listed on DeFi exchanges, we can pull the real-time price using ChainLink Oracle and use it to compute interest.

## Workflow
The workflow is illustarted by taking user1 as the account holder in the DeFi Bank.
There are two unstaking options (withdrawal) for user1:
a. Partial withdrawal: Where he can withdraw requested amount of USDC only from the principal.
b. Complete withdrawal: Where he withdraws the complete principal and the accumulated intreest bankToken is also transferred to him.

The contract is Keeper Compatible. Hence, the calculateInterest() function is called at an interval of 24 hours by the Keeper node calculating the interest accumulated in all the users’ account.

![1](https://user-images.githubusercontent.com/32013812/167298641-76b62777-bd47-4ef8-8868-8a2f887f5890.png)


![2](https://user-images.githubusercontent.com/32013812/167298650-bf6eb33b-9698-42d2-97cf-5c639a9d8b8b.png)



![3](https://user-images.githubusercontent.com/32013812/167298662-bde374e9-689a-47dd-877c-dbfa85690b96.png)



## Contract Address
The contract is deployed on Rinkeby testnet at 0x560779519569d88Fdf0044fC41c75c741546b4b7
