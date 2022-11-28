# ---------------------------------------
# install WindowsTerminal
# source: https://github.com/microsoft/terminal/releases/
# ---------------------------------------
$winver = Get-WMIObject win32_operatingsystem | select Caption

if($winver -like "*Windows 11*" ){
    Add-AppxPackage -path ".\packages\Microsoft.WindowsTerminal_Win11.msixbundle" -ForceUpdateFromAnyVersion
}
elseif($winver -like "*Windows 10*" ) {
    Add-AppxPackage -path ".\packages\Microsoft.WindowsTerminal_Win10.msixbundle" -ForceUpdateFromAnyVersion
}
else {
    Write-Output "$winver not support"
}