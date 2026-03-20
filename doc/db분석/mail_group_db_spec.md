# 메일그룹 관리 (ORD02A) — 데이터베이스 설계 명세서

> **작성자**: 송우석
> **AS-IS 소스 분석 기준**
> **화면 ID**: ORD02A (수신자 그룹 관리)

---

## Core Tables

- **TORD_EMAIL_GROUP** — 메일그룹 마스터 (PK: `PLT_CODE` + `MCODE`)
- **TORD_EMAIL_GROUP_EMP** — 메일그룹 멤버 (PK: `PLT_CODE` + `MCODE` + `EMP_CODE`)
- **TSTD_EMPLOYEE** — 사원 마스터 (PK: `PLT_CODE` + `EMP_CODE`) — 참조
- **TSTD_ORG** — 부서/조직 마스터 (PK: `PLT_CODE` + `ORG_CODE`) — 참조

---

## 1. 개요

메일그룹 관리(ORD02A)는 수신자 그룹을 생성하고, 그룹별 사원(멤버)을 등록·관리하는 기능이다.
ORD03A(월별생산계획), ORD08A, ORD29A 등 메일 발송이 필요한 다른 화면에서 수신자 목록을 참조할 때 사용된다.

### 1.1 AS-IS 소스 위치

| 구분                 | 파일 경로                                                      |
|----------------------|----------------------------------------------------------------|
| 메인 화면            | `C:\proActive\DecompiledSrc\ORD\ORD\ORD02A_M0A.cs`            |
| 팝업 (엑셀 업로드)   | `C:\proActive\DecompiledSrc\ORD\ORD\ORD02A_D0A.cs`            |
| 비즈니스 로직        | `C:\proActive\DecompiledSrc\CUBIZ_BR\BORD\ORD02A.cs`          |
| DA — 그룹 마스터     | `C:\proActive\DecompiledSrc\CUBIZ_DA\DORD\TORD_EMAIL_GROUP.cs` |
| DA — 그룹 마스터 쿼리 | `C:\proActive\DecompiledSrc\CUBIZ_DA\DORD\TORD_EMAIL_GROUP_QUERY.cs` |
| DA — 그룹 멤버      | `C:\proActive\DecompiledSrc\CUBIZ_DA\DORD\TORD_EMAIL_GROUP_EMP.cs`   |
| DA — 그룹 멤버 쿼리  | `C:\proActive\DecompiledSrc\CUBIZ_DA\DORD\TORD_EMAIL_GROUP_EMP_QUERY.cs` |

---

## 2. 관련 테이블 목록

| #   | 테이블명              | 용도             | 구분         |
|-----|-----------------------|------------------|--------------|
| 1   | TORD_EMAIL_GROUP      | 메일그룹 마스터  | **핵심**     |
| 2   | TORD_EMAIL_GROUP_EMP  | 메일그룹 멤버   | **핵심**     |
| 3   | TSTD_EMPLOYEE         | 사원 마스터     | 참조(LEFT JOIN) |
| 4   | TSTD_ORG              | 부서/조직 마스터 | 참조(LEFT JOIN) |

---

## 3. 테이블별 상세 컬럼 명세

### 3.1 TORD_EMAIL_GROUP (메일그룹 마스터)

메일 수신자 그룹의 마스터 정보를 관리한다.

