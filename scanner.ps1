$target = "mail.local"
try
{
$webtest = Invoke-WebRequest -uri "https://$target/autodiscover"
}
catch
{
Write-Host $_.ErrorDetails.Message;
$Failure = $_.Exception.Response
$Failure.Headers.tostring()
}

try
{
$webtest = invoke-webrequest -uri "https://$target/autodiscover/autodiscover.json?scanner4329@pwnstar.local/owa/&Email=autodiscover/autodiscover.json?a@foo.var&Protocol=XYZ&FooProtocol=Powershell"
}
catch
{
$Failure = $_.Exception.Response
$Failure.Headers.tostring()
$Failure.Headers.tostring() | findstr /I "X-OWA-Version"
$Failure.Headers.tostring() | findstr /I "X-FEServer"
if($Failure.Headers -contains "X-FEServer")
{
write-host "Poentially vulnerable to CVE-2022-40140 & CVE-2022-41082" -ForegroundColor Red
}


}
