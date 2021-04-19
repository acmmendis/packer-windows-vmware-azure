$packerWindowsDir = 'C:\Windows\packer'
New-Item -Path $packerWindowsDir -ItemType Directory -Force

$Passwd = -join ((48..122) | Get-Random -Count 16 | ForEach-Object{[char]$_})
$PasswdSecStr = ConvertTo-SecureString $passwd -AsPlainText -Force

# final shutdown command
$shutdownCmd = @"
Set-LocalUser $env:WinRMUser -PasswordNeverExpires 0 -UserMayChangePassword 1
shutdown /s /t 10 /f /d p:4:1
"@

Set-Content -Path "$($packerWindowsDir)\PackerShutdown.bat" -Value $shutdownCmd