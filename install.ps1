# ---------------------------------------
# Remove all packages
# ---------------------------------------
Get-AppxPackage | Remove-AppxPackage
#Get-AppxPackage | Out-GridView -PassThru | Remove-AppxPackage
#Get-AppxPackage -AllUsers | Where-Object {$_.name -NotLike "*store*"} | Remove-AppxPackage

# ---------------------------------------
# install winget
# ---------------------------------------
$localPackages = @(
    "Microsoft.VCLibs.x64.14.00.Desktop.appx"   # source: https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
    "Microsoft.UI.Xaml.2.7.appx"                # source: https://www.nuget.org/packages/Microsoft.UI.Xaml/2.7.0
    "Microsoft.DesktopAppInstaller.msixbundle"  # source: https://github.com/microsoft/winget-cli/releases/
    "Microsoft.WebpImageExtension.appx"
)
foreach ($package in $localPackages) {
    Write-Output "Install local package $package"
    Add-AppxPackage -path ".\packages\$package" -ForceUpdateFromAnyVersion
}

# ---------------------------------------
# install & update from MS Store 
# sourse: https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1
# ---------------------------------------
$msstorePackages = @(
    "9NBLGGH4NNS1" # AppInstaller
    "9PG2DK419DRG" # WebpImageExtension
)
foreach ($package in $msstorePackages) {
    Write-Output "Install MS Store package $package";
    winget install $package -s msstore --accept-package-agreements --silent
}

# ---------------------------------------
# install WindowsTerminal
# source: https://github.com/microsoft/terminal/releases/
# ---------------------------------------
$winver = Get-WMIObject win32_operatingsystem | select Caption

if($winver -like "*Windows 11*" ){
    Add-AppxPackage -path .\Microsoft.WindowsTerminal_Win11.msixbundle -ForceUpdateFromAnyVersion
}
elseif($winver -like "*Windows 10*" ) {
    Add-AppxPackage -path .\Microsoft.WindowsTerminal_Win10.msixbundle -ForceUpdateFromAnyVersion
}
else {
    Write-Output "$winver not support"
}

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
