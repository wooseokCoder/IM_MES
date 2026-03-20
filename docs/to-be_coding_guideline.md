# TO-BE 코딩 가이드라인 (MES 화면 전환)

> **Golden Sample**: STD45A (비가동코드 관리)
> **작성일**: 2026-02-06
> **작성자**: 송우석

---

## 1. 개요

이 문서는 ProActive C# → Java Web (Spring MVC + MyBatis) 전환 프로젝트의 표준 코딩 가이드라인입니다.
모든 MES 화면은 **STD45A를 기준 샘플**로 삼아 동일한 구조와 패턴을 따릅니다.

### 가이드 문서 구성

| 문서                                              | 내용                               |
|---------------------------------------------------|------------------------------------|
| **본 문서** (`to-be_coding_guideline.md`)         | 개요, 패키지 구조, 탭 분리, 체크리스트 |
| [`to-be_guide_java.md`](to-be_guide_java.md)     | Controller / Service 패턴          |
| [`to-be_guide_xml.md`](to-be_guide_xml.md)       | MyBatis Mapper XML 패턴            |
| [`to-be_guide_jsp.md`](to-be_guide_jsp.md)       | JSP 화면 패턴                      |
| [`to-be_guide_js.md`](to-be_guide_js.md)         | JavaScript 패턴                    |

### Golden Sample 파일 목록

| 레이어         | 파일                                                              | 역할                   |
|----------------|-------------------------------------------------------------------|------------------------|
| Controller     | `com/wsc/imes/std/Std45aController.java`                         | 요청 라우팅, 파라미터 처리 |
| Service        | `com/wsc/imes/std/Std45aService.java`                            | 비즈니스 로직           |
| Mapper (CRUD)  | `mappers/com/wsc/imes/std/TSTD_IDLECODE.xml`                    | 테이블 CRUD 프로시저    |
| Mapper (QUERY) | `mappers/com/wsc/imes/std/TSTD_IDLECODE_QUERY.xml`              | 조회 전용 프로시저      |
| JSP (조립)     | `views/imes/std/std45a_assy.jsp`                                 | 화면 마크업             |
| JSP (가공)     | `views/imes/std/std45a_mach.jsp`                                 | 화면 마크업 (변형)      |
| JS             | `js/imes/std/std45a.js`                                          | 화면 로직               |

---

## 2. 패키지 구조 (MES 전환용)

### 2.1 디렉토리 레이아웃

```
com/wsc/imes/{module}/
    {ScreenId}Controller.java    ← @Controller
    {ScreenId}Service.java       ← @Service extends BaseService

mappers/com/wsc/imes/{module}/
    {TABLE_NAME}.xml             ← 테이블별 CRUD 매퍼
    {TABLE_NAME}_QUERY.xml       ← 테이블별 조회 전용 매퍼

views/imes/{module}/
    {screenId}_{suffix}.jsp      ← 화면 JSP

js/imes/{module}/
    {screenId}.js                ← 화면 JS (공용)
```

### 2.2 STD45A 예시

```
com/wsc/imes/std/
    Std45aController.java
    Std45aService.java

mappers/com/wsc/imes/std/
    TSTD_IDLECODE.xml
    TSTD_IDLECODE_QUERY.xml

views/imes/std/
    std45a_assy.jsp
    std45a_mach.jsp

js/imes/std/
    std45a.js
```

### 2.3 핵심 차이점: DAO 없음

> MES 전환 화면은 **별도 DAO 인터페이스/구현체를 만들지 않는다.**
> 대신 `CommonDao`를 주입받고, `BaseService`의 `xxxByMapper()` 메서드로 매퍼를 직접 호출한다.

| 항목              | 기존 WSC 방식 (CLAUDE.md)                    | MES 전환 방식 (Golden Sample)          |
|-------------------|----------------------------------------------|----------------------------------------|
| DAO               | `{ScreenId}Dao.java` + `{ScreenId}DaoImpl.java` | **없음** (`CommonDao` 공유)         |
| Service Interface | `{ScreenId}Service.java` (인터페이스)        | **없음** (구현 클래스만)               |
| Service 구현      | `{ScreenId}ServiceImpl.java`                 | `{ScreenId}Service.java` (@Service)    |
| Mapper namespace  | `com.wsc.{module}.{screenId}.{ScreenId}Dao`  | `com.wsc.imes.{module}.{TABLE_NAME}`   |
| Mapper 파일명     | `{ScreenId}.xml`                              | `{TABLE_NAME}.xml` (테이블 기반)       |
| 데이터 접근       | `xxxDao.selectList(params)`                   | `searchByMapper(NS, id, params)`       |

