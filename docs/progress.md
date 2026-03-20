# IM_MES 마이그레이션 진행 현황

> **최종 업데이트**: 2026-02-10
> **담당자**: 송우석

---

## 진행 상태 요약

| 상태              | 개수 | 비율   |
|-------------------|------|--------|
| Done              | 7    | 54%    |
| Dead Code         | 1    | 8%     |
| Analyzing         | 4    | 31%    |
| TBD               | 1    | 8%     |
| **Total**         | 13   | 100%   |

---

## 작업 체크리스트

### STD 모듈 (기준정보)

| 완료 | 파일명       | 상태       | 진행률 | 비고                                                            |
|------|--------------|------------|--------|-----------------------------------------------------------------|
| [x]  | STD45A_M0A   | Done       | 100%   | 비가동코드관리 - Golden Sample, ASSY/MACH 탭 분리 JSP 3개      |
| [x]  | STD52A_M0A   | Done       | 100%   | 설비점검항목 관리 - 메인화면 개발완료                            |
| [x]  | STD52A_D0A   | Done       | 100%   | 설비점검항목 관리 - 편집 다이얼로그 개발완료                     |
| [ ]  | STD23A_M0A   | Analyzing  | 10%    | 설비일일CAPA관리 - 캘린더+그리드 분할, 컨텍스트메뉴2개          |
| [ ]  | STD23A_D0B   | Analyzing  | 10%    | CAPA생성 팝업 - 기간+요일+설비그리드, STD23A_INS_CAPA           |
| [ ]  | STD23A_D1B   | Analyzing  | 10%    | 휴일설정 팝업 - 날짜(readonly)+휴일명, 간단 폼                  |
| [ ]  | STD23A_D2B   | Analyzing  | 10%    | CAPA변경 팝업 - 날짜/설비(readonly)+CAPA+사유, STD23B_UPD4 호출 |
| [ ]  | STD23A_D3B   | TBD        | 0%     | CAPA일괄변경 - M0A 미참조, STD23B_INS 호출 → 범위확인 필요     |

### ORD 모듈 (주문)

| 완료 | 파일명       | 상태       | 진행률 | 비고                                                                |
|------|--------------|------------|--------|---------------------------------------------------------------------|
| [x]  | ORD02A_M0A   | Done       | 100%   | 이메일수신자그룹관리 - 좌우분할 마스터-디테일 + 사원검색 다이얼로그 |
| [x]  | ORD02A_D0A   | Done       | 100%   | 엑셀업로드 팝업 - SheetJS 파싱, overwrite 처리, 재오픈 초기화      |
| [x]  | ORD07A_M0A   | Done       | 100%   | 일련번호관리 - 모델검색+그리드(fit:true,region:center)+D0A팝업    |
| [-]  | ORD07A_M1A   | Dead Code  | -      | 거래처원장 - 메뉴 미등록, 외부 호출 없음, 비즈니스 메서드 미구현   |
| [x]  | ORD07A_D0A   | Done       | 100%   | 호기순번수정팝업 - popup-search-table, buttons바, 년도/모델readonly |

### 공통 컴포넌트

| 완료 | 파일명         | 상태       | 진행률 | 비고                                            |
|------|----------------|------------|--------|-------------------------------------------------|
| [ ]  | acEmpForm      | Pending    | 0%     | 사원 검색 팝업                                  |
| [x]  | acMachineForm  | Analyzing  | 100%   | SAP I/F 작업장 팝업 - 분석 완료 (코딩대기)      |

---

## 상세 진행 기록

### STD23A (설비 일일 CAPA 관리)

**상태**: Analyzing (10%) - AS-IS 분석 완료, 코딩 대기

#### 1. 화면 개요

캘린더(좌) + 그리드(우) 분할 레이아웃으로 설비의 일일 생산능력(CAPA)을 관리하는 화면.
캘린더에서 날짜 클릭 시 해당 일자의 설비별 CAPA 정보를 그리드에 표시한다.

#### 2. AS-IS 구조