| #   | 컬럼명     | 데이터타입(추정) | PK  | NULL 허용 | 기본값       | 설명                                      |
|-----|------------|------------------|-----|-----------|--------------|-------------------------------------------|
| 1   | PLT_CODE   | VARCHAR          | PK  | NOT NULL  |              | 공장코드 — 멀티 공장 지원 키              |
| 2   | MCODE      | VARCHAR          | PK  | NOT NULL  | 자동채번     | 그룹코드 — 접두어 `"EG"` + 일련번호       |
| 3   | GROUP_TYPE | VARCHAR          |     |           | `'A'`        | 그룹타입 — `'A'`: 자동 메일그룹            |
| 4   | GROUP_NAME | VARCHAR          |     |           |              | 그룹명 — 사용자 입력, LIKE 검색 가능       |
| 5   | USE_FLAG   | VARCHAR          |     |           | `'1'`        | 사용여부 — 공통코드 `S900` (`1`:사용, `0`:미사용) |
| 6   | SCOMMENT   | VARCHAR          |     | NULL      |              | 비고                                      |
| 7   | REG_DATE   | DATETIME         |     |           | `GETDATE()`  | 등록일시 — INSERT 시 자동 설정             |
| 8   | REG_EMP    | VARCHAR          |     |           | 로그인 사용자 | 등록자                                    |
| 9   | MDFY_DATE  | DATETIME         |     | NULL      | `GETDATE()`  | 수정일시 — UPDATE 시 자동 설정             |
| 10  | MDFY_EMP   | VARCHAR          |     | NULL      | 로그인 사용자 | 수정자                                    |
| 11  | DEL_DATE   | DATETIME         |     | NULL      | `GETDATE()`  | 삭제일시 — 논리삭제 시 자동 설정           |
| 12  | DEL_EMP    | VARCHAR          |     | NULL      | 로그인 사용자 | 삭제자                                    |
| 13  | DEL_REASON | VARCHAR          |     | NULL      |              | 삭제사유                                  |
| 14  | DATA_FLAG  | TINYINT          |     |           | `0`          | 데이터상태 — `0`:정상, `2`:삭제(논리삭제)  |

**MCODE 자동채번 규칙**:
```
UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "EG", bizExecute)
→ 접두어 "EG" + 일련번호 (예: EG0001, EG0002, ...)
```

### 3.2 TORD_EMAIL_GROUP_EMP (메일그룹 멤버)

메일그룹에 소속된 사원(수신자) 매핑 정보를 관리한다.

| #   | 컬럼명     | 데이터타입(추정) | PK  | NULL 허용 | 기본값       | 설명                                      |
|-----|------------|------------------|-----|-----------|--------------|-------------------------------------------|
| 1   | PLT_CODE   | VARCHAR          | PK  | NOT NULL  |              | 공장코드 — FK: TORD_EMAIL_GROUP.PLT_CODE  |
| 2   | MCODE      | VARCHAR          | PK  | NOT NULL  |              | 그룹코드 — FK: TORD_EMAIL_GROUP.MCODE     |
| 3   | EMP_CODE   | VARCHAR          | PK  | NOT NULL  |              | 사원코드 — FK: TSTD_EMPLOYEE.EMP_CODE     |
| 4   | EMP_NAME   | VARCHAR          |     |           |              | 사원명 — 비정규화(TSTD_EMPLOYEE에서 복사)  |
| 5   | EMAIL      | VARCHAR          |     | NULL      |              | 이메일 — 화면에서 직접 편집 가능           |
| 6   | REG_DATE   | DATETIME         |     |           | `GETDATE()`  | 등록일시 — INSERT 시 자동 설정             |
| 7   | REG_EMP    | VARCHAR          |     |           | 로그인 사용자 | 등록자                                    |
| 8   | MDFY_DATE  | DATETIME         |     | NULL      | `GETDATE()`  | 수정일시 — UPDATE 시 자동 설정             |
| 9   | MDFY_EMP   | VARCHAR          |     | NULL      | 로그인 사용자 | 수정자                                    |
| 10  | DEL_DATE   | DATETIME         |     | NULL      | `GETDATE()`  | 삭제일시 — 논리삭제 시 자동 설정           |
| 11  | DEL_EMP    | VARCHAR          |     | NULL      | 로그인 사용자 | 삭제자                                    |
| 12  | DEL_REASON | VARCHAR          |     | NULL      |              | 삭제사유                                  |
| 13  | DATA_FLAG  | TINYINT          |     |           | `0`          | 데이터상태 — `0`:정상, `2`:삭제            |

### 3.3 TSTD_EMPLOYEE (사원 마스터) — 참조 테이블

사원 기본 정보를 관리하는 기준정보 테이블이다. 메일그룹 멤버 조회 시 사원명·부서 정보를 LEFT JOIN으로 가져온다.

