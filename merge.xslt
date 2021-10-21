<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

    <xsl:key match="scenario-group" use="@path" name="path" />

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="scenarios-paths">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="scenario-group[generate-id(.) = generate-id(key('path', @path))]" mode="sibling-recurse" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="scenario-group" mode="sibling-recurse">
        <xsl:copy>
            <!-- back to default mode -->
            <xsl:apply-templates select="node() | @*" />
            <xsl:apply-templates select="following-sibling::scenario-group[@path = current()/@path]/node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>