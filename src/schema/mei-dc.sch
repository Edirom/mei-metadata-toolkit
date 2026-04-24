<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:mei="http://www.music-encoding.org/ns/mei">


    <!-- 
        This is a Schematron schema for checking MEI files against Dublin Core mapping rules.

        The defined rules only apply to MEI files with a root element mei:mei so that all kinds of 
        XML files can be checked without running into errors.

        Contact: Daniel Jettka <daniel.jettka@uni-paderborn.de>, Virtueller Forschungsverbund Edirom (ViFE), Universität Paderborn, Germany    
    -->


    <title>MEI 5.1 Presence Rules for mapping to Dublin Core</title>
    
    <!-- namespace declaration -->
    <ns prefix="mei" uri="http://www.music-encoding.org/ns/mei" />
    

    <!-- MINIMUM REQUIREMENTS -->
    <pattern>
    
        <title>Check for Required Infos</title>
        
        <rule context="/mei:mei">
            
            <!-- Check MEI Version -->
            <assert test="starts-with(@meiversion, '5')" role="error">
                ERROR: The &lt;mei&gt; element must have a meiversion attribute with value >= 5.x'.
            </assert>
            
        </rule>
        
        <rule context="/mei:mei/mei:meiHead/mei:fileDesc/mei:titleStmt">
                        
            <!-- Check for title -> DC field: title -->
            <assert test=".//mei:title" role="error">
                ERROR: A &lt;title&gt; element must be present within &lt;mei:titleStmt&gt;.
            </assert>
            
        </rule>
    </pattern>
    
    <!-- OPTIONAL REQUIREMENTS -->
    <!-- only apply if root element is *:mei -->
    <pattern>
    
        <title>Check for Optional Infos</title>
        
        <!-- new rule context -->
        <rule context="/mei:mei">
            
            <!-- Check for persons -> DC field: creator -->
            <assert test=".//mei:respStmt/mei:persName or .//mei:author/mei:persName or .//mei:editor/mei:persName" role="warning">
                WARNING: Cannot derive dc:creator because none of &lt;mei:respStmt/mei:persName&gt; or &lt;mei:author/mei:persName&gt; or &lt;mei:editor/mei:persName&gt; is present.
            </assert>

            <!-- Check for subjects -> DC field: subject -->
            <assert test=".//mei:fileDesc/mei:titleStmt/mei:keywords" role="warning">
                WARNING: Cannot derive dc:subject because no &lt;mei:keywords&gt; element is present.
            </assert>

            <!-- Check for descriptions -> DC field: description -->
            <assert test=".//mei:fileDesc/mei:sourceDesc/mei:source/mei:abstract or .//mei:fileDesc/mei:sourceDesc/mei:source/mei:p" role="warning">
                WARNING: Cannot derive dc:description because no &lt;mei:abstract&gt; or &lt;mei:p&gt; element is present.
            </assert>

            <!-- Check for contributor information -> DC field: contributor -->
            <assert test=".//mei:contributor/mei:persName" role="warning">
                WARNING: Cannot derive dc:contributor because no &lt;mei:contributor/mei:persName&gt; element is present.
            </assert>

            <!-- Check for type information -> DC field: type -->
            <assert test=".//mei:workList/mei:work or .//mei:music/mei:performance/mei:recording or .//mei:music/mei:facsimile" role="warning">
                WARNING: Cannot derive dc:type because none of &lt;mei:work&gt;, &lt;mei:recording&gt;, or &lt;mei:facsimile&gt; elements is present.
            </assert>

            <!-- Check for format information -> DC field: format -->
            <!-- This is just assumed to be text/mei+xml for any MEI file -->

            <!-- Check for identifiers information -> DC field: identifier -->
            <assert test=".//mei:fileDesc/mei:pubStmt/mei:identifier or .//mei:revisionDesc/mei:change" role="warning">
                WARNING: Cannot derive dc:identifier because no &lt;mei:pubStmt/mei:identifier&gt; or &lt;mei:revisionDesc/mei:change&gt; element is present.
            </assert>

            <!-- Check for source information -> DC field: source -->
            <assert test=".//mei:fileDesc/mei:sourceDesc/mei:source" role="warning">
                WARNING: Cannot derive dc:source because no &lt;mei:source&gt; element is present.
            </assert>

            <!-- Check for language information -> DC field: language -->
            <assert test=".//mei:langUsage/mei:language" role="warning">
                WARNING: Cannot derive dc:language because no &lt;mei:language&gt; element is present within &lt;mei:langUsage&gt;.
            </assert>

             <!-- Check for relation information -> DC field: relation -->
             <assert test=".//mei:repository" role="warning">
                WARNING: Cannot derive dc:relation because no &lt;mei:repository&gt; element is present.
            </assert>

            <!-- Check for coverage information -> DC field: coverage -->
            <assert test=".//mei:periodName or .//mei:geogName" role="warning">
                WARNING: Cannot derive dc:coverage because no &lt;mei:periodName&gt; or &lt;mei:geogName&gt; element is present.
            </assert>


        </rule>



        <!-- new rule context -->
        <rule context="/mei:mei//mei:fileDesc/mei:pubStmt">

            <!-- Check for publisher information -> DC field: publisher -->
            <assert test="./mei:publisher/mei:persName or ./mei:publisher/mei:name or ./mei:publisher/mei:corpName" role="warning">
                WARNING: Cannot derive dc:publisher because no &lt;publisher/persName&gt; or &lt;publisher/name&gt; or &lt;publisher/corpName&gt; element is present.
            </assert>

            <!-- Check for date information -> DC field: date -->
            <assert test="./mei:date" role="warning">
                WARNING: Cannot derive dc:date because no &lt;date&gt; element is present.
            </assert>

            <!-- Check for rights information -> DC field: rights -->
            <assert test="./mei:availability/mei:accessRestrict or ./mei:availability/mei:identifier or ./mei:availability/mei:useRestrict" role="warning">
                WARNING: Cannot derive dc:rights because no &lt;accessRestrict&gt; or &lt;identifier&gt; or &lt;useRestrict&gt; element is present within &lt;pubStmt/availability&gt;.
            </assert>

        </rule>

    </pattern>
    
    
</schema>