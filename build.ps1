param([switch]$Force)

if (-not (Get-Command choco)) {
    throw "choco not found, install from https://chocolatey.org/install"
}

# Download fresh rustup-init.exe
# and make sure we can do it over existing file
$url = 'http://win.rustup.rs/'
$package = "$pwd\rustup-init.exe"
if (Test-Path $package) {
    if ($Force) {
        Write-Warning "Removing old rustup-init.exe"
        Remove-Item $package
    } else {
        Write-Warning "Skip rustup-init.exe downloading, because it's already present"
    }   
}
(New-Object System.Net.WebClient).DownloadFile($url, $package)

# version is output in form of
# rustup-init 1.11.0 (e751ff9f8 2018-02-13)
$versionStr = & "$pwd\rustup-init.exe" --version
$matchResult = $versionStr -match 'rustup-init ([\d\.]+) '
if (-not $matchResult) {
    throw "Unexpected rustup-init.exe --version output: $versionStr" 
}

$version = $matches[1]
choco pack --version $version rustup.nuspec
