# 정례비가동관리 (Regular/Scheduled Downtime Management) - DB 스펙

> 작성자: 송우석
> 화면 ID: STD49A
> AS-IS 소스 경로: `C:\proActive\DecompiledSrc\`

---

## Core Tables

- **TSTD_IDLETIME** — 정례 비가동 시간 스케줄 마스터 (STD49A 핵심 테이블)
- **TSTD_IDLECODE** — 비가동 사유 코드 마스터 (비가동명 참조)
- **TSHP_IDLETIME** — 실적 비가동 시간 기록 (참조, STD49A에서 직접 사용하지 않음)
- **TSTD_ORG** — 조직 마스터 (TSTD_IDLECODE의 MG_ORG 참조)

---

## 1. TSTD_IDLETIME (정례 비가동 시간 스케줄)

> 정기적으로 반복되는 비가동 시간(점심, 휴식 등)의 스케줄을 관리하는 기준정보 테이블

### 1.1 컬럼 상세

| 컬럼명           | 데이터 타입 (추정) | PK  | NULL 허용 | 기본값                  | 설명                                  |
|------------------|---------------------|-----|-----------|-------------------------|---------------------------------------|
| PLT_CODE         | VARCHAR             | PK  | N         |                         | 공장코드                              |
| IDLE_NO          | VARCHAR             | PK  | N         | UTILITY_GET_SERIALNO    | 비가동번호 (자동채번, 접두어 'IDT')   |
| SCODE            | VARCHAR             |     | N         |                         | 비가동사유코드 (FK → TSTD_IDLECODE)   |
| IDLE_START_TIME  | VARCHAR(4)          |     | N         |                         | 비가동 시작시간 (HHmm, 예: "1200")   |
| IDLE_END_TIME    | VARCHAR(4)          |     | N         |                         | 비가동 종료시간 (HHmm, 예: "1300")   |
| SCOMMENT         | NVARCHAR            |     | Y         |                         | 비고                                  |
| REG_DATE         | DATETIME            |     | N         | GETDATE()               | 등록일시                              |
| REG_EMP          | VARCHAR             |     | N         | ConnInfo.UserID         | 등록자                                |
| MDFY_DATE        | DATETIME            |     | Y         | GETDATE()               | 수정일시                              |
| MDFY_EMP         | VARCHAR             |     | Y         | ConnInfo.UserID         | 수정자                                |
| DEL_DATE         | DATETIME            |     | Y         | GETDATE()               | 삭제일시                              |
| DEL_EMP          | VARCHAR             |     | Y         | ConnInfo.UserID         | 삭제자                                |
| DATA_FLAG        | TINYINT             |     | N         | 0                       | 데이터 상태 (0=활성, 2=삭제)          |

### 1.2 채번 규칙

```
IDLE_NO = UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "IDT", YYYYMMDD)
예: IDT20260203001, IDT20260203002, ...
```

### 1.3 시간 저장 형식

- DB 저장: 4자리 문자열 `HHmm` (예: `"1200"`, `"1300"`)
- 화면 표시: `HH:mm` 형식 (예: `"12:00"`, `"13:00"`)
- 변환 규칙: 저장 시 콜론 제거, 조회 시 콜론 삽입
  ```
  화면 → DB: "12:00" → "1200" (Substring(0,2) + Substring(3,2))
  DB → 화면: "1200" → "12:00" (Substring(0,2) + ":" + Substring(2,2))
  ```

### 1.4 CRUD 메서드 (DA: TSTD_IDLETIME.cs)

| 메서드                   | 동작              | 조건                              |
|--------------------------|-------------------|-----------------------------------|
| TSTD_IDLETIME_SER        | PK 조회           | PLT_CODE + IDLE_NO                |
| TSTD_IDLETIME_INS        | 신규 등록         | REG_DATE=GETDATE(), DATA_FLAG=0   |
| TSTD_IDLETIME_UPD        | 전체 컬럼 수정    | MDFY_DATE=GETDATE()               |
| TSTD_IDLETIME_UDE        | 논리 삭제         | DATA_FLAG=2, DEL_DATE=GETDATE()   |

### 1.5 쿼리 메서드 (DA: TSTD_IDLETIME_QUERY.cs)

| 메서드                        | 용도                   | JOIN/조건                                                                                                 |
|-------------------------------|------------------------|-----------------------------------------------------------------------------------------------------------|
| TSTD_IDLETIME_QUERY1          | 메인 조회 (목록)       | JOIN TSTD_IDLECODE ON SCODE, 동적 WHERE: SCODE, SAP_CODE, IDLE_CODE, IDLE_LIKE, PLANTS, DATA_FLAG        |
| TSTD_IDLETIME_QUERY2          | 시간 중복 체크         | 동적 WHERE: PLANTS, NOT_IDLE_NO(자기 제외), 반환: IDLE_NO, SCODE, IDLE_START_TIME, IDLE_END_TIME          |

**QUERY1 반환 컬럼**: IDLE_NO, SCODE, IDLE_START_TIME, IDLE_END_TIME, SCOMMENT + TSTD_IDLECODE 컬럼(IDLE_CODE, PLANTS, SAP_CODE, IDLE_NAME)

**QUERY1 정렬**: `ORDER BY IDLE_START_TIME, IDLE_SEQ`

---

## 2. TSTD_IDLECODE (비가동 사유 코드 마스터)

> 비가동 사유를 분류·관리하는 코드 테이블. STD49A에서는 비가동명 드롭다운 데이터로 참조

### 2.1 컬럼 상세

| 컬럼명           | 데이터 타입 (추정) | PK  | NULL 허용 | 기본값                  | 설명                                           |
|------------------|---------------------|-----|-----------|-------------------------|-------------------------------------------------|
| PLT_CODE         | VARCHAR             | PK  | N         |                         | 공장코드                                        |
| SCODE            | VARCHAR             | PK  | N         |                         | 비가동사유 순번코드 (내부 PK)                   |
| PLANTS           | VARCHAR             |     | N         |                         | 공장구분 (3603=조립, 3605=가공)                  |
| IDLE_CODE        | VARCHAR             |     | N         |                         | 비가동코드 (외부 표시용)                         |
| SAP_CODE         | VARCHAR             |     | Y         |                         | SAP 연동 코드                                   |
| IDLE_NAME        | NVARCHAR            |     | N         |                         | 비가동명                                        |
| MG_TYPE1         | VARCHAR             |     | Y         |                         | 관리유형1                                       |
| MG_TYPE2         | VARCHAR             |     | Y         |                         | 관리유형2                                       |
| MG_ORG           | VARCHAR             |     | Y         |                         | 관리조직코드 (FK → TSTD_ORG.ORG_CODE)           |
| IDLE_SEQ         | INT                 |     | Y         |                         | 정렬순서                                        |
| ALARM_TYPE       | VARCHAR             |     | Y         |                         | 알람유형                                        |
| SCOMMENT         | NVARCHAR            |     | Y         |                         | 비고                                            |
| USE_FLAG         | VARCHAR(1)          |     | N         |                         | 사용여부 (0=미사용, 1=사용)                      |
| IS_NG            | VARCHAR(1)          |     | Y         |                         | 불량 관련 여부                                   |
| IS_MCT_SCOMMENT  | VARCHAR(1)          |     | Y         |                         | MCT 코멘트 사용 여부                            |
| IS_SAP           | VARCHAR(1)          |     | Y         |                         | SAP 연동 여부                                    |
| IS_RPT           | VARCHAR(1)          |     | Y         |                         | 리포트 포함 여부                                 |
| REG_DATE         | DATETIME            |     | N         | GETDATE()               | 등록일시                                        |
| REG_EMP          | VARCHAR             |     | N         | ConnInfo.UserID         | 등록자                                          |
| MDFY_DATE        | DATETIME            |     | Y         | GETDATE()               | 수정일시                                        |
| MDFY_EMP         | VARCHAR             |     | Y         | ConnInfo.UserID         | 수정자                                          |
| DEL_DATE         | DATETIME            |     | Y         | GETDATE()               | 삭제일시                                        |
| DEL_EMP          | VARCHAR             |     | Y         | ConnInfo.UserID         | 삭제자                                          |
| DATA_FLAG        | TINYINT             |     | N         | 0                       | 데이터 상태 (0=활성, 2=삭제)                    |

### 2.2 CRUD 메서드 (DA: TSTD_IDLECODE.cs)

| 메서드                    | 동작                         | 조건/특징                                              |
|---------------------------|------------------------------|--------------------------------------------------------|
| TSTD_IDLECODE_SER         | PK 단건 조회                 | PLT_CODE + SCODE                                       |
| TSTD_IDLECODE_SER2        | 공장별 활성 코드 목록        | PLANTS, DATA_FLAG=0, USE_FLAG='1', ORDER BY IDLE_SEQ   |
| TSTD_IDLECODE_SER3        | IDLE_CODE로 조회             | PLT_CODE + IDLE_CODE                                   |
| TSTD_IDLECODE_INS         | 신규 등록                    | 전체 컬럼 INSERT                                       |
| TSTD_IDLECODE_UPD         | 전체 수정                    | 전체 컬럼 UPDATE                                       |
| TSTD_IDLECODE_UPD2        | 부분 수정                    | USE_FLAG, IDLE_SEQ, IS_NG, IS_SAP, IS_RPT, IS_MCT만   |
| TSTD_IDLECODE_UDE         | 논리 삭제                    | DATA_FLAG=2                                            |

### 2.3 쿼리 메서드 (DA: TSTD_IDLECODE_QUERY.cs)

| 메서드                        | 용도                  | JOIN/조건                                                                         |
|-------------------------------|-----------------------|-----------------------------------------------------------------------------------|
| TSTD_IDLECODE_QUERY1          | 코드 목록 조회        | LEFT JOIN TSTD_ORG (MG_ORG → ORG_CODE → MG_ORG_NAME), 동적 WHERE 다수, ORDER BY IDLE_SEQ |

---

## 3. TSHP_IDLETIME (실적 비가동 시간 기록) — 참조 테이블

> 실제 현장에서 발생한 비가동 이력을 기록하는 트랜잭션 테이블.
> STD49A(정례비가동관리)에서는 직접 사용하지 않으나, 비가동 코드 체계를 공유함

### 3.1 컬럼 상세

| 컬럼명              | 데이터 타입 (추정) | PK  | NULL 허용 | 설명                                       |
|---------------------|---------------------|-----|-----------|--------------------------------------------|
| PLT_CODE            | VARCHAR             | PK  | N         | 공장코드                                   |
| IDLE_ID             | VARCHAR             | PK  | N         | 비가동 실적 ID                             |
| WORK_DATE           | VARCHAR(8)          |     | N         | 작업일자 (YYYYMMDD)                        |
| MC_CODE             | VARCHAR             |     | N         | 설비코드 (FK → LSE_MACHINE)               |
| EMP_CODE            | VARCHAR             |     | Y         | 작업자코드 (FK → TSTD_EMPLOYEE)            |
| IDLE_CODE           | VARCHAR             |     | N         | 비가동코드 (FK → TSTD_IDLECODE.IDLE_CODE) |
| IDLE_TIME           | INT                 |     | Y         | 비가동시간(분)                             |
| IDLE_STATE          | VARCHAR(1)          |     | N         | 비가동상태 (1=진행중, 2=완료 등)           |
| START_TIME          | DATETIME            |     | N         | 실제 시작시간                              |
| END_TIME            | DATETIME            |     | Y         | 실제 종료시간 (NULL=진행중)                |
| SCOMMENT            | NVARCHAR            |     | Y         | 비고                                       |
| ACTUAL_ID           | VARCHAR             |     | Y         | 실적 ID                                    |
| WO_NO               | VARCHAR             |     | Y         | 작업지시번호                               |
| NG_ID               | VARCHAR             |     | Y         | 불량 ID                                    |
| IF_FLAG             | VARCHAR             |     | Y         | 인터페이스 플래그                          |
| IF_SEL_FLAG         | VARCHAR             |     | Y         | 인터페이스 선택 플래그                     |
| IS_AUTO_IDLE_FLAG   | VARCHAR(1)          |     | Y         | 자동비가동 플래그                          |
| MCT_SCOMMENT        | NVARCHAR            |     | Y         | MCT 코멘트                                |
| MCT_SCOMMENT_RESULT | NVARCHAR            |     | Y         | MCT 코멘트 결과                            |
| REG_DATE            | DATETIME            |     | N         | 등록일시                                   |
| REG_EMP             | VARCHAR             |     | N         | 등록자                                     |
| MDFY_DATE           | DATETIME            |     | Y         | 수정일시                                   |
| MDFY_EMP            | VARCHAR             |     | Y         | 수정자                                     |
| DEL_DATE            | DATETIME            |     | Y         | 삭제일시                                   |
| DEL_EMP             | VARCHAR             |     | Y         | 삭제자                                     |
| DATA_FLAG           | TINYINT             |     | N         | 데이터 상태 (0=활성, 2=삭제)               |

### 3.2 TSTD_IDLETIME vs TSHP_IDLETIME 비교

| 구분               | TSTD_IDLETIME (정례)           | TSHP_IDLETIME (실적)              |
|--------------------|--------------------------------|-----------------------------------|
| 성격               | 기준정보 (스케줄)              | 트랜잭션 (실적)                   |
| PK                 | PLT_CODE + IDLE_NO             | PLT_CODE + IDLE_ID                |
| 시간 형식          | VARCHAR(4) HHmm                | DATETIME (실제 시각)              |
| 설비/작업자        | 없음 (공장 단위)               | MC_CODE, EMP_CODE 보유            |
| 작업일자           | 없음 (매일 반복)               | WORK_DATE 보유                    |
| 비가동 상태        | 없음                           | IDLE_STATE (진행/완료)            |
| 관련 화면          | STD49A                         | POP 계열 (현장 실적)              |

---

## 4. TSTD_ORG (조직 마스터) — 참조 테이블

> TSTD_IDLECODE의 MG_ORG 필드가 참조하는 조직 마스터

### 4.1 컬럼 상세

| 컬럼명       | 데이터 타입 (추정) | PK  | NULL 허용 | 설명             |
|--------------|---------------------|-----|-----------|------------------|
| PLT_CODE     | VARCHAR             | PK  | N         | 공장코드         |
| ORG_CODE     | VARCHAR             | PK  | N         | 조직코드         |
| ORG_NAME     | NVARCHAR            |     | N         | 조직명           |
| ORG_PARENT   | VARCHAR             |     | Y         | 상위조직코드     |
| ORG_LEADER   | VARCHAR             |     | Y         | 조직장코드       |
| ORG_SEQ      | INT                 |     | Y         | 정렬순서         |
| COST_CENTER  | VARCHAR             |     | Y         | 코스트센터       |
| REG_DATE     | DATETIME            |     | N         | 등록일시         |
| REG_EMP      | VARCHAR             |     | N         | 등록자           |
| MDFY_DATE    | DATETIME            |     | Y         | 수정일시         |
| MDFY_EMP     | VARCHAR             |     | Y         | 수정자           |
| DEL_DATE     | DATETIME            |     | Y         | 삭제일시         |
| DEL_EMP      | VARCHAR             |     | Y         | 삭제자           |
| DEL_REASON   | NVARCHAR            |     | Y         | 삭제사유         |
| DATA_FLAG    | TINYINT             |     | N         | 데이터 상태      |

---

## 5. 테이블 관계도 (ERD)

```
TSTD_IDLETIME (정례 비가동 스케줄)
  ├── SCODE ──────────→ TSTD_IDLECODE.SCODE (비가동 사유 코드)
  └── PLT_CODE                │
                               ├── PLANTS (공장구분: 3603=조립, 3605=가공)
                               ├── IDLE_CODE (외부 표시 코드)
                               ├── MG_ORG ──→ TSTD_ORG.ORG_CODE (관리 조직)
                               └── (TSTD_IDLECODE_QUERY1에서 LEFT JOIN TSTD_ORG)

