# bootstrap DNVM into this session. 
&{$Branch='dev';iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.ps1'))}

# load up the global.json so we can find the DNX version 
$globalJson = Get-Content -Path $PSScriptRoot\global.json -Raw -ErrorAction Ignore | ConvertFrom-Json -ErrorAction Ignore

if($globalJson) 
{ 
    $dnxVersion = $globalJson.sdk.version 
} 
else 
{ 
    Write-Warning "Unable to locate global.json to determine using 'latest'" 
    $dnxVersion = "latest" 
}

# install DNX 
& $env:USERPROFILE\.dnx\bin\dnvm install $dnxVersion -Persistent

# run DNU restore on all project.json files 
& dnu restore $PSScriptRoot\src\CD\project.json 2>1