# "simple" function
Function Get-LargeFiles ($location = "C:\Windows", $length = 1MB, [switch]$Recurse = $False) 
{ 
  Get-ChildItem $location -Recurse:$Recurse | Where-Object {$_.length -ge $length} 
}
# call
Get-LargeFiles 
Get-LargeFiles –location $HOME
Get-LargeFiles –location $HOME -length 500MB -Recurse

# special info
(Get-Item Function:\Get-LargeFiles).Definition