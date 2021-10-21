package uk.ac.manchester.cs.img.seed.development.feature.stepdefinitions;

import static org.junit.Assert.assertTrue;
import cucumber.api.java.en.Then;
import uk.ac.manchester.cs.img.seed.prod.ProdClass;

public class StepDefs {

    @Then("^swans exist$")
    public void swans_exist() throws Throwable {
      assertTrue(ProdClass.swansExist());
    }

    @Then("^there are some swans$")
    public void there_are_some_swans() throws Throwable {
      assertTrue(ProdClass.swansExist());
    }
}