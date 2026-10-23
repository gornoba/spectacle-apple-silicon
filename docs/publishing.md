# Spectacle Apple Silicon ver 1.0 게시 안내

## GitHub 새 저장소에 입력할 값

| 항목 | 값 |
|---|---|
| Owner | `gornoba` |
| Repository name | `spectacle-apple-silicon` |
| Description | `Spectacle Apple Silicon: native arm64 macOS window manager. 스펙타클 애플 실리콘 버전 — 단축키 창 배치·화면 분할·다중 모니터 지원.` |
| Visibility | `Public` — 검색엔진이 볼 수 있는 공개 저장소 |
| README / .gitignore / License 자동 추가 | 모두 선택하지 않음. 로컬 첫 커밋에 이미 포함되어 있습니다. |

생성 후 About 옆 톱니바퀴에서 다음 Topics를 추가하세요.

```text
spectacle, apple-silicon, macos, arm64, window-manager, window-management, keyboard-shortcuts, objective-c
```

프로젝트명·설명·README 제목과 첫 문단에 검색자가 사용하는 `Spectacle Apple Silicon`을 자연스럽게 포함했습니다. Topics는 GitHub 내 분류·탐색에 쓰입니다. Google 노출 여부·순위·시점은 보장되지 않으며, 공개 후 Google의 수집·색인이 필요합니다. GitHub가 렌더링하는 README에서 HTML 메타 태그를 넣어 검색 순위를 보장할 수는 없습니다.

## 첫 커밋과 태그 올리기

새 저장소를 **빈 저장소**로 만든 후 이 프로젝트 폴더에서 실행합니다. `origin`은 위 저장소 주소로 준비되어 있습니다.

```sh
git push -u origin main
git push origin v1.0
```

기존 Git 이력은 프로젝트 밖에 백업하고 새 `main`의 첫 커밋부터 시작했습니다. 기존 원본 저장소에 push하거나 강제 push하는 절차가 아닙니다.

## 웹에서 ZIP을 Release에 올리기

1. 새 저장소의 **Releases → Draft a new release**로 이동합니다.
2. **Choose a tag**에서 `v1.0`을 선택합니다. 위 태그 push를 하지 않았다면 `v1.0` 태그를 `main` 대상으로 생성합니다.
3. **Release title:** `Spectacle Apple Silicon ver 1.0`.
4. **Describe this release:** [릴리스 노트](releases/v1.0.md)의 내용을 복사합니다.
5. 첨부 영역에 `build/apple-silicon/spectacle_apple_silicon_ver_1.0.zip`을 드래그합니다. 필요하면 같은 폴더의 `.zip.sha256` 파일도 올립니다.
6. 파일 이름·업로드 완료·서명 및 공증 안내를 확인하고 **Publish release**를 누릅니다. 검토가 더 필요하면 **Save draft**로 보관합니다.
7. 공개된 **Assets**에서 업로드한 ZIP을 다시 받아 파일 이름과 SHA-256을 확인합니다. 자동 생성되는 `Source code (zip)`은 실행 앱이 아닙니다.

ZIP 내부 최상위는 `Spectacle.app` 하나이며, 원본 MIT 라이선스는 앱 리소스 안에 들어 있습니다. 테스트·사용자 설정·백업·Git 이력은 ZIP에 포함하지 않습니다.

## GitHub CLI로 게시하기

위에서 소스와 태그를 push한 뒤 아래 명령 하나로 Release 생성과 ZIP 업로드를 함께 할 수도 있습니다. 이 명령을 실행하면 외부에 공개됩니다.

```sh
gh release create v1.0 build/apple-silicon/spectacle_apple_silicon_ver_1.0.zip build/apple-silicon/spectacle_apple_silicon_ver_1.0.zip.sha256 --repo gornoba/spectacle-apple-silicon --verify-tag --title 'Spectacle Apple Silicon ver 1.0' --notes-file docs/releases/v1.0.md
```

먼저 초안만 만들려면 `--draft`를 추가합니다. 이미 같은 태그의 Release가 있다면 새로 만들지 말고 기존 Release의 첨부 파일을 확인하세요.

## 배포 상태와 한계

이 ZIP은 ad-hoc 서명된 비공식 빌드입니다. Developer ID 서명·Apple 공증·다른 사용자의 Mac에서의 설치 성공까지 검증된 배포본은 아닙니다. 다운로드 후 보안 경고나 접근성 재승인이 필요할 수 있습니다. 유료 개발자 계정·인증서·공증은 별도 준비이며 이 작업에서 도입하지 않았습니다.

## 공식 참고 자료

- [GitHub Release 생성 및 파일 첨부](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
- [GitHub Topics 설정](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/classifying-your-repository-with-topics)
- [Google 검색 기본 사항](https://developers.google.com/search/docs/essentials)
- [Google 수집·색인 FAQ](https://developers.google.com/search/help/crawling-index-faq)
