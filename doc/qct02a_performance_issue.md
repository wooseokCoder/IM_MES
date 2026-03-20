# QCT02A 조회 속도 이슈 — 분석 및 해결 방안

- 작성자: 송우석
- 작성일: 2026-03-10
- 상태: **미적용** (인덱스 생성 SQL 준비 완료)

---

## 증상

- QCT02A (부적합/결품 현황) 조회 시 **60초 이상 소요** (타임아웃 발생 가능)
- 프로시저: `sp_imes_tshp_ng_query3`
- 조건: PLT_CODE='100', 날짜범위 2~3개월, PLANTS='3603' 또는 '3605'

---

## 원인 분석

### EXPLAIN 실행 계획 요약

| 테이블              | 접근 방식 | 스캔 행수   | 문제                                          |
|---------------------|-----------|-------------|-----------------------------------------------|
| TSHP_NG             | ref (PK)  | 5,079       | NG_DATE 인덱스 없음 → 행 단위 필터 (11%)     |
| TSHP_WORKORDER      | eq_ref    | 1           | 정상                                          |
| TORD_PRODUCT        | eq_ref    | 1           | 정상                                          |
| LSE_STD_PART        | eq_ref    | 1           | 정상                                          |
| TSTD_MODEL          | ref       | 1           | 정상                                          |
| **TSHP_IDLETIME**   | **ALL**   | **363,247** | **(PLT_CODE, NG_ID) 인덱스 없음 → Full Scan** |
| TSTD_IDLECODE       | ALL       | 150         | 소량이라 영향 적음                            |
| SYS_USER            | ref       | 324         | EMP_CODE → USER_ID 매칭 비효율               |
| IF_QMS_PROC_RSLT    | ALL       | 1           | 데이터 없음 (현재 영향 없음)                  |
| IF_SAP_WORKORDER_PROD | ALL     | 1           | 데이터 없음 (현재 영향 없음)                  |

### 병목 1: TSHP_IDLETIME Full Table Scan (최대 병목)

**JOIN 조건**:
```sql
LEFT JOIN TSHP_IDLETIME I
    ON N.PLT_CODE = I.PLT_CODE AND N.NG_ID = I.NG_ID AND I.DATA_FLAG = 0
```

**기존 인덱스 6개가 모두 사용 불가한 이유**:

| 기존 인덱스                      | 선두 컬럼                        | 불가 이유                           |
|----------------------------------|----------------------------------|-------------------------------------|
| PK                               | PLT_CODE, **IDLE_ID**           | IDLE_ID로 JOIN하지 않음             |
| idx_tshp_idletime1               | **MC_CODE**, IDLE_CODE, ...     | 선두가 MC_CODE — 이 쿼리에서 안 씀  |
| IX_TSHP_IDLETIME_WO_STATE        | PLT_CODE, **WO_NO**, ...        | 두 번째가 WO_NO — NG_ID 없음       |
| idx_tshp_idle_mc_date            | PLT_CODE, **MC_CODE**, ...      | 두 번째가 MC_CODE — NG_ID 없음     |
| idx_tshp_idle_plt_emp_df_start   | PLT_CODE, **EMP_CODE**, ...     | 두 번째가 EMP_CODE — NG_ID 없음    |
| idx_tshp_idle_data_flag          | **DATA_FLAG**                   | 카디널리티 낮음 — 대부분 해당       |

> 인덱스는 **선두 컬럼부터 순서대로 매칭**되어야 함.
> `(PLT_CODE, NG_ID, DATA_FLAG)` 조합 인덱스가 없으므로 38만건 Full Scan 발생.

### 병목 2: TSHP_NG에 NG_DATE 인덱스 없음

**WHERE 조건**:
```sql
WHERE N.PLT_CODE = '100' AND N.NG_DATE >= '20260101' AND N.NG_DATE <= '20260310'
```

PK(`PLT_CODE, NG_ID`)로 PLT_CODE 필터는 되지만, NG_DATE 범위 검색은 5,079건 행 단위 비교.

### 병목 3: GROUP BY + Using temporary + Using filesort

TSHP_IDLETIME의 `SUM(IDLE_TIME)` 집계를 위해 GROUP BY 사용 중.
38만건 Full Scan 결과를 임시 테이블에 넣고 정렬 → 추가 부하.

---

## 해결 방안

### 인덱스 추가 (SQL 파일 준비 완료)

**파일**: `sql/imes/qct/qct02a_index_performance.sql`

```sql
-- 1. TSHP_IDLETIME: NG JOIN용 (최우선 — 38만건 Full Scan 제거)
CREATE INDEX idx_tshp_idle_plt_ng_df ON TSHP_IDLETIME (PLT_CODE, NG_ID, DATA_FLAG);

-- 2. TSHP_NG: 날짜 범위 필터용
CREATE INDEX idx_tshp_ng_plt_date ON TSHP_NG (PLT_CODE, NG_DATE);
```

### 예상 효과

| 항목                    | 현재                    | 인덱스 추가 후 예상     |
|-------------------------|-------------------------|-------------------------|
| TSHP_IDLETIME 스캔 행수 | 363,247 (Full Scan)     | NG건당 1~5건 (Index)    |
| TSHP_NG 필터 방식       | 5,079건 행 단위 비교    | 인덱스 범위 스캔        |
| 전체 조회 시간          | 60초+                   | 1~3초 이내 예상         |

### 적용 순서

1. `sql/imes/qct/qct02a_index_performance.sql` 파일 내용을 DB에서 실행
2. QCT02A 조회 테스트 (조립/가공 각각)
3. 속도 개선 확인 후 이 문서 상태를 **적용 완료**로 변경

---

## 테이블 데이터 현황 (2026-03-10 기준)

| 테이블                  | 건수      |
|-------------------------|-----------|
| TSHP_NG                 | 10,146    |
| TSHP_WORKORDER          | 71,223    |
| TSHP_IDLETIME           | 381,496   |
| TORD_PRODUCT            | 5,166     |
| LSE_STD_PART            | 150,664   |
| TSTD_MODEL              | 211       |
| SYS_USER                | 650       |
| TSTD_IDLECODE           | 152       |
| IF_QMS_PROC_RSLT        | 0         |
| IF_SAP_WORKORDER_PROD   | 0         |
