# 설비점검항목관리 (STD52A) — 데이터베이스 설계 명세서

> **작성자**: 송우석
> **AS-IS 소스 분석 기준**
> **화면 ID**: STD52A (설비 일상점검 항목 관리)

---

## Core Tables

- **TSTD_MC_DAILY_CHECK** — 설비 일상점검 항목 마스터 (PK: `PLT_CODE` + `SMDC_NO`)
- **TPOP_MC_DAILY_CHECK_RESULT** — 설비 일상점검 결과 (PK: `PLT_CODE` + `MDCR_NO`)
- **LSE_MACHINE** — 설비(기계) 마스터 (PK: `PLT_CODE` + `MC_CODE`) — 참조

---

## 1. 개요

설비점검항목관리(STD52A)는 설비 일상점검에 사용되는 표준 점검항목을 등록·수정·삭제하는 기능이다.
여기에 등록된 점검항목은 POP30B(설비일상점검 등록), POP42A(설비일상점검 이력조회) 등 생산 현장 화면에서
실제 점검 수행 시 템플릿으로 활용되며, 점검 결과는 `TPOP_MC_DAILY_CHECK_RESULT` 테이블에 저장된다.

### 1.1 AS-IS 소스 위치

| 구분                    | 파일 경로                                                                  |
|-------------------------|----------------------------------------------------------------------------|
| 메인 화면               | `C:\proActive\DecompiledSrc\STD\STD\STD52A_M0A.cs`                        |
| 팝업 (점검항목 편집기)   | `C:\proActive\DecompiledSrc\STD\STD\STD52A_D0A.cs`                        |
| 비즈니스 로직           | `C:\proActive\DecompiledSrc\CUBIZ_BR\BSTD\STD52A.cs`                      |
| DA — 점검항목 마스터    | `C:\proActive\DecompiledSrc\CUBIZ_DA\DSTD\TSTD_MC_DAILY_CHECK.cs`         |
| DA — 점검항목 쿼리      | `C:\proActive\DecompiledSrc\CUBIZ_DA\DSTD\TSTD_MC_DAILY_CHECK_QUERY.cs`   |
| DA — 점검결과           | `C:\proActive\DecompiledSrc\CUBIZ_DA\DPOP\TPOP_MC_DAILY_CHECK_RESULT.cs`  |
| DA — 점검결과 쿼리      | `C:\proActive\DecompiledSrc\CUBIZ_DA\DPOP\TPOP_MC_DAILY_CHECK_RESULT_QUERY.cs` |

---

## 2. 관련 테이블 목록

| #   | 테이블명                      | 용도                     | 구분            |
|-----|-------------------------------|--------------------------|-----------------|
| 1   | TSTD_MC_DAILY_CHECK           | 설비 일상점검 항목 마스터 | **핵심**        |
| 2   | TPOP_MC_DAILY_CHECK_RESULT    | 설비 일상점검 결과       | **연관(결과)**  |
| 3   | LSE_MACHINE                   | 설비(기계) 마스터        | 참조(LEFT JOIN) |

---

## 3. 테이블별 상세 컬럼 명세

### 3.1 TSTD_MC_DAILY_CHECK (설비 일상점검 항목 마스터)

설비 일상점검 시 사용되는 표준 점검항목 정의 테이블이다. STD52A 화면에서 직접 관리된다.

