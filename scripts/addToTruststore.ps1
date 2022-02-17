#For handling the method in which the certificate will be sourced to the JDK/bin folder. Either script will download automatically or the user will have to do it manually.
param (
 [Parameter(Mandatory = $false)]
 [AllowEmptyString()]
 [ValidateSet("manual","")]
 [string]$action

)


#Not getting java_home instead as it might not be set up for ITOM etc.+
#Getting ITOM path for JDK from the service SapphireIMS
$servicePathCheckITOM=Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\SapphireIMS -Name "ImagePath"
$itomPath= $servicePathCheckITOM.Imagepath.Replace("\ConsoleManagement\bin\SapphireIMS.exe","")
$itomPath=$itomPath.Trim("""");

#Setting re-used paths 
$itomJDK=$itomPath+"\WebManagement\JDK\bin\"
$itomJRE=$itomPath+"\WebManagement\JDK\jre\lib\security\"
$itomLOG=$itomPath+"\WebManagement\standalone\"


#for starting services handling
$MessageQueueExists=$false

function getCertificate(){
	
	
	
	try {
		
		#setting TLS1.2 for the PowerShell session.	
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

		
		#$URLITOM = "Hardcoded URL for setting in specific customer servers, comment out line bellow if using this setting instead"
		Write-Host "`nReady to attempt to download your SSL certificate"
		Write-Host "`nverify in a chrome browser from this machine that the certificate authority listed is correct`n"
		Write-Host "`nthen proceed with the following..."
		
		
		$URLITOM = Read-Host "`nType your full itom central server public URL. `nExample https://ifs-itom.saas.axiossystems.com/assystITOM`n"
		$webRequest = [Net.WebRequest]::Create($URLITOM)
		try { $webRequest.GetResponse() } catch {}
		$cert = $webRequest.ServicePoint.Certificate
		$bytes = $cert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Cert)
		set-content -value $bytes -encoding byte -path $itomJDK"cacert.cer"
		
		#Once certificate is downloaded and stored, it will move on to the perfomChange function which handles the implementation of the certificate.
		Write-Host "Proceeding with truststore changes"
		start-sleep -Seconds 5		
		performChange
	
		}
	
	
	#If error occurs during download, possible issues... Can't reach URL at the time, Certificate showing wrong provider (e,g if using Kaspersky it can show that as the provider)
	#Advises user of the error and how to resolve with manual certificate download.
	
	catch {
		
		 Write-Host "Could not download the certificate, is the URL correct? if it is, please try manual mode"
		 Write-Host "To do this, manually download cacert.cer and place in the $itomJDK folder"
		 Write-Host "Once that is done, start the script like this: "
		 Write-Host "./addToTruststore manual"
		 Write-Host "Detailed steps can be found in the ReadMe file"
		 PAUSE
		}

	
	
}



#Main function that performs the procedure once the cacert.cer file has been sourced.

function performChange(){



	#cacert.cer file must be downloaded and placed either by the getCertificate function or manually by the user if using the manual mode.
	#Additionally, checking that an ITOM install exists as precaution.

	if ((Test-Path -Path $itomJDK"cacert.cer" -PathType Leaf) -and ($servicePathCheckITOM -ne "")){
		
		Write-Host "SapphireIMS service will automatically be stopped if it is currently running"
		stop-service SapphireIMS
		Write-Host "`nService is stopped"
		
		
		#Confirming if the message queue service exists. If so -> stopping the service and setting a value to true for later.
		#Could have been done faster by just using stop service but I don't want to display a not found service error. 
		#Using the silent errors would not be good here because of possible true errors when stopping service instead of can't find. Handling scenario with this if statement.
			
		if (get-service -name "SapphireIMSMessageQueue" -ErrorAction SilentlyContinue){
		
				Write-Host "Message Queue service is installed, stopping the service"
				stop-service SapphireIMSMessageQueue
				Write-Host "message queue service exists, so stopped"
				$MessageQueueExists=$true
				
		}
		
		
		#error message to be expected if the alias does not already exist in the trust store. Advising user that it is expected/normal.
		
		Write-Host "`nDeleting current assystITOM alias in the java trusttore"
		Write-Host "`nif it does not exist, there will be a missing alias assystITOM keytool error displayed (ignore this error)"
		
		#Delete from keystore file. This is required as some versions of java do not allow you to override an existing one.
		& $itomJDK"keytool" -delete -alias "assystITOM" -keystore $itomJRE"cacerts" -storepass changeit -noprompt 
		
		Write-Host "`nSuccessfuly deleted any existing assystITOM alias from the java truststore"


		#Adding certificate to truststore with default alias "assystITOM"
		& $itomJDK"keytool" -importcert -storepass changeit -noprompt -file $itomJDK"cacert.cer" -keystore $itomJRE"cacerts" -alias "assystITOM" 


		Write-Host "`nPlease confirm that the paths indicated are correct and accept the delete the folders for tmp & log`n"
		
		#Removing folders, not using force as I want the user to validate the path for deleting, can be changed to force for specific customer setups.
		Remove-Item $itomLOG"tmp"
		Remove-Item $itomLOG"log"
		
		
		#MessageQueue needs to be started first (if there is any in the setup) and it requires around 30-45 seconds to load correctly before starting ITOM service.
		if ($MessageQueueExists){
			
			Write-Host "`nStarting MessageQueue Service"
			Start-Service SapphireIMSMessageQueue
			Write-Host "`nWaiting 60 seconds for MessageQueue to load correctly..."
			Start-Sleep -Seconds 60
			
			
		}
		
		#Finally starting ITOM service
		
		Write-Host "`nStarting ITOM service..."
		Start-Service SapphireIMS
		
		Write-Host "`nServer should now be in deploying state, please wait some minutes and check the server"
		PAUSE
	}

	#If missing cacert.cer or the ITOM install does not exist / can't be detected.

	else {

		Write-Host "`nDownload and place the required cacert.cer file in: "$itomJDK
		Write-Host "Once you have placed the file, rerun this script"
		Write-Host "`nif you do not have the cacert.cer file, please follow the ReadMe instructions"
		Write-Host "this script should only be executed in servers that contain an ITOM installation"
		PAUSE
		
	}

	Read-Host "`nPress enter to exit..."
	
	
	
	
	
}




#Paramter used to select either manual or not.

if ($action -eq "manual"){
	
	performChange
	
}

if ($action -eq ""){
	
	getCertificate
	
}
