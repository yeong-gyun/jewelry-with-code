param(
    [string]$RepoPath = "C:\dev\jewelry-with-code",
    [int]$IntervalSeconds = 10
)

$ErrorActionPreference = 'Continue'

while ($true) {
    try {
        $status = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath status --porcelain --untracked-files=all 2>$null
        if ($status -and $status.ToString().Trim()) {
            & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath add -A
            $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            $message = "chore: auto-sync $timestamp"
            & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath commit -m $message 2>$null | Out-Null
            & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath push origin main 2>$null | Out-Null
        }
    }
    catch {
        Write-Host ("Auto-sync error: {0}" -f $_.Exception.Message)
    }

    Start-Sleep -Seconds $IntervalSeconds
}
