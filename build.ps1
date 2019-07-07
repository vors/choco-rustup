if (-not (Get-Command choco)) {
    throw "choco not found, install from https://chocolatey.org/install"
}

# Download fresh rustup-init.exe
$url = 'http://win.rustup.rs/'
$package = "$pwd\rustup-init.exe"
(New-Object System.Net.WebClient).DownloadFile($url, $package)

$licenseUrl = 'https://raw.githubusercontent.com/rust-lang/rustup.rs/master/LICENSE-MIT'
$licensePath = "$pwd\LICENSE.tmp"
(New-Object System.Net.WebClient).DownloadFile($licenseUrl, $licensePath)

$licenseText = Get-Content -Raw $licensePath
@"
From: $licenseUrl

LICENSE

$licenseText
"@ > "$pwd\LICENSE.txt"

# version is output in form of
# rustup-init 1.11.0 (e751ff9f8 2018-02-13)
$versionStr = & "$pwd\rustup-init.exe" --version
$matchResult = $versionStr -match 'rustup-init ([\d\.]+) '
if (-not $matchResult) {
    throw "Unexpected rustup-init.exe --version output: $versionStr" 
}

$version = $matches[1]
choco pack --version $version rustup.nuspec