| #   | 컬럼명        | 데이터타입(추정) | PK  | 설명                          |
|-----|---------------|------------------|-----|-------------------------------|
| 1   | PLT_CODE      | VARCHAR          | PK  | 공장코드                     |
| 2   | EMP_CODE      | VARCHAR          | PK  | 사원코드                     |
| 3   | EMP_NAME      | VARCHAR          |     | 사원명                       |
| 4   | EMP_TYPE      | VARCHAR          |     | 사원유형                     |
| 5   | EMP_TITLE     | VARCHAR          |     | 직위                         |
| 6   | EMP_SEQ       | INT              |     | 정렬순서                     |
| 7   | ORG_CODE      | VARCHAR          |     | 부서코드 — FK: TSTD_ORG      |
| 8   | CPROC_CODE    | VARCHAR          |     | 공정코드                     |
| 9   | USRGRP_CODE   | VARCHAR          |     | 사용자그룹코드               |
| 10  | ACC_PWD       | VARCHAR          |     | 비밀번호                     |
| 11  | EMAIL         | VARCHAR          |     | 이메일                       |
| 12  | MOBILE_PHONE  | VARCHAR          |     | 휴대전화                     |
| 13  | IS_SYSTEM     | VARCHAR          |     | 시스템계정 여부              |
| 14  | INS_DIRECTION | INT              |     | 검사방향 — 기본값 0          |
| 15  | RFID_NO       | VARCHAR          |     | RFID 번호                    |
| 16  | FIRE_FLAG     | VARCHAR          |     | 퇴사여부                     |
| 17  | FIRE_DATE     | DATETIME         |     | 퇴사일                       |
| 18  | EMP_GUBUN     | VARCHAR          |     | 사원구분1                    |
| 19  | EMP_GUBUN2    | VARCHAR          |     | 사원구분2                    |
| 20  | DATA_FLAG     | TINYINT          |     | 데이터상태                   |
| 21  | REG_DATE      | DATETIME         |     | 등록일시                     |
| 22  | REG_EMP       | VARCHAR          |     | 등록자                       |
| 23  | MDFY_DATE     | DATETIME         |     | 수정일시                     |
| 24  | MDFY_EMP      | VARCHAR          |     | 수정자                       |
| 25  | DEL_DATE      | DATETIME         |     | 삭제일시                     |
| 26  | DEL_EMP       | VARCHAR          |     | 삭제자                       |
| 27  | DEL_REASON    | VARCHAR          |     | 삭제사유                     |

### 3.4 TSTD_ORG (부서/조직 마스터) — 참조 테이블

부서·조직 기본 정보를 관리하는 기준정보 테이블이다. 멤버 조회 시 부서명(`ORG_NAME`)을 표시하기 위해 참조한다.

| #   | 컬럼명      | 데이터타입(추정) | PK  | 설명                              |
|-----|-------------|------------------|-----|-----------------------------------|
| 1   | PLT_CODE    | VARCHAR          | PK  | 공장코드                         |
| 2   | ORG_CODE    | VARCHAR          | PK  | 부서코드                         |
| 3   | ORG_NAME    | VARCHAR          |     | 부서명                           |
| 4   | ORG_PARENT  | VARCHAR          |     | 상위부서코드 — 자기참조(트리구조) |
| 5   | ORG_LEADER  | VARCHAR          |     | 부서장                           |
| 6   | ORG_SEQ     | INT              |     | 정렬순서                         |
| 7   | COST_CENTER | VARCHAR          |     | 코스트센터                       |
| 8   | DATA_FLAG   | TINYINT          |     | 데이터상태                       |
| 9   | REG_DATE    | DATETIME         |     | 등록일시                         |
| 10  | REG_EMP     | VARCHAR          |     | 등록자                           |
| 11  | MDFY_DATE   | DATETIME         |     | 수정일시                         |
| 12  | MDFY_EMP    | VARCHAR          |     | 수정자                           |
| 13  | DEL_DATE    | DATETIME         |     | 삭제일시                         |
| 14  | DEL_EMP     | VARCHAR          |     | 삭제자                           |
| 15  | DEL_REASON  | VARCHAR          |     | 삭제사유                         |