TSHP_IDLETIME (실적 비가동)
  ├── IDLE_CODE ──────→ TSTD_IDLECODE.IDLE_CODE
  ├── MC_CODE ────────→ LSE_MACHINE.MC_CODE (설비)
  └── EMP_CODE ───────→ TSTD_EMPLOYEE.EMP_CODE (작업자)
```

---

## 6. 비즈니스 로직 (BR: STD49A.cs)

### 6.1 메서드 요약

| 메서드          | 기능               | 호출 DA                                              |
|-----------------|--------------------|----------------------------------------------------- |
| STD49A_SER      | 정례비가동 목록조회 | TSTD_IDLETIME_QUERY1 (DATA_FLAG=0 자동 설정)         |
| STD49A_IDLE     | 비가동코드 목록조회 | TSTD_IDLECODE_QUERY1 (DATA_FLAG=0 자동 설정)         |
| STD49A_INS      | 등록/수정 (UPSERT) | TSTD_IDLETIME_SER → QUERY2(중복체크) → INS 또는 UPD  |
| STD49A_DEL      | 논리 삭제          | TSTD_IDLETIME_UDE (DATA_FLAG=2)                      |

### 6.2 STD49A_INS 상세 흐름

```
1. DATA_FLAG=0 설정
2. 각 행(row)에 대해 반복:
   a. TSTD_IDLETIME_SER(PK 조회) → 기존 데이터 존재 여부 확인
   b. TSTD_IDLETIME_QUERY2(시간 중복 체크) → NOT_IDLE_NO로 자기 자신 제외
   c. 중복 판정 (4가지 조건):
      - 기존 시작 < 신규 시작 < 기존 종료
      - 기존 시작 < 신규 종료 < 기존 종료
      - 신규 시작 < 기존 종료 < 신규 종료
      - 신규 시작 == 기존 시작 AND 신규 종료 == 기존 종료
   d. 중복 시 → 에러 100009 ("비가동 시간 중복")
   e. 기존 데이터 존재 시:
      - OVERWRITE != "1" 이면:
        - DATA_FLAG=2(이력) → 에러 100002 ("동일 데이터가 이력이 존재")
        - 그 외 → 에러 100001 ("동일 데이터가 존재")
      - OVERWRITE == "1" 이면 → TSTD_IDLETIME_UPD (덮어쓰기)
   f. 기존 데이터 미존재 시:
      - IDLE_NO 자동채번 (IDT + YYYYMMDD)
      - TSTD_IDLETIME_INS
