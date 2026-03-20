# MES 사용자 시스템 통합 변경 내역

## 개요

**목적**: sys_user를 단일 사용자 테이블로 사용하고 LSBAS 권한 체계를 유지하면서 MES(TSTD_EMPLOYEE) 데이터 통합

**수행일**: 2026-02-03 ~ 2026-02-11

---

## 1. 데이터베이스 변경

### 1.1 sys_user 테이블 컬럼 추가 (6개)

| 컬럼명 | 타입 | 기본값 | 설명 | 위치 |
|--------|------|--------|------|------|
| PLT_CODE | VARCHAR(3) | '100' | 플랜트코드 | SYS_ID 다음 |
| ORG_CODE | VARCHAR(20) | NULL | 조직코드 (TSTD_ORG 참조) | DEPT_NAME 다음 |
| POSITION | VARCHAR(20) | NULL | 직위 | ORG_CODE 다음 |
| IS_SYSTEM | TINYINT | 0 | 시스템관리자 (0/1) | POSITION 다음 |
| LOCK_YN | CHAR(1) | 'N' | 계정잠금여부 | LOGIN_FAIL_CNT 다음 |
| LANG | VARCHAR(5) | 'ko' | 언어설정 | LOCK_YN 다음 |

**스크립트**: `sql/migration/01_sys_user_alter.sql`

### 1.2 인덱스 추가

| 인덱스명 | 컬럼 | 용도 |
|----------|------|------|
| idx_sys_user_plt_code | (SYS_ID, PLT_CODE) | 플랜트별 조회 최적화 |
| idx_sys_user_org_code | (SYS_ID, ORG_CODE) | 조직별 조회 최적화 |

### 1.3 데이터 마이그레이션

| 소스 | 타겟 | 건수 | 비고 |
|------|------|------|------|
| TSYS_USERGRP | sys_grup | 23 | MES 사용자 그룹 |
| TSTD_EMPLOYEE | sys_user | 496 | 활성 사용자 (DATA_FLAG=0) |
| TSTD_EMPLOYEE.USRGRP_CODE | sys_ugrp | 494 | 사용자-그룹 매핑 |

**스크립트**: `sql/migration/02_data_migration.sql`

### 1.4 비밀번호 암호화

MES 사용자 비밀번호를 LSBAS 방식(AES)으로 변환:

```sql
UPDATE sys_user
SET USER_PWD = HEX(AES_ENCRYPT(USER_ID, USER_PWD))
WHERE USER_TYPE = 'MES' AND REGI_ID = 'MIGRATION';
```

---

## 2. 프로시저 변경

**파일**: `sql/sp_user_procedures.sql`

### 2.1 sp_user_select

**변경 내용**:
- MES 컬럼 반환 추가 (pltCode, orgCode, position, isSystem, lockYn, lang)
- 그룹 정보(grupId, grupNm) 서브쿼리로 조회 (다대다 관계 대응)

**변경 전**:
```sql
-- 그룹 정보 없음
FROM SYS_USER A
WHERE A.SYS_ID = p_sys_id AND A.USER_ID = p_user_id
```

**변경 후**:
```sql
SELECT
    ...
    IFNULL(A.PLT_CODE, '100') AS pltCode,
    A.ORG_CODE AS orgCode,
    A.POSITION AS position,
    IFNULL(A.IS_SYSTEM, 0) AS isSystem,
    IFNULL(A.LOCK_YN, 'N') AS lockYn,
    IFNULL(A.LANG, 'ko') AS lang,
    (SELECT GROUP_ID FROM SYS_UGRP WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID LIMIT 1) AS grupId,
    (SELECT G.GROUP_NAME FROM SYS_UGRP UG
     JOIN SYS_GRUP G ON UG.SYS_ID = G.SYS_ID AND UG.GROUP_ID = G.GROUP_ID
     WHERE UG.SYS_ID = A.SYS_ID AND UG.USER_ID = A.USER_ID LIMIT 1) AS grupNm
FROM SYS_USER A
WHERE A.SYS_ID = p_sys_id AND A.USER_ID = p_user_id
```

**성능**: 2.4ms 이내 (PK 인덱스 사용)