---

## 4. 엔티티 관계도 (ERD)

### 4.1 관계 다이어그램

```
┌─────────────────────────┐
│   TORD_EMAIL_GROUP      │
│   (메일그룹 마스터)      │
│─────────────────────────│
│ PK  PLT_CODE            │
│ PK  MCODE               │
│     GROUP_TYPE           │
│     GROUP_NAME           │
│     USE_FLAG             │
│     SCOMMENT             │
│     REG_DATE / REG_EMP   │
│     MDFY_DATE / MDFY_EMP │
│     DEL_DATE / DEL_EMP   │
│     DEL_REASON           │
│     DATA_FLAG            │
└────────┬────────────────┘
         │
         │  1 : N
         │  (PLT_CODE + MCODE)
         ▼
┌─────────────────────────┐       LEFT JOIN        ┌─────────────────────────┐
│  TORD_EMAIL_GROUP_EMP   │ ─────────────────────▶ │    TSTD_EMPLOYEE        │
│  (메일그룹 멤버)        │  PLT_CODE + EMP_CODE   │    (사원 마스터)         │
│─────────────────────────│                        │─────────────────────────│
│ PK  PLT_CODE            │                        │ PK  PLT_CODE            │
│ PK  MCODE          (FK) │                        │ PK  EMP_CODE            │
│ PK  EMP_CODE       (FK) │                        │     EMP_NAME            │
│     EMP_NAME             │                        │     ORG_CODE       (FK) │
│     EMAIL                │                        │     EMAIL               │
│     REG_DATE / REG_EMP   │                        │     MOBILE_PHONE        │
│     MDFY_DATE / MDFY_EMP │                        │     ...                 │
│     DEL_DATE / DEL_EMP   │                        └────────┬────────────────┘
│     DEL_REASON           │                                 │
│     DATA_FLAG            │                                 │  N : 1
└──────────────────────────┘                                 │  (PLT_CODE + ORG_CODE)
                                                             ▼
                                                    ┌─────────────────────────┐
                                                    │      TSTD_ORG           │
                                                    │      (부서 마스터)       │
                                                    │─────────────────────────│
                                                    │ PK  PLT_CODE            │
                                                    │ PK  ORG_CODE            │
                                                    │     ORG_NAME            │
                                                    │     ORG_PARENT          │
                                                    │     ...                 │
                                                    └─────────────────────────┘
```

### 4.2 관계 정의

| 관계                                            | 카디널리티 | 조인 조건                                                              |
|-------------------------------------------------|------------|------------------------------------------------------------------------|
| TORD_EMAIL_GROUP → TORD_EMAIL_GROUP_EMP         | 1 : N      | `A.PLT_CODE = B.PLT_CODE AND A.MCODE = B.MCODE`                       |
| TORD_EMAIL_GROUP_EMP → TSTD_EMPLOYEE            | N : 1      | `A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.EMP_CODE`                 |
| TSTD_EMPLOYEE → TSTD_ORG                        | N : 1      | `E.PLT_CODE = O.PLT_CODE AND E.ORG_CODE = O.ORG_CODE`                 |

### 4.3 AS-IS 실제 조인 쿼리 (TORD_EMAIL_GROUP_EMP_QUERY1)

멤버 목록 조회 시 사원명과 부서명을 함께 가져오는 쿼리이다.

```sql
SELECT A.PLT_CODE
     , A.MCODE
     , A.EMP_CODE
     , E.EMP_NAME
     , O.ORG_NAME
     , A.EMAIL
     , A.REG_DATE
     , A.REG_EMP
     , A.MDFY_DATE
     , A.MDFY_EMP
  FROM TORD_EMAIL_GROUP_EMP A
  LEFT JOIN TSTD_EMPLOYEE E
    ON A.PLT_CODE = E.PLT_CODE
   AND A.EMP_CODE = E.EMP_CODE
  LEFT JOIN TSTD_ORG O
    ON E.PLT_CODE = O.PLT_CODE
   AND E.ORG_CODE = O.ORG_CODE
 WHERE A.PLT_CODE = @PLT_CODE
   AND A.DATA_FLAG = @DATA_FLAG   -- 선택적 조건
   AND A.MCODE    = @MCODE        -- 선택적 조건
   AND A.EMP_CODE = @EMP_CODE     -- 선택적 조건
 ORDER BY A.EMP_CODE
```

