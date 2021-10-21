//package uk.ac.manchester.cs.img.seed.trace;
//
//import java.util.LinkedList;
//import java.util.List;
//
//import org.aspectj.lang.JoinPoint;
//import org.aspectj.lang.ProceedingJoinPoint;
//import org.aspectj.lang.annotation.Around;
//import org.aspectj.lang.annotation.Aspect;
//import org.aspectj.lang.annotation.Before;
//import org.aspectj.lang.annotation.Pointcut;
//import org.aspectj.lang.reflect.MethodSignature;
////import org.springframework.context.annotation.EnableAspectJAutoProxy;
//
////@EnableAspectJAutoProxy
//@Aspect
//public class ConcreteLoggingAspect {
//	public String runningScenario= null;
//	public String runningFeature = null;
//	public String callerStep = null;   
//	public String callerStepWithoutArgs = null;    
//	public String stepSource = null;
//	public StringBuffer flow = new StringBuffer();
//	public List<String> cfList = new LinkedList<String>();
//	public Object returnValue = null;
//	public List<String> stepArgList = new LinkedList<String>();
//	public String thenGlueMethod;
//	public String slicingCriterion;
//	public String callerClassName;
//	public String callerMethod;
//	public int callerSourceLine;
//	public List<String> callerLocation = new LinkedList<String>();
//	public String singleSlicingCriterion;
//	private int executedStatementLine;
//	private String executedMethod;
//	private String executedClassName;
//	private String executedStatement;
//	public List<String> backgroundStatements = new LinkedList<String>();
//	private String methodModifier;
//
//	@Pointcut("execution(* uk.ac.manchester.cs.img.seed.trace.CustomFormatter.scenario(..))")
//	public void executingScenario(){    
//	}
//
//	@Around("executingScenario()")
//	public Object recordScenarioInfo(final ProceedingJoinPoint firstJoinPoint) throws Throwable {
//		Object scenarioResult = firstJoinPoint.proceed();
//
//		//get name of running scenario
//		Object target = firstJoinPoint.getTarget();
//		if (target instanceof CustomFormatter) {
//			runningScenario=((CustomFormatter) target).getScenarioName();
//		}
//		return scenarioResult;
//	}
//
//	@Pointcut("execution(* uk.ac.manchester.cs.img.seed.trace.CustomFormatter.feature(..))")
//	public void executingFeature(){  
//	}
//
//	@Around("executingFeature()")
//	public Object recordFeatureInfo(final ProceedingJoinPoint secondJoinPoint) throws Throwable {
//		Object featureResult = secondJoinPoint.proceed();
//
//		//get name of running feature
//		Object target = secondJoinPoint.getTarget();
//		if (target instanceof CustomFormatter ) {
//			runningFeature=((CustomFormatter ) target).getFeatureName();
//		}
//
//		return featureResult;
//	}
//
//	@Pointcut("cflow(execution(* *(..)) && !execution(* uk.ac.manchester.cs.img.seed.trace.*.*(..))"
//			+ " && !execution(* com.ice.automation.stepdefinitions.*.*(..))"
//			+ " && !within(* && is(InterfaceType)))"
//			+ " && !within(ConcreteLoggingAspect)"
//			+ " && !within(CustomFormatter) && !within(WriteXmlTraceToFile)")
//	public void getCflow() {
//
//	}
//
//	@Before("getCflow()")        
//	public void displayCflow(JoinPoint callJoinPoint) throws Throwable {       
//		cfList.add(callJoinPoint.toString()); 
//
//		//		int executedStatementLine = callJoinPoint.getSourceLocation().getLine();
//		//		callerMethod = callJoinPoint.getSignature().getName();
//		//		callerClassName = callJoinPoint.getSignature().getDeclaringTypeName();
//		//		callerSourceLine = callJoinPoint.getSourceLocation().getLine();
//		//		singleSlicingCriterion = callerClassName + "." + callerMethod + ":" + executedStatementLine;
//		//		System.out.println("THE EXECUTED STATEMENT  IS: " +  singleSlicingCriterion);
//		////		
//	}
//
//
//	//	@Pointcut("execution(* com.ice.automation.stepdefinitions.*.*(..))")
//	//	public void getCallerMethod() {
//	//
//	//	}
//	//
//	//	@Around("getCallerMethod()") 
//	//	public Object collectStepDefInfo(final ProceedingJoinPoint stepJoinPoint) throws Throwable{
//	//		callerStepWithoutArgs = MethodSignature.class.cast(stepJoinPoint.getSignature()).getMethod().getName();        
//	//
//	//		String stepArgValues=new String();
//	//		stepArgList = new LinkedList<String>();
//	//		Object[] stepArguments = stepJoinPoint.getArgs();
//	//		if (stepArguments.length > 0) {
//	//			int length = stepArguments.length;
//	//			for (int i = 0; i < length;i++) {
//	//				Object argument = stepArguments[i];
//	//				stepArgValues=argument.toString();
//	//				stepArgList.add(stepArgValues);       
//	//			}
//	//		}
//	//
//	//		StringBuilder combArgs=new StringBuilder();
//	//		for ( int i = 0; i< stepArgList.size(); i++){
//	//			combArgs.append(stepArgList.get(i));
//	//			if ( i != stepArgList.size()-1){
//	//				combArgs.append(", ");
//	//			}
//	//		}
//	//
//	//		callerStep = callerStepWithoutArgs;             
//	//
//	//		return  stepJoinPoint.proceed();        
//	//	}
//
//
//	/*@Pointcut("@annotation(cucumber.api.java.en.Then)")
//	public void onMethodForThenStep(){
//	} 
//
//	@Around("onMethodForThenStep()")
//	public void getThenStep(JoinPoint thenCallJoinPoint) {
//		thenGlueMethod = thenCallJoinPoint.getStaticPart().getSignature().getName();
//		System.out.println("===THE EXECUTED THEN STEP IS: " + thenGlueMethod);
//
//	}*/
//
//	//	@Pointcut("call(public * *(..)) && within(com.ice.automation.stepdefinitions.*)")
//	//	public void callAPIMethod() {
//	//	}
//	//
//	//	@Before("callAPIMethod()")
//	//	public void collectSlicingCriterionInformation(JoinPoint thisJoinPoint, JoinPoint.EnclosingStaticPart thisJoinPointEnclosingStaticPart) throws NoSuchMethodException, SecurityException {
//	//		/*callerClassName = thisJoinPointEnclosingStaticPart.getSignature().getDeclaringTypeName();
//	//		callerMethod = thisJoinPointEnclosingStaticPart.getSignature().getName();
//	//		callerSourceLine = thisJoinPoint.getSourceLocation().getLine();
//	//		callerLocation = callerClassName + "." + callerMethod + ":" + callerSourceLine;*/
//	//		MethodSignature signature = (MethodSignature)thisJoinPointEnclosingStaticPart.getSignature();
//	//		Method method = signature.getMethod();
//	//
//	//		if(method.getAnnotation(cucumber.api.java.en.Then.class) != null) {
//	//			callerMethod = thisJoinPointEnclosingStaticPart.getSignature().getName();
//	//			callerClassName = thisJoinPointEnclosingStaticPart.getSignature().getDeclaringTypeName();
//	//			callerSourceLine = thisJoinPoint.getSourceLocation().getLine();
//	//			singleSlicingCriterion = callerClassName + "." + callerMethod + ":" + callerSourceLine;
//	//
//	//			if(!callerLocation.contains(singleSlicingCriterion)) {
//	//				callerLocation.add(singleSlicingCriterion); 
//	//				RecordSlicingCriterion writeCriterionObj = new RecordSlicingCriterion();
//	//				writeCriterionObj.writeSlicingCriterionToXml(runningScenario, runningFeature, callerLocation.get(callerLocation.size()-1));
//	//			}
//	//
//	//			System.out.println("THE CALL SOURCE  IS: " +  singleSlicingCriterion);
//	//		}		
//	//
//	//	}
//
//	@Pointcut("withincode(* *(..)) && !withincode(* uk.ac.manchester.cs.img.seed.trace.*.*(..))"
//			+ " && !withincode(* com.ice.automation.stepdefinitions.*.*(..))")    
//	public void getExecutedStatement() {}
//
//	@Pointcut("within(*.*) && !within(uk.ac.manchester.cs.img.seed.trace.*)"
//			+ " && !within(com.ice.automation.stepdefinitions.*)")    
//	public void getAccessedField() {	        
//	}
//
//	@Before("getExecutedStatement()")
//	public void collectExecutedStatementInfo (JoinPoint.StaticPart joinPointStaticPart, 
//			JoinPoint.EnclosingStaticPart thisJoinPointEnclosingStaticPart) {
//		executedStatementLine = joinPointStaticPart.getSourceLocation().getLine();
//		executedMethod =thisJoinPointEnclosingStaticPart.getSignature().getName();
//		String accessedField = joinPointStaticPart.getSignature().getName();
//		executedClassName = joinPointStaticPart.getSignature().getDeclaringTypeName();
//
//
//		executedStatement = executedClassName + "." + executedMethod + ":" + executedStatementLine;
//
//
//	}
//
//	@Pointcut("execution(* *(..)) && !execution(* uk.ac.manchester.cs.img.seed.trace.*.*(..))"
//			+ " && !execution(* com.ice.automation.stepdefinitions.*.*(..))")    
//	public void logging() {
//	}
//
//	@Before("logging()")
//	public void getExecutedStatement(JoinPoint.StaticPart joinPointStaticPart) {
//		//get information about executed statements
//		//		int executedStatementLine = joinPointStaticPart.getSourceLocation().getLine();
//		//		callerMethod = joinPointStaticPart.getSignature().getName();
//		//		callerClassName = joinPointStaticPart.getSignature().getDeclaringTypeName();
//		//		callerSourceLine = joinPointStaticPart.getSourceLocation().getLine();
//		//		singleSlicingCriterion = callerClassName + "." + callerMethod + ":" + executedStatementLine;
//		//		System.out.println("THE EXECUTED STATEMENT  IS: " +  singleSlicingCriterion);
//		//		
//	}
//
//	// get running class, object, method, arguments and return value
//	@Around("logging()")
//	public Object collectClassAndMethodRunTimeInformation(final ProceedingJoinPoint thisJoinPoint,
//			JoinPoint.EnclosingStaticPart thisJoinPointEnclosingStaticPart, JoinPoint.StaticPart joinPointStaticPart) throws Throwable { 
//		Object result =null;
//		try{
//			result = thisJoinPoint.proceed();           
//		} finally {			
//			//get other method information			
//			String parameterValues=new String();
//
//			if (thisJoinPoint.getThis() != null) {
//				String name = thisJoinPoint.getStaticPart().getSignature().getName();
//				if (!(name.startsWith("get"))
//						&& !(name.startsWith("set"))
//						&& !(name.equals("<init>"))) {
//				}
//			}
//
//			List<String> argList = new LinkedList<String>();
//			Object[] arguments = thisJoinPoint.getArgs();
//			if (arguments.length > 0) {
//				int length = arguments.length;
//				for (int i = 0; i < length;i++) {
//					Object argument = arguments[i];
//
//					if(argument != null) {
//						parameterValues=argument.toString();
//						argList.add(parameterValues);
//					}
//				}
//			}
//
//			StringBuilder combArgs=new StringBuilder();
//			for ( int i = 0; i< argList.size(); i++){
//				combArgs.append(argList.get(i));
//				if ( i != argList.size()-1){
//					combArgs.append(", ");
//				}
//			}
//
//			String receiverObject = "";
//			String classInExecution = "";
//			if(thisJoinPoint.getThis() !=null) {
//				String obj = ObjectUtil.myToString(thisJoinPoint.getThis());
//				String[] strDivide = obj.split("@", 2);
//				classInExecution = strDivide[0];
//				receiverObject ="@".concat(strDivide[1]);
//
//			}
//			else {
//				classInExecution = thisJoinPoint.getSignature().getDeclaringType().getName();
//				receiverObject = "static method call.No object";
//			}
//
//			String methodName=MethodSignature.class.cast(thisJoinPoint.getSignature()).getMethod().getName();
//			methodModifier = java.lang.reflect.Modifier.toString(thisJoinPoint.getSignature().getModifiers());
//
//			System.out.println("THE MODIFIER IS " + methodModifier);
//			String signatureString = MethodSignature.class.cast(thisJoinPoint.getSignature()).toString();
//			String paramTypes = signatureString.substring(signatureString.indexOf("(") + 1, signatureString.indexOf(")"));
//			String methodReturnType = MethodSignature.class.cast(thisJoinPoint.getSignature()).getReturnType().toString();
//			if(methodReturnType != "void") returnValue = result;
//			String returnValueToSave = String.valueOf(returnValue);
//
//			//write dynamically recorded values to an XML file
//			if((runningScenario == null) && (executedStatement !=null)) {
//				backgroundStatements.add(executedStatement);
//			} else {
//				WriteXmlTraceToFile xmlWriteObj=new WriteXmlTraceToFile();
//				xmlWriteObj.writeToXml(returnValueToSave, methodName, classInExecution, argList,
//						paramTypes, methodReturnType, runningScenario, runningFeature, cfList, 
//						executedStatement, backgroundStatements, methodModifier); 
//				cfList.clear();
//				backgroundStatements.clear();
//			}
//
//			thisJoinPoint.proceed();
//		}
//		return result;
//	}	 
//}