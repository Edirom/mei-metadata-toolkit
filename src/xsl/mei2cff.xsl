<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">

        <!-- cff-version -->
        <xsl:text>cff-version: 1.2.0&#10;</xsl:text>

        <!-- title -->
        <xsl:text>title: "</xsl:text><xsl:value-of select="//mei:titleStmt/mei:title"/><xsl:text>"&#10;</xsl:text>
        
        <!-- authors -->
        <xsl:text>authors:&#10;</xsl:text>
        <xsl:for-each select="//mei:respStmt/mei:persName | //mei:author/mei:persName | //mei:contributor/mei:persName | //mei:editor/mei:persName">
            <xsl:text>  - name: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each>

        <!-- TODO: abstract -->


        <!-- TODO: contact -->


        <!-- TODO: date-released -->


        <!-- TODO: identifiers -->


        <!-- TODO: keywords -->


        <!-- TODO: license -->


        <!-- TODO: repository -->


        <!-- TODO: type -->
        

        <!-- TODO: version -->

        
        <!-- message -->
        <xsl:text>message: "This CFF file was generated from MEI metadata using the MEI-CFF-Checker XSLT stylesheet."&#10;</xsl:text>

    </xsl:template>

</xsl:stylesheet>