### 4.4 AS-IS 그룹 목록 조회 쿼리 (TORD_EMAIL_GROUP_QUERY1)

```sql
SELECT A.PLT_CODE
     , A.MCODE
     , A.GROUP_NAME
     , A.GROUP_TYPE
     , A.USE_FLAG
     , A.SCOMMENT
     , A.REG_DATE
     , A.REG_EMP
     , A.MDFY_DATE
     , A.MDFY_EMP
  FROM TORD_EMAIL_GROUP A
 WHERE A.PLT_CODE  = @PLT_CODE
   AND A.DATA_FLAG = @DATA_FLAG       -- 선택적 조건
   AND A.GROUP_TYPE = @GROUP_TYPE     -- 선택적 조건
   AND A.MCODE     = @MCODE          -- 선택적 조건
   AND A.GROUP_NAME LIKE '%' + @GROUP_LIKE + '%'  -- 선택적 조건
 ORDER BY A.MCODE
```

---

## 5. 비즈니스 로직 명세

### 5.1 서비스 메서드 목록

| 메서드       | 기능                       | CRUD   | 대상 테이블                                  |
|--------------|----------------------------|--------|----------------------------------------------|
| ORD02A_SER   | 그룹 목록 조회             | SELECT | TORD_EMAIL_GROUP                             |
| ORD02A_SER2  | 그룹별 멤버 조회           | SELECT | TORD_EMAIL_GROUP_EMP + TSTD_EMPLOYEE + TSTD_ORG |
| ORD02A_INS   | 그룹 등록/수정 (UPSERT)    | INSERT/UPDATE | TORD_EMAIL_GROUP                       |
| ORD02A_INS2  | 멤버 등록/수정 (UPSERT)    | INSERT/UPDATE | TORD_EMAIL_GROUP_EMP                   |
| ORD02A_INS3  | 엑셀 일괄 등록             | INSERT/UPDATE | TORD_EMAIL_GROUP + TORD_EMAIL_GROUP_EMP |
| ORD02A_DEL   | 그룹 논리삭제              | UPDATE | TORD_EMAIL_GROUP (DATA_FLAG → 2)             |
| ORD02A_DEL2  | 멤버 논리삭제              | UPDATE | TORD_EMAIL_GROUP_EMP (DATA_FLAG → 2)         |

### 5.2 UPSERT 처리 흐름

#### 그룹 저장 (ORD02A_INS)

```
1. 파라미터에서 PLT_CODE + MCODE로 기존 레코드 조회 (TORD_EMAIL_GROUP_SER)
2. IF 존재 → UPDATE (GROUP_NAME, USE_FLAG, SCOMMENT, MDFY_DATE, MDFY_EMP)
3. IF 미존재 → MCODE 자동채번 후 INSERT
4. 저장 후 목록 재조회 (TORD_EMAIL_GROUP_QUERY1) 반환
```

#### 멤버 저장 (ORD02A_INS2)

```
1. 파라미터에서 PLT_CODE + MCODE + EMP_CODE로 기존 레코드 조회 (TORD_EMAIL_GROUP_EMP_SER)
2. IF 존재 → UPDATE (EMP_NAME, EMAIL, MDFY_DATE, MDFY_EMP)
3. IF 미존재 → INSERT
```

#### 엑셀 일괄 등록 (ORD02A_INS3)

```
1. GROUP_TYPE = 'A' 고정
2. 각 행에 대해:
   a. GROUP_NAME + GROUP_TYPE으로 그룹 조회 (TORD_EMAIL_GROUP_SER2)
   b. 그룹 미존재 시 오류: "[그룹명]의 그룹을 찾을 수 없습니다."
   c. EMP_CODE로 사원 존재 여부 확인 (TSTD_EMPLOYEE_SER)
   d. 사원 미존재 시 오류: "[사원코드]의 사원을 찾을 수 없습니다."
   e. 해당 그룹의 MCODE를 조회 결과에서 추출
   f. PLT_CODE + MCODE + EMP_CODE로 멤버 UPSERT
```

