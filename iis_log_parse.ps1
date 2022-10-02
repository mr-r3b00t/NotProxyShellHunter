
Function Out-GridViewIISLog ($File) { 
   #.Synopsis - Thanks to this dude - https://www.catapultsystems.com/blogs/easy-iis-log-reading-with-powershell/

$Headers = @((Get-Content -Path $File -ReadCount 4 -TotalCount 4)[3].split(' ') | Where-Object { $_ -ne '#Fields:' });
   Import-Csv -Delimiter ' ' -Header $Headers -Path $File | Where-Object { $_.date -notlike '#*' } | Out-GridView -Title "IIS log: $File";
};

$logs = get-childitem -path "C:\inetpub\logs\LogFiles" -Recurse -Filter *.log | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-30)}
foreach($log in $logs){

$logdata = $log | Get-Content 

if($logdata -match 'autodiscover.*powershell')
{
write-host "Detected possible IOC in: " $log.FullName -ForegroundColor Yellow
write-host "IOC located, please investigate" -ForegroundColor Red
sleep -Seconds 5
#$matches = $logdata -match 'autodiscover.*powershell'
#write-host $matches -ForegroundColor Gray

Out-GridViewIISLog -File $log.FullName


}


}
