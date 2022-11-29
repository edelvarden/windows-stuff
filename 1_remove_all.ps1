Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
#param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))  | out-null
    }
    exit
}
'Running with full privileges'
# ---------------------------------------
# Remove all packages
# ---------------------------------------
Get-AppxPackage | Remove-AppxPackage
#Get-AppxPackage | Out-GridView -PassThru | Remove-AppxPackage
#Get-AppxPackage -AllUsers | Where-Object {$_.name -NotLike "*store*"} | Remove-AppxPackage