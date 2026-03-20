# 작업자 그룹 관리 (Worker Group Management) - DB 스펙

> 작성자: 송우석
> 화면 ID: STD50A
> AS-IS 소스 경로: `C:\proActive\DecompiledSrc\`

---

## Core Tables

- **TSTD_WORKGROUP** — 작업자 그룹 마스터 (그룹 기본정보)
- **TSTD_WORKGROUP_EMP** — 그룹별 작업자 매핑 (그룹↔작업자 N:M 관계)
- **TSTD_WORKGROUP_MC** — 그룹별 작업장(설비) 매핑 (그룹↔작업장 N:M 관계)
- **TSTD_EMPLOYEE** — 작업자(사원) 마스터 (참조)
- **LSE_MACHINE** — 작업장(설비) 마스터 (참조)

---

## 1. TSTD_WORKGROUP (작업자 그룹 마스터)

> 작업자 그룹의 기본 정보를 관리하는 마스터 테이블

### 1.1 컬럼 상세

| 컬럼명       | 데이터 타입 (추정) | PK  | NULL 허용 | 기본값              | 설명                                    |
|--------------|---------------------|-----|-----------|---------------------|-----------------------------------------|
| PLT_CODE     | VARCHAR             | PK  | N         |                     | 공장코드                                |
| GROUP_NO     | VARCHAR             | PK  | N         | UTILITY_GET_SERIALNO | 그룹번호 (자동채번, 접두어 'GRP')       |
| GROUP_NAME   | NVARCHAR            |     | N         |                     | 작업자 그룹명                           |
| EMP_COUNT    | INT                 |     | Y         |                     | 소속 작업자 수                          |
| MC_COUNT     | INT                 |     | Y         |                     | 활동 작업장 수                          |
| SCOMMENT     | NVARCHAR            |     | Y         |                     | 비고                                    |
| REG_DATE     | DATETIME            |     | N         | GETDATE()           | 등록일시                                |
| REG_EMP      | VARCHAR             |     | N         | ConnInfo.UserID     | 등록자                                  |
| MDFY_DATE    | DATETIME            |     | Y         | GETDATE()           | 수정일시                                |
| MDFY_EMP     | VARCHAR             |     | Y         | ConnInfo.UserID     | 수정자                                  |
| DEL_DATE     | DATETIME            |     | Y         | GETDATE()           | 삭제일시                                |
| DEL_EMP      | VARCHAR             |     | Y         | ConnInfo.UserID     | 삭제자                                  |
| DATA_FLAG    | TINYINT             |     | N         | 0                   | 데이터 상태 (0=활성, 2=삭제)            |

### 1.2 채번 규칙

```
GROUP_NO = UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "GRP", YYYYMMDD)
예: GRP20260203001, GRP20260203002, ...
```

### 1.3 CRUD 메서드 (DA: TSTD_WORKGROUP.cs)

| 메서드                    | 동작            | 조건                            |
|---------------------------|-----------------|---------------------------------|
| TSTD_WORKGROUP_SER        | PK 단건 조회    | PLT_CODE + GROUP_NO              |
| TSTD_WORKGROUP_INS        | 신규 등록       | REG_DATE=GETDATE(), DATA_FLAG=@  |
| TSTD_WORKGROUP_UPD        | 전체 수정       | MDFY_DATE=GETDATE()              |
| TSTD_WORKGROUP_UDE        | 논리 삭제       | DEL_DATE=GETDATE(), DATA_FLAG=@  |

### 1.4 쿼리 메서드 (DA: TSTD_WORKGROUP_QUERY.cs)

| 메서드                       | 용도                 | 조건                                                                   |
|------------------------------|----------------------|------------------------------------------------------------------------|
| TSTD_WORKGROUP_QUERY1        | 메인 목록 조회       | 동적 WHERE: GROUP_NO, GROUP_LIKE(LIKE검색), DATA_FLAG                  |
| TSTD_WORKGROUP_QUERY2        | 전체 그룹 목록       | 동적 WHERE: DATA_FLAG만                                               |

**QUERY1 반환 컬럼**: PLT_CODE, GROUP_NO, GROUP_NAME, EMP_COUNT, MC_COUNT, SCOMMENT

**QUERY1 GROUP_LIKE 패턴**: `GROUP_NAME LIKE '%' + @GROUP_LIKE + '%'`

---

## 2. TSTD_WORKGROUP_EMP (그룹별 작업자 매핑)

> 그룹에 소속된 작업자를 매핑하는 관계 테이블

### 2.1 컬럼 상세

| 컬럼명       | 데이터 타입 (추정) | PK  | NULL 허용 | 기본값              | 설명                                  |
|--------------|---------------------|-----|-----------|---------------------|---------------------------------------|
| PLT_CODE     | VARCHAR             | PK  | N         |                     | 공장코드                              |
| GROUP_NO     | VARCHAR             | PK  | N         |                     | 그룹번호 (FK → TSTD_WORKGROUP)        |
| EMP_CODE     | VARCHAR             | PK  | N         |                     | 사원코드 (FK → TSTD_EMPLOYEE)         |
| EMP_SEQ      | INT/VARCHAR         |     | Y         |                     | 작업자 정렬순서                       |
| REG_DATE     | DATETIME            |     | N         | GETDATE()           | 등록일시                              |
| REG_EMP      | VARCHAR             |     | N         | ConnInfo.UserID     | 등록자                                |
| MDFY_DATE    | DATETIME            |     | Y         | GETDATE()           | 수정일시                              |
| MDFY_EMP     | VARCHAR             |     | Y         | ConnInfo.UserID     | 수정자                                |
| DEL_DATE     | DATETIME            |     | Y         | GETDATE()           | 삭제일시                              |
| DEL_EMP      | VARCHAR             |     | Y         | ConnInfo.UserID     | 삭제자                                |
| DATA_FLAG    | TINYINT             |     | N         | 0                   | 데이터 상태 (0=활성, 2=삭제)          |

### 2.2 CRUD 메서드 (DA: TSTD_WORKGROUP_EMP.cs)

| 메서드                         | 동작                  | 조건                                |
|--------------------------------|-----------------------|--------------------------------------|
| TSTD_WORKGROUP_EMP_SER         | PK 단건 조회          | PLT_CODE + GROUP_NO + EMP_CODE       |
| TSTD_WORKGROUP_EMP_SER2        | 그룹별 작업자 전체    | PLT_CODE + GROUP_NO                  |
| TSTD_WORKGROUP_EMP_INS         | 작업자 추가           | 전체 컬럼 INSERT                     |
| TSTD_WORKGROUP_EMP_UPD         | 순서 수정             | SET EMP_SEQ, MDFY_DATE               |
| TSTD_WORKGROUP_EMP_UDE         | 개별 작업자 삭제      | PLT_CODE + GROUP_NO + EMP_CODE       |
| TSTD_WORKGROUP_EMP_UDE2        | 그룹 전체 작업자 삭제 | PLT_CODE + GROUP_NO (그룹 삭제 시)   |

### 2.3 쿼리 메서드 (DA: TSTD_WORKGROUP_EMP_QUERY.cs)

| 메서드                            | 용도                    | JOIN/조건                                                        |
|-----------------------------------|-------------------------|------------------------------------------------------------------|
| TSTD_WORKGROUP_EMP_QUERY1         | 그룹별 작업자 목록      | LEFT JOIN TSTD_EMPLOYEE ON EMP_CODE → EMP_NAME, 동적 WHERE      |
| TSTD_WORKGROUP_EMP_QUERY2         | 전체 작업자 매핑 목록   | LEFT JOIN TSTD_EMPLOYEE, ORDER BY GROUP_NO, EMP_SEQ              |
| TSTD_WORKGROUP_EMP_QUERY3         | 중복 제거 작업자 목록   | LEFT JOIN TSTD_EMPLOYEE, GROUP BY PLT_CODE, EMP_CODE, EMP_NAME   |

**QUERY1 반환 컬럼**: WE.PLT_CODE, WE.GROUP_NO, WE.EMP_CODE, E.EMP_NAME, WE.EMP_SEQ

---

## 3. TSTD_WORKGROUP_MC (그룹별 작업장 매핑)

> 그룹에 할당된 작업장(설비)을 매핑하는 관계 테이블

### 3.1 컬럼 상세

| 컬럼명       | 데이터 타입 (추정) | PK  | NULL 허용 | 기본값              | 설명                                  |
|--------------|---------------------|-----|-----------|---------------------|---------------------------------------|
| PLT_CODE     | VARCHAR             | PK  | N         |                     | 공장코드                              |
| GROUP_NO     | VARCHAR             | PK  | N         |                     | 그룹번호 (FK → TSTD_WORKGROUP)        |
| MC_CODE      | VARCHAR             | PK  | N         |                     | 작업장코드 (FK → LSE_MACHINE)         |
| MC_SEQ       | INT/VARCHAR         |     | Y         |                     | 작업장 정렬순서                       |
| REG_DATE     | DATETIME            |     | N         | GETDATE()           | 등록일시                              |
| REG_EMP      | VARCHAR             |     | N         | ConnInfo.UserID     | 등록자                                |
| MDFY_DATE    | DATETIME            |     | Y         | GETDATE()           | 수정일시                              |
| MDFY_EMP     | VARCHAR             |     | Y         | ConnInfo.UserID     | 수정자                                |
| DEL_DATE     | DATETIME            |     | Y         | GETDATE()           | 삭제일시                              |
| DEL_EMP      | VARCHAR             |     | Y         | ConnInfo.UserID     | 삭제자                                |
| DATA_FLAG    | TINYINT             |     | N         | 0                   | 데이터 상태 (0=활성, 2=삭제)          |

### 3.2 CRUD 메서드 (DA: TSTD_WORKGROUP_MC.cs)

| 메서드                        | 동작                  | 조건                                |
|-------------------------------|-----------------------|--------------------------------------|
| TSTD_WORKGROUP_MC_SER         | PK 단건 조회          | PLT_CODE + GROUP_NO + MC_CODE        |
| TSTD_WORKGROUP_MC_SER2        | 그룹별 작업장 전체    | PLT_CODE + GROUP_NO                  |
| TSTD_WORKGROUP_MC_INS         | 작업장 추가           | 전체 컬럼 INSERT                     |
| TSTD_WORKGROUP_MC_UPD         | 순서 수정             | SET MC_SEQ, MDFY_DATE                |
| TSTD_WORKGROUP_MC_UDE         | 개별 작업장 삭제      | PLT_CODE + GROUP_NO + MC_CODE        |
| TSTD_WORKGROUP_MC_UDE2        | 그룹 전체 작업장 삭제 | PLT_CODE + GROUP_NO (그룹 삭제 시)   |

### 3.3 쿼리 메서드 (DA: TSTD_WORKGROUP_MC_QUERY.cs)

| 메서드                           | 용도                    | JOIN/조건                                                         |
|----------------------------------|-------------------------|-------------------------------------------------------------------|
| TSTD_WORKGROUP_MC_QUERY1         | 그룹별 작업장 목록      | LEFT JOIN LSE_MACHINE ON MC_CODE → MC_NAME, PROC_CODE, SCOMMENT  |
| TSTD_WORKGROUP_MC_QUERY2         | 전체 작업장 매핑 목록   | ORDER BY GROUP_NO, MC_SEQ                                         |

**QUERY1 반환 컬럼**: WM.PLT_CODE, WM.GROUP_NO, WM.MC_CODE, M.MC_NAME, M.PROC_CODE, WM.MC_SEQ, M.SCOMMENT

---

## 4. 참조 테이블

### 4.1 TSTD_EMPLOYEE (작업자/사원 마스터)

> STD50A에서 `TSTD_EMPLOYEE_QUERY9`로 전체 작업자 목록을 조회

| 컬럼명       | 설명               | STD50A에서의 용도                  |
|--------------|--------------------|------------------------------------|
| PLT_CODE     | 공장코드           | JOIN 조건                          |
| EMP_CODE     | 사원코드           | WORKGROUP_EMP의 FK, 그리드 표시    |
| EMP_NAME     | 사원명             | 작업자 그리드 표시                 |

### 4.2 LSE_MACHINE (작업장/설비 마스터)

> STD50A에서 `LSE_MACHINE_QUERY8`로 전체 작업장 목록 조회 (IS_ASSY=1, MC_GROUP='9999' 조건)

| 컬럼명       | 설명               | STD50A에서의 용도                  |
|--------------|--------------------|------------------------------------|
| PLT_CODE     | 공장코드           | JOIN 조건                          |
| MC_CODE      | 작업장코드         | WORKGROUP_MC의 FK, 그리드 표시     |
| MC_NAME      | 작업장명           | 작업장 그리드 표시                 |
| PROC_CODE    | 공정코드           | 작업장 그리드 표시                 |
| SCOMMENT     | 비고               | 작업장 그리드 표시                 |

---

## 5. 테이블 관계도 (ERD)

```
                    TSTD_WORKGROUP (작업자 그룹)
                    PK: PLT_CODE + GROUP_NO
                    ├── GROUP_NAME
                    ├── EMP_COUNT (비정규화, 소속 작업자 수)
                    ├── MC_COUNT  (비정규화, 활동 작업장 수)
                    └── SCOMMENT
                          │
          ┌───────────────┼───────────────┐
          │                               │
  TSTD_WORKGROUP_EMP              TSTD_WORKGROUP_MC
  PK: PLT_CODE+GROUP_NO           PK: PLT_CODE+GROUP_NO
     +EMP_CODE                       +MC_CODE
  ├── EMP_SEQ                     ├── MC_SEQ
  │                               │
  └── FK → TSTD_EMPLOYEE          └── FK → LSE_MACHINE
          ├── EMP_CODE                   ├── MC_CODE
          └── EMP_NAME                   ├── MC_NAME
                                         ├── PROC_CODE
                                         └── SCOMMENT
