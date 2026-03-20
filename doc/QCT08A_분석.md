# QCT08A (자주검사 현황) AS-IS 분석

> 작성자: 송우석
> 작성일: 2026-03-17

---

## 1. 화면 개요

| 항목           | 내용                                      |
|----------------|-------------------------------------------|
| **화면 ID**    | QCT08A                                    |
| **메뉴명**     | 자주검사 현황                             |
| **성격**       | 조회 전용 + QMS 전송 기능                 |
| **탭 구조**    | Tab1: 조립(acTabPage1), Tab2: 가공(acTabPage2) |
| **CRUD 버튼**  | 등록/수정/삭제 **없음** (조회+QMS전송만)   |

---

## 2. UI 레이아웃

### 2-1. 검색 조건

| 탭        | 검색 필드       | 파라미터명     | 컨트롤 타입   | 비고                    |
|-----------|-----------------|----------------|---------------|-------------------------|
| Tab1(조립) | 판매오더       | ORDER_LIKE     | TextBox       | LIKE 검색               |
| Tab1(조립) | 호기           | HOGI_LIKE      | TextBox       | LIKE 검색               |
| Tab1(조립) | 공정           | PROC_CODE      | ComboBox      | LookUp C060 (검사공정)  |
| Tab2(가공) | 모델           | MODEL_LIKE     | TextBox       | LIKE 검색               |
| Tab2(가공) | 공정           | PROC_CODE      | ComboBox      | LookUp C060             |

> **Tab1**: `PLANTS='1000'` (조립 공장) 고정 파라미터
> **Tab2**: `PLANTS='2000'` (가공 공장) 고정 파라미터

### 2-2. 그리드 컬럼 — Tab1 (조립)

| 컬럼명         | 헤더명         | 너비 | 타입         | 비고                              |
|----------------|----------------|------|--------------|-----------------------------------|
| SEL            | (선택)         | 30   | CheckBox     | 체크박스                          |
| PROD_CODE      | -              | -    | Hidden       |                                   |
| INSM_NO        | -              | -    | Hidden       |                                   |
| WO_NO          | -              | -    | Hidden       |                                   |
| PROD_ORDER     | 판매오더/라인  | 120  | Text         | ORDER_NO + '/' + ORDER_LINE 합성  |
| PROD_WEEK      | 생산주차       | 80   | Text         |                                   |
| PROD_HOGI      | 호기           | 80   | Text         |                                   |
| INDUE_DATE     | 생산완료일     | 110  | Text         |                                   |
| CUSTOMER       | 수주처         | 100  | Text         |                                   |
| MODEL_TYPE     | 타입           | 80   | Text         |                                   |
| EMP_NAME       | 검사자         | 80   | Text         |                                   |
| EMP_CODE       | 검사자사번     | 80   | Text(Hidden) |                                   |
| INS_DATE       | 검사일         | 120  | Text         |                                   |
| QMS_STATE      | QMS 전송여부   | 100  | Text         | '1'→전송, else→미전송             |
| PROC_CODE      | 검사공정       | 80   | Text(Hidden) |                                   |
| PROC_NAME      | 검사공정명     | 100  | Text         |                                   |
| INS_NAME       | 검사항목명     | 150  | Text         |                                   |
| INS_DESC       | 점검내역       | 150  | Text         |                                   |
| INS_TYPE       | TYPE           | 80   | Text         | LookUp C053                       |
| AVG_VAL        | 기준값         | 80   | Text         |                                   |
| INS_UNIT       | 단위           | 80   | Text         | LookUp C054                       |
| MIN_VAL        | Min            | 80   | Text         |                                   |
| MAX_VAL        | Max            | 80   | Text         |                                   |
| INS_RESULT     | 검사값         | 100  | CustomEdit   | INS_TYPE별 동적 에디터            |
| IMG_CNT        | -              | -    | Hidden       | 이미지 존재 여부 (0/1)            |
| INS_RESULT_IMG | 검사이미지     | 80   | ButtonEdit   | 이미지 보기 버튼                  |
| INS_NO         | -              | -    | Hidden/Key   | KeyColumn                         |

> **Cell Merge**: `PROD_ORDER` 컬럼에 적용 (동일 판매오더 행 병합)

### 2-3. 그리드 컬럼 — Tab2 (가공)

Tab1과 유사하나 다음 차이:

