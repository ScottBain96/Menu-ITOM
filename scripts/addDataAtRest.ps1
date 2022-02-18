##Validating if server meets requirements for data at rest and finding the MySQL installation"


$checkSoftwareSettings= Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Tecknodreams\Sapphire-IMS" -ErrorAction SilentlyContinue


$type
$customerSchema
$imsSchema="ims"

#default value

$MySQLServiceName="SapphireMySQL"

if ($checkSoftwareSettings.MySQLServer -eq "1") {


    if ($checkSoftwareSettings.InstallType -eq "MSPServer"){

        Write-Host "MSP Central server with local MySQL"
        $type="localDBCentral"
        $customerSchema=Read-Host "Enter customer schema to encrypt"
        $customerSchema
    }
    elseif ($checkSoftwareSettings.InstallType -eq "MSPProbe"){
    
        Write-Host "Probe with local database"
        $type="localDBProbe"
    }

    

}


Else {
   
   Write-Host "Remote database set up detected"
   Write-Host "`nAs there can be multiple MySQL installations, please confirm manually"
   Write-Host "`nSearching for services that include MySQL in their name"
   Write-Host "`nFound the following *MySQL* services:"  
   Get-Service -Name "*MySQL*"

   $MySQLServiceName = Read-host "`nEnter the specific MySQL service name"

  

   $type="remoteDB"

   Write-Host "`nData at rest will be applied to: "$MySQLServiceName



}



$checkMySQLPath= Get-ItemProperty -Path "HKLM:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\$MySQLServiceName" -ErrorAction SilentlyContinue


$pathSQL = $checkMySQLPath.ImagePath


#Splitting paths, Setting MySQL exe location.

$pos = $pathSQL.IndexOf("mysqld.exe")
$leftPart = $pathSQL.Substring(0, $pos)
$rightPart = $pathSQL.Substring($pos+1)
$MySQLExe
$MySQLExe=$leftPart.Trim("""");


$creds = Get-Credential
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($creds.Password)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
$username = $creds.Username


$sc="test"

$fileScript="test.sql"
$pathDataRestScripts="$pwd\DataRest\5006\"+$fileScript



try{

& $MySQLExe"mysql" -u"$username" -p"$password" $sc -e "source $pathDataRestScripts"
& $MySQLExe"mysql" -u"$username" -p"$password" $sc -e "source $pathDataRestScripts"



}

catch{


}