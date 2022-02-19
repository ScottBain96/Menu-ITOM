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

$itomAppRoleFile=$itomPath+"\WebManagement\standalone\configuration\application-roles.properties"
$itomDomainRoleFile=$itomPath+"\WebManagement\Domain\configuration\application-roles.properties"




##generating backups
#Check the $FolderAttachments exists, if not it creates it.

if (!(Test-Path -Path $pwd"\backups")){

New-Item -ItemType Directory -Force -Path $pwd"\backups"



}

Copy-Item "$pathStandalone" -Destination $pwd"\backups"
Copy-Item "$pathAppUser" -Destination $pwd"\backups"
Copy-Item "$pathSaphireUser" -Destination $pwd"\backups"



$UserNameDefined="sapphire"

Write-Host "`nEnter the new password for your agent web services (username will always be sapphire)`n"

$credToConvert = Read-host "`Enter password" -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credToConvert)
$valuepwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)


$ENCODED = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($valuepwd))


Write-Host "Encoded password is $encoded "

Write-Host "`nLOADING SCRIPT...`n"


& $itomAddUser"add-user.ps1" -a -u $UserNameDefined -p $valuepwd



Write-Host "`nCompleted JBOSS add-user script`n"


Write-Host "`nAdding additional configuration...`n"


##Adding the empty roles manually to the files which can't be added with -g in the add-user.ps1 script as it needs to be empty. Not sure if adding " " to the script works as the encoded value is different.

##To correct and add as a function in the future##


$str ="sapphire="




##first file to replace/add line to##


$search = Get-Content $itomAppRoleFile |Select-String -Pattern $str | Select-Object LineNumber, Line

#handling if no matches are found#

if (!($search)){

$totalLines=Get-Content $itomAppRoleFile
$LineWhereFound=$totalLines.Count -1
$filecontent = Get-Content -Path $itomAppRoleFile
$filecontent[$LineWhereFound] += "`r`n$str"
Set-Content -Path $itomAppRoleFile -Value $filecontent
Write-Host "Sucessfully added group $str to $itomAppRoleFile"

}

#adding to a new line at end of file to not overwrite any values#

else{
	
$LineWhereFound=$search.LineNumber -1
$LineToRemove=$search.Line
$filecontent = Get-Content -Path $itomAppRoleFile
$filecontent[$LineWhereFound] = $filecontent[$LineWhereFound] -replace $lineToRemove,$str
Set-Content -Path $itomAppRoleFile -Value $filecontent
Write-Host "Sucessfully added group $str to $itomAppRoleFile"


}



##Second file to replace/add line to, Again should be a single function but for now leaving like this##


$search = Get-Content $itomDomainRoleFile |Select-String -Pattern $str | Select-Object LineNumber, Line

#handling if no matches are found#

if (!($search)){
	
$totalLines=Get-Content $itomDomainRoleFile
$LineWhereFound=$totalLines.Count -1
$filecontent = Get-Content -Path $itomDomainRoleFile
$filecontent[$LineWhereFound] += "`r`n$str"
Set-Content -Path $itomDomainRoleFile -Value $filecontent
Write-Host "Added $str to $itomDomainRoleFile"


}

#adding to a new line at end of file to not overwrite any values#

else{

$LineWhereFound=$search.LineNumber -1
$LineToRemove=$search.Line
$filecontent = Get-Content -Path $itomDomainRoleFile
$filecontent[$LineWhereFound] = $filecontent[$LineWhereFound] -replace $lineToRemove,$str
Set-Content -Path $itomDomainRoleFile -Value $filecontent
Write-Host "Added $str to $itomDomainRoleFile"


}





#Strings to search for

$stringModule='<module-option name="realm" value="sapphire"/>'
$stringAppUser="Sapphire*"
$stringServerPWD="Password="


##UPDATING STANDALONE.XML#

$search = Get-Content $pathStandalone |Select-String -Pattern $stringModule | Select-Object LineNumber, Line


#Finding line in the text and - 1 because it will be used as a position in an array, since arrays start at 0...

$LineWhereFound=$search.LineNumber -1
$filecontent = Get-Content -Path $pathStandalone
$filecontent[$LineWhereFound] = $filecontent[$LineWhereFound] -replace $stringModule,'<module-option name="realm" value="ApplicationRealm"/>'
Set-Content -Path $pathStandalone -Value $filecontent


Write-Host "updated standalone.xml"




############# Updating sapphire-user file with the value of application-user file: ############

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


##UPDATING SERVER CONFIG FILE FOR AGENT PACKAGES##


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




$creds = Get-Credential "sapphire"

#Not handling errors as they are helpful for the user to understand why it failed, e.g incorrect auth or not reachable.

try{
	
	Invoke-WebRequest $urltoCheck -Credential $creds
	Read-Host "Successful, was able to log in to the ITOM Agent Webservice with your new credentials, press enter to exit."
	
	
	
}

catch {
	
	Read-Host "error encountered, please confirm manually in a browser, if not working please rerun-script."
}














