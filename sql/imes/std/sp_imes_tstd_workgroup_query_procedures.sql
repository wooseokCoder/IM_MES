-- ============================================================
-- TSTD_WORKGROUP QUERY 프로시저
-- 생성일: 2026-02-10
-- 수정일: 2026-02-12 TSTD_EMPLOYEE → SYS_USER 전환
-- 대상 테이블: TSTD_WORKGROUP, TSTD_WORKGROUP_MC, TSTD_WORKGROUP_EMP
--              LSE_MACHINE, SYS_USER (JOIN)
-- 원본: ProActive TSTD_WORKGROUP_QUERY.cs, TSTD_WORKGROUP_MC_QUERY.cs,
--       TSTD_WORKGROUP_EMP_QUERY.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_workgroup[_mc|_emp]_query[번호]
--            sp_imes_lse_machine_query[번호]
--            sp_imes_sys_user_query[번호]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_workgroup_query1: 그룹 목록 (메인 그리드)
-- 원본: TSTD_WORKGROUP_QUERY.TSTD_WORKGROUP_QUERY1()
-- 용도: 메인 화면 그리드 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_query1//

CREATE PROCEDURE sp_imes_tstd_workgroup_query1(
    IN p_plt_code VARCHAR(10),
    IN p_group_like VARCHAR(100),
    IN p_data_flag INT
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        GROUP_NO AS groupNo,
        GROUP_NAME AS groupName,
        EMP_COUNT AS empCount,
        MC_COUNT AS mcCount,
        SCOMMENT AS scomment
    FROM TSTD_WORKGROUP
    WHERE PLT_CODE = p_plt_code
      AND DATA_FLAG = p_data_flag
      AND (p_group_like IS NULL OR p_group_like = ''
           OR GROUP_NAME LIKE CONCAT('%', p_group_like, '%'))
    ;
END//

-- ============================================================
-- sp_imes_tstd_workgroup_mc_query1: 그룹 소속 작업장 (JOIN LSE_MACHINE)
-- 원본: TSTD_WORKGROUP_MC_QUERY.TSTD_WORKGROUP_MC_QUERY1()
-- 용도: 그룹 상세 - 소속 작업장 목록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_mc_query1//

CREATE PROCEDURE sp_imes_tstd_workgroup_mc_query1(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_data_flag INT
)
BEGIN
    SELECT
        WM.MC_CODE AS mcCode,
        M.MC_NAME AS mcName,
        M.PROC_CODE AS procCode,
        WM.MC_SEQ AS mcSeq,
        M.SCOMMENT AS scomment
    FROM TSTD_WORKGROUP_MC WM
    LEFT JOIN LSE_MACHINE M ON WM.PLT_CODE = M.PLT_CODE AND WM.MC_CODE = M.MC_CODE
    WHERE WM.PLT_CODE = p_plt_code
      AND WM.GROUP_NO = p_group_no
      AND WM.DATA_FLAG = p_data_flag
    ;
END//

-- ============================================================
-- sp_imes_tstd_workgroup_emp_query1: 그룹 소속 작업자 (JOIN SYS_USER)
-- 원본: TSTD_WORKGROUP_EMP_QUERY.TSTD_WORKGROUP_EMP_QUERY1()
-- 용도: 그룹 상세 - 소속 작업자 목록
-- 변경: TSTD_EMPLOYEE → SYS_USER (MES_USER_INTEGRATION)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_emp_query1//

CREATE PROCEDURE sp_imes_tstd_workgroup_emp_query1(
    IN p_sys_id VARCHAR(20),
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_data_flag INT
)
BEGIN
    SELECT
        WE.EMP_CODE AS empCode,
        E.USER_NAME AS empName,
        WE.EMP_SEQ AS empSeq
    FROM TSTD_WORKGROUP_EMP WE
    LEFT JOIN SYS_USER E ON E.SYS_ID = p_sys_id AND WE.PLT_CODE = E.PLT_CODE AND WE.EMP_CODE = E.USER_ID
    WHERE WE.PLT_CODE = p_plt_code
      AND WE.GROUP_NO = p_group_no
      AND WE.DATA_FLAG = p_data_flag
    ;
END//

-- ============================================================
-- sp_imes_lse_machine_query8: 전체 작업장 목록 (다이얼로그용)
-- 원본: STD50A.STD50A_SER3() → LSE_MACHINE_QUERY8
-- AS-IS 조건: MC_GROUP='9999', DATA_FLAG=0
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_query8//

CREATE PROCEDURE sp_imes_lse_machine_query8(
    IN p_plt_code VARCHAR(10),
    IN p_mc_group VARCHAR(10),
    IN p_data_flag INT
)
BEGIN
    SELECT
        MC_CODE AS mcCode,
        MC_NAME AS mcName,
        PROC_CODE AS procCode,
        SCOMMENT AS scomment
    FROM LSE_MACHINE
    WHERE PLT_CODE = p_plt_code
      AND MC_GROUP = p_mc_group
      AND DATA_FLAG = p_data_flag
    ;
END//

-- ============================================================
-- sp_imes_sys_user_query9: 전체 작업자 목록 (다이얼로그용)
-- 원본: STD50A.STD50A_SER3() → TSTD_EMPLOYEE_QUERY9
-- AS-IS 조건: IS_ASSY=1 (TSTD_ORG JOIN), DATA_FLAG=0
-- 변경: TSTD_EMPLOYEE → SYS_USER (MES_USER_INTEGRATION)
--       DATA_FLAG=0 → USE_FLAG='Y', 프로시저명 변경
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_employee_query9//
DROP PROCEDURE IF EXISTS sp_imes_sys_user_query9//

CREATE PROCEDURE sp_imes_sys_user_query9(
    IN p_sys_id VARCHAR(20),
    IN p_plt_code VARCHAR(10),
    IN p_is_assy INT,
    IN p_data_flag INT
)
BEGIN
    SELECT
        E.USER_ID AS empCode,
        E.USER_NAME AS empName
    FROM SYS_USER E
    LEFT JOIN TSTD_ORG O ON E.PLT_CODE = O.PLT_CODE AND E.ORG_CODE = O.ORG_CODE
    WHERE E.SYS_ID = p_sys_id
      AND E.PLT_CODE = p_plt_code
      AND E.USER_TYPE = 'MES'
      AND E.USE_FLAG = IF(p_data_flag = 0, 'Y', 'N')
      AND O.IS_ASSY = p_is_assy
    ;
END//

DELIMITER ;

-- ============================================================
-- 실행 안내
-- ============================================================
-- 1. sp_imes_tstd_workgroup_procedures.sql 먼저 실행
-- 2. MySQL Workbench 또는 CLI에서 이 스크립트 실행
-- 3. 운영 DB에 적용 후 doc/PROCEDURE_SYNC_RULE.md에 기록
-- ============================================================
