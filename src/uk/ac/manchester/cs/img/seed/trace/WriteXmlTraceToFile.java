package uk.ac.manchester.cs.img.seed.trace;

import java.io.File;
import java.io.FileInputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.ArrayList;
import java.util.List;
import org.w3c.dom.Text;

public class WriteXmlTraceToFile {

	public void writeToXml(String returnValue, String method, String executedClass,
			List<String> prms, String prmsTypes,
			String methodReturnType, String scenario, String feature, List<String> cfList, String executedStatement, List<String> backgroundStatements, String methodModifier) {
		Element existingElement;

		DocumentBuilderFactory icFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder icBuilder;
		FileInputStream fin;
		try {
			icBuilder = icFactory.newDocumentBuilder();
			Document doc = icBuilder.newDocument();
			Element mainRootElement;
			/*read the existing xml file.
			 * If it is empty,create root element and initial contents.
			 * Otherwise read root element and update it with new nodes
			 */

			// check if trace.xml exists.If not, create it
			File f= new File("trace.xml");
			if(!f.exists()){
				f.createNewFile();
			}

			fin=new FileInputStream("trace.xml");
			if(fin.read() == -1){
				mainRootElement = doc.createElement("traces");
				doc.appendChild(mainRootElement);

				// append child elements to root element
				mainRootElement.appendChild(getTrace(doc, returnValue, method, executedClass,
						prms, prmsTypes, methodReturnType, scenario, feature, cfList, executedStatement, backgroundStatements, methodModifier));

				Transformer transformer = TransformerFactory.newInstance().newTransformer();
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");
				transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
				DOMSource source = new DOMSource(doc);

				StreamResult file = new StreamResult("trace.xml");				
				transformer.transform(source, file);
			}

			else {
				doc = icBuilder.parse(new File("trace.xml"));
				mainRootElement=doc.getDocumentElement();

				List<Node> list = selectElementsByAttributeValue( mainRootElement, "trace", "scenario", scenario, false);

				if(!list.isEmpty()) {
					for(int i = 0; i < list.size(); i++) {
						existingElement = (Element) list.get(i);

						if(existingElement != null) {
							if(!backgroundStatements.isEmpty()) {
								for (int j = 0; j< backgroundStatements.size(); j++) {
									existingElement.appendChild(getTraceElements(doc, existingElement, "statement", backgroundStatements.get(j)));
									//                                  Text stmtValue = doc.createTextNode(backgroundStatements.get(j));
									//                                  Node stmtNode = doc.createElement("statement");
									//                                  stmtNode.appendChild(stmtValue);
									//                                  brgNode.appendChild(stmtNode);
								}

								//removed separating background statements from the rest of the statements
								//                                Node brgNode = existingElement.appendChild(getTraceElements(doc, existingElement, "background", ""));
								//                                for (int j = 0; j< backgroundStatements.size(); j++) {
								//                                 Text stmtValue = doc.createTextNode(backgroundStatements.get(j));
								//                                 Node stmtNode = doc.createElement("statement");
								//                                 stmtNode.appendChild(stmtValue);
								//                                 brgNode.appendChild(stmtNode);
								//                             }                                
							}
							existingElement.appendChild(getTraceElements(doc, existingElement, "statement", executedStatement));

							Node eventNode = existingElement.appendChild(getTraceElements(doc, existingElement, "event", ""));
							Text classNodeValue = doc.createTextNode(executedClass);
							Node classNode = doc.createElement("class");
							classNode.appendChild(classNodeValue);
							eventNode.appendChild(classNode);

							Text methodNodeValue = doc.createTextNode(method);
							Node methodNode = doc.createElement("method");
							methodNode.appendChild(methodNodeValue);
							eventNode.appendChild(methodNode);

							Text paramTypesNodeValue = doc.createTextNode(prmsTypes);
							Node paramTypesNode = doc.createElement("param-types");
							paramTypesNode.appendChild(paramTypesNodeValue);
							eventNode.appendChild(paramTypesNode);

							Text returunTypeNodeValue = doc.createTextNode(methodReturnType);
							Node returunTypeNode = doc.createElement("return-type");
							returunTypeNode.appendChild(returunTypeNodeValue);
							eventNode.appendChild(returunTypeNode);

							Node paramsNode = existingElement.appendChild(getTraceElements(doc, existingElement, "args", ""));

							for (int j = 0; j< prms.size(); j++) {
								Text argValue = doc.createTextNode(prms.get(j));
								Node argNode = doc.createElement("arg");
								argNode.appendChild(argValue);
								paramsNode.appendChild(argNode);
							}
							eventNode.appendChild(paramsNode);

							//                            existingElement.appendChild(getTraceElements(doc, existingElement, "step", callerStep));                            
							//                            Node stepArgsNode= existingElement.appendChild(getTraceElements(doc, existingElement, "step-args", ""));
							//
							//                            for (int j = 0; j< stepArgList.size(); j++) {
							//                                Text argValue = doc.createTextNode(stepArgList.get(j));
							//                                Node argNode = doc.createElement("step-arg");
							//                                argNode.appendChild(argValue);
							//                                stepArgsNode.appendChild(argNode);
							//                            }
							Text returnNodeValue = doc.createTextNode(returnValue);
							Node returnNode = doc.createElement("return-value");
							returnNode.appendChild(returnNodeValue);
							eventNode.appendChild(returnNode);

							Text modifierNodeValue = doc.createTextNode(methodModifier);
							Node modifierNode = doc.createElement("modifier");
							modifierNode.appendChild(modifierNodeValue);
							eventNode.appendChild(modifierNode);

							//                            Node flowsNode = existingElement.appendChild(getTraceElements(doc, existingElement, "cflow", ""));                            
							//                            for (int j = 0; j< cfList.size(); j++) {
							//                                Text flowValue = doc.createTextNode(cfList.get(j));
							//                                Node flowNode = doc.createElement("flow");
							//                                flowNode.appendChild(flowValue);
							//                                flowsNode.appendChild(flowNode);
							//                            }                           


						}                    

					}

				}  else {

					mainRootElement.appendChild(getTrace(doc, returnValue, method, executedClass, prms,
							prmsTypes, methodReturnType, scenario, feature, cfList, executedStatement, backgroundStatements, methodModifier));
				}


				Transformer transformer = TransformerFactory.newInstance().newTransformer();
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");
				transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
				DOMSource source = new DOMSource(doc);

				StreamResult file = new StreamResult("trace.xml");
				transformer.transform(source, file);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static Node getTrace(Document doc, String returnValue, String executedMethod,
			String executedClass, List<String> paramValues, String parameterTypes, String methodReturnType, String executedScenario,
			String executedFeature, List<String> cfList, String executedStatement, List<String> backgroundStatements, String methodModifier) {

		Element traceElement = doc.createElement("trace");
		traceElement.setAttribute("scenario", executedScenario);
		traceElement.setAttribute("feature", executedFeature);
		if(!backgroundStatements.isEmpty()) {
			for (int i = 0; i< backgroundStatements.size(); i++) {
				traceElement.appendChild(getTraceElements(doc, traceElement, "statement", backgroundStatements.get(i)));
			}
			//            Node brgNode = traceElement.appendChild(getTraceElements(doc, traceElement, "background", ""));
			//            for (int i = 0; i< backgroundStatements.size(); i++) {
			//             Text stmtValue = doc.createTextNode(backgroundStatements.get(i));
			//             Node stmtNode = doc.createElement("statement");
			//             stmtNode.appendChild(stmtValue);
			//             brgNode.appendChild(stmtNode);
			//         }

		}
		traceElement.appendChild(getTraceElements(doc, traceElement, "statement", executedStatement));
		Node eventNode = traceElement.appendChild(getTraceElements(doc, traceElement, "event", ""));
		Text classNodeValue = doc.createTextNode(executedClass);
		Node classNode = doc.createElement("class");
		classNode.appendChild(classNodeValue);
		eventNode.appendChild(classNode);

		Text methodNodeValue = doc.createTextNode(executedMethod);
		Node methodNode = doc.createElement("method");
		methodNode.appendChild(methodNodeValue);
		eventNode.appendChild(methodNode);

		Text paramTypesNodeValue = doc.createTextNode(parameterTypes);
		Node paramTypesNode = doc.createElement("param-types");
		paramTypesNode.appendChild(paramTypesNodeValue);
		eventNode.appendChild(paramTypesNode);

		Text returunTypeNodeValue = doc.createTextNode(methodReturnType);
		Node returunTypeNode = doc.createElement("return-type");
		returunTypeNode.appendChild(returunTypeNodeValue);
		eventNode.appendChild(returunTypeNode);

		Node paramsNode = traceElement.appendChild(getTraceElements(doc, traceElement, "args", ""));

		for (int j = 0; j< paramValues.size(); j++) {
			Text argValue = doc.createTextNode(paramValues.get(j));
			Node argNode = doc.createElement("arg");
			argNode.appendChild(argValue);
			paramsNode.appendChild(argNode);
		}
		eventNode.appendChild(paramsNode);

		//                            existingElement.appendChild(getTraceElements(doc, existingElement, "step", callerStep));                            
		//                            Node stepArgsNode= existingElement.appendChild(getTraceElements(doc, existingElement, "step-args", ""));
		//
		//                            for (int j = 0; j< stepArgList.size(); j++) {
		//                                Text argValue = doc.createTextNode(stepArgList.get(j));
		//                                Node argNode = doc.createElement("step-arg");
		//                                argNode.appendChild(argValue);
		//                                stepArgsNode.appendChild(argNode);
		//                            }
		Text returnNodeValue = doc.createTextNode(returnValue);
		Node returnNode = doc.createElement("return-value");
		returnNode.appendChild(returnNodeValue);
		eventNode.appendChild(returnNode);

		Text modifierNodeValue = doc.createTextNode(methodModifier);
		Node modifierNode = doc.createElement("modifier");
		modifierNode.appendChild(modifierNodeValue);
		eventNode.appendChild(modifierNode);


		//		traceElement.appendChild(getTraceElements(doc, traceElement, "class", executedClass));
		//
		//		traceElement.appendChild(getTraceElements(doc, traceElement, "method", executedMethod));
		//		traceElement.appendChild(getTraceElements(doc, traceElement, "param-types", parameterTypes));
		//		traceElement.appendChild(getTraceElements(doc, traceElement, "return-type", methodReturnType));        
		//		Node paramsNode = traceElement.appendChild(getTraceElements(doc, traceElement, "args", ""));
		//
		//		for (int i = 0; i< paramValues.size(); i++) {
		//			Text argValue = doc.createTextNode(paramValues.get(i));
		//			Node argNode = doc.createElement("arg");
		//			argNode.appendChild(argValue);
		//			paramsNode.appendChild(argNode);
		//		}
		//
		//		//        traceElement.appendChild(getTraceElements(doc, traceElement, "step", callerStep));
		//		//
		//		//        Node stepArgsNode=  traceElement.appendChild(getTraceElements(doc,  traceElement, "step-args", ""));
		//		//
		//		//        for (int j = 0; j< stepArgList.size(); j++) {
		//		//            Text argValue = doc.createTextNode(stepArgList.get(j));
		//		//            Node argNode = doc.createElement("step-arg");
		//		//            argNode.appendChild(argValue);
		//		//            stepArgsNode.appendChild(argNode);
		//		//        }  
		//
		//		traceElement.appendChild(getTraceElements(doc, traceElement, "return-value", returnValue));
		//        Node flowsNode = traceElement.appendChild(getTraceElements(doc, traceElement, "cflow", ""));
		//        for (int i = 0; i< cfList.size(); i++) {
		//            Text flowValue = doc.createTextNode(cfList.get(i));
		//            Node flowNode = doc.createElement("flow");
		//            flowNode.appendChild(flowValue);
		//            flowsNode.appendChild(flowNode);
		//        }

		return traceElement;
	}

	// utility method to create text nodes
	public static Node getTraceElements(Document doc, Element element, String name, String value) {
		Element node = doc.createElement(name);
		node.appendChild(doc.createTextNode(value));
		return node;
	}    

	public static String getAttribute(Element element, String name) {
		return element.getAttribute(name);
	}

	public static List<Node> selectElementsByAttributeValue(Element element, String name,
			String attribute, String value, boolean returnFirst) {
		NodeList  elementList = element.getElementsByTagName(name);
		List<Node> resultList  = new ArrayList<Node>();

		for (int i = 0; i < elementList.getLength(); i++) {
			if (getAttribute((Element) elementList.item(i), attribute).equals(value)) {
				resultList.add(elementList.item(i));
				if (returnFirst) {
					break;
				}
			}
		}
		return resultList;
	}
}