### 2.2 sp_user_insert

**변경 내용**: MES 컬럼 파라미터 추가 (하위 호환성 유지 - NULL 허용)

추가 파라미터:
- p_plt_code
- p_org_code
- p_position
- p_is_system
- p_lang

### 2.3 sp_user_update

**변경 내용**: sp_user_insert와 동일

### 2.4 sp_user_update_failure

**변경 내용**: 5회 실패 시 계정 잠금 (LOCK_YN = 'Y')

```sql
UPDATE sys_user
SET LOCK_YN = 'Y'
WHERE SYS_ID = p_sys_id AND USER_ID = p_user_id
AND LOGIN_FAIL_CNT >= 5;
```

### 2.5 sp_user_update_success

**변경 내용**: 로그인 성공 시 잠금 해제 (LOCK_YN = 'N')

### 2.6 sp_user_get_group

**변경 내용**: 컬럼명 수정 (GRUP_ID → GROUP_ID)

---

## 3. Java 파일 변경

### 3.1 User.java

**경로**: `src/main/java/com/wsc/common/model/User.java`

**추가 필드**:
```java
private String pltCode;    // 플랜트코드
private String orgCode;    // 조직코드
private String position;   // 직위
private int isSystem;      // 시스템관리자 (0/1)
private String lockYn;     // 계정잠금여부
private String lang;       // 언어설정
private String grupId;     // 그룹 ID (조인)
private String grupNm;     // 그룹명 (조인)
```

### 3.2 ParamsMap.java

**경로**: `src/main/java/com/wsc/framework/model/ParamsMap.java`

**추가 상수**:
```java
public static final String GS_PLT_CODE = "gsPltCode";
public static final String GS_ORG_CODE = "gsOrgCode";
public static final String GS_GRUP_ID = "gsGrupId";
public static final String GS_GRUP_NM = "gsGrupNm";
public static final String GS_IS_SYSTEM = "gsIsSystem";
public static final String GS_POSITION = "gsPosition";
```

### 3.3 BaseController.java

**경로**: `src/main/java/com/wsc/framework/base/BaseController.java`

**변경 메서드**: `addUserParameter()`

**추가 파라미터**:
```java
params.put(ParamsMap.GS_PLT_CODE, user.getPltCode());
params.put(ParamsMap.GS_ORG_CODE, user.getOrgCode());
params.put(ParamsMap.GS_GRUP_ID, user.getGrupId());
params.put(ParamsMap.GS_GRUP_NM, user.getGrupNm());
params.put(ParamsMap.GS_IS_SYSTEM, user.getIsSystem());
params.put(ParamsMap.GS_POSITION, user.getPosition());
```

---

## 4. JSP 파일 변경 (Phase 1)

### 4.1 gconsts 추가 상수

**대상 파일**:
- `src/main/webapp/WEB-INF/views/include/common.jsp`
- `src/main/webapp/WEB-INF/views/include/popup/ndm_common.jsp`
- `src/main/webapp/WEB-INF/views/include/popup/promo_common.jsp`

**추가 상수**:
```javascript
var gconsts = {
    // 기존 상수...

    // MES 통합 상수 추가
    PLT_CODE:   '${user.pltCode}',   // 플랜트코드
    USER_ID:    '${user.userId}',    // 사용자 ID
    USER_NAME:  '${user.userName}',  // 사용자명
    USER_TYPE:  '${user.userType}',  // 사용자유형
    DEPT_CODE:  '${user.deptCode}',  // 부서코드
    DEPT_NAME:  '${user.deptName}',  // 부서명
    ORG_CODE:   '${user.orgCode}',   // 조직코드
    GRUP_ID:    '${user.grupId}',    // 그룹 ID
    GRUP_NM:    '${user.grupNm}',    // 그룹명
    IS_SYSTEM:  ${user.isSystem},    // 시스템관리자
    POSITION:   '${user.position}',  // 직위
    LANG:       '${user.lang}'       // 언어설정
};
```

**버전**: 260203A

---

## 5. MES 전용 컬럼 추가 이관 (Phase 5, 2026-02-11)

### 5.1 배경

