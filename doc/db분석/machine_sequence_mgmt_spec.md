# 호기순번관리 (Machine Sequence Management) - AS-IS 분석 명세서

> **작성자**: 송우석
> **화면 ID**: ORD07A
> **모듈**: ORD (수주/생산계획)
> **AS-IS 소스 경로**: `C:\proActive\DecompiledSrc\`

---

## Core Tables

- **TSYS_SERIAL** — 시리얼번호 마스터 (호기순번 포함)
- **TORD_PRODUCT** — 생산제품 마스터 (PROD_HOGI 컬럼으로 호기 참조)
- **IF_SAP_PRODPLAN** — SAP 생산계획 인터페이스 (HOGI 컬럼)

---

## 1. 테이블 상세 명세

### 1.1 TSYS_SERIAL (시리얼번호 마스터)

> 시스템 시리얼번호 관리 테이블. IS_HOGI='1' 조건으로 호기순번 데이터를 필터링하여 사용.

| 컬럼명       | 데이터 타입 | PK | NULL 허용 | 설명                              | 비고                      |
|--------------|------------|:--:|:---------:|-----------------------------------|---------------------------|
| PLT_CODE     | VARCHAR    | O  | N         | 공장 코드                          | 복합 PK 1                |
| SR_CODE      | VARCHAR    | O  | N         | 시리얼 코드 (형)                    | 복합 PK 2, 모델/형식 구분 |
| SR_KEY       | VARCHAR    | O  | N         | 시리얼 키 (기도)                    | 복합 PK 3, 연도 구분      |
| SR_NO        | VARCHAR    | -  | Y         | 시리얼 번호 (순번)                  | 유일한 수정 가능 필드     |
| IS_HOGI      | VARCHAR    | -  | Y         | 호기 여부 ('1'=호기, NULL/기타=일반) | 호기 필터 조건            |

**PK 구성**: `PLT_CODE` + `SR_CODE` + `SR_KEY` (3컬럼 복합키)

**특이사항**:
- TSYS_SERIAL은 범용 시리얼번호 테이블이며, IS_HOGI 플래그로 호기순번 데이터를 구분
- ORD07A 화면은 IS_HOGI='1' 조건을 고정으로 설정하여 호기 데이터만 조회
- SR_NO만 수정 가능하며, SR_KEY/SR_CODE는 읽기 전용

### 1.2 TORD_PRODUCT (생산제품 마스터) — 참조 테이블

> 생산제품 정보를 관리하는 테이블. PROD_HOGI 컬럼으로 호기 값을 참조함.

| 컬럼명         | 데이터 타입 | PK | 설명                | 비고                          |
|---------------|------------|:--:|---------------------|-------------------------------|
| PLT_CODE      | VARCHAR    | O  | 공장 코드            | 복합 PK 1                    |
| PROD_CODE     | VARCHAR    | O  | 생산 코드            | 복합 PK 2                    |
| PROD_HOGI     | VARCHAR    | -  | 호기                 | TSYS_SERIAL의 순번과 연관     |
| ORDER_NO      | VARCHAR    | -  | 주문 번호            |                               |
| ORDER_LINE    | VARCHAR    | -  | 주문 라인            |                               |
| PROD_MONTH    | VARCHAR    | -  | 생산 월              |                               |
| PROD_STATE    | VARCHAR    | -  | 생산 상태            |                               |
| PROD_TYPE     | VARCHAR    | -  | 생산 유형            |                               |
| MODEL_TYPE    | VARCHAR    | -  | 모델 유형            |                               |
| MODEL_SERISE  | VARCHAR    | -  | 모델 시리즈          |                               |
| MODEL_NO      | VARCHAR    | -  | 모델 번호            |                               |
| MODEL_TON     | VARCHAR    | -  | 모델 톤수            |                               |
| ... (다수 컬럼) |           |    |                      | 총 30+ 컬럼                   |

### 1.3 IF_SAP_PRODPLAN (SAP 생산계획 인터페이스) — 참조 테이블

> SAP 연동 생산계획 인터페이스 테이블. HOGI 컬럼으로 호기 값을 저장.

| 컬럼명   | 데이터 타입 | 설명         | 비고            |
|---------|------------|-------------|-----------------|
| HOGI    | VARCHAR    | 호기          | SAP 연동 호기값 |

---

## 2. Entity Relationship (엔티티 관계)

```
┌─────────────────────────────────────────────────┐
│                  TSYS_SERIAL                     │
│  (시리얼번호 마스터 - 호기순번 포함)                │
│─────────────────────────────────────────────────│
│  PK: PLT_CODE + SR_CODE + SR_KEY                │
│  SR_NO        ← 유일한 수정 대상                  │
│  IS_HOGI='1'  ← 호기 데이터 필터                  │
└──────────────────────┬──────────────────────────┘
                       │ SR_NO (호기순번) 참조
                       │
          ┌────────────┴────────────┐
          │                         │
          ▼                         ▼
