# ---------------------------------------
# Remove all packages
# ---------------------------------------
Get-AppxPackage | Remove-AppxPackage
#Get-AppxPackage | Out-GridView -PassThru | Remove-AppxPackage
#Get-AppxPackage -AllUsers | Where-Object {$_.name -NotLike "*store*"} | Remove-AppxPackage