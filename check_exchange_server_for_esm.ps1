Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn; 

Get-OrganizationConfig | Select-Object MitigationsEnabled

#Set-OrganizationConfig -MitigationsEnabled $false
#Set-OrganizationConfig -MitigationsEnabled $true

GCM exsetup |%{$_.Fileversioninfo}

. "C:\Program Files\Microsoft\Exchange Server\V15\Scripts\Test-MitigationServiceConnectivity.ps1"
