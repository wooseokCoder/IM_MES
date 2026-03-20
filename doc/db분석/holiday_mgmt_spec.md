# 휴일관리 (Holiday Management) - AS-IS 분석 명세서

> **작성자**: 송우석
> **화면 ID**: STD23A (메인), STD23B (변형)
> **모듈**: STD (기준정보)
> **AS-IS 소스 경로**: `C:\proActive\DecompiledSrc\`

---

## Core Tables

- **LSE_HOLIDAY** — 휴일 마스터
- **TSTD_MC_DAILYCAPA** — 설비 일별 CAPA (휴일 시 CAPA=0 처리)
- **LSE_MACHINE** — 설비 마스터 (설비코드/설비명 참조)
- **LSE_MC_WORKTIME** — 설비 근무시간 (요일별 CAPA 산정 기준)
- **LSE_MC_CAPAPLAN** — 설비 CAPA 계획 (교대별 상세 CAPA)
- **TSTD_CODES** — 공통코드 (A004: 기본 CAPA 설정값)

---

## 1. 테이블 상세 명세

### 1.1 LSE_HOLIDAY (휴일 마스터)

> 공장별 휴일 날짜와 휴일명을 관리하는 테이블. 물리 삭제(DELETE) 방식 사용.

| 컬럼명       | 데이터 타입 | PK | NULL 허용 | 설명       | 비고                        |
|-------------|------------|:--:|:---------:|-----------|----------------------------|
| PLT_CODE    | VARCHAR    | O  | N         | 공장 코드  | 복합 PK 1                  |
| HOLI_DATE   | VARCHAR    | O  | N         | 휴일 날짜  | 복합 PK 2, YYYYMMDD 형식    |
| HOLI_NAME   | VARCHAR    | -  | Y         | 휴일명     | 예: 신정, 추석 등            |

**PK 구성**: `PLT_CODE` + `HOLI_DATE` (2컬럼 복합키)

**특이사항**:
- 매우 단순한 3컬럼 구조
- 논리 삭제(DATA_FLAG) 패턴을 사용하지 않음 — **물리 삭제(DELETE)** 방식
- 감사 컬럼(REG_DATE, REG_EMP 등) 없음
- 휴일 등록/해제 시 연관 CAPA 테이블 동시 처리

### 1.2 TSTD_MC_DAILYCAPA (설비 일별 CAPA)

> 설비별 일별 생산 가용시간(CAPA)을 관리하는 테이블. 휴일 등록 시 CAPA=0 처리됨.

| 컬럼명       | 데이터 타입 | PK | NULL 허용 | 설명                     | 비고                   |
|-------------|------------|:--:|:---------:|-------------------------|------------------------|
| PLT_CODE    | VARCHAR    | O  | N         | 공장 코드                | 복합 PK 1              |
| MC_CODE     | VARCHAR    | O  | N         | 설비 코드                | 복합 PK 2              |
| WORK_DATE   | VARCHAR    | O  | N         | 작업 일자 (YYYYMMDD)     | 복합 PK 3              |
| CAPA        | DECIMAL    | -  | Y         | 가용 시간 (분)           | 휴일 시 0으로 설정      |
| SCOMMENT    | VARCHAR    | -  | Y         | CAPA 변경사유            |                        |

**PK 구성**: `PLT_CODE` + `MC_CODE` + `WORK_DATE`

### 1.3 LSE_MACHINE (설비 마스터) — 참조 테이블

| 컬럼명         | 데이터 타입 | PK | 설명              | 비고                           |
|---------------|------------|:--:|-------------------|-------------------------------|
| PLT_CODE      | VARCHAR    | O  | 공장 코드          | 복합 PK 1                     |
| MC_CODE       | VARCHAR    | O  | 설비 코드          | 복합 PK 2                     |
| MC_NAME       | VARCHAR    | -  | 설비명             |                               |
| MC_GROUP      | VARCHAR    | -  | 설비 그룹          | 코드 C020 참조                 |
| MC_SHIFT      | TINYINT    | -  | 교대 수 (1/2/3)    | CAPA 계산에 사용               |
| MC_SEQ        | INT        | -  | 설비 순번          | 정렬에 사용                    |
| MC_MGT_FLAG   | TINYINT    | -  | 관리 대상 플래그    | 1=관리대상 (CAPA 조회 필터)     |
| DATA_FLAG     | TINYINT    | -  | 삭제 플래그        | 0=활성                        |

### 1.4 LSE_MC_WORKTIME (설비 근무시간) — 참조 테이블

> 설비별 요일별 근무시간을 저장. CAPA 자동 산정의 기준 데이터.

| 컬럼명       | 데이터 타입 | 설명                 | 비고           |
|-------------|------------|---------------------|----------------|
| PLT_CODE    | VARCHAR    | 공장 코드            | PK 1           |
| MC_CODE     | VARCHAR    | 설비 코드            | PK 2           |
| MON_TIME    | DECIMAL    | 월요일 근무시간 (분)  |                |
| TUE_TIME    | DECIMAL    | 화요일 근무시간 (분)  |                |
| WED_TIME    | DECIMAL    | 수요일 근무시간 (분)  |                |
| THR_TIME    | DECIMAL    | 목요일 근무시간 (분)  |                |
| FRI_TIME    | DECIMAL    | 금요일 근무시간 (분)  |                |
| SAT_TIME    | DECIMAL    | 토요일 근무시간 (분)  |                |
| SUN_TIME    | DECIMAL    | 일요일 근무시간 (분)  |                |

### 1.5 LSE_MC_CAPAPLAN (설비 CAPA 계획) — 참조 테이블

> 설비별 일자별 교대 상세 CAPA(1교대/2교대/3교대 + 잔업)를 저장.

| 컬럼명       | 데이터 타입 | 설명                  | 비고       |
|-------------|------------|----------------------|------------|
| PLT_CODE    | VARCHAR    | 공장 코드             | PK 1       |
| MC_CODE     | VARCHAR    | 설비 코드             | PK 2       |
| MC_DATE     | VARCHAR    | 작업 일자             | PK 3       |
| FT1         | FLOAT      | 1교대 정규시간 1      |            |
| FT2         | FLOAT      | 1교대 정규시간 2      |            |
| FOT         | FLOAT      | 1교대 잔업시간        |            |
| SD1         | FLOAT      | 2교대 정규시간 1      |            |
| SD2         | FLOAT      | 2교대 정규시간 2      |            |
| SOT         | FLOAT      | 2교대 잔업시간        |            |
| TD1         | FLOAT      | 3교대 정규시간 1      |            |
| TD2         | FLOAT      | 3교대 정규시간 2      |            |
| TOT         | FLOAT      | 3교대 잔업시간        |            |
| SCOMMENT    | VARCHAR    | CAPA 변경사유         |            |
| CAPA        | DECIMAL    | 총 CAPA              | 교대합계    |

---

## 2. Entity Relationship (엔티티 관계)

```
                        ┌───────────────────────────────────────┐
                        │           LSE_HOLIDAY                 │
                        │          (휴일 마스터)                 │
                        │───────────────────────────────────────│
                        │  PK: PLT_CODE + HOLI_DATE             │
                        │  HOLI_NAME (휴일명)                   │
                        └───────────┬───────────────────────────┘
                                    │
                 ┌──────────────────┼───────────────────┐
                 │ HOLI_DATE =      │ HOLI_DATE IN      │
                 │ WORK_DATE        │ (subquery)        │
                 │ (LEFT JOIN)      │ (UPDATE CAPA=0)   │
                 ▼                  ▼                   │
