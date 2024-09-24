Clear-Host

$folderPath = ".*"
$pattern = "User:"

Get-ChildItem $folderPath -recurse |
Select-String -pattern $pattern |
Select Path, Placeholder, LineNumber, Line, Pattern, Context, Matches |
Out-GridView


Clear-Host

$folderPath = ".*"
$pattern = "user:"

Get-ChildItem $folderPath -recurse |
Select-String -pattern $pattern |
Select Path, Placeholder, LineNumber, Line, Pattern, Context, Matches |
Out-GridView


Clear-Host

$folderPath = ".*.json"
$pattern = "name"

Get-ChildItem $folderPath -recurse |
Select-String -pattern $pattern |
Select Path, Placeholder, LineNumber, Line, Pattern, Context, Matches |
Out-GridView


Clear-Host

$folderPath = ".*.json"
$pattern = "Name"

Get-ChildItem $folderPath -recurse |
Select-String -pattern $pattern |
Select Path, Placeholder, LineNumber, Line, Pattern, Context, Matches |
Out-GridView