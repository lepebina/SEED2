package uk.ac.manchester.cs.img.seed.stepdefinitions;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.LinkedList;
import java.util.List;

import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;

import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeDiagnosingMatcher;
import org.w3c.dom.Node;
import uk.ac.manchester.cs.img.seed.Seed;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import net.sf.saxon.xqj.SaxonXQDataSource;

public class StepDefinitions {

    private static final String TEST_DATA_LOCATION = "test_data";
    private static final String FEATURE_FILE_LOCATION = TEST_DATA_LOCATION + "/specification/features/duplicationDetectionFeature.feature";
    private static final String STEPDEFS_LOCATION = TEST_DATA_LOCATION + "/specification/stepDefinitions/StepDefs.java";
    private static final String PRODCLASS_LOCATION = TEST_DATA_LOCATION + "/src/ProdClass.java";

    private static final String TRACING_FILES_LOCATION = "tracing";
    private static final String TRACING_ABSTRACT_ASPECT_SOURCE_LOCATION = TRACING_FILES_LOCATION + "/AbstractAspect.txt";
    private static final String TRACING_ABSTRACT_ASPECT_DESTINATION_LOCATION = TEST_DATA_LOCATION + "/src/AbstractLoggingAspect.java";
    private static final String TRACING_CONCRETE_ASPECT_SOURCE_LOCATION = TRACING_FILES_LOCATION + "/ConcreteAspect.txt";
    private static final String TRACING_CONCRETE_ASPECT_DESTINATION_LOCATION = TEST_DATA_LOCATION + "/src/ConcreteLoggingAspect.java";
    private static final String TRACING_CUSTOM_FORMATTER_SOURCE_LOCATION = TRACING_FILES_LOCATION + "/CustomFormatter.txt";
    private static final String TRACING_CUSTOM_FORMATTER_DESTINATION_LOCATION = TEST_DATA_LOCATION + "/src/CustomFormatter.java";
    private static final String TRACING_XML_WRITE_SOURCE_LOCATION = TRACING_FILES_LOCATION + "/WriteXmlTraceToFile.txt";
    private static final String TRACING_XML_WRITE_DESTINATION_LOCATION = TEST_DATA_LOCATION + "/src/WriteXmlTraceToFile.java";

    private static final String DUPLICATION_REPORT_LOCATION = TEST_DATA_LOCATION + "/duplication.xml";

    private static final String NEWLINE = "\n";
    private static final String DOUBLE_QUOTE = "\"";

    private static final String SCENARIO_TWO_BODY = "SCENARIO_TWO_BODY";
    private static final String SCENARIO_ONE_BODY = "SCENARIO_ONE_BODY";
    private static final String RESULT_TYPE = "RESULT_TYPE";
    private static final String PARAMETERS = "PARAMETERS";
    private static final String PRODUCTION_METHOD_BODY = "PRODUCTION_METHOD_BODY";
    private static final String IMPORTS = "IMPORTS";
    private static final String STEP_DEF_BODY = "STEPDEFBODY";

    private static final String FEATURE_NAME = "fake feature name";
    private static final String SCENARIO_ONE_NAME = "fake scenario one";
    private static final String SCENARIO_TWO_NAME = "fake scenario two";

    private String feature;
    private String stepDef;
    private String productionClass;
    private XQResultSequence duplicatedScenarios;


    /* Steps that create features */

    @Given("^a feature file with two scenarios$")
    public void a_feature_file_with_two_scenarios() throws Throwable {
        feature = "Feature: " + "fake feature name" + NEWLINE +
                NEWLINE +
                "Scenario: " + SCENARIO_ONE_NAME + NEWLINE +
                NEWLINE +
                SCENARIO_ONE_BODY + NEWLINE +
                NEWLINE +
                "Scenario: " + SCENARIO_TWO_NAME + NEWLINE +
                NEWLINE +
                SCENARIO_TWO_BODY + NEWLINE +
                NEWLINE;
    }


    /* Steps that create scenarios */