### 5.3 논리삭제 처리

물리삭제를 사용하지 않고 **논리삭제** 방식을 적용한다.

```sql
-- 그룹 삭제 (ORD02A_DEL)
UPDATE TORD_EMAIL_GROUP SET
    DATA_FLAG = 2,
    DEL_DATE  = GETDATE(),
    DEL_EMP   = @로그인_사용자
WHERE PLT_CODE = @PLT_CODE
  AND MCODE    = @MCODE

-- 멤버 삭제 (ORD02A_DEL2)
UPDATE TORD_EMAIL_GROUP_EMP SET
    DATA_FLAG = 2,
    DEL_DATE  = GETDATE(),
    DEL_EMP   = @로그인_사용자
WHERE PLT_CODE = @PLT_CODE
  AND MCODE    = @MCODE
  AND EMP_CODE = @EMP_CODE
```

---

## 6. 화면 구성 (AS-IS)

### 6.1 ORD02A_M0A — 메인 화면

좌우 **SplitContainer** 레이아웃 구조이다.

#### 좌측 패널: "수신자 그룹"

| #   | 컬럼 필드명 | 표시명   | 편집 가능 | 표시 여부 | 비고                      |
|-----|-------------|----------|-----------|-----------|---------------------------|
| 1   | SEL         | 선택     | O         | O         | 체크박스                  |
| 2   | GROUP_NAME  | 그룹명   | O         | O         | 텍스트 입력, 중앙정렬     |
| 3   | GROUP_TYPE  | 그룹타입 | O         | **숨김**  | 기본값 `'A'`              |
| 4   | REG_DATE    | 생성일   | X         | O         | 날짜형식(LONG_DATE)       |
| 5   | USE_FLAG    | 사용여부 | O         | O         | 라디오버튼, 코드 `S900`   |
| 6   | MCODE       | 그룹코드 | -         | **숨김**  | Hidden, 키 컬럼           |

**버튼**: `[추가]` `[저장]`
**컨텍스트 메뉴**: `[삭제]` (우클릭)

**조회 조건**: `PLT_CODE` = 현재 공장, `GROUP_TYPE` = `'A'`

#### 우측 패널: "그룹별 세부 내역"

| #   | 컬럼 필드명 | 표시명   | 편집 가능 | 표시 여부 | 비고                       |
|-----|-------------|----------|-----------|-----------|----------------------------|
| 1   | SEL         | 선택     | O         | O         | 체크박스                   |
| 2   | EMP_CODE    | 사원코드 | X         | O         | 중앙정렬, 사원팝업에서 선택 |
| 3   | EMP_NAME    | 사원명   | X         | O         | 중앙정렬                   |
| 4   | ORG_NAME    | 부서명   | X         | O         | 중앙정렬, TSTD_ORG에서 조인 |
| 5   | EMAIL       | 이메일   | O         | O         | 좌측정렬, 직접 편집 가능    |

**버튼**: `[엑셀업로드]` `[사원추가]` `[저장]`
**컨텍스트 메뉴**: `[삭제]` (우클릭)

#### 화면 동작 흐름

```
1. 화면 초기화 → 그룹 목록 조회 (ORD02A_SER)
2. 좌측 그리드에서 그룹 행 선택 → 해당 그룹의 멤버 목록 조회 (ORD02A_SER2)
3. [추가] → 새 행 추가 (GROUP_TYPE='A', USE_FLAG='1')
4. [저장] → 변경된 그룹 행 UPSERT (ORD02A_INS)
5. [사원추가] → 사원 팝업(acEmpForm) 표시 → 선택한 사원을 우측 그리드에 추가
6. [저장(멤버)] → 변경된 멤버 행 UPSERT (ORD02A_INS2)
7. [삭제(그룹)] → 선택/체크된 그룹 논리삭제 (ORD02A_DEL)
8. [삭제(멤버)] → 선택/체크된 멤버 논리삭제 (ORD02A_DEL2)
```

