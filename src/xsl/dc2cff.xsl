<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fx="http://example.com/fx"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:eor="https://edirom-online.edirom.de/ns/1.0"
    exclude-result-prefixes="mei xs fx oai_dc eor">


    <!-- Serialization settings -->
    <xsl:output method="text" encoding="UTF-8" />
    

    <!-- Imports -->
    <xsl:import href="mei2dc.xsl"/>


    <!-- Global parameters -->
    <xsl:param name="mode" select="'xml'" as="xs:string"/><!-- xml or yaml -->
    <xsl:param name="scope" select="'global'" as="xs:string"/><!-- single or global -->
    <xsl:param name="directories" select="('file:/home/djettka/git-clones/Edirom/EditionExample')" as="xs:string+"/>


    <!-- Global variables -->
    <xsl:variable name="dc-all">
        <xsl:for-each select="$directories">
            <oai_dc:dc eor:dir="{.}">
                <xsl:for-each select="collection(concat(., '?select=*.xml;recurse=yes;on-error=warning'))/mei:mei">
                    <xsl:call-template name="generate-oai_dc-xml"/>
                </xsl:for-each>
            </oai_dc:dc>
        </xsl:for-each>        
    </xsl:variable>


    <!-- Template matching root -->
    <xsl:template match="/">
        <xsl:for-each select="dc-all">
            <xsl:call-template name="generate-cff-yaml"/>
        </xsl:for-each>     
    </xsl:template>


    <!-- Generate Citation File Format (CFF) metadata YAML -->
    <xsl:template name="generate-cff-yaml">

        <!-- cff-version -->
        <xsl:text>cff-version: 1.2.0&#10;</xsl:text>

        <!-- title -->
        <xsl:text>title: "</xsl:text><xsl:value-of select="string-join(distinct-values(//dc:title), '; ')"/><xsl:text>"&#10;</xsl:text>
        

        <!-- authors -->
        <xsl:for-each-group select="//dc:creator | //dc:contributor" group-by="1">
            <xsl:text>authors:&#10;</xsl:text>
            <xsl:for-each select="distinct-values(current-group())">
                <xsl:text>  - name: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>
        


        <!-- abstract -->
        <xsl:for-each-group select="//dc:description" group-by="1">
            <xsl:text>abstract: "</xsl:text><xsl:value-of select="string-join(current-group()/replace(replace(., '\s+', ' '), '&quot;', ''''), ' ')"/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>


        <!-- contact -->
        <xsl:for-each-group select="//dc:publisher" group-by="1">
            <xsl:text>contact:&#10;</xsl:text>
            <xsl:for-each select="distinct-values(current-group())">
                <xsl:text>  - name: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>


        <!-- date-released -->
        <xsl:for-each-group select="//dc:date" group-by="1">
            <xsl:text>date-released: "</xsl:text><xsl:value-of select="string-join(current-group())"/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>


        <!-- identifiers -->
        <xsl:for-each-group select="//dc:identifier" group-by="1">
            <xsl:text>identifiers:&#10;</xsl:text>
            <xsl:for-each select="distinct-values(current-group())">
                <xsl:text>  - value: </xsl:text><xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
                <xsl:choose>
                    <xsl:when test="matches(., 'doi[\.:\/]')">
                        <xsl:text>    type: doi&#10;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>            
        </xsl:for-each-group>
        

        <!-- keywords -->
        <xsl:for-each-group select="//dc:format | //dc:subject | //dc:source | //dc:language | //dc:coverage" group-by="1">
            <xsl:text>keywords:&#10;</xsl:text>
            <xsl:for-each select="distinct-values(current-group())">
                <xsl:text>  - "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>


        <!-- license -->
        <xsl:for-each-group select="//dc:rights" group-by="1">
            <xsl:text>license:</xsl:text>
            <xsl:choose>
                <xsl:when test="count(distinct-values(current-group())) > 1">
                    <xsl:text>&#10;</xsl:text>
                    <xsl:for-each select="distinct-values(current-group())">
                        <xsl:text>  - "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> "</xsl:text><xsl:value-of select="current-group()[1]"/><xsl:text>"&#10;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>


        <!-- repository -->
        <xsl:for-each-group select="//dc:relation" group-by="1">
            <xsl:text>repository: "</xsl:text>
            <xsl:value-of select="fx:cff-quote(string-join(current-group(), ', '))"/>
            <xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>


        <!-- type-->
        <xsl:text>type: dataset&#10;</xsl:text>


        <!-- version -->
        <xsl:for-each-group select="//dc:identifier[starts-with(., 'Version: ')]" group-by="1">
            <xsl:text>version: "</xsl:text><xsl:value-of select="string-join(distinct-values(current-group()/substring-after(., 'Version: ')), '; ')"/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>

        <!-- message -->
        <xsl:text>message: "This CFF file was generated from MEI metadata using mei2dc.xsl and dc2cff.xsl"</xsl:text>

    </xsl:template>



    <xsl:function name="fx:cff-quote" as="xs:string">
        <xsl:param name="text" as="xs:string"/>
        <!-- About string quoting: https://github.com/citation-file-format/citation-file-format/blob/main/schema-guide.md#general-structure-of-a-citationcff-file -->
        <xsl:choose>
            <xsl:when test="matches($text, ':{}[],&amp;*#\?\|-&lt;&gt;=!%') or matches($text, '^[`@]') or matches($text, '^\d+$') or matches($text, '^(true|false|yes|no)$', 'i')">
                <xsl:value-of select="concat('&quot;', replace($text, '&quot;', ''''), '&quot;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>