| #   | 컬럼명        | 데이터타입(추정) | PK  | NULL 허용 | 기본값        | 설명                                          |
|-----|---------------|------------------|-----|-----------|---------------|-----------------------------------------------|
| 1   | PLT_CODE      | VARCHAR          | PK  | NOT NULL  |               | 공장코드 — 멀티 공장 지원 키                  |
| 2   | SMDC_NO       | VARCHAR          | PK  | NOT NULL  | 자동채번      | 점검항목ID — 접두어 `"SMDC"` + YYMMDD + 일련번호 |
| 3   | SMDC_TYPE     | VARCHAR          |     |           |               | 구분 — 점검항목 분류 (LIKE 검색 지원)         |
| 4   | SMDC_NUM      | VARCHAR          |     |           |               | 점검번호 — 해당 구분 내 번호                  |
| 5   | SMDC_CONTENTS | VARCHAR          |     |           |               | 점검항목 — 점검 대상 항목명 (Memo 타입)       |
| 6   | SMDC_CHECK    | VARCHAR          |     |           |               | 점검내용 — 점검 상세 내용 (Memo 타입)         |
| 7   | SMDC_MEANS    | VARCHAR          |     |           |               | 점검방법 — 점검 수행 방법                     |
| 8   | SMDC_SEQ      | INT              |     |           |               | 순번 — 표시 정렬 순서 (ORDER BY 기준)         |
| 9   | REG_DATE      | DATETIME         |     |           | `GETDATE()`   | 등록일시 — INSERT 시 자동 설정                |
| 10  | REG_EMP       | VARCHAR          |     |           | 로그인 사용자 | 등록자                                        |
| 11  | MDFY_DATE     | DATETIME         |     | NULL      | `GETDATE()`   | 수정일시 — UPDATE 시 자동 설정                |
| 12  | MDFY_EMP      | VARCHAR          |     | NULL      | 로그인 사용자 | 수정자                                        |
| 13  | DEL_DATE      | DATETIME         |     | NULL      | `GETDATE()`   | 삭제일시 — 논리삭제 시 자동 설정              |
| 14  | DEL_EMP       | VARCHAR          |     | NULL      | 로그인 사용자 | 삭제자                                        |
| 15  | DATA_FLAG     | TINYINT          |     |           | `0`           | 데이터상태 — `0`:정상, `2`:삭제(논리삭제)     |

**SMDC_NO 자동채번 규칙**:
```
UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "SMDC", YYMMDD, bizExecute)
→ 접두어 "SMDC" + 날짜(YYMMDD) + 일련번호 (예: SMDC250203001)
```

### 3.2 TPOP_MC_DAILY_CHECK_RESULT (설비 일상점검 결과)

실제 설비 일상점검 수행 결과를 기록하는 테이블이다. POP30B 화면에서 점검 실시 시 생성되며,
TSTD_MC_DAILY_CHECK의 항목을 기반으로 점검 결과·비고를 추가 기록한다.

| #   | 컬럼명        | 데이터타입(추정) | PK  | NULL 허용 | 기본값        | 설명                                          |
|-----|---------------|------------------|-----|-----------|---------------|-----------------------------------------------|
| 1   | PLT_CODE      | VARCHAR          | PK  | NOT NULL  |               | 공장코드                                      |
| 2   | MDCR_NO       | VARCHAR          | PK  | NOT NULL  | 자동채번      | 점검결과ID                                    |
| 3   | MDCR_DATE     | VARCHAR/DATE     |     |           |               | 점검일자 — 점검 수행 날짜                     |
| 4   | MDCR_MC_CODE  | VARCHAR          |     |           |               | 설비코드 — FK: LSE_MACHINE.MC_CODE            |
| 5   | MDCR_TYPE     | VARCHAR          |     |           |               | 구분 — TSTD_MC_DAILY_CHECK.SMDC_TYPE에서 복사 |
| 6   | MDCR_NUM      | VARCHAR          |     |           |               | 점검번호 — SMDC_NUM에서 복사                  |
| 7   | MDCR_CONTENTS | VARCHAR          |     |           |               | 점검항목 — SMDC_CONTENTS에서 복사             |
| 8   | MDCR_CHECK    | VARCHAR          |     |           |               | 점검내용 — SMDC_CHECK에서 복사                |
| 9   | MDCR_MEANS    | VARCHAR          |     |           |               | 점검방법 — SMDC_MEANS에서 복사                |
| 10  | MDCR_RESULT   | VARCHAR          |     |           |               | 점검결과 — 실제 점검 수행 결과값              |
| 11  | MDCR_SCOMMENT | VARCHAR          |     | NULL      |               | 비고 — 점검 시 특이사항 기록                  |
| 12  | MDCR_SEQ      | INT              |     |           |               | 순번 — SMDC_SEQ에서 복사, ORDER BY 기준       |
| 13  | REG_DATE      | DATETIME         |     |           | `GETDATE()`   | 등록일시                                      |
| 14  | REG_EMP       | VARCHAR          |     |           | 로그인 사용자 | 등록자                                        |
| 15  | MDFY_DATE     | DATETIME         |     | NULL      | `GETDATE()`   | 수정일시                                      |
| 16  | MDFY_EMP      | VARCHAR          |     | NULL      | 로그인 사용자 | 수정자                                        |
| 17  | DEL_DATE      | DATETIME         |     | NULL      |               | 삭제일시                                      |
| 18  | DEL_EMP       | VARCHAR          |     | NULL      |               | 삭제자                                        |
| 19  | DATA_FLAG     | TINYINT          |     |           | `0`           | 데이터상태 — `0`:정상, `2`:삭제               |

