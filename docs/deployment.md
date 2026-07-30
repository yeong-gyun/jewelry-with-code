# 배포 가이드

## Cloudflare Pages

- Production branch: `main`
- Build command: 비워 둠
- Build output directory: `/`
- Root directory: `/`

GitHub 저장소를 Pages에 연결하면 브랜치와 Pull Request마다 미리보기 배포가 생성됩니다.

## 도메인 연결 전 확인

- `robots.txt`, `sitemap.xml`, `ads.txt`의 실제 도메인 반영
- 사업자 정보 및 고객센터 정보 입력
- 개인정보처리방침과 약관 법률 검토
- 운영 및 미리보기 환경 변수 분리
- 결제 테스트 키와 운영 키 분리

## 로컬 확인

VS Code Live Server 또는 간단한 정적 HTTP 서버로 루트의 `index.html`을 엽니다.
`file://` 주소보다 HTTP 서버 사용을 권장합니다.