┌──────────────────────────────────────┐                │
│       TSTD_MC_DAILYCAPA              │                │
│      (설비 일별 CAPA)                 │                │
│──────────────────────────────────────│                │
│  PK: PLT_CODE + MC_CODE + WORK_DATE │                │
│  CAPA (가용시간, 휴일=0)             │                │
│  SCOMMENT (변경사유)                 │                │
└──────────┬───────────────────────────┘                │
           │ MC_CODE (FK)                               │
           ▼                                            │
┌──────────────────────────────────┐                    │
│        LSE_MACHINE               │                    │
│       (설비 마스터)               │                    │
│──────────────────────────────────│                    │
│  MC_CODE, MC_NAME, MC_GROUP      │                    │
│  MC_SHIFT (교대수)               │                    │
│  MC_MGT_FLAG (관리대상)          │                    │
└──────────┬───────────────────────┘                    │
           │ MC_CODE (FK)                               │
           ▼                                            │
┌──────────────────────────────────┐   ┌───────────────────────────┐
│      LSE_MC_WORKTIME             │   │     LSE_MC_CAPAPLAN       │
│    (설비 요일별 근무시간)         │   │   (설비 CAPA 계획)         │
│──────────────────────────────────│   │───────────────────────────│
│  MON_TIME ~ SUN_TIME (요일별)    │   │  FT1,FT2,FOT (1교대)     │
│  → 기본 CAPA 산정 기준           │   │  SD1,SD2,SOT (2교대)     │
└──────────────────────────────────┘   │  TD1,TD2,TOT (3교대)     │
                                       │  CAPA (합계)              │
                                       └───────────────────────────┘