    @Given("^one scenario consists of only \"(.*)\"$")
    public void one_scenario_consists_of_only(String scenarioBody) throws Throwable {
        feature = feature.replaceFirst("SCENARIO_ONE_BODY", scenarioBody);
    }

    @Given("^the other scenario consists of only \"(.*)\"$")
    public void the_other_scenario_consists_of_only(String scenarioBody) throws Throwable {
        feature = feature.replaceFirst(SCENARIO_TWO_BODY, scenarioBody);
    }


    /* Step definitions that define production code */	

    @Given("^there is a production method called \"([^\"]*)\"$")
    public void there_is_a_production_method_called(String prodMethodName) throws Throwable {
        productionClass = "package prod;" + NEWLINE +
                "public class ProdClass {" + NEWLINE +
                NEWLINE +
                "  public static " + RESULT_TYPE + " " + prodMethodName + "(" + PARAMETERS + ") throws Throwable {" + NEWLINE +
                "    " + PRODUCTION_METHOD_BODY + NEWLINE +
                "  }" + NEWLINE +
                NEWLINE +
                "}" + NEWLINE;
    }

    @Given("^the method takes no parameters and returns a value of type \"([^\"]*)\"$")
    public void the_method_takes_no_parameters_and_returns_a_value_of_type(String resultType) throws Throwable {
        productionClass = productionClass.replaceFirst(RESULT_TYPE, resultType);
        productionClass = productionClass.replaceFirst(PARAMETERS, "");
        productionClass = productionClass.replaceFirst(PRODUCTION_METHOD_BODY, "return true;");
    }


    /* Steps that create step definition declarations */

    @Given("^there is a step definition matching \"(.*)\"$")
    public void there_is_a_step_definition_matching(String stepDescription) throws Throwable {		
        stepDef = "package test;" + NEWLINE +
                "import static org.junit.Assert.assertTrue;" + NEWLINE +
                IMPORTS + NEWLINE +
                "import cucumber.api.java.en.Then;" + NEWLINE +
                NEWLINE +
                "public class StepDefs {" + NEWLINE +
                NEWLINE +
                "  @Then(" + DOUBLE_QUOTE + "^" + stepDescription + "$" + DOUBLE_QUOTE + ")" + NEWLINE +
                "  public void " + convertStepDescriptionToMethodName(stepDescription) + "() throws Throwable {" + NEWLINE +
                "    assertTrue(" + STEP_DEF_BODY + ");" + NEWLINE +
                "  }" + NEWLINE +
                NEWLINE;
    }

    @Given("^there is another step definition matching \"(.*)\"$")
    public void there_is_another_step_definition_matching(String anotherStepDescription) throws Throwable {
        stepDef = stepDef +
                "  @Then(" + DOUBLE_QUOTE + "^" + anotherStepDescription + "$" + DOUBLE_QUOTE + ")" + NEWLINE +
                "  public void " + convertStepDescriptionToMethodName(anotherStepDescription) + "() throws Throwable {" + NEWLINE +
                "    assertTrue(" + STEP_DEF_BODY + ");" + NEWLINE +
                "  }" + NEWLINE +
                NEWLINE +
                "}" + NEWLINE;
    }

    @Given("^this step definition (?:also )?just calls method \"([^\"]*)\"$")
    public void this_step_definition_just_calls_method(String methodName) throws Throwable {
        String requiredImports = "import static org.junit.Assert.assertTrue;" + NEWLINE + 
                "import prod.ProdClass.*;" + NEWLINE + 
                NEWLINE;
        stepDef = stepDef.replaceFirst(IMPORTS, requiredImports);
        stepDef = stepDef.replaceAll(STEP_DEF_BODY, "prod.ProdClass." + methodName + "()"); 
    }


    /* Actions that request duplicate reports */

    @When("^a report on the semantic duplicates is requested$")
    public void a_report_on_the_semantic_duplicates_is_requested() throws Throwable, Exception {		
        createFileStructureForTestFiles();	   
        executeDuplicateDetection();					 	
    }


