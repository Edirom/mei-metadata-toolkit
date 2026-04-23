<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:mei="http://www.music-encoding.org/ns/mei">

    <title>MEI 5.1 Presence Rules for mapping to Citation File Format (CFF)</title>
    
    <!-- namespace declaration -->
    <ns prefix="mei" uri="http://www.music-encoding.org/ns/mei" />
    

    <!-- MINIMUM REQUIREMENTS -->
    <pattern>
        <title>Check for Required Infos</title>
        
        <rule context="/*">
            
            <!-- Check root element -->
            <assert test="local-name() = 'mei'" role="error">
                ERROR: Root element must be &lt;mei&gt;.
            </assert>
            
            <!-- Check MEI Version -->
            <assert test="starts-with(@meiversion, '5')" role="error">
                ERROR: The &lt;mei&gt; element must have a meiversion attribute with value >= 5.x'.
            </assert>
            
            <!-- Check for persons -> CFF field: authors -->
            <assert test=".//mei:respStmt/mei:persName or .//mei:author/mei:persName or .//mei:contributor/mei:persName or 
                    .//mei:editor/mei:persName" role="error">
                ERROR: A &lt;respStmt/persName&gt; or &lt;author&gt; or &lt;contributor&gt; or &lt;editor&gt; element must be present.
            </assert>
            
        </rule>
        
        <rule context="/mei:mei/mei:meiHead/mei:fileDesc/mei:titleStmt">
                        
            <!-- Check for title -> CFF field: title -->
            <assert test=".//mei:title" role="error">
                ERROR: A &lt;title&gt; element must be present within &lt;titleStmt&gt;.
            </assert>
            
        </rule>
    </pattern>
    

    <!-- OPTIONAL REQUIREMENTS -->
    <pattern>
        <title>Check for Optional Infos</title>
        
        <!-- new rule context -->
        <rule context="/*">
            
            <!-- Check for keywords information -> CFF field: keywords -->
            <assert test=".//mei:fileDesc/mei:titleStmt/mei:keywords" role="warning">
                WARNING: Cannot derive keywords because no &lt;titleStmt/keywords&gt; is present.
            </assert>

            <!-- Check for repository information -> CFF field: repository -->
            <assert test=".//mei:repository" role="warning">
                WARNING: Cannot derive repository because no &lt;repository&gt; is present.
            </assert>

            <!-- Check for type information -> CFF field: type -->
            <assert test=".//mei:workList/mei:work or .//mei:music/mei:performance/mei:recording or .//mei:music/mei:facsimile" role="warning">
                WARNING: Cannot derive type because none of &lt;work&gt;, &lt;recording&gt;, or &lt;facsimile&gt; is present.
            </assert>

            <!-- Check for version information -> CFF field: version -->
            <assert test=".//mei:revisionDesc/mei:changeDesc/mei:change" role="warning">
                WARNING: Cannot derive version because no &lt;changeDesc/change&gt; is present.
            </assert>

        </rule>


        <!-- new rule context -->
        <rule context="//mei:fileDesc/mei:sourceDesc/mei:source">

            <!-- Check for abstract information -> CFF field: abstract -->
            <assert test="./mei:abstract or ./mei:p" role="warning">
                WARNING: Cannot derive abstract because no &lt;source/abstract&gt; or &lt;source/p&gt; is present.
            </assert>

        </rule>


        <!-- new rule context -->
        <rule context="//mei:fileDesc/mei:pubStmt">

            <!-- Check for contact information -> CFF field: contact -->
            <assert test="./mei:publisher/mei:persName or ./mei:name or ./mei:publisher/mei:corpName" role="warning">
                WARNING: Cannot derive contact because no &lt;publisher/persName&gt;, &lt;publisher/name&gt;, or &lt;publisher/corpName&gt; is present.
            </assert>

            <!-- Check for date information -> CFF field: date-released -->
            <assert test="./mei:date" role="warning">
                WARNING: Cannot derive date-released because no &lt;pubStmt/date&gt; is present.
            </assert>

            <!-- Check for identifiers information -> CFF field: identifiers -->
            <assert test="./mei:identifier" role="warning">
                WARNING: Cannot derive identifiers because no &lt;pubStmt/identifier&gt; is present.
            </assert>

            <!-- Check for license information -> CFF field: license -->
            <assert test="./mei:availability/mei:accessRestrict or ./mei:availability/mei:identifier or ./mei:availability/mei:useRestrict" role="warning">
                WARNING: Cannot derive license because no &lt;accessRestrict&gt;, &lt;identifier&gt;, or &lt;useRestrict&gt; is present within &lt;pubStmt/availability&gt;.
            </assert>

        </rule>

    </pattern>
    
    
</schema>