### 3.3 LSE_MACHINE (설비/기계 마스터) — 참조 테이블

설비 기본 정보를 관리하는 기준정보 테이블이다. 점검결과 이력 조회 시 설비명(`MC_NAME`)을 표시하기 위해 참조한다.

| #   | 컬럼명   | 데이터타입(추정) | PK  | 설명                     |
|-----|----------|------------------|-----|--------------------------|
| 1   | PLT_CODE | VARCHAR          | PK  | 공장코드                 |
| 2   | MC_CODE  | VARCHAR          | PK  | 설비코드                 |
| 3   | MC_NAME  | VARCHAR          |     | 설비명 — 조회 시 표시용  |
| -   | (기타)   | -                |     | 설비 상세 정보 컬럼들    |

> LSE_MACHINE의 전체 컬럼은 별도 설비관리 명세서에서 정의한다. 본 문서에서는 점검 관련 조인에 사용되는 컬럼만 명시한다.

---

## 4. 엔티티 관계도 (ERD)

### 4.1 관계 다이어그램

```
┌──────────────────────────────┐
│   TSTD_MC_DAILY_CHECK        │
│   (점검항목 마스터)           │
│──────────────────────────────│
│ PK  PLT_CODE                 │
│ PK  SMDC_NO                  │
│     SMDC_TYPE                │
│     SMDC_NUM                 │
│     SMDC_CONTENTS            │
│     SMDC_CHECK               │
│     SMDC_MEANS               │
│     SMDC_SEQ                 │
│     REG_DATE / REG_EMP       │
│     MDFY_DATE / MDFY_EMP     │
│     DEL_DATE / DEL_EMP       │
│     DATA_FLAG                │
└──────────────┬───────────────┘
               │
               │  항목 템플릿 → 결과 복사
               │  (설계상 데이터 복사 관계, FK 아님)
               ▼
┌──────────────────────────────┐       LEFT JOIN        ┌──────────────────────┐
│ TPOP_MC_DAILY_CHECK_RESULT   │ ─────────────────────▶ │    LSE_MACHINE       │
│ (점검결과)                   │  PLT_CODE + MC_CODE    │    (설비 마스터)      │
│──────────────────────────────│                        │──────────────────────│
│ PK  PLT_CODE                 │                        │ PK  PLT_CODE         │
│ PK  MDCR_NO                  │                        │ PK  MC_CODE          │
│     MDCR_DATE                │                        │     MC_NAME          │
│     MDCR_MC_CODE        (FK) │                        │     ...              │
│     MDCR_TYPE                │                        └──────────────────────┘
│     MDCR_NUM                 │
│     MDCR_CONTENTS            │
│     MDCR_CHECK               │
│     MDCR_MEANS               │
│     MDCR_RESULT              │
│     MDCR_SCOMMENT            │
│     MDCR_SEQ                 │
│     REG_DATE / REG_EMP       │
│     MDFY_DATE / MDFY_EMP     │
│     DATA_FLAG                │
└──────────────────────────────┘
```

### 4.2 관계 정의