```

**관계 요약**:
- TSTD_WORKGROUP ↔ TSTD_WORKGROUP_EMP: 1:N (한 그룹에 여러 작업자)
- TSTD_WORKGROUP ↔ TSTD_WORKGROUP_MC: 1:N (한 그룹에 여러 작업장)
- TSTD_WORKGROUP_EMP → TSTD_EMPLOYEE: N:1 (작업자 이름 참조)
- TSTD_WORKGROUP_MC → LSE_MACHINE: N:1 (작업장 이름/공정 참조)

---

## 6. 비즈니스 로직 (BR: STD50A.cs)

### 6.1 메서드 요약

| 메서드          | 기능                       | 호출 DA                                                              |
|-----------------|----------------------------|----------------------------------------------------------------------|
| STD50A_SER      | 그룹 목록 조회             | TSTD_WORKGROUP_QUERY1 (DATA_FLAG=0)                                  |
| STD50A_SER2     | 그룹 상세 조회 (작업자+작업장) | TSTD_WORKGROUP_EMP_QUERY1 + TSTD_WORKGROUP_MC_QUERY1                |
| STD50A_SER3     | 전체 작업자/작업장 후보 목록   | TSTD_EMPLOYEE_QUERY9(IS_ASSY=1) + LSE_MACHINE_QUERY8(MC_GROUP=9999) |
| STD50A_INS      | 그룹 등록/수정 + 작업자/작업장 동기화 | 복합 UPSERT (아래 상세)                                     |
| STD50A_DEL      | 그룹 삭제 (연쇄)           | WORKGROUP_UDE + WORKGROUP_EMP_UDE2 + WORKGROUP_MC_UDE2               |

### 6.2 STD50A_SER2 상세

> 메인 화면에서 그룹 행 선택 시 호출, 2개 DataTable 동시 반환

```
입력: PLT_CODE, GROUP_NO
결과:
  - RSLTDT_EMP: 해당 그룹의 작업자 목록 (EMP_CODE, EMP_NAME, EMP_SEQ)
  - RSLTDT_MC:  해당 그룹의 작업장 목록 (MC_CODE, MC_NAME, PROC_CODE, MC_SEQ, SCOMMENT)
