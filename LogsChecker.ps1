        # Skidded by Quickpots
function Print-AnimatedLogo {
    Clear-Host

    $padding = " " * 10
    Write-Host -NoNewline ($padding)
    Write-Host -ForegroundColor Cyan @"
                              
                                       QUICKPOTS SS TOOL

"@
    Start-Sleep -Milliseconds 500
}

# hi
function Print-Menu {
    Clear-Host
    Print-AnimatedLogo
    Write-Host ""
    Write-Host ""
    Write-Host "                                            ------------------------------"
    Write-Host "                                                       LOGS TOOL          " 
    Write-Host "                                            ------------------------------"
    Write-Host ""  
    Write-Host "                                                  Client logs       [1]"
    Write-Host "                                                  Deleted Files     [2]"
    Write-Host "                                                  Account Files     [3]"
    Write-Host "                                                  Install WinRaR    [4]"
    Read-Host "                                                                        "
} 

while ($true) {
    $choice = Print-Menu

    switch ($choice) {
        "1" {
            Clear-Host
            Write-Host "Looking For Logs..."
            Start-Process -FilePath "$env:APPDATA\.minecraft\logs"
            Start-Process -FilePath "$env:APPDATA\.minecraft\logs\blclient\minecraft\" -ErrorAction SilentlyContinue
            Start-Process -FilePath "$env:USERPROFILE\.lunarclient\offline\1.8\logs" -ErrorAction SilentlyContinue
            Start-Process -FilePath "$env:USERPROFILE\.lunarclient\offline\multiver\logs" -ErrorAction SilentlyContinue
            Pause
        }
        "2" {
            Clear-Host
            Write-Host "looking for deleted logs..."
            Set-Location C:\
            fsutil usn readjournal C: csv | findstr /i /C:"0x80000200" | findstr /i /C:"latest.log" /i /C:".log.gz" /i /C:"launcher_profiles.json" /i /C:"usernamecache.json" /i /C:"usercache.json" /i /C:"shig.inima" /i /C:”launcher_accounts.json” > logs.txt
            Start-Process -FilePath "notepad.exe" -ArgumentList "logs.txt"
            Pause
        }
        "3" {
            Clear-Host
            Write-Host "looking for the files..."
            Clear-Host
            cd $env:APPDATA\.minecraft
            Rename-Item -Path ".\usernamecache.json" -NewName "usernamecache.txt"
            Rename-Item -Path ".\usercache.json" -NewName "usercache.txt"
            Rename-Item -Path ".\launcher_accounts.json" -NewName "launcher_accounts.txt"
            Rename-Item -Path ".\launcher_profiles.json" -NewName "launcher_profiles.txt"
            Rename-Item -Path ".\tlaucherprofiles.json" -NewName "tlaucherprofi2les.txt"
            Start-Process -FilePath "usercache.txt"
            Start-Process -FilePath "launcher_accounts.txt"
            Start-Process -FilePath "launcher_profiles.txt"
            Start-Process -FilePath "tlaucherprofiles.txt"
            Rename-Item -Path ".\usernamecache.txt" -NewName "usernamecache.json"
            Rename-Item -Path ".\usercache.txt" -NewName "usercache.json"
            Rename-Item -Path ".\launcher_accounts.txt" -NewName "launcher_accounts.json"
            Rename-Item -Path ".\launcher_profiles.txt" -NewName "launcher_profiles.json"
            Rename-Item -Path ".\tlaucherprofiles.txt" -NewName "tlaucherprofiles.json"
            Pause
        }
        "4" {
            Clear-Host
            $installer = Read-Host "Do you want to download and install WinRAR? (Yes/No)"
            if ($installer -eq "Yes") {
                Write-Host "Sto scaricando WinRAR..."
                $url = 'https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-700it.exe'
                $output = "C:\Users\$env:USERNAME\Downloads\winrar-x64-700it.exe"
                (New-Object System.Net.WebClient).DownloadFile($url, $output)
                Write-Host "Download Complete"
                Start-Process -FilePath $output
                $confirmation = Read-Host "WinRAR è stato avviato correttamente, premi il tasto invio per andare avanti"
            } else {
                Write-Host "No other options are available as of now"
                Pause
            }
        }
    }
}
    
