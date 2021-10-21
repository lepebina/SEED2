package uk.ac.manchester.cs.img.seed.prod;

public class BankAccount {
	   int accountBalance;

	   public BankAccount(int balance) {
	      accountBalance = balance;
	   }

	   public void updateBankAccount
	   (int deductableAmount) {
	      accountBalance -= deductableAmount;		
	   }

	   public int getAccountBalance() {
	      return accountBalance;		
	   }
	}