| 파일명       | 역할                          | 핵심 기능                                      |
|--------------|-------------------------------|------------------------------------------------|
| STD23A.cs    | 비즈니스 로직                 | SER/SER1/SER4/SER5/INS_CAPA/UPD1~3/UPD5_2     |
| STD23A_M0A   | 메인 화면                     | SplitContainer(캘린더+그리드), 컨텍스트메뉴 2개 |
| STD23A_D0B   | CAPA 생성 팝업                | 기간+요일체크+설비그리드, 545×547               |
| STD23A_D1B   | 휴일설정 팝업                 | 날짜(readonly)+휴일명, 346×121                  |
| STD23A_D2B   | CAPA 변경 팝업                | 날짜/설비(readonly)+CAPA+사유, 471×191          |
| STD23A_D3B   | CAPA 일괄 변경 팝업           | **M0A 미참조**, STD23B_INS 호출 → TBD          |

#### 3. DB 테이블

| 테이블명             | 용도                    | PK                             |
|----------------------|-------------------------|--------------------------------|
| TSTD_MC_DAILYCAPA    | 설비 일일 CAPA          | PLT_CODE, MC_CODE, WORK_DATE   |
| LSE_HOLIDAY          | 휴일 마스터             | PLT_CODE, HOLI_DATE            |
| LSE_MACHINE          | 설비 마스터             | PLT_CODE, MC_CODE              |
| LSE_MC_WORKTIME      | 설비 근무시간 (요일별)  | PLT_CODE, MC_CODE, MC_SHIFT    |
| LSE_MC_CAPAPLAN      | 설비 CAPA 계획          | PLT_CODE, MC_CODE, MC_DATE     |

#### 4. 메인 화면 (M0A) 구조

- **좌측**: 캘린더 (acDateNavigator) — 날짜 클릭 시 STD23A_SER, 월 변경 시 STD23A_SER1
- **우측**: 그리드 (gcHoli) — 컬럼: SEL, WORK_DATE, MC_CODE, MC_NAME, CAPA, HOLI_NAME, FT1, FT2, FOT, SCOMMENT
- **툴바**: 조회, 도움말, 생성 (모두 Visible)
- **캘린더 우클릭**: 휴일설정(→D1B), 휴일해제(→STD23A_UPD3)
- **그리드 우클릭**: CAPA변경(→D2B), CAPA기본값설정(→STD23A_UPD1)
- **그리드 더블클릭**: CAPA변경(→D2B)

#### 5. 핵심 이슈

| 이슈                                      | 영향                                  | 대응 방안                               |
|-------------------------------------------|---------------------------------------|------------------------------------------|
| 캘린더 컴포넌트 EasyUI 미존재             | 좌측 패널 대체 구현 필요              | jQuery datepicker inline 또는 커스텀 달력 |
| D2B/D3B가 STD23B 메서드 호출              | cross-BR 의존성                       | STD23A Service에 통합 또는 별도 판단     |
| D0B CHECKZERO LayoutVisibility.Never       | 숨겨진 UI 요소                        | TO-BE에서도 제외                         |
| CAPA 계산 (shift×요일)                    | 복잡한 비즈니스 로직                  | SP에서 처리                              |
| D3B M0A 미참조                            | 전환 범위 판단 필요                   | TBD — STD23B에서 사용 여부 확인 필요     |

---

### acMachineForm (SAP I/F 작업장 팝업)

**상태**: Analyzing (100%) - 분석 완료, 코딩 대기

#### 1. 파일 구조

| 파일명              | 역할                              | 경로                                                               |
|---------------------|-----------------------------------|--------------------------------------------------------------------|
| acMachine.cs        | 컨트롤 클래스 (입력 컴포넌트)     | `DecompiledSrc\CodeHelperManager\CodeHelperManager\acMachine.cs`   |
| acMachineForm.cs    | 팝업 폼 (검색 다이얼로그)         | `DecompiledSrc\CodeHelperManager\CodeHelperManager\acMachineForm.cs` |

#### 2. 핵심 속성 (acMachine)

| 속성명           | 타입     | 설명                          | 기본값   |
|------------------|----------|-------------------------------|----------|
| `ColumnName`     | string   | 바인딩 DB 컬럼명              | null     |
| `IsSap`          | byte     | SAP 연동 플래그 (0:일반, 1:SAP) | 0        |
| `IsSimGantt`     | byte     | 시뮬레이션 간트 플래그        | 0        |
| `PARENT_MC_CODE` | string   | 상위 설비그룹 코드            | null     |
| `PROC_CODE`      | object   | 공정코드 (가용설비 필터용)    | null     |
| `AVAILEMP`       | object   | 가용사원 코드 (필터용)        | null     |
| `isRequired`     | bool     | 필수 입력 여부                | false    |
| `isReadyOnly`    | bool     | 읽기 전용 여부                | false    |
| `FindButtonVisible` | bool  | 찾기 버튼 표시 여부           | true     |