| 차이점            | Tab1(조립)                          | Tab2(가공)                |
|-------------------|-------------------------------------|---------------------------|
| 판매오더 컬럼     | PROD_ORDER (합성)                   | **없음**                  |
| 생산오더 컬럼     | 없음                                | SAP_WO_NO                 |
| 모델 컬럼         | MODEL_TYPE(타입)                    | MODEL(타입)               |
| PROD_WEEK/HOGI    | 있음                                | **없음**                  |
| INDUE_DATE        | 있음                                | **없음**                  |
| CUSTOMER          | 있음                                | **없음**                  |
| INS_RESULT_IMG    | 있음                                | **없음**                  |
| Cell Merge        | PROD_ORDER 적용                     | 없음                      |

### 2-4. 버튼 상태

| 버튼명             | Visibility    | 기능           |
|--------------------|---------------|----------------|
| barItemSearch      | Always        | 조회           |
| acBarButtonItem1   | Always        | QMS 전송       |
| barItemNew         | **Never**     | 숨김 (미사용)  |
| barItemSave        | **Never**     | 숨김 (미사용)  |
| barItemDelete      | **Never**     | 숨김 (미사용)  |

---

## 3. 핵심 비즈니스 로직

### 3-1. 조회 (QCT08A_SER / SER2)

```
호출 경로:
  QCT08A_SER  → TSHP_INS_RESULT_MASTER_QUERY.QUERY1 (Tab1 조립)
  QCT08A_SER2 → TSHP_INS_RESULT_MASTER_QUERY.QUERY1 (Tab2 가공, 동일 쿼리)
```

**메인 조회 SQL (QUERY1)**:

```sql
SELECT A.PLT_CODE, A.INSM_NO,
       D.ORDER_NO, D.ORDER_LINE,
       D.ORDER_NO + '/' + CONVERT(NVARCHAR, D.ORDER_LINE) AS PROD_ORDER,
       D.PROD_WEEK, D.PROD_HOGI, D.INDUE_DATE,
       E.CUSTOMER, D.MODEL_TYPE, B.MODEL,
       '' AS QCT_STATE,
       CASE WHEN A.QMS_STATE = '1' THEN '전송' ELSE '미전송' END AS QMS_STATE,
       A.EMP_CODE, F.EMP_NAME,
       A.REG_DATE AS INS_DATE,
       C.INS_NO, C.PROC_CODE, G.PROC_NAME,
       C.INS_TYPE, C.INS_UNIT, C.INS_NAME, C.INS_DESC,
       C.AVG_VAL, C.MIN_VAL, C.MAX_VAL, C.INS_RESULT,
       CASE WHEN C.INS_RESULT_IMG IS NOT NULL THEN 1 ELSE 0 END AS IMG_CNT,
       C.INS_SEQ, B.SAP_WO_NO
FROM TSHP_INS_RESULT_MASTER A
LEFT JOIN TSHP_WORKORDER B      ON A.WO_NO = B.WO_NO
JOIN TSHP_INS_RESULT C           ON A.INSM_NO = C.INSM_NO AND C.DATA_FLAG = 0
LEFT JOIN TORD_PRODUCT D         ON B.PROD_CODE = D.PROD_CODE
LEFT JOIN IF_SAP_SHIPINFO E      ON D.ORDER_NO = E.ORDER_NO AND D.ORDER_LINE = E.ORDER_LINE
LEFT JOIN TSTD_EMPLOYEE F        ON A.EMP_CODE = F.EMP_CODE
LEFT JOIN LSE_STD_PROC G         ON C.PROC_CODE = G.PROC_CODE
WHERE A.PLT_CODE = @PLT_CODE
  AND A.DATA_FLAG = 0
  [AND D.ORDER_NO LIKE '%' + @ORDER_LIKE + '%']
  [AND D.PROD_HOGI LIKE '%' + @HOGI_LIKE + '%']
  [AND C.PROC_CODE = @PROC_CODE]
  [AND B.PLANTS = @PLANTS]
ORDER BY D.ORDER_NO, D.ORDER_LINE, A.INSM_NO, C.INS_SEQ
```

### 3-2. 이미지 조회 (QCT08A_SER3)

```
QCT08A_SER3 → TSHP_INS_RESULT.SER2
  SELECT PLT_CODE, INS_RESULT_IMG
  FROM TSHP_INS_RESULT
  WHERE PLT_CODE = @PLT_CODE AND INS_NO = @INS_NO
```

Tab1의 `INS_RESULT_IMG` ButtonEdit 클릭 시 해당 검사항목의 이미지를 조회하여 표시.

### 3-3. INS_RESULT 동적 에디터 (Pass/Fail 로직)

`CustomRowCellEdit` 이벤트로 `INS_TYPE`에 따라 에디터가 동적 전환:

