#Requires -Version 3

[CmdletBinding()]
param(    
)

if ((git remote) -notcontains "official") {
    Write-Verbose -Message "Creating remote for official depot"
    git remote add --tags official https://github.com/Crypt32/PSPKI.git
    git fetch official
}

$branches = git branch --list
$branches = (,$branches) | ForEach-Object -Process { $_.Substring(2) }
if ($branches -notcontains "official") {
    Write-Verbose -Message "Creating local branch official to track official depot"
    git branch --track official official/master
}