3. STD49A_SER 재호출하여 최신 목록 반환
```

### 6.3 에러 코드

| 에러번호 | 메시지                               | 처리                                    |
|----------|--------------------------------------|-----------------------------------------|
| 100001   | 동일 데이터가 존재할때 발생          | Yes/No → Yes면 OVERWRITE=1로 재시도     |
| 100002   | 동일 데이터가 이력이 존재할때 발생   | 삭제 이력 표시 → Yes면 OVERWRITE=1 재시도|
| 100009   | 비가동 시간 중복                     | 확인 메시지 표시 (저장 불가)            |

---

## 7. 화면 구성

### 7.1 메인 화면 (STD49A_M0A)

```
┌─────────────────────────────────────────────────┐
│ [조회]                                    도구상자│
├─────────────────────────────────────────────────┤
│ ┌──────────┬──────────┐                         │
│ │  조립     │  가공     │          ← TabControl  │
│ ├──────────┴──────────┤                         │
│ │ 검색조건                                      │
│ │ 비가동명: [________]    ← IDLE_LIKE 검색      │
│ ├───────────────────────────────────────────────┤
│ │ 비가동명 │ 비가동 시작시간 │ 비가동 종료시간 │ 비고│
│ │ (SCODE)  │(IDLE_START_TIME)│(IDLE_END_TIME)  │     │
│ │ LookUp   │   Center       │   Center        │     │
│ │ 점심     │   12:00        │   13:00         │     │
│ │ 휴식     │   10:00        │   10:15         │     │
│ │          │                │                 │     │
│ │ Hidden: IDLE_NO                              │
│ │ KeyColumn: IDLE_NO                           │
│ │ AllowCellMerge: true                         │
│ └───────────────────────────────────────────────┘
│                                    StatusBar     │
└─────────────────────────────────────────────────┘
```

**탭 구성**:

| 탭명   | ContainerName | PLANTS 값 | 설명                  |
|--------|---------------|------------|-----------------------|
| 조립   | ASSY          | 3603       | 조립 공장 비가동 관리 |
| 가공   | MC            | 3605       | 가공 공장 비가동 관리 |

**그리드 컬럼**:

| 컬럼명           | 표시명          | 정렬    | 편집 가능 | 필수 | 비고                          |
|------------------|-----------------|---------|-----------|------|-------------------------------|
| SCODE            | 비가동명        | Center  | N         | N    | LookUpEdit (IDLE_NAME, SCODE) |
| IDLE_START_TIME  | 비가동 시작시간 | Center  | N         | N    | RegEx: HH:mm                  |
| IDLE_END_TIME    | 비가동 종료시간 | Center  | N         | N    | RegEx: HH:mm                  |
| SCOMMENT         | 비고            | Near    | N         | N    |                               |
| IDLE_NO          | (숨김)          | -       | -         | -    | Hidden, KeyColumn              |

**우클릭 컨텍스트 메뉴**:

| 메뉴 항목 | 표시 조건                      | 동작               |
|-----------|--------------------------------|--------------------|
| 새로만들기 | 항상 표시                      | D0A 팝업 NEW 모드  |
| 열기       | 행 선택 시                     | D0A 팝업 OPEN 모드 |
| 삭제       | 행 선택 시                     | 삭제 확인 → DEL    |

**더블클릭**: 행 더블클릭 시 D0A 팝업 OPEN 모드 열기

**검색 흐름**:
1. 비가동명(IDLE_LIKE) 입력 후 Enter 또는 조회 버튼 클릭
2. 현재 선택된 탭에 따라 PLANTS 값 결정 (ASSY→3603, MC→3605)
3. `STD49A_SER` 호출 → 해당 탭의 그리드에 결과 바인딩

### 7.2 등록/수정 팝업 (STD49A_D0A) — "비가동 관리 편집기"

```
┌──────────────────────────────┐
│ [초기화] [저장] [저장닫기] [삭제] │
├──────────────────────────────┤
│ 비가동    : [▼ 드롭다운   ]  │ ← SCODE (LookUpEdit, 필수)
│ 시작 시간 : [__:__       ]  │ ← IDLE_START_TIME (필수, RegEx HH:mm)
│ 종료 시간 : [__:__       ]  │ ← IDLE_END_TIME (필수, RegEx HH:mm)
│ 비고      : [             ] │ ← SCOMMENT (MemoEdit)
│            [             ] │
│            [             ] │
└──────────────────────────────┘
```

**모드별 버튼 표시**:

| 모드   | 초기화 | 저장 | 저장닫기 | 삭제 |
|--------|--------|------|----------|------|
| NEW    | O      | O    | X        | X    |
| OPEN   | X      | X    | O        | O    |

**입력 필드**:

| 필드명           | 컨트롤         | 필수 | 읽기전용 | 마스크                          |
|------------------|----------------|------|----------|---------------------------------|
| SCODE            | LookUpEdit     | Y    | N        | -                               |
| IDLE_START_TIME  | TextEdit       | Y    | N        | RegEx: `(0?\d|1\d|2[0-3])\:[0-5]\d` |
| IDLE_END_TIME    | TextEdit       | Y    | N        | RegEx: `(0?\d|1\d|2[0-3])\:[0-5]\d` |
| SCOMMENT         | MemoEdit       | N    | N        | -                               |

**시간 유효성 검사 (isTimeCheck)**:
1. 시작시간, 종료시간 모두 5자리(HH:mm) 형식이어야 함
2. 시작시간 < 종료시간이어야 함 (정수 변환 비교)
3. 유효하지 않으면 "입력 형식이 잘못되었습니다." 메시지

**저장 처리 (NEW 모드)**:
1. `ValidCheck()` → 필수 항목 검증
2. `isTimeCheck()` → 시간 형식/순서 검증
3. 파라미터 구성: PLT_CODE, IDLE_NO(null), SCODE, IDLE_START_TIME(HHmm), IDLE_END_TIME(HHmm), PLANTS, SCOMMENT, REG_EMP, OVERWRITE="0"
4. `STD49A_INS` 호출
5. 성공 시 메인 그리드 자동 갱신 (UpdateMappingRow)

**저장닫기 처리 (OPEN 모드)**:
1. 동일한 검증 과정
2. IDLE_NO = 기존 값, OVERWRITE="1" (덮어쓰기 모드)
3. 저장 후 팝업 자동 닫힘

**삭제 처리**:
1. "정말 삭제하시겠습니까?" 확인 → 삭제사유 입력
2. PLT_CODE, IDLE_NO, DEL_EMP, DEL_REASON 전달
3. `STD49A_DEL` 호출 (논리 삭제)
4. 메인 그리드에서 해당 행 제거, 팝업 닫힘

**에러 처리 (QuickException)**:

| 에러번호 | 처리                                                              |
|----------|-------------------------------------------------------------------|
| 100001   | "동일 데이터 존재" → Yes/No → Yes면 OVERWRITE=1로 재시도         |
| 100002   | 삭제 이력 표시 (DEL_DATE, DEL_EMP, DEL_REASON 그리드) → Yes면 재시도 |
| 100009   | "기존등록된 비가동 시간과 겹칩니다." 확인 메시지                 |

---

## 8. AS-IS 소스 파일 매핑

| 구분           | AS-IS 파일                                                    | 용도                     |
|----------------|---------------------------------------------------------------|--------------------------|
| DA (데이터)    | `CUBIZ_DA\DSTD\TSTD_IDLETIME.cs`                             | 비가동 스케줄 CRUD       |
| DA (쿼리)      | `CUBIZ_DA\DSTD\TSTD_IDLETIME_QUERY.cs`                       | 비가동 스케줄 조회/중복  |
| DA (데이터)    | `CUBIZ_DA\DSTD\TSTD_IDLECODE.cs`                             | 비가동 코드 CRUD         |
| DA (쿼리)      | `CUBIZ_DA\DSTD\TSTD_IDLECODE_QUERY.cs`                       | 비가동 코드 조회         |
| DA (데이터)    | `CUBIZ_DA\DSHP\TSHP_IDLETIME.cs`                             | 실적 비가동 CRUD (참조)  |
| DA (데이터)    | `CUBIZ_DA\DSTD\TSTD_ORG.cs`                                  | 조직 마스터 (참조)       |
| BR (비즈니스)  | `CUBIZ_BR\BSTD\STD49A.cs`                                    | STD49A 비즈니스 로직     |
| 화면 (메인)    | `STD\STD\STD49A_M0A.cs`                                      | 메인 화면                |
| 화면 (팝업)    | `STD\STD\STD49A_D0A.cs`                                      | 등록/수정 팝업           |

---

## 9. TO-BE 전환 시 고려사항

### 9.1 파일 구조

```
TO-BE:
  Java:   com.wsc.std.std49a/Std49aController.java, Std49aService.java, ...
  Mapper: resources/mappers/com/wsc/std/std49a/Std49a.xml
  JSP:    WEB-INF/views/std/std49a/std49a.jsp         (메인)
          WEB-INF/views/std/std49a/std49a_d0a.jsp      (팝업)
  JS:     resources/js/std/std49a/std49a.js            (메인)
          resources/js/std/std49a/std49a_d0a.js         (팝업)
  URL:    /std/std49a/std49a.do
          /std/std49a/std49a_d0a.do
