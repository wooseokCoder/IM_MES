-- ============================================================
-- TSTD_ORG / sys_user QUERY 프로시저
-- 생성일: 2026-02-11
-- 대상 테이블: TSTD_ORG, sys_user, sys_ugrp, sys_grup, LSE_MACHINE
-- 원본: ProActive TSTD_ORG_QUERY.cs, TSTD_EMPLOYEE_QUERY.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_org_query[N] / sp_imes_sysuser_[용도]
-- ============================================================
-- TSTD_EMPLOYEE → sys_user 전환 적용
-- (MES_USER_INTEGRATION.md 기준)
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_org_query1: 부서 목록 조회 (단순)
-- 원본: TSTD_ORG_QUERY.TSTD_ORG_QUERY1()
-- 용도: 부서 선택 팝업/드롭다운 (acORG 컴포넌트 등)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_org_query1//

CREATE PROCEDURE sp_imes_tstd_org_query1(
    IN p_plt_code VARCHAR(20)
)
BEGIN
    SELECT
        O.PLT_CODE AS pltCode,
        O.ORG_CODE AS orgCode,
        O.ORG_NAME AS orgName,
        O.ORG_PARENT AS orgParent,
        O.COST_CENTER AS costCenter
    FROM TSTD_ORG O
    WHERE O.PLT_CODE = p_plt_code
      AND O.DATA_FLAG = 0
    ORDER BY O.ORG_SEQ, O.ORG_NAME;
END//

-- ============================================================
-- sp_imes_tstd_org_query2: 부서 트리 조회 (메인)
-- 원본: TSTD_ORG_QUERY.TSTD_ORG_QUERY2()
-- 용도: 부서 treegrid 데이터 (JOIN sys_user로 이름 조회)
-- 변환: TSTD_EMPLOYEE → sys_user
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_org_query2//

CREATE PROCEDURE sp_imes_tstd_org_query2(
    IN p_plt_code VARCHAR(20),
    IN p_data_flag INT,
    IN p_emp_type VARCHAR(20),
    IN p_emp_like VARCHAR(100)
)
BEGIN
    SELECT
        O.ORG_CODE AS orgCode,
        O.ORG_NAME AS orgName,
        O.ORG_PARENT AS orgParent,
        O.ORG_LEADER AS orgLeader,
        O.COST_CENTER AS costCenter,
        O.ORG_SEQ AS orgSeq,
        DATE_FORMAT(O.REG_DATE, '%Y-%m-%d') AS regDate,
        O.REG_EMP AS regEmp,
        DATE_FORMAT(O.MDFY_DATE, '%Y-%m-%d') AS mdfyDate,
        O.MDFY_EMP AS mdfyEmp,
        E.USER_NAME AS orgLeaderName,
        REG.USER_NAME AS regEmpName,
        MDFY.USER_NAME AS mdfyEmpName
    FROM TSTD_ORG O
    LEFT JOIN sys_user E    ON E.SYS_ID = 'IMMES' AND E.PLT_CODE = O.PLT_CODE AND E.USER_ID = O.ORG_LEADER
    LEFT JOIN sys_user REG  ON REG.SYS_ID = 'IMMES' AND REG.PLT_CODE = O.PLT_CODE AND REG.USER_ID = O.REG_EMP
    LEFT JOIN sys_user MDFY ON MDFY.SYS_ID = 'IMMES' AND MDFY.PLT_CODE = O.PLT_CODE AND MDFY.USER_ID = O.MDFY_EMP
    WHERE O.PLT_CODE = p_plt_code
      AND O.DATA_FLAG = p_data_flag
      -- EMP_TYPE 필터 (선택)
      AND (p_emp_type IS NULL OR p_emp_type = '' OR O.ORG_CODE IN (
          SELECT ORG_CODE FROM sys_user
          WHERE SYS_ID = 'IMMES' AND USER_TYPE = 'MES' AND USE_FLAG = 'Y'
            AND PLT_CODE = p_plt_code AND EMP_TYPE = p_emp_type
      ))
      -- EMP_LIKE 필터 (선택) — 사원코드/명 검색
      AND (p_emp_like IS NULL OR p_emp_like = '' OR O.ORG_CODE IN (
          SELECT ORG_CODE FROM sys_user
          WHERE SYS_ID = 'IMMES' AND USER_TYPE = 'MES' AND USE_FLAG = 'Y'
            AND PLT_CODE = p_plt_code
            AND (USER_ID LIKE CONCAT('%', p_emp_like, '%') OR USER_NAME LIKE CONCAT('%', p_emp_like, '%'))
      ))
    ORDER BY O.ORG_SEQ, O.ORG_NAME;
