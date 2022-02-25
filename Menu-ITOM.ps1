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
$title3.text=$serviceSapphire.Name+ " is currently "+$serviceSapphire.status
$title3.location=New-Object System.Drawing.Point(10,250)
$title3.AutoSize =$true


#Choose script to run label##
$title4=New-Object system.Windows.Forms.Label
$title4.Font = 'Microsoft Sans Serif,10'
$filesWar=Get-ChildItem -Path $itomPathWarfiles -Exclude "*.war","*.txt" | select LastWriteTime, Name | Out-String
$title4.text=$filesWar
$title4.location=New-Object System.Drawing.Point(10,280)
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




#not sure if multiple can be added in a single line, to check at some point.


$main_form.Controls.Add($btnSecureITAM)
$main_form.Controls.Add($btnTrustStore)
$main_form.Controls.Add($btnTrustStoreManual)
$main_form.Controls.Add($btnAgentPwd)
$main_form.Controls.Add($btnDataRest)
$main_form.Controls.Add($btnServices)
$main_form.Controls.Add($title)
$main_form.Controls.Add($title2)
$main_form.Controls.Add($title2)
$main_form.Controls.Add($title3)
$main_form.Controls.Add($title4)



$btnSecureITAM.Add_Click({ startSecureITAMScript })
$btnTrustStore.Add_Click({ startTrustStoreScript })
$btnTrustStoreManual.Add_Click({ startTrustStoreScriptManual })
$btnAgentPwd.Add_Click({ startAgentPwd })
$btnDataRest.Add_Click({ startDataRest })
$btnServices.Add_Click({ startServices })



$pathScripts="$pwd\scripts\"


Write-Host "Starting UI...`nIf UI is not loading, you can still run the scripts manually"

function startSecureITAMScript{
	
try{

start-process powershell $pathScripts"secureITAMWebService.ps1"


}


##need to add a catch to the web request incase it fails, else it closes instantly. Either that or a pause.


catch {}

}





function startTrustStoreScript{

try{



#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"addToTruststore.ps1"


}

catch{}

}



function startTrustStoreScriptManual{

try{



#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"addToTruststore.ps1 manual"


}

catch{}

}










## AGENT PASSWORD CHANGE ##


function startAgentPwd{

try{


#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"updateAgentPwd.ps1"


}

catch{}

}


function startDataRest{

try{


#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"addDataAtRest.ps1"


}

catch{}

}







function startServices{

try{

#Getting the SapphireIMS paths,setting log folder paths and deployments to check for war file status:





$filesWar=Get-ChildItem -Path $itomPathWarfiles -Exclude "*.war","*.txt" | select LastWriteTime, Name | Out-String



#Missing adding manual option
#Read-host "Manual or importing certificate?"


$serviceSapphire=Get-Service -name "SapphireMySQL"

if ($serviceSapphire.status -eq "Stopped"){
	
	
	Start-service "SapphireMySQL"
	Write-Host "started SapphireMySQL"
}

else {
	
	stop-service "SapphireMySQL"
	Write-Host "stopping service"
}


$serviceSapphire=Get-Service -name "SapphireMySQL"
$title3.text=$serviceSapphire.Name+ " is currently "+$serviceSapphire.status
$title4.text=$filesWar
}

catch{}

}






##Loading UI.

try{
	
	
	
	$main_form.ShowDialog()
	
}

catch{}