| INS_TYPE | 에디터 타입     | LookUp  | 설명                    |
|----------|-----------------|---------|-------------------------|
| 1        | ComboBox        | C055    | 합격/불합격 선택        |
| 2        | TextEdit        | -       | 측정값 직접 입력        |
| 3        | ComboBox        | C055    | 합격/불합격 선택        |
| 4        | ButtonEdit      | -       | 이미지 첨부용           |
| 기타     | (기본) TextEdit  | -       | 텍스트 입력             |

> C053: 검사유형 코드 (TYPE 표시)
> C054: 단위 코드 (INS_UNIT 표시)
> C055: Pass/Fail 판정 코드 (합격/불합격)

---

## 4. QMS 전송 로직 (QCT08A_UPD / UPD2)

### 4-1. 전송 흐름

```
그리드 SEL 체크 → [QMS 전송] 버튼 클릭
  → ① TSHP_INS_RESULT_QUERY2: 선택된 INSM_NO로 검사결과 조회 (QMS 규격 변환)
  → ② IF_QMS_DAILY_INS INSERT: 인터페이스 테이블에 적재 (EAI_QRSULT='N')
  → ③ TSHP_INS_RESULT_MASTER UPD2: QMS_STATE='1', QMS_SEND_DATE=현재시각 갱신
  → ④ 그리드 재조회 (QMS_STATE '전송' 표시 갱신)
```

QCT08A_UPD (Tab1 조립), QCT08A_UPD2 (Tab2 가공) 동일 로직. 재조회만 SER/SER2 차이.

### 4-2. QMS 변환 쿼리 (TSHP_INS_RESULT_QUERY2)

```sql
SELECT N.INS_NO, W.SAP_WO_NO,
       CONVERT(VARCHAR, CONVERT(DECIMAL, P.ORDER_NO)) + '-'
         + CONVERT(VARCHAR, CONVERT(DECIMAL, P.ORDER_LINE)) AS ORDER_NO,
       N.REG_EMP AS EMP_CODE,
       PRC.MPROC_CODE AS PROC_CODE,
       PRC.PROC_NO AS PROC_SEQ,
       N.INS_NAME,
       N.INS_DESC AS IND_DESC,
       N.INS_UNIT, N.AVG_VAL, N.MIN_VAL, N.MAX_VAL, N.INS_RESULT,
       N.INS_SEQ,
       CONVERT(VARCHAR(8), N.REG_DATE, 112) AS INS_DATE,
       CASE WHEN N.INS_RESULT_IMG IS NULL THEN NULL
            ELSE 'INS/' + CONVERT(VARCHAR(8), GETDATE(), 112) + '/' + N.INS_NO + '-IMG1.JPG'
       END AS NG_IMG1,
       'N' AS EAI_QRSULT
FROM TSHP_INS_RESULT N
LEFT JOIN TSHP_INS_RESULT_MASTER NM ON N.INSM_NO = NM.INSM_NO
LEFT JOIN TSHP_WORKORDER W           ON NM.WO_NO = W.WO_NO
LEFT JOIN TORD_PRODUCT P             ON W.PROD_CODE = P.PROD_CODE
LEFT JOIN LSE_STD_PROC PRC           ON N.PROC_CODE = PRC.PROC_CODE
WHERE N.PLT_CODE = @PLT_CODE
  AND N.INSM_NO = @INSM_NO AND N.DATA_FLAG = 0
```

### 4-3. QMS_STATE 갱신 (TSHP_INS_RESULT_MASTER_UPD2)

```sql
UPDATE TSHP_INS_RESULT_MASTER
SET QMS_STATE = @QMS_STATE,
    QMS_SEND_DATE = GETDATE(),
    MDFY_DATE = GETDATE(),
    MDFY_EMP = @현재사용자,
    DATA_FLAG = @DATA_FLAG
WHERE PLT_CODE = @PLT_CODE AND INSM_NO = @INSM_NO
```

---

## 5. QMS 인터페이스 분석

### 5-1. IF_QMS_DAILY_INS 테이블 구조