#### 3. 호출 방식 (emMethodType)

| 타입          | 설명                                  | 트리거                        |
|---------------|---------------------------------------|-------------------------------|
| `FIND`        | 팝업 열기 (검색조건 비어있음)         | 찾기 버튼 클릭, Ctrl+Enter    |
| `QUICK_FIND`  | 팝업 열기 (검색어 자동 입력)          | 텍스트 입력 후 Enter          |

#### 4. 키보드 단축키

| 단축키        | 동작                                   |
|---------------|----------------------------------------|
| `Ctrl+Enter`  | 팝업 열기 (FIND 모드)                  |
| `Enter`       | 빠른 검색 실행 (QUICK_FIND)            |
| `Delete/Back` | 값 초기화                              |
| `Ctrl+V`      | 클립보드 붙여넣기 후 검색              |
| 문자 입력     | 팝업 자동 열기 + 입력                  |

#### 5. 서비스 호출

| 서비스명                     | 용도                      | 조건                        |
|------------------------------|---------------------------|-----------------------------|
| `CONTROL_MACHINE_SEARCH`     | 설비 목록 조회            | PROC_CODE가 null일 때       |
| `CONTROL_AVAILMACHINE_SEARCH`| 가용 설비 목록 조회       | PROC_CODE가 있을 때         |

#### 6. 요청 파라미터 (RQSTDT)

| 컬럼명        | 타입     | 필수 | 설명                           |
|---------------|----------|------|--------------------------------|
| `PLT_CODE`    | string   | Y    | 공장코드 (acInfo.PLT_CODE)     |
| `MC_CODE`     | string   | N    | 설비코드 (정확히 일치)         |
| `MC_LIKE`     | string   | N    | 설비코드/명 (LIKE 검색)        |
| `MC_GROUP`    | string   | N    | 설비그룹 (PARENT_MC_CODE)      |
| `MC_NAME`     | string   | N    | 설비명 (정확히 일치)           |
| `AVAILEMP`    | string   | N    | 가용사원 코드                  |
| `PROC_CODE`   | string   | N    | 공정코드 (가용설비 조회용)     |
| `DATA_FLAG`   | byte     | N    | 데이터 플래그 (기본: 0)        |
| `IS_SAP`      | byte     | N    | SAP 설비만 조회 (1일 때)       |
| `IS_SIM_GANTT`| byte     | N    | 시뮬레이션 간트용 설비 조회    |

#### 7. 응답 컬럼 (RSLTDT)

| 컬럼명          | 레이블       | 정렬     | 표시 | 비고                  |
|-----------------|--------------|----------|------|-----------------------|
| `MC_CODE`       | 설비코드     | Center   | Y    | **KEY**               |
| `MC_NAME`       | 설비명       | Center   | Y    |                       |
| `MC_MODEL`      | 실모델명     | Center   | N    |                       |
| `MC_GROUP`      | 설비그룹     | Center   | N    | 공통코드 C020         |
| `MC_FLAG`       | 구분         | -        | N    | 공통코드 S908         |
| `MC_OPEN_DATE`  | 유효시작일   | Center   | N    |                       |
| `MC_CLOSE_DATE` | 유효종료일   | Center   | N    |                       |
| `MC_SEQ`        | 표시순서     | Right    | N    |                       |
| `CPROC_CODE`    | 임률코드     | Center   | N    |                       |
| `CPROC_NAME`    | 임률명       | Center   | N    |                       |
| `MAIN_EMP`      | 담당자코드   | Center   | N    |                       |
| `MAIN_EMP_NAME` | 담당자       | Center   | N    |                       |
| `SCOMMENT`      | 비고         | Near     | N    |                       |

#### 8. 팝업 UI 구조 (acMachineForm)

```
┌─────────────────────────────────────────────────────────┐
│ [검색] [선택]                              도구상자 Bar  │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────┐ │
│ │ 검색조건                                            │ │
│ │ 설비코드/명: [________________]                     │ │
│ └─────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────┤
│ │ 설비코드 │ 설비명 │ 설비그룹 │ 구분 │ 비고 │        │ │
│ ├──────────┼────────┼──────────┼──────┼──────┤        │ │
│ │ MC001    │ 작업장1│ 그룹A    │ 일반 │ ...  │        │ │
│ │ MC002    │ 작업장2│ 그룹B    │ SAP  │ ...  │        │ │
│ └──────────┴────────┴──────────┴──────┴──────┴────────┘ │
├─────────────────────────────────────────────────────────┤
│ 검색완료: 2건 / 0.05초                     상태 Bar     │
└─────────────────────────────────────────────────────────┘
```

