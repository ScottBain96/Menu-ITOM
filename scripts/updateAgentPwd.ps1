#Not getting java_home instead as it might not be set up for ITOM etc.+
#Getting ITOM path for JDK from the service SapphireIMS
$servicePathCheckITOM=Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\SapphireIMS -Name "ImagePath"
$itomPath= $servicePathCheckITOM.Imagepath.Replace("\ConsoleManagement\bin\SapphireIMS.exe","")
$itomPath=$itomPath.Trim("""");

#Paths for files to modify:

$pathStandalone=$itomPath+"\WebManagement\standalone\configuration\standalone.xml"
$pathAppUser=$itomPath+"\WebManagement\standalone\configuration\application-users.properties"
$pathSaphireUser=$itomPath+"\WebManagement\standalone\configuration\sapphire-users.properties"
$pathAgentSelfCreator=$itomPath+"\ConsoleManagement\AgentSelfCreater\"
$pathServerConf=$pathAgentSelfCreator+"ServerConf.ini"
$itomAddUser=$itomPath+"\WebManagement\bin\"



while ($checkRequirement -ne "Sapphire"){

$checkRequirement=Read-Host "USER MUST BE SET EXACTLY AS sapphire (CASE SENSITIVE) when prompted, type sapphire to confirm you have read this"



}



##generating backups
#Check the $FolderAttachments exists, if not it creates it.

if (!(Test-Path -Path $pwd"\backups")){

New-Item -ItemType Directory -Force -Path $pwd"\backups"



}

Copy-Item "$pathStandalone" -Destination $pwd"\backups"
Copy-Item "$pathAppUser" -Destination $pwd"\backups"
Copy-Item "$pathSaphireUser" -Destination $pwd"\backups"




Write-Host "Steps to complete by user with previously defined values."
Write-Host "1) Select Option b (type letter b and press enter)"
Write-Host "2) Username MUST BE sapphire (CARE CASE SENSITIVE)"
Write-Host "3) Enter desired password"
Write-Host "4) Confirm password if requested"
Write-Host "5) Re-enter password when requested"
Write-Host "6) What groups do you want... leave emtpy, press enter"
Write-Host "7) Confirm with yes to if asked about adding user"
Write-Host "8) For Slave host controller... answer yes."
Write-Host "9) You will receive a secrent value (your password encrypted in base64)."


Write-Host "`nLOADING SCRIPT...`n"



& $itomAddUser"add-user.ps1" 



Write-Host "Enter the password for sapphire user again for file configs"

$credToConvert = Read-host 'enter password' -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credToConvert)
$value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
$ENCODED = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($value))

#Strings to search for

$stringModule='<module-option name="realm" value="sapphire"/>'
$stringAppUser="Sapphire*"
$stringServerPWD="Password="


###### First change, replacing the module option#####


$search = Get-Content $pathStandalone |Select-String -Pattern $stringModule | Select-Object LineNumber, Line


#Finding line in the text and - 1 because it will be used as a position in an array, since arrays start at 0...

$LineWhereFound=$search.LineNumber -1


$LineWhereFound


$filecontent = Get-Content -Path $pathStandalone
$filecontent[$LineWhereFound] = $filecontent[$LineWhereFound] -replace $stringModule,'<module-option name="realm" value="ApplicationRealm"/>'

Set-Content -Path $pathStandalone -Value $filecontent

Write-Host "updated standalone.xml"




############# Second change, Updating sapphire-user file with the value of application-user file: ############

#Getting full line content to copy, setting as variable to use later.

$search = Get-Content $pathAppUser |Select-String -Pattern $stringAppUser | Select-Object LineNumber, Line
$lineToCopy=$search.Line


#searching in destination file to replace existing line, need the value of the full line to replace.

$search = Get-Content $pathSaphireUser |Select-String -Pattern $stringAppUser | Select-Object LineNumber, Line
$LineWhereFoundTwo=$search.LineNumber -1
$lineToRemove=$search.Line


#Performing the line replacement from file 1 to file 2.

$filecontent = Get-Content -Path $pathSaphireUser
$filecontent[$LineWhereFoundTwo] = $filecontent[$LineWhereFoundTwo] -replace $lineToRemove,$lineToCopy

Set-Content -Path $pathSaphireUser -Value $filecontent

Write-Host "Updated user files"

#TO DO updated server.conf file for agent installer package.


#to fix the formatting at some point for the secret result.
Write-Host "`nsecret value bellow should match the secret value provided above, if not you will need to manually change the password reference in the following file:"
Write-Host "(double quotes missing to be ignored)"
Write-Host "`n<secret value=$ENCODED />"
Write-Host "`nFile location:`n "


$pathServerConf



#$search = Get-Content $pathServerConf |Select-String -Pattern $stringServerPWD | Select-Object LineNumber, Line
$search = Get-Content $pathServerConf |Select-String -Pattern "Password" | Select-Object LineNumber, Line 
$lineWhereFound=$search[0].LineNumber -1
$lineToRemove=$search[0].Line




#Error handling rare ocassion that Password setting has been removed from the server config file.


if (!($lineToRemove -match "proxy"))

{

$filecontent = Get-Content -Path $pathServerConf
$filecontent[$LineWhereFound] = $filecontent[$LineWhereFound] -replace $lineToRemove,"Password=$ENCODED"
Set-Content -Path $pathServerConf -Value $filecontent


}

else {
	
	Write-host "missing Password setting in $pathServerConf"
	
	Write-host "not applying change, please correct manually".
	
	
}


##Apply agentcreator exe OOP, simple file swap but backing existing one. This should not be needed in later releases####

Write-Host "backing up SIMS_AgentTrigger.exe..."
copy-Item $pathAgentSelfCreator"\SIMS_AgentTrigger.exe" -Destination $pwd"\backups"


Write-Host "applying new SIMS_AgentTrigger.exe"
Copy-Item $pwd"\sourceAgentTrigger\SIMS_AgentTrigger.exe" -Destination $pathAgentSelfCreator



Write-Host "all steps completed, agent password is now updated at a server level. Please recreate any ITOM agent packages to reflect the new password."

Write-Host "`nContinue with the script to confirm change is working, else you can close the script and verify on a browser`n"

$urltoCheck= Read-Host "Enter URL for ITOMserverURL/SapphireWS to verify credentials`n `nexample: https://ifs-itom.saas.axiossystems.com/SapphireWS/ `n`nYour URL:"




$creds = Get-Credential

#Not handling errors as they are helpful for the user to understand why it failed, e.g incorrect auth or not reachable.

try{
	
	Invoke-WebRequest $urltoCheck -Credential $creds
	Read-Host "Successful, was able to log in to the ITOM Agent Webservice with your new credentials, press enter to exit."
	
	
	
}

catch {
	
	Read-Host "error encountered, please confirm manually in a browser, if not working please rerun-script."
}














