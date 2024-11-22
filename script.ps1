$service = "DPS"
$cmdOutput = cmd /c "tasklist /svc /FI ""Services eq $service"""

$pidMatch = $cmdOutput | Select-String -Pattern "$service" | ForEach-Object { $_.Line -split '\s+' }
$targetPID = $pidMatch[1]

if ([string]::IsNullOrWhiteSpace($targetPID)) {
    Write-Host "Service $service not found or no PID available."
    exit
}

$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$dumpFilePath = Join-Path $scriptDirectory "dump.txt"
$stringsUrl = "https://pastebin.com/raw/ZDmzDSVS"
$stringsFilePath = Join-Path $scriptDirectory "strings.txt"

Invoke-WebRequest -Uri $stringsUrl -OutFile $stringsFilePath
$strings = @{}
Get-Content $stringsFilePath | ForEach-Object {
    $searchString, $foundString = $_ -split "\."
    $strings[$searchString] = [PSCustomObject]@{
        Found   = $foundString
        Pattern = [regex]::Escape($searchString)
    }
}

$strings2Path = Join-Path $scriptDirectory "strings.exe"  # Path to strings.exe in script directory
if (-not (Test-Path -Path $strings2Path)) {
    $strings2DownloadUrl = "https://github.com/glmcdona/strings2/raw/master/x64/Release/strings.exe"
    Invoke-WebRequest -Uri $strings2DownloadUrl -OutFile $strings2Path
}

$outputFilePath = Join-Path $scriptDirectory "dump.txt"
$dumpCommand = "$strings2Path -pid $targetPID -raw -nh"

try {
    $memoryDump = Invoke-Expression $dumpCommand
} catch {
    Write-Host "Error extracting strings from process memory: $_"
    exit
}

$memoryDump | Out-File -FilePath $outputFilePath -Encoding UTF8

$dumpContent = Get-Content -Raw $dumpFilePath
if ([string]::IsNullOrWhiteSpace($dumpContent)) {
    Write-Host "Error: No content found in the memory dump file."
    Remove-Item -Path $stringsFilePath -Force
    Get-ChildItem -Path $scriptDirectory | Where-Object { $_.Name -ne "output.txt" } | Remove-Item -Recurse -Force
    exit
}

$combinedPattern = ($strings.Values.Pattern -join '|')
$regex = [regex]::new($combinedPattern)
$outputBuilder = [System.Text.StringBuilder]::new()

$matches = $regex.Matches($dumpContent)
foreach ($match in $matches) {
    $matchingStringData = $strings[$match.Value]
    if ($matchingStringData) {
        $applicationName = $dumpContent -match "!!(.*?)!$($match.Value)" | ForEach-Object { $matches[1] }
        $outputBuilder.AppendLine("$($matchingStringData.Found) ($applicationName) Found")
    }
}

$output = $outputBuilder.ToString()

if ([string]::IsNullOrWhiteSpace($output)) {
    Write-Host "No matching strings found in memory dump."
    Remove-Item -Path $stringsFilePath -Force
    Remove-Item -Path $dumpFilePath -Force
    Remove-Item -Path $stringsFilePath -Force
    Remove-Item -Path $strings2Path -Force
} else {
    $outputFilePath = Join-Path $scriptDirectory "output.txt"
    $output | Out-File -FilePath $outputFilePath -Encoding UTF8
    Invoke-Item $outputFilePath
}

Remove-Item -Path $stringsFilePath -Force
Remove-Item -Path $dumpFilePath -Force
Remove-Item -Path $stringsFilePath -Force
Remove-Item -Path $strings2Path -Force
