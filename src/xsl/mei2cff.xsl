<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fx="http://example.com/fx"
    exclude-result-prefixes="mei xs fx">

    <xsl:output indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    
    <!-- Global parameters -->
    <xsl:param name="mode" select="'xml'" as="xs:string"/><!-- xml or yaml -->
    <xsl:param name="scope" select="'global'" as="xs:string"/><!-- single or global -->
    <xsl:param name="directories" select="('file:/home/djettka/git-clones/Edirom/EditionExample')" as="xs:string+"/>


    <xsl:variable name="cff-all">
        <xsl:for-each select="$directories">
            <cff-collection dir="{.}">
                <xsl:for-each select="collection(concat(., '?select=*.xml;recurse=yes;on-error=warning'))/mei:mei">
                    <xsl:call-template name="generate-cff-xml"/>
                </xsl:for-each>
            </cff-collection>
        </xsl:for-each>        
    </xsl:variable>


    <!-- Template matching root -->
    <xsl:template match="/">

        <xsl:choose>

            <!-- transform all MEI files into one CFF -->
            <xsl:when test="$scope ='global'">                
                <xsl:copy-of select="$cff-all"/>
            </xsl:when>

            <!-- transform single MEI file -->
            <xsl:when test="$scope ='single'">
                <xsl:choose>
                    <xsl:when test="$mode='xml'">
                        <xsl:call-template name="generate-cff-xml"/>
                    </xsl:when>
                    <xsl:when test="$mode='yaml'">
                        <xsl:call-template name="generate-cff-yaml"/>
                    </xsl:when>
                </xsl:choose>   
            </xsl:when>
        </xsl:choose>
     
    </xsl:template>



    <!-- Generate Citation File Format (CFF) metadata XML -->
    <xsl:template name="generate-cff-xml">

        <cff version="1.2.0" file="{base-uri(.)}">
    
            <!-- title -->
            <title><xsl:value-of select="string-join(distinct-values(//mei:titleStmt/mei:title), '; ')"/></title>
            
    
            <!-- authors -->
            <xsl:for-each-group select="//mei:respStmt/mei:persName | //mei:author/mei:persName | //mei:contributor/mei:persName | //mei:editor/mei:persName" group-by="1">
                <authors>                            
                    <xsl:for-each select="distinct-values(current-group())">
                        <name><xsl:value-of select="."/></name>
                    </xsl:for-each>
                </authors>
            </xsl:for-each-group>
            
    
    
            <!-- abstract -->
            <xsl:for-each-group select="//mei:fileDesc/mei:sourceDesc/mei:source/mei:abstract | //mei:fileDesc/mei:sourceDesc/mei:source/mei:p" group-by="1">
                <abstract><xsl:value-of select="string-join(current-group()/replace(replace(., '\s+', ' '), '&quot;', ''''), ' ')"/></abstract>
            </xsl:for-each-group>
    
    
            <!-- contact -->
            <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:publisher/mei:persName | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:name | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:corpName" group-by="1">
                <contact>
                    <xsl:for-each select="current-group()">
                        <name><xsl:value-of select="."/></name>
                    </xsl:for-each>
                </contact>
            </xsl:for-each-group>
    
    
            <!-- date-released -->
            <xsl:for-each select="//mei:fileDesc/mei:pubStmt/mei:date">
                <date-released><xsl:value-of select="."/></date-released>
            </xsl:for-each>
    
    
            <!-- identifiers -->
            <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:identifier" group-by="1">
                <identifiers>
                    <xsl:for-each select="current-group()">
                        <val><xsl:value-of select="."/></val>
                        <xsl:if test="@type">
                            <type><xsl:value-of select="@type"/></type>
                        </xsl:if>
                    </xsl:for-each>
                </identifiers>    
            </xsl:for-each-group>
            
    
            <!-- keywords -->
            <xsl:for-each-group select="//mei:fileDesc/mei:titleStmt/mei:keywords" group-by="1">
                <keywords>
                    <xsl:for-each select="current-group()">
                        <val><xsl:value-of select="."/></val>
                    </xsl:for-each>
                </keywords>
            </xsl:for-each-group>
    
    
            <!-- license -->
            <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:availability/mei:accessRestrict | //mei:fileDesc/mei:pubStmt/mei:availability/mei:identifier | //mei:fileDesc/mei:pubStmt/mei:availability/mei:useRestrict" group-by="1">
                <license>
                    <xsl:choose>
                        <xsl:when test="current-group()[2]">
                            <xsl:text>&#10;</xsl:text>
                            <xsl:for-each select="current-group()">
                                <val><xsl:value-of select="."/></val>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </license>
            </xsl:for-each-group>
    
    
            <!-- repository -->
            <xsl:for-each-group select="//mei:repository" group-by="1">
                <repository>
                    <xsl:value-of select="string-join(current-group(), ', ')"/>
                </repository>
            </xsl:for-each-group>
    
    
            <!-- type-->
            <type>dataset</type>
    
    
            <!-- version -->
            <xsl:for-each select="//mei:revisionDesc/mei:change">
                <xsl:sort select="substring-before(mei:date/@isodate, '-')" data-type="number" order="descending"/><!-- year of date -->
                <xsl:sort select="substring-after(substring-before(mei:date/@isodate, '-'), '-')" data-type="number" order="descending"/><!-- month of date -->
                <xsl:sort select="substring-after(substring-after(mei:date/@isodate, '-'), '-')" data-type="number" order="descending"/><!-- day of date -->
                <xsl:sort select="@n" data-type="number" order="descending"/>
                <xsl:sort select="position()" data-type="number" order="descending"/>
                <xsl:if test="position() = 1">
                    <version><xsl:value-of select="string-join(mei:changeDesc//text()[not(matches(.,'^\s*$'))], ' ')"/></version>
                </xsl:if>
            </xsl:for-each>
    
            <!-- message -->
            <message>This CFF file was generated from MEI metadata using mei2cff.xsl</message>

        </cff>
        
    </xsl:template>


    <!-- Generate Citation File Format (CFF) metadata YAML -->
    <xsl:template name="generate-cff-yaml">

        <!-- cff-version -->
        <xsl:text>cff-version: 1.2.0&#10;</xsl:text>

        <!-- title -->
        <xsl:text>title: "</xsl:text><xsl:value-of select="string-join(distinct-values(//mei:titleStmt/mei:title), '; ')"/><xsl:text>"&#10;</xsl:text>
        

        <!-- authors -->
        <xsl:for-each-group select="//mei:respStmt/mei:persName | //mei:author/mei:persName | //mei:contributor/mei:persName | //mei:editor/mei:persName" group-by="1">
            <xsl:text>authors:&#10;</xsl:text>
            <xsl:for-each select="distinct-values(current-group())">
                <xsl:text>  - name: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>
        


        <!-- abstract -->
        <xsl:for-each-group select="//mei:fileDesc/mei:sourceDesc/mei:source/mei:abstract | //mei:fileDesc/mei:sourceDesc/mei:source/mei:p" group-by="1">
            <xsl:text>abstract: "</xsl:text><xsl:value-of select="string-join(current-group()/replace(replace(., '\s+', ' '), '&quot;', ''''), ' ')"/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>


        <!-- contact -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:publisher/mei:persName | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:name | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:corpName" group-by="1">
            <xsl:text>contact:&#10;</xsl:text>
            <xsl:for-each select="current-group()">
                <xsl:text>  - name: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>


        <!-- date-released -->
        <xsl:for-each select="//mei:fileDesc/mei:pubStmt/mei:date">
            <xsl:text>date-released: "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
        </xsl:for-each>


        <!-- identifiers -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:identifier" group-by="1">
            <xsl:text>identifiers:&#10;</xsl:text>
            <xsl:for-each select="current-group()">
                <xsl:text>  - value: </xsl:text><xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
                <xsl:if test="@type">
                    <xsl:text>    type: </xsl:text><xsl:value-of select="@type"/><xsl:text>&#10;</xsl:text>
                </xsl:if>
            </xsl:for-each>            
        </xsl:for-each-group>
        

        <!-- keywords -->
        <xsl:for-each-group select="//mei:fileDesc/mei:titleStmt/mei:keywords" group-by="1">
            <xsl:text>keywords:&#10;</xsl:text>
            <xsl:for-each select="current-group()">
                <xsl:text>  - "</xsl:text><xsl:value-of select="."/><xsl:text>"&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each-group>


        <!-- license -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:availability/mei:accessRestrict | //mei:fileDesc/mei:pubStmt/mei:availability/mei:identifier | //mei:fileDesc/mei:pubStmt/mei:availability/mei:useRestrict" group-by="1">
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
        <xsl:for-each-group select="//mei:repository" group-by="1">
            <xsl:text>repository: "</xsl:text>
            <xsl:value-of select="fx:cff-quote(string-join(current-group(), ', '))"/>
            <xsl:text>"&#10;</xsl:text>
        </xsl:for-each-group>


        <!-- type-->
        <xsl:text>type: dataset&#10;</xsl:text>


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
        <xsl:text>message: "This CFF file was generated from MEI metadata using mei2cff.xsl"</xsl:text>

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