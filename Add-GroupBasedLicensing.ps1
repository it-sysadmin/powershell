foreach ($u in Import-Csv c:\temp\users.csv) {
    #Tidy switches up by giving them a variable name
    $groupCommand = switch ($u.o365)
    #$groupCommand = switch ($u)
    {
        # {($u.o365 -eq 'y') -or ($u.exch -eq 'y')} {'Add-ADGroupMember'}
        # {($u.o365 -eq 'n') -or ($u.exch -eq 'n')} {'Remove-ADGroupMember'}
        Y {'Add-ADGroupMember'}
        N {'Remove-ADGroupMember'}
    }

    #Tidy switches up by giving them a variable name
    $Grp = switch ($u.site)
    {
        M   { 'm_licensing' }
        U   { 'u_licensing' }
        REM { 'rem_licensing' }
    }

    $Group = @{
        Identity = $Grp
        Members  = $u.sam
        Confirm  = $false
    }

    # the call operator allows you to push the command name into a variable; eg. $cmd = 'get-process'; & $cmd
    # this does away w/ two separate cmd calls and also resolves the inheritance issue (see orig code below)
    & $groupCommand @Group
}

<#
CSV should look like:

sam,o365,site
x1,y,m
x2,y,m
x3,y,u
x4,y,u
x5,n,rem
x6,n,rem

#>

<#
Original code looked like:

$o365 = (import-csv c:\temp\users.csv).o365
$site = (import-csv c:\temp\users.csv).site

foreach ($u in (import-csv c:\temp\users.csv).sam) {

    switch ($o365)
        {
            Y  { $365Add = Add-ADGroupMember }
            N  { $365Rem = Remove-ADGroupMember }
        }

    switch ($site)
        {
            M   { $Grp = 'umdoitmstlicensing' }
            UM  { $Grp = 'umdoitstudents' }
        }

    $grpRemove = @{
        Identity = $Grp
        Members = $u
    }

    $grpAdd = @{
        Identity = $Grp
        Members = $u
    }

    $365Add @grpAdd
    $365Rem @grpRemove
}

#>