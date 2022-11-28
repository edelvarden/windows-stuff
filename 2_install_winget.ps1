# ---------------------------------------
# install winget
# ---------------------------------------
$localPackages = @(
    "Microsoft.VCLibs.x64.14.00.Desktop.appx"   # source: https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
    "Microsoft.UI.Xaml.2.7.appx"                # source: https://www.nuget.org/packages/Microsoft.UI.Xaml/2.7.0
)
foreach ($package in $localPackages) {
    Write-Output "Install local package $package"
    Add-AppxPackage -path ".\packages\$package" -ForceUpdateFromAnyVersion
}

# source: https://github.com/microsoft/winget-cli/releases/
Add-AppxProvisionedPackage -Online -PackagePath ".\packages\Microsoft.DesktopAppInstaller.msixbundle" -LicensePath ".\packages\Microsoft.DesktopAppInstaller_License.xml"

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