Phase 1(01_sys_user_alter.sql)에서 sys_user에 6개 공통 컬럼만 추가하였으나, TSTD_EMPLOYEE의 MES 전용 컬럼 15개가 미이관 상태였음. SAP 작업장코드(IF_MC_CODE), RFID, 퇴사정보 등 MES 업무에 필요한 컬럼을 추가 이관.

### 5.2 추가 컬럼 (15개)

모든 컬럼의 COMMENT에 `[MES이관]` 접두어를 붙여 이관 컬럼을 식별 가능하게 함.

| # | 컬럼명 | 타입 | 기본값 | 설명 | 위치 |
|---|--------|------|--------|------|------|
| 1 | EMP_TYPE | VARCHAR(20) | NULL | 사원유형 | POSITION 다음 |
| 2 | EMP_SEQ | INT | NULL | 정렬순서 | EMP_TYPE 다음 |
| 3 | CPROC_CODE | VARCHAR(20) | NULL | 원가공정코드 | EMP_SEQ 다음 |
| 4 | IF_EMP_CODE | VARCHAR(50) | NULL | SAP 사원코드 | CPROC_CODE 다음 |
| 5 | IF_MC_CODE | VARCHAR(20) | NULL | SAP 작업장코드 (LSE_MACHINE 참조) | IF_EMP_CODE 다음 |
| 6 | MAIN_MC_CODE | VARCHAR(20) | NULL | 주담당설비코드 (LSE_MACHINE 참조) | IF_MC_CODE 다음 |
| 7 | INS_DIRECTION | INT | NULL | 지시방향 | MAIN_MC_CODE 다음 |
| 8 | RFID_NO | VARCHAR(50) | NULL | RFID 번호 | INS_DIRECTION 다음 |
| 9 | FIRE_FLAG | VARCHAR(1) | NULL | 퇴사여부 | RFID_NO 다음 |
| 10 | FIRE_DATE | DATETIME | NULL | 퇴사일 | FIRE_FLAG 다음 |
| 11 | EMP_GUBUN | VARCHAR(20) | NULL | 사원구분1 | FIRE_DATE 다음 |
| 12 | EMP_GUBUN2 | VARCHAR(20) | NULL | 사원구분2 | EMP_GUBUN 다음 |
| 13 | IS_VND | TINYINT | 0 | 외주사여부 (0/1) | EMP_GUBUN2 다음 |
| 14 | EMP_VND | VARCHAR(20) | NULL | 외주사코드 | IS_VND 다음 |
| 15 | DEL_REASON | VARCHAR(200) | NULL | 삭제사유 | EMP_VND 다음 |

### 5.3 데이터 이관

```sql
UPDATE sys_user U
INNER JOIN TSTD_EMPLOYEE E
    ON U.PLT_CODE = E.PLT_CODE AND U.USER_ID = E.EMP_CODE
SET
    U.EMP_TYPE = E.EMP_TYPE, U.EMP_SEQ = E.EMP_SEQ,
    U.CPROC_CODE = E.CPROC_CODE, U.IF_EMP_CODE = E.IF_EMP_CODE,
    U.IF_MC_CODE = E.IF_MC_CODE, U.MAIN_MC_CODE = E.MAIN_MC_CODE,
    U.INS_DIRECTION = E.INS_DIRECTION, U.RFID_NO = E.RFID_NO,
    U.FIRE_FLAG = E.FIRE_FLAG, U.FIRE_DATE = E.FIRE_DATE,
    U.EMP_GUBUN = E.EMP_GUBUN, U.EMP_GUBUN2 = E.EMP_GUBUN2,
    U.IS_VND = IFNULL(E.IS_VND, 0), U.EMP_VND = E.EMP_VND,
    U.DEL_REASON = E.DEL_REASON,
    U.CHNG_ID = 'MES_MIG_05', U.CHNG_DATE = NOW()
WHERE U.SYS_ID = 'IMMES' AND U.USER_TYPE = 'MES';
```

### 5.4 실행 결과

| 환경 | MES 사용자 수 | SAP 작업장 보유 | SAP 사원코드 보유 | 주담당설비 보유 |
|------|-------------|----------------|------------------|---------------|
| 운영 DB (172.30.1.29:3306) | 497 | 23 | 23 | 23 |
| 로컬 DB (localhost:3307) | 496 | 23 | 23 | 23 |