#### 9. 핵심 로직 흐름

```
[사용자 입력]
     │
     ├─→ 찾기 버튼 클릭 ─→ Execute(FIND, null)
     │                          │
     ├─→ Ctrl+Enter ───────────┘
     │
     ├─→ 텍스트 입력 + Enter ─→ SetCode(value)
     │                              │
     │                    ┌─────────┴─────────┐
     │                    │ 결과 있음          │ 결과 없음
     │                    ↓                    ↓
     │               값 설정 완료         Execute(QUICK_FIND, value)
     │
     ↓
[acMachineForm 팝업]
     │
     ↓
BizRun.ExecuteService("CTRL", "CONTROL_MACHINE_SEARCH", ...)
     │
     ↓
[그리드에 결과 표시]
     │
     ├─→ 행 더블클릭 ─→ 선택 완료 (DialogResult.OK)
     │
     └─→ 선택 버튼 클릭
              │
              ↓
[OutputData = 선택된 DataRow]
     │
     ↓
[컨트롤에 MC_CODE 설정]
```

#### 10. 시스템 설정 참조

| 설정 키                       | 용도                              |
|-------------------------------|-----------------------------------|
| `CTRL_MACHINE_AUTO_FIND`      | 팝업 열릴 때 자동 검색 여부       |
| `CTRL_MACHINE_SHOW_COLUMN`    | 컨트롤에 표시할 컬럼 마스크       |
| `FOCUS_EDIT_ENABLED`          | 포커스 시 배경색 변경 여부        |
| `FOCUS_EDIT_BACKCOLOR`        | 포커스 배경색                     |
| `FOCUS_EDIT_FORECOLOR`        | 포커스 전경색                     |

#### 11. TO-BE 구현 계획

| 구분       | TO-BE 파일                                | 비고                        |
|------------|-------------------------------------------|-----------------------------|
| JSP        | `views/common/popup/machine_search.jsp`   | 팝업 화면                   |
| JS         | `js/common/popup/machine_search.js`       | 팝업 스크립트               |
| Controller | `PopupController.machineSearch()`         | 공통 팝업 컨트롤러          |
| Service    | `PopupService.selectMachineList()`        | 설비 조회 서비스            |
| Mapper     | `Popup.xml` - `selectMachineList`         | 설비 조회 쿼리              |
| Procedure  | `SP_POPUP_MACHINE_SELECT_LIST`            | 설비 목록 조회 프로시저     |

**남은 작업**:
- [ ] TO-BE 프로시저 설계 및 생성
- [ ] TO-BE Mapper XML 작성
- [ ] TO-BE Service/DAO 구현
- [ ] TO-BE Controller 구현
- [ ] TO-BE JSP/JS 구현
- [ ] 단위 테스트
- [ ] 통합 테스트

---

## AS-IS 파일 경로

| 파일명         | AS-IS 경로                                                                 |
|----------------|----------------------------------------------------------------------------|
| STD45A_M0A     | `C:\proActive\DecompiledSrc\STD\STD\STD45A_M0A.cs`                         |
| STD45A (BR)    | `C:\proActive\DecompiledSrc\CUBIZ_BR\BSTD\STD45A.cs`                       |
| STD52A_M0A     | `C:\proActive\DecompiledSrc\STD\STD\STD52A_M0A.cs`                         |
| STD52A_D0A     | `C:\proActive\DecompiledSrc\STD\STD\STD52A_D0A.cs`                         |
| STD23A (BR)    | `C:\proActive\DecompiledSrc\CUBIZ_BR\BSTD\STD23A.cs`                       |
| STD23A_M0A     | `C:\proActive\DecompiledSrc\STD\STD\STD23A_M0A.cs`                         |
| STD23A_D0B     | `C:\proActive\DecompiledSrc\STD\STD\STD23A_D0B.cs`                         |
| STD23A_D1B     | `C:\proActive\DecompiledSrc\STD\STD\STD23A_D1B.cs`                         |
| STD23A_D2B     | `C:\proActive\DecompiledSrc\STD\STD\STD23A_D2B.cs`                         |
| STD23A_D3B     | `C:\proActive\DecompiledSrc\STD\STD\STD23A_D3B.cs` **(M0A 미참조, TBD)**   |
| ORD02A_M0A     | `C:\proActive\DecompiledSrc\ORD\ORD\ORD02A_M0A.cs`                         |
| ORD02A_D0A     | `C:\proActive\DecompiledSrc\ORD\ORD\ORD02A_D0A.cs`                         |
| ORD07A_M0A     | `C:\proActive\DecompiledSrc\ORD\ORD\ORD07A_M0A.cs`                         |
| ORD07A_M1A     | `C:\proActive\DecompiledSrc\ORD\ORD\ORD07A_M1A.cs` **(Dead Code)**         |
| ORD07A_D0A     | `C:\proActive\DecompiledSrc\ORD\ORD\ORD07A_D0A.cs`                         |
| acEmpForm      | `C:\proActive\DecompiledSrc\CodeHelperManager\CodeHelperManager\acEmpForm.cs` |
| acMachineForm  | `C:\proActive\DecompiledSrc\CodeHelperManager\CodeHelperManager\acMachineForm.cs` |

