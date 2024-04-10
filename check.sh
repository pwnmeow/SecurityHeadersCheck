# Created by Pwnmeow 
# Twitter: @BeingSheerazAli
# sheerazali.com

#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Initialize variable to hold the custom header
CUSTOM_HEADER=""

# Process command-line options
while getopts "H:" opt; do
    case "$opt" in
        H) CUSTOM_HEADER=$OPTARG ;;
        ?) echo -e "${RED}Usage: $0 [-H \"Header: Value\"] <URL>${NC}"
           exit 1 ;;
    esac
done
shift $((OPTIND -1))

# Check if a URL was passed
if [ "$#" -ne 1 ]; then
    echo -e "${RED}Usage: $0 [-H \"Header: Value\"] <URL>${NC}"
    exit 1
fi

URL=$1

# Use curl to fetch the headers, following redirects. Include custom header if provided.
if [ -n "$CUSTOM_HEADER" ]; then
    RESPONSE_HEADERS=$(curl -s -L -D - "$URL" -o /dev/null -H "$CUSTOM_HEADER")
else
    RESPONSE_HEADERS=$(curl -s -L -D - "$URL" -o /dev/null)
fi

# Define a function to check and print a specific header
check_header() {
    HEADER_NAME=$1
    HEADER_VALUE=$(echo "$RESPONSE_HEADERS" | grep -i "$HEADER_NAME:" | cut -d ' ' -f2- | tr -d '\r' | sort | uniq)

    if [ -n "$HEADER_VALUE" ]; then
        echo -e "${GREEN}$HEADER_NAME: Found${NC}"
        # Display each unique header value on a new line
        echo "$HEADER_VALUE" | while read -r line; do
            echo -e "  Value: $line"
        done
        # Perform specific checks based on the header
        case "$HEADER_NAME" in
            "Strict-Transport-Security")
                if ! echo "$HEADER_VALUE" | grep -qi "includeSubDomains"; then
                    echo -e "${YELLOW}  Warning: 'includeSubDomains' directive is missing.${NC}"
                fi
                if ! echo "$HEADER_VALUE" | grep -qi "preload"; then
                    echo -e "${YELLOW}  Warning: 'preload' directive is missing.${NC}"
                fi
                ;;
            "Content-Security-Policy")
                if echo "$HEADER_VALUE" | grep -qi "unsafe-inline"; then
                    echo -e "${YELLOW}  Warning: 'unsafe-inline' directive should be avoided.${NC}"
                fi
                if echo "$HEADER_VALUE" | grep -qi "unsafe-eval"; then
                    echo -e "${YELLOW}  Warning: 'unsafe-eval' directive should be avoided.${NC}"
                fi
                ;;
            "X-Frame-Options")
                if ! echo "$HEADER_VALUE" | grep -qie "DENY\|SAMEORIGIN"; then
                    echo -e "${YELLOW}  Warning: X-Frame-Options should be set to either 'DENY' or 'SAMEORIGIN'.${NC}"
                fi
                ;;
            "X-Content-Type-Options")
                if ! echo "$HEADER_VALUE" | grep -qi "nosniff"; then
                    echo -e "${YELLOW}  Warning: 'nosniff' directive is missing.${NC}"
                fi
                ;;
        esac
    else
        echo -e "${RED}$HEADER_NAME: Not Found${NC}"
    fi
}

# List of security headers to check
SECURITY_HEADERS=(
    "Strict-Transport-Security"
    "Content-Security-Policy"
    "X-Frame-Options"
    "X-Content-Type-Options"
    "Referrer-Policy"
    "Permissions-Policy"
    "X-XSS-Protection"
)

# Check each security header
for HEADER in "${SECURITY_HEADERS[@]}"; do
    check_header "$HEADER"
done