### 5.5 이관 컬럼 식별 방법

```sql
-- COMMENT에 [MES이관] 접두어가 있는 컬럼 조회
SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_DEFAULT, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'sys_user'
  AND COLUMN_COMMENT LIKE '%[MES이관]%'
ORDER BY ORDINAL_POSITION;
```

**스크립트**: `sql/migration/05_sys_user_mes_columns.sql`

---

## 5-1. MENU_TYPE 패치 (2026-02-04 추가)

### 문제 현상

MES 사용자 로그인 후 메뉴가 표시되지 않음

### 원인 분석

1. 마이그레이션 스크립트에서 `MENU_TYPE` 컬럼 미설정
2. `SP_SEARCH_AUTHORIZED_MENU` 프로시저 동작:
   - `MENU_TYPE`이 NULL/빈값 → `MENU_DIR LIKE '%Z%'` 조건 적용
   - MES 메뉴는 `MENU_DIR='O,U'` → 'Z' 미포함으로 표시 안됨

### 해결책

MES 사용자의 `MENU_TYPE`을 'U'로 설정:

```sql
UPDATE sys_user
SET MENU_TYPE = 'U',
    CHNG_ID = 'MIGRATION',
    CHNG_DATE = NOW()
WHERE SYS_ID = 'IMMES'
  AND USER_TYPE = 'MES'
  AND (MENU_TYPE IS NULL OR MENU_TYPE = '');
```

### 패치 스크립트

`sql/migration/03_fix_mes_menu_type.sql`

---

## 6. 마이그레이션 실행 순서

```bash
# 1단계: sys_user 테이블 확장 (6개 공통 컬럼)
mysql -u lstaadm -p immes < sql/migration/01_sys_user_alter.sql

# 2단계: 프로시저 업데이트
mysql -u lstaadm -p immes < sql/sp_user_procedures.sql

# 3단계: 데이터 마이그레이션 (TSTD_EMPLOYEE → sys_user 기본 데이터)
mysql -u lstaadm -p immes < sql/migration/02_data_migration.sql

# 4단계: 비밀번호 암호화 (02_data_migration.sql에 포함되지 않은 경우)
UPDATE sys_user
SET USER_PWD = HEX(AES_ENCRYPT(USER_ID, USER_PWD))
WHERE USER_TYPE = 'MES' AND REGI_ID = 'MIGRATION';

# 5단계: MENU_TYPE 패치 (기존 마이그레이션 환경만 해당)
mysql -u lstaadm -p immes < sql/migration/03_fix_mes_menu_type.sql

# 6단계: MES 전용 컬럼 추가 이관 (15개 컬럼 + 데이터)
mysql -u lstaadm -p immes < sql/migration/05_sys_user_mes_columns.sql
```

---

## 7. 검증 체크리스트

### 데이터베이스
- [x] sys_user 공통 컬럼 추가 완료 (6개, Phase 1)
- [x] 기존 sys_user 데이터 보존 확인
- [x] TSTD_EMPLOYEE → sys_user 이관 완료 (496건)
- [x] sys_grup에 MES 그룹 추가 (23건)
- [x] sys_ugrp에 사용자-그룹 매핑 완료 (494건)
- [x] 비밀번호 AES 암호화 완료
- [x] MES 사용자 MENU_TYPE='U' 설정 완료 (2026-02-04)
- [x] sys_user MES 전용 컬럼 추가 완료 (15개, Phase 5, 2026-02-11)
- [x] MES 전용 컬럼 데이터 이관 완료 (운영/로컬 DB 모두)

### 로그인
- [x] 기존 LSBAS 사용자 로그인 성공
- [x] MES 사원코드로 로그인 성공
- [x] sp_user_select 단일 행 반환 확인
- [x] 성능 확인 (2.4ms 이내)

### 프론트엔드
- [x] gconsts.PLT_CODE 정상 출력
- [x] gconsts.GRUP_ID 정상 출력
- [x] gconsts.IS_SYSTEM 정상 출력

