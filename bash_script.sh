#!/bin/bash

# Download the log file
curl -L -o "access.log" "https://drive.google.com/file/d/1Wuko3rkpL9TtOXTSIVmZ3tFHYFQs2sxf/view?usp=sharing"

# Initialize the output file
output_file="audit_rpt.txt"
echo "" > "$output_file"

# Search for blacklisted IP address and SQL Injection strings
while IFS= read -r line; do
    ((line_number++))
    if echo "$line" | grep -qE '173\.255\.170\.15'; then
        echo "$line_number, bad IP found" >> "$output_file"
    fi
    if echo "$line" | grep -qE 'UNION|SELECT|'"'"' OR 1=1|DROP TABLE'; then
        echo "$line_number, SQL Injection attempt found" >> "$output_file"
    fi
done < "access.log"

# Zip the log file and output file
zip processed_log.zip access.log "$output_file"
