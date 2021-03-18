Import-Module ActiveDirectory

$c = 0
Import-Csv -Path C:\tmp\data_10.csv -Delimiter ';' |
foreach {
    #$name = $_.fio.Trim()
    $name = $_.fio_short.Trim()
    $department = $_.department.Trim()
    $title  = $_.title.Trim()
    $l = $_.l.Trim()
    $streetAddress = $_.streetAddress.Trim()
    $telephoneNumber = $_.telephoneNumber.Trim()
    $mail = $_.mail.Trim()
    $mobile = $_.mobile.Trim()

    #Write-Host "$name -> $department -> $title -> $l -> $streetAddress -> $telephoneNumber -> $mail -> $mobile ..."
    
    $search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
    $search.filter = “(&(objectClass=user)(displayName=$name))”
    $results = $search.Findall()

    if (! $results.length)
    { 
        $c++
        #throw "User not found: " + $name
        #if ($c -gt 50) { Write-Host $c ": User not found: " $name }
        #if ($c.Equals(70) ) {break}
        Write-Host $c ": User not found: " $name
    }
    if ( $results.length > 1)
    {
        #throw "More than one user found: " + $name 
        Write-Host "More than one user found: " $name 
    }
    foreach($result in $results){
        $DN = $result.GetDirectoryEntry().DistinguishedName[0]
        write-host "$DN"
        if($department)        { Set-ADUser -Identity $DN -Department $department }
        if($title)             { Set-ADUser -Identity $DN -Title $title }
        if($l)                 { Set-ADUser -Identity $DN -City  $l }
        if($streetAddress)     { Set-ADUser -Identity $DN -StreetAddress  $streetAddress }
        if($telephoneNumber)   { Set-ADUser -Identity $DN -OfficePhone $telephoneNumber }
        if($mail)              { Set-ADUser -Identity $DN -EmailAddress $mail }
        if($mobile)            { Set-ADUser -Identity $DN -MobilePhone $mobile }
        
#        if($phone_ext)    { Set-ADUser -Identity $DN -HomePhone $phone_ext }
#        if($room)         { Set-ADUser -Identity $DN -Office $room }
#        if($bday)         { Set-ADUser -Identity $DN -Description $bday }
#        if($kmail)        { Set-ADUser -Identity $DN -HomePage $kmail }
    }
}