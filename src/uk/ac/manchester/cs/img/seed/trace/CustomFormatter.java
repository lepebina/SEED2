package uk.ac.manchester.cs.img.seed.trace;

import java.util.List;

import gherkin.formatter.Formatter;
import gherkin.formatter.NiceAppendable;
import gherkin.formatter.Reporter;
import gherkin.formatter.model.Background;
import gherkin.formatter.model.Examples;
import gherkin.formatter.model.Feature;
import gherkin.formatter.model.Match;
import gherkin.formatter.model.Result;
import gherkin.formatter.model.Scenario;
import gherkin.formatter.model.ScenarioOutline;
import gherkin.formatter.model.Step;

//custom formatter to facilitate reading scenario name during execution
public class CustomFormatter implements Reporter, Formatter {

    public NiceAppendable output;
    public String scenarioName;  
    public String featureName;  

    public CustomFormatter(Appendable appendable) {
        output = new NiceAppendable(appendable);        
    }

    public CustomFormatter(String str){
        this.scenarioName=str;
    }

    @Override
    public void syntaxError(String s, String s1, List<String> list, String s2, Integer integer) {       
    }

    @Override
    public void uri(String s) {      
    }

    @Override
    public void feature(Feature feature) {
    featureName = feature.getName();
    }

    @Override
    public void scenarioOutline(ScenarioOutline scenarioOutline) {
    }

    @Override
    public void examples(Examples examples) {
    }

    @Override
    public void startOfScenarioLifeCycle(Scenario scenario) {
    }

    @Override
    public void background(Background background) {
    }

    @Override
    public void scenario(Scenario scenario) {
        scenarioName=scenario.getName();   
    }   

    @Override
    public void step(Step step) {        
    }

    @Override
    public void endOfScenarioLifeCycle(Scenario scenario) {
    }

    @Override
    public void done() {
    }

    @Override
    public void close() {
        output.close();
    }

    @Override
    public void eof() {
    }

    @Override
    public void before(Match match, Result result) {
    }

    @Override
    public void result(Result result) {
       
    }

    @Override
    public void after(Match match, Result result) {
    }

    @Override
    public void match(Match match) {
    }

    @Override
    public void embedding(String s, byte[] bytes) {
    }

    @Override
    public void write(String s) {
    }

    public String getScenarioName(){
        return scenarioName;    
    }
    
    public String getFeatureName(){
        return featureName;    
    }
}
