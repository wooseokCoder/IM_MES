# AS-IS 그리드 컨텍스트 메뉴 전체 분석

> **소스**: `C:\proActive\DecompiledSrc\ControlManager\ControlManager\acGridView.cs`
> **메서드**: `SetGridColumnMenu()` (라인 4570~4908), `RaiseShowGridPopupMenu()` (라인 4910~4949)
> **작성자**: 송우석
> **작성일**: 2026-02-12

---

## 1. 컬럼 헤더 우클릭 메뉴 (Column Header Context Menu)

> 그리드 컬럼 헤더 영역(`GridHitTest.Column`, `GridHitTest.ColumnPanel`)에서 우클릭 시 표시.
> `GridViewColumnMenu.Init(column)` → `SetGridColumnMenu()` 순서로 구성됨.

### 1-1. DevExpress 기본 메뉴 항목 (인덱스 0~9)

> `GridViewColumnMenu.Init(column)`이 자동 생성하는 DevExpress 기본 항목.
> `SetGridColumnMenu()`에서 `RemoveAt()` 으로 일부 제거 후, 커스텀 항목 추가.

| 인덱스 | 메뉴 라벨                    | 기능                                                    | 이벤트 핸들러          |
|:------:|------------------------------|----------------------------------------------------------|------------------------|
| 0      | Sort Ascending (오름차순)    | 해당 컬럼 오름차순 정렬                                  | DevExpress 기본        |
| 1      | Sort Descending (내림차순)   | 해당 컬럼 내림차순 정렬                                  | DevExpress 기본        |
| 2      | Clear Sorting (정렬 해제)    | 해당 컬럼의 정렬 해제                                    | DevExpress 기본        |
| 3      | Group By This Column (그룹)  | 해당 컬럼으로 그룹핑                                     | DevExpress 기본        |
| 4      | Show Group By Box (그룹패널) | 그룹 패널(Group Panel) 표시/숨김                         | DevExpress 기본        |
| 5      | Remove This Column (컬럼제거)| 해당 컬럼을 그리드에서 제거 (드래그로 복원 가능)          | DevExpress 기본        |
| 6      | Column Chooser (컬럼선택기)  | 숨겨진 컬럼 목록 팝업 표시 → 드래그로 복원               | DevExpress 기본        |
| 7      | Best Fit (자동맞춤)          | 해당 컬럼 너비를 내용에 맞게 자동 조절                   | DevExpress 기본        |
| 8      | Best Fit (All) (전체자동맞춤)| 모든 컬럼 너비를 내용에 맞게 자동 조절                   | DevExpress 기본        |
| 9      | Filter Editor (필터편집기)   | 해당 컬럼 필터 조건 편집기 표시                           | DevExpress 기본        |

### 1-2. 커스텀 메뉴 항목 (ProActive 추가)

> `SetGridColumnMenu()`에서 기본 항목 뒤에 추가하는 커스텀 항목.

