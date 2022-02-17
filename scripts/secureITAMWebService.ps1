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
$UserNameDefined = Read-Host "Enter username which will be used for Web Service Authentication (sapphire reserverd, DO NOT USE)"



#Creating Group which follows format usernameAdmin
$UserRoleDefined=$UserNameDefined+"Admin"



#Replacing lines 51 and 59 of the web.xml to include the correct user security Role. (positions are 1 less due to being array)

$filecontent = Get-Content -Path "$pwd\tmp\web.xml"
$filecontent[50] = $filecontent[50] -replace 'gatewayAdmin',$UserRoleDefined
$filecontent[58] = $filecontent[58] -replace 'gatewayAdmin',$UserRoleDefined
 
Set-Content -Path "$pwd\tmp\web.xml" -Value $filecontent


Write-Host "`nFiles configured with Username $UserNameDefined and group name $UserRoleDefined"
Write-Host "`nYou must use these values when prompted now, else the files will not match`n"
 
#for now leaving like this, I will automate this input at some later stage.


Write-Host "Steps to complete by user with previously defined values."
Write-Host "1) Select Option b (type letter b and press enter)"
Write-Host "2) Username MUST BE $UserNameDefined (CASE SENSITIVE)"
Write-Host "3) Enter desired password"
Write-Host "4) Confirm password if requested"
Write-Host "5) Re-enter password when requested"
Write-Host "6) What groups do you want... MUST BE: $UserRoleDefined (CASE SENSITIVE)"
Write-Host "7) Confirm with yes to adding user"
Write-Host "8) For Slave host controller... answer yes."
Write-Host "9) You will receive a secrent value (your password encrypted in base64)."
Write-host "10) Script will handle the rest of the config"

Write-Host "`nLOADING SCRIPT...`n"


#calling the JBoss add-user powershell script.

& $itomAddUser"add-user.ps1" 

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

$urltoCheck= Read-Host "Enter URL for ITOMserverURL/ITAM/ to verify credentials`n `nexample: https://ifs-itom.saas.axiossystems.com/ITAM/ `n`nYour URL:"

Write-Host "`nEnter Credentials configured when prompted (user will be $UserNameDefined)`n"



$cred = Get-Credential

#Not handling errors as they are helpful for the user to understand why it failed, e.g incorrect auth or not reachable.

try{
	
	Invoke-WebRequest $urltoCheck -Credential $cred
	Read-Host "Successful, was able to log in to the ITAM Api with your new credentials, press enter to exit."

	
	
}

catch {
	
	Read-Host "error encountered, please confirm manually in a browser, if not working please rerun-script."
}