| 컬럼명       | 용도                                | ProActive 설정  | 외부 설정     |
|--------------|-------------------------------------|:---------------:|:-------------:|
| INS_NO       | 검사결과번호 (PK)                   | INSERT          | -             |
| SAP_WO_NO    | SAP 작업오더번호                    | INSERT          | -             |
| ORDER_NO     | 주문번호                            | INSERT          | -             |
| EMP_CODE     | 검사자사번                          | INSERT          | -             |
| PROC_CODE    | 공정코드                            | INSERT          | -             |
| PROC_SEQ     | 공정순번                            | INSERT          | -             |
| INS_NAME     | 검사항목명                          | INSERT          | -             |
| IND_DESC     | 점검내역                            | INSERT          | -             |
| INS_UNIT     | 단위                                | INSERT          | -             |
| AVG_VAL      | 기준값                              | INSERT          | -             |
| MIN_VAL      | 최소값                              | INSERT          | -             |
| MAX_VAL      | 최대값                              | INSERT          | -             |
| INS_RESULT   | 검사결과값                          | INSERT          | -             |
| INS_SEQ      | 검사순번                            | INSERT          | -             |
| INS_DATE     | 검사일 (YYYYMMDD)                   | INSERT          | -             |
| NG_IMG1~4    | NG 이미지 경로                      | INSERT          | -             |
| EAI_QRSULT   | 전송결과 ('N'→미전송, 'Y'→완료)     | 'N'             | 'Y'로 갱신    |
| EAI_QMSTXT   | QMS 응답 메시지                     | -               | (미사용)      |
| EAI_UPDATE   | EAI 처리 일시                       | -               | (미사용)      |

### 5-2. 전송 아키텍처

```
ProActive 앱 (QCT08A/POP30A/POP30B)       외부 배치/EAI              SAP QMS (Oracle)
──────────────────────────────────         ──────────────             ────────────────
① TSHP_INS_RESULT_QUERY2
   (검사결과 → QMS 규격 변환)
        ↓
② IF_QMS_DAILY_INS INSERT
   (EAI_QRSULT = 'N')            →  ③ 폴링/감지  →  ④ Linked Server
        ↓                                               LQMS (Oracle)로 전송
⑤ QMS_STATE = '1' 갱신           ←  ⑥ EAI_QRSULT = 'Y' 갱신
```

### 5-3. AS-IS DB 확인 결과

| 확인 항목                           | 결과                                              |
|-------------------------------------|---------------------------------------------------|
| 트리거 (IF_QMS_DAILY_INS)          | **없음**                                          |
| 트리거 (TSHP_INS_RESULT_MASTER)    | **없음**                                          |
| 트리거 (TSHP_INS_RESULT)           | **없음**                                          |
| Linked Server                       | **LQMS** (OraOLEDB.Oracle → Oracle QMS DB)        |
| Linked Server                       | **WELS** (SQLNCLI → 10.125.12.173,1433 MSSQL)    |
| IF_QMS_DAILY_INS 데이터             | 843,243건 전체 `EAI_QRSULT='Y'` (미전송 0건)     |
| EAI_QMSTXT / EAI_UPDATE            | 전체 NULL (미사용 컬럼)                           |
| SQL Agent Job                       | 권한 부족으로 조회 불가                           |

### 5-4. 추정 메커니즘

- 트리거 없음 → **SQL Agent Job 또는 SSIS 패키지**가 `EAI_QRSULT='N'` 건을 감지
- Linked Server `LQMS`(Oracle)를 통해 Oracle QMS DB에 직접 INSERT
- 완료 후 `EAI_QRSULT='Y'`로 UPDATE
- 현재 미전송 건이 0건 → 실시간에 가까운 주기로 배치 동작 중

### 5-5. IF_QMS_DAILY_INS 호출처 (ProActive 내)

| 화면      | 용도                                    |
|-----------|-----------------------------------------|
| QCT08A    | 자주검사 현황 → QMS 전송 버튼           |
| POP30A    | 조립 단말기 → 검사 완료 시 자동 전송    |
| POP30B    | 가공 단말기 → 검사 완료 시 자동 전송    |

3곳 모두 동일한 패턴: `QUERY2 변환 → IF_QMS_DAILY_INS INSERT → MASTER UPD2`

---

## 6. 관련 테이블 요약

| 테이블명                   | 용도                        | 주요 컬럼                                          |
|----------------------------|-----------------------------|----------------------------------------------------|
| TSHP_INS_RESULT_MASTER     | 검사결과 마스터             | PLT_CODE, INSM_NO(PK), WO_NO, EMP_CODE, QMS_STATE |
| TSHP_INS_RESULT            | 검사결과 상세               | PLT_CODE, INS_NO(PK), INSM_NO(FK), INS_RESULT, INS_RESULT_IMG |
| TSHP_WORKORDER             | 작업오더                    | WO_NO, PROD_CODE, SAP_WO_NO, PLANTS               |
| TORD_PRODUCT               | 생산제품                    | PROD_CODE, ORDER_NO, ORDER_LINE, PROD_HOGI         |
| IF_SAP_SHIPINFO            | SAP 출하정보                | ORDER_NO, ORDER_LINE, CUSTOMER                     |
| TSTD_EMPLOYEE              | 사원 마스터                 | EMP_CODE, EMP_NAME                                 |
| LSE_STD_PROC               | 공정 마스터                 | PROC_CODE, PROC_NAME, MPROC_CODE, PROC_NO         |
| IF_QMS_DAILY_INS           | QMS 인터페이스 (송신)       | INS_NO, SAP_WO_NO, EAI_QRSULT                     |

