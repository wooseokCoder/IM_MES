# QCT04A 이슈 목록

## 이슈 현황

| #  | 이슈                              | 상태   | 비고                                                        |
|----|-----------------------------------|--------|--------------------------------------------------------------|
| 1  | 편집 모드 진입 시 렉              | 적용됨 | 클라이언트 페이징(pageSize:500)으로 DOM 행 수 축소           |
| 2  | 이미지 삭제 시 버벅임             | 적용됨 | _imgStore 분리 + 페이징으로 근본 해결                        |
| 3  | 삭제된 이미지가 저장 후 재출현    | 적용됨 | `_imgChanged` 플래그 적용, 사용자 확인 필요                  |
| 4  | 이미지 불러오기 시 버벅임         | 적용됨 | _imgStore 분리 + 페이징으로 근본 해결                        |
| 5  | 화면 초기 진입 시 리스트 버벅임   | 적용됨 | DOM 배치 갱신(5건씩) + max-width CSS + 페이지당 이미지 로드  |
| 6  | 이미지 컬럼 너비 변경 시 미연동   | 적용됨 | CSS max-width:100% (원본 이상 확대 안 됨)                    |
| 7  | 이미지 렌더링 메모리/스크롤 최적화 | 적용됨 | loading="lazy" + content-visibility:auto (2026-03-16)        |
| 8  | 브라우저 이미지 메모리 누적 문제   | 적용됨 | LRU 캐시 제한 + 클립보드/캐시 초기화 (2026-03-17) 테스트 필요 |
| 9  | 이미지 컨텍스트 메뉴 TO-BE 구현   | 미적용 | AS-IS DevExpress 기본 메뉴 → TO-BE 커스텀 EasyUI 메뉴 필요   |

---

## 이슈 #1: 편집 모드 진입 시 렉 [적용됨]

### 증상
- 그리드 행 클릭 → `beginEdit` 진입 시 2~3초 체감 렉 발생

### 근본 원인
- EasyUI `beginEdit`가 행의 **모든 editor 컬럼**에 위젯(combobox, textbox 등)을 동시에 생성
- 3,973개 `<tr>` DOM 위에서 위젯 생성 → 전체 레이아웃 재계산(reflow) 발생
- `endEdit` 시 `refreshRow`로 행 전체 re-render → 같은 reflow 반복
- combobox 데이터(C053=4건, C054=8건)는 작지만, **3,973 DOM 행의 레이아웃 비용**이 핵심

### 시도 1: 셀 단위 편집 (폐기 — 오히려 느려짐)
- EasyUI `beginEdit/endEdit` 완전 제거 → onClickCell + 직접 DOM input/select 생성
- 클릭한 셀 1개에만 `<input>` 또는 `<select>` HTML을 생성
- **결과**: 오히려 느려짐 (매 클릭마다 DOM 조작 + blur 이벤트 setTimeout + 3,973 행 위 DOM 탐색)
- 되돌리고 페이징 방식으로 전환

### 해결: 클라이언트 사이드 페이징 (2026-03-05)
- **핵심**: DOM `<tr>` 수를 3,973 → 최대 500으로 축소
- `pagination: true, pageSize: 500, pageList: [100, 200, 500]`
- 서버 SP는 그대로 전체 데이터 반환 (CALLABLE이라 LIMIT/OFFSET 불가)
- 클라이언트에서 `_allRows`에 전체 저장 → `_renderPage()`로 페이지별 slice + `loadData`

**변경 내용**:

| 구분            | 변경 전                                    | 변경 후                                                |
|-----------------|--------------------------------------------|---------------------------------------------------------|
| pagination      | `false`                                    | `true`, pageSize:500, pageList:[100,200,500]            |
| 데이터 로딩     | `datagrid('load', params)` (URL 직접)      | 수동 AJAX → `_allRows` 저장 → `_renderPage(1)`         |
| 편집 방식       | 셀 단위 편집 (커스텀)                       | EasyUI `beginEdit`/`endEdit` (원래 방식)                |
| dbOriginal 구축 | `onLoadSuccess`에서 매번                   | `doSearch` AJAX success에서 1회 (전체 행)               |
| 저장/삭제 대상  | `getRows()` (현재 페이지만)                | `_allRows` (전체 페이지)                                |
| 행 추가         | `appendRow` → 현재 페이지 끝              | `_allRows.push()` → 마지막 페이지로 이동               |
| 이미지 로드     | `onLoadSuccess`에서 전체 행                | 페이지 전환마다 현재 페이지 행만 (`_imgStore` 캐시)     |
| No 컬럼         | `index + 1` (페이지 내 순번)               | `(_currentPage-1)*pageSize + index + 1` (전체 순번)     |

**추가 함수**:
- `_renderPage(pageNum)`: _allRows에서 해당 페이지 slice → loadData + pager 설정
- `_syncCurrentPage()`: 현재 페이지의 datagrid 행을 _allRows에 동기화
- `_comboShowAbove(ed)`: 콤보박스 패널을 입력 위쪽에 표시
- `_bindProcCodeSelect(index)`: beginEdit 후 공정코드 콤보 onSelect 바인딩
- `_refreshImageCells()`: 현재 페이지 이미지 셀 DOM 갱신 (캐시 이미지 포함)

---

## 이슈 #2: 이미지 삭제 시 버벅임 [적용됨 — 사용자 확인 필요]

### 증상
- 컨텍스트 메뉴 → 삭제 시 5~10초 버벅임

### 원인 분석
- row 객체에 base64 문자열(수십~수백KB)이 직접 저장되어 있음
- `endEdit` → EasyUI 내부 `refreshRow` → formatter가 row의 base64를 DOM에 재삽입
- row가 무거울수록 `beginEdit/endEdit/refreshRow` 비용 증가

### 해결: _imgStore 분리 (2026-03-05)
- **핵심**: 이미지 base64를 row 객체에서 분리하여 별도 맵(`_imgStore`)에 저장
- row 객체는 `_imgChanged`(boolean), `hasImg`(flag)만 유지 → 가벼움
- formatter에서 `_imgStore[row.insCode]`로 접근 (동작 동일)
- 페이징 도입으로 `_imgStore`는 페이지 전환 시에도 캐시 유지 (재요청 방지)

---

## 이슈 #3: 삭제된 이미지가 저장 후 재출현 [적용됨 — 사용자 확인 필요]

### 증상
- 이미지 삭제 → 저장 → 재조회 시 삭제했던 이미지가 다시 표시됨

### 원인
- formatter가 `insImgBase64`(서버 원본)를 fallback으로 표시

### 해결
- `_imgChanged` 플래그 도입: formatter에서 `_imgChanged`이면 `_imgStore`만 참조

---

## 이슈 #4: 이미지 불러오기 시 버벅임 [적용됨 — 사용자 확인 필요]

### 증상
- 컨텍스트 메뉴 → 불러오기 → 파일 선택 후 셀 반영 시 버벅임