---

## 3. 탭(Tab) 분리 규칙 (MANDATORY)

> **AS-IS에서 탭(Tab) 구조로 된 화면은 TO-BE에서 탭을 제거하고, 각 탭을 독립된 별도 파일로 분리한다.**

### 3.1 원칙

AS-IS C# WinForms에서 `TabControl`/`XtraTabControl`로 구성된 화면은
TO-BE 웹 환경에서 **탭 UI를 사용하지 않는다.**
각 탭은 독립된 화면 파일(JSP + JS)로 분리하고, 메뉴에서 각각 별도 진입점을 가진다.

### 3.2 분리 구조

```
AS-IS (C# WinForms 탭 구조):
  ORD45A_M0A.cs
    ├── Tab1: 조립 (PLANTS=3603)
    └── Tab2: 가공 (PLANTS=3605)

TO-BE (독립 파일 분리):
  Controller:  Ord45aController.java       ← 1개 (공유)
  Service:     Ord45aService.java          ← 1개 (공유)
  Mapper:      TORD_TABLE.xml              ← 1개 (공유)
  JSP:         ord45a_assy.jsp             ← 탭1 → 독립 화면
               ord45a_mach.jsp             ← 탭2 → 독립 화면
  JS:          ord45a.js                   ← 1개 (공유, 조건 분기)
```

### 3.3 Golden Sample 참조: STD45A

| AS-IS 탭               | TO-BE 파일                | 구분값              |
|-------------------------|---------------------------|---------------------|
| Tab1: 조립              | `std45a_assy.jsp`         | `PLANTS = '3603'`   |
| Tab2: 가공              | `std45a_mach.jsp`         | `PLANTS = '3605'`   |
| 공통 로직               | `std45a.js` (1개 공유)    | `PAGE_PLANTS` 분기  |

### 3.4 파일 명명 규칙

> 분리된 각 화면 파일은 `{screenId}_{suffix}.jsp` 형식으로 명명한다.

| 탭 의미            | suffix 예시          | 파일명 예시            |
|--------------------|----------------------|------------------------|
| 조립               | `assy`               | `ord45a_assy.jsp`      |
| 가공               | `mach`               | `ord45a_mach.jsp`      |
| 제품               | `prod`               | `std10a_prod.jsp`      |
| 반제품             | `semi`               | `std10a_semi.jsp`      |
| 일별               | `daily`              | `rep01a_daily.jsp`     |
| 월별               | `monthly`            | `rep01a_monthly.jsp`   |

### 3.5 공유 계층과 분리 계층

| 계층       | 공유 여부 | 설명                                                      |
|------------|-----------|-----------------------------------------------------------|
| Controller | **공유**  | 1개 Controller에 탭별 화면 오픈 메서드를 각각 정의         |
| Service    | **공유**  | 1개 Service에 모든 비즈니스 로직 포함                      |
| Mapper     | **공유**  | 동일 테이블이면 매퍼 공유                                  |
| JSP        | **분리**  | 탭마다 별도 JSP 파일, 서버에서 구분값 주입                 |
| JS         | **조건부**| 탭 간 로직이 유사하면 1개 공유 + `PAGE_*` 변수 분기, 로직이 크게 다르면 별도 JS |

### 3.6 Controller 탭 분리 패턴

> 상세 Controller 구조: [`to-be_guide_java.md` §1.4](to-be_guide_java.md)

