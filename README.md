# MEI Metadata Toolkit

Toolkit for [validation](#validation) and [conversion](#conversion) of MEI metadata to standard metadata.

The processing steps are available as workflows for GitHub Actions.

## Usage

Simply copy the following files (or a selection) from the directory `workflows` into the `.github/workflows` directory of the GitHub repository of your Digital Music Edition (or other type of resource containing MEI files):

* `mei-dublin-core-validation.yml` - Validation of Dublin Core compliance of MEI files within the project, also see section [Dublin Core Compliance of MEI](#dublin-core-compliance-of-mei)
* `mei-dublin-core-extraction.yml` - Extraction of Dublin Core XML files from MEI files in the project, also see section [Dublin Core (DC) from MEI](#dublin-core-dc-from-mei)
* `mei-citation-file-format-extraction.yml` - Extraction of a CITATION.cff from MEI files in the project, also see section [Citation File Format (CFF) from MEI](#citation-file-format-cff-from-mei)

Inside the workflow files please adjust the action trigger and used branches to your preferred settings.

The workflows will use the tools from this repository (via a actions/checkout step) and search the complete repository for MEI files (files with `.xml` file ending and a `mei:mei` root element and a `@meiversion` attribute starting with "5"). They then validate and convert those files with the schema and scripts described below.

**Please note:** 
The GitHub Actions will commit the extracted metadata into files in the directories `metadata/dc` and `metadata/cff` directly in the repository. Furthermore, they will write processing reports into the directory `.github/workflow-reports`.


## Validation

### Dublin Core Compliance of MEI

The Schematron schema `src/schema/mei-dc.sch` validates MEI 5.x files for the presence of metadata needed to generate Dublin Core records

* it checks that the root `<mei>` element declares an MEI version starting with 5 and requires at least one title in `<mei:titleStmt>`, since this is essential for mapping to dc:title
* in addition, it issues warnings when optional metadata fields are missing that would otherwise be used to derive Dublin Core elements such as dc:creator, dc:subject, dc:description, dc:publisher, dc:contributor, dc:date, dc:type, dc:identifier, dc:source, dc:language, dc:relation, dc:coverage, and dc:rights
* the schema is designed to be safely run on collections containing different XML files, because its rules only apply to documents with an MEI root element
* it helps identify whether MEI files contain sufficient descriptive metadata for reliable transformation into Dublin Core.


## Conversion

### Dublin Core (DC) from MEI

The XSLT stylesheet `src/xsl/mei2dc.xsl` transforms metadata from MEI 5.x files into OAI Dublin Core XML.

* the xsl checks whether the input document is a valid MEI file with a meiversion starting with 5
  * if so, it creates an `<oai_dc:dc>` record using the standard Dublin Core Elements namespace
  * the transformation maps MEI metadata such as titles, creators, contributors, publishers, dates, identifiers, sources, languages, repositories, coverage information, and rights statements to the corresponding Dublin Core fields
  * it also adds a fixed format value of text/mei+xml and derives a version identifier from the latest entry in the MEI revision history
* if the input file is not an MEI 5.x document, no Dublin Core metadata is generated.

How to apply:

### Citation File Format (CFF) from MEI

The XSLT stylesheet `src/xsl/mei2cff.xsl` generates a Citation File Format (CFF) YAML file from metadata extracted from MEI.

* it imports the `mei2dc.xsl` to first convert MEI metadata into Dublin Core
* then it collects metadata from all .xml files in the configured directory or directories
* the resulting Dublin Core fields are mapped to CFF properties such as title, authors, abstract, contact, date-released, identifiers, keywords, license, repository, and version
* repeated values are deduplicated where appropriate, DOI identifiers are marked as such, and the output is serialized as plain text in valid CFF-style YAML.
* the generated file uses CFF version 1.2.0, assigns the resource type dataset, and includes a message noting that the file was generated from MEI metadata via the MEI-to-Dublin-Core and Dublin-Core-to-CFF transformation workflow.


## License

This code is released to the public under the terms of the MIT open source license.
