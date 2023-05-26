$GpoNames = @(
    "Your GPO Name"
    # If you want to add multiple GPO names :
    # "Your first GPO Name",
    # "Your second GPO Name"
)

foreach ($GpoName in $GpoNames) {

    if (-not (Get-GPO -Name $GpoName -ErrorAction SilentlyContinue)) {
        $Gpo = New-GPO -Name $GpoName
        Write-Host "The GPO $GpoName has been created"
    }
    else {
        Write-Host "The GPO '$GpoName' already exists ! Go check it out"
    }
}