```java
// 탭1: 조립 화면 오픈
@RequestMapping(value = "/ord45a_assy.do")
public String openAssy(HttpServletRequest request, Model model) {
    super.open(request, model);
    model.addAttribute("plants", "3603");
    model.addAttribute("plantsName", "조립");
    return "imes/ord/ord45a_assy";
}

// 탭2: 가공 화면 오픈
@RequestMapping(value = "/ord45a_mach.do")
public String openMach(HttpServletRequest request, Model model) {
    super.open(request, model);
    model.addAttribute("plants", "3605");
    model.addAttribute("plantsName", "가공");
    return "imes/ord/ord45a_mach";
}

// API 엔드포인트는 탭과 무관하게 공유 (plants 파라미터로 구분)
```

### 3.7 JSP/JS 탭 분리 패턴

> 상세 JSP 패턴: [`to-be_guide_jsp.md` §5](to-be_guide_jsp.md)
> 상세 JS 패턴: [`to-be_guide_js.md` §3](to-be_guide_js.md)

```jsp
<%-- ord45a_assy.jsp --%>
<script type="text/javascript">
    var PAGE_PLANTS = '${plants}';          // '3603'
    var PAGE_PLANTS_NAME = '${plantsName}'; // '조립'
    var PAGE_SHOW_EXTRA = false;            // 탭별 차이점 플래그
</script>
<script src="<c:url value="/resources/js/imes/ord/ord45a.js" />"></script>
```

```javascript
// 공유 JS에서 PAGE_* 변수로 탭별 차이 처리
if (typeof PAGE_SHOW_EXTRA !== 'undefined' && PAGE_SHOW_EXTRA) {
    columns[0].push({ field: 'extraColumn', title: '가공전용', width: 120 });
}
```

### 3.8 JS 분리 기준

| 기준       | 조건                                                       | 결과             |
|------------|------------------------------------------------------------|------------------|
| 공유 (1 JS)| 그리드 컬럼 90% 이상 동일, 검색 조건 동일, CRUD 로직 동일  | `{screenId}.js`  |
| 분리 (N JS)| 그리드 구조 완전히 다름, 검색 조건 다름, 저장 로직 다름     | `{screenId}_{suffix}.js` |

### 3.9 금지 사항

| 금지 항목                                  | 사유                                           |
|--------------------------------------------|------------------------------------------------|
| TO-BE에서 `easyui-tabs` 등 탭 UI 사용      | 탭 분리 원칙 위반, 독립 화면으로 관리           |
| 하나의 JSP에 탭 콘텐츠를 모두 포함          | 파일 비대화, 유지보수 어려움                    |
| 탭별 별도 Controller/Service 생성           | 과도한 파일 분리, 공유 로직 중복                |
| suffix 없이 동일 screenId로 파일 생성       | 파일명 충돌, 구분 불가                          |

### 3.10 체크리스트: 탭 분리 화면

- [ ] AS-IS에서 TabControl/XtraTabControl 존재 여부 확인
- [ ] 각 탭의 구분값(PLANTS, TYPE 등) 식별
- [ ] 탭별 JSP 파일 생성: `{screenId}_{suffix}.jsp`
- [ ] Controller에 탭별 화면 오픈 메서드 추가
- [ ] JSP에 `PAGE_*` 서버 변수 주입
- [ ] JS 공유 가능 여부 판단 (컬럼/로직 유사성)
- [ ] 공유 JS인 경우 `PAGE_*` 조건 분기 구현
- [ ] API 엔드포인트는 탭과 무관하게 공유 확인
- [ ] 메뉴 등록: 각 탭을 별도 메뉴 항목으로 등록

---

## 4. 명명 규칙

### 4.1 파일명 규칙

| 대상       | 규칙                               | 예시                          |
|------------|-------------------------------------|-------------------------------|
| Controller | `{ScreenId}Controller.java`         | `Std45aController.java`      |
| Service    | `{ScreenId}Service.java`            | `Std45aService.java`         |
| CRUD 매퍼  | `{TABLE_NAME}.xml`                  | `TSTD_IDLECODE.xml`          |
| QUERY 매퍼 | `{TABLE_NAME}_QUERY.xml`            | `TSTD_IDLECODE_QUERY.xml`    |
| JSP        | `{screenId}_{suffix}.jsp` (소문자)  | `std45a_assy.jsp`             |
| JS         | `{screenId}.js` (소문자)            | `std45a.js`                   |

### 4.2 메서드명 변환 규칙

