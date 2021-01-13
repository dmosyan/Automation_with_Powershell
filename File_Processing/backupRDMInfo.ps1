$tempPath = ""
$exeFile = ""
$rdmCsv = ""

$rdgFile = "C:\Users\$env:UserName\Documents\RDCM"
$fileNames = Get-ChildItem -Path $rdgFile | Select-Object -ExpandProperty Name | ForEach-Object -Process {[System.IO.Path]::GetFileNameWithoutExtension($_)}

foreach ($file in $fileNames) {
    $fullPath = "$tempPath\$file.xml"
    Copy-Item $rdgFile $fullPath
    
    [System.Xml.XmlDocument]$xml = Get-Content -Path $fullPath
    Copy-Item $exeFile 'C:\temp\RDCMan.dll'
    Import-Module 'C:\temp\RDCMan.dll'
    
    $vms = $xml.RDCMan.file.group.server.properties
    $vmsCount = $xml.RDCMan.file.group.server.properties.count
    $creds = $xml.RDCMan.file.group.server.logonCredentials
    
    $newcsv = {} | Select-Object "ServerDisplayName", "ServerName", "UserName", "Password", "Comment" | Export-Csv $rdmCsv
    $csvfile = Import-Csv $rdmCsv

    for ($i = 0; $i -lt $vmsCount; $i++) {

        $vmDisplayName = $vms[$i].displayName
        $vmLogin = $creds[$i].userName
        $vmPass = $creds[$i].password
        $vmName = $vms[$i].name
        $vmComment = $vms[$i].comment
    
        $EncryptionSettings = New-Object -TypeName RdcMan.EncryptionSettings
        $decryptedPass = [RdcMan.Encryption]::DecryptString($vmPass, $EncryptionSettings)
    
        try 
        {
            $csvfile.ServerDisplayName = $vmDisplayName
            $csvfile.UserName = $vmLogin
            $csvfile.Password = $decryptedPass
            $csvfile.ServerName = $vmName
            $csvfile.Comment = $vmComment
    
            $csvfile | Export-Csv -Path $rdmCsv -Append
        }
        catch 
        {
            throw $_.Exception
            break
        }
    }
    Write-Host("Finished adding the information into the $file")
}










