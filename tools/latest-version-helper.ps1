param(
    [string]$RepoPath = "C:\dev\jewelry-with-code",
    [switch]$OpenSite
)

$ErrorActionPreference = 'Continue'

$git = 'C:\Program Files\Git\cmd\git.exe'

& $git -C $RepoPath fetch origin main 2>$null | Out-Null
& $git -C $RepoPath pull --ff-only origin main 2>$null | Out-Null

if ($OpenSite) {
    $indexPath = Join-Path $RepoPath 'index.html'
    if (Test-Path $indexPath) {
        Start-Process $indexPath
    }
}

Write-Output 'Latest version synced from GitHub.'