```

### 9.2 핵심 전환 포인트

| 항목                  | AS-IS                              | TO-BE                                          |
|-----------------------|------------------------------------|-------------------------------------------------|
| 시간 저장 형식        | VARCHAR(4) HHmm                    | 동일하게 유지 (DB: HHmm, 화면: HH:mm)         |
| 탭 분리               | TabControl (ASSY/MC)               | jQuery 탭 또는 easyui-tabs                     |
| 비가동명 드롭다운     | LookUpEdit → STD49A_IDLE           | select/combobox → 비가동 코드 API 호출         |
| 시간 중복 체크        | BR에서 QUERY2 + 4가지 조건 비교    | Service 레이어에서 동일 로직 구현              |
| UPSERT 패턴           | SER → 존재 여부 → INS/UPD          | MyBatis에서 동일 패턴 (SELECT COUNT → INSERT/UPDATE) |
| 에러 핸들링           | BizException (100001/100002/100009)| 커스텀 예외 또는 결과 코드 반환                |
| 자동채번              | UTILITY_GET_SERIALNO(IDT,YYYYMMDD) | TSYS_SERIAL 테이블 기반 시퀀스 생성            |
| 공장구분              | 3603(조립), 3605(가공) 하드코딩     | 공통코드 또는 설정값으로 관리 권장             |

### 9.3 MySQL 전환 시 주의사항

- `GETDATE()` → `NOW()`
- `CONVERT(nvarchar(8), GETDATE(), 112)` → `DATE_FORMAT(NOW(), '%Y%m%d')`
- `DATEDIFF(MINUTE, START_TIME, END_TIME)` → `TIMESTAMPDIFF(MINUTE, START_TIME, END_TIME)`
- `ISNULL(A.END_TIME, GETDATE())` → `IFNULL(A.END_TIME, NOW())`