| 관계                                                   | 유형                   | 조인 조건                                                             |
|--------------------------------------------------------|------------------------|-----------------------------------------------------------------------|
| TSTD_MC_DAILY_CHECK → TPOP_MC_DAILY_CHECK_RESULT       | 템플릿 → 결과 (복사)   | 컬럼 값 복사 (SMDC_TYPE→MDCR_TYPE 등), FK 관계 아님                  |
| TPOP_MC_DAILY_CHECK_RESULT → LSE_MACHINE               | N : 1 (LEFT JOIN)      | `D.PLT_CODE = M.PLT_CODE AND D.MDCR_MC_CODE = M.MC_CODE`            |

### 4.3 항목 → 결과 컬럼 매핑

점검항목 마스터(TSTD)에서 점검결과(TPOP)로 데이터가 복사될 때의 컬럼 매핑이다.
`TSTD_MC_DAILY_CHECK_QUERY2`에서 이 매핑을 확인할 수 있다.

| TSTD_MC_DAILY_CHECK (원본) | TPOP_MC_DAILY_CHECK_RESULT (복사 대상) | 설명       |
|----------------------------|----------------------------------------|------------|
| SMDC_TYPE                  | MDCR_TYPE                              | 구분       |
| SMDC_NUM                   | MDCR_NUM                               | 점검번호   |
| SMDC_CONTENTS              | MDCR_CONTENTS                          | 점검항목   |
| SMDC_CHECK                 | MDCR_CHECK                             | 점검내용   |
| SMDC_MEANS                 | MDCR_MEANS                             | 점검방법   |
| SMDC_SEQ                   | MDCR_SEQ                               | 순번       |
| (없음)                     | MDCR_RESULT                            | 점검결과   |
| (없음)                     | MDCR_SCOMMENT                          | 비고       |
| (없음)                     | MDCR_DATE                              | 점검일자   |
| (없음)                     | MDCR_MC_CODE                           | 설비코드   |

### 4.4 AS-IS 실제 조인 쿼리

#### 점검결과 이력 조회 (TPOP_MC_DAILY_CHECK_RESULT_QUERY2)

점검결과 목록을 설비명과 함께 조회하는 쿼리이다.

```sql
SELECT D.PLT_CODE
     , D.MDCR_DATE
     , D.MDCR_MC_CODE
     , M.MC_NAME AS MDCR_MC_NAME
  FROM TPOP_MC_DAILY_CHECK_RESULT D
  LEFT JOIN LSE_MACHINE M
    ON D.PLT_CODE = M.PLT_CODE
   AND D.MDCR_MC_CODE = M.MC_CODE
 WHERE D.PLT_CODE = @PLT_CODE
   AND D.MDCR_MC_CODE = @MDCR_MC_CODE                                    -- 선택적
   AND (D.MDCR_MC_CODE LIKE '%' + @MDCR_MC_LIKE + '%'
        OR M.MC_NAME LIKE '%' + @MDCR_MC_LIKE + '%')                     -- 선택적
   AND D.MDCR_DATE BETWEEN @S_MDCR_DATE AND @E_MDCR_DATE                 -- 선택적
 GROUP BY D.PLT_CODE, D.MDCR_DATE, D.MDCR_MC_CODE, M.MC_NAME
 ORDER BY D.MDCR_DATE
```

#### 점검항목 마스터 조회 (TSTD_MC_DAILY_CHECK_QUERY1)

```sql
SELECT PLT_CODE
     , SMDC_NO
     , SMDC_TYPE
     , SMDC_NUM
     , SMDC_CONTENTS
     , SMDC_CHECK
     , SMDC_MEANS
     , SMDC_SEQ
     , REG_DATE
     , REG_EMP
     , MDFY_DATE
     , MDFY_EMP
     , DEL_DATE
     , DEL_EMP
     , DATA_FLAG
  FROM TSTD_MC_DAILY_CHECK
 WHERE PLT_CODE = @PLT_CODE
   AND SMDC_NO = @SMDC_NO                                                -- 선택적
   AND SMDC_TYPE LIKE '%' + @TYPE_LIKE + '%'                              -- 선택적
   AND SMDC_CONTENTS LIKE '%' + @CONTENTS_LIKE + '%'                      -- 선택적
   AND DATA_FLAG = @DATA_FLAG                                             -- 선택적
 ORDER BY SMDC_SEQ
```

