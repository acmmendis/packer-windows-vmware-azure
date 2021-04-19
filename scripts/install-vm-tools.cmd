@rem Silent mode, basic UI, no reboot
netsh interface ipv6 set interface "Local Area Connection" routerdiscovery=disabled
netsh interface teredo set state disable
netsh interface 6to4 set state disabled
netsh interface isatap set state disabled
e:\setup64 /s /v "/qb REBOOT=R"
shutdown /r /t 000