```

### 6.3 STD50A_SER3 상세

> 팝업 초기화 시 호출, 추가 가능한 전체 후보 목록 제공

```
조건: DATA_FLAG=0, IS_ASSY=1, MC_GROUP='9999'
결과:
  - RSLTDT_EMP: 전체 사원 목록 (TSTD_EMPLOYEE_QUERY9)
  - RSLTDT_MC:  전체 작업장 목록 (LSE_MACHINE_QUERY8)
```

### 6.4 STD50A_INS 상세 흐름

```
1. TSTD_WORKGROUP 처리:
   a. TSTD_WORKGROUP_SER(PK 조회) → 존재 여부 확인
   b. 존재 시:
      - OVERWRITE != "1" 이면:
        - DATA_FLAG=2(이력) → 에러 100002
        - 그 외 → 에러 100001
      - OVERWRITE == "1" → TSTD_WORKGROUP_UPD (덮어쓰기)
   c. 미존재 시:
      - GROUP_NO 자동채번 (GRP + YYYYMMDD)
      - TSTD_WORKGROUP_INS

2. 신규 그룹인 경우 → 채번된 GROUP_NO를 EMP/MC 테이블에 일괄 설정

3. 작업자 삭제 처리 (RQSTDT_EMP_DEL):
   - 각 행에 대해 SER → 존재하면 UDE (DATA_FLAG=2)

