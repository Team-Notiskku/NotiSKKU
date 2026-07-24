# Git Workflow

NotiSKKU는 `develop`을 개발 기준 브랜치로, `master`를 출시 기준 브랜치로 사용한다.

## 브랜치 역할

| 브랜치 | 역할 |
| --- | --- |
| `master` | Play Store 업로드 및 운영 배포 기준 브랜치 |
| `develop` | 기능 개발, 버그 수정, 설정 정리 작업을 모으는 개발 기준 브랜치 |
| `<issue#>-issue-description` | 이슈 단위 작업 브랜치 |

## 기본 원칙

- `master`와 `develop`에는 직접 커밋하지 않는다.
- 모든 작업은 이슈를 기준으로 브랜치를 만든 뒤 PR로 반영한다.
- 일반 작업 PR은 `develop`을 base로 만든다.
- `develop`에 들어가는 일반 작업 PR은 `Squash and merge`를 사용한다.
- 출시 시점에는 검증된 `develop`을 `master`로 반영한다.
- 출시 PR은 커밋 관계를 보존하기 위해 `Create a merge commit`을 사용한다.

## GitHub 저장소 설정

저장소 기본 브랜치는 `develop`으로 설정한다.

```text
default branch: develop
```

브랜치 역할은 다음과 같이 구분한다.

```text
develop: 개발 기준 브랜치
master: Play Store 출시 기준 브랜치
```

Pull Request 머지 옵션은 다음 설정을 권장한다.

| 설정 | 권장 값 | 이유 |
| --- | --- | --- |
| Allow merge commits | On | 출시 PR과 브랜치 동기화 PR에서 커밋 관계 보존 |
| Allow squash merging | On | 일반 이슈 PR을 하나의 커밋으로 정리 |
| Allow rebase merging | Off | 현재 플로우에서 사용하지 않으며 커밋 관계 혼선을 줄이기 위함 |
| Automatically delete head branches | On | PR 머지 후 원격 작업 브랜치 자동 정리 |

PR이 merge되면 원격 작업 브랜치는 자동 삭제될 수 있다. 필요한 작업 기록은 브랜치가 아니라 이슈, PR, 커밋 메시지에 남긴다.

## 작업 흐름

### 1. 이슈 생성

작업 전에 GitHub Issue를 만든다.

예시:

```text
#91 레거시 Google Sheets 연동 및 불필요 앱 asset 정리
```

### 2. `develop` 기준으로 작업 브랜치 생성

```bash
git fetch origin
git switch develop
git pull --ff-only origin develop
git switch -c 91-remove-legacy-google-sheets
```

브랜치 이름은 다음 형식을 사용한다.

```text
<issue#>-issue-description
```

예시:

```text
88-track-google-services
91-remove-legacy-google-sheets
```

### 3. 작업 및 커밋

작업 범위는 해당 이슈에 필요한 변경으로 제한한다.

```bash
git status
git add <changed-files>
git commit -m "chore: remove legacy google sheets asset"
```

### 4. 원격 브랜치 push

```bash
git push -u origin 91-remove-legacy-google-sheets
```

### 5. `develop` 대상 PR 생성

PR 방향은 항상 다음과 같이 설정한다.

```text
base: develop
compare: <issue#>-issue-description
```

PR 본문에는 다음 내용을 포함한다.

- 관련 이슈 번호는 이슈 자동 종료 키워드로 작성
- 변경 요약
- 확인한 테스트 또는 빌드 결과
- 남은 리스크나 후속 작업

관련 이슈는 다음 형식을 사용한다.

```text
Close #91
```

여러 이슈를 함께 닫아야 한다면 각각 명시한다.

```text
Close #91
Close #92
```

### 6. `develop`에 Squash merge

일반 작업 PR은 `Squash and merge`로 `develop`에 반영한다.

Squash commit 메시지는 PR 내용을 대표하도록 정리한다.

예시:

```text
chore: remove legacy google sheets integration (#91)
```

## 출시 흐름

