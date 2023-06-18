$psversiontable
Get-Service | 
    Where-Object { $_.Status -eq "Running" -and $_.DisplayName -like "Windows*"} |
    Select-Object -First 10

#ping

1..3 | ForEach-Object {Test-Connection 127.0.0.$_ -Count 1}