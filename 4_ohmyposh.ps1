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
# install OhMyPosh & theme for powershell & git bash
# theme based on: https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/powerlevel10k_rainbow.omp.json
# ---------------------------------------
winget install -e --id JanDeDobbeleer.OhMyPosh --accept-source-agreements --accept-package-agreements --silent
Start-Sleep -Seconds 1.5

# enable PowerShell profile running
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

$themeFile = "powerlevel10k_rainbow.omp.json" 
$documentsFolder = [Environment]::GetFolderPath("MyDocuments")

# oh-my-posh init powershell --config "C:\Users\user\Documents\powerlevel10k_rainbow.omp.json" | Invoke-Expression
$psConfig = ";oh-my-posh init powershell --config ""$documentsFolder\$themeFile"" | Invoke-Expression;"
Copy-Item $themeFile -Destination $documentsFolder -Force
New-Item "$documentsFolder\WindowsPowerShell" -itemType Directory -Force
$psConfig | Out-File -FilePath $documentsFolder\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -Force

# eval "$(oh-my-posh --init --shell bash --config 'C:\Users\user\Documents\theme.json')"
$bashConfig = ";clear;eval {0}{1}{2}" -f '"$(oh-my-posh --init --shell bash --config "', "$documentsFolder\$themeFile", '")";'
$bashConfig | Out-File -FilePath "$env:USERPROFILE\.bashrc" -Force

# install NerdFont
# !REPLACE YOUR TERMINAL FONT MANUALLY AFTER INSTALLATION
oh-my-posh font install