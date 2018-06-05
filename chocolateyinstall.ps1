$ErrorActionPreference = 'Stop';

$packageName= 'rustup-init'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir "$packageName.exe"

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  file          = $fileLocation
  silentArgs    = "-y"
  validExitCodes= @(0)
  softwareName  = 'rustup-init*'
}

Install-ChocolateyInstallPackage @packageArgs
