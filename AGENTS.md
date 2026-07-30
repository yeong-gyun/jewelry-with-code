# 프로젝트 개발 규칙

이 저장소는 GitHub와 Cloudflare Pages로 배포하는 주얼리 견적 서비스입니다.

## 파일 배치

- HTML 페이지: 루트 또는 `pages/`
- CSS: `css/`
- JavaScript: `js/`
- 정적 이미지와 아이콘: `images/`
- 프로젝트 및 운영 문서: `docs/`
- AI 프롬프트: `prompts/`
- Cloudflare Pages Functions: `functions/api/`
- 테스트: `tests/`

## 구현 원칙

- 모바일 우선, 반응형, 키보드 접근성을 기본으로 합니다.
- HTML에 인라인 CSS 또는 JavaScript를 추가하지 않습니다.
- 공통 디자인 값은 `css/style.css`의 CSS 사용자 지정 속성으로 관리합니다.
- 결제 비밀키, API 키, 개인정보를 코드나 Git에 저장하지 않습니다.
- 클라이언트가 보낸 가격과 결제 상태를 신뢰하지 않습니다.
- 사용자 업로드 이미지는 Git 저장소가 아닌 R2 등 별도 객체 저장소에 보관합니다.
- 실제 결제 기능은 서버 승인, 웹훅 검증, 중복 처리 방지를 갖춘 뒤 활성화합니다.
- 새 기능을 만들 때 관련 문서와 테스트도 함께 갱신합니다.

## 배포

- 기능 브랜치에서 작업하고 Pull Request 미리보기로 검증합니다.
- `main`은 운영 배포 브랜치입니다.
- 민감한 환경 변수는 Cloudflare의 암호화된 Secret으로 관리합니다.
