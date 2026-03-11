#!/bin/bash

# Script to generate a private key using OpenSSL
# Creates an output folder in the RBAC directory and saves the private key there
# Accepts private key filename from command line argument or interactive keyboard input

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/output"

# Create output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Get private key filename
# Priority: 1. Command line argument, 2. Interactive keyboard input
if [ -n "$1" ]; then
    # Get filename from command line argument
    KEY_FILENAME="$1"
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

# Generate private key with OpenSSL
# You can customize the key type and size as needed
# Example: RSA 2048 bits
openssl genrsa -out "${KEY_OUTPUT}" 4096

# Optional: Generate private key with different parameters
# For example, to generate a 4096-bit RSA key:
# openssl genrsa -out "${KEY_OUTPUT}" 4096

# Or to generate an EC key (secp256r1 curve):
# openssl ecparam -name secp256r1 -genkey -noout -out "${KEY_OUTPUT}"

echo "Private key generated successfully at: ${KEY_OUTPUT}"
