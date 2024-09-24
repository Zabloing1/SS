# Function to display the logo at the beginning
Function Show-Logo {
    $logo = @"
░██████╗████████╗██████╗░███████╗░█████╗░███╗░░░███╗
██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗████╗░████║
╚█████╗░░░░██║░░░██████╔╝█████╗░░███████║██╔████╔██║
░╚═══██╗░░░██║░░░██╔══██╗██╔══╝░░██╔══██║██║╚██╔╝██║
██████╔╝░░░██║░░░██║░░██║███████╗██║░░██║██║░╚═╝░██║
╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝

██╗░░░██╗██╗███████╗░██╗░░░░░░░██╗██████╗░
██║░░░██║██║██╔════╝░██║░░██╗░░██║██╔══██╗
╚██╗░██╔╝██║█████╗░░░╚██╗████╗██╔╝██████╔╝
░╚████╔╝░██║██╔══╝░░░░████╔═████║░██╔══██╗
░░╚██╔╝░░██║███████╗░░╚██╔╝░╚██╔╝░██║░░██║
░░░╚═╝░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝
(Coded by _s0sa_. Shittyscreensharer for ScreenShare Network Community...)
"@
    Write-Host -ForegroundColor Red $logo
}

# Function to log errors
Function Log-Error {
    param (
        [string]$message
    )
    $errorLog = "$($env:userprofile)\Desktop\error_log.txt"
    Add-Content -Path $errorLog -Value "$(Get-Date -Format 'dd-MM-yyyy hh:mm:ss'): $message"
}

# Function to select a folder
Function Get-Folder($initialDirectory = [System.Environment]::GetFolderPath("MyDocuments")) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.RootFolder = [System.Environment+SpecialFolder]::MyComputer
    $foldername.SelectedPath = $initialDirectory
    $foldername.Description = "Select a directory to scan files for Alternate Data Streams"
    $foldername.ShowNewFolderButton = $false

    if ($foldername.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $foldername.SelectedPath
    } else {
        Write-Host "(Streams.ps1):" -ForegroundColor Yellow -NoNewline
        Write-Host " User Cancelled" -ForegroundColor White
        exit
    }
}

# Main scanning function
Function Scan-Folder {
    param (
        [string]$ScanFolder
    )

    Clear-Host  # Clear the screen
    Show-Logo   # Display the logo

    $Folder = if (-not $ScanFolder) { Get-Folder } else { $ScanFolder }

    Write-Host "(Streams.ps1):" -ForegroundColor Yellow -NoNewline
    Write-Host " Selected directory: ($Folder)" -ForegroundColor White

    # Get all files in the directory and collect necessary properties
    $Files = Get-ChildItem -Path $Folder -Recurse -File -ErrorAction Ignore | 
             Select-Object Name, FullName, @{Name='Owner'; Expression={(Get-Acl $_.FullName).Owner}},
                           Length, LastAccessTime, LastWriteTime, Attributes

    $results = @()
    $i = 1

    foreach ($File in $Files) {
        # Check for Alternate Data Streams
        $Stream = ""
        try {
            $Stream = (Get-Item -LiteralPath $File.FullName -Stream * -ErrorAction Ignore).Stream -join ", "
        } catch {
            Log-Error "Error reading streams for $($File.FullName): $_"
        }

        # Calculate hash (MD5 by default)
        $hash = ""
        try {
            $hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm "MD5" -ErrorAction Ignore).Hash
        } catch {
            Log-Error "Error calculating hash for $($File.FullName): $_"
        }

        # Collect results in a single object
        $results += [PSCustomObject]@{
            Path                = Split-Path -LiteralPath $File.FullName
            'File/Directory Name' = $File.Name
            'MD5 Hash (File Hash only)' = $hash
            'Owner (name/sid)'  = $File.Owner
            Length              = $File.Length
            LastAccessTime      = $File.LastAccessTime
            LastWriteTime       = $File.LastWriteTime
            Attributes          = $File.Attributes
            Stream              = $Stream
        }

        # Optionally show progress
        # Write-Progress -Activity "Collecting information for File: $($File.Name)" -Status "File $i of $($Files.Count)" -PercentComplete (($i / $Files.Count) * 100)
        $i++
    }

    # Check if there are results
    if ($results.Count -eq 0) {
        Write-Host "No files with alternate data streams found in the selected directory." -ForegroundColor Yellow
    } else {
        # Show results in a table
        $results | Out-GridView -Title "Alternate Data Streams (ADS) Scan Results"
    }

    [gc]::Collect()  # Memory cleanup
}

# Execute the folder scan (added optional parameter)
Scan-Folder
