$urltoCheck= Read-Host "Enter URL for ITOMserverURL/ITAM/ to verify credentials`n `nexample: https://ifs-itom.saas.axiossystems.com/ITAM/ `n`nYour URL:"

Write-Host "`nEnter Credentials configured when prompted (user will be $UserNameDefined)`n"



$cred = Get-Credential $UserNameDefined

#Not handling errors as they are helpful for the user to understand why it failed, e.g incorrect auth or not reachable.

try{
	
	Invoke-WebRequest $urltoCheck -Credential $cred
	Read-Host "Successful, was able to log in to the ITAM Api with your new credentials, press enter to exit."

	
	
}

catch {
	
	Read-Host "error encountered, please confirm manually in a browser."
}