┌──────────────────┐    ┌────────────────────────┐
│  TORD_PRODUCT    │    │  IF_SAP_PRODPLAN       │
│  (생산제품)       │    │  (SAP 생산계획)         │
│──────────────────│    │────────────────────────│
│  PROD_HOGI       │    │  HOGI                  │
│  (제품별 호기)    │    │  (SAP 호기)             │
└──────────────────┘    └────────────────────────┘
```

**관계 설명**:
- `TSYS_SERIAL`은 범용 시리얼 관리 테이블이며, `IS_HOGI='1'` 조건으로 호기순번 데이터를 식별
- `TORD_PRODUCT.PROD_HOGI`는 생산제품에 배정된 호기번호를 저장
- `IF_SAP_PRODPLAN.HOGI`는 SAP 시스템과 연동되는 호기 정보
- TSYS_SERIAL과 TORD_PRODUCT 간 FK 관계는 코드상 명시적이지 않으며, 비즈니스 로직으로 연결

### PROD_HOGI 참조 테이블 목록

> 다수의 테이블에서 PROD_HOGI 컬럼을 사용하여 호기를 참조함.

| 테이블명                          | 모듈  | 설명                     |
|----------------------------------|-------|--------------------------|
| TORD_PRODUCT                     | ORD   | 생산제품 마스터            |
| TORD_PRODUCT_QUERY               | ORD   | 생산제품 조회 (JOIN)       |
| TORD_PRODUCT_INDUE_LOG_QUERY     | ORD   | 입고일 변경 로그           |
| TORD_PROD_REV_LOG_QUERY          | ORD   | 생산 변경 로그             |
| TORD_PROD_REV_PROD_QUERY         | ORD   | 생산 변경 제품             |
| TORD_SHIP_COST_QUERY             | ORD   | 선적 비용                  |
| TSHP_WORKORDER_QUERY             | SHP   | 작업지시서                 |
| TSHP_WORKORDER_HIS               | SHP   | 작업지시서 이력            |
| TSHP_ACTUAL_QUERY                | SHP   | 실적                      |
| TSHP_NON_WORKORDER               | SHP   | 비작업지시                 |
| TSHP_NON_WORKORDER_QUERY         | SHP   | 비작업지시 조회            |
| TSHP_OUT_ACTUAL_QUERY            | SHP   | 출고 실적                  |
| TSHP_OUT_WORKORDER_QUERY         | SHP   | 출고 작업지시서            |
| TSHP_PART_USE_QUERY              | SHP   | 부품 사용                  |
| TSHP_IDLETIME_QUERY              | SHP   | 비가동시간                 |
| TSHP_INS_RESULT_MASTER_QUERY     | SHP   | 검사결과 마스터            |
| TSHP_NG_QUERY                    | SHP   | 불량                      |
| TSHP_NG_FILE_CHK_QUERY           | SHP   | 불량 파일 체크             |
| TSHP_QMS_CHK                     | SHP   | QMS 체크                   |

---

## 3. 비즈니스 로직 (Business Logic)

### 3.1 소스 파일 위치

| 구분           | 파일 경로                                                    |
|---------------|-------------------------------------------------------------|
| 비즈니스 로직  | `CUBIZ_BR\BORD\ORD07A.cs`                                   |
| 데이터 접근    | `CUBIZ_DA\DSYS\TSYS_SERIAL.cs`                               |
| 쿼리           | `CUBIZ_DA\DSYS\TSYS_SERIAL_QUERY.cs`                        |
| 메인 화면      | `ORD\ORD\ORD07A_M0A.cs`                                     |
| 수정 팝업      | `ORD\ORD\ORD07A_D0A.cs`                                     |
| 서브 화면      | `ORD\ORD\ORD07A_M1A.cs` (생산계획 관련, 별도 기능)            |

### 3.2 메서드 상세

#### ORD07A_SER — 호기순번 목록 조회

```
입력 파라미터:
  - PLT_CODE    : 공장코드 (세션)
  - MODEL_LIKE  : 형(SR_CODE) 검색어 (LIKE '%검색어%')
  - IS_HOGI     : '1' (고정값)

