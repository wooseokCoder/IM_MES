-- ============================================================
-- TSHP_IDLETIME QUERY 프로시저 (POP 모듈)
-- 생성일: 2026-03-04
-- 대상 테이블: TSHP_IDLETIME (비가동 실적)
-- 원본: ProActive TSHP_IDLETIME_QUERY.cs - TSHP_IDLETIME_QUERY2
-- 화면: POP32A (비가동 현황 - 조립)
-- ============================================================
-- 명명 규칙: sp_imes_tshp_idletime_query[번호]
-- ============================================================
-- ⚠️ 주의: 이 스크립트 실행 전에 반드시 아래 명령어를 먼저 실행할 것
--   SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
-- (SP 파라미터가 DB 기본 collation이 아닌 테이블 collation과
--  일치하도록 세션 collation을 맞추기 위함)
-- ============================================================


DELIMITER //

-- ============================================================
-- sp_imes_tshp_idletime_query2: 비가동 현황 목록 조회
-- 원본: TSHP_IDLETIME_QUERY.TSHP_IDLETIME_QUERY2()
-- 용도: POP32A 메인 그리드 조회 (POP32A_SER 서비스)
-- JOIN: TSHP_IDLETIME IL
--       ↔ LSE_MACHINE M (설비명, 설비그룹 필터)
--       ↔ SYS_USER EMP (작업자명)
--       ↔ TSTD_IDLECODE IC (비가동코드명)
--       ↔ SYS_USER REG (등록자명)
-- 파라미터:
--   p_plt_code    - 공장코드
--   p_s_idle_date - 비가동 시작일 (yyyyMMdd)
--   p_e_idle_date - 비가동 종료일 (yyyyMMdd)
--   p_mc_group    - 설비그룹 (AS-IS: PLANTS 값 복사)
--   p_data_flag   - 데이터 상태 (0=활성, 2=삭제)
-- 검색조건:
--   AS-IS 동일: START_TIME/END_TIME DATE_FORMAT BETWEEN (yyyyMMdd)
-- 정렬: REG_DATE 내림차순 (최신 등록 우선)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_query2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_query2(
    IN p_plt_code       VARCHAR(10),    /* PLT_CODE (기본) */
    IN p_idle_id        VARCHAR(20),    /* IDLE_ID (단건 조회) */
    IN p_mc_code        VARCHAR(200),   /* MC_CODE (단일 또는 콤마구분, AS-IS: MC_CODE_IN) */
    IN p_emp_code       VARCHAR(20),    /* EMP_CODE (작업자) */
    IN p_data_flag      VARCHAR(1),     /* DATA_FLAG (0=활성, 2=삭제) */
    IN p_s_idle_date    VARCHAR(8),     /* S_IDLE_DATE (비가동시작일 yyyyMMdd) */
    IN p_e_idle_date    VARCHAR(8),     /* E_IDLE_DATE (비가동종료일 yyyyMMdd) */
    IN p_s_work_date    VARCHAR(8),     /* S_WORK_DATE (작업시작일 yyyyMMdd) */
    IN p_e_work_date    VARCHAR(8),     /* E_WORK_DATE (작업종료일 yyyyMMdd) */
    IN p_idle_state     VARCHAR(1),     /* IDLE_STATE (비가동상태) */
    IN p_mc_group       VARCHAR(10)     /* MC_GROUP (설비그룹) */
)
BEGIN
    SELECT
        IL.IDLE_ID AS idleId,
        IL.PLT_CODE AS pltCode,
        IL.WORK_DATE AS workDate,
        IL.MC_CODE AS mcCode,
        M.MC_NAME AS mcName,
        IL.EMP_CODE AS empCode,
        EMP.USER_NAME AS empName,
        DATE_FORMAT(IL.START_TIME, '%Y-%m-%d %H:%i:%s') AS startTime,
        DATE_FORMAT(IL.END_TIME, '%Y-%m-%d %H:%i:%s') AS endTime,
        IL.IDLE_STATE AS idleState,
        IL.IDLE_CODE AS idleCode,
        IC.IDLE_NAME AS idleName,
        IL.IDLE_TIME AS idleTime,
        IL.SCOMMENT AS scomment,
        IC.SAP_CODE AS sapCode,
        IL.WO_NO AS woNo,
        REG.USER_NAME AS regEmpName,
        IF(IL.IF_FLAG = '2', '1', IL.IF_FLAG) AS ifFlag,
        IL.MCT_SCOMMENT AS mctScomment,
        IL.MCT_SCOMMENT_RESULT AS mctScommentResult
    FROM TSHP_IDLETIME IL
    LEFT JOIN LSE_MACHINE M
        ON IL.PLT_CODE = M.PLT_CODE
        AND IL.MC_CODE = M.MC_CODE
    LEFT JOIN SYS_USER EMP
        ON IL.PLT_CODE = EMP.PLT_CODE
        AND IL.EMP_CODE = EMP.USER_ID
    LEFT JOIN TSTD_IDLECODE IC
        ON IL.PLT_CODE = IC.PLT_CODE
        AND IL.IDLE_CODE = IC.SCODE
    LEFT JOIN SYS_USER REG
        ON IL.PLT_CODE = REG.PLT_CODE
        AND IL.REG_EMP = REG.USER_ID
    WHERE IL.PLT_CODE = p_plt_code
      /* AS-IS GetWhere: IDLE_ID */
      AND (p_idle_id IS NULL OR p_idle_id = '' OR IL.IDLE_ID = p_idle_id)
      /* AS-IS GetWhere: MC_CODE (단일=등호, 콤마구분=FIND_IN_SET) */
      AND (p_mc_code IS NULL OR p_mc_code = '' OR IL.MC_CODE = p_mc_code OR FIND_IN_SET(IL.MC_CODE, p_mc_code) > 0)
      /* AS-IS GetWhere: EMP_CODE */
      AND (p_emp_code IS NULL OR p_emp_code = '' OR IL.EMP_CODE = p_emp_code)
      /* AS-IS GetWhere: DATA_FLAG */
      AND (p_data_flag IS NULL OR p_data_flag = '' OR IL.DATA_FLAG = p_data_flag)
      /* AS-IS GetWhere: S_IDLE_DATE, E_IDLE_DATE */
      AND (p_s_idle_date IS NULL OR p_s_idle_date = ''
           OR DATE_FORMAT(IL.START_TIME, '%Y%m%d') BETWEEN p_s_idle_date AND p_e_idle_date
           OR DATE_FORMAT(IL.END_TIME, '%Y%m%d') BETWEEN p_s_idle_date AND p_e_idle_date)
      /* AS-IS GetWhere: S_WORK_DATE, E_WORK_DATE */
      AND (p_s_work_date IS NULL OR p_s_work_date = '' OR IL.WORK_DATE BETWEEN p_s_work_date AND p_e_work_date)
      /* AS-IS GetWhere: IDLE_STATE */
      AND (p_idle_state IS NULL OR p_idle_state = '' OR IL.IDLE_STATE = p_idle_state)
      /* AS-IS GetWhere: MC_GROUP */
      AND (p_mc_group IS NULL OR p_mc_group = '' OR M.MC_GROUP = p_mc_group)
    ORDER BY IL.START_TIME DESC;
