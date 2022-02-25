#Not getting java_home instead as it might not be set up for ITOM etc.+
#Getting ITOM path for JDK from the service SapphireIMS
$servicePathCheckITOM=Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\SapphireIMS -Name "ImagePath"
$itomPath= $servicePathCheckITOM.Imagepath.Replace("\ConsoleManagement\bin\SapphireIMS.exe","")
$itomPath=$itomPath.Trim("""");

#Setting re-used paths 
$itamWebPath=$itomPath+"\WebManagement\standalone\deployments\ITAM.war\WEB-INF\"
$itamWarPath=$itomPath+"\WebManagement\standalone\deployments\"
$itomAddUser=$itomPath+"\WebManagement\bin\"


#Ensuring that the script will always use an undedited version of the xml file to avoid issues when rerunning the script.


if (!(Test-Path -Path $pwd"\tmp")){

New-Item -ItemType Directory -Force -Path $pwd"\tmp"



}

Copy-Item "$pwd/sourceXML/web.xml" -Destination "$pwd\tmp\"
Copy-Item "$pwd/sourceXML/jboss-web.xml" -Destination "$pwd\tmp\"


Write-Host "`nCreating XML files, will require some information:`n"

$checkRequirement=0

while ($checkRequirement -eq 0){



$UserNameDefined=Read-Host "`nChoose a username (sapphire is reserved, can't be used)"

	if($UserNameDefined -ne "sapphire"){
		
		$checkRequirement++

	} 
	
	else {
		
		Write-Host "sapphire is not a valid username for this procedure"
		
	}




}


#Creating Group which follows format usernameAdmin
$UserRoleDefined=$UserNameDefined+"Admin"



$credToConvert = Read-host "`nEnter password" -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credToConvert)
$valuepwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
$ENCODED = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($valuepwd))


Write-Host "`nEncoded password is $encoded "



#Replacing lines 51 and 59 of the web.xml to include the correct user security Role. (positions are 1 less due to being array)

$filecontent = Get-Content -Path "$pwd\tmp\web.xml"
$filecontent[50] = $filecontent[50] -replace 'gatewayAdmin',$UserRoleDefined
$filecontent[58] = $filecontent[58] -replace 'gatewayAdmin',$UserRoleDefined
 
Set-Content -Path "$pwd\tmp\web.xml" -Value $filecontent


Write-Host "`nFiles configured with Username $UserNameDefined and group name $UserRoleDefined"

 



#calling the JBoss add-user powershell script.

& $itomAddUser"add-user.ps1" -a -u $UserNameDefined -p $valuepwd -g $UserRoleDefined



#Copy config files

Write-Host "`ncopying files..."

Copy-Item "$pwd/tmp\web.xml" -Destination $itamWebPath
Copy-Item "$pwd/tmp\jboss-web.xml" -Destination $itamWebPath

#Copy dodeploy file, this should allow the itam war to be deployed regardless if undeployed, skip deploy etc.

Write-Host "`nenabling ITAM.war deployment..."


Copy-Item "$pwd/ITAM.war.dodeploy" -Destination $itamWarPath

Write-Host "`ncompleted all steps, Basic auth is now enabled on your ITAM Web Service"
Write-Host "`nReminder username is $UserNameDefined"




#Optional confirm ITAM Web Service Credential is configured.




Write-Host "`nContinue with the script to confirm change is working, else you can close the script and verify on a browser`n"




##if SapphireIMS service is running, proceed with test, else say not started##






$urltoCheck= Read-Host "Enter URL for ITOMserverURL/ITAM/ to verify credentials`n `nexample: https://ifs-itom.saas.axiossystems.com/ITAM/ `n`nYour URL:"

Write-Host "`nEnter Credentials configured when prompted (user will be $UserNameDefined)`n"



$cred = Get-Credential $UserNameDefined

#Not handling errors as they are helpful for the user to understand why it failed, e.g incorrect auth or not reachable.

try{
	
	Invoke-WebRequest $urltoCheck -Credential $cred
	Read-Host "Successful, was able to log in to the ITAM Api with your new credentials, press enter to exit."

	
	
}

catch {
	
	Read-Host "error encountered, please confirm manually in a browser, if not working please rerun-script."
}