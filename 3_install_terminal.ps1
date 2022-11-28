# ---------------------------------------
# install WindowsTerminal
# source: https://github.com/microsoft/terminal/releases/
# ---------------------------------------
$uri = "https://api.github.com/repos/microsoft/terminal/releases"

# download & get file
function GetFile()
{
    param ($fileMatch, $source)
    $msixbundle = $source[0].assets | Where-Object name -like $fileMatch
    $downloadLink = $msixbundle.browser_download_url
    $destFile = Join-Path -path $env:temp -ChildPath $msixbundle.name
    (New-Object System.Net.WebClient).DownloadFile($downloadLink, $destFile)
    return $destFile
}

$source = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop
$windows11File = GetFile '*Win11*.msixbundle' $source
$windows10File = GetFile '*Win10*.msixbundle' $source

$winver = Get-WMIObject win32_operatingsystem | select Caption

if($winver -like "*Windows 11*" ){
    Add-AppxPackage "$windows11File" -ForceUpdateFromAnyVersion
} elseif($winver -like "*Windows 10*" ) {
    Add-AppxPackage "$windows10File" -ForceUpdateFromAnyVersion
} else {
    Write-Output "$winver not support"
}

# Remove temp files
Start-Sleep -Seconds 1.5
Remove-Item "$windows10File" -Force  | out-null
Remove-Item "$windows11File" -Force  | out-null