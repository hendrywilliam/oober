#!/bin/bash

# Script to generate private keys and certificate requests using OpenSSL
# Usage:
#   ./generate_key.sh gen [filename] [bits=4096]              - Generate private key
#   ./generate_key.sh req <private_key> "<subject>" - Generate CSR with subject.
#   ./generate_key.sh print <filename>                        - Print file info (CSR or private key)

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/output"

# Create output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Check if mode argument is provided
if [ -z "$1" ]; then
    echo "Error: No mode specified."
    echo "Usage:"
    echo "  ./generate_key.sh gen [filename] [bits=4096]              - Generate private key"
    echo "  ./generate_key.sh req <private_key> \"<subject>\" - Generate X.509 Certificate Signing Request with subject"
    echo "  ./generate_key.sh print <filename>                        - Print file info (CSR or private key)"
    echo ""
    echo "Subject format:"
    echo "  \"/CN=batman/O=testgroup/O=groupA\""
    exit 1
fi

MODE="$1"

case "$MODE" in
    gen)
        # Generate private key mode
        if [ -n "$2" ]; then
            KEY_FILENAME="$2"
        else
            # Loop to get filename from keyboard input
            while true; do
                echo "Enter private key filename (press Enter for default 'private_key.pem'):"
                read KEY_FILENAME

                # If empty input, use default
                if [ -z "$KEY_FILENAME" ]; then
                    KEY_FILENAME="private_key.pem"
                    break
                fi

                # Check if input is not empty
                if [ -n "$KEY_FILENAME" ]; then
                    break
                fi
            done
        fi

        # Remove .pem extension if present to avoid double extension
        KEY_FILENAME=$(basename "$KEY_FILENAME" .pem).pem

        # Define full output path
        KEY_OUTPUT="${OUTPUT_DIR}/${KEY_FILENAME}"

        # Check if file already exists
        if [ -f "$KEY_OUTPUT" ]; then
            echo "Warning: File '$KEY_FILENAME' already exists in output directory."
            read -p "Do you want to overwrite it? (y/N): " confirm
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                echo "Operation cancelled."
                exit 0
            fi
        fi

        if [ -n "$3" ]; then
          BITS="$3"
        else
          BITS="4096"
        fi

        # Generate private key with OpenSSL (RSA 4096 bits)
        openssl genrsa -out "${KEY_OUTPUT}" "${BITS}"

        echo "Private key generated successfully at: ${KEY_OUTPUT} with ${BITS} bits."
        ;;

    req)
        # Generate certificate request mode
        if [ -z "$2" ]; then
            echo "Error: Private key is required for req mode."
            echo "Usage: ./generate_key.sh req <private_key> \"<subject>\""
            exit 1
        fi

        KEY_FILENAME="$2"

        if [ -z "$3" ]; then
            echo "Error: Subject is required for req mode."
            echo "Usage: ./generate_key.sh req <private_key> \"<subject>\""
            echo ""
            echo "Subject format:"
            echo "  \"/CN=batman/O=testgroup/O=groupA\""
            exit 1
        fi

        SUBJECT="$3"

        # Remove .pem extension if present
        KEY_FILENAME=$(basename "$KEY_FILENAME" .pem).pem
        KEY_PATH="${OUTPUT_DIR}/${KEY_FILENAME}"

        # Check if private key exists
        if [ ! -f "$KEY_PATH" ]; then
            echo "Error: Private key '$KEY_FILENAME' not found in output directory."
            exit 1
        fi

        # Extract CN from subject string
        CN=$(echo "$SUBJECT" | grep -oP '(?<=CN=)[^/]+')
        if [ -z "$CN" ]; then
            # Fallback to private key name if CN not found
            CN=$(basename "$KEY_FILENAME" .pem)
        fi

        # Generate CSR filename based on CN
        CSR_FILENAME="${CN}.csr"
        CSR_OUTPUT="${OUTPUT_DIR}/${CSR_FILENAME}"

        # Check if CSR file already exists
        if [ -f "$CSR_OUTPUT" ]; then
            echo "Warning: CSR file '$CSR_FILENAME' already exists in output directory."
            read -p "Do you want to overwrite it? (y/N): " confirm
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                echo "Operation cancelled."
                exit 0
            fi
        fi

        # Generate CSR
        openssl req -new -key "${KEY_PATH}" -out "${CSR_OUTPUT}" -subj "${SUBJECT}" -sha256

        echo "Certificate request generated successfully at: ${CSR_OUTPUT}"
        echo ""
        echo "Subject: ${SUBJECT}"
        echo ""
        echo "You can view the CSR details with:"
        echo "  openssl req -in ${CSR_OUTPUT} -text -noout"
        ;;

        print)
            # Print file info mode
            if [ -z "$2" ]; then
                echo "Error: Filename is required for print mode."
                echo "Usage: ./generate_key.sh print <filename>"
                exit 1
            fi

            FILENAME="$2"

            # Check if filename has path, otherwise use output directory
            if [[ "$FILENAME" == */* ]]; then
                FILE_PATH="$FILENAME"
            else
                FILE_PATH="${OUTPUT_DIR}/${FILENAME}"
            fi

            # Check if file exists
            if [ ! -f "$FILE_PATH" ]; then
                echo "Error: File '$FILENAME' not found."
                exit 1
            fi

            # Get file extension
            EXT="${FILENAME##*.}"
            BASENAME=$(basename "$FILENAME" "$EXT")

            echo ""
            echo "=================================="
            echo "File: $FILENAME"
            echo "Path: $FILE_PATH"
            echo "=================================="
            echo ""

            # Determine command based on extension
            case "$EXT" in
                csr)
                    echo "Type: Certificate Signing Request (CSR)"
                    echo ""
                    echo "--- Subject ---"
                    openssl req -in "$FILE_PATH" -subject -noout
                    echo ""
                    echo "--- Full Details ---"
                    openssl req -in "$FILE_PATH" -text -noout
                    ;;
                pem|key)
                    echo "Type: Private Key"
                    echo ""
                    echo "--- Key Details ---"
                    openssl rsa -in "$FILE_PATH" -text -noout
                    ;;
                crt|cer|p12|pfx)
                    echo "Type: Certificate"
                    echo ""
                    echo "--- Subject ---"
                    openssl x509 -in "$FILE_PATH" -subject -noout
                    echo ""
                    echo "--- Full Details ---"
                    openssl x509 -in "$FILE_PATH" -text -noout
                    ;;
                *)
                    echo "Warning: Unknown file extension '.$EXT'"
                    echo ""
                    echo "Trying to detect file type..."

                    # Try CSR
                    if openssl req -in "$FILE_PATH" -noout -text >/dev/null 2>&1; then
                        echo "Detected: Certificate Signing Request (CSR)"
                        echo ""
                        openssl req -in "$FILE_PATH" -text -noout
                    # Try private key
                    elif openssl rsa -in "$FILE_PATH" -noout -text >/dev/null 2>&1; then
                        echo "Detected: Private Key"
                        echo ""
                        openssl rsa -in "$FILE_PATH" -text -noout
                    # Try certificate
                    elif openssl x509 -in "$FILE_PATH" -noout -text >/dev/null 2>&1; then
                        echo "Detected: Certificate"
                        echo ""
                        openssl x509 -in "$FILE_PATH" -text -noout
                    else
                        echo "Error: Unable to detect file type or read the file."
                        exit 1
                    fi
                    ;;
            esac
            ;;

        *)
            echo "Error: Invalid mode '$MODE'."
            echo "Valid modes are: gen, req, print"
            echo ""
            echo "Usage:"
            echo "  ./generate_key.sh gen [filename]               - Generate private key"
            echo "  ./generate_key.sh req <private_key> \"<subject>\" - Generate CSR with subject"
            echo "  ./generate_key.sh print <filename>             - Print file info (CSR or private key)"
            echo ""
            echo "Subject format:"
            echo "  \"/CN=batman/O=testgroup/O=groupA\""
            exit 1
            ;;
esac
