Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}
clear
'running with full privileges'
# ---------------------------------------
# install winget
# ---------------------------------------
# source: https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
#Add-AppxPackage -path ".\packages\Microsoft.VCLibs.x64.14.00.Desktop.appx" -ForceUpdateFromAnyVersion

# source: https://www.nuget.org/packages/Microsoft.UI.Xaml/2.7.0
#Add-AppxPackage -path ".\packages\Microsoft.UI.Xaml.2.7.appx" -ForceUpdateFromAnyVersion

# source: https://github.com/microsoft/winget-cli/releases/
#Add-AppxProvisionedPackage -Online -PackagePath ".\packages\Microsoft.DesktopAppInstaller.msixbundle" -LicensePath ".\packages\Microsoft.DesktopAppInstaller_License.xml"

#
#
#
$VCLibs             = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
$MicrosoftUIXaml    = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.0"
$winget             = "https://api.github.com/repos/microsoft/winget-cli/releases"

function InstallMicrosoftUIXaml()
{
    param ($URL)

    Write-Output "Install Microsoft.UI.Xaml 2.7.0"

    $Path = "{0}\{1}" -f $env:temp, "Microsoft.UI.Xaml2.7.0"
    # Downloading Microsoft.UI.Xaml 2.7.0 to $Path
    (New-Object System.Net.WebClient).DownloadFile($URL, "$Path.zip")

    # Unziping Microsoft.UI.Xaml 2.7.0
    Expand-Archive "$Path.zip" -DestinationPath "$Path"

    # Install Microsoft.UI.Xaml 2.7.0
    Add-AppxPackage "$Path\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx" -ForceUpdateFromAnyVersion

    # Remove temp files
    Remove-Item "$Path.zip" -Force
    Remove-Item "$Path" -Recurse -Force
}

function InstallAppInstaller()
{
    param ($uri)

    # download & get file
    function GetFile()
    {
        param ($fileMatch, $source)
        $msixbundle = $source[0].assets | Where-Object name -Match $fileMatch
        $downloadLink = $msixbundle.browser_download_url
        $destFile = Join-Path -path $env:temp -ChildPath $msixbundle.name
        (New-Object System.Net.WebClient).DownloadFile($downloadLink, $destFile)
        return $destFile
    }

    Write-Output "Install AppInstaller (winget)"

    $source = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop
    $msixbundle = GetFile '.msixbundle' $source
    $license    = GetFile 'License1.xml' $source

    # Install AppInstaller (winget)
    Add-AppxProvisionedPackage -Online -PackagePath $msixbundle -LicensePath $license

    # Remove temp files
    Remove-Item $msixbundle -Force
    Remove-Item $license -Force
}

# 
Write-Output "Install VCLibs"
Add-AppxPackage         $VCLibs -ForceUpdateFromAnyVersion
InstallMicrosoftUIXaml  $MicrosoftUIXaml
InstallAppInstaller     $winget

Start-Sleep -Seconds 1.5

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
    winget install $package -s msstore --accept-source-agreements --accept-package-agreements --silent
}