```

**관계 설명**:
- `LSE_HOLIDAY` ↔ `TSTD_MC_DAILYCAPA`: WORK_DATE = HOLI_DATE로 LEFT JOIN, 휴일 등록 시 해당 일자의 모든 설비 CAPA를 0으로 설정
- `TSTD_MC_DAILYCAPA` → `LSE_MACHINE`: MC_CODE로 JOIN하여 설비명/설비그룹 표시
- `LSE_MACHINE` → `LSE_MC_WORKTIME`: MC_CODE로 요일별 기본 근무시간 조회
- `LSE_MACHINE` → `LSE_MC_CAPAPLAN`: MC_CODE + MC_DATE로 교대별 상세 CAPA 관리

---

## 3. 비즈니스 로직 (Business Logic)

### 3.1 소스 파일 위치

| 구분           | 파일 경로                                                    |
|---------------|-------------------------------------------------------------|
| STD23A BR     | `CUBIZ_BR\BSTD\STD23A.cs`                                   |
| STD23B BR     | `CUBIZ_BR\BSTD\STD23B.cs`                                   |
| 휴일 DA        | `CUBIZ_DA\DLSE\LSE_HOLIDAY.cs`                               |
| 휴일 쿼리 DA   | `CUBIZ_DA\DLSE\LSE_HOLIDAY_QUERY.cs`                        |
| CAPA DA        | `CUBIZ_DA\DSTD\TSTD_MC_DAILYCAPA.cs`                        |
| CAPA 쿼리 DA   | `CUBIZ_DA\DSTD\TSTD_MC_DAILYCAPA_QUERY.cs`                 |
| STD23A 메인    | `STD\STD\STD23A_M0A.cs`                                     |
| STD23A CAPA 팝업 | `STD\STD\STD23A_D0B.cs`                                   |
| STD23A 휴일설정 팝업 | `STD\STD\STD23A_D1B.cs`                                |
| STD23B 메인    | `STD\STD\STD23B_M0A.cs`                                     |

### 3.2 STD23A 메서드 상세

#### STD23A_SER — 설비별 일별 CAPA 조회 (메인 그리드)

```
입력: PLT_CODE, DATE1, DATE2 (선택 날짜)
쿼리: TSTD_MC_DAILYCAPA_QUERY5
  → TSTD_MC_DAILYCAPA A
    LEFT JOIN LSE_MACHINE B ON A.MC_CODE = B.MC_CODE
    LEFT JOIN LSE_HOLIDAY C ON A.WORK_DATE = C.HOLI_DATE
  → WHERE: PLT_CODE, WORK_DATE BETWEEN, MC_MGT_FLAG=1, DATA_FLAG=0
  → ORDER BY: PLT_CODE, WORK_DATE, MC_SEQ, MC_CODE
출력: PLT_CODE, WORK_DATE, MC_CODE, MC_NAME, CAPA, HOLI_NAME, MC_GROUP, SCOMMENT
```

#### STD23A_SER1 — 휴일 목록 조회 (캘린더 표시용)

```
입력: PLT_CODE, S_HOLI_DATE, E_HOLI_DATE
쿼리: LSE_HOLIDAY_QUERY1
  → SELECT PLT_CODE, HOLI_DATE AS DISP_HOLI_DATE, HOLI_DATE, HOLI_NAME
  → WHERE: PLT_CODE, HOLI_DATE BETWEEN 시작~종료
출력: 캘린더 HoliDayTable에 바인딩 → 휴일 날짜 표시
```

#### STD23A_SER4 — 설비별 요일 CAPA 산정

```
입력: PLT_CODE, MC_CODE, WEEK (요일명)
처리:
  1. LSE_MACHINE_SER → MC_SHIFT(교대수) 조회
  2. LSE_MC_WORKTIME_SER → 요일별 근무시간 조회
  3. 요일(WEEK)에 따라 해당 요일 시간 반환:
     - Sunday → SUN_TIME
     - Monday → MON_TIME
     - ... Saturday → SAT_TIME
출력: CAPA (해당 요일 근무시간)
```

#### STD23A_SER5 — 관리 대상 설비 목록 조회

```
입력: PLT_CODE
쿼리: LSE_MACHINE_QUERY7
  → WHERE: DATA_FLAG=0, MC_MGT_FLAG=1
출력: 설비 목록 (MC_CODE, MC_NAME, MC_GROUP)
```

#### STD23A_INS_CAPA — CAPA 일괄 생성 (D0B 팝업)

```
입력:
  - RQSTDT: PLT_CODE, FR_DATE, TO_DATE, CHECKZERO, 요일별 적용 플래그(Sunday~Saturday)
  - RQSTDT2: 대상 설비 목록 (MC_CODE)