### 6.2 ORD02A_D0A — 엑셀 업로드 팝업

좌우 SplitContainer 구조이며, 엑셀 파일에서 메일그룹 멤버를 일괄 등록한다.

#### 좌측 패널: "Excel 열 설정"

| #   | 필드명                   | 표시명   | 설명                          |
|-----|--------------------------|----------|-------------------------------|
| 1   | EXCEL_IMPORT::STARTROW   | 시작행   | 엑셀 데이터 시작 행 번호      |
| 2   | EXCEL_IMPORT::GROUP_NAME | 그룹명   | 그룹명이 위치한 엑셀 열 이름  |
| 3   | EXCEL_IMPORT::EMP_NAME   | 사원명   | 사원명이 위치한 엑셀 열 이름  |
| 4   | EXCEL_IMPORT::EMP_CODE   | 사원코드 | 사원코드가 위치한 엑셀 열 이름 |
| 5   | EXCEL_IMPORT::EMAIL      | 이메일   | 이메일이 위치한 엑셀 열 이름  |

#### 우측 패널: 미리보기 그리드

| #   | 컬럼 필드명 | 표시명   | 편집 가능 |
|-----|-------------|----------|-----------|
| 1   | SEL         | 선택     | O         |
| 2   | OVERWRITE   | 덮어쓰기 | O         |
| 3   | GROUP_NAME  | 그룹명   | O         |
| 4   | EMP_NAME    | 사원명   | O         |
| 5   | EMP_CODE    | 사원코드 | O         |
| 6   | EMAIL       | 이메일   | O         |

**도구모음**: `[파일 열기]` `[반영]`

---

## 7. 다른 화면에서의 참조 관계

메일그룹 데이터는 다음 화면에서 수신자 목록 조회 용도로 참조된다.

| 화면 ID | 화면명              | 참조 메서드                               | 참조 내용                              |
|---------|---------------------|-------------------------------------------|----------------------------------------|
| ORD03A  | 월별생산계획        | TORD_EMAIL_GROUP_QUERY1, EMP_QUERY1       | 그룹 목록 조회 + 멤버 조회 (메일 발송) |
| ORD08A  | (메일 관련)         | TORD_EMAIL_GROUP_EMP_QUERY1               | 멤버 목록 조회 (수신자 조회)           |
| ORD29A  | (메일 발송 관련)    | TORD_EMAIL_GROUP_QUERY1, EMP_QUERY1       | 그룹+멤버 조회 및 메일 수신자 구성     |

---

## 8. 공통 패턴 정리

### 8.1 이력관리 컬럼 패턴

모든 테이블에 공통 적용되는 이력관리 컬럼 구조이다.

| 컬럼군     | 컬럼                         | 설정 시점           |
|------------|------------------------------|---------------------|
| 등록 이력  | REG_DATE, REG_EMP            | INSERT 시           |
| 수정 이력  | MDFY_DATE, MDFY_EMP          | UPDATE 시           |
| 삭제 이력  | DEL_DATE, DEL_EMP, DEL_REASON | 논리삭제(UDE) 시    |
| 상태 플래그 | DATA_FLAG                    | 0:정상, 2:삭제      |

### 8.2 복합 PK 패턴

모든 테이블의 PK에 `PLT_CODE`가 포함되어 멀티 공장(사이트) 운영을 지원한다.

| 테이블                 | PK 구성                           |
|------------------------|-----------------------------------|
| TORD_EMAIL_GROUP       | PLT_CODE + MCODE                  |
| TORD_EMAIL_GROUP_EMP   | PLT_CODE + MCODE + EMP_CODE       |
| TSTD_EMPLOYEE          | PLT_CODE + EMP_CODE               |
| TSTD_ORG               | PLT_CODE + ORG_CODE               |

### 8.3 논리삭제 패턴

```
삭제 요청 → DATA_FLAG = 2 설정 + DEL_DATE/DEL_EMP 기록
조회 시   → DATA_FLAG = 0 조건으로 정상 데이터만 필터링
```