처리 흐름:
  1. TSYS_SERIAL_QUERY1 호출
  2. WHERE PLT_CODE = ? AND SR_CODE LIKE '%MODEL_LIKE%' AND IS_HOGI = '1'
  3. 결과에 SEL(선택) 컬럼 추가
  4. RSLTDT 테이블명으로 반환

출력: DataTable (PLT_CODE, SR_CODE, SR_KEY, SR_NO + SEL)
```

#### ORD07A_UPD — 호기순번 수정

```
입력 파라미터:
  - PLT_CODE  : 공장코드
  - SR_CODE   : 시리얼 코드 (형)
  - SR_KEY    : 시리얼 키 (기도)
  - SR_NO     : 시리얼 번호 (순번) ← 수정 대상

처리 흐름:
  1. TSYS_SERIAL_UPD 호출
  2. UPDATE TSYS_SERIAL SET SR_NO = ? WHERE PLT_CODE = ? AND SR_CODE = ? AND SR_KEY = ?
  3. 수정 후 ORD07A_SER 재조회하여 결과 반환

출력: 조회 결과 DataTable
```

### 3.3 DA 메서드 목록

| 메서드명              | 유형     | 설명                                    | 대상 컬럼                            |
|----------------------|----------|----------------------------------------|--------------------------------------|
| TSYS_SERIAL_SER      | SELECT   | PK 기준 단건 조회                        | PLT_CODE, SR_CODE, SR_KEY            |
| TSYS_SERIAL_SER2     | SELECT   | PK + SR_NO 기준 조회                     | PLT_CODE, SR_CODE, SR_KEY, SR_NO     |
| TSYS_SERIAL_UPD      | UPDATE   | SR_NO 수정                              | SET SR_NO WHERE PK                   |
| TSYS_SERIAL_INS      | INSERT   | 기본 등록 (4컬럼)                        | PLT_CODE, SR_CODE, SR_KEY, SR_NO     |
| TSYS_SERIAL_INS2     | INSERT   | IS_HOGI 포함 등록 (5컬럼)                | PLT_CODE, SR_CODE, SR_KEY, SR_NO, IS_HOGI |
| TSYS_SERIAL_QUERY1   | SELECT   | 동적 조건 조회 (MODEL_LIKE, IS_HOGI 등)  | 전체 컬럼 + 동적 WHERE               |

---

## 4. 화면 구성 (Screen Layout)

### 4.1 ORD07A_M0A — 메인 화면

```
┌──────────────────────────────────────────────────────┐
│ [조회]                                                │ ← 툴바
├──────────────────────────────────────────────────────┤
│ 검색조건                                              │
│ ┌──────────────────────────────────────┐             │
│ │ 형: [____________]                    │             │ ← MODEL_LIKE 검색
│ └──────────────────────────────────────┘             │
├──────────────────────────────────────────────────────┤
│ 그리드 (셀 병합 허용)                                  │
│ ┌──────────┬──────────┬──────────┐                   │
│ │  기도     │  형       │  번호    │                   │
│ │ (SR_KEY) │ (SR_CODE)│ (SR_NO)  │                   │
│ ├──────────┼──────────┼──────────┤                   │
│ │  2025    │ MT5 51   │  1234    │                   │
│ │  2025    │ MT5 55   │  5678    │                   │
│ │  2024    │ XR3 30   │  9999    │                   │
│ └──────────┴──────────┴──────────┘                   │
│                                                       │
│ 우클릭 메뉴: [수정]                                    │ ← 컨텍스트 메뉴
│ 더블클릭 → D0A 팝업 오픈                                │
└──────────────────────────────────────────────────────┘
```

**그리드 컬럼 상세**:

| 컬럼명     | 표시명 | 정렬     | 편집 | 가시성 | 비고                |
|-----------|-------|:--------:|:----:|:-----:|---------------------|
| SR_KEY    | 기도   | Center   | N    | O     | KeyColumn 1         |
| SR_CODE   | 형     | Center   | N    | O     | KeyColumn 2         |
| SR_NO     | 번호   | Center   | N    | O     | 팝업에서만 수정 가능 |

**검색 파라미터**:

| 파라미터명   | 라벨 | 유형     | 설명                          |
|------------|------|---------|-------------------------------|
| MODEL_LIKE | 형   | TextEdit | SR_CODE LIKE 검색 (부분일치)    |
| IS_HOGI    | -    | 고정값   | '1' (항상 호기 데이터만 조회)    |

**동작**:
- Enter 키 → 검색 실행
- 행 더블클릭 → D0A 수정 팝업 오픈
- 우클릭 → 컨텍스트 메뉴 (수정)
- 셀 병합(CellMerge) 활성화 — SR_KEY 기준으로 동일값 셀 병합

### 4.2 ORD07A_D0A — 수정 팝업

```
┌─────────────────────────────────────────┐
│ 호기 순번 관리                            │ ← 팝업 타이틀
├─────────────────────────────────────────┤
│ [저장] [초기화] [□고정]                   │ ← 툴바
├─────────────────────────────────────────┤
│                                          │
│  기도: [2025        ]  형: [MT5 51     ] │ ← ReadOnly
│                                          │
│  번호: [1234        ]                    │ ← 수정 가능 (필수, 숫자)
│                                          │
└─────────────────────────────────────────┘
  크기: 358 x 148 px
