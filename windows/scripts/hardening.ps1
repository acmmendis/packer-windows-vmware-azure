
Write-Host "##################################  OS Hardening to CIS Baseline  ##################################"
install-module AuditPolicyDSC -Force
install-module ComputerManagementDsc -Force
install-module SecurityPolicyDsc -Force
Set-Item -Path WSMan:\localhost\MaxEnvelopeSizeKb -Value 2048
set-location -Path 'C:\DSC'
$script='c:\DSC\CIS_WindowsServer.ps1'
&$script
Start-DscConfiguration -Path 'c:\DSC\CIS_WindowsServer'  -Force -Verbose -Wait
set-location -Path 'C:\'


Write-Host "#################################  Resetting Base Image & Features #################################"
try{
	Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
} catch {
	Write-Host "Unable to reset base. Should be ok if patches have been slipstreamed."
}

$moduleExist = Get-Module servermanager

if ($moduleExist){
	Write-Host 'Get-WindowsFeature | ? { $_.InstallState -eq "Available" } | Uninstall-WindowsFeature -Remove'
	Import-Module servermanager
	Get-WindowsFeature | Where-Object { $_.InstallState -eq 'Available' } | Uninstall-WindowsFeature -Remove
}

Write-Host "Removing temp folders and Adding Firewall rules"
$tempfolders = @("C:\DSC\*","C:\Windows\Prefetch\*", "C:\Documents and Settings\*\Local Settings\temp\*", "C:\Users\*\Appdata\Local\Temp\*")
Remove-Item $tempfolders -Force -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Remove-Item "c:\DSC\" -Force -Recurse -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f


Write-Host "####################################  Resetting Admin Accounts  ####################################"
$SecurePass = ConvertTo-SecureString $env:UserPass -AsPlainText -Force
New-LocalUser $env:LocalUser -Password $SecurePass -FullName "Packer Local Admin" -Description "Packer Windows Local Administrator"
Add-LocalGroupMember -Group "Administrators" -Member $env:LocalUser

#Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name '!DisableUser' -Value "c:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -command 'Remove-LocalUser -Name $env:WinRMUser'"
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name '!WinRMSetup' -Value "c:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe  -executionpolicy bypass -command 'winrm quickconfig -quiet; net stop winrm; net start winrm'"
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonSID" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -ErrorAction SilentlyContinue

Write-Host "##################################  Moulding Packer Golden Image  ##################################"
exit 0
