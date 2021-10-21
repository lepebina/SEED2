Feature: ATM transactions
As an account holder, whenever
I perform ATM withdrawals, I want my
balance to be updated

@running-example
Scenario: Successful withdrawal from account
Given my account is in credit by $100
When I request withdrawal of $20
Then $20 should be dispensed 
And my balance should be $80