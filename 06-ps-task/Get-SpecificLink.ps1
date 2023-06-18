Import-Module PSLogging
<#
.Synopsis
    We want to find asp, htm or html links on certain websites 
.DESCRIPTION
    It is searching for asp, htm or html links on the given website and creates a log file where all the found links and errors go.
.EXAMPLE
    Get-SpecificLink -Uri "https://example.com" -LogFileNamePath "C:\Users\ExampleUser\Logs\Example.log" -LinkFileFormat "html"
#>
function Get-SpecificLink{
    [CmdletBinding()]
     Param (
         # link of the website
         [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
         [string]$Uri,
         
        # Path and name of the log file
        [string]$LogFileNamePath,

        # which file format of links should be found
        [string]$LinkFileFormat 
    )
    
    Process {
        try {
            $FileName = Split-Path -Path $LogFileNamePath -Leaf
            $LogFilePath = Split-Path -Path $LogFileNamePath
            $filteredLinks = @()

            Start-Log -LogPath $LogFilePath -LogName $FileName -ScriptVersion “1.0”

            Write-LogInfo -LogPath $LogFileNamePath -Message "Sending WebRequest..."
            $Response = Invoke-WebRequest -Uri $Uri -UseBasicParsing
            Write-LogInfo -LogPath $LogFileNamePath -Message "Successful!"

            $Links = ($Response).Links.href
            
            Write-LogInfo -LogPath $LogFileNamePath -Message "Searching for $LinkFileFormat links on the web page..."
            if ($LinkFileFormat -eq "asp" -or $LinkFileFormat -eq "htm" -or $LinkFileFormat -eq "html"){
                $filteredLinks = $Links | Where-Object { $Links -match '\.(' + $LinkFileFormat + ')$' }
                if($null -eq $filteredLinks){
                    Write-LogInfo -LogPath $LogFileNamePath -Message "Found no $LinkFileFormat links"
                } else {
                    foreach ($link in $filteredLinks){
                        Write-LogInfo -LogPath $LogFileNamePath -Message "Valid link: $link"
                    }
                }
            } else{
                Write-LogError -LogPath $LogFileNamePath -Message "Invalid Input for LinkFileFormat, Input: $LinkFileFormat"
            }
        }
        catch {
            Write-LogError -LogPath $LogFileNamePath -Message $_.Exception.Message
        }
        Stop-Log -LogPath $LogFileNamePath
    }
}