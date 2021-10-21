<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:data="data">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="versionTwoXmlFile" select="document('trace3.xml')//trace" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="trace">
    <xsl:variable name="trace" select="$versionTwoXmlFile[@scenario = current()/@scenario]"/>
    <xsl:if test="$trace">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>

        <xsl:for-each select="*">        
          <xsl:choose>
            <xsl:when test="$versionTwoXmlFile/*[name() = name(current()) and . = current()/.]">
               <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>&#x0A;</xsl:text>
               <inserted>any</inserted>
               <!--<xsl:text>any</xsl:text> -->
               <xsl:text>&#x0A;</xsl:text>
            </xsl:otherwise>
         </xsl:choose> 
          <!-- <xsl:if test="$xml2/*[name() = name(current()) and . = current()/.]">
            <xsl:apply-templates select="."/>
          </xsl:if>-->
        </xsl:for-each>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>