#### 점검항목 → 결과 템플릿 변환 쿼리 (TSTD_MC_DAILY_CHECK_QUERY2)

점검 수행 시 마스터 항목을 결과 테이블 형식으로 변환하는 쿼리이다.

```sql
SELECT PLT_CODE
     , '' AS MDCR_NO
     , '' AS MDCR_DATE
     , '' AS MDCR_MC_CODE
     , SMDC_TYPE     AS MDCR_TYPE
     , SMDC_NUM      AS MDCR_NUM
     , SMDC_CONTENTS AS MDCR_CONTENTS
     , SMDC_CHECK    AS MDCR_CHECK
     , SMDC_MEANS    AS MDCR_MEANS
     , '' AS MDCR_RESULT
     , '' AS MDCR_SCOMMENT
     , SMDC_SEQ      AS MDCR_SEQ
  FROM TSTD_MC_DAILY_CHECK A
 WHERE PLT_CODE = @PLT_CODE
   AND DATA_FLAG = @DATA_FLAG
 ORDER BY SMDC_SEQ
```

---

## 5. 비즈니스 로직 명세

### 5.1 서비스 메서드 목록

| 메서드       | 기능                           | CRUD          | 대상 테이블                 |
|--------------|--------------------------------|---------------|-----------------------------|
| STD52A_SER   | 점검항목 목록 조회             | SELECT        | TSTD_MC_DAILY_CHECK         |
| STD52A_INS   | 점검항목 등록/수정 (UPSERT)    | INSERT/UPDATE | TSTD_MC_DAILY_CHECK         |
| STD52A_DEL   | 점검항목 논리삭제              | UPDATE        | TSTD_MC_DAILY_CHECK         |

### 5.2 UPSERT 처리 흐름 (STD52A_INS)

```
1. 파라미터에서 PLT_CODE + SMDC_NO로 기존 레코드 조회 (TSTD_MC_DAILY_CHECK_SER)
2. IF 존재:
   a. OVERWRITE = '1' → UPDATE (SMDC_TYPE, SMDC_NUM, SMDC_CONTENTS, SMDC_CHECK, SMDC_MEANS, SMDC_SEQ)
   b. OVERWRITE ≠ '1':
      - DATA_FLAG = 2 (삭제 이력) → 에러 100002: "동일 데이터가 이력이 존재할때 발생"
      - DATA_FLAG ≠ 2 (활성) → 에러 100001: "동일 데이터가 존재할때 발생"
      - 사용자가 "예" 선택 시 OVERWRITE = '1'로 재시도
3. IF 미존재 → SMDC_NO 자동채번 후 INSERT
4. 저장 후 목록 재조회 (STD52A_SER) 반환
```

### 5.3 논리삭제 처리 (STD52A_DEL)

```sql
UPDATE TSTD_MC_DAILY_CHECK SET
    DEL_DATE  = GETDATE(),
    DEL_EMP   = @로그인_사용자,
    DATA_FLAG = 2
WHERE PLT_CODE = @PLT_CODE
  AND SMDC_NO  = @SMDC_NO
```

삭제 시 D0A 팝업에서 삭제사유(`DEL_REASON`) 입력을 요구한다.

---

## 6. 화면 구성 (AS-IS)

### 6.1 STD52A_M0A — 메인 화면

상하 **SplitContainer** 레이아웃 구조이다.

#### 상단 패널: "검색조건"

| #   | 필드 바인딩명  | 표시명   | 설명                              |
|-----|----------------|----------|-----------------------------------|
| 1   | TYPE_LIKE      | 구분     | 구분 LIKE 검색 (텍스트 입력)      |
| 2   | CONTENTS_LIKE  | 점검항목 | 점검항목명 LIKE 검색 (텍스트 입력) |

