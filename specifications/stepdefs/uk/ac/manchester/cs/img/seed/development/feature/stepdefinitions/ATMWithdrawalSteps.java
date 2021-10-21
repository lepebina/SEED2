package uk.ac.manchester.cs.img.seed.development.feature.stepdefinitions;

import static org.junit.Assert.assertEquals;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import uk.ac.manchester.cs.img.seed.prod.BankAccount;

public class ATMWithdrawalSteps {
	  BankAccount account;
	@Given("^my account is in credit by \\$(\\d+)$")
	public void my_acc_is_in_credit_by_$(int amt) {
	  account = new BankAccount(amt);
	}
	@When("^I request withdrawal of \\$(\\d+)$")
	public void i_request_withdrawal_of(int amt) {
	  account.updateBankAccount(amt);
	}
	@Then("^\\$(\\d+) should be dispensed$")
	public void should_be_dispensed(int ant) {
	  // cash dispensing code goes here
	}
	@Then("^my balance should be \\$(\\d+)$")
	public void my_balance_should_be(int amt) {
	  assertEquals(amt,account.getAccountBalance());
	}}