param (
    [string]$serviceUser,
    [string]$servicePass
)

Function Set-ServiceAcctCreds([string]$strCompName,[string]$strServiceName,[string]$newAcct,[string]$newPass){
  $filter = 'Name=' + "'" + $strServiceName + "'" + ''
  $service = Get-WMIObject -ComputerName $strCompName -namespace "root\cimv2" -class Win32_Service -Filter $filter
  $service.Change($null,$null,$null,$null,$null,$null,$newAcct,$newPass)
  $service.StopService()
  while ($service.Started){
    sleep 2
    $service = Get-WMIObject -ComputerName $strCompName -namespace "root\cimv2" -class Win32_Service -Filter $filter
  }
  $service.StartService()
}

Set-ServiceAcctCreds -strCompName "." -strServiceName "chef-client" -newAcct $serviceUser -newPass $servicePass