처리 흐름:
  1. FR_DATE ~ TO_DATE 기간의 모든 날짜를 생성
  2. 각 날짜 × 각 설비에 대해:
     a. 해당 요일이 적용 대상이면:
        - 기존 CAPA 존재 여부 확인 (TSTD_MC_DAILYCAPA_SER)
        - CHECKZERO="1" → 기존 삭제 후 요일별 기본 CAPA로 재생성
        - CHECKZERO="0" → 요일별 기본 CAPA로 UPDATE
        - 미존재 → INSERT (요일별 기본 CAPA)
     b. 해당 요일이 비적용이고 CHECKZERO="1" → 삭제 후 CAPA=0으로 INSERT
  3. 마지막: LSE_HOLIDAY_UPD → 휴일 날짜의 CAPA를 0으로 일괄 UPDATE

핵심: 기간 내 휴일 날짜의 CAPA는 항상 0으로 설정
```

#### STD23A_UPD1 — CAPA 기본값으로 복원 (그리드 우클릭)

```
입력: PLT_CODE, WORK_DATE, MC_CODE (선택/체크된 행)
처리:
  1. 요일 조회 (CTRL.GetDateStringWeek)
  2. STD23A_SER4로 해당 요일 기본 CAPA 산정
  3. TSTD_MC_DAILYCAPA_UPD → CAPA 업데이트
  4. LSE_MC_CAPAPLAN 삭제 (커스텀 CAPA 초기화)
```

#### STD23A_UPD2 — 휴일 설정 (캘린더 우클릭 → "휴일설정")

```
입력: PLT_CODE, WORK_DATE, HOLI_NAME
처리:
  1. HOLI_DATE = WORK_DATE 설정
  2. LSE_HOLIDAY_SER → 이미 등록된 휴일인지 확인
  3. 미등록 시 LSE_HOLIDAY_INS → 휴일 INSERT
  4. TSTD_MC_DAILYCAPA_QUERY1 → 해당 날짜의 모든 설비 CAPA 조회
  5. CAPA=0 설정 후 TSTD_MC_DAILYCAPA_UPD → 일괄 UPDATE
```

#### STD23A_UPD3 — 휴일 해제 (캘린더 우클릭 → "휴일해제")

```
입력: PLT_CODE, HOLI_DATE
처리:
  1. LSE_HOLIDAY_DEL3 → 휴일 DELETE (물리 삭제)
  2. TSTD_MC_DAILYCAPA_QUERY1 → 해당 날짜의 모든 설비 CAPA 조회
  3. 각 설비별:
     a. 요일 조회 (CTRL.GetDateStringWeek)
     b. STD23A_SER4 → 해당 요일 기본 CAPA 산정
     c. TSTD_MC_DAILYCAPA_UPD → CAPA 복원
```

#### STD23A_UPD5_2 — CAPA 수동 수정 (D2B 팝업)

```
입력: PLT_CODE, MC_CODE, WORK_DATE + 교대별 시간 (FT1,FT2,FOT,SD1,SD2,SOT,TD1,TD2,TOT)
처리:
  1. LSE_MACHINE_SER → 교대 수(MC_SHIFT) 확인
  2. 교대 수에 따라 CAPA 합계 계산:
     - 1교대: FT1 + FT2 + FOT
     - 2교대: + SD1 + SD2 + SOT
     - 3교대: + TD1 + TD2 + TOT
  3. LSE_MC_CAPAPLAN UPSERT (존재→UPD, 미존재→INS)
  4. TSTD_MC_DAILYCAPA_UPD → 총 CAPA 업데이트