| 메뉴 라벨                           | 기능                                                    | 이벤트 핸들러                        |
|--------------------------------------|----------------------------------------------------------|--------------------------------------|
| **[컬럼명] (서브메뉴)**              | 선택된 컬럼에 대한 설정 메뉴 그룹                       | —                                    |
| ├ 정렬 > 왼쪽                        | 셀 텍스트 좌측 정렬 (HorzAlignment.Near)                | `menuItemAlignLeft_Click`            |
| ├ 정렬 > 중앙                        | 셀 텍스트 중앙 정렬 (HorzAlignment.Center)              | `menuItemAlignCenter_Click`          |
| ├ 정렬 > 오른쪽                      | 셀 텍스트 우측 정렬 (HorzAlignment.Far)                 | `menuItemAlignRight_Click`           |
| ├ 고정 > 왼쪽                        | 컬럼을 좌측에 고정 (FixedStyle.Left)                    | `menuItemFixedLeft_Click`            |
| ├ 고정 > 오른쪽                      | 컬럼을 우측에 고정 (FixedStyle.Right)                   | `menuItemFixedRight_Click`           |
| ├ 병합                               | 동일 값 셀 병합 허용 (체크박스, AllowMerge)             | `menuItemMerge_Click`                |
| ├ 마스크                             | 컬럼 데이터 마스킹 처리                                 | `menuItemMask_Click`                 |
| ├ 빠른 필터                          | 해당 컬럼에 빠른 필터 적용                              | `menuItemFilter_Click`               |
| └ 표시형태 > 명 / 값                 | LOOKUP 컬럼 전용 — 코드명/코드값 표시 전환              | `menuItemEditShowTypeDisplay_Click`  |
|                                      |                                                          | `menuItemEditShowTypeValue_Click`    |
| **표시 (서브메뉴)**                  | 그리드 영역 표시/숨김 그룹                              | —                                    |
| ├ 행번호                             | 행 번호(Indicator) 표시/숨김 (체크박스)                 | `menuItemShowRowNum_Click`           |
| ├ 컬럼                               | 컬럼 헤더 표시/숨김 (체크박스)                          | `menuItemShowColumnHeader_Click`     |
| ├ 전체 요약                          | 그리드 하단 Footer 표시/숨김 (체크박스)                 | `menuItemFooter_Click`               |
| └ 그룹 요약                          | 그룹별 요약 Footer 표시/숨김 (체크박스)                 | `menuItemGroupFooter_Click`          |
| **기능 (서브메뉴)**                  | 그리드 기능 그룹                                        | —                                    |
| ├ 전체 컬럼 자동크기                 | 모든 컬럼 너비를 내용에 맞게 자동 조절 (Best Fit All)   | `menuItemAllBestFitColumns_Click`    |
| ├ 항상 전체 컬럼 자동크기            | 항상 자동 크기 조절 유지 (체크박스)                     | `menuItemAlwaysBestFit_Click`        |
| ├ 모든 그룹 펼치기                   | 그룹핑된 모든 그룹을 펼침 (Expand All)                  | `menuItemGroupExpand_Click`          |
| └ 모든 그룹 접기                     | 그룹핑된 모든 그룹을 접음 (Collapse All)                | `menuItemGroupCollapse_Click`        |
| **스타일 상자**                      | 그리드 스타일(색상/폰트) 설정 대화상자 열기             | `menuItemStyleBox_Click`             |
| **사용자 UI (서브메뉴)**             | 사용자별 그리드 레이아웃 저장/복원 그룹                 | —                                    |
| ├ 현재 설정된 UI - {설정명}          | 현재 적용 중인 UI 설정 이름 표시 (읽기 전용)            | — (Visible=false if 미설정)          |
| ├ 불러오기                           | 저장된 UI 설정 불러오기                                 | `menuItemConfigLoad_Click`           |
| ├ 저장                               | 현재 UI 설정 저장                                       | `menuItemConfigSave_Click`           |
| ├ 다른이름으로 저장                   | 현재 UI 설정을 새 이름으로 저장                         | `menuItemConfigOtherSave_Click`      |
| ├ 현재 사용자 UI을 기본으로 설정     | 현재 설정을 사용자 기본값으로 지정                      | `menuItemConfigUse_Click`            |
| ├ 시스템 UI로 초기화                 | 시스템 기본 UI로 되돌리기 (초기화)                      | `menuItemSystemConfig_Click`         |
| └ 관리                               | 저장된 UI 설정 목록 관리 (삭제 등)                      | `menuItemConfigManager_Click`        |
| **파일로 저장 (서브메뉴)**           | 그리드 데이터 외부 파일 내보내기 그룹                   | —                                    |
| ├ Microsoft Excel (.xls)            | Excel 97-2003 형식 내보내기                             | `menuItemToExcel_Click`              |
| ├ Microsoft Excel (.xlsx)           | Excel 2007+ 형식 내보내기                               | `menuItemToXlsx_Click`               |
| ├ Adobe Acrobat PDF                  | PDF 형식 내보내기                                       | `menuItemToPDF_Click`                |
| ├ 텍스트 문서                        | Text 파일 내보내기                                      | `menuItemToText_Click`               |
| ├ 서식있는 텍스트 (RTF)              | RTF 형식 내보내기                                       | `menuItemToRTF_Click`                |
| ├ 웹문서 (html)                      | HTML 형식 내보내기                                      | `menuItemToHtml_Click`               |
| └ 웹페이지 보관파일 (mht)            | MHT 형식 내보내기                                       | `menuItemToMht_Click`                |
| **인쇄**                             | 그리드 데이터 인쇄 (기본 인쇄 대화상자)                | `menuItemDefaultPrint_Click`         |
| **도움말**                           | 도움말 표시 (HELP_CTRL_GRID / HELP_CTRL_ATTACHFILE)    | `menuHelp_Click`                     |

---

## 2. Footer(요약행) 우클릭 메뉴 (Footer Context Menu)

> 그리드 하단 요약 행(`GridHitTest.Footer`, `GridHitTest.RowFooter`)에서 우클릭 시 표시.
> `GridViewFooterMenu.Init(hitInfo)` → `SetGridColumnMenu()` 순서로 구성됨.
> 숫자(Numeric) 컬럼만 활성화, 그 외 컬럼은 전체 비활성화.