4. 작업자 추가 처리 (RQSTDT_EMP_INS):
   - 각 행에 대해 SER → 미존재면 INS, 존재하면 UPD (재활성화)

5. 작업장 삭제 처리 (RQSTDT_MC_DEL):
   - 각 행에 대해 SER → 존재하면 UDE (DATA_FLAG=2)

6. 작업장 추가 처리 (RQSTDT_MC_INS):
   - 각 행에 대해 SER → 미존재면 INS, 존재하면 UPD (재활성화)

7. STD50A_SER 재호출 → 최신 그룹 목록 반환
```

**핵심 패턴**: 작업자/작업장 매핑은 "삭제 후 재등록" 시 기존 데이터를 UPD로 복원하는 방식. 물리 삭제 대신 DATA_FLAG 토글로 관리.

### 6.5 STD50A_DEL 상세 (연쇄 삭제)

```
1. TSTD_WORKGROUP_UDE     → 그룹 마스터 논리 삭제 (DATA_FLAG=2)
2. TSTD_WORKGROUP_EMP_UDE2 → 그룹 소속 전체 작업자 논리 삭제
3. TSTD_WORKGROUP_MC_UDE2  → 그룹 소속 전체 작업장 논리 삭제
```

### 6.6 DataSet 테이블 구성 (INS 호출 시)

| 테이블명          | 용도                                                 |
|-------------------|------------------------------------------------------|
| RQSTDT            | 그룹 기본정보 (GROUP_NO, GROUP_NAME, MC_COUNT 등)    |
| RQSTDT_EMP_INS    | 추가할 작업자 목록 (PLT_CODE, GROUP_NO, EMP_CODE, EMP_SEQ) |
| RQSTDT_EMP_DEL    | 삭제할 작업자 목록 (PLT_CODE, GROUP_NO, EMP_CODE)    |
| RQSTDT_MC_INS     | 추가할 작업장 목록 (PLT_CODE, GROUP_NO, MC_CODE, MC_SEQ)  |
| RQSTDT_MC_DEL     | 삭제할 작업장 목록 (PLT_CODE, GROUP_NO, MC_CODE)     |

---

## 7. 화면 구성

### 7.1 메인 화면 (STD50A_M0A)

```
┌─────────────────────────────────────────────────────┐
│ [조회]                                        도구상자│
├─────────────────────────────────────────────────────┤
│ 검색조건                                            │
│ 작업자 그룹명: [____________]  ← GROUP_LIKE 검색    │
├─────────────────────────────────────────────────────┤
│ 그룹 목록 (acGridView1)                             │
│ ┌─────────────┬──────────┬─────────┬──────────────┐ │
│ │ 작업자 그룹명│ 활동 작업장 수│ 작업자 수│ 비고       │ │
│ │ (GROUP_NAME)│ (MC_COUNT) │(EMP_COUNT)│(SCOMMENT) │ │
│ │ Hidden: GROUP_NO, KeyColumn: GROUP_NO            │ │
│ └──────────────────────────────────────────────────┘ │
├──────────────────────┬──────────────────────────────┤
│ 작업장 (acGridView2) │ 작업자 (acGridView3)        │
│ ┌──────────────────┐ │ ┌──────────────────────────┐ │
│ │ 작업장코드       │ │ │ 작업자코드              │ │
│ │ 작업장명         │ │ │ 작업자명                │ │
│ │ 공정코드         │ │ │ Hidden: GROUP_NO        │ │
│ │ 비고             │ │ │ Key: GROUP_NO+EMP_CODE  │ │
│ │ Hidden: GROUP_NO │ │ └──────────────────────────┘ │
│ │ Key: GROUP_NO    │ │                              │
│ │     +MC_CODE     │ │                              │
│ └──────────────────┘ │                              │
└──────────────────────┴──────────────────────────────┘
│                                          StatusBar   │
└─────────────────────────────────────────────────────┘
```

**레이아웃**: 3단 수직 분할
1. 상단: 검색조건 (GROUP_LIKE)
2. 중단: 그룹 목록 그리드 (acGridView1)
3. 하단: 좌우 분할 — 좌=작업장(acGridView2), 우=작업자(acGridView3)

**마스터-디테일 동작**: 그룹 목록에서 행 선택 시 → `STD50A_SER2` 호출 → 하단 작업장/작업자 그리드 갱신

**우클릭 컨텍스트 메뉴**:

| 메뉴 항목  | 표시 조건  | 동작                |
|-----------|-----------|---------------------|
| 새로만들기 | 항상       | D0A 팝업 NEW 모드   |
| 열기       | 행 선택 시 | D0A 팝업 OPEN 모드  |
| 삭제       | 행 선택 시 | 삭제 확인 → DEL     |

**더블클릭**: 그룹 행 더블클릭 → D0A 팝업 OPEN 모드

### 7.2 등록/수정 팝업 (STD50A_D0A) — "작업자 그룹 편집기"

```
┌───────────────────────────────────────────────────────────────┐
│ [초기화] [저장] [저장닫기] [삭제]                        도구상자│
├───────────────────────────────────────────────────────────────┤
│ 작업자 그룹명: [__________]  작업장수: [__]  작업자수: [__]   │
│ 비고:          [                                           ]  │
│                [                                           ]  │
├───────────────────────────────────────────────────────────────┤
│ ┌─── 작업장 ────────────────────────────────────────────────┐ │
│ │ ┌── 활동 가능 작업장 (좌) ──┐ ┌── 작업장 리스트 (우) ──┐ │ │
│ │ │ MC_NAME | PROC_CODE |비고 │ │ MC_NAME |PROC_CODE|비고 │ │ │
│ │ │ (소속 작업장)             │ │ (전체 작업장 후보)     │ │ │
│ │ │ 우클릭:삭제 / 더블클릭    │ │ 우클릭:추가 / 더블클릭 │ │ │
│ │ └──────────────────────────┘ └─────────────────────────┘ │ │
│ └───────────────────────────────────────────────────────────┘ │
│ ┌─── 작업자 ────────────────────────────────────────────────┐ │
│ │ ┌── 소속 작업자 (좌) ──────┐ ┌── 작업자 리스트 (우) ──┐  │ │
│ │ │ EMP_CODE | EMP_NAME      │ │ EMP_CODE | EMP_NAME    │  │ │
│ │ │ (소속 작업자)             │ │ (전체 작업자 후보)     │  │ │
│ │ │ 우클릭:삭제 / 더블클릭    │ │ 우클릭:추가 / 더블클릭 │  │ │
│ │ └──────────────────────────┘ └────────────────────────┘  │ │
│ └───────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────┘
```

**모드별 버튼 표시**:

| 모드   | 초기화 | 저장 | 저장닫기 | 삭제 |
|--------|--------|------|----------|------|
| NEW    | O      | O    | X        | X    |
| OPEN   | X      | X    | O        | O    |

**기본 정보 입력 필드**:

| 필드명       | 컬럼명       | 필수 | 읽기전용 | 설명                                  |
|-------------|-------------|------|----------|---------------------------------------|
| 작업자 그룹명 | GROUP_NAME | Y    | N        | 그룹명 입력                           |
| 작업장수     | MC_COUNT    | N    | Y        | 소속 작업장 수 (자동 계산)            |
| 작업자수     | EMP_COUNT   | N    | Y        | 소속 작업자 수 (자동 계산)            |
| 비고         | SCOMMENT    | N    | N        | MemoEdit                              |

**MC_COUNT/EMP_COUNT 자동 계산**: 좌측 그리드(소속)의 RowCountChanged 이벤트 → 자동으로 해당 필드값 갱신

**4개 그리드 구성**:

| 그리드       | 위치      | 용도                    | 데이터 소스              | 조작                    |
|-------------|-----------|-------------------------|--------------------------|-------------------------|
| acGridView1 | 작업장-좌 | 소속 작업장 (활동 가능)  | STD50A_SER2 RSLTDT_MC    | 우클릭 "삭제" / 더블클릭→삭제 |
| acGridView2 | 작업장-우 | 전체 작업장 후보 리스트  | STD50A_SER3 RSLTDT_MC    | 우클릭 "추가" / 더블클릭→추가 |
| acGridView3 | 작업자-좌 | 소속 작업자              | STD50A_SER2 RSLTDT_EMP   | 우클릭 "삭제" / 더블클릭→삭제 |
| acGridView4 | 작업자-우 | 전체 작업자 후보 리스트  | STD50A_SER3 RSLTDT_EMP   | 우클릭 "추가" / 더블클릭→추가 |

**추가/삭제 동작**:

| 동작              | 설명                                                                        |
|-------------------|-----------------------------------------------------------------------------|
| 작업장 추가 (우→좌) | 우측 작업장 리스트에서 선택 → 좌측 소속 그리드에 추가 (중복 체크: MC_CODE)  |
| 작업장 삭제 (좌→)   | 좌측 소속 그리드에서 제거 → _removeMcTable에 삭제 대상 기록                |
| 작업자 추가 (우→좌) | 우측 작업자 리스트에서 선택 → 좌측 소속 그리드에 추가 (중복 체크: EMP_CODE) |
| 작업자 삭제 (좌→)   | 좌측 소속 그리드에서 제거 → _removeEmpTable에 삭제 대상 기록              |

**삭제 후 재추가 처리**: 삭제 목록(_removeXxxTable)에 기록된 항목을 다시 추가하면, 삭제 목록에서도 제거 (서버 전송 시 불필요한 DELETE-INSERT 방지)

**저장 시 순서(SEQ) 계산**: 저장 시점에 좌측 그리드의 현재 행 순서를 기반으로 MC_SEQ/EMP_SEQ를 1부터 순차 할당

---

## 8. AS-IS 소스 파일 매핑

| 구분           | AS-IS 파일                                                     | 용도                              |
|----------------|----------------------------------------------------------------|-----------------------------------|
| DA (데이터)    | `CUBIZ_DA\DSTD\TSTD_WORKGROUP.cs`                             | 그룹 마스터 CRUD                  |
| DA (쿼리)      | `CUBIZ_DA\DSTD\TSTD_WORKGROUP_QUERY.cs`                       | 그룹 목록 조회                    |
| DA (데이터)    | `CUBIZ_DA\DSTD\TSTD_WORKGROUP_EMP.cs`                         | 그룹-작업자 매핑 CRUD             |
| DA (쿼리)      | `CUBIZ_DA\DSTD\TSTD_WORKGROUP_EMP_QUERY.cs`                   | 그룹-작업자 조회 (JOIN EMPLOYEE)  |
| DA (데이터)    | `CUBIZ_DA\DSTD\TSTD_WORKGROUP_MC.cs`                          | 그룹-작업장 매핑 CRUD             |
| DA (쿼리)      | `CUBIZ_DA\DSTD\TSTD_WORKGROUP_MC_QUERY.cs`                    | 그룹-작업장 조회 (JOIN MACHINE)   |
| BR (비즈니스)  | `CUBIZ_BR\BSTD\STD50A.cs`                                     | STD50A 비즈니스 로직              |
| 화면 (메인)    | `STD\STD\STD50A_M0A.cs`                                       | 메인 화면                         |
| 화면 (팝업)    | `STD\STD\STD50A_D0A.cs`                                       | 등록/수정 팝업                    |

---

## 9. TO-BE 전환 시 고려사항

### 9.1 파일 구조

```
TO-BE:
  Java:   com.wsc.std.std50a/Std50aController.java, Std50aService.java, ...
  Mapper: resources/mappers/com/wsc/std/std50a/Std50a.xml
  JSP:    WEB-INF/views/std/std50a/std50a.jsp          (메인)
          WEB-INF/views/std/std50a/std50a_d0a.jsp       (팝업)
  JS:     resources/js/std/std50a/std50a.js             (메인)
          resources/js/std/std50a/std50a_d0a.js          (팝업)
  URL:    /std/std50a/std50a.do
          /std/std50a/std50a_d0a.do
