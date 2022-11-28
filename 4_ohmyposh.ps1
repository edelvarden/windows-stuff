# ---------------------------------------
# install OhMyPosh & theme for powershell & git bash
# theme based on: https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/powerlevel10k_rainbow.omp.json
# ---------------------------------------
winget install JanDeDobbeleer.OhMyPosh

# install NerdFont
oh-my-posh font install

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