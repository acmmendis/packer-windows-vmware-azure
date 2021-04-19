Write-Host "###################  Packer - Patching Windows  ###################"
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

Install-PackageProvider -Name Nuget -Force
Import-PackageProvider -Name NuGet
Install-Module -Name PSWindowsUpdate -Force
Import-Module -Name PSWindowsUpdate
Get-WindowsUpdate -MicrosoftUpdate -NotCategory 'Drivers' -Install -AcceptAll -IgnoreReboot
Write-Host "###################  Packer - Windows Patching Done  ###################"