| 인덱스 | 메뉴 라벨                    | 기능                                              | 활성 조건                    |
|:------:|------------------------------|----------------------------------------------------|------------------------------|
| 0      | {컬럼명} - Sum               | 해당 컬럼의 합계 표시                              | Numeric MaskType만 활성      |
| 1      | {컬럼명} - Min               | 해당 컬럼의 최소값 표시                            | Numeric MaskType만 활성      |
| 2      | {컬럼명} - Max               | 해당 컬럼의 최대값 표시                            | Numeric MaskType만 활성      |
| 3      | {컬럼명} - Count             | 해당 컬럼의 건수 표시                              | Numeric MaskType만 활성      |
| 4      | {컬럼명} - Average           | 해당 컬럼의 평균값 표시                            | Numeric MaskType만 활성      |

---

## 3. Row(행) 우클릭 메뉴 (Row Context Menu)

> 그리드 행 영역(`GridHitTest.Row`, `GridHitTest.RowCell`, `GridHitTest.RowEdge`, `GridHitTest.RowDetail`)에서 우클릭 시.
> 기본 메뉴 없음 — `ShowGridMenuEx` 이벤트를 통해 각 화면에서 개별 구현.

| 항목              | 설명                                                                |
|-------------------|---------------------------------------------------------------------|
| 기본 메뉴         | 없음 (빈 `GridViewMenu` 생성 후 이벤트 전달)                       |
| 커스텀 구현       | 각 화면의 `ShowGridMenuEx` 이벤트 핸들러에서 메뉴 항목 추가        |
| GridMenuType      | `GridMenuType.Row`                                                  |

---

## 4. 빈 행(EmptyRow) 우클릭 메뉴

> 데이터가 없는 빈 영역(`GridHitTest.EmptyRow`)에서 우클릭 시.
> 기본 메뉴 없음 — `ShowGridMenuEx` 이벤트를 통해 개별 구현.

| 항목              | 설명                                                                |
|-------------------|---------------------------------------------------------------------|
| 기본 메뉴         | 없음 (빈 `GridViewMenu` 생성 후 이벤트 전달)                       |
| GridMenuType      | `GridMenuType.User`                                                 |

---

## 5. 그리드 타입(emGridType) 전체 목록

> `acGridView.cs` 라인 111~125에 정의된 전체 12개 타입.

| 그리드 타입      | EnableColumnMenu | EnableFooterMenu | EnableGroupPanelMenu | AllowSort | AllowGroup | AllowFilter | ColumnAutoWidth | IsLoadConfig |
|------------------|:----------------:|:----------------:|:--------------------:|:---------:|:----------:|:-----------:|:---------------:|:------------:|
| SEARCH           | O                | O                | O                    | O         | O          | O           | X               | O            |
| FIXED            | O                | X                | X                    | O         | X          | O           | X               | X            |
| FIXED_FULLWIDTH  | O                | X                | X                    | X         | X          | X           | O               | X            |
| FIXED_EXCEL      | O                | X                | X                    | X         | X          | X           | X               | X            |
| FIXED_SINGLE     | X                | X                | X                    | X         | X          | X           | O               | X            |
| COMMON_CONTROL   | O                | X                | X                    | X         | X          | X           | O               | X            |
| LIST_USERCONFIG  | X                | X                | X                    | X         | X          | X           | O               | O            |
| LIST_USERCONFIG2 | X                | X                | X                    | X         | X          | X           | O               | O            |
| LIST             | O                | X                | X                    | O         | O          | O           | O               | X            |
| ATTACH_FILE_LIST | O                | X                | X                    | O         | X          | O           | O               | X            |
| LIST_SINGLE      | O                | X                | X                    | O         | O          | O           | O               | X            |
| AUTO_COL         | O                | O                | O                    | O         | O          | O           | X               | O            |

---

## 6. 그리드 타입별 헤더 메뉴 구성 상세

> `SetGridColumnMenu()` 내부의 `switch(GridType)` 분기에서 기본 항목 제거 + 커스텀 항목 추가.

### acGridView (일반 그리드)

| 그리드 타입      | 기본 항목 제거                          | 커스텀 항목 추가                                                        |
|------------------|-----------------------------------------|-------------------------------------------------------------------------|
| SEARCH           | `RemoveAt(9)` — 필터편집기 제거         | [컬럼명] + 표시 + 기능 + 스타일상자 + 사용자UI + 파일저장 + 인쇄 + 도움말 |
| AUTO_COL         | `RemoveAt(9)` — 필터편집기 제거         | [컬럼명] + 표시 + 기능 + 스타일상자 + 사용자UI + 파일저장 + 인쇄 + 도움말 |
| FIXED            | `RemoveAt(4)` + `RemoveAt(6)` — 그룹패널, 자동맞춤 제거 | 기능 + 파일저장 + 인쇄 + 도움말                            |
| LIST             | `RemoveAt(9)` — 필터편집기 제거         | 기능 + 파일저장 + 인쇄 + 도움말                                         |
| ATTACH_FILE_LIST | `RemoveAt(4)` — 그룹패널 제거           | 도움말만                                                                |
| COMMON_CONTROL   | `RemoveAt(4)` + `RemoveAt(6)` — 그룹패널, 자동맞춤 제거 | (추가 없음, 기본 항목만 유지)                              |

