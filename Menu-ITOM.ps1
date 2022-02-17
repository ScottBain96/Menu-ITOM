
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='ITOM additional features launcher'
$main_form.BackColor = "#ffffff"
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



#$btnSecureITAM.FlatStyle = "Flat"
#$btnSecureITAM.FlatAppearance.Bordersize=10
#$btnSecureITAM.FlatStyle ="Standard"



##Second BUTTON - TrustStore###
$btnTrustStore                   = New-Object system.Windows.Forms.Button
$btnTrustStore.BackColor         = "#82b0fa"
$btnTrustStore.text              = "Add SSL to TrustStore"
$btnTrustStore.width             = 90
$btnTrustStore.height            = 60
$btnTrustStore.location          = New-Object System.Drawing.Point(110,100)
$btnTrustStore.Font              = 'Microsoft Sans Serif,10'
$btnTrustStore.ForeColor         = "#ffffff"
$btnTrustStore.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnTrustStore.FlatAppearance.BorderSize = 0.8
$btnTrustStore.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnTrustStore.TabStop=$false




##Third BUTTON - Agent Password###
$btnAgentPwd                   = New-Object system.Windows.Forms.Button
$btnAgentPwd.BackColor         = "#82b0fa"
$btnAgentPwd.text              = "Secure Agent WebService"
$btnAgentPwd.width             = 90
$btnAgentPwd.height            = 60
$btnAgentPwd.location          = New-Object System.Drawing.Point(210,100)
$btnAgentPwd.Font              = 'Microsoft Sans Serif,10'
$btnAgentPwd.ForeColor         = "#ffffff"
$btnAgentPwd.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAgentPwd.FlatAppearance.BorderSize =0.8
$btnAgentPwd.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnAgentPwd.TabStop=$false


##FORTH BUTTUN - ALL ###

##Third BUTTON - Agent Password###
$btnAllSecurityConfig                   = New-Object system.Windows.Forms.Button
$btnAllSecurityConfig.BackColor         = "#82b0fa"
$btnAllSecurityConfig.text              = "PlaceHolder"
$btnAllSecurityConfig.width             = 90
$btnAllSecurityConfig.height            = 60
$btnAllSecurityConfig.location          = New-Object System.Drawing.Point(310,100)
$btnAllSecurityConfig.Font              = 'Microsoft Sans Serif,10'
$btnAllSecurityConfig.ForeColor         = "#ffffff"
$btnAllSecurityConfig.Margin = 10
$btnAllSecurityConfig.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAllSecurityConfig.FlatAppearance.BorderSize = 0.8
$btnAllSecurityConfig.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnAllSecurityConfig.TabStop=$false


#not sure if multiple can be added in a single line, to check at some point.


$main_form.Controls.Add($btnSecureITAM)
$main_form.Controls.Add($btnTrustStore)
$main_form.Controls.Add($btnAgentPwd)
$main_form.Controls.Add($btnAllSecurityConfig)
$main_form.Controls.Add($title)
$main_form.Controls.Add($title2)



$btnSecureITAM.Add_Click({ startSecureITAMScript })
$btnTrustStore.Add_Click({ startTrustStoreScript })
$btnAgentPwd.Add_Click({ startAgentPwd })
$btnAllSecurityConfig.Add_Click({ startAllSecurityConfig })


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










## AGENT PASSWORD CHANGE ##


function startAgentPwd{

try{


#Missing adding manual option
#Read-host "Manual or importing certificate?"


start-process powershell $pathScripts"updateAgentPwd.ps1"


}

catch{}

}



function startAllSecurityConfig{

try{




#Missing adding manual option
#Read-host "Manual or importing certificate?"



}

catch{}

}









try{
	$main_form.ShowDialog()
	
}

catch{}


