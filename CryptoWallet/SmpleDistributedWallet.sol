pragma solidity^0.7.0;
/**
 * A Demo on solidity - contract based programing..
 * where we are going to work on smart contracts..
 * 
 * This is simple Distributed Crypto Wallet which can store and modify etherium balance.
 * 
 * 
 * Created using #Remix -Etherium IDE.
 * 
 * 
 * */
contract Wallet{//similar to class in OOPs.
    bool public pause;
    address public owner;
    constructor()public{//constructor to initiate 
        owner = msg.sender;//stores eth address on owner variable
    }
    
    struct payment{
        uint amount;
        uint timestamp;
    }
    
    struct Balance{
        uint totalBalance;
        uint numOfPayment;
        mapping(uint=>payment)payments;
    }

    mapping(address=>Balance) public Balance_rec;//mapping address and Balance on it.
    event sendingether(address indexed ad1,uint amnt1);//event varible for send function.
    event receiveEther(address indexed ad2,uint amnt2);//creating event variable for withdraw function
    modifier ownerOnly(){//modifier to check conditions.
        require(msg.sender==owner,'You are Not Owner ..Go Away..');//checks and allows only owner.
        _;
    }
    
    modifier notOnPause(){//to give a pause and resume switches for Transactions.
        require(pause==false,'Transactions are paused by admin....Try later....');
        _;
    }
    
    function pauseAndResume(bool pau) public{
        pause = pau;
    }
    
    function sendMoney()public payable notOnPause{
        Balance_rec[msg.sender].totalBalance+=msg.value;
        Balance_rec[msg.sender].numOfPayment+=1;
        payment memory pay = payment(msg.value,block.timestamp);
        Balance_rec[msg.sender].payments[Balance_rec[msg.sender].numOfPayment] =pay;
        emit sendingether(msg.sender,msg.value);
    }
    
    function getBalance()public view notOnPause returns(uint){
        return Balance_rec[msg.sender].totalBalance;
    }
    
    function covertToEth(uint amtInWei) public pure returns(uint){//converts Wei to ether
        return amtInWei/1 ether;
    }
    
    function withdraw(uint withdrawAmt) notOnPause public{
        require(Balance_rec[msg.sender].totalBalance >= withdrawAmt,'Less Funds Unable to dispatch');
        Balance_rec[msg.sender].totalBalance -=withdrawAmt;
        msg.sender.transfer(withdrawAmt);
        emit receiveEther(msg.sender,withdrawAmt);
    }
    function desttroySC(address payable ends) public ownerOnly{
        selfdestruct(ends);//all the ether will be sent to provided address and the block will be destroyed
        //We can't deleted the block but we can destroy it. any amount send to the destroyed block will be lost.
    }
    
}
