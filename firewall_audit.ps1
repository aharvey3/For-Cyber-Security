# firewall_audit.ps1
# Lists all inbound rules allowing TCP ports > 1024 (potential backdoors)

Get-NetFirewallRule -Direction Inbound -Action Allow | 
    Where-Object { $_.Enabled -eq $true } | 
    Get-NetFirewallPortFilter | 
    Where-Object { $_.Protocol -eq "TCP" -and $_.LocalPort -gt 1024 } | 
    Select-Object -Property LocalPort, Protocol, 
        @{Name="RuleName";Expression={(Get-NetFirewallRule -PortFilter $_).Name}} |
    Export-Csv -Path "C:\Audits\open_high_ports.csv" -NoTypeInformation

Write-Host "Report saved to C:\Audits\open_high_ports.csv"