```

### 3.3 STD23B 메서드 상세

> STD23B는 STD23A의 변형 화면으로, 휴일+CAPA를 동시에 조회/관리하는 통합 뷰.

| 메서드명       | 설명                                               | STD23A 대응    |
|---------------|---------------------------------------------------|----------------|
| STD23B_SER    | 휴일 목록 + CAPA 목록 동시 조회                      | SER1 + SER     |
| STD23B_SER2   | CAPA 목록만 조회                                    | SER             |
| STD23B_INS    | CAPA 일괄 생성 (요일별 CAPA 직접 지정)               | INS_CAPA 변형   |
| STD23B_UPD2   | 휴일 설정 (STD23A_UPD2와 동일 로직)                  | UPD2            |
| STD23B_UPD3   | 휴일 해제 (CAPA 복원 포함)                           | UPD3            |
| STD23B_UPD4   | CAPA 직접 수정                                      | 단순 UPDATE     |

### 3.4 DA 메서드 목록

#### LSE_HOLIDAY DA

| 메서드명              | 유형     | 설명                                           |
|----------------------|----------|------------------------------------------------|
| LSE_HOLIDAY_SER      | SELECT   | PK(PLT_CODE+HOLI_DATE) 기준 단건 조회           |
| LSE_HOLIDAY_INS      | INSERT   | 휴일 등록 (PLT_CODE, HOLI_DATE, HOLI_NAME)      |
| LSE_HOLIDAY_UPD      | UPDATE   | 휴일 날짜의 CAPA=0 일괄 처리 **(TSTD_MC_DAILYCAPA 대상)** |
| LSE_HOLIDAY_DEL3     | DELETE   | 휴일 물리 삭제                                   |

> **주의**: `LSE_HOLIDAY_UPD`는 LSE_HOLIDAY 테이블이 아닌 **TSTD_MC_DAILYCAPA** 테이블을 UPDATE함:
> ```sql
> UPDATE TSTD_MC_DAILYCAPA SET CAPA = 0
> WHERE PLT_CODE = @PLT_CODE
>   AND WORK_DATE IN (SELECT HOLI_DATE FROM LSE_HOLIDAY WHERE PLT_CODE = @PLT_CODE)
> ```

#### LSE_HOLIDAY_QUERY DA

| 메서드명                  | 설명                                                | 사용처                         |
|--------------------------|-----------------------------------------------------|-------------------------------|
| LSE_HOLIDAY_QUERY1       | 기간 검색 (BETWEEN S_HOLI_DATE AND E_HOLI_DATE)      | STD23A_SER1, STD23B_SER, PLN14A, CTRL |
| LSE_HOLIDAY_QUERY2       | 기간 검색 (QUERY1과 동일 구조, DISP_HOLI_DATE 없음)   | ORD09A, POP31A                |
| LSE_HOLIDAY_QUERY3       | CTE로 날짜 범위 생성 + LSE_HOLIDAY LEFT JOIN + 근무일 필터 | REP07A                      |
| LSE_HOLIDAY_QUERY4       | 실적 테이블(TSHP_ACTUAL)과 JOIN하여 일별 가동 설비 수 조회 | (보고서용)                   |

---

## 4. 화면 구성 (Screen Layout)

### 4.1 STD23A_M0A — 메인 화면

```
┌──────────────────────────────────────────────────────────────┐
│ [조회] [도움말] | [생성]                                      │ ← 툴바
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌───────────────┐  ┌──────────────────────────────────────┐ │
│  │               │  │ 그리드 (설비별 일별 CAPA)              │ │
│  │  DateNavigator│  │ ┌──┬────┬──────┬──────┬────┬────┐    │ │
│  │  (캘린더)     │  │ │☑│날짜 │설비CD│설비명│CAPA│휴일명│   │ │
│  │               │  │ ├──┼────┼──────┼──────┼────┼────┤    │ │
│  │  12개월 표시   │  │ │  │0203│MC001 │조립1 │480 │    │    │ │
│  │  휴일 표시    │  │ │  │0203│MC002 │조립2 │480 │    │    │ │
│  │               │  │ │  │0204│MC001 │조립1 │  0 │설날│    │ │
│  │  우클릭 메뉴: │  │ │  │0204│MC002 │조립2 │  0 │설날│    │ │
│  │  · 휴일설정   │  │ └──┴────┴──────┴──────┴────┴────┘    │ │
│  │  · 휴일해제   │  │                                       │ │
│  │               │  │ 우클릭 메뉴:                           │ │
│  │               │  │ · CAPA 수정                            │ │
│  │               │  │ · CAPA 값을 기본데이터로 복원            │ │
│  └───────────────┘  └──────────────────────────────────────┘ │
│                                                               │
└──────────────────────────────────────────────────────────────┘
  레이아웃: SplitContainer 좌=캘린더(281px) / 우=그리드
