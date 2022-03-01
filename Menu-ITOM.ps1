$servicePathCheckITOM=Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\SapphireIMS -Name "ImagePath"
$itomPath= $servicePathCheckITOM.Imagepath.Replace("\ConsoleManagement\bin\SapphireIMS.exe","")
$itomPath=$itomPath.Trim("""");
$itomPathWarfiles=$itomPath+"\WebManagement\standalone\deployments\"


Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='ITOM additional features launcher'
$main_form.BackColor = "#ffffff"
#$main_form.BackColor = "Black"
$main_form.ForeColor= "Black"


$main_form.StartPosition="CenterScreen"
$main_form.Font = 'Microsoft Sans Serif,13'
$main_form.AutoSize = $true
$main_form.location = New-Object System.Drawing.Point(40,20)




#form ICON
$objIcon = New-Object system.drawing.icon ("$pwd\sourceXML\favicon.ico")
$main_form.Icon = $objIcon


#Header 1##
$title=New-Object system.Windows.Forms.Label
$title.text="assystITOM 5006-x additional features script launcher."
$title.location=New-Object System.Drawing.Point(10,20)
$title.Font = 'Microsoft Sans Serif,10'
$title.AutoSize =$true


#Choose script to run label##
$title2=New-Object system.Windows.Forms.Label
$title2.Font = 'Microsoft Sans Serif,10'
$title2.text="Choose script to run:"
$title2.location=New-Object System.Drawing.Point(10,50)
$title2.AutoSize =$true


#Choose script to run label##
$title3=New-Object system.Windows.Forms.Label
$title3.Font = 'Microsoft Sans Serif,10'
$serviceSapphire=Get-Service -name "SapphireIMS"
$title3.text=$serviceSapphire.Name+ " is currently: "+$serviceSapphire.status
$title3.location=New-Object System.Drawing.Point(10,250)
$title3.AutoSize =$true


#Choose script to run label##
$title5=New-Object system.Windows.Forms.Label
$title5.Font = 'Microsoft Sans Serif,10'
$serviceMessageQ=Get-Service -name "SapphireIMSMessageQueue"
$title5.text=$serviceMessageQ.Name+ " is currently: "+$serviceMessageQ.status
$title5.location=New-Object System.Drawing.Point(10,280)
$title5.AutoSize =$true







#Choose script to run label##
$title4=New-Object system.Windows.Forms.Label
$title4.Font = 'Microsoft Sans Serif,10'
$filesWar=Get-ChildItem -Path $itomPathWarfiles -Exclude "*.war","*.txt" | select LastWriteTime, Name | Out-String
$title4.text=$filesWar
#$title4.location=New-Object System.Drawing.Point(10,310)
$title4.location=New-Object System.Drawing.Point(10,350)
$title4.AutoSize =$true



##FIRST BUTTON - Secure ITAM WebService###
$btnSecureITAM                   = New-Object system.Windows.Forms.Button
$btnSecureITAM.BackColor         = "#82b0fa"
$btnSecureITAM.text              = "Secure ITAM WebService"
$btnSecureITAM.width             = 90
$btnSecureITAM.height            = 60
$btnSecureITAM.location          = New-Object System.Drawing.Point(10,100)
$btnSecureITAM.Font              = 'Microsoft Sans Serif,10'
$btnSecureITAM.ForeColor         = "#ffffff"
$btnSecureITAM.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnSecureITAM.FlatAppearance.BorderSize = 0.8
$btnSecureITAM.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnSecureITAM.TabStop=$false





##Second BUTTON - Agent Password###
$btnAgentPwd                   = New-Object system.Windows.Forms.Button
$btnAgentPwd.BackColor         = "#82b0fa"
$btnAgentPwd.text              = "Secure Agent WebService"
$btnAgentPwd.width             = 90
$btnAgentPwd.height            = 60
$btnAgentPwd.location          = New-Object System.Drawing.Point(110,100)
$btnAgentPwd.Font              = 'Microsoft Sans Serif,10'
$btnAgentPwd.ForeColor         = "#ffffff"
$btnAgentPwd.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAgentPwd.FlatAppearance.BorderSize =0.8
$btnAgentPwd.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnAgentPwd.TabStop=$false


##third BUTTON - TrustStore###
$btnTrustStore                   = New-Object system.Windows.Forms.Button
$btnTrustStore.BackColor         = "#82b0fa"
$btnTrustStore.text              = "Add SSL to TrustStore"
$btnTrustStore.width             = 90
$btnTrustStore.height            = 60
$btnTrustStore.location          = New-Object System.Drawing.Point(210,100)
$btnTrustStore.Font              = 'Microsoft Sans Serif,10'
$btnTrustStore.ForeColor         = "#ffffff"
$btnTrustStore.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnTrustStore.FlatAppearance.BorderSize = 0.8
$btnTrustStore.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnTrustStore.TabStop=$false







## BUTTUN - ALL ###

$btnDataRest                   = New-Object system.Windows.Forms.Button
$btnDataRest.BackColor         = "#82b0fa"
$btnDataRest.text              = "Add Data at Rest"
$btnDataRest.width             = 90
$btnDataRest.height            = 60
$btnDataRest.location          = New-Object System.Drawing.Point(310,100)
$btnDataRest.Font              = 'Microsoft Sans Serif,10'
$btnDataRest.ForeColor         = "#ffffff"
$btnDataRest.Margin = 10
$btnDataRest.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnDataRest.FlatAppearance.BorderSize = 0.8
$btnDataRest.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnDataRest.TabStop=$false









## BUTTUN - Start / stop Services ###

$btnServices                   = New-Object system.Windows.Forms.Button
$btnServices.BackColor         = "#82b0fa"
$btnServices.text              = "Start/stop Services"
$btnServices.width             = 90
$btnServices.height            = 60
$btnServices.location          = New-Object System.Drawing.Point(410,100)
$btnServices.Font              = 'Microsoft Sans Serif,10'
$btnServices.ForeColor         = "#ffffff"
$btnServices.Margin = 10
$btnServices.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnServices.FlatAppearance.BorderSize = 0.8
$btnServices.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnServices.TabStop=$false



################################### SECOND ROW OF BUTTONS###################################


## BUTTUN - TEST ITAM WebService###

$btnTestITAM                   = New-Object system.Windows.Forms.Button
$btnTestITAM.BackColor         = "#82b0fa"
$btnTestITAM.text              = "Test ITAM Web Service"
$btnTestITAM.width             = 90
$btnTestITAM.height            = 60
$btnTestITAM.location          = New-Object System.Drawing.Point(10,170)
$btnTestITAM.Font              = 'Microsoft Sans Serif,10'
$btnTestITAM.ForeColor         = "#ffffff"
$btnTestITAM.Margin = 10
$btnTestITAM.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnTestITAM.FlatAppearance.BorderSize = 0.8
$btnTestITAM.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnTestITAM.TabStop=$false




## BUTTUN - TEST Agent Web Service###

$btnTestAgentWS                   = New-Object system.Windows.Forms.Button
$btnTestAgentWS.BackColor         = "#82b0fa"
$btnTestAgentWS.text              = "Test Agent Web Service"
$btnTestAgentWS.width             = 90
$btnTestAgentWS.height            = 60
$btnTestAgentWS.location          = New-Object System.Drawing.Point(110,170)
$btnTestAgentWS.Font              = 'Microsoft Sans Serif,10'
$btnTestAgentWS.ForeColor         = "#ffffff"
$btnTestAgentWS.Margin = 10
$btnTestAgentWS.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnTestAgentWS.FlatAppearance.BorderSize = 0.8
$btnTestAgentWS.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnTestAgentWS.TabStop=$false


## BUTTON - TrustStore MANUAL             = New-Object system.Windows.Forms.Button
$btnTrustStoreManual            = New-Object system.Windows.Forms.Button
$btnTrustStoreManual.BackColor         = "#82b0fa"
$btnTrustStoreManual.text              = "Add SSL to TrustStore - Manual cert"
$btnTrustStoreManual.width             = 90
$btnTrustStoreManual.height            = 60
$btnTrustStoreManual.location          = New-Object System.Drawing.Point(210,170)
$btnTrustStoreManual.Font              = 'Microsoft Sans Serif,10'
$btnTrustStoreManual.ForeColor         = "#ffffff"
$btnTrustStoreManual.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnTrustStoreManual.FlatAppearance.BorderSize = 0.8
$btnTrustStoreManual.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnTrustStoreManual.TabStop=$false



## BUTTON - Log folders ##

$btnLogs                   = New-Object system.Windows.Forms.Button
$btnLogs.BackColor         = "#82b0fa"
$btnLogs.text              = "Copy logs"
$btnLogs.width             = 90
$btnLogs.height            = 60
$btnLogs.location          = New-Object System.Drawing.Point(310,170)
$btnLogs.Font              = 'Microsoft Sans Serif,10'
$btnLogs.ForeColor         = "#ffffff"
$btnLogs.Margin = 10
$btnLogs.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnLogs.FlatAppearance.BorderSize = 0.8
$btnLogs.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnLogs.TabStop=$false


## BUTTUN - REFRESH ##

$btnRefresh                   = New-Object system.Windows.Forms.Button
$btnRefresh.BackColor         = "#82b0fa"
$btnRefresh.text              = "Refresh Form"
$btnRefresh.width             = 90
$btnRefresh.height            = 60
$btnRefresh.location          = New-Object System.Drawing.Point(410,170)
$btnRefresh.Font              = 'Microsoft Sans Serif,10'
$btnRefresh.ForeColor         = "#ffffff"
$btnRefresh.Margin = 10
$btnRefresh.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRefresh.FlatAppearance.BorderSize = 0.8
$btnRefresh.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnRefresh.TabStop=$false












#CHECKBOX FOR MessageQueue ignoring

$checkbox1 = new-object System.Windows.Forms.checkbox
$checkbox1.Location = new-object System.Drawing.Point(10,310)
$checkbox1.Font = 'Microsoft Sans Serif,10'
$checkbox1.Text = "Ignore MessageQueue when stopping/starting services"
$checkbox1.Checked = $True
$checkbox1.AutoSize =$True
 





#not sure if multiple can be added in a single line, to check at some point.


$main_form.Controls.Add($btnSecureITAM)
$main_form.Controls.Add($btnTrustStore)
$main_form.Controls.Add($btnTrustStoreManual)
$main_form.Controls.Add($btnAgentPwd)
$main_form.Controls.Add($btnDataRest)
$main_form.Controls.Add($btnRefresh)
$main_form.Controls.Add($btnServices)
$main_form.Controls.Add($btnTestITAM)
$main_form.Controls.Add($btnTestAgentWS)
$main_form.Controls.Add($btnLogs)
$main_form.Controls.Add($checkbox1) 
$main_form.Controls.Add($title)
$main_form.Controls.Add($title2)
$main_form.Controls.Add($title2)
$main_form.Controls.Add($title3)
$main_form.Controls.Add($title4)
$main_form.Controls.Add($title5)





$btnSecureITAM.Add_Click({ startSecureITAMScript })
$btnTrustStore.Add_Click({ startTrustStoreScript })
$btnTrustStoreManual.Add_Click({ startTrustStoreScriptManual })
$btnAgentPwd.Add_Click({ startAgentPwd })
$btnDataRest.Add_Click({ startDataRest })
$btnServices.Add_Click({ startServices })
$btnRefresh.Add_Click({ startRefresh })
$btnTestITAM.Add_Click({ startTestITAMWS })
$btnTestAgentWS.Add_Click({ startTestAgentWS })






$pathScripts="$pwd\scripts\"


Write-Host "Starting UI..."

function startSecureITAMScript{
	
try{

start-process powershell $pathScripts"secureITAMWebService.ps1"
Write-Host "Started Secure ITAM Web Service process..."


}


##need to add a catch to the web request incase it fails, else it closes instantly. Either that or a pause.


catch {}

}





function startTrustStoreScript{

try{



#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"addToTruststore.ps1"
Write-Host "Started Add SSL to truststore process..."

}

catch{}

}



function startTrustStoreScriptManual{

try{



#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"addToTruststore.ps1 manual"
Write-Host "Started Add SSL to truststore process (manual flag)..."


}

catch{}

}










## AGENT PASSWORD CHANGE ##


function startAgentPwd{

try{


#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"updateAgentPwd.ps1"
Write-Host "Started Secure Agent Webservice process..."

}

catch{}

}


function startDataRest{

try{


#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"addDataAtRest.ps1"
Write-Host "Started Add Data at Rest process..."

}

catch{}

}





function startRefresh{

try{

Write-Host "Refreshing..."

#Missing adding manual option
#Read-host "Manual or importing certificate?"
$filesWar=Get-ChildItem -Path $itomPathWarfiles -Exclude "*.war","*.txt" | select LastWriteTime, Name | Out-String

##Adding a visual text replacement, maybe there are other transitions effects available but good enough.
$title4.text=""
Start-Sleep -Milliseconds 50
$title4.text=$filesWar

$serviceSapphire=Get-Service -name "SapphireIMS"
$title3.text=$serviceSapphire.Name+ " is currently: "+$serviceSapphire.status
$serviceMessageQ=Get-Service -name "SapphireIMSMessageQueue"
$title5.text=$serviceMessageQ.Name+ " is currently: "+$serviceMessageQ.status


Write-Host "`nRefresh completed`n"

}

catch{}

}


















	

function startServices{

try{

#Getting the SapphireIMS paths,setting log folder paths and deployments to check for war file status:



Write-Host "status of checkbox "$checkbox1.Checked


$filesWar=Get-ChildItem -Path $itomPathWarfiles -Exclude "*.war","*.txt" | select LastWriteTime, Name | Out-String

$a = new-object -comobject wscript.shell

#Missing adding manual option
#Read-host "Manual or importing certificate?"



$serviceSapphire=Get-Service -name "SapphireIMS"
$serviceMessageQ=Get-Service -name "SapphireIMSMessageQueue"

if (($MessageQueueExists) -and ($serviceMessageQ.status -eq "stopped") -and (!($checkbox1.Checked))){
	
		Write-Host "`nStarting SapphireIMSMessageQueue`n"
		
		##Popup messagebox with a 60s timer as the UI will be unuable during the timer
		#$a = new-object -comobject wscript.shell
		$b = $a.popup("Main UI will be unusable during 60 seconds due to loading queues for RabbitMQ",5,"Notify timer started")
		
		start-service "SapphireIMSMessageQueue"
		Write-Host "`nStarted service SapphireIMSMessageQueue`nproceeding with 60 seconds sleep for queues to load correctly. UI will be unresponsive"
		Start-Sleep -Seconds 3
		Write-Host "Message queue is started, proceeding with ITOM service`n"
		
		
	
	
}




if ($serviceSapphire.status -eq "Stopped"){
	


	Start-service "SapphireIMS"
	Write-Host "started SapphireIMS"
	
	startRefresh
	$b = $a.popup("Finished starting services",5,"Notify started services")
	$btnServices.text = "Stop Services"
	
	
	
}


else {
	
	stop-service "SapphireIMS"
	Write-Host "stopping service"
	
		if ((get-service -name "SapphireIMSMessageQueue" -ErrorAction SilentlyContinue) -and (!($checkbox1.Checked))){
		
				Write-Host "Message Queue service is installed, stopping the service"
				stop-service SapphireIMSMessageQueue
				Write-Host "message queue service exists, so stopped"
				
				
		}
	startRefresh
	$btnServices.text = "Start Services"
	$b = $a.popup("Stopped services",5,"Notify services stopped")

		

	
}



}

catch{}

}




function startTestITAMWS{

try{



start-process powershell $pathScripts"testITAMWebService.ps1"
Write-Host "Started Test ITAM WebService process..."

}

catch{}

}





function startTestAgentWS{

try{



start-process powershell $pathScripts"testAgentWebService.ps1"
Write-Host "Started Test Agent WebService process..."

}

catch{}

}









##Loading UI.

try{
	
	$MessageQueueExists

	if (get-service -name "SapphireIMSMessageQueue" -ErrorAction SilentlyContinue){
		
				Write-Host "Message Queue service is installed"
				$MessageQueueExists=$true
				
				
	}
	
	if ($env:JAVA_HOME){
		Write-Host "Found JAVA_HOME directory: $env:JAVA_HOME"
		Write-Host "`nMake sure this matches your current install`n"
		$main_form.ShowDialog()
		
	}
	else {
		
		Write-Host "Missing JAVA_HOME environment variable, please set this up and restart powershell. Then you should be able to rerun the script."
		
	}
	
	
	
}

catch{}