#### 하단 패널: 점검항목 그리드

| #   | 컬럼 필드명   | 표시명         | 편집 가능 | 표시 여부 | 비고                        |
|-----|---------------|----------------|-----------|-----------|------------------------------|
| 1   | SEL           | 선택           | O         | O         | 체크박스                     |
| 2   | SMDC_NO       | 점검항목ID     | X         | O         | 중앙정렬, 키 컬럼            |
| 3   | SMDC_TYPE     | 구분           | X         | O         | 중앙정렬                     |
| 4   | SMDC_NUM      | 점검번호       | X         | O         | 중앙정렬                     |
| 5   | SMDC_CONTENTS | 점검항목       | X         | O         | 중앙정렬, Memo 타입(줄바꿈)  |
| 6   | SMDC_CHECK    | 점검내용       | X         | O         | 중앙정렬, Memo 타입(줄바꿈)  |
| 7   | SMDC_MEANS    | 점검방법       | X         | O         | 중앙정렬                     |
| 8   | SMDC_SEQ      | 순번           | X         | O         | 중앙정렬                     |
| 9   | REG_DATE      | 최초 등록일    | X         | **숨김**  | 날짜형식                     |
| 10  | REG_EMP       | 최초 등록자코드 | X         | **숨김**  |                              |
| 11  | REG_EMP_NAME  | 최초 등록자    | X         | **숨김**  |                              |
| 12  | MDFY_DATE     | 최근 수정일    | X         | **숨김**  | 날짜형식                     |
| 13  | MDFY_EMP      | 최근 수정자코드 | X         | **숨김**  |                              |
| 14  | MDFY_EMP_NAME | 최근 수정자    | X         | **숨김**  |                              |

**도구모음**: `[조회]` `[도움말]`
**컨텍스트 메뉴** (우클릭): `[점검항목 등록]` `[점검항목 수정]` `[삭제]`
**더블클릭**: 선택 행 수정 (D0A 팝업 열기)

#### 화면 동작 흐름

```
1. 화면 초기화 → 검색조건 표시
2. [조회] 또는 Enter 키 → 점검항목 목록 조회 (STD52A_SER)
3. [점검항목 등록] → D0A 팝업 (NEW 모드)
4. 행 더블클릭 또는 [점검항목 수정] → D0A 팝업 (OPEN 모드)
5. [삭제] → 선택/체크된 항목 논리삭제 (STD52A_DEL)
```

### 6.2 STD52A_D0A — 점검항목 편집기 팝업

폼(Layout) 구조로 점검항목을 등록·수정하는 팝업이다. 제목: "점검항목 편집기"

#### 입력 필드

| #   | 필드 바인딩명  | 표시명     | 읽기전용 | 입력 타입        | 비고                     |
|-----|----------------|------------|----------|------------------|--------------------------|
| 1   | SMDC_NO        | 점검항목ID | O        | 텍스트           | 자동 생성, 수정 불가     |
| 2   | SMDC_TYPE      | 구분       | X        | 텍스트           |                          |
| 3   | SMDC_NUM       | 번호       | X        | 텍스트           |                          |
| 4   | SMDC_CONTENTS  | 점검항목   | X        | 멀티라인(Memo)   |                          |
| 5   | SMDC_CHECK     | 점검내용   | X        | 멀티라인(Memo)   |                          |
| 6   | SMDC_MEANS     | 점검방법   | X        | 텍스트           |                          |
| 7   | SMDC_SEQ       | 순번       | X        | 숫자(QTY 마스크) | 정렬 순서                |

#### 모드별 버튼 표시

| 버튼        | NEW 모드 | OPEN 모드 |
|-------------|----------|-----------|
| 저장        | O        | X         |
| 저장 후 닫기 | X        | O         |
| 삭제        | X        | O         |
| 초기화      | O        | X         |
| 창 고정     | O        | O         |

#### 중복 처리 로직

