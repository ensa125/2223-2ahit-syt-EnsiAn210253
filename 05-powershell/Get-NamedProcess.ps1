<#
.Synopsis
   We want to list all processes with a given name
.DESCRIPTION
   more text...
.EXAMPLE
   Get-NamedProcess -Name powershell -Foo "some text"
#>
function Get-NamedProcess {
    [CmdletBinding()]
    param (
        [string]$Name,
        [string]$Foo
    )

    Write-Host $Foo

    Get-Process -Name $Name
}