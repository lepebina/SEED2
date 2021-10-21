package uk.ac.manchester.cs.img.seed.indexing;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.CharArraySet;
import org.apache.lucene.analysis.StopFilter;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.Field.Store;
import org.apache.lucene.document.LongPoint;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.Fields;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.IndexWriterConfig.OpenMode;
import org.apache.lucene.index.MultiFields;
import org.apache.lucene.index.Term;
import org.apache.lucene.index.Terms;
import org.apache.lucene.index.TermsEnum;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.BytesRef;

public class LuceneIndexMaker  {
	public static void main(String[] args)    {
		
        //Input folder
        String docsPath ="/home/leonard/newworkspace/IceAutomation/src/test/resources/com/ice/automation/scenarios/features/for-lucene-index/targeted-scenarios";
         
        //Output folder
        String indexPath = "lucene-index";
 
        //Input Path Variable
        final Path docDir = Paths.get(docsPath);
        String stopWords[] = {"i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself",
        		"yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they",
        		"them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those",
        		"am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did",
        		"doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for",
        		"with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to",
        		"from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here",
        		"there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some",
        		"such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just",
        		"don", "should", "now", "given", "within",
        		"a", "b","c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
        		"v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
 
        CharArraySet stops = StopFilter.makeStopSet(stopWords, true);
        
        try
        {
            //org.apache.lucene.store.Directory instance
            Directory dir = FSDirectory.open( Paths.get(indexPath) );
             
            //analyzer with the default stop words
            Analyzer analyzer = new StandardAnalyzer(stops);
             
            //IndexWriter Configuration
            IndexWriterConfig iwc = new IndexWriterConfig(analyzer);
            iwc.setOpenMode(OpenMode.CREATE_OR_APPEND);
             
            //IndexWriter writes new index files to the directory
            IndexWriter writer = new IndexWriter(dir, iwc);
             
            //Its recursive method to iterate all files and directories
            indexDocs(writer, docDir);
 
            writer.close();
            displayIndexContents();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }
     
    static void indexDocs(final IndexWriter writer, Path path) throws IOException
    {
        //Directory?
        if (Files.isDirectory(path))
        {
            //Iterate directory
            Files.walkFileTree(path, new SimpleFileVisitor<Path>()
            {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException
                {
                    try
                    {
                        //Index this file
                        indexDoc(writer, file, attrs.lastModifiedTime().toMillis());
                    }
                    catch (IOException ioe)
                    {
                        ioe.printStackTrace();
                    }
                    return FileVisitResult.CONTINUE;
                }
            });
        }
        else
        {
            //Index this file
            indexDoc(writer, path, Files.getLastModifiedTime(path).toMillis());
        }
    }
 
    static void indexDoc(IndexWriter writer, Path file, long lastModified) throws IOException
    {
        try (InputStream stream = Files.newInputStream(file))
        {
            //Create lucene Document
            Document doc = new Document();
             
            doc.add(new StringField("path", file.toString(), Field.Store.YES));
            doc.add(new LongPoint("modified", lastModified));
            doc.add(new TextField("contents", new String(Files.readAllBytes(file)), Store.YES));
             
            //Updates a document by first deleting the document(s)
            //containing <code>term</code> and then adding the new
            //document.  The delete and then add are atomic as seen
            //by a reader on the same index
            writer.updateDocument(new Term("path", file.toString()), doc);
        }
    }
    
    public static void displayIndexContents() throws IOException {
    	Directory dir = FSDirectory.open(Paths.get("lucene-index"));
    	IndexReader reader = DirectoryReader.open(dir);
        final Fields fields = MultiFields.getFields(reader);
        final Iterator<String> iterator = fields.iterator();
        FileWriter writer = new FileWriter(new File("lucene-index/lucene_index.txt"), true);
    	KStem stemer = new KStem();
    	List<String> indexWords = new LinkedList<String>();

        while(iterator.hasNext()) {
            final String field = iterator.next();
            final Terms terms = MultiFields.getTerms(reader, field);
            final TermsEnum it = terms.iterator();
            BytesRef term = it.next();
            while (term != null) {
                //System.out.println(term.utf8ToString());
            	//if(!indexWords.contains(stemer.stemTerm(term.utf8ToString()))) {
            	writer.write(stemer.stemTerm(term.utf8ToString()));
            	writer.write(System.lineSeparator());
            	//indexWords.add(stemer.stemTerm(term.utf8ToString()));
            	//}
            //else {
                term = it.next();
            	//}
            	
            }
        }
    	writer.close();

    }

}