### acBandGridView (밴드 그리드)

| 그리드 타입      | 기본 항목 제거                          | 커스텀 항목 추가                                                        |
|------------------|-----------------------------------------|-------------------------------------------------------------------------|
| SEARCH           | (제거 없음)                             | [컬럼명] + 표시 + 기능 + 스타일상자 + 사용자UI + 파일저장 + 인쇄 + 도움말 |
| AUTO_COL         | (제거 없음)                             | [컬럼명] + 표시 + 기능 + 스타일상자 + 파일저장 + 인쇄 + 도움말         |
| FIXED            | `RemoveAt(4)` — 그룹패널 제거           | 기능 + 파일저장 + 인쇄 + 도움말                                         |
| LIST             | (제거 없음)                             | 기능 + 파일저장 + 인쇄 + 도움말                                         |
| ATTACH_FILE_LIST | `RemoveAt(4)` — 그룹패널 제거           | 도움말만                                                                |
| COMMON_CONTROL   | `RemoveAt(4)` — 그룹패널 제거           | (추가 없음)                                                            |
| FIXED_EXCEL      | (메뉴 없음)                             | —                                                                       |
| FIXED_SINGLE     | (메뉴 없음)                             | —                                                                       |
| LIST_USERCONFIG  | (메뉴 없음)                             | —                                                                       |
| LIST_USERCONFIG2 | (메뉴 없음)                             | —                                                                       |
| LIST_SINGLE      | (메뉴 없음)                             | —                                                                       |

---

## 7. SEARCH 타입 최종 메뉴 구성 (전체 펼침)

> 가장 일반적인 SEARCH 타입 그리드의 헤더 우클릭 시 최종 메뉴 순서.

```
[DevExpress 기본 항목]
 ├ Sort Ascending (오름차순)
 ├ Sort Descending (내림차순)
 ├ Clear Sorting (정렬 해제)
 ├ Group By This Column (이 컬럼으로 그룹)
 ├ Show Group By Box (그룹 패널 표시)
 ├ Remove This Column (이 컬럼 제거)
 ├ Column Chooser (컬럼 선택기)
 ├ Best Fit (자동 맞춤)
 └ Best Fit All Columns (전체 컬럼 자동 맞춤)
─── (구분선) ───
[컬럼명] ▶
 ├ 정렬 ▶
 │  ├ 왼쪽
 │  ├ 중앙
 │  └ 오른쪽
 ├ 고정 ▶
 │  ├ 왼쪽
 │  └ 오른쪽
 ├ 병합
 ├ 마스크
 ├ 빠른 필터
 └ 표시형태 ▶          ← LOOKUP 컬럼에서만 표시
    ├ 명
    └ 값
표시 ▶
 ├ 행번호
 ├ 컬럼
 ├ 전체 요약
 └ 그룹 요약
기능 ▶
 ├ 전체 컬럼 자동크기
 ├ 항상 전체 컬럼 자동크기
 ├ 모든 그룹 펼치기
 └ 모든 그룹 접기
스타일 상자
─── (구분선) ───
사용자 UI ▶
 ├ 현재 설정된 UI - {설정명}
 ├ 불러오기
 ├ 저장
 ├ 다른이름으로 저장
 ├ 현재 사용자 UI을 기본으로 설정
 ├ 시스템 UI로 초기화
 └ 관리
─── (구분선) ───
파일로 저장 ▶
 ├ Microsoft Excel (.xls)
 ├ Microsoft Excel (.xlsx)
 ├ Adobe Acrobat PDF
 ├ 텍스트 문서
 ├ 서식있는 텍스트 (RTF)
 ├ 웹문서 (html)
 └ 웹페이지 보관파일 (mht)
─── (구분선) ───
인쇄
─── (구분선) ───
도움말
```

---

## 8. Footer 요약행 메뉴 구성 (전체 펼침)

> Footer/GroupFooter 영역 우클릭 시 최종 메뉴 순서.

```
{컬럼명} - Sum         ← 숫자 컬럼만 활성
{컬럼명} - Min         ← 숫자 컬럼만 활성
{컬럼명} - Max         ← 숫자 컬럼만 활성
{컬럼명} - Count       ← 숫자 컬럼만 활성
{컬럼명} - Average     ← 숫자 컬럼만 활성
```
