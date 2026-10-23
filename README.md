# Spectacle Apple Silicon ver 1.0 — 맥 창 배치·화면 분할

**Spectacle Apple Silicon**은 원본 [Spectacle](https://github.com/eczarny/spectacle)을 Apple Silicon 맥에서 **Rosetta 없이 arm64 네이티브로 실행**하도록 수정한 비공식 버전입니다. 스펙타클의 단축키 창 배치, 화면 분할, 다중 모니터 이동, 되돌리기 기능과 기존 설정 형식을 유지합니다.

[버전 1.0 다운로드](https://github.com/gornoba/spectacle-apple-silicon/releases/tag/v1.0) · [릴리스 목록](https://github.com/gornoba/spectacle-apple-silicon/releases) · [검증 내역](docs/apple-silicon-validation.md)

## 출처와 프로젝트 관계

- 원작: **Eric Czarny와 Spectacle 기여자들**, [eczarny/spectacle](https://github.com/eczarny/spectacle).
- 기반 소스: 원본의 [`e75c341`](https://github.com/eczarny/spectacle/commit/e75c341). 공식 Spectacle 1.2 이후 master 코드입니다.
- Apple Silicon 전환 및 이 저장소 관리: [gornoba](https://github.com/gornoba).
- 원본의 **MIT 라이선스와 저작권 표시를 유지**합니다. [LICENSE.md](LICENSE.md), [NOTICE.md](NOTICE.md)를 참고하세요.

원작자의 공식 업데이트가 아닙니다. **ver 1.0은 이 Apple Silicon 전환 프로젝트의 첫 버전**으로, 원본의 버전 번호와 별도로 관리합니다. 이전 개발 검증본의 표시 버전은 1.3.0이었습니다. 새 저장소는 첫 커밋부터 시작하지만 원본 소스의 출처와 기여는 그대로 인정합니다.

## 지원 환경과 변경 사항

| 항목 | 내용 |
|---|---|
| CPU | Apple Silicon / arm64 전용. Intel 맥은 지원하지 않습니다. |
| 운영체제 | 빌드 기준 macOS 13 이상. 실측 환경은 Apple M2 · macOS 26.6.2입니다. |
| 배포 파일 | `spectacle_apple_silicon_ver_1.0.zip` |
| 압축 해제 결과 | `Spectacle.app` 하나. 별도 설치 프로그램 없이 응용 프로그램 폴더로 옮깁니다. |
| 업데이트 | 앱 내 자동 업데이트를 제거했습니다. 새 ZIP으로 수동 교체합니다. |
| 로그인 실행 | `SMAppService` 사용. `/Applications/Spectacle.app`에서 설정합니다. |
| 서명 | ad-hoc 로컬 서명. **Developer ID 서명·Apple 공증은 적용되지 않았습니다.** |

기존 Objective-C·AppKit 화면과 창 계산 구조를 유지하면서 arm64 빌드, 로그인 API, XCTest 테스트 및 최신 AppKit의 설정 화면 그리기 문제를 정리했습니다. macOS 13 실기기 실행과 실제 로그아웃 후 자동 실행은 아직 검증하지 않았습니다. 다른 Apple Silicon 칩과 미래 macOS의 동작도 별도 확인이 필요합니다.

## 다운로드와 설치

1. [Releases](https://github.com/gornoba/spectacle-apple-silicon/releases)에서 `spectacle_apple_silicon_ver_1.0.zip`을 받습니다. 자동 생성되는 **Source code (zip)**은 빌드된 앱이 아니라 소스 코드입니다.
2. 기존 Spectacle이 있다면 앱과 설정을 백업하고 정상 종료합니다. 두 버전의 동시 실행을 피하세요.
3. ZIP을 풀고 `Spectacle.app`을 **응용 프로그램(`/Applications`)** 폴더로 옮깁니다. 기존 앱 교체 전에는 백업을 확인하세요.
4. `/Applications/Spectacle.app`을 실행합니다.
5. **시스템 설정 → 개인정보 보호 및 보안 → 손쉬운 사용**에서 Spectacle의 접근성 권한을 켭니다. 항목 이름은 macOS 버전에 따라 다를 수 있습니다.
6. 빈 TextEdit 창에서 단축키로 창이 움직이는지 확인합니다.

공증되지 않은 앱이므로 다운로드한 파일을 macOS가 차단할 수 있습니다. 출처를 확인한 뒤 [Apple의 공식 앱 보안 안내](https://support.apple.com/ko-kr/102445)를 따르세요. 보안 설정을 전체 해제하는 명령은 설치에 사용하지 않습니다. Developer ID 서명·공증이 필요한 조직이나 기기에서는 이 배포본을 사용할 수 없을 수 있습니다.

### 접근성을 켰는데 창이 움직이지 않을 때

원본 앱이나 이전 빌드의 권한이 새 서명에는 적용되지 않을 수 있습니다. 사용자가 시스템 설정의 기존 Spectacle 항목을 제거한 뒤 **현재 `/Applications/Spectacle.app`을 다시 추가하고 허용**하면 해결되는지 확인하세요. 이 권한은 다른 앱의 창 위치와 크기를 바꾸는 데 필요합니다.

## 사용 방법과 기본 단축키

배치할 창을 클릭한 다음 단축키를 누릅니다. 메뉴 막대의 Spectacle 아이콘에서 설정과 창 배치 메뉴를 열 수 있습니다. 표는 **새로 설치했을 때의 기본값**입니다. 기존 설정이 있으면 저장된 사용자 단축키가 우선합니다.

| 기능 | 기본 단축키 |
|---|---|
| 가운데 / 최대화 | `Option + Command + C` / `Option + Command + F` |
| 왼쪽 / 오른쪽 절반 | `Option + Command + ←` / `Option + Command + →` |
| 위 / 아래 절반 | `Option + Command + ↑` / `Option + Command + ↓` |
| 왼쪽 위 / 오른쪽 위 | `Control + Command + ←` / `Control + Command + →` |
| 왼쪽 아래 / 오른쪽 아래 | `Control + Shift + Command + ←` / `Control + Shift + Command + →` |
| 다음 / 이전 모니터 | `Control + Option + Command + →` / `Control + Option + Command + ←` |
| 다음 / 이전 3분할 영역 | `Control + Option + →` / `Control + Option + ←` |
| 창 크게 / 작게 | `Control + Option + Shift + →` / `Control + Option + Shift + ←` |
| 되돌리기 / 다시 실행 | `Option + Command + Z` / `Option + Shift + Command + Z` |

- **크기 순환:** 절반·모서리 배치 단축키를 반복하면 해당 영역에서 1/2·2/3·1/3 크기로 순환합니다.
- **단축키 변경:** 설정의 입력칸을 클릭하고 원하는 키 조합을 누릅니다. 할당을 지우면 비울 수 있으며, Undo·Redo는 메뉴에서도 사용할 수 있습니다.
- **로그인 시 실행:** 설치본 설정의 `Launch Spectacle at login`을 켭니다. 승인 대기라면 시스템 설정의 로그인 항목에서 허용합니다. 등록과 다음 로그인에서 실제 실행되는지는 별도로 확인하세요.
- **창 크기 제한:** 일부 앱은 최소 크기를 제한합니다. Terminal 등은 글자 행·열 단위로 조정되어 정확한 절반 크기와 조금 다를 수 있습니다.

## 기존 설정 유지와 복구

앱 식별자 `com.divisiblebyzero.Spectacle`과 기존 저장 형식을 유지합니다.

```text
~/Library/Application Support/Spectacle/Shortcuts.json
~/Library/Preferences/com.divisiblebyzero.Spectacle.plist
```

교체 전 위 설정과 기존 `Spectacle.app`을 백업하세요. 문제가 생기면 새 앱을 종료하고 기존 앱으로 복원합니다. 설정 복원은 두 앱이 모두 종료된 상태에서 진행하고, 로그인 항목·접근성 권한이 복원한 앱을 가리키는지 확인하세요. 재빌드로 서명이 바뀌면 접근성 재승인이 필요할 수 있습니다.

## 소스 빌드와 검사

Xcode의 macOS SDK와 Python 3가 필요합니다. Carthage나 외부 테스트 라이브러리 설치는 필요하지 않습니다.

```sh
git clone https://github.com/gornoba/spectacle-apple-silicon.git
cd spectacle-apple-silicon
./scripts/test-arm64.sh
./scripts/build-arm64.sh
```

결과물은 `build/apple-silicon/Spectacle.app`과 `build/apple-silicon/spectacle_apple_silicon_ver_1.0.zip`입니다. ZIP에는 라이선스를 내부에 포함한 앱 하나만 들어갑니다. 빌드 스크립트는 모든 Mach-O의 arm64, 버전·최소 OS, 라이브러리 연결, 서명과 ZIP 압축 해제 결과를 검사하며 설치 앱을 교체하거나 실행하지 않습니다.

XCTest는 사용자 단축키·권한·로그인 항목을 변경하지 않는 독립 테스트 번들에서 실행됩니다. [테스트 대응표](docs/test-migration.md), [검증 결과](docs/apple-silicon-validation.md)를 참고하세요.

## GitHub 릴리스 게시

저장소 이름·설명·Topics와 ZIP 업로드 절차는 [한국어 게시 안내](docs/publishing.md)에, 첫 릴리스 설명은 [v1.0 릴리스 노트](docs/releases/v1.0.md)에 정리했습니다.