```
저장 시 동일 SMDC_NO 존재 확인:
  → 에러 100001: "동일 데이터가 존재할때 발생"
     → 사용자 "예" 선택 → OVERWRITE=1 로 덮어쓰기 재시도
  → 에러 100002: "동일 데이터가 이력이 존재할때 발생" (삭제된 데이터 복원)
     → 삭제일/삭제자/삭제사유 표시 후 사용자 확인 → 덮어쓰기 재시도
```

---

## 7. 다른 화면에서의 참조 관계

점검항목 마스터와 점검결과 데이터는 다음 화면에서 참조된다.

| 화면 ID | 화면명              | 참조 테이블                    | 참조 내용                                    |
|---------|---------------------|--------------------------------|----------------------------------------------|
| POP30B  | 설비일상점검 등록   | TSTD_MC_DAILY_CHECK            | 점검항목 템플릿 로드 → 결과 입력 화면 구성   |
|         |                     | TPOP_MC_DAILY_CHECK_RESULT     | 점검결과 저장/수정                           |
| POP42A  | 설비일상점검 이력   | TPOP_MC_DAILY_CHECK_RESULT     | 점검결과 이력 조회 (설비별/기간별)           |
|         |                     | LSE_MACHINE                    | 설비명 표시를 위한 LEFT JOIN                 |

### 7.1 데이터 흐름

```
STD52A (점검항목 정의)
    │
    │  TSTD_MC_DAILY_CHECK_QUERY2 로 템플릿 변환
    ▼
POP30B (점검 수행)
    │  SMDC 컬럼 → MDCR 컬럼으로 매핑 복사
    │  + MDCR_RESULT, MDCR_SCOMMENT, MDCR_DATE, MDCR_MC_CODE 추가 입력
    ▼
TPOP_MC_DAILY_CHECK_RESULT (결과 저장)
    │
    ▼
POP42A (이력 조회)
    LEFT JOIN LSE_MACHINE 으로 설비명 함께 표시
```

---

## 8. 공통 패턴 정리

### 8.1 이력관리 컬럼 패턴

| 컬럼군      | 컬럼                    | 설정 시점           |
|-------------|-------------------------|---------------------|
| 등록 이력   | REG_DATE, REG_EMP       | INSERT 시           |
| 수정 이력   | MDFY_DATE, MDFY_EMP     | UPDATE 시           |
| 삭제 이력   | DEL_DATE, DEL_EMP       | 논리삭제(UDE) 시    |
| 상태 플래그 | DATA_FLAG               | 0:정상, 2:삭제      |

### 8.2 복합 PK 패턴

| 테이블                        | PK 구성                |
|-------------------------------|------------------------|
| TSTD_MC_DAILY_CHECK           | PLT_CODE + SMDC_NO    |
| TPOP_MC_DAILY_CHECK_RESULT    | PLT_CODE + MDCR_NO    |
| LSE_MACHINE                   | PLT_CODE + MC_CODE    |

### 8.3 접두어 네이밍 컨벤션

| 접두어 | 의미               | 테이블 예시                    |
|--------|--------------------|---------------------------------|
| TSTD_  | 기준정보(Standard) | TSTD_MC_DAILY_CHECK            |
| TPOP_  | 생산실적(POP)      | TPOP_MC_DAILY_CHECK_RESULT     |
| LSE_   | LS 확장            | LSE_MACHINE                    |
| SMDC_  | 점검항목 컬럼      | SMDC_NO, SMDC_TYPE, ...        |
| MDCR_  | 점검결과 컬럼      | MDCR_NO, MDCR_RESULT, ...     |

### 8.4 마스터-결과 복사 패턴

점검항목 마스터(TSTD)의 정의 데이터를 점검결과(TPOP)로 **스냅샷 복사**하는 패턴을 사용한다.
이렇게 하면 마스터 항목이 추후 변경되더라도 과거 점검결과의 무결성이 유지된다.

```
마스터 정의 → 결과 테이블로 값 복사 (비정규화)
장점: 과거 이력 불변성 보장
단점: 데이터 중복 저장
```
