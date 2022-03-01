$urltoCheck= Read-Host "Enter URL for ITOMserverURL/SapphireWS to verify credentials`n `nexample: https://ifs-itom.saas.axiossystems.com/SapphireWS/ `n`nYour URL:"
$creds = Get-Credential "sapphire"

#Not handling errors as they are helpful for the user to understand why it failed, e.g incorrect auth or not reachable.

try{
	
	Invoke-WebRequest $urltoCheck -Credential $creds
	Read-Host "Successful, was able to log in to the ITOM Agent Webservice with your new credentials, press enter to exit."
	
	
	
}

catch {
	
	Read-Host "error encountered, please confirm manually in a browser."
}

