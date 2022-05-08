// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../interfaces/KeeperCompatibleInterface.sol";
import "../interfaces/IERC20.sol" ;
import "./SafeMath.sol";

//Assumptions: 1:1 peg -> USDC : BankToken
// Can withdraw partially, bt only from the principal amt.
// Interest transferred only when deciding to unstake the complete amount

contract Bank is  KeeperCompatibleInterface {

	using SafeMath for uint256;

	address public usdc;
	address public bankToken;
	uint256 previousTime;
	uint256 interestRate;
	uint exponent = 5;

	constructor(address _bankToken, uint256 _interestRate) public {

		usdc = 0xeb8f08a975Ab53E34D8a0330E0D34de942C95926;
		bankToken =  _bankToken;
		previousTime = block.timestamp;
		interestRate = _interestRate;
	}

	address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping (address => uint) bankTokenInterest;
    mapping(address => bool) public hasStaked;

	// allow user to stake usdc tokens in contract
    function stakeTokens(uint _amount) public {

        // Trasnfer usdc tokens to contract for staking
        IERC20(usdc).transferFrom(msg.sender, address(this), _amount);

        // Update the staking balance in map
        stakingBalance[msg.sender] = stakingBalance[msg.sender].add(_amount.mul(10** exponent));

        // Add user to stakers array if they haven't staked already
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        hasStaked[msg.sender] = true;

    }

    // allow user to unstake total balance and withdraw USDC from the contract
    function unstakeTokens(uint _amount) public {

    	// get the users staking balance in usdc
    /*	if(_fullWithdrawal) {
    		unstakeTokensCompletely(_amount, msg.sender);
    		return;
    	}*/
    	uint balance = stakingBalance[msg.sender];
    
        // reqire the amount staked needs to be greater then 0
        uint amountScaled = _amount.mul(10 ** exponent);
        require(balance >= amountScaled, "Insufficient Balance");

        // reset staking balance map to 0
        stakingBalance[msg.sender] = stakingBalance[msg.sender].sub(amountScaled);
    
        // transfer usdc tokens out of this contract to the msg.sender
        IERC20(usdc).transfer(msg.sender, _amount);

	}

	function unstakeTokensCompletely(address _withdrawer) external {

		uint _amount = stakingBalance[_withdrawer];
		uint _amountScaled = _amount.div(10 ** exponent);
		//require(_amount == amountScaled, "Inalid withdrawal");
		stakingBalance[_withdrawer] = 0;
		IERC20(usdc).transfer(_withdrawer, _amountScaled);
		IERC20(bankToken).transfer(_withdrawer, bankTokenInterest[_withdrawer].div(10 ** exponent));
		bankTokenInterest[_withdrawer] = 0;
	}

	function checkUpkeep(bytes calldata ) external override returns (bool upkeepNeeded, bytes memory) {
       
        upkeepNeeded = (previousTime + 1 days == block.timestamp );

    }

    function performUpkeep(bytes calldata) external override {

    	if (previousTime + 1 days == block.timestamp ) {

    		calculateInterestToken();
    		previousTime = block.timestamp;
    	}
    }

    function calculateInterestToken() public {

        for (uint i=0; i<stakers.length; i++) {

            address recipient = stakers[i];
            uint principal = stakingBalance[recipient];
            uint interest = bankTokenInterest[recipient];
            uint amount = principal.add(interest);
            
            uint newInterest = interestRate.mul(amount).div(100*365); 
            bankTokenInterest[recipient] = newInterest; 
            
        }
        
    }

    function viewBalance(address _user) public view returns(uint) {
    	return stakingBalance[_user];
    }

    function viewAccumulatedInterest(address _user) public view returns(uint) {
    	return bankTokenInterest[_user];
    }

}



