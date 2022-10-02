#Check for webshells
get-childitem -path "C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\" -Recurse -Filter *.aspx | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-30)}

get-childitem -path "C:\inetpub\wwwroot" -Recurse -Filter *.aspx | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-30)}

get-childitem -path "C:\Users\All Users" -Recurse -Filter *.aspx | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-30)}

#Check for virtual directory abuse

[xml]$xmlElm = Get-Content -Path "C:\Windows\System32\inetsrv\Config\applicationHost.config"
$xmlElm.ChildNodes.location

