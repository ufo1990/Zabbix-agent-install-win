$path = "C:\Users\$env:username\Downloads"

#Download Zabbix agent
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest "https://cdn.zabbix.com/zabbix/binaries/stable/6.4/6.4.11/zabbix_agent2-6.4.11-windows-amd64-openssl.msi" -Outfile $path\zabbix_agent2-6.4.11-windows-amd64-openssl.msi

if(Test-Path $path\zabbix_agent2-6.4.11-windows-amd64-openssl.msi){ 
    
    Write-host "File was downloaded."

    Start-Sleep -Seconds 1

    try {   
        #Instalation and configuration Zabbix agent
        msiexec /I $path\zabbix_agent2-6.4.11-windows-amd64-openssl.msi server=127.0.0.1 HOSTNAME=$env:computername ENABLEPATH=1 /qn
    
        #Open port 10050 on firewall
        New-NetFirewallRule -DisplayName "Allow inbound port 10050" -Direction Inbound -Protocol TCP -Action Allow -LocalPort 10050

        Write-Host "Zabbix agent was installed and configured." 

    } catch {
        Write-Host "Error installed: $_"
    }    
 
    Start-Sleep -Seconds 3

    #Removing download file Zabbix agent after installed
    rm $path\zabbix_agent2-6.4.11-windows-amd64-openssl.msi

    if(-not(Test-Path $path\zabbix_agent2-6.4.11-windows-amd64-openssl.msi)){
       Write-host "File was removed."
    }
}