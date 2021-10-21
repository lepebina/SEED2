Feature: analysis
 #pair 1    
      Scenario: Blacklisted with no profile customer sends mo with HELP keyword to free short code- mbaxqna9-31
     Given User has "355004567893" msisdn
     And User has no profile
     And User is blacklisted	
     When User sends sms with input "HELP" to free short code
     Then User has profile
     And Sms is being processed by the "BLACKLISTED" request
     And User receives the "BLACKLISTED" reply from free short code
     And User receives the "text_key_blacklisted" text from free short code for "BLACKLISTED" reply
     And User does not get charged for the sms
     And User is not blacklisted
     
     
     Scenario: Blacklisted with no profile customer sends mo with HELP message to free short code- mbaxqna9-31
     Given User has "355004567893" msisdn
     And User has no profile
     And User is blacklisted	
     When User sends sms with input "HELP" to free short code
     Then User has profile
     And Sms is being processed by the "BLACKLISTED" request
     And User receives the "BLACKLISTED" reply from free short code
     And User receives the "text_key_blacklisted" message from free short code for "BLACKLISTED" reply
     And User does not get charged for the message sent
     And User is not blacklisted
     
     #Pair 2
     Scenario: Blacklisted with no profile customer sends mo with HELP keyword to free short code-blacklist
    Given User has "355004567893" msisdn
    And User has no profile
    And  User is blacklisted
    When User sends sms with input "HELP" to free short code
    Then User has profile
    And User has no subscription profile
    And Sms is being processed by the "BLACKLISTED" request
    And User receives the "BLACKLISTED" reply from free short code
    And User receives the "text_key_blacklisted" text from free short code for "BLACKLISTED" reply
    And User does not get charged for the sms
    And User is not blacklisted
    
    Scenario: Blacklisted user with no profile should not be charged for sending HELP message-4
    Given User is blacklisted
    And User has no profile
    And  has "355004567893" msisdn
   When User sends sms with the text "HELP" to free short code
    Then User has profile
    And User has no subscription
    And the "BLACKLISTED" request processes the sms
    And User gets a reply with the text  "BLACKLISTED" from free short code
    And User receives the "text_key_blacklisted" text from free short code for "BLACKLISTED" reply
    And User does not get charged for the sms
    And User is not blacklisted
    
    #Pair 3
    Scenario: Subscribed user sends mo with QUIT to free short code
    Given User has "355006740004" msisdn
    And User has no profile
    When User sends sms with input "YES" to free short code
    Then User has profile
    When User sends sms with input "QUIT" to free short code
    Then User is unsubscribed in subscription profile
    And Sms is being processed by the "UNSUBSCRIBE" request
    
    Scenario: A subscribed user sends a free short code messages-15
	Given "355006740004" msisdn is the identification code for the user with no profile
	When A "YES" sms  is sent by the user
	Then The profile is created
    When The same user sends a "QUIT" sms
    Then The user will be unsubscribed from the profile
    And A request is sent to "UNSUBSCRIBED" in response to the sms     