출시 준비가 끝난 뒤 `develop`을 `master`에 반영한다.

### 1. 출시 전 확인

- 앱 버전과 빌드 번호가 올바른지 확인
- Android release build 또는 app bundle build 확인
- Firebase 설정 파일이 실제 앱 ID와 맞는지 확인
- 불필요한 legacy asset이나 secret이 빌드 산출물에 포함되지 않는지 확인
- 주요 기능을 실제 기기 또는 에뮬레이터에서 확인

### 2. `develop`에서 `master`로 release PR 생성

PR 방향은 다음과 같이 설정한다.

```text
base: master
compare: develop
```

제목 예시:

```text
release: 1.0.2
```

### 3. `master`에 Merge commit으로 반영

출시 PR은 `Create a merge commit`을 사용한다.

`Squash and merge`를 사용하면 `develop`과 `master`가 같은 커밋을 공유하지 않게 되어, 이후 PR diff가 불필요하게 커질 수 있다.

## Hotfix 흐름

운영 중 긴급 수정이 필요한 경우에는 `master`에서 hotfix 브랜치를 만든다.

```bash
git fetch origin
git switch master
git pull --ff-only origin master
git switch -c 92-fix-release-build
```

수정 후 `master` 대상 PR을 만들고, 머지 후에는 반드시 `master`를 `develop`에도 반영한다.

```text
base: develop
compare: master
```

이 동기화 PR도 `Create a merge commit`을 사용한다.

## 머지 옵션 기준

| 상황 | 대상 브랜치 | 추천 옵션 |
| --- | --- | --- |
| 일반 이슈 작업 PR | `develop` | `Squash and merge` |
| 출시 PR | `master` | `Create a merge commit` |
| `master` 변경을 `develop`에 동기화 | `develop` | `Create a merge commit` |
| 오래된 브랜치에서 일부 작업만 재사용 | 새 이슈 브랜치 | 필요한 커밋만 cherry-pick 또는 수동 반영 |

## 오래된 브랜치 정리

오래된 feature 브랜치는 직접 머지하지 않는다.

필요한 변경이 남아 있다면 다음 순서로 정리한다.

1. 해당 브랜치가 `master` 또는 `develop`에 이미 포함되었는지 확인한다.
2. 포함되지 않은 커밋 중 필요한 변경만 선별한다.
3. 최신 `develop` 기준 새 이슈 브랜치를 만든다.
4. 필요한 변경만 cherry-pick 또는 수동 반영한다.
5. 새 PR로 `develop`에 반영한다.

## 브랜치 보호 권장 설정

GitHub에서 `master`와 `develop`에 다음 보호 규칙을 설정하는 것을 권장한다.

| 항목 | `develop` | `master` |
| --- | --- | --- |
| Require a pull request before merging | On | On |
| Require approvals | 1명 이상 권장 | 1명 이상 권장 |
| Require conversation resolution before merging | On | On |
| Require status checks before merging | CI 추가 전까지 Off | CI 추가 전까지 Off |
| Require linear history | Off | Off |
| Allow force pushes | Off | Off |
| Allow deletions | Off | Off |

`Require linear history`는 켜지 않는다. 출시 PR과 `master` 동기화 PR에서 `Create a merge commit`을 사용하기 때문이다.

현재 저장소에 GitHub Actions 기반 CI가 없다면 `Require status checks before merging`은 켜지 않는다. CI를 추가한 뒤 build/test check가 안정화되면 필수 조건으로 전환한다.

## 팀원 로컬 저장소 갱신

default branch가 `develop`으로 변경된 뒤, 기존에 저장소를 clone한 팀원은 로컬에서 다음 명령을 한 번 실행한다.

```bash
git remote set-head origin -a
git fetch --prune
```

`git remote set-head origin -a`는 로컬의 `origin/HEAD`가 GitHub의 default branch를 따라가도록 갱신한다.

`git fetch --prune`은 원격에서 삭제된 작업 브랜치를 로컬 remote-tracking branch에서도 정리한다.
