<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   
<xsl:template match="/">
<traces>
     <xsl:for-each select="//trace[not(@scenario=preceding::trace/@scenario)]">
          <xsl:copy-of select="."/>
     </xsl:for-each>
</traces>
</xsl:template>     
   
</xsl:stylesheet>