---

## TO-BE 파일 경로 (예정)

| AS-IS 파일     | TO-BE Controller                          | TO-BE JSP                              | TO-BE JS                               |
|----------------|-------------------------------------------|----------------------------------------|----------------------------------------|
| STD45A_M0A     | `com.wsc.imes.std.Std45aController`       | `views/imes/std/std45a_assy.jsp`       | `js/imes/std/std45a.js`                |
| STD45A_M0A     | (위와 동일)                               | `views/imes/std/std45a_mach.jsp`       | (std45a.js 공유)                       |
| STD45A_M0A     | (위와 동일)                               | `views/imes/std/std45a_dialog.jsp`     | (std45a.js에 포함)                     |
| STD52A_M0A     | `com.wsc.imes.std.Std52aController`       | `views/imes/std/std52a.jsp`            | `js/imes/std/std52a.js`                |
| STD52A_D0A     | (위와 동일)                               | `views/imes/std/std52a_dialog.jsp`     | (std52a.js에 포함)                     |
| STD23A_M0A     | `com.wsc.imes.std.Std23aController`       | `views/imes/std/std23a.jsp`            | `js/imes/std/std23a.js`                |
| STD23A_D0B     | (위와 동일)                               | `views/imes/std/std23a_d0b.jsp`        | (std23a.js onLoad 콜백)               |
| STD23A_D1B     | (위와 동일)                               | `views/imes/std/std23a_d1b.jsp`        | (std23a.js onLoad 콜백)               |
| STD23A_D2B     | (위와 동일)                               | `views/imes/std/std23a_d2b.jsp`        | (std23a.js onLoad 콜백)               |
| ORD02A_M0A     | `com.wsc.imes.ord.Ord02aController`       | `views/imes/ord/ord02a.jsp`            | `js/imes/ord/ord02a.js`                |
| ORD02A_D0A     | (위와 동일)                               | `views/imes/ord/ord02a_d0a.jsp`        | (ord02a.js onLoad 콜백)               |
| ORD07A_M0A     | `com.wsc.imes.ord.Ord07aController`       | `views/imes/ord/ord07a.jsp`            | `js/imes/ord/ord07a.js`                |
| ORD07A_D0A     | (위와 동일)                               | `views/imes/ord/ord07a_d0a.jsp`        | (ord07a.js onLoad 콜백)               |
| acEmpForm      | `com.wsc.common.popup.PopupController`    | `views/common/popup/emp_search.jsp`    | `js/common/popup/emp_search.js`        |
| acMachineForm  | `com.wsc.common.popup.PopupController`    | `views/common/popup/machine_search.jsp`| `js/common/popup/machine_search.js`    |

---

## 일별 작업 로그

### 2026-02-10