    /* Steps that check the results of duplicate detection */

    @Then("^SEED2 reports that these two scenarios duplicate each other$")
    public void seed_reports_that_these_two_scenarios_duplicate_each_other() throws Throwable {
        assertThat(DUPLICATION_REPORT_LOCATION, is(theLocationOfAnExistingFile()));
        File duplicationReportFile = new File(DUPLICATION_REPORT_LOCATION);
        assertThat(duplicationReportFile , reportsDuplicationBetween(theScenarioCalled(SCENARIO_ONE_NAME), 
                and(theScenarioCalled(SCENARIO_TWO_NAME)),
                in(theFeatureCalled(FEATURE_NAME))));		
    }


    /** Custom Matchers **/

    private Matcher<String> theLocationOfAnExistingFile() {
        return new TypeSafeDiagnosingMatcher<String>() {

            @Override
            public void describeTo(Description description) {
                description.appendText("a path to an existing file");
            }

            @Override
            protected boolean matchesSafely(String fileLocation, Description mismatchDescription) {
                mismatchDescription.appendText("the file does not exist");
                return (new File(fileLocation)).exists();
            }

        };
    }

    private Matcher<File> reportsDuplicationBetween(final String scenarioName1, final String scenarioName2, final String featureName) {
        return new TypeSafeDiagnosingMatcher<File>() {

            @Override
            public void describeTo(Description description) {
                description.appendText("a report that duplication exists between the scenario called <")
                .appendValue(scenarioName1)
                .appendText("> and the scenario named <")
                .appendValue(scenarioName2)
                .appendText("> in the feature called <")
                .appendValue(featureName)
                .appendText(">");
            }

            @Override
            protected boolean matchesSafely(File reportFile, Description mismatchDescription) {
                try {
                    if (numberOfDuplicationsFound() == 0) {
                        mismatchDescription.appendText("a report that says no duplications have been found");
                        return false;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                List<String> relevantDuplications = null;
                try {
                    relevantDuplications = getDuplicationsWith(featureName, scenarioName1);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (relevantDuplications.isEmpty()) {
                    mismatchDescription.appendText("a report that says no duplications with the scenario called <")
                    .appendValue(scenarioName1)
                    .appendText("> in the feature called <")
                    .appendValue(featureName)
                    .appendText("> have been found");
                    return false;
                }

                if (!relevantDuplications.contains(scenarioName2)) {
                    mismatchDescription.appendText("a report that says the scenario called <")
                    .appendValue(scenarioName1)
                    .appendText("> in the feature called <")
                    .appendValue(featureName)
                    .appendText("> only duplicates the following scenarios: ")
                    .appendValueList("<", ", ", ">", relevantDuplications);
                    return false;
                }

                return true;
            }

        };
    }


    /** Helper methods to  support various matters in step definitions **/

    public String convertStepDescriptionToMethodName(String stepDesc){
        return stepDesc.replaceAll(" ", "_");
    }

    public void createFileStructureForTestFiles() throws IOException{
        clearOutTestDataDirectory();

        Path featureFilePath = FileSystems.getDefault().getPath(FEATURE_FILE_LOCATION);
        Files.createDirectories(featureFilePath.getParent());
        Files.write(featureFilePath, feature.getBytes(), StandardOpenOption.CREATE);

        Path stepDefsClassPath = FileSystems.getDefault().getPath(STEPDEFS_LOCATION);
        Files.createDirectories(stepDefsClassPath.getParent());
        Files.write(stepDefsClassPath, stepDef.getBytes(), StandardOpenOption.CREATE);

        Path prodClassPath = FileSystems.getDefault().getPath(PRODCLASS_LOCATION);
        Files.createDirectories(prodClassPath.getParent());
        Files.write(prodClassPath, productionClass.getBytes(), StandardOpenOption.CREATE);

        Path abstractAspectDestinationClassPath = FileSystems.getDefault().getPath(TRACING_ABSTRACT_ASPECT_DESTINATION_LOCATION);
        Path abstractAspectSourceClassPath = FileSystems.getDefault().getPath(TRACING_ABSTRACT_ASPECT_SOURCE_LOCATION);
        Files.createDirectories(abstractAspectDestinationClassPath.getParent());
        Files.copy(abstractAspectSourceClassPath, abstractAspectDestinationClassPath);

        Path concreteAspectDestinationClassPath = FileSystems.getDefault().getPath(TRACING_CONCRETE_ASPECT_DESTINATION_LOCATION);
        Path concreteAspectSourceClassPath = FileSystems.getDefault().getPath(TRACING_CONCRETE_ASPECT_SOURCE_LOCATION);
        Files.createDirectories(concreteAspectDestinationClassPath.getParent());
        Files.copy(concreteAspectSourceClassPath, concreteAspectDestinationClassPath);

        Path formatterDestinationClassPath = FileSystems.getDefault().getPath(TRACING_CUSTOM_FORMATTER_DESTINATION_LOCATION);
        Path formatterSourceClassPath = FileSystems.getDefault().getPath(TRACING_CUSTOM_FORMATTER_SOURCE_LOCATION);
        Files.createDirectories(formatterDestinationClassPath.getParent());
        Files.copy(formatterSourceClassPath, formatterDestinationClassPath);

        Path xmlDestinationClassPath = FileSystems.getDefault().getPath(TRACING_XML_WRITE_DESTINATION_LOCATION);
        Path xmlSourceClassPath = FileSystems.getDefault().getPath(TRACING_XML_WRITE_SOURCE_LOCATION);
        Files.createDirectories(xmlDestinationClassPath.getParent());
        Files.copy(xmlSourceClassPath, xmlDestinationClassPath);

    }

    private void clearOutTestDataDirectory() throws IOException {
        Path directory = Paths.get(TEST_DATA_LOCATION);
        if (directory.toFile().exists()) {
            Files.walkFileTree(directory, new SimpleFileVisitor<Path>() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                    Files.delete(file);
                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
                    Files.delete(dir);
                    return FileVisitResult.CONTINUE;
                }
            });
        }
    }

    private void executeDuplicateDetection() throws Exception {
        Seed.main(new String[] {"-f", FEATURE_FILE_LOCATION,
                "-s", STEPDEFS_LOCATION,
                "-p", PRODCLASS_LOCATION,
                "-dr", DUPLICATION_REPORT_LOCATION });

    }


    /** Helper methods for fluent-style test assertions **/

    private String in(String thingName) {
        return thingName;
    }

    private String and(String thingName) {
        return thingName;
    }

    private String theFeatureCalled(String featureName) {
        return featureName;
    }

    private String theScenarioCalled(String scenarioName) {
        return scenarioName;
    }

    /** helper methods for reading the duplication report xml file 
     **/

    public int numberOfDuplicationsFound() throws Exception {
        duplicatedScenarios = getDuplicationsFromXmlFile();
        int countDuplicates = duplicatedScenarios.count();       
        return countDuplicates;
    }

    public List<String> getDuplicationsWith(String featureName, String scenarioName1) throws Exception {
        List<String> duplicationInfo = new LinkedList<String>();
        duplicatedScenarios = getDuplicationsFromXmlFile();

        while (duplicatedScenarios.next()) {
            Node nNode = duplicatedScenarios.getNode();
            duplicationInfo.add(nNode.getTextContent()); 
        }  
       

        return duplicationInfo;
    }

    public XQResultSequence getDuplicationsFromXmlFile() throws Exception {
        File xqueryFile = new File("duplication.xqy");
        FileInputStream inputStream = new FileInputStream(xqueryFile);
        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression exp = conn.prepareExpression(inputStream);        
        XQResultSequence result = exp.executeQuery();
        XQResultSequence duplicationSequence = (XQResultSequence) conn.createSequence(result);     
                     
        return duplicationSequence;
    }

}