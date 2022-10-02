$target = "mail.local"
$checkdns = Resolve-DnsName $target -ErrorAction SilentlyContinue
$webtest1 = "0"
$webtest2 = "0"

if($checkdns){
Write-host "Running autodiscover test..." -ForegroundColor Cyan
try
{
$webtest1 = Invoke-WebRequest -uri "https://$target/autodiscover" -Verbose -DisableKeepAlive
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
$webtest2 = invoke-webrequest -uri "https://$target/autodiscover/autodiscover.json?scanner4329@pwnstar.local/owa/&Email=autodiscover/autodiscover.json?b@small.local&Protocol=HACKER&Protocol=PowerShell" -Verbose -DisableKeepAlive
}
catch
{
    write-host "Caught" -ForegroundColor Red
    $failure.StatusCode
    if($failure.StatusCode -contains "BadGateway"){write-host "Mitigation Detected" -ForegroundColor Green}
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
    write-host "Connected to Server with HTTP 200 Response..." -ForegroundColor Green
    if($webtest2.RawContent.ToString() -like "*Powershell*")
            {
            write-host "Poentially vulnerable to CVE-2022-40140 & CVE-2022-41082" -ForegroundColor Red
            }
        }

}
else
{
write-host "DNS does not resolve" -ForegroundColor Red
}

if(Get-Variable webtest1 -ErrorAction SilentlyContinue){Clear-Variable webtest1}
if(Get-Variable webtest2 -ErrorAction SilentlyContinue){Clear-Variable webtest2}
