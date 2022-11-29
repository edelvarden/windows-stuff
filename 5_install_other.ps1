$wingetPackages = @(

    # Libs
    "Microsoft.DirectX"
    "Microsoft.VCRedist.2013.x86"
    "Microsoft.VCRedist.2013.x64"
    "Microsoft.VCRedist.2015+.x86"
    "Microsoft.VCRedist.2015+.x64"

    # Tools
    "7zip.7zip"
    "qBittorrent.qBittorrent"
    "OpenVPNTechnologies.OpenVPN"
    #"Microsoft.PowerToys"

    # Social & Network
    "Google.Chrome"
    #Mozilla.Firefox.DeveloperEdition
    "Telegram.TelegramDesktop"
    #"Zoom.Zoom"
    #"Discord.Discord"
    #"Valve.Steam"

    # Dev
    "Git.Git"
    "Microsoft.VisualStudioCode"
    "OpenJS.NodeJS"
    "Python.Python.3.10"
    #"Docker.DockerDesktop"
    #"Canonical.Ubuntu"
    #"Debian.Debian"
    #"VMware.WorkstationPlayer"

    # Office
    #"Microsoft.Office"
)

foreach ($package in $wingetPackages)
{
  winget install -e --id $package --accept-source-agreements --accept-package-agreements --silent
}