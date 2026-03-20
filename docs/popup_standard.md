# Common Popup (acForm) 폴더 및 코딩 표준

> **Golden Sample**: acORGForm (부서 검색 팝업)
> **작성일**: 2026-02-11
> **작성자**: 송우석

---

## 1. 개요

AS-IS `CodeHelperManager` 네임스페이스에 정의된 공통 팝업 컨트롤(`acORG`, `acEmp`, `acMachine` 등)을
TO-BE 웹 환경(Spring MVC + EasyUI)에서 **공통 모듈**로 전환한다.

| AS-IS (C# WinForms)                     | TO-BE (Java Web)                                        |
|------------------------------------------|---------------------------------------------------------|
| `CodeHelperManager.acORGForm`            | `acORGForm.jsp` + `acORGForm.js`                       |
| `CodeHelperManager.acEmpForm`            | `acEmpForm.jsp` + `acEmpForm.js`                       |
| `CodeHelperManager.acMachineForm`        | `acMachineForm.jsp` + `acMachineForm.js`               |
| `BaseMenuDialog` 상속 → `ShowDialog()`  | `<%@ include %>` + `dialog('open')`                    |
| `OutputData` + `DialogResult.OK`        | `onSelect(row)` 콜백                                   |

---

## 2. 폴더 구조 (MANDATORY)

> 공통 팝업 모듈은 모두 `imes/com/` 경로에 배치한다.

```
src/main/webapp/
├── WEB-INF/views/imes/com/           ← JSP (팝업 HTML)
│   ├── acORGForm.jsp                  ← ✅ 구현 완료
│   ├── acEmpForm.jsp                  ← 예정
│   └── acMachineForm.jsp              ← 예정
└── resources/js/imes/com/             ← JS (팝업 로직)
    ├── acORGForm.js                   ← ✅ 구현 완료
    ├── acEmpForm.js                   ← 예정
    └── acMachineForm.js               ← 예정

src/main/resources/mappers/com/wsc/common/board/
    ├── OrgSearch.xml                  ← ✅ acORGForm 조직 조회
    ├── EmpSearch.xml                  ← 예정: acEmpForm 사원 조회
    └── MachineSearch.xml              ← 예정: acMachineForm 설비 조회

src/main/java/com/wsc/common/board/
    └── BoardController.java           ← 공통 팝업 API 엔드포인트 (기존 공유)
```

### 폴더 경로 비교

| 대상               | 일반 MES 화면                                  | 공통 팝업 모듈                                 |
|--------------------|------------------------------------------------|------------------------------------------------|
| JSP                | `views/imes/{module}/{screenId}.jsp`           | `views/imes/com/{acFormName}.jsp`              |
| JS                 | `js/imes/{module}/{screenId}.js`               | `js/imes/com/{acFormName}.js`                  |
| Mapper             | `mappers/com/wsc/imes/{module}/{TABLE}.xml`    | `mappers/com/wsc/common/board/{Name}Search.xml`|
| Controller         | `com/wsc/imes/{module}/{ScreenId}Controller`   | `com/wsc/common/board/BoardController` (공유)  |

---

## 3. acORGForm 구조 분석 (Golden Sample)

### 3.1 AS-IS 분석

| 항목                 | AS-IS (acORGForm.cs)                                                      |
|----------------------|---------------------------------------------------------------------------|
| **상속**             | `BaseMenuDialog` (모달 다이얼로그)                                        |
| **타이틀**           | `this.Text = "부서 찾기"`                                                 |
| **크기**             | `ClientSize = 366 x 507`                                                 |
| **UI 구조**          | TreeList (계층형 트리) — `acTreeList1`                                    |
| **키 필드**          | `KeyFieldName = "ORG_CODE"`, `ParentFieldName = "ORG_PARENT"`            |
| **그리드 컬럼**      | `ORG_CODE` (부서코드, Center), `ORG_NAME` (부서명, Center)               |
| **버튼**             | 조회(`acBarButtonItem1`), 확인(`acBarButtonItem2`)                        |
| **호출 서비스**      | `CTRL > CONTROL_ORG_SEARCH` (RQSTDT→RSLTDT)                              |
| **파라미터**         | `PLT_CODE` (플랜트 코드)                                                 |
| **반환 방식**        | `OutputData = dataRowView.Row.NewTable()` + `DialogResult.OK`            |
| **더블클릭**         | 행 더블클릭 → 확인(선택) 동작                                            |

### 3.2 TO-BE 구현 (acORGForm)

**JSP** (`views/imes/com/acORGForm.jsp`):

```jsp
<%@ include file="/WEB-INF/views/imes/com/acORGForm.jsp" %>
```

- `<script>` 태그로 JS 로드 + Dialog HTML 정의
- Dialog: `id="acorg-search-dialog"`, 650x550, `closed:true`, `modal:true`
- 내부: TreeGrid (`id="acorg-search-grid"`)
- 버튼: `acorg-confirm-button` (확인), `acorg-close-button` (닫기)

**JS** (`js/imes/com/acORGForm.js`):

```javascript
var acORGForm = {
    init: function(args) { ... },    // 초기화 (DOM ready 후 1회)
    open: function(opts) { ... },    // 팝업 열기
    close: function() { ... },       // 팝업 닫기
    _doSelect: function(row) { ... } // 행 선택 처리 (내부)
};
```

**Mapper** (`mappers/com/wsc/common/board/OrgSearch.xml`):

```xml
<mapper namespace="com.wsc.common.board.OrgSearch">
    <select id="treeSearch" statementType="CALLABLE" ...>
        {CALL sp_org_tree_search(#{sysId}, #{pltCode}, #{orgCode}, #{orgName})}
    </select>
</mapper>
```

**Controller** (`BoardController.java`):

```java
@RequestMapping(value = "/orgSearch/treeSearch.json")
public String orgTreeSearch(HttpServletRequest request, Model model) {
    ParamsMap params = getParams(request);
    Object result = service.search("com.wsc.common.board.OrgSearch.treeSearch", params);
    addObject(model, result);
    return "jsonView";
}
```

---

## 4. 인터페이스 및 프로토콜 (API Contract)

### 4.1 호출자 → 팝업 (입력 파라미터)

| 메서드         | 파라미터             | 설명                                          |
|----------------|----------------------|-----------------------------------------------|
| `init(args)`   | `args.onSelect`      | 기본 선택 핸들러 (Function)                    |
| `open(opts)`   | `opts.onSelect`      | 1회성 선택 핸들러 (이번 호출에만 적용)         |
| `open(opts)`   | `opts.title`         | 다이얼로그 제목 오버라이드                     |

### 4.2 팝업 → 호출자 (콜백 반환)

선택된 행 데이터를 `onSelect(row)` 콜백으로 전달:

```javascript
// acORGForm 반환 데이터
row = {
    orgCode: '3603',      // 부서코드
    orgName: '조립',       // 부서명
    id: '3603',            // TreeGrid idField
    _parentId: '3600'      // TreeGrid 부모 노드
}
```

### 4.3 호출 패턴 (사용 예시)

```javascript
// 1) 초기화 ($(function) 내에서 1회)
acORGForm.init({
    onSelect: function(row) {
        $('#f_mgOrg').val(row.orgCode);
        $('#f_mgOrgName').textbox('setValue', row.orgName);
    }
});

// 2) 열기 (버튼 클릭 이벤트에서)
$('#org-search-btn').bind('click', function() {
    acORGForm.open();
});

// 3) 1회성 핸들러로 열기 (다른 용도)
acORGForm.open({
    title: 'Department Search',
    onSelect: function(row) {
        // 다른 필드에 반영
    }
});
```

### 4.4 JSP include 위치

```jsp
<%-- 메인 JSP 하단, body.foot.jsp 직전 --%>
<%-- 다른 _dialog.jsp include 이후 --%>
<%@ include file="/WEB-INF/views/imes/com/acORGForm.jsp" %>
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
```

---

## 5. acForm 시리즈 ID 명명 규칙 (MANDATORY)

| acForm            | Dialog ID                  | Grid ID                   | 버튼 접두사         |
|-------------------|-----------------------------|---------------------------|---------------------|
| acORGForm         | `acorg-search-dialog`      | `acorg-search-grid`       | `acorg-`            |
| acEmpForm         | `acemp-search-dialog`      | `acemp-search-grid`       | `acemp-`            |
| acMachineForm     | `acmc-search-dialog`       | `acmc-search-grid`        | `acmc-`             |

### ID 패턴

```
Dialog:    ac{prefix}-search-dialog
Grid:      ac{prefix}-search-grid
확인 버튼:  ac{prefix}-confirm-button
닫기 버튼:  ac{prefix}-close-button
검색 입력:  ac{prefix}-keyword
검색 버튼:  ac{prefix}-search-button
```

---

## 6. AS-IS → TO-BE 매핑: acEmpForm (사원 검색)

### 6.1 AS-IS 분석

| 항목                 | AS-IS (acEmpForm.cs)                                                        |
|----------------------|-----------------------------------------------------------------------------|
| **타이틀**           | `this.Text = "사원찾기"`                                                    |
| **크기**             | `ClientSize = 650 x 468`                                                   |
| **UI 구조**          | 좌: TreeList(부서 트리) + 우: GridView(사원 목록) + 상단: 검색조건          |
| **검색 필드**        | `EMP_LIKE` (사원코드/명) — Enter 키 검색                                    |
| **트리 컬럼**        | `ORG_NAME` (부서명) — 트리 노드 선택 시 사원 필터                           |
| **그리드 컬럼**      | `SEL`(선택), `ORG_CODE`, `ORG_NAME`, `EMP_CODE`, `EMP_NAME`, `EMP_TYPE`, `EMP_TITLE`, `EMAIL` |
| **호출 서비스**      | 조직: `CTRL > CONTROL_ORG_SEARCH`, 사원: `CTRL > CONTROL_EMP_SEARCH`       |
| **선택 모드**        | `SelectMode=true` → 체크박스 다중선택, `false` → 단일선택(더블클릭/확인)    |
| **반환 방식**        | 단일: `focusedDataRow.NewTable()`, 다중: `SEL='1'` DataView                 |
| **트리 필터**        | 트리 노드 선택 → `ORG_CODE` 기준 사원 RowFilter                             |

### 6.2 TO-BE 파일 계획

| 레이어     | 파일 경로                                                  |
|------------|-----------------------------------------------------------|
| JSP        | `views/imes/com/acEmpForm.jsp`                            |
| JS         | `js/imes/com/acEmpForm.js`                                |
| Mapper     | `mappers/com/wsc/common/board/EmpSearch.xml`              |
| Controller | `BoardController.java` 에 API 엔드포인트 추가             |
| SP         | `sql/imes/com/sp_emp_search.sql`                          |

### 6.3 TO-BE 반환 데이터

```javascript
// 단일 선택 모드
row = {
    empCode: 'E001',
    empName: '홍길동',
    orgCode: '3603',
    orgName: '조립',
    empType: 'R',
    empTitle: 'M',
    email: 'hong@lsta.com'
}

// 다중 선택 모드 (selectMode:true)
rows = [
    { empCode: 'E001', empName: '홍길동', ... },
    { empCode: 'E002', empName: '김철수', ... }
]
```

---

## 7. AS-IS → TO-BE 매핑: acMachineForm (설비 검색)

### 7.1 AS-IS 분석

| 항목                 | AS-IS (acMachineForm.cs)                                                    |
|----------------------|-----------------------------------------------------------------------------|
| **타이틀**           | `this.Text = "설비 찾기"`                                                   |
| **크기**             | `ClientSize = 729 x 363`                                                   |
| **UI 구조**          | 상단: 검색조건 + 하단: GridView(설비 목록). TreeList 없음                   |
| **검색 필드**        | `MC_LIKE` (설비코드/명) — Enter 키 검색                                     |
| **그리드 컬럼**      | `MC_CODE`(설비코드), `MC_NAME`(설비명), `MC_GROUP`(설비그룹), `MC_FLAG`(구분), `SCOMMENT`(비고) |
| **호출 서비스**      | `CTRL > CONTROL_MACHINE_SEARCH` 또는 `CONTROL_AVAILMACHINE_SEARCH`         |
| **파라미터**         | `PLT_CODE`, `MC_LIKE`, `MC_GROUP`, `AVAILEMP`, `DATA_FLAG`, `IS_SAP`, `IS_SIM_GANTT` |
| **반환 방식**        | `focusedDataRow.NewTable()` + `DialogResult.OK`                             |
| **더블클릭**         | 행 더블클릭 → 확인(선택) 동작                                              |

### 7.2 TO-BE 파일 계획

| 레이어     | 파일 경로                                                  |
|------------|-----------------------------------------------------------|
| JSP        | `views/imes/com/acMachineForm.jsp`                        |
| JS         | `js/imes/com/acMachineForm.js`                            |
| Mapper     | `mappers/com/wsc/common/board/MachineSearch.xml`          |
| Controller | `BoardController.java` 에 API 엔드포인트 추가             |
| SP         | `sql/imes/com/sp_machine_search.sql`                      |

### 7.3 TO-BE 반환 데이터

```javascript
row = {
    mcCode: 'MC001',
    mcName: '프레스 1호기',
    mcGroup: 'PR',
    mcFlag: '1',
    scomment: '비고'
}
```

---

## 8. 공통 패턴 규칙 (acForm 시리즈 공통)

### 8.1 JS 객체 구조 (필수 인터페이스)

모든 acForm은 동일한 public API를 가진다:

```javascript
var ac{Name}Form = {
    _defaultOnSelect: null,    // init() 시 등록한 기본 핸들러
    _currentOnSelect: null,    // open() 시 1회성 핸들러
    _initialized: false,       // 중복 초기화 방지

    init: function(args) {},   // 초기화 (1회)
    open: function(opts) {},   // 팝업 열기
    close: function() {},      // 팝업 닫기
    _doSelect: function(row) {} // 선택 처리 (내부)
};
```

### 8.2 핸들러 우선순위

```
open(opts.onSelect) > init(args.onSelect)
```

- `open()`에 `onSelect` 전달 시 → 해당 호출에만 적용 (1회성)
- 없으면 `init()`에서 등록한 기본 핸들러 사용
- `open()` 종료 후 1회성 핸들러 초기화 (`_currentOnSelect = null`)

### 8.3 다이얼로그 공통 옵션

```javascript
$('#ac{prefix}-search-dialog').dialog({
    title: '{타이틀}',
    closed: true,
    modal: true,
    onOpen: function() {
        $(this).dialog('center');
        // 그리드 resize + reload
    }
});
```

### 8.4 더블클릭 선택

모든 acForm의 그리드/트리에서 행 더블클릭 → `_doSelect(row)` 호출 (AS-IS 동일 동작).

### 8.5 JSP include 방식 (신규 다이얼로그 패턴)

- 공통 팝업은 **`<%@ include %>`** 방식 사용 (별도 Controller 엔드포인트 불필요)
- JSP에 `<script>` 포함 가능 (JS 로드 전용 — 공통 모듈이므로 예외)
- Dialog ID: `ac{prefix}-search-dialog` (프로젝트 전역 고유)

### 8.6 금지 사항

| 금지 항목                                        | 사유                                              |
|--------------------------------------------------|---------------------------------------------------|
| `href` 방식으로 공통 팝업 로드                   | include가 적합 (모든 화면에서 재사용)              |
| 공통 팝업 JSP에 화면 고유 로직 포함              | 범용성 저해                                        |
| 공통 팝업 ID를 화면별로 다르게 사용              | 전역 고유 ID로 통일                                |
| `onclick` 등 인라인 이벤트 사용                  | JS `bind()` 사용 원칙                              |

---

## 9. 3종 팝업 비교 요약

| 비교 항목       | acORGForm (부서)           | acEmpForm (사원)                   | acMachineForm (설비)          |
|-----------------|----------------------------|------------------------------------|-------------------------------|
| **UI 유형**     | TreeGrid (계층형)          | TreeList(좌) + DataGrid(우)        | DataGrid (단일)               |
| **검색 입력**   | 없음 (자동 전체 조회)      | `EMP_LIKE` (사원코드/명)           | `MC_LIKE` (설비코드/명)       |
| **다중 선택**   | 불가                       | `selectMode=true` 시 가능          | 불가                          |
| **트리 필터**   | 해당 없음                  | 부서 트리 선택 → 사원 필터         | 해당 없음                     |
| **반환 키**     | `orgCode`, `orgName`       | `empCode`, `empName`, ...          | `mcCode`, `mcName`, ...       |
| **크기**        | 650x550                    | 750x550                            | 750x450                       |