### 해결
- `_imgStore` 분리로 간접 개선 (이슈 #2와 동일한 해결)
- 페이징으로 DOM 행 수 축소 → 이미지 반영 시 reflow 비용 감소

---

## 이슈 #6: 이미지 컬럼 너비 변경 시 이미지 크기 미연동 [적용됨]

### 증상
- 컬럼 너비를 늘려도 이미지가 원본 크기 그대로 유지

### 해결: `max-width: 100%` (2026-03-05)
- `qct04a_assy.jsp` `.ins-img-cell` CSS:
  - `max-width: 100%` — 컬럼보다 크면 축소, 원본보다 커지지 않음 (화질 보존)
  - `height: auto` — 비율 유지

---

## 이슈 #5: 화면 초기 진입 시 리스트 버벅임 [적용됨 — 사용자 확인 필요]

### 증상
- `doSearch()` → 그리드 로드 후 이미지 일괄 조회 시 버벅임

### 해결 (2026-03-05)
1. **CSS**: `max-width: 100%` (원본보다 커지지 않아 리플로우 감소)
2. **DOM 배치 갱신**: 5건씩 `setTimeout(fn, 0)` 배치 처리
3. **페이징**: 페이지당 최대 500행만 이미지 로드 (이전 페이지 이미지는 `_imgStore` 캐시)

---

## 교차 검증 체크리스트 (이슈 간 상충 방지)

### 공유 코드 맵

```
  코드 위치                         관련 이슈
  ─────────────────────────────    ──────────
  formatter (insImg)                #2, #3, #5, #6, #7
  onClickRow + beginEdit            #1
  onLoadSuccess                     #5
  _loadImagesBatch                  #2, #5
  _setImgData                       #2, #3, #4
  _getRowImgBase64                  #2, #4
  _fetchImgBase64                   #2
  _imgStore 전역 변수               #2, #3, #4, #5, #8
  _imgCachePut / _imgCacheReset     #8
  _imgClipboard                     #8
  _allRows + _renderPage            #1 (페이징)
  doSaveGrid imgVal                 #2, #3
  hasImg 판별                       #2, #4
  CSS .ins-img-cell                 #6, #7
```

### 수정 후 시나리오 검증 (필수)

| #  | 시나리오                                     | 예상 결과                               | 관련 이슈 |
|----|----------------------------------------------|-----------------------------------------|-----------|
| 1  | 조회 후 이미지 있는 행 표시                  | 이미지 정상 표시, 렉 없음               | #2, #5    |
| 2  | 행 클릭 → 편집 모드 진입                     | 즉시 반응 (렉 없음)                     | #1        |
| 3  | 셀 값 변경 → 다른 행 클릭                    | 변경값 저장, 배경 녹색                  | #1        |
| 4  | 우클릭 → 삭제 → 이미지 사라짐               | 버벅임 없이 즉시 사라짐                 | #2, #3    |
| 5  | 삭제 후 저장 → 재조회                        | 삭제한 이미지 재출현 안 됨              | #3        |
| 6  | 우클릭 → 불러오기 → 파일 선택               | 버벅임 없이 이미지 표시                 | #4        |
| 7  | 컬럼 너비 늘림/줄임                          | 이미지가 너비에 맞춰 축소 (확대 안 됨)  | #6        |
| 8  | 저장 시 변경된 이미지만 전송                 | `__KEEP__` vs base64 정상 분기          | #2, #3    |
| 9  | 페이지 전환 (1→2→1)                         | 수정 내용·이미지 유지                   | #1        |
| 10 | 2페이지에서 수정 → 저장                      | 전체 페이지 변경 행 저장됨              | #1        |
| 11 | 행 추가 → 마지막 페이지 이동                | 신규 행 편집 가능                       | #1        |
| 12 | 이미지 500건 조회 후 빠른 스크롤             | 스크롤 랙 감소 (뷰포트 밖 페인트 생략)  | #7        |
| 13 | 컨텍스트 메뉴 Copy/Cut/Paste                | src 속성 참조 정상 동작                 | #7        |
| 14 | 이미지 조회 후 5페이지 이상 탐색             | 브라우저 메모리 안정 (LRU 40건 제한)    | #8        |
| 15 | 이미지 복사 → 조회 → 붙여넣기               | "클립보드에 이미지가 없습니다" 경고     | #8        |
| 16 | 이미지 편집 → 3페이지 이상 이동 → 저장       | 편집 이미지 정상 보존 (changedRows 보호)| #8        |
| 17 | 이미지 삭제 → 같은 행 다시 확인              | 이미지 사라짐 + _imgStore에서 키 제거   | #8        |

---

## 이슈 #7: 이미지 렌더링 메모리/스크롤 최적화 [적용됨]

### 배경

- 이슈 #1~#6으로 페이징, _imgStore 분리, CSS max-width 등 적용 완료
- 추가 최적화 여지: 뷰포트 밖 이미지의 디코딩/페인트 비용 절감

### 검토한 접근들

| 접근                        | 채택 여부 | 이유                                                                |
|-----------------------------|:---------:|---------------------------------------------------------------------|
| iframe 가상 스크롤          | ❌ 폐기   | EasyUI datagrid 구조와 충돌, 기존 편집/저장 로직 전면 재작성 필요   |
| `<div>` background-image    | ❌ 폐기   | 컨텍스트 메뉴(Copy/Cut/Paste)가 `<img>` src 속성에 의존 → 호환 불가 |
| `loading="lazy"` 속성       | ✅ 적용   | `<img>` 구조 유지, 브라우저 네이티브 디코딩 지연                    |
| `content-visibility:auto`   | ✅ 적용   | 뷰포트 밖 행의 레이아웃/페인트 건너뛰기                             |

### 적용 내용 (2026-03-16)

formatter의 `<img>` 태그 3곳에 아래 2개 속성 추가:

```html
<img class="ins-img-cell"
     loading="lazy"
     style="content-visibility:auto; contain-intrinsic-size:50px;"
     oncontextmenu="return false"
     src="data:image/png;base64,..." />
```

| 속성                              | 효과                                                          |
|-----------------------------------|---------------------------------------------------------------|
| `loading="lazy"`                  | 뷰포트 밖 Base64 이미지의 디코딩 지연 → 초기 메모리 스파이크 완화 |
| `content-visibility:auto`         | 뷰포트 밖 행의 레이아웃/페인트 계산 건너뛰기 → 스크롤 랙 감소   |
| `contain-intrinsic-size:50px`     | content-visibility 적용 시 레이아웃 점프 방지용 힌트 크기       |

### 적용 대상 (qct04a.js formatter 3곳)

| #  | 조건                        | 행 번호 (변경 후) | 설명                                         |
|----|-----------------------------|--------------------|----------------------------------------------|
| 1  | `row._imgChanged`           | 359~363행          | 클라이언트에서 편집된 이미지 (미저장 상태)    |
| 2  | `_imgStore[row.insCode]`    | 369~373행          | 캐시 히트 (페이지 이동 복귀 시)              |
| 3  | `row.hasImg && row.insCode` | 378~382행          | DB 이미지 (배치 로딩 대기 — `img-loading`)   |

### 안전성

- `<img>` 태그 구조/클래스/이벤트 변경 없음 → 컨텍스트 메뉴(Copy/Cut/Paste) 정상 동작
- `_imgStore` 캐시, 배치 로딩, URL→dataURI 변환 로직 영향 없음
- 미지원 브라우저에서는 속성이 단순 무시됨 (graceful degradation)

### 참고: `loading="lazy"`와 Base64 data URI

- `loading="lazy"`는 본래 네트워크 요청 지연용이지만, Chrome에서는 data URI에도 **디코딩 지연** 효과가 일부 작동
- 3번째 케이스(`data-src`만 있고 `src` 없음)는 배치 로딩으로 `src`가 채워지는 시점에 의미 있음
- 효과가 제한적일 수 있으나, 부작용 없으므로 일관성 있게 적용

### 사용자 확인 필요

- [ ] 이미지 있는 행 500건 이상 조회 후 스크롤 시 체감 랙 변화 확인
- [ ] 컨텍스트 메뉴(Copy/Cut/Paste) 정상 동작 확인
- [ ] 이미지 편집(불러오기/삭제) 후 저장/재조회 정상 확인

---

## 이슈 #8: 브라우저 이미지 메모리 누적 문제 [적용됨 — 테스트 필요]

### 배경

- 이슈 #1~#7으로 서버 측 메모리(heap space)와 렌더링 성능은 해결됨
- 브라우저(클라이언트) 측 JS 메모리 관리가 미흡하여, 장시간 사용 시 메모리 누적 가능

### 메모리 점유 구조 (이미지 1건 기준)

```
서버 TO_BASE64 → AJAX 응답 (~1.3MB string)
    → _imgStore[insCode] = base64  (JS heap: ~1.3MB)
    → <img src="data:image/png;base64,...">  (DOM: ~1.3MB string)
    → 브라우저 디코딩 → 비트맵  (GPU/Render: ~1MB)
    ────────────────────────────────────────────
    합계: 이미지 1건당 ~3.6MB 점유
```

### 발견된 문제 5건

| #  | 심각도 | 문제                                       | 해결 여부 |
|----|:------:|--------------------------------------------|:---------:|
| 8a | 상     | `_imgClipboard` 영구 보유                  | ✅ 적용   |
| 8b | 상     | `_imgStore` 페이지네이션 시 무한 누적       | ✅ 적용   |
| 8c | 중     | `_imgStore` 삭제 시 키 잔존 (`null` 할당)  | ✅ 적용   |
| 8d | 하     | `_tabState.allRows` 내 `_imgBase64` 잔존   | 미적용    |
| 8e | 하     | `_processConvertNext` rAF 1프레임 잔존     | 미적용    |

### 8a: `_imgClipboard` doSearch/탭전환 시 초기화 (적용됨)

**문제**: 이미지 복사/잘라내기 후 `_imgClipboard`(~2.7MB)가 doSearch·탭전환에서도 해제 안 됨. 페이지 떠나기 전까지 영구 보유.

**해결**: doSearch 성공 콜백과 `_restoreTabState`에 `_imgClipboard = null` 추가.

**동작 변화**:
- 같은 조회 결과 내 복사→여러 셀 붙여넣기: **정상** (변화 없음)
- 붙여넣기 후 클립보드 유지: **정상** (이전에 `_imgPaste()`에서 `null` 하던 것 제거)
- 조회/탭전환 후 이전 클립보드 사용: **불가** (초기화됨 — 새 데이터에 이전 이미지 붙일 이유 없음)

### 8b: `_imgStore` LRU 캐시 제한 (적용됨)

**문제**: 페이지네이션 반복 탐색 시 방문한 모든 페이지의 이미지가 `_imgStore`에 무한 누적.

```
1페이지 → _imgStore 5건 (6.5MB)
2페이지 → _imgStore 10건 (13MB)
3페이지 → _imgStore 15건 (19.5MB)
... doSearch 전까지 계속 증가
```

**해결**: LRU 캐시 도입 (`_IMG_CACHE_MAX = 40`건 제한).

```javascript
_imgCachePut(insCode, base64)
  ├─ _imgCacheOrder에서 해당 키 위치를 뒤로 갱신 (최근 접근)
  ├─ _imgStore에 저장
  └─ _imgCacheOrder.length > 40 이면
      └─ changedRows에 없는 가장 오래된 항목부터 delete
         (changedRows 항목은 보호 — 미저장 편집 이미지)
```

**changedRows 보호 이유**: `doSaveGrid`(line ~933)에서 `_imgStore[row.insCode]`를 읽어 저장 데이터 구성. 캐시에서 제거되면 편집한 이미지가 빈값으로 저장됨.

**최대 메모리**: 40건 × ~1.3MB = ~52MB 상한.

**동작 변화**:
- 캐시에서 밀려난 이미지: 해당 페이지 재방문 시 서버에서 다시 배치 로딩 (data-src → 자동 복원)
- 사용자가 편집한 이미지: changedRows 보호로 캐시에서 제거 안 됨

**적용 범위**:
- `_imgCachePut()`: `_setImgData`, `_fetchImgBase64`, `_processConvertNext` (3곳)
- `_imgCacheReset()`: `doSearch`, `_restoreTabState` (2곳)

### 8c: `_imgStore` 삭제 시 `delete` 사용 (적용됨)

**문제**: `_setImgData(idx, null)` → `_imgStore[key] = null` — 키가 남아있고 값만 null.

**해결**: `delete _imgStore[key]` + `_imgCacheOrder`에서도 제거.

**동작 변화**: 없음. formatter에서 `_imgStore[key]`가 null이든 undefined이든 falsy → 이미지 미표시.

### 8d: `_tabState.allRows` 내 `_imgBase64` 잔존 (미적용)

**문제**: 신규 행(insCode 없음)에 이미지 붙이고 저장 안 한 채 탭 전환 시, `_tabState[plants].allRows` 안에 `row._imgBase64`(base64) 잔존.

**미적용 이유**: 신규 행에 이미지를 추가하고 미저장 상태에서 탭 전환하는 경우가 극히 드물고, `_allRows` 자체는 커스텀 페이징에 필수.

### 8e: `_processConvertNext` rAF 잔존 (미적용)

**문제**: `_renderPage` 호출 시 `_convertQueue = []`로 큐를 비우지만, 이미 예약된 `requestAnimationFrame` 콜백은 취소 안 됨. 다음 프레임에 1회 실행 후 `_convertQueue.length === 0` → 자동 종료.

**미적용 이유**: 1프레임 후 자동 종료되므로 실질적 메모리 영향 없음.

### 사용자 테스트 필요

- [ ] 이미지 있는 행 조회 후 여러 페이지 탐색 → 브라우저 메모리(작업관리자) 안정적인지 확인
- [ ] 페이지 이동 후 복귀 시 캐시 히트/서버 재로딩 정상 동작 확인
- [ ] 이미지 복사 → 여러 셀 붙여넣기 → 저장 정상 확인
- [ ] 이미지 편집 후 페이지 많이 이동 → 저장 시 편집 이미지 정상 보존 확인 (changedRows 보호)
- [ ] 조회/탭전환 후 붙여넣기 시 "클립보드에 이미지가 없습니다" 경고 표시 확인

---

## 이슈 #9: 이미지 컨텍스트 메뉴 TO-BE 구현 [미적용]

### 배경

AS-IS에서는 DevExpress `PictureEdit` 컨트롤의 **기본 내장 컨텍스트 메뉴**가 제공되었다.
커스텀 컨텍스트 메뉴는 없고, DevExpress가 자동으로 제공하는 메뉴(복사, 다른 이름으로 저장 등)만 사용.

TO-BE에서는 `<img>` 태그를 사용하므로 **브라우저 기본 우클릭 메뉴**만 나오는데,
이것은 AS-IS 사용자 경험과 다르고 불필요한 항목(새 탭에서 이미지 열기, 요소 검사 등)이 포함됨.

### AS-IS 분석 결과

#### QCT 이미지 화면 3개 비교

| 화면   | 이미지 위치          | 컨트롤                      | 커스텀 메뉴 | 기본 메뉴                               |
|--------|----------------------|-----------------------------|:-----------:|------------------------------------------|
| QCT02A | D0A 팝업 (4장)       | `acPictureEdit` x4          | 없음        | DevExpress PictureEdit 기본 (ReadOnly)   |
| QCT04A | **그리드 셀 내장**   | `AddPictrue("INS_IMG", ...)` | 없음        | DevExpress PictureEdit 기본 (allowEdit)  |
| QCT08A | D0A 팝업 (1장)       | `acPictureEdit` x1          | 없음        | DevExpress PictureEdit 기본 (ReadOnly)   |

#### DevExpress PictureEdit 기본 컨텍스트 메뉴 항목

| 항목                      | ReadOnly 시 | allowEdit 시 |
|---------------------------|:-----------:|:------------:|
| 복사 (Copy)               | 활성        | 활성         |
| 붙여넣기 (Paste)          | 비활성      | 활성         |
| 잘라내기 (Cut)            | 비활성      | 활성         |
| 삭제 (Delete/Clear)       | 비활성      | 활성         |
| 불러오기 (Load)           | 비활성      | 활성         |
| 다른 이름으로 저장 (Save) | 활성        | 활성         |

#### QCT04A 특이사항

- M0A에서 `allowEdit: true` → 그리드 셀에서 이미지 편집 가능
- 현재 TO-BE에는 이미 커스텀 컨텍스트 메뉴가 구현되어 있음 (Copy/Cut/Paste/불러오기/삭제)
- **TO-BE 기존 메뉴는 AS-IS DevExpress 기본 메뉴와 동등 수준**

#### QCT02A / QCT08A (D0A 팝업) 현황

- 현재 TO-BE에 컨텍스트 메뉴 **없음** — 브라우저 기본 우클릭만 동작
- AS-IS ReadOnly 기본 메뉴 기준으로 필요한 항목: **복사, 다른 이름으로 저장(다운로드)**

### TO-BE 구현 방안

#### QCT04A (그리드 셀 이미지) — 이미 구현됨

- 기존 컨텍스트 메뉴(Copy/Cut/Paste/불러오기/삭제)가 AS-IS와 동등
- **추가 작업 불필요**

#### QCT02A / QCT08A (D0A 팝업 이미지) — 구현 필요

EasyUI `menu`를 사용한 커스텀 컨텍스트 메뉴 추가:

```
우클릭 메뉴 항목:
├── 이미지 저장 (다운로드)    ← AS-IS "Save As" 대응
└── 새 창에서 보기 (원본 크기) ← 확대 보기 용도
```

구현 위치:
- QCT02A: `qct02a.js` — D0A 팝업 이미지 4개에 contextmenu 이벤트 바인딩
- QCT08A: `qct08a.js` — D0A 팝업 이미지 1개에 contextmenu 이벤트 바인딩

---

## 실패한 접근: 셀 단위 편집 (폐기 — 오히려 느려짐)

### 시도 내용
- EasyUI `beginEdit/endEdit` 완전 제거
- `_onCellClick()`: 클릭한 셀 1개에만 `<input>` 또는 `<select>` HTML 직접 생성
- `_endCellEdit()`: 값 읽기 + row 데이터 업데이트 + 포맷된 텍스트 복원

### 실패 원인
- 사용자 피드백: "너무 느려졌다"
- 매 클릭마다 DOM 탐색(tr + td + .datagrid-cell) + input/select 생성/제거
- blur 이벤트에 setTimeout(100ms) 지연 → 응답성 저하
- 3,973개 행 위의 jQuery selector + DOM 조작이 여전히 무거움
- EasyUI 내장 editor보다 최적화 부족

### 교훈
- DOM 행 수 자체를 줄이는 것(페이징)이 편집 방식 변경보다 효과적
- 3,973행 위 커스텀 DOM 조작은 EasyUI 내장 기능보다 느릴 수 있음

---

## 실패한 접근: 서버 썸네일 변환 (폐기 — OOM)

### 시도 내용
- `generateThumbnail(base64, 60)`: SP 결과를 Java에서 BufferedImage로 축소 후 재인코딩

### 실패 원인
- 이미지 670건 × (원본 byte[] + BufferedImage + 썸네일 BufferedImage) = **Java heap space OOM**
- 새로고침 몇 번에 Tomcat 서버 다운

### 교훈
- **리스트/그리드에서 서버 측 썸네일 변환 금지**
- 이미지 크기 제한은 CSS `max-width: 100%`로 클라이언트에서 처리

---

## 실패한 접근: Blob URL (폐기)

### 시도 내용
- base64 문자열 대신 `URL.createObjectURL()`로 짧은 Blob URL 사용

### 실패 원인
- `_base64ToBlobUrl()` 함수가 `atob()` + 바이트 변환 루프 실행
- formatter(동기) 안에서 실행되어 초기 로딩이 오히려 악화

### 교훈
- formatter는 **순수 문자열 연결만** 해야 함 (CPU 작업 금지)