```

**폼 필드 상세**:

| 필드명     | 컬럼명     | 라벨 | 유형      | ReadOnly | 필수 | MaskType     | 설명              |
|-----------|-----------|------|----------|:--------:|:----:|-------------|-------------------|
| acTextEdit1 | SR_KEY  | 기도  | TextEdit | O        | N    | NONE        | 연도/기도 식별자   |
| acTextEdit2 | SR_CODE | 형    | TextEdit | O        | N    | NONE        | 모델/형식 코드     |
| acTextEdit3 | SR_NO   | 번호  | TextEdit | N        | O    | QTY_OVER    | 순번 (숫자만 입력) |

**동작 흐름**:
1. M0A에서 행 선택 후 더블클릭/우클릭 수정
2. D0A 팝업 오픈 → `_row` 데이터를 폼에 바인딩 (`DialogOpen`)
3. SR_KEY, SR_CODE는 ReadOnly로 표시
4. SR_NO만 수정 가능 (QTY_OVER 마스크 = 숫자)
5. 저장 클릭 → `ValidCheck()` 통과 시 `OutputData`에 파라미터 행 설정
6. `DialogResult.OK` → M0A에서 `ORD07A_UPD` 호출하여 DB 업데이트
7. 업데이트 후 그리드 행 갱신 (`UpdateMapingRow`)

---

## 5. SQL 패턴

### 5.1 조회 쿼리 (TSYS_SERIAL_QUERY1)

```sql
SELECT
    PLT_CODE,
    SR_CODE,
    SR_KEY,
    SR_NO
FROM TSYS_SERIAL
WHERE PLT_CODE = @PLT_CODE
  AND SR_CODE LIKE '%' + @MODEL_LIKE + '%'  -- 선택적 조건
  AND IS_HOGI = @IS_HOGI                     -- 선택적 조건 (고정값 '1')
  AND SR_CODE = @SR_CODE                     -- 선택적 조건
  AND SR_KEY = @SR_KEY                       -- 선택적 조건
```

> 동적 WHERE: `UTIL.GetWhere()`를 사용하여 파라미터가 존재할 때만 조건 추가

### 5.2 수정 쿼리 (TSYS_SERIAL_UPD)

```sql
UPDATE TSYS_SERIAL
SET SR_NO = @SR_NO
WHERE PLT_CODE = @PLT_CODE
  AND SR_CODE = @SR_CODE
  AND SR_KEY = @SR_KEY
