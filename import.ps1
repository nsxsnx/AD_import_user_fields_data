Import-Csv -Path .\data.csv |
foreach {
    $name = $_.fio.Trim()
    $phone_main = $_.main.Trim()
    $phone_ext  = $_.ext.Trim()
    $phone_mobile = $_.mobile.Trim()
    $room = $_.room.Trim()
    $title = $_.title.Trim()
    $bday = $_.bday.Trim()
    $kmail = $_.kmail.Trim()

    Write-Host "$name -> $title -> $bday -> $phone_main -> $phone_ext -> $phone_mobile -> $room -> $kmail ..."

    $search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
    $search.filter = “(&(objectClass=user)(displayName=$name))”
    $results = $search.Findall()

    if (! $results.length) { throw "User not found" }
    if ( $results.length > 1) { throw "More than one user found" }
    foreach($result in $results){
        $DN = $result.GetDirectoryEntry().DistinguishedName[0]
        write-host "$DN"
        if($phone_ext)    { Set-ADUser -Identity $DN -HomePhone $phone_ext }
        if($phone_mobile) { Set-ADUser -Identity $DN -MobilePhone $phone_mobile }
        if($phone_main)   { Set-ADUser -Identity $DN -OfficePhone $phone_main }
        if($room)         { Set-ADUser -Identity $DN -Office $room }
        if($title)        { Set-ADUser -Identity $DN -Title $title }
        if($bday)         { Set-ADUser -Identity $DN -Description $bday }
        if($kmail)        { Set-ADUser -Identity $DN -HomePage $kmail }
    }
}