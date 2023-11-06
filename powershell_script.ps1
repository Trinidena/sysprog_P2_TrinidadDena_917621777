# Download the log file
Invoke-WebRequest -Uri "https://drive.google.com/file/d/1Wuko3rkpL9TtOXTSIVmZ3tFHYFQs2sxf/view" -OutFile "logfile.log"

# Initialize the output file
$outputFile = "audit_rpt.txt"
New-Item -Path $outputFile -ItemType file -Force

# Search for blacklisted IP address and SQL Injection strings
$lineNumber = 0
Get-Content "logfile.log" -Encoding UTF8| ForEach-Object {
    $lineNumber++
    if ($_ -match "173\.255\.170\.15") {
        Add-Content -Path $outputFile -Value "$lineNumber, bad IP found"
    }
    if ($_ -match "UNION|SELECT|' OR 1=1|DROP TABLE") {
        Add-Content -Path $outputFile -Value "$lineNumber, SQL Injection attempt found"
    }
}

# Zip the log file and output file
Compress-Archive -Path "logfile.log", $outputFile -DestinationPath "processed_log.zip" -Force