```

### 5.3 등록 쿼리 (TSYS_SERIAL_INS / INS2)

```sql
-- 기본 등록 (IS_HOGI 없이)
INSERT INTO TSYS_SERIAL (PLT_CODE, SR_CODE, SR_KEY, SR_NO)
VALUES (@PLT_CODE, @SR_CODE, @SR_KEY, @SR_NO)

-- 호기 포함 등록
INSERT INTO TSYS_SERIAL (PLT_CODE, SR_CODE, SR_KEY, SR_NO, IS_HOGI)
VALUES (@PLT_CODE, @SR_CODE, @SR_KEY, @SR_NO, @IS_HOGI)
```

---

## 6. 화면 간 참조 관계

### ORD07A를 참조하는 화면

| 화면 ID     | 화면명             | 참조 방식                                   |
|------------|-------------------|---------------------------------------------|
| ORD03A     | 월간생산계획        | PROD_HOGI 컬럼, 호기 변경 로직 (OLD_PROD_HOGI) |
| ORD04A     | 생산계획 (일별)     | PROD_HOGI 표시                                |
| ORD05A     | 생산계획 (주간)     | PROD_HOGI 표시                                |
| ORD08A     | 생산계획 관리       | PROD_HOGI 표시                                |
| POP30A     | 생산실적            | RSLTDT_HOGI 테이블 / PROD_HOGI 참조           |
| POP30C/D   | 생산실적 (상세)     | PROD_HOGI 참조                                |
| REP02A     | 보고서              | PROD_HOGI 표시                                |
| REP10A~23A | 각종 보고서         | PROD_HOGI 표시                                |
| MNT01A/02A | 유지보수            | PROD_HOGI 참조                                |
| QCT08A     | 품질 관리           | PROD_HOGI 참조                                |
| MAT01A~05A | 자재 관리           | PROD_HOGI 참조                                |
| STD44A     | 기준정보            | PROD_HOGI 참조                                |

### 코드 헬퍼 (CodeHelper)

| 파일명            | 설명                                    |
|------------------|----------------------------------------|
| acHogi.cs        | 호기 선택 코드 헬퍼 컨트롤               |
| acHogiForm.cs    | 호기 선택 팝업 폼                        |
| CTRL.cs          | `newRow["HOGI"] = "호기"` (코드 헬퍼 설정) |

> `acHogi` 코드 헬퍼는 다른 화면에서 호기 값을 선택할 때 사용되는 공통 컨트롤

---

## 7. 특이사항 및 설계 포인트

### 7.1 범용 시리얼 테이블 활용

- `TSYS_SERIAL`은 시스템 전체의 시리얼번호를 관리하는 범용 테이블
- `IS_HOGI` 플래그로 호기순번 데이터를 구분하는 필터링 패턴 사용
- 호기 전용 테이블이 별도로 존재하지 않음

### 7.2 수정 전용 화면

- ORD07A는 **조회/수정만** 가능 (등록/삭제 기능 없음)
- 신규 호기순번 데이터는 다른 경로(배치, SAP 연동 등)로 등록되는 것으로 추정
- `TSYS_SERIAL_INS2` (IS_HOGI 포함 INSERT)는 비즈니스 로직에서 직접 호출하지 않고, 초기 데이터 셋업 또는 다른 화면에서 사용

### 7.3 셀 병합 (AllowCellMerge)

- 그리드에서 `OptionsView.AllowCellMerge = true` 설정
- SR_KEY(기도) 기준으로 동일 값 셀이 병합되어 표시
- 같은 연도(기도)의 여러 형(SR_CODE) 데이터가 시각적으로 그룹핑됨

### 7.4 QTY_OVER 마스크

- SR_NO 입력 필드에 `MaskType = QTY_OVER` 적용
- 숫자 전용 입력 마스크로, 시리얼 순번값을 숫자로만 입력 가능

### 7.5 M1A 서브 화면

- `ORD07A_M1A.cs`는 생산계획 관련 별도 서브 화면
- 호기순번 관리의 핵심 기능과는 직접적 관련이 적음
- 탭 또는 별도 뷰로 제공되는 보조 화면으로 추정