> AS-IS 메서드명을 camelCase로 변환하되, 원본 이름을 최대한 유지한다.
> 매퍼 Statement ID는 AS-IS 원본 그대로 유지한다.

| AS-IS (C#)               | TO-BE (Java 메서드)   | TO-BE (매퍼 ID)         | 변환 규칙                    |
|---------------------------|-----------------------|-------------------------|------------------------------|
| `STD45A_SER`              | `std45aSer()`         | -                       | 언더바 제거 + camelCase       |
| `STD45A_INS`              | `std45aIns()`         | -                       | 언더바 제거 + camelCase       |
| `STD45A_UPD`              | `std45aUpd()`         | -                       | 언더바 제거 + camelCase       |
| `STD45A_DEL`              | `std45aDel()`         | -                       | 언더바 제거 + camelCase       |
| `TSTD_IDLECODE_SER`      | -                     | `TSTD_IDLECODE_SER`    | 매퍼 ID는 원본 유지           |
| `TSTD_IDLECODE_QUERY1`   | -                     | `TSTD_IDLECODE_QUERY1` | 매퍼 ID는 원본 유지           |

### 4.3 URL 매핑 규칙

```
화면 오픈:  /imes/{module}/{screenId}.do
           /imes/{module}/{screenId}_{suffix}.do  (탭 분리 화면)

API 호출:  /imes/{module}/{screenId}/{SCREEN_ID}_SER.json   (조회)
           /imes/{module}/{screenId}/{SCREEN_ID}_INS.json   (등록)
           /imes/{module}/{screenId}/{SCREEN_ID}_UPD.json   (수정)
           /imes/{module}/{screenId}/{SCREEN_ID}_DEL.json   (삭제)

예시:
  /imes/std/std45a_assy.do              ← 화면 오픈 (조립)
  /imes/std/std45a/STD45A_SER.json      ← 목록 조회
  /imes/std/std45a/STD45A_INS.json      ← 신규/수정 (UPSERT)
  /imes/std/std45a/STD45A_UPD.json      ← 그리드 일괄 수정
  /imes/std/std45a/STD45A_DEL.json      ← 논리 삭제
```

### 4.4 JSP ID/Name 규칙

| 용도             | 접두사/ID             | 예시                         |
|------------------|-----------------------|------------------------------|
| 검색 필드        | `s_`                  | `s_idleLike`, `s_plants`     |
| 폼 필드          | `f_`                  | `f_scode`, `f_idleCode`      |
| 그리드           | `search-grid`         |                              |
| 검색 툴바        | `search-toolbar`      |                              |
| 편집 다이얼로그  | `edit-dialog`         |                              |
| 조회/신규/저장/삭제 버튼 | `search-button`, `new-button`, `save-button`, `delete-button` | |

---

## 5. EasyUI Layout 규칙 (MANDATORY)

### 5.1 `region:'center'` 필수

> `easyui-layout` 안에서 datagrid `fit:true`가 동작하려면, datagrid를 반드시 `region:'center'` div로 감싸야 한다.

```jsp
<div class="easyui-layout" data-options="fit:true" id="account-layout">
    <!-- ★ 반드시 region:'center' 포함 -->
    <div data-options="region:'center', border:false">
        <table id="search-grid"><thead>...</thead></table>
    </div>
    <div data-options="region:'north', border:true" id="search-grid-panel"></div>
</div>
```

| 원인                                      | 증상                                                    |
|-------------------------------------------|---------------------------------------------------------|
| `region:'center'` 없음                    | datagrid가 `fit:true`인데도 컨테이너를 채우지 않음      |
| 컬럼이 많은 화면(STD45A 등)               | 시각적으로 차이 안 보여 발견 어려움                     |

### 5.2 D0A href 팝업 폼/버튼 패턴

> D0A 팝업(`_d0a.jsp`)은 팝업 전용 CSS + 메인 JSP에 별도 버튼 div를 사용한다.

**팝업 폼 CSS**:

| 항목           | 올바른 값                | 잘못된 값 (금지)             |
|----------------|--------------------------|------------------------------|
| 외부 padding   | `10px 20px`              | padding 없음                 |
| fieldset class | `div-line-new-sub`       | `Remake-div-line-new`        |
| table class    | `popup-search-table`     | `select-table accordion`     |
| th/td class    | `h` / `d`               | `table-Search-h` 등         |

**버튼 배치**: 메인 JSP에 `<div id="d0a-buttons">` + dialog `buttons:'#d0a-buttons'` 옵션

### 5.3 AS-IS 팝업 속성 확인 체크리스트

- [ ] `this.Text` → dialog `title` (메인 화면명과 다를 수 있음)
- [ ] `ReadOnly = true` → `readonly:true` 반영
- [ ] `DialogResult.OK + Close()` → 저장 버튼 1개(save+close), 별도 닫기 버튼 불필요
- [ ] `ClientSize` → `width`/`height` (height는 `'auto'` 권장)

---

## 6. WEB-INF/classes 동기화 규칙

> 매퍼 XML은 반드시 **두 곳에 동일하게** 배치한다.

```
src/main/resources/mappers/com/wsc/imes/{module}/{TABLE_NAME}.xml          ← 원본
src/main/webapp/WEB-INF/classes/mappers/com/wsc/imes/{module}/{TABLE_NAME}.xml  ← 복사본
```

---

## 7. 체크리스트: 새 화면 개발

### 7.1 백엔드 → [`to-be_guide_java.md`](to-be_guide_java.md) + [`to-be_guide_xml.md`](to-be_guide_xml.md)

- [ ] Controller 생성: `com.wsc.imes.{module}.{ScreenId}Controller.java`
- [ ] Service 생성: `com.wsc.imes.{module}.{ScreenId}Service.java`
- [ ] CRUD 매퍼 생성: `mappers/com/wsc/imes/{module}/{TABLE_NAME}.xml`
- [ ] QUERY 매퍼 생성: `mappers/com/wsc/imes/{module}/{TABLE_NAME}_QUERY.xml`
- [ ] WEB-INF/classes에 매퍼 복사본 배치
- [ ] Controller: `extends BaseController`, `getService()`, `getSessionComponent()` 오버라이드
- [ ] Service: `extends BaseService`, `getDao()`, `getMessageSource()`, `getSessionComponent()` 오버라이드
- [ ] Service: Namespace 상수 정의
- [ ] Service: 쓰기 메서드에 `@Transactional` 적용
- [ ] 매퍼: 모든 쿼리 `statementType="CALLABLE"`, `parameterType="params"`, `resultType="record"`

### 7.2 프론트엔드 → [`to-be_guide_jsp.md`](to-be_guide_jsp.md) + [`to-be_guide_js.md`](to-be_guide_js.md)

- [ ] JSP 생성: `views/imes/{module}/{screenId}.jsp`
- [ ] JS 생성: `js/imes/{module}/{screenId}.js`
- [ ] JSP: 공통 include 5종 (common, body.head, topnav, topnav2, body.foot)
- [ ] JSP: 검색 영역 + 버튼 영역 + 권한 버튼 (`disabled:${RET/INS/UPD/DEL}`)
- [ ] JSP: 인라인 이벤트 없음 (onclick 등 금지)
- [ ] JS: `consts.url` 상수, `getUrl()` 사용
- [ ] JS: 초기화 순서 준수
- [ ] JS: 포맷터, 다국어 함수

### 7.3 AS-IS 검증 (필수)

- [ ] 테이블명 확인: AS-IS C# 소스에서 실제 사용 테이블 확인
- [ ] 컬럼명 확인: 그리드 컬럼이 해당 기능과 일치하는지 확인
- [ ] 교차 검증: 메뉴명 ↔ 테이블명 ↔ 그리드 컬럼 모두 일치 확인
- [ ] 숨김 기능 확인: `BarItemVisibility.Never` 버튼 → 개발 범위 제외
- [ ] 라벨 정확성: AS-IS Caption과 TO-BE 라벨 정확히 일치

---

## 8. 공통 팝업 (acForm) 폴더 및 코딩 표준

> **Golden Sample**: acORGForm (부서 검색 팝업)
> **상세 문서**: [`popup_standard.md`](popup_standard.md)

### 8.1 개요

AS-IS `CodeHelperManager` 네임스페이스의 공통 팝업(`acORGForm`, `acEmpForm`, `acMachineForm`)을
TO-BE에서 **`imes/com/`** 경로에 공통 모듈로 구현한다.

### 8.2 폴더 구조

```
views/imes/com/             ← JSP (팝업 HTML + JS 로드)
    acORGForm.jsp            ← ✅ 구현 완료
    acEmpForm.jsp            ← 예정
    acMachineForm.jsp        ← 예정

js/imes/com/                ← JS (팝업 로직)
    acORGForm.js             ← ✅ 구현 완료
    acEmpForm.js             ← 예정
    acMachineForm.js         ← 예정

mappers/com/wsc/common/board/  ← Mapper (조회 전용)
    OrgSearch.xml             ← ✅ 구현 완료
    EmpSearch.xml             ← 예정
    MachineSearch.xml         ← 예정
```

### 8.3 사용법 (호출 화면에서)

**JSP** — 메인 JSP 하단, `body.foot.jsp` 직전에 include:

```jsp
<%@ include file="/WEB-INF/views/imes/com/acORGForm.jsp" %>
```

**JS** — `$(function)` 내에서 초기화 + 버튼 이벤트에서 열기:

```javascript
// 초기화
acORGForm.init({
    onSelect: function(row) {
        $('#f_orgCode').val(row.orgCode);
        $('#f_orgName').textbox('setValue', row.orgName);
    }
});

// 열기
$('#org-search-btn').bind('click', function() {
    acORGForm.open();
});
```

### 8.4 공통 인터페이스

모든 acForm 모듈은 동일한 public API를 제공한다:

| 메서드           | 파라미터                     | 설명                                  |
|------------------|------------------------------|---------------------------------------|
| `init(args)`     | `args.onSelect: Function`    | 초기화 (1회), 기본 선택 핸들러 등록   |
| `open(opts)`     | `opts.onSelect`, `opts.title`| 팝업 열기, 1회성 핸들러/제목 오버라이드 |
| `close()`        | 없음                         | 팝업 닫기                             |

### 8.5 ID 명명 규칙

| acForm          | Dialog ID                | Grid ID                 | 접두사     |
|-----------------|--------------------------|-------------------------|------------|
| acORGForm       | `acorg-search-dialog`    | `acorg-search-grid`     | `acorg-`   |
| acEmpForm       | `acemp-search-dialog`    | `acemp-search-grid`     | `acemp-`   |
| acMachineForm   | `acmc-search-dialog`     | `acmc-search-grid`      | `acmc-`    |

---

## 부록 A: 프레임워크 데이터 모델

> 상세 사용법: [`to-be_guide_java.md` §3](to-be_guide_java.md)

### ParamsMap 자동 주입 세션 값

| 키             | 설명             | 용도                           |
|----------------|------------------|--------------------------------|
| `gsSysId`      | 시스템 ID        | 시스템 구분                    |
| `gsUserId`     | 사용자 ID        | 등록자/수정자 기록             |
| `gsUserName`   | 사용자 이름      | 표시용                         |
| `gsLang`       | 언어 코드        | 다국어 처리                    |
| `gsPltCode`    | 플랜트 코드      | 사업장 구분 (MES 필수)         |
| `gsOrgCode`    | 조직 코드        | 부서 구분                      |
| `gsGrupId`     | 그룹 ID          | 권한 그룹                      |

### ResultMap JSON 응답 형식

```json
{ "success": true, "message": "저장되었습니다." }
{ "success": false, "message": "저장 실패: 중복된 코드입니다." }
```

---

## 부록 B: 모듈 코드

| 모듈 코드 | 설명         |
|-----------|--------------|
| `std`     | 기준정보     |
| `ord`     | 생산계획     |
| `pop`     | 생산실적     |
| `pln`     | 일정계획     |
| `qct`     | 품질관리     |
| `pur`     | 구매관리     |
| `rep`     | 리포트       |
| `mat`     | 자재관리     |
| `his`     | 이력관리     |
| `mnt`     | 설비관리     |
| `tol`     | 공구관리     |
| `sys`     | 시스템관리   |
