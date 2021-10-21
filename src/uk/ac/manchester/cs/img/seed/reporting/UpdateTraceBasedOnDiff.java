package uk.ac.manchester.cs.img.seed.reporting;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.net.URI;
import java.util.Iterator;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XQueryCompiler;
import net.sf.saxon.s9api.XQueryEvaluator;
import net.sf.saxon.s9api.XQueryExecutable;
import net.sf.saxon.s9api.XdmNode;

public class UpdateTraceBasedOnDiff {
	public static void main(String args[]) throws SaxonApiException {
		new UpdateTraceBasedOnDiff().updateAreasOfXmLDiff();
	}
	
	public void updateAreasOfXmLDiff() throws SaxonApiException {
        Processor proc = new Processor(true);
        XQueryCompiler comp = proc.newXQueryCompiler();
        comp.setUpdatingEnabled(true);
        XQueryExecutable exp = comp.compile(
                "for $p in doc('clean_trace1.xml')//trace " +
                "return replace value of node $p/return-value with changed");

        XQueryEvaluator eval = exp.load();
        eval.run();
        for (Iterator<XdmNode> iter = eval.getUpdatedDocuments(); iter.hasNext();) {
            XdmNode root = iter.next();
            URI rootUri = root.getDocumentURI();
            if (rootUri != null && rootUri.getScheme().equals("file")) {
                try {
                    net.sf.saxon.s9api.Serializer out = proc.newSerializer(new FileOutputStream(new File(rootUri)));
                    out.setOutputProperty(net.sf.saxon.s9api.Serializer.Property.METHOD, "xml");
                    out.setOutputProperty(net.sf.saxon.s9api.Serializer.Property.INDENT, "yes");
                    out.setOutputProperty(net.sf.saxon.s9api.Serializer.Property.OMIT_XML_DECLARATION, "yes");
                    System.err.println("Rewriting " + rootUri);
                    proc.writeXdmValue(root, out);
                } catch (FileNotFoundException e) {
                    System.err.println("Could not write to file " + rootUri);
                }
            } else {
                System.err.println("Updated document not rewritten: location unknown or not updatable");
            }
        }
    }

}
