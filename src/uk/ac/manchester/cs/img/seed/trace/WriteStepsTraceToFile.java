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

public class WriteStepsTraceToFile {
	public void writeStepsToXml(String step, String scenario, String feature) {
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
			File f= new File("steps_trace.xml");
			if(!f.exists()){
				f.createNewFile();
			}

			fin=new FileInputStream("steps_trace.xml");
			if(fin.read() == -1){
				mainRootElement = doc.createElement("steps");
				doc.appendChild(mainRootElement);

				// append child elements to root element
				mainRootElement.appendChild(getTrace(doc, step, scenario, feature));

				Transformer transformer = TransformerFactory.newInstance().newTransformer();
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");
				transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
				DOMSource source = new DOMSource(doc);

				StreamResult file = new StreamResult("steps_trace.xml");				
				transformer.transform(source, file);
			}

			else {
				doc = icBuilder.parse(new File("steps_trace.xml"));
				mainRootElement=doc.getDocumentElement();

				List<Node> list = selectElementsByAttributeValue( mainRootElement, "step", "text", step, false);

				if(!list.isEmpty()) {
					for(int i = 0; i < list.size(); i++) {
						existingElement = (Element) list.get(i);

						if(existingElement != null) {
							
							Node eventNode = existingElement.appendChild(getTraceElements(doc, existingElement, "used-in", ""));
							Text scenarioNodeValue = doc.createTextNode(scenario);
							Node scenarioNode = doc.createElement("scenario");
							scenarioNode.appendChild(scenarioNodeValue);
							eventNode.appendChild(scenarioNode);

							Text featureNodeValue = doc.createTextNode(feature);
							Node featureNode = doc.createElement("feature");
							featureNode.appendChild(featureNodeValue);
							eventNode.appendChild(featureNode);

						}                    

					}

				}  else {

					mainRootElement.appendChild(getTrace(doc, step, scenario, feature));
				}


				Transformer transformer = TransformerFactory.newInstance().newTransformer();
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");
				transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
				DOMSource source = new DOMSource(doc);

				StreamResult file = new StreamResult("steps_trace.xml");
				transformer.transform(source, file);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static Node getTrace(Document doc, String step, String executedScenario, String executedFeature) {

		Element traceElement = doc.createElement("step");
		traceElement.setAttribute("text", step);
		
		Node eventNode = traceElement.appendChild(getTraceElements(doc, traceElement, "used-in", ""));
		Text scenarioNodeValue = doc.createTextNode(executedScenario);
		Node scenarioNode = doc.createElement("scenario");
		scenarioNode.appendChild(scenarioNodeValue);
		eventNode.appendChild(scenarioNode);

		Text featureNodeValue = doc.createTextNode(executedFeature);
		Node featureNode = doc.createElement("feature");
		featureNode.appendChild(featureNodeValue);
		eventNode.appendChild(featureNode);

		
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
