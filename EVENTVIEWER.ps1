$EventIDs = @(3079, 1102, 7, 7036, 7045, 1001, 1002, 104, 1074, 4663, 7036, 4688, 4660, 4616)
$EventLogs = @("Application", "System", "Security", "Windows PowerShell", "Windows PowerShell Operational", "Setup", "ForwardedEvents", "Internet Explorer")
$Results = @()
foreach ($EventLog in $EventLogs) {
$Events = foreach ($EventID in $EventIDs) {
Get-EventLog -LogName $EventLog -InstanceId $EventID -Newest 3
     }
     $Results += $Events
 }
$Results | out-gridview
