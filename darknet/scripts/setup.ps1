#!/usr/bin/env pwsh

param (
  [switch]$InstallCUDA = $false
)

Import-Module -Name $PSScriptRoot/utils.psm1 -Force

if ($null -eq (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
  # Download and install Chocolatey
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  Throw "Please close and re-open powershell and then re-run setup.ps1 script"
}

Start-Process -FilePath "choco" -Verb runAs -ArgumentList " install -y cmake ninja powershell git vscode"
Start-Process -FilePath "choco" -Verb runAs -ArgumentList " install -y visualstudio2022buildtools --package-parameters `"--add Microsoft.VisualStudio.Component.VC.CoreBuildTools --includeRecommended --includeOptional --passive --locale en-US --lang en-US`""
Push-Location $PSScriptRoot

if ($InstallCUDA) {
  & $PSScriptRoot/deploy-cuda.ps1
  $env:CUDA_PATH = "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v${cuda_version_short}"
  $env:CUDA_TOOLKIT_ROOT_DIR = "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v${cuda_version_short}"
  $env:CUDACXX = "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v${cuda_version_short}\\bin\\nvcc.exe"
  $CUDAisAvailable = $true
}
else {
  if (-not $null -eq $env:CUDA_PATH) {
    $CUDAisAvailable = $true
  }
  else{
    $CUDAisAvailable = $false
  }
}

if ($CUDAisAvailable) {
  & $PSScriptRoot/../build.ps1 -UseVCPKG -ForceLocalVCPKG -EnableOPENCV -EnableCUDA -DisableInteractive -DoNotUpdateTOOL
  #& $PSScriptRoot/../build.ps1 -UseVCPKG -EnableOPENCV -EnableCUDA -EnableOPENCV_CUDA  -DisableInteractive -DoNotUpdateTOOL
}
else {
  & $PSScriptRoot/../build.ps1 -UseVCPKG -EnableOPENCV -DisableInteractive -DoNotUpdateTOOL
}
