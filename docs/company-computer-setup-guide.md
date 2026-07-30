# 회사 컴퓨터에서 GitHub 자동 동기화 설정 가이드

이 문서는 회사 컴퓨터에서 이 프로젝트를 같은 방식으로 사용하기 위한 설정 순서를 정리한 문서입니다.

## 1. 준비 사항
- Git 설치
- GitHub 계정 로그인 가능 상태
- 이 저장소의 GitHub URL

저장소 URL:
- https://github.com/yeong-gyun/jewelry-with-code.git

## 2. 로컬 폴더 준비
회사 컴퓨터에서도 다음 경로처럼 로컬 폴더를 만들고 저장소를 클론합니다.

```powershell
mkdir C:\dev
cd C:\dev
git clone https://github.com/yeong-gyun/jewelry-with-code.git
```

## 3. Git 사용자 정보 설정
```powershell
git config --global user.name "yeong-gyun"
git config --global user.email "yeonggyun@example.com"
```

## 4. 자동 업로드용 스크립트 준비
다음 스크립트를 저장소의 tools 폴더에 저장합니다.

파일: tools/auto-sync-to-github.ps1

```powershell
param(
    [string]$RepoPath = "C:\dev\jewelry-with-code",
    [int]$IntervalSeconds = 5
)

$ErrorActionPreference = 'Continue'
$logPath = Join-Path $RepoPath 'auto-sync.log'

while ($true) {
    try {
        $status = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath status --porcelain --untracked-files=all 2>$null
        if ($status -and $status.ToString().Trim()) {
            $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            Add-Content -Path $logPath -Value "[$timestamp] changes detected"
            & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath add -A | Out-Null
            $message = "chore: auto-sync $timestamp"
            $commitOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath commit -m $message 2>&1
            $pushOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath push origin main 2>&1
            Add-Content -Path $logPath -Value ($commitOutput | Out-String)
            Add-Content -Path $logPath -Value ($pushOutput | Out-String)
        }
    }
    catch {
        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Add-Content -Path $logPath -Value "[$timestamp] error: $($_.Exception.Message)"
    }

    Start-Sleep -Seconds $IntervalSeconds
}
```

## 5. 자동 pull용 스크립트 준비
파일: tools/auto-pull-and-sync.ps1

```powershell
param(
    [string]$RepoPath = "C:\dev\jewelry-with-code",
    [int]$IntervalSeconds = 10
)

$ErrorActionPreference = 'Continue'
$logPath = Join-Path $RepoPath 'auto-pull.log'

while ($true) {
    try {
        $fetchOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath fetch origin main 2>&1
        $statusOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath status -sb 2>&1

        if ($statusOutput -match '\[ahead|behind|diverged]') {
            & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath pull --ff-only origin main 2>&1 | Out-Null
        }

        Add-Content -Path $logPath -Value ("[{0}] fetch/pull checked" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
    }
    catch {
        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Add-Content -Path $logPath -Value ("[{0}] error: {1}" -f $timestamp, $_.Exception.Message)
    }

    Start-Sleep -Seconds $IntervalSeconds
}
```

## 6. 실행 방법
```powershell
$repoPath = 'C:\dev\jewelry-with-code'
$scriptPath = Join-Path $repoPath 'tools\auto-sync-to-github.ps1'
Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File', $scriptPath -WindowStyle Hidden

$scriptPath2 = Join-Path $repoPath 'tools\auto-pull-and-sync.ps1'
Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File', $scriptPath2 -WindowStyle Hidden
```

## 7. 회사 컴퓨터에서 바로 적용할 때의 문장
회사 컴퓨터에서 이 문서를 보고 바로 실행하면 됩니다.

"회사 컴퓨터에서도 이 프로젝트를 GitHub와 연결해서, 내가 수정한 내용이 자동으로 GitHub에 반영되고, GitHub의 최신 내용도 자동으로 내 로컬 폴더에 반영되도록 설정해줘."