- [x] ORD07A 분석 및 개발 완료
  - AS-IS 분석: ORD07A_M0A.cs (메인), ORD07A_D0A.cs (팝업), ORD07A.cs (비즈니스), TSYS_SERIAL.cs/TSYS_SERIAL_QUERY.cs (데이터)
  - M1A Dead Code 확인: 메뉴 미등록, 외부 호출 없음, SER2/SER3/SER4/INS 비즈니스 메서드 미구현 → 전환 범위 제외
  - DB 테이블 구조 검증: TSYS_SERIAL (PLT_CODE, SR_CODE, SR_KEY, SR_NO, IS_HOGI)
  - 백엔드: Ord07aController.java, Ord07aService.java 생성
  - 매퍼: TSYS_SERIAL.xml (UPD), TSYS_SERIAL_QUERY.xml (QUERY1) 생성
  - 프론트엔드: ord07a.jsp (메인), ord07a_d0a.jsp (편집팝업 href), ord07a.js 생성
  - SP SQL: sp_imes_tsys_serial_procedures.sql, sp_imes_tsys_serial_query_procedures.sql 생성
  - 그리드 셀 병합 구현 (년도 기준 mergeCells)
  - 상태 Done (100%)으로 업데이트
- [x] STD52A 최종 검증 및 완료 처리
  - Java (Controller, Service), JSP (메인, 다이얼로그), JS, Mapper XML 전수 검증
  - 가이드라인 대비 검증: 주석 AS-IS 흔적 제거 (CLAUDE.md 규칙 준수)
  - 상태 Done (100%)으로 업데이트
- [x] ORD02A 분석 및 개발 완료
  - ORD02A_M0A.cs, ORD02A_D0A.cs, ORD02A.cs (비즈니스) 분석
  - TORD_EMAIL_GROUP, TORD_EMAIL_GROUP_EMP 데이터 레이어 분석
  - DB 테이블 구조 검증 (TORD_EMAIL_GROUP, TORD_EMAIL_GROUP_EMP, TSTD_EMPLOYEE, TSTD_ORG)
  - Golden Sample(STD45A) 대비 GAP 분석 완료
  - 백엔드: Ord02aController.java, Ord02aService.java 생성
  - 매퍼: TORD_EMAIL_GROUP.xml, TORD_EMAIL_GROUP_QUERY.xml, TORD_EMAIL_GROUP_EMP.xml, TORD_EMAIL_GROUP_EMP_QUERY.xml, TSTD_EMPLOYEE.xml 생성
  - 프론트엔드: ord02a.jsp (분할 레이아웃 마스터-디테일), ord02a_d0a.jsp (엑셀업로드), ord02a_dialog.jsp (사원검색), ord02a.js 생성
  - 7개 서비스 메서드 구현: SER, SER2, INS, INS2, INS3, DEL, DEL2
  - 상태 Done (100%)으로 업데이트
- [x] ORD02A 전체 코드 리뷰 및 이슈 수정
  - JSP ↔ JS ID 매칭 검증 (전수 OK)
  - JS URL ↔ Controller ↔ Service ↔ Mapper 체인 검증 (전수 OK)
  - 외부 매퍼 참조 검증 (TSTD_EMPLOYEE OK)
  - 이슈1 수정: overwrite 플래그 체크 로직 Service에 추가 (ord02aIns3)
  - 이슈3 수정: D0A 팝업 재오픈 시 그리드/파일입력 초기화 로직 추가
  - 이슈2 보류: 사원검색 API (doEmpSearchQuery) 공통 연동 대기
- [x] 개발 교훈 문서화
  - MEMORY.md: ORD02A 작업 이력 및 교훈 5건 추가
  - easyui_datagrid.md: EasyUI 1.4 datagrid 패턴 6건 정리 (신규)
  - CLAUDE.md 3개 파일 업데이트: href dialog 패턴, datagrid 주의사항, 재오픈 초기화 규칙
- [x] PROGRESS.md 업무 현황 업데이트
  - 전환 요약: ORD 1완료, STD 2완료, 합계 3/213
  - 완료 이력 3건 기록, 완료 화면 상세/공통 산출물 추가
- [x] i18n 다국어 점검 및 수정 (STD52A, ORD02A, ORD07A)
  - Golden Sample(STD45A) 패턴 기준 전수 점검 (상1/중6/하1 = 총 8건)
  - 상: ORD02A D0A 팝업 getTitle/getMessage 미사용 7곳 수정
  - 중: 그리드 컬럼 JSP `<thead>` + `data_item` 이동 (STD52A, ORD07A), D0A th 라벨 `data-item` 추가, 컨텍스트 메뉴 `data-item` 추가
  - 하: ORD07A 컨텍스트 메뉴 `data-item="BTN_001"` 추가
  - 전체 8건 해소 완료
- [x] ORD07A 그리드 레이아웃 수정
  - `fit:true` 설정 추가 (그리드 컨테이너 전체 높이 채움)
  - `fitColumns:false` 명시 (컬럼 개별 width 유지)
  - `region:'center'` div 래핑 추가 (easyui-layout에서 fit 동작 필수 조건)
