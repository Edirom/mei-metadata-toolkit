#!/usr/bin/env python3
"""
XML Schematron Validator

Usage:
    python validate_xml.py <path_to_xml_file> <path_to_schematron_file>

Example:
    python validate_xml.py ./data/my_file.xml ./mei-metadata-toolkit/src/schema/mei-dc.sch
"""

import sys
import os

def main():
    # Check for correct number of arguments
    if len(sys.argv) != 3:
        print(f"Usage: python {sys.argv[0]} <xml_file> <schematron_file>")
        print("Example: python validate_xml.py ./file.xml ./schema.sch")
        sys.exit(1)

    xml_file_path = sys.argv[1]
    schema_file_path = sys.argv[2]

    # Check if files exist
    if not os.path.exists(xml_file_path):
        print(f"Error: XML file not found: {xml_file_path}")
        sys.exit(1)

    if not os.path.exists(schema_file_path):
        print(f"Error: Schematron file not found: {schema_file_path}")
        sys.exit(1)

    try:
        # Import the library
        from pyschematron import validate_document

        print(f"Validating: {xml_file_path}")
        print(f"Against Schema: {schema_file_path}")
        print("-" * 50)

        # Perform validation
        # validate_document takes the XML path and the Schema path
        result = validate_document(xml_file_path, schema_file_path)
        
        is_valid = result.is_valid()

        if is_valid:
            print("✅ VALIDATION PASSED")
            print("No errors found.")
            sys.exit(0)
        else:
            print("❌ VALIDATION FAILED")
            
            # Get the SVRL (Schematron Validation Report Language) output
            svrl = result.get_svrl()
            
            # Try to extract human-readable error messages
            # The svrl object contains the full XML report. 
            # We can try to parse it or just print the string representation.
            # For a simple script, printing the string is often enough for debugging.
            print("\nError Details:")
            print(svrl) 
            
            # Optional: If you want to just print the error messages without the full XML
            # You might need to parse svrl further depending on the library version.
            # For now, printing the SVRL string is the safest generic approach.
            
            sys.exit(1)

    except ImportError:
        print("Error: 'pyschematron' library not found.")
        print("Please install it first: pip install pyschematron")
        sys.exit(2)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        sys.exit(3)

if __name__ == "__main__":
    main()