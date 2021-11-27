param (
    [Parameter(HelpMessage="Splunk agent version")]
    [string]$agent_version = "na",
    
    [Parameter(HelpMessage="Splunk platform Windows or Linux")]
    [string]$platform = "na",

    [Parameter(HelpMessage="Splunk architecture type")]
    [string]$arch = "na",

    [Parameter(HelpMessage="Download binary to local machine")]
    [switch]$download,

    [Parameter(HelpMessage="Install splunk agent")]
    [switch]$install,

    [Parameter(HelpMessage="Splunk binary full path")]
    [string]$binary = "na",

    [Parameter(HelpMessage="Splunk deployment server")]
    [string]$ds = "na",

    [Parameter(HelpMessage="Install directory for splunk agent")]
    [string]$install_dir = "na"
 )

function Download-Splunk-Agent {
    param ($agent_version, $platform, $arch)
    $arch_array = @()
    $version_array = @()
    $direct_download_url = $false
    $old_url = 'https://www.splunk.com/en_us/download/previous-releases/universalforwarder.html'
    $new_url = 'https://www.splunk.com/en_us/download/universal-forwarder.html'
    $ProgressPreference = 'SilentlyContinue'
    $request = ((Invoke-WebRequest -Uri $old_url -UseBasicParsing).Links | Where-Object {$_.'data-filename' -like “*splunkforwarder-*”})

    if ($agent_version -eq "na") {
        foreach ($line in $request) {
            if (-not ($version_array -contains $line.'data-version')) {
                $version_array += $line.'data-version'
            }
        }

        $version_array = $version_array -join " | "
        $input_version = Read-Host "Enter agent version from the list: `n$version_array"
        $input_version = $input_version.Trim()
    }
    else {
        $input_version = $agent_version
    }

    if ($platform -eq "na") {
        $input_platform = Read-Host "Windows or Linux"
        $input_platform = $input_platform.Trim()

        if (($input_platform -like "windows")) {
            $input_platform = "windows"
        }

        if (($input_platform -like "nix")) {
            $input_platform = "linux"
        }
    }
    else {
        $input_platform = $platform
    }

    if ($arch -eq "na") {
        foreach ($line in $request) {
            if (-not ($arch_array -contains $line.'data-arch') -and ($line.'data-platform' -like "$input_platform") -and ($line.'data-version' -like "$input_version")) {
            $arch_array += $line.'data-arch'
            }
        }
        $arch_array = $arch_array -join " | "
        $input_arch = Read-Host "Choose architecture type from list: `n$arch_array"
    }
    else {
        $input_arch = $arch
    }


    # Find download link
    foreach ($line in $request) {
        if(($line.'data-version' -like "$input_version") -and ($line.'data-arch' -like "$input_arch") -and ($line.'data-platform' -like "$input_platform")) {
            Write-Host $line.'data-link'
            $direct_download_url = $line.'data-link'
        }
    }

    # Download binaries
    if ($direct_download_url -ne $false) {
        $binary = $direct_download_url.Split("/")
        $location = "$HOME\Downloads\" + $binary[8]
    
        $download = Invoke-WebRequest -Uri $direct_download_url -UseBasicParsing -OutFile $location
        Write-Host "Successfully downloaded" $binary[8] "in" $location
    }
    else {
        Write-Host "No packages found with given criteria"
    }

    return $binary[8], $location
}


function Install-Splunk-Agent {
    param ($ds, $install_dir, $binary)
    $install_dir = "C:\Program Files\SplunkUniversalForwarder"
    $log = "$env:TEMP\splunk-agent.log"
    Start-Process -Wait -Verb RunAs -FilePath "msiexec.exe" -ArgumentList "/L $log /i $binary DEPLOYMENT_SERVER=$ds AGREETOLICENSE=Yes GENRANDOMPASSWORD=1 /quiet"
}

# Main

if ($download -and -not ($install)) {
    Write-Host "Downloading"
    Download-Splunk-Agent $agent_version $platform $arch  
}

if ($install -and ($binary -ne "na")) {
    Install-Splunk-Agent $ds $install_dir $binary
    Write-Host "Agent successfully installed"
    Write-Host "Log output written to $env:TEMP\splunk-agent.log"
}

if ($download -and $install) {
    Write-Host "Downloading and Installing"
    $binary, $location = Download-Splunk-Agent $agent_version $platform $arch
    Write-Host "Attempting to install agent"
    Install-Splunk-Agent $ds $install_dir $location
    Write-Host "Agent successfully installed"
    Write-Host "Log output written to $env:TEMP\splunk-agent.log"
}