powershell
# Lab 08 - Gathering Windows Event Logs
# Commands executed during lab (sequential, no explanations)

mkdir C:\Temp
cd C:\Temp
Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.13.4-windows-x86_64.zip" -OutFile "winlogbeat.zip"

Expand-Archive .\winlogbeat.zip -DestinationPath "C:\Program Files\Winlogbeat" -Force
Get-ChildItem "C:\Program Files\Winlogbeat" | Select-Object -First 10

Move-Item "C:\Program Files\Winlogbeat\winlogbeat-8.13.4-windows-x86_64\*" "C:\Program Files\Winlogbeat\" -Force
Remove-Item "C:\Program Files\Winlogbeat\winlogbeat-8.13.4-windows-x86_64" -Recurse -Force

cd 'C:\Program Files\Winlogbeat'
.\install-service-winlogbeat.ps1

notepad .\winlogbeat.yml
Select-String -Path .\winlogbeat.yml -Pattern "winlogbeat.event_logs" -Context 0,6

Start-Service winlogbeat
Get-Service winlogbeat
Restart-Service winlogbeat

Get-EventLog -LogName Application -Newest 5
Get-ChildItem .\logs | Select-Object -First 5

Select-String -Path .\winlogbeat.yml -Pattern "output\." -Context 0,6