END//

-- ============================================================
-- sp_imes_sysuser_query1: 사원 목록 조회 (sys_user 기반)
-- 원본: TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY1()
-- 용도: 부서 선택 시 소속 사원 목록 (읽기전용)
-- 변환: TSTD_EMPLOYEE → sys_user, TSYS_USERGRP → sys_ugrp/sys_grup
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_sysuser_query1//

CREATE PROCEDURE sp_imes_sysuser_query1(
    IN p_plt_code VARCHAR(20),
    IN p_org_code VARCHAR(20),
    IN p_emp_like VARCHAR(100)
)
BEGIN
    SELECT
        U.PLT_CODE AS pltCode,
        U.USER_ID AS empCode,
        U.USER_NAME AS empName,
        U.EMP_TYPE AS empType,
        U.POSITION AS empTitle,
        U.EMP_SEQ AS empSeq,
        U.ORG_CODE AS orgCode,
        U.CPROC_CODE AS cprocCode,
        G.GROUP_ID AS usrgrpCode,
        U.USER_HP AS mobilePhone,
        U.USER_MAIL AS email,
        U.IS_SYSTEM AS isSystem,
        DATE_FORMAT(U.REGI_DATE, '%Y-%m-%d') AS regDate,
        U.REGI_ID AS regEmp,
        DATE_FORMAT(U.CHNG_DATE, '%Y-%m-%d') AS mdfyDate,
        U.CHNG_ID AS mdfyEmp,
        U.IS_VND AS isVnd,
        U.RFID_NO AS rfidNo,
        U.MAIN_MC_CODE AS mainMcCode,
        U.FIRE_FLAG AS fireFlag,
        DATE_FORMAT(U.FIRE_DATE, '%Y-%m-%d') AS fireDate,
        U.EMP_GUBUN AS empGubun,
        U.EMP_GUBUN2 AS empGubun2,
        U.IF_MC_CODE AS ifMcCode,
        O.ORG_NAME AS orgName,
        G.GROUP_NAME AS usrgrpName,
        M.MC_NAME AS mainMcName,
        IM.MC_NAME AS ifMcName
    FROM sys_user U
    LEFT JOIN TSTD_ORG O    ON U.PLT_CODE = O.PLT_CODE AND U.ORG_CODE = O.ORG_CODE
    LEFT JOIN sys_ugrp UG   ON UG.SYS_ID = U.SYS_ID AND UG.USER_ID = U.USER_ID
    LEFT JOIN sys_grup G     ON G.SYS_ID = UG.SYS_ID AND G.GROUP_ID = UG.GROUP_ID
    LEFT JOIN LSE_MACHINE M  ON U.PLT_CODE = M.PLT_CODE AND U.MAIN_MC_CODE = M.MC_CODE
    LEFT JOIN LSE_MACHINE IM ON U.PLT_CODE = IM.PLT_CODE AND U.IF_MC_CODE = IM.MC_CODE
    WHERE U.SYS_ID = 'IMMES' AND U.USER_TYPE = 'MES' AND U.USE_FLAG = 'Y'
      AND U.PLT_CODE = p_plt_code
      AND (p_org_code IS NULL OR p_org_code = '' OR U.ORG_CODE = p_org_code)
      AND (p_emp_like IS NULL OR p_emp_like = '' OR
           U.USER_ID LIKE CONCAT('%', p_emp_like, '%') OR U.USER_NAME LIKE CONCAT('%', p_emp_like, '%'))
    ORDER BY U.EMP_SEQ;
END//

-- ============================================================
-- sp_imes_sysuser_emp_count: 부서별 사원 수 확인
-- 용도: 부서 삭제 시 소속 사원 존재 여부 확인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_sysuser_emp_count//

CREATE PROCEDURE sp_imes_sysuser_emp_count(
    IN p_plt_code VARCHAR(20),
    IN p_org_code VARCHAR(20)
)
BEGIN
    SELECT COUNT(*) AS cnt
    FROM sys_user
    WHERE SYS_ID = 'IMMES' AND USER_TYPE = 'MES' AND USE_FLAG = 'Y'
      AND PLT_CODE = p_plt_code AND ORG_CODE = p_org_code;
END//

DELIMITER ;

-- ============================================================
-- 실행 안내
-- ============================================================
-- 1. MySQL Workbench 또는 CLI에서 이 스크립트 실행
-- 2. 운영 DB에 적용 후 doc/PROCEDURE_SYNC_RULE.md에 기록
-- ============================================================
