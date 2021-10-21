package uk.ac.manchester.cs.img.seed.reporting;
import java.io.File;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;


public class XDiffEssentialTraceJava {
	 public static void main(String[] args) throws Exception {
		    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		    Document document = dbf.newDocumentBuilder().parse(new File("xdiff_output.xml"));

		    XPathFactory xpf = XPathFactory.newInstance();
		    XPath xpath = xpf.newXPath();
		    XPathExpression expression = xpath.compile("//*[contains(text(),'<?UPDATE FROM')]");

		    Node b13Node = (Node) expression.evaluate(document, XPathConstants.NODE);
		    b13Node.getParentNode().removeChild(b13Node);

		    TransformerFactory tf = TransformerFactory.newInstance();
		    Transformer t = tf.newTransformer();
		    t.transform(new DOMSource(document), new StreamResult(System.out));
		  }

}