---

## 7. To-be 작업 분해

### Phase 1: 기본 화면 + 조회

| #   | 작업                          | 산출물                                              | 난이도 |
|-----|-------------------------------|-----------------------------------------------------|--------|
| 1-1 | Controller/Service 생성       | `Qct08aController.java`, `Qct08aService.java`       | 낮음   |
| 1-2 | 메인 조회 SP 작성             | `sp_imes_tshp_ins_result_master_query.sql`           | 중간   |
| 1-3 | Mapper XML 작성               | `TSHP_INS_RESULT_MASTER_QUERY.xml`                  | 낮음   |
| 1-4 | JSP 작성 (탭 2개)             | `qct08a.jsp` (ASSY/MACH 공용 JSP 패턴)              | 중간   |
| 1-5 | JS 작성                       | `qct08a.js` (그리드 초기화, 탭 전환, 검색)           | 중간   |
| 1-6 | 검색조건 콤보박스             | C060(검사공정) 코드 로드                             | 낮음   |

### Phase 2: 동적 에디터 + 이미지

| #   | 작업                          | 산출물                                              | 난이도 |
|-----|-------------------------------|-----------------------------------------------------|--------|
| 2-1 | INS_TYPE별 동적 에디터        | JS: `onLoadSuccess`에서 INS_TYPE별 분기              | **높음** |
| 2-2 | LookUp 코드 매핑              | C053(검사유형), C054(단위), C055(합격/불합격)        | 낮음   |
| 2-3 | 이미지 조회 (SER3)            | SP + Controller 이미지 반환 API                      | 중간   |
| 2-4 | Cell Merge (PROD_ORDER)       | EasyUI datagrid rowspan 처리                         | 중간   |

### Phase 3: QMS 전송

| #   | 작업                          | 산출물                                              | 난이도 |
|-----|-------------------------------|-----------------------------------------------------|--------|
| 3-1 | QMS 변환 SP (QUERY2 기반)     | `sp_imes_tshp_ins_result_qms.sql`                    | 중간   |
| 3-2 | QMS INSERT SP                 | IF_QMS_DAILY_INS 테이블 INSERT                      | 낮음   |
| 3-3 | QMS_STATE 갱신 SP             | TSHP_INS_RESULT_MASTER UPD2                         | 낮음   |
| 3-4 | JS QMS 전송 버튼 바인딩       | SEL 체크 → 확인 → AJAX 호출 → 재조회                | 낮음   |

### Phase 4: 인프라 협의 (개발 범위 외)

| #   | 작업                          | 비고                                                |
|-----|-------------------------------|-----------------------------------------------------|
| 4-1 | QMS 연계 방안 결정            | AS-IS: Linked Server(Oracle). TO-BE: MySQL→Oracle 불가 |
| 4-2 | EAI 미들웨어 또는 API 연계    | 인프라팀/SAP팀 협의 필수                            |

---

## 8. 특이사항 / 주의점

1. **동적 에디터 (난이도 높음)**: AS-IS `CustomRowCellEdit`을 EasyUI에서 구현하려면 `onLoadSuccess`에서 각 행 INS_TYPE별 셀 에디터 동적 변경 필요. EasyUI 기본 기능에 직접 대응 없어 커스텀 로직 필요
2. **Cell Merge**: EasyUI datagrid 기본 미지원. `onLoadSuccess`에서 DOM 조작 또는 별도 플러그인 필요
3. **TSTD_EMPLOYEE → SYS_USER 전환**: 조회 SQL에서 F(TSTD_EMPLOYEE) JOIN을 SYS_USER로 변경 필요
4. **MSSQL → MySQL 변환**: `CONVERT(NVARCHAR, ...)` → `CAST(... AS CHAR)`, `GETDATE()` → `NOW()` 등
5. **QMS 인터페이스**: AS-IS는 Linked Server(Oracle) 기반. TO-BE MySQL에서는 동일 방식 불가 → 인프라 협의 필수
6. **조회 전용 화면**: 검사값(INS_RESULT)은 그리드에 표시만 하고, 이 화면에서 수정/저장하는 로직 없음. 검사 입력은 POP30A/POP30B(단말기 화면)에서 수행
