# Input your list of IP's to test here
$ips = Get-content C:\temp\ips.txt

# Test IP Connectivity
foreach ($ip in $ips) {
    
    $testip = Test-NetConnection -ComputerName $ip -port 80
    $testiphttps = Test-NetConnection -ComputerName $ip -port 443

    if ($testip.TcpTestSucceeded -eq $true) {
        Write-Host -ForegroundColor "Green" "Connected to $ip on port 80"
    }
    elseif ($testip.TcpTestSucceeded -eq $false)
    {
        Write-Host -ForegroundColor "Red" "Cannot connect to $ip on port 80"
    }

    if ($testiphttps.TcpTestSucceeded -eq $true) {
        Write-Host -ForegroundColor "Green" "Connected to $ip on port 443"
    }
    elseif ($testiphttps.TcpTestSucceeded -eq $false)
    {
        Write-Host -ForegroundColor "Red" "Cannot connect to $ip on port 443"
    }
}