- [x] ORD07A D0A 팝업 UI 전면 수정
  - 팝업 title: '일련번호 수정' → '호기 순번 수정' (AS-IS 일치)
  - 테이블 클래스: `select-table accordion` → `popup-search-table` (Golden Sample 패턴)
  - th/td 클래스: 없음 → `class="h"` / `class="d"` (padding 정상화)
  - 감싸기 구조: `<fieldset class="div-line-new-sub">` 래핑 추가
  - 년도/모델: editable → `readonly:true` (AS-IS 일치, 순번만 편집)
  - 버튼: 콘텐츠 내 인라인 → dialog `buttons:'#d0a-buttons'` 하단 바로 이동
  - 버튼 구성: 저장+닫기 분리 → 저장 1개만 (AS-IS: save+close 동시 동작)
  - height: 230 고정 → 'auto' (콘텐츠 맞춤)
- [x] STD23A 사전 분석 완료 (Analyzing 10%)
  - AS-IS 소스 6개 파일 분석: STD23A.cs(BR), M0A, D0B, D1B, D2B, D3B
  - DB 테이블 5개 존재 확인: TSTD_MC_DAILYCAPA, LSE_HOLIDAY, LSE_MACHINE, LSE_MC_WORKTIME, LSE_MC_CAPAPLAN
  - 핵심 이슈 식별: 캘린더 컴포넌트 대체, D2B/D3B cross-BR 호출, D3B M0A 미참조
  - D3B TBD 판정: STD23B_INS 호출 + M0A 미참조 → 전환 범위 확인 필요
  - Golden Sample(STD45A) 대비 GAP 분석 완료
  - TO-BE 경로 수정: `com.wsc.imes.std` 패키지 (Golden Sample 패턴 일치)
- [x] ORD02A/ORD07A 전체 SP vs AS-IS 전수 대조 검증 및 수정
  - **TORD_EMAIL_GROUP_EMP_QUERY1**: alias B→E, C→O 수정, A.EMP_NAME→E.EMP_NAME 수정, orgCode 제거
  - **TORD_EMAIL_GROUP SER**: GROUP_TYPE 제거 (AS-IS에 없음), DEL_DATE/DEL_EMP/DEL_REASON 추가
  - **TORD_EMAIL_GROUP SER2**: 누락 컬럼 보충 (REG/MDFY/DEL 계열), DATA_FLAG=0 조건 제거 (AS-IS에 없음)
  - **TORD_EMAIL_GROUP INS**: SCOMMENT, DEL_REASON, DATA_FLAG 파라미터 추가
  - **TORD_EMAIL_GROUP UPD**: SCOMMENT, DATA_FLAG 파라미터 추가
  - **TORD_EMAIL_GROUP_QUERY1**: ORDER BY A.GROUP_NAME→A.MCODE, MCODE/GROUP_LIKE 선택적 필터 추가, SELECT 순서 수정
  - **TORD_EMAIL_GROUP_EMP SER**: DEL_DATE/DEL_EMP/DEL_REASON 추가
  - **TORD_EMAIL_GROUP_EMP INS/UPD**: DATA_FLAG 파라미터화 (고정값→IFNULL)
  - **TSYS_SERIAL_QUERY1**: ORDER BY 제거 (AS-IS에 없음)
  - 매퍼 XML 5개 파라미터 동기화 완료
  - sql/CLAUDE.md에 alias 보존 규칙 추가
  - MEMORY.md에 교훈 3건 추가

### 2026-02-05

- [x] progress.md 파일 생성
- [x] acMachineForm (SAP I/F 작업장 팝업) 분석 완료 (100%)
  - acMachine.cs (컨트롤 클래스) 분석
  - acMachineForm.cs (팝업 폼) 분석
  - 핵심 속성, 호출 방식, 키보드 단축키 정리
  - 서비스 호출 파라미터/응답 구조 정리
  - 시스템 설정 참조 정리
  - TO-BE 구현 계획 수립

---

## 참고 문서

- `CLAUDE.md` - 프로젝트 전체 가이드
- `src/main/resources/mappers/CLAUDE.md` - 쿼리 작성 규칙
- `src/main/webapp/WEB-INF/views/CLAUDE.md` - JSP 규칙
- `src/main/webapp/resources/js/CLAUDE.md` - JS 규칙
