Feature: detect duplicate scenarios in a single feature

Scenario: detect semantic duplication in a feature with two textually dissimilar scenarios

Given a feature file with two scenarios
And   one scenario consists of only "Then swans exist"
And   the other scenario consists of only "Then there are some swans"
And   there is a production method called "swansExist"
And   the method takes no parameters and returns a value of type "boolean" 
And   there is a step definition matching "swans exist"
And   this step definition just calls method "swansExist"
And   there is another step definition matching "there are some swans"
And   this step definition also just calls method "swansExist"
When  a report on the semantic duplicates is requested
Then  SEED2 reports that these two scenarios duplicate each other