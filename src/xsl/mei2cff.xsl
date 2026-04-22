<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">

        <!-- cff-version -->
        <xsl:text>cff-version: 1.2.0&#10;</xsl:text>

        <!-- title -->
        <xsl:text>title: "</xsl:text><xsl:value-of select="(//mei:titleStmt/mei:title, error((),'FATAL ERROR: No title found)'))[1]"/><xsl:text>"&#10;</xsl:text>
        

        <!-- authors -->
        <xsl:text>authors:&#10;</xsl:text>
        <xsl:variable name="authors" select="//mei:respStmt/mei:persName | //mei:author/mei:persName | //mei:contributor/mei:persName | //mei:editor/mei:persName"/>
        <xsl:if test="not($authors)">
            <xsl:value-of select="error((),'FATAL ERROR: No authors found')"/>
        </xsl:if>
        <xsl:for-each select="$authors">
            <xsl:text>  - name: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each>


        <!-- abstract -->
        <xsl:for-each-group select="//mei:fileDesc/mei:sourceDesc/mei:source/mei:abstract | //mei:fileDesc/mei:sourceDesc/mei:source/mei:p" group-by=".">
            <xsl:text>abstract: "</xsl:text><xsl:value-of select="string-join(current-group()/replace(replace(., '\s+', ' '), '&quot;', ''''), ' ')"/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>


        <!-- contact -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:publisher/mei:persName | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:name | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:corpName" group-by=".">
            <xsl:text>contact:&#10;</xsl:text>
            <xsl:for-each select="current-group()">
                <xsl:text>  - "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>


        <!-- date-released -->
        <xsl:for-each select="//mei:fileDesc/mei:pubStmt/mei:date">
            <xsl:text>date-released: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each>


        <!-- identifiers -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:identifier" group-by=".">
            <xsl:text>identifiers:&#10;</xsl:text>
            <xsl:for-each select="current-group()">
                <xsl:text>  - value: </xsl:text><xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
                <xsl:if test="@type">
                    <xsl:text>    type: </xsl:text><xsl:value-of select="@type"/><xsl:text>&#10;</xsl:text>
                </xsl:if>
            </xsl:for-each>            
        </xsl:for-each-group>
        

        <!-- keywords -->
        <xsl:for-each-group select="//mei:fileDesc/mei:titleStmt/mei:keywords" group-by=".">
            <xsl:text>keywords:&#10;</xsl:text>
            <xsl:for-each select="current-group()">
                <xsl:text>  - "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>


        <!-- license -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:availability/mei:accessRestrict | //mei:fileDesc/mei:pubStmt/mei:availability/mei:identifier | //mei:fileDesc/mei:pubStmt/mei:availability/mei:useRestrict" group-by=".">
            <xsl:text>license:</xsl:text>
            <xsl:choose>
                <xsl:when test="current-group()[2]">
                <xsl:message select="current-group()[2]"/>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:for-each select="current-group()">
                        <xsl:text>  - "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> "</xsl:text><xsl:value-of select="current-group()[1]"/><xsl:text>"&#10;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>


        <!-- repository -->
        <xsl:for-each-group select="//mei:repository" group-by=".">
            <xsl:text>repository: "</xsl:text>
            <xsl:value-of select="string-join(current-group(), ', ')"/>
            <xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>


        <!-- type -->
        <xsl:text>type: "MEI file</xsl:text>
        <xsl:for-each-group select="//mei:workList/mei:work | //mei:music/mei:performance/mei:recording | //mei:music/mei:facsimile" group-by="local-name()">
            <xsl:text> (</xsl:text>
            <xsl:for-each select="current-group()">
                <xsl:value-of select="local-name()"/>
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>)</xsl:text>
        </xsl:for-each-group>
        <xsl:text>"&#10;</xsl:text>


        <!-- version -->
        <xsl:for-each select="//mei:revisionDesc/mei:change">
            <xsl:sort select="substring-before(mei:date/@isodate, '-')" data-type="number" order="descending"/><!-- year of date -->
            <xsl:sort select="substring-after(substring-before(mei:date/@isodate, '-'), '-')" data-type="number" order="descending"/><!-- month of date -->
            <xsl:sort select="substring-after(substring-after(mei:date/@isodate, '-'), '-')" data-type="number" order="descending"/><!-- day of date -->
            <xsl:sort select="@n" data-type="number" order="descending"/>
            <xsl:sort select="position()" data-type="number" order="descending"/>
            <xsl:if test="position() = 1">
                <xsl:text>version: "</xsl:text><xsl:value-of select="string-join(mei:changeDesc//text()[not(matches(.,'^\s*$'))], ' ')"/><xsl:text>"&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>

        <!-- message -->
        <xsl:text>message: "This CFF file was generated from MEI metadata using the MEI-CFF-Checker XSLT stylesheet."&#10;</xsl:text>


    </xsl:template>

</xsl:stylesheet>