```

**그리드 컬럼 상세 (gvHoli)**:

| 컬럼명       | 표시명          | 정렬     | 편집 | 가시성 | 유형       | 비고              |
|-------------|----------------|:--------:|:----:|:-----:|-----------|-------------------|
| SEL         | 선택            | -        | O    | O     | CheckEdit | 다건 선택용        |
| WORK_DATE   | 날짜            | Center   | N    | O     | DateEdit  | SHORT_DATE 형식    |
| MC_CODE     | 설비코드        | Center   | N    | O     | TextEdit  |                   |
| MC_NAME     | 설비명          | Center   | N    | O     | TextEdit  |                   |
| CAPA        | CAPA           | Far      | N    | O     | TextEdit  | TIME 마스크        |
| HOLI_NAME   | 휴일명          | Center   | N    | O     | TextEdit  | 휴일 시 표시       |
| FT1         | 정규            | Far      | N    | O     | TextEdit  | TIME 마스크        |
| FT2         | 정규            | Far      | N    | O     | TextEdit  | TIME 마스크        |
| FOT         | 잔업            | Far      | N    | O     | TextEdit  | TIME 마스크        |
| SCOMMENT    | CAPA 변경사유   | Near     | N    | O     | TextEdit  |                   |

**동작 요약**:

| 이벤트                    | 동작                                              |
|--------------------------|---------------------------------------------------|
| 캘린더 날짜 클릭          | 선택 날짜의 설비별 CAPA 그리드 표시 (STD23A_SER)    |
| 캘린더 월 이동            | 해당 기간 휴일 재조회 → 캘린더 갱신 (STD23A_SER1)   |
| 캘린더 우클릭 → 휴일설정   | D1B 팝업 오픈 → 휴일 등록 + CAPA=0 (STD23A_UPD2)  |
| 캘린더 우클릭 → 휴일해제   | 휴일 삭제 + CAPA 복원 (STD23A_UPD3)                |
| 그리드 더블클릭            | D2B 팝업 → CAPA 수동 수정 (STD23A_UPD5_2)          |
| 그리드 우클릭 → CAPA 수정  | D2B 팝업 → CAPA 수동 수정                          |
| 그리드 우클릭 → 기본 복원  | 요일별 기본 CAPA로 복원 (STD23A_UPD1)               |
| 툴바 [생성]               | D0B 팝업 → 기간/요일별 CAPA 일괄 생성               |

### 4.2 STD23A_D0B — CAPA 일괄 생성 팝업

```
┌─────────────────────────────────────────────────────┐
│ [저장]                                               │
├─────────────────────────────────────────────────────┤
│                                                      │
│  시작일: [2025-01-01]    종료일: [2025-12-31]         │
│  ☐ 기존데이터 초기화 후 재설정                        │
│                                                      │
│  ┌─────────────────────────────────────────┐         │
│  │ 요일 적용 설정                           │         │
│  │ ☑월  ☑화  ☑수  ☑목  ☑금  ☑토  ☑일    │         │
│  └─────────────────────────────────────────┘         │
│                                                      │
│  ⚠ 해당기간 내 등록된 휴일의 CAPA 는 0으로 설정됩니다 │
│                                                      │
│  ┌─────────────────────────────────────────┐         │
│  │ 대상 설비 목록                           │         │
│  │ ☑ MC001 조립1  라인A                    │         │
│  │ ☑ MC002 조립2  라인A                    │         │
│  │ ☐ MC003 가공1  라인B                    │         │
│  └─────────────────────────────────────────┘         │
│                                                      │
└─────────────────────────────────────────────────────┘
  크기: 약 550 x 500 px
```

**D0B 폼 구성**:

| 컨트롤          | 컬럼명       | 설명                              | 기본값                |
|----------------|-------------|----------------------------------|----------------------|
| acDateEdit1    | FR_DATE     | 시작일                            | 당해 1월 1일          |
| acDateEdit2    | TO_DATE     | 종료일                            | 당해 12월 31일        |
| acCheckEdit1   | CHECKZERO   | 기존데이터 초기화 여부              | 미체크                |
| acGridView2    | 요일 체크    | MON,TUE,WED,THR,FRI,SAT,SUN       | 전체 체크             |
| acGridView1    | 설비 목록    | SEL, MC_CODE, MC_NAME, MC_GROUP    | STD23A_SER5 조회      |
| acLabelControl | -           | 휴일 CAPA=0 안내 메시지             | 고정 텍스트           |

### 4.3 STD23A_D1B — 휴일 설정 팝업

```
┌──────────────────────────────────────┐
│ 휴일설정                              │
├──────────────────────────────────────┤
│ [저장]                                │
├──────────────────────────────────────┤
│  날짜: [2025-02-03]  ← ReadOnly     │
│  휴일명: [설날       ]                │
└──────────────────────────────────────┘
  크기: 346 x 121 px (최소 362 x 160)
```

**D1B 폼 구성**:

| 컨트롤      | 컬럼명          | 라벨   | ReadOnly | 설명                        |
|------------|----------------|--------|:--------:|----------------------------|
| dateEdit1  | HoliDateTime   | 날짜   | O        | 캘린더 선택 날짜 (변경 불가)  |
| textEdit1  | HoliReason     | 휴일명 | N        | 휴일 사유 입력               |

### 4.4 STD23B_M0A — 변형 메인 화면

> STD23A와 유사한 레이아웃이나 그리드에 **휴일 목록**만 표시 (CAPA 그리드 없음).

```
┌──────────────────────────────────────────────────────────────┐
│ [조회] [도움말] | [생성] [수정]                                │
├──────────────────────────────────────────────────────────────┤
│  ┌───────────────┐  ┌──────────────────────────────────────┐ │
│  │  DateNavigator │  │ 휴일 목록 그리드                      │ │
│  │  (캘린더)      │  │ ┌──────────┬──────────┐              │ │
│  │  12개월 표시   │  │ │  날짜     │  휴일명   │              │ │
│  │               │  │ ├──────────┼──────────┤              │ │
│  │  우클릭:      │  │ │ 2025-01-01│ 신정     │              │ │
│  │  · 휴일설정   │  │ │ 2025-02-03│ 설날     │              │ │
│  │  · 휴일해제   │  │ └──────────┴──────────┘              │ │
│  └───────────────┘  └──────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

**STD23B 그리드 컬럼**:

| 컬럼명         | 표시명    | 정렬     | 편집 | 가시성 | 비고                   |
|---------------|----------|:--------:|:----:|:-----:|------------------------|
| DISP_HOLI_DATE | 날짜    | Center   | N    | O     | DateEdit (표시용)       |
| HOLI_DATE     | 날짜     | Center   | N    | N     | 숨김 (내부 데이터)       |
| HOLI_NAME     | 휴일명   | Near     | N    | O     |                        |

---

## 5. SQL 패턴

### 5.1 휴일 목록 조회 (LSE_HOLIDAY_QUERY1)

```sql
SELECT
    PLT_CODE,
    HOLI_DATE AS DISP_HOLI_DATE,
    HOLI_DATE,
    HOLI_NAME
FROM LSE_HOLIDAY
WHERE PLT_CODE = @PLT_CODE
  AND HOLI_DATE BETWEEN @S_HOLI_DATE AND @E_HOLI_DATE  -- 선택적
```

### 5.2 CAPA + 휴일 통합 조회 (TSTD_MC_DAILYCAPA_QUERY5)

```sql
SELECT
    A.PLT_CODE,
    A.WORK_DATE,
    A.MC_CODE,
    B.MC_NAME,
    A.CAPA,
    C.HOLI_NAME,
    B.MC_GROUP,
    A.SCOMMENT
FROM TSTD_MC_DAILYCAPA A
    LEFT JOIN LSE_MACHINE B
        ON A.MC_CODE = B.MC_CODE AND A.PLT_CODE = B.PLT_CODE
    LEFT JOIN LSE_HOLIDAY C
        ON A.WORK_DATE = C.HOLI_DATE AND A.PLT_CODE = C.PLT_CODE
WHERE A.PLT_CODE = @PLT_CODE
  AND A.WORK_DATE BETWEEN @DATE1 AND @DATE2  -- 선택적
  AND B.MC_MGT_FLAG = 1
  AND B.DATA_FLAG = 0
ORDER BY A.PLT_CODE, A.WORK_DATE, B.MC_SEQ, A.MC_CODE
```

### 5.3 근무일 + CAPA 계산 (LSE_HOLIDAY_QUERY3) — 리포트용

```sql
WITH CTE (DT) AS (
    SELECT CONVERT(VARCHAR(8), @S_DATE, 112)
    UNION ALL
    SELECT CONVERT(VARCHAR(8), DATEADD(D, 1, DT), 112)
    FROM CTE
    WHERE DT < @E_DATE
)
SELECT
    LEFT(DT, 4) AS YEAR_DATE,
    LEFT(DT, 6) AS MONTH_DATE,
    DT AS DAY_DATE,
    DATENAME(DW, DT) AS 'DATE_NAME',
    CONVERT(INT, ISNULL(
        (SELECT TOP 1 VALUE FROM TSTD_CODES
         WHERE CAT_CODE = 'A004' AND DATA_FLAG = '0'
         AND DT BETWEEN LEFT(SCOMMENT, 10) AND RIGHT(SCOMMENT, 10)
         AND H.HOLI_DATE IS NULL), 0
    )) AS MC_CAPA
FROM CTE
    LEFT JOIN LSE_HOLIDAY H ON CTE.DT = H.HOLI_DATE
WHERE DATEPART(DW, DT) NOT IN ('1', '7')  -- 토/일 제외
OPTION (MAXRECURSION 0)
```