```

### 9.2 핵심 전환 포인트

| 항목                    | AS-IS                                 | TO-BE                                               |
|-------------------------|---------------------------------------|------------------------------------------------------|
| 마스터-디테일            | FocusedRowChanged 이벤트              | AJAX 호출 (그룹 행 클릭 → 작업자/작업장 조회 API)   |
| 작업장/작업자 추가/삭제  | 화면 내 그리드 간 이동 (4그리드)      | jQuery 기반 좌우 리스트 전환 또는 더블리스트 패턴    |
| 5개 DataTable 동시 전송  | DataSet에 RQSTDT/EMP_INS/EMP_DEL/MC_INS/MC_DEL | JSON 객체로 구조화하여 단일 API 호출           |
| UPSERT 패턴             | SER → 존재 여부 → INS/UPD             | MyBatis에서 동일 패턴                                |
| 연쇄 삭제               | BR에서 3개 테이블 순차 UDE            | Service 레이어에서 @Transactional로 처리             |
| SEQ 자동 계산            | 저장 시 그리드 순서 기반 1부터 할당    | 프런트엔드에서 인덱스 기반 SEQ 생성                  |
| 자동채번                 | UTILITY_GET_SERIALNO(GRP,YYYYMMDD)    | TSYS_SERIAL 테이블 기반 시퀀스                       |
| EMP_COUNT/MC_COUNT 비정규화 | 화면에서 계산, DB에도 저장          | Service 레이어에서 COUNT 쿼리 또는 화면 값 사용      |

### 9.3 MySQL 전환 시 주의사항

- `GETDATE()` → `NOW()`
- `UTIL.GetValidValue(ConnInfo.UserID)` → MyBatis `#{regEmp}` 파라미터 바인딩
- GROUP_LIKE 패턴: `GROUP_NAME LIKE CONCAT('%', #{groupLike}, '%')`