END//

-- ============================================================
-- sp_imes_tshp_idletime_query7: 진행중 비가동 조회
-- 원본: TSHP_IDLETIME_QUERY.TSHP_IDLETIME_QUERY7()
-- 용도: ORD16A 완료처리 시 진행중인 비가동 레코드 조회
--       → 완료처리 전 진행중 비가동을 종료 처리하기 위해 사용
-- 파라미터:
--   p_plt_code   - 공장코드
--   p_wo_no      - 작업지시번호
--   p_idle_state - 비가동상태 ('1'=진행중)
-- 정렬: 시작시간 역순 (최신 비가동 우선)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_query7//

CREATE PROCEDURE sp_imes_tshp_idletime_query7(
    IN p_plt_code   VARCHAR(20),   /* 공장코드 */
    IN p_wo_no      VARCHAR(20),   /* 작업지시번호 */
    IN p_idle_state VARCHAR(5)     /* 비가동상태 ('1'=진행중) */
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,       /* 공장코드 */
        IDLE_ID  AS idleId         /* 비가동ID (PK) */
    FROM TSHP_IDLETIME
    WHERE PLT_CODE = p_plt_code
      AND WO_NO = p_wo_no
      AND IDLE_STATE = p_idle_state
    ORDER BY START_TIME DESC;      /* 최신 비가동 우선 */
END//

-- ============================================================
-- sp_imes_tshp_idletime_query2_1: 비가동 조회
-- 원본: TSHP_IDLETIME_QUERY.TSHP_IDLETIME_QUERY2()
-- 용도: POP30B 설비 기준 비가동 현황 조회
-- JOIN: LSE_MACHINE M (설비명, 설비그룹)
--       SYS_USER EMP (작업자명)
--       TSTD_IDLECODE IC (비가동코드명, SAP코드)
--       SYS_USER REG (등록자명)
-- WHERE: AS-IS GetWhere 9개 전체 반영
--   1. PLT_CODE (기본)
--   2. IDLE_ID (단건 조회)
--   3. MC_CODE (단일/콤마구분)
--   4. EMP_CODE (작업자)
--   5. DATA_FLAG (데이터상태)
--   6. S_IDLE_DATE, E_IDLE_DATE (비가동일 범위 - START_TIME/END_TIME)
--   7. S_WORK_DATE, E_WORK_DATE (작업일 범위)
--   8. IDLE_STATE (비가동상태)
--   9. MC_GROUP (설비그룹)
-- 추가일: 2026-03-18
-- 수정일: 2026-03-19 (AS-IS WHERE 전체 반영, SYS_USER 적용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_query2_1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_query2_1(
    IN p_plt_code       VARCHAR(10),    /* PLT_CODE (기본) */
    IN p_idle_id        VARCHAR(20),    /* IDLE_ID (단건 조회) */
    IN p_mc_code        VARCHAR(200),   /* MC_CODE (단일 또는 콤마구분) */
    IN p_emp_code       VARCHAR(20),    /* EMP_CODE (작업자) */
    IN p_data_flag      VARCHAR(1),     /* DATA_FLAG (0=활성, 2=삭제) */
    IN p_s_idle_date    VARCHAR(8),     /* S_IDLE_DATE (비가동시작일 yyyyMMdd) */
    IN p_e_idle_date    VARCHAR(8),     /* E_IDLE_DATE (비가동종료일 yyyyMMdd) */
    IN p_s_work_date    VARCHAR(8),     /* S_WORK_DATE (작업시작일 yyyyMMdd) */
    IN p_e_work_date    VARCHAR(8),     /* E_WORK_DATE (작업종료일 yyyyMMdd) */
    IN p_idle_state     VARCHAR(1),     /* IDLE_STATE (비가동상태) */
    IN p_mc_group       VARCHAR(10)     /* MC_GROUP (설비그룹) */
)
BEGIN
    SELECT
        IL.IDLE_ID AS idleId,
        IL.PLT_CODE AS pltCode,
        IL.WORK_DATE AS workDate,
        IL.MC_CODE AS mcCode,
        M.MC_NAME AS mcName,
        IL.EMP_CODE AS empCode,
        EMP.USER_NAME AS empName,
        DATE_FORMAT(IL.START_TIME, '%Y-%m-%d %H:%i:%s') AS startTime,
        DATE_FORMAT(IL.END_TIME, '%Y-%m-%d %H:%i:%s') AS endTime,
        IL.IDLE_STATE AS idleState,
        IL.IDLE_CODE AS idleCode,
        IC.IDLE_NAME AS idleName,
        IL.IDLE_TIME AS idleTime,
        IL.SCOMMENT AS scomment,
        IC.SAP_CODE AS sapCode,
        IL.WO_NO AS woNo,
        REG.USER_NAME AS regEmpName,
        IF(IL.IF_FLAG = '2', '1', IL.IF_FLAG) AS ifFlag,
        IL.MCT_SCOMMENT AS mctScomment,
        IL.MCT_SCOMMENT_RESULT AS mctScommentResult
    FROM TSHP_IDLETIME IL
    LEFT JOIN LSE_MACHINE M
        ON IL.PLT_CODE = M.PLT_CODE
        AND IL.MC_CODE = M.MC_CODE
    LEFT JOIN SYS_USER EMP
        ON IL.PLT_CODE = EMP.PLT_CODE
        AND IL.EMP_CODE = EMP.USER_ID
    LEFT JOIN TSTD_IDLECODE IC
        ON IL.PLT_CODE = IC.PLT_CODE
        AND IL.IDLE_CODE = IC.SCODE
    LEFT JOIN SYS_USER REG
        ON IL.PLT_CODE = REG.PLT_CODE
        AND IL.REG_EMP = REG.USER_ID
    WHERE IL.PLT_CODE = p_plt_code
      /* 2. IDLE_ID */
      AND (p_idle_id IS NULL OR p_idle_id = '' OR IL.IDLE_ID = p_idle_id)
      /* 3. MC_CODE (단일=등호, 콤마구분=FIND_IN_SET) */
      AND (p_mc_code IS NULL OR p_mc_code = '' OR IL.MC_CODE = p_mc_code OR FIND_IN_SET(IL.MC_CODE, p_mc_code) > 0)
      /* 4. EMP_CODE */
      AND (p_emp_code IS NULL OR p_emp_code = '' OR IL.EMP_CODE = p_emp_code)
      /* 5. DATA_FLAG */
      AND (p_data_flag IS NULL OR p_data_flag = '' OR IL.DATA_FLAG = p_data_flag)
      /* 6. S_IDLE_DATE, E_IDLE_DATE (START_TIME 또는 END_TIME이 범위 내) */
      AND (p_s_idle_date IS NULL OR p_s_idle_date = ''
           OR DATE_FORMAT(IL.START_TIME, '%Y%m%d') BETWEEN p_s_idle_date AND p_e_idle_date
           OR DATE_FORMAT(IL.END_TIME, '%Y%m%d') BETWEEN p_s_idle_date AND p_e_idle_date)
      /* 7. S_WORK_DATE, E_WORK_DATE */
      AND (p_s_work_date IS NULL OR p_s_work_date = '' OR IL.WORK_DATE BETWEEN p_s_work_date AND p_e_work_date)
      /* 8. IDLE_STATE */
      AND (p_idle_state IS NULL OR p_idle_state = '' OR IL.IDLE_STATE = p_idle_state)
      /* 9. MC_GROUP */
      AND (p_mc_group IS NULL OR p_mc_group = '' OR M.MC_GROUP = p_mc_group)
    ORDER BY IL.START_TIME DESC;
END//

DELIMITER ;
