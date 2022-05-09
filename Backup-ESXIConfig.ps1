function Backup-ESXIConfig {
    # Get the ESXI Hosts IP, the username, password, and path to save the backup to
    $EsxiHostIP = Read-Host -Prompt "Input the ESXI Host IP"
    $Username = Read-Host -Prompt "Input the Username for the ESXI machine"
    $Password = Read-Host -Prompt "Input the Password for the ESXI machine"
    $BackupPath = Read-Host -Prompt "Input the Path to backup the configuration to (Ex. C:\Users\Henry\Documents)"

    # Build out the credentials
    $SecureStringPassword = ConvertTo-SecureString -String "$Password" -AsPlainText -Force
    $PsCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPassword

    # Get InvalidCertificateAction Value
    $InvalidCertActionData = Get-PowerCLIConfiguration | Where-Object -Property Scope -eq "Session" | Select-Object InvalidCertificateAction

    # Evaluate if we ignore bad Certificates, set to ignore in session scope if not alredy
    if ($InvalidCertActionData.InvalidCertificateAction -ne "Ignore") {
        Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
    }

    # Connect via PowerCLI to ESXI Host
    Connect-VIServer -Server $EsxiHostIP -Credential $PsCredential 

    # Backup the configuration the Path specified earlier
    Get-VMHostFirmware -VMHost $EsxiHostIP -BackupConfiguration -DestinationPath $BackupPath
}

Backup-ESXIConfig