### 5.4 휴일 등록 시 CAPA 일괄 0 처리 (LSE_HOLIDAY_UPD)

```sql
UPDATE TSTD_MC_DAILYCAPA SET CAPA = 0
WHERE PLT_CODE = @PLT_CODE
  AND WORK_DATE IN (
      SELECT HOLI_DATE FROM LSE_HOLIDAY WHERE PLT_CODE = @PLT_CODE
  )
```

### 5.5 휴일 물리 삭제 (LSE_HOLIDAY_DEL3)

```sql
DELETE FROM LSE_HOLIDAY
WHERE PLT_CODE = @PLT_CODE
  AND HOLI_DATE = @HOLI_DATE
```

---

## 6. 화면 간 참조 관계

### LSE_HOLIDAY 데이터를 참조하는 화면

| 화면 ID     | 모듈  | 쿼리 메서드          | 용도                                       |
|------------|------|---------------------|--------------------------------------------|
| STD23A     | STD  | QUERY1              | 휴일관리 메인 (캘린더 표시 + CAPA 연동)       |
| STD23B     | STD  | QUERY1              | 휴일관리 변형 (휴일 목록 그리드)              |
| ORD04A     | ORD  | -                   | 주문 팝업에서 HOLI_DATE 표시                 |
| ORD09A     | ORD  | QUERY2              | 주문 화면에서 HOLI_NAME 컬럼 표시            |
| POP30A     | POP  | LSE_HOLIDAY_SER     | 생산 실적 저장 시 휴일 참조                   |
| POP31A     | POP  | QUERY2              | 생산 화면에서 휴일 기간 조회                  |
| POP41A     | POP  | -                   | HOLI_ACT_TIME(휴일근무) 컬럼 표시            |
| PLN14A     | PLN  | QUERY1              | 생산계획에서 휴일 고려                        |
| REP07A     | REP  | QUERY3              | CTE+휴일 JOIN으로 근무일 기준 CAPA 리포트     |
| SYS04A     | SYS  | -                   | 간트차트 휴일 색상 설정                       |
| CTRL       | CTRL | QUERY1              | 공통 컨트롤러에서 휴일 목록 조회              |

---

## 7. 특이사항 및 설계 포인트

### 7.1 물리 삭제 방식

- 대부분의 테이블이 `DATA_FLAG`를 사용하는 논리 삭제 패턴과 달리, LSE_HOLIDAY는 **물리 DELETE** 방식 사용
- 감사 컬럼(REG_DATE, REG_EMP, DEL_DATE 등) 없음
- 테이블 구조가 매우 단순 (3컬럼)

### 7.2 휴일-CAPA 연동 패턴

- 휴일 등록 시 → TSTD_MC_DAILYCAPA의 해당 날짜 모든 설비 CAPA를 0으로 설정
- 휴일 해제 시 → 해당 날짜 설비별 요일 기본 CAPA로 복원
- `LSE_HOLIDAY_UPD` 메서드명이 오해의 소지가 있음: LSE_HOLIDAY가 아닌 **TSTD_MC_DAILYCAPA**를 UPDATE

### 7.3 요일별 CAPA 자동 산정

- 설비별 교대 수(MC_SHIFT)와 요일별 근무시간(LSE_MC_WORKTIME)을 기반으로 자동 산정
- 교대 수에 따라 1교대(FT1+FT2+FOT), 2교대(+SD1+SD2+SOT), 3교대(+TD1+TD2+TOT) 합산
- D2B 팝업을 통해 수동 오버라이드 가능 → LSE_MC_CAPAPLAN에 저장

### 7.4 STD23A vs STD23B 차이

| 항목          | STD23A                                | STD23B                               |
|--------------|---------------------------------------|--------------------------------------|
| 메인 그리드   | 설비별 CAPA (TSTD_MC_DAILYCAPA 기반)  | 휴일 목록 (LSE_HOLIDAY 기반)          |
| 캘린더 날짜 클릭 | 해당 날짜 CAPA 조회                | 동작 없음                             |
| CAPA 일괄 생성 | 요일별 기본 CAPA 자동 산정            | 직접 CAPA 값 지정                     |
| 그리드 수정    | D2B 팝업 (교대별 수정)                | 직접 CAPA 수정 (UPD4)                |

### 7.5 TSTD_CODES 'A004' 참조

- `LSE_HOLIDAY_QUERY3`에서 공통코드 A004의 VALUE를 기본 MC_CAPA로 사용
- SCOMMENT 필드의 좌측 10자리/우측 10자리를 기간(FROM/TO)으로 파싱
- 휴일이 아닌 근무일(토/일 제외)에만 적용
