<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <xsl:output method="xml"/>
    <xsl:param name="inputFolder">file:/home/leonard/eclipse-workspace/SEED2/traces/essential</xsl:param> 

    <xsl:template match="/">        
        <xsl:variable name="filename" select="translate(concat($inputFolder, '\essential_traces.xml'),'\','/')"/>
        <xsl:message><xsl:value-of select="$filename"/></xsl:message>
        <xsl:result-document method="xml" href="{$filename}">
        <xsl:copy>
            <xsl:apply-templates mode="rootcopy"/>
        </xsl:copy>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="node()" mode="rootcopy">
        <xsl:copy>              
            <xsl:variable name="folderURI"  select="$inputFolder"/>     
            <xsl:message><xsl:value-of select="$folderURI"/></xsl:message>           
            <xsl:for-each select="collection(translate(concat($folderURI, '?select=*.xml;recurse=yes'),'\','/'))/*/node()">
                <xsl:apply-templates mode="copy" select="."/>
            </xsl:for-each>           
        </xsl:copy>
    </xsl:template>

    <!-- Deep copy template -->
   <xsl:template match="node()|@*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates mode="copy" select="@*"/>
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <!-- Handle default matching -->
    <xsl:template match="*"/>
</xsl:stylesheet>