### 메뉴 표시 (2026-02-04 추가)
- [x] MES 사용자 로그인 후 메뉴 표시
- [x] SP_SEARCH_AUTHORIZED_MENU에서 MENU_TYPE='U' 적용

---

## 8. 롤백 절차

### 데이터 롤백
```sql
-- MES 마이그레이션 데이터 삭제
DELETE FROM sys_ugrp WHERE SYS_ID = 'IMMES' AND REGI_ID = 'MIGRATION';
DELETE FROM sys_user WHERE SYS_ID = 'IMMES' AND USER_TYPE = 'MES' AND REGI_ID = 'MIGRATION';
DELETE FROM sys_grup WHERE SYS_ID = 'IMMES' AND REGI_ID = 'MIGRATION';
```

### Phase 1 컬럼 롤백 (공통 6개)
```sql
ALTER TABLE sys_user DROP COLUMN PLT_CODE;
ALTER TABLE sys_user DROP COLUMN ORG_CODE;
ALTER TABLE sys_user DROP COLUMN POSITION;
ALTER TABLE sys_user DROP COLUMN IS_SYSTEM;
ALTER TABLE sys_user DROP COLUMN LOCK_YN;
ALTER TABLE sys_user DROP COLUMN LANG;
```

### Phase 5 컬럼 롤백 (MES 전용 15개)
```sql
ALTER TABLE sys_user DROP COLUMN EMP_TYPE;
ALTER TABLE sys_user DROP COLUMN EMP_SEQ;
ALTER TABLE sys_user DROP COLUMN CPROC_CODE;
ALTER TABLE sys_user DROP COLUMN IF_EMP_CODE;
ALTER TABLE sys_user DROP COLUMN IF_MC_CODE;
ALTER TABLE sys_user DROP COLUMN MAIN_MC_CODE;
ALTER TABLE sys_user DROP COLUMN INS_DIRECTION;
ALTER TABLE sys_user DROP COLUMN RFID_NO;
ALTER TABLE sys_user DROP COLUMN FIRE_FLAG;
ALTER TABLE sys_user DROP COLUMN FIRE_DATE;
ALTER TABLE sys_user DROP COLUMN EMP_GUBUN;
ALTER TABLE sys_user DROP COLUMN EMP_GUBUN2;
ALTER TABLE sys_user DROP COLUMN IS_VND;
ALTER TABLE sys_user DROP COLUMN EMP_VND;
ALTER TABLE sys_user DROP COLUMN DEL_REASON;
```

### 코드 롤백
```bash
svn revert -R .
```

---

## 9. 관련 파일 목록

```
sql/
├── migration/
│   ├── 01_sys_user_alter.sql              # Phase 1: 테이블 공통 컬럼 추가 (6개)
│   ├── 02_data_migration.sql              # Phase 2: 데이터 이관 (MENU_TYPE 포함)
│   ├── 03_fix_mes_menu_type.sql           # Phase 2-1: MENU_TYPE 패치 (기존 환경용)
│   ├── 03_sp_user_procedures_update.sql   # Phase 3: 프로시저 업데이트
│   ├── 04_add_menu_type_code.sql          # Phase 4: 메뉴 타입 코드 관리
│   ├── 05_sys_user_mes_columns.sql        # Phase 5: MES 전용 컬럼 추가 (15개)
│   ├── migrate_to_sys_code.sql            # 코드 관리 마이그레이션
│   └── README.md                          # 마이그레이션 가이드
└── sp_user_procedures.sql                 # 프로시저 (MES 컬럼 반영)

src/main/java/com/wsc/
├── common/model/User.java         # MES 필드 추가
├── framework/model/ParamsMap.java # MES 상수 추가
└── framework/base/BaseController.java # MES 파라미터 추가

src/main/webapp/WEB-INF/views/include/
├── common.jsp                     # gconsts MES 상수 추가
└── popup/
    ├── ndm_common.jsp             # gconsts MES 상수 추가
    └── promo_common.jsp           # gconsts MES 상수 추가

doc/
├── DB_MIGRATION_RESULT.md         # 마이그레이션 결과
└── MES_USER_INTEGRATION.md        # 본 문서
```
