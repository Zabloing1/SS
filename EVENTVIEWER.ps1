Clear-Host
$host.UI.RawUI.WindowTitle = "Administrator: PowerShell - AutoEventVWR"
Write-Host "░█████╗░██╗░░░██╗████████╗░█████╗░  ███████╗██╗░░░██╗███████╗███╗░░██╗████████╗██╗░░░██╗░██╗░░░░░░░██╗██████╗░"
Write-Host "██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗  ██╔════╝██║░░░██║██╔════╝████╗░██║╚══██╔══╝██║░░░██║░██║░░██╗░░██║██╔══██╗"
Write-Host "███████║██║░░░██║░░░██║░░░██║░░██║  █████╗░░╚██╗░██╔╝█████╗░░██╔██╗██║░░░██║░░░╚██╗░██╔╝░╚██╗████╗██╔╝██████╔╝"
Write-Host "██╔══██║██║░░░██║░░░██║░░░██║░░██║  ██╔══╝░░░╚████╔╝░██╔══╝░░██║╚████║░░░██║░░░░╚████╔╝░░░████╔═████║░██╔══██╗"
Write-Host "██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝  ███████╗░░╚██╔╝░░███████╗██║░╚███║░░░██║░░░░░╚██╔╝░░░░╚██╔╝░╚██╔╝░██║░░██║"
Write-Host "╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░  ╚══════╝░░░╚═╝░░░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░░░░╚═╝░░░░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝"
Write-Host "Made by QuickPots"
$EventIDs = @(4616, 3079, 1102, 7036, 4663)
$EventLogs = @("Security", "Application", "Security", "Application", "Application", "Application")
$Results = @()
foreach ($EventLog in $EventLogs) {
$Events = foreach ($EventID in $EventIDs) {
Get-EventLog -LogName $EventLog -InstanceId $EventID -Newest 3
     }
     $Results += $Events
 }
$Results | out-gridview
