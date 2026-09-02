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
    <xsl:import href="dc2cff.xsl"/>


    <!-- Global parameters -->
    <xsl:param name="input-files" as="xs:string*"/><!-- (optional) paths to MEI input files -->


    <!-- Global variables -->
    <xsl:variable name="dc-all">
        <xsl:choose>
            <xsl:when test="$input-files">
                <xsl:for-each select="tokenize($input-files, ',')">
                    <oai_dc:dc>
                        <xsl:for-each select="document(.)//mei:mei">
                            <xsl:call-template name="generate-oai_dc-xml"/>
                        </xsl:for-each>
                    </oai_dc:dc>
                </xsl:for-each>                        
            </xsl:when>
            <xsl:otherwise>
                <oai_dc:dc>
                    <xsl:for-each select="//mei:mei">
                        <xsl:call-template name="generate-oai_dc-xml"/>
                    </xsl:for-each>
                </oai_dc:dc>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


    <!-- Template matching root -->
    <xsl:template match="/">        
        <xsl:for-each select="$dc-all">
            <xsl:call-template name="generate-cff-yaml"/>
        </xsl:for-each>                     
    </xsl:template>



</xsl:stylesheet>