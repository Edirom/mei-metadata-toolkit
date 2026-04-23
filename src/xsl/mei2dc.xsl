<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="mei">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <oai_dc:dc xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
            <xsl:call-template name="generate-dc"/>
        </oai_dc:dc>
    </xsl:template>

    <xsl:template name="generate-dc">

        <xsl:comment>This Dublin Core file was generated from MEI metadata using mei2dc.xsl.</xsl:comment>

        <!-- 1. Title: The name given to the resource -->
        <xsl:for-each select="(//mei:titleStmt/mei:title, error((),'FATAL ERROR: No title found)'))[1]">
            <dc:title>
                <xsl:copy-of select="@xml:lang"/>
                <xsl:value-of select="."/>
            </dc:title>
        </xsl:for-each>
        
        <!-- 2. Creator: An entity primarily responsible for making the resource -->
        <xsl:for-each select="//mei:respStmt/mei:persName | //mei:author/mei:persName | //mei:editor/mei:persName">
            <dc:creator><xsl:value-of select="."/></dc:creator>
        </xsl:for-each>
        
        <!-- 3. Subject: The topic of the resource -->
        <xsl:for-each select="//mei:fileDesc/mei:titleStmt/mei:keywords">
            <dc:subject>            
                <xsl:copy-of select="@xml:lang"/>
                <xsl:value-of select="."/>
            </dc:subject>
        </xsl:for-each>
        
        <!-- 4. Description: An account of the resource -->
        <xsl:for-each select="//mei:fileDesc/mei:sourceDesc/mei:source/mei:abstract | //mei:fileDesc/mei:sourceDesc/mei:source/mei:p">
            <dc:description>
                <xsl:copy-of select="@xml:lang"/>
                <xsl:value-of select="."/>
            </dc:description>
        </xsl:for-each>

        <!-- 5. Publisher: An entity responsible for making the resource available -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:publisher/mei:persName | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:name | //mei:fileDesc/mei:pubStmt/mei:publisher/mei:corpName" group-by=".">
            <xsl:for-each select="current-group()">
                <dc:publisher><xsl:value-of select="."/></dc:publisher>
            </xsl:for-each>
        </xsl:for-each-group>
        
        <!-- 6. Contributor: An entity responsible for making contributions to the resource -->
        <xsl:for-each select="//mei:contributor/mei:persName">
            <dc:contributor><xsl:value-of select="."/></dc:contributor>
        </xsl:for-each>
        
        <!-- 7. Date: A point or period of time associated with an event in the lifecycle of the resource -->
        <xsl:for-each select="//mei:fileDesc/mei:pubStmt/mei:date">
            <dc:date><xsl:value-of select="."/></dc:date>
        </xsl:for-each>
        
        <!-- 8. Type: The nature or genre of the resource -->
        <xsl:for-each select="//mei:workList/mei:work | //mei:music/mei:performance/mei:recording | //mei:music/mei:facsimile">
            <dc:type><xsl:value-of select="concat(upper-case(substring(local-name(), 1, 1)), substring(local-name(), 2))"/></dc:type>
        </xsl:for-each>
        
        <!-- 9. Format: The physical or digital manifestation of the resource -->
        <dc:format>text/mei+xml</dc:format>
        
        <!-- 10. Identifier: An unambiguous reference to the resource within a given context -->
        <xsl:for-each select="//mei:fileDesc/mei:pubStmt/mei:identifier">
            <dc:identifier><xsl:value-of select="."/></dc:identifier>
        </xsl:for-each>
        <xsl:for-each select="//mei:revisionDesc/mei:change">
            <xsl:sort select="substring-before(mei:date/@isodate, '-')" data-type="number" order="descending"/><!-- year of date -->
            <xsl:sort select="substring-after(substring-before(mei:date/@isodate, '-'), '-')" data-type="number" order="descending"/><!-- month of date -->
            <xsl:sort select="substring-after(substring-after(mei:date/@isodate, '-'), '-')" data-type="number" order="descending"/><!-- day of date -->
            <xsl:sort select="@n" data-type="number" order="descending"/>
            <xsl:sort select="position()" data-type="number" order="descending"/>
            <xsl:if test="position() = 1">
                <dc:identifier><xsl:value-of select="string-join(mei:changeDesc//text()[not(matches(.,'^\s*$'))], ' ')"/></dc:identifier>
            </xsl:if>
        </xsl:for-each>
        
        <!-- 11. Source: A related resource from which the described resource is derived -->  
        <!--     mei:source - A bibliographic description of a source used in the creation of the electronic file. -->      
        <!-- and others sources? -->
        <xsl:for-each select="//mei:fileDesc/mei:sourceDesc/mei:source">
            <dc:source>
                <xsl:value-of select="join-descendants(., '; ')"/>
            </dc:source>
        </xsl:for-each>
        
        <!-- 12. Language: A language of the resource -->
        <xsl:for-each select="//mei:langUsage/mei:language">
            <dc:language><xsl:value-of select="."/></dc:language>
        </xsl:for-each>
                
        <!-- 13. Relation: A related resource -->
        <xsl:for-each select="//mei:repository">
            <dc:relation><xsl:value-of select="."/></dc:relation>
        </xsl:for-each>
        
        <!-- 14. Coverage: The spatial or temporal topic of the resource -->
        <xsl:for-each select="//mei:periodName, //mei:geogName">
            <dc:coverage><xsl:value-of select="."/></dc:coverage>
        </xsl:for-each>
        
        <!-- 15. Rights: Information about rights held in and over the resource -->
        <xsl:for-each-group select="//mei:fileDesc/mei:pubStmt/mei:availability/mei:accessRestrict | //mei:fileDesc/mei:pubStmt/mei:availability/mei:identifier | //mei:fileDesc/mei:pubStmt/mei:availability/mei:useRestrict" group-by=".">
            <dc:rights><xsl:value-of select="string-join(current-group(), ', ')"/></dc:rights>
        </xsl:for-each-group>
        
    </xsl:template>


    <!-- Helper function to join descendant text nodes with a separator -->
    <xsl:function name="join-descendants" as="xs:string">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:param name="separator" as="xs:string"/>
        <xsl:variable name="values" as="xs:string*" select="$nodes//text()[not(matches(.,'^\s*$'))]"/>
        <xsl:value-of select="string-join(replace($values, '\s+', ' '), $separator)"/>
    </xsl:function>

</xsl:stylesheet>