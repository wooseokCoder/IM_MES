-- ============================================================
-- TSTD_EMPLOYEE_QUERY 조회 프로시저
-- 생성일: 2026-03-05
-- 대상 테이블: SYS_USER (TSTD_EMPLOYEE 전환)
-- 원본: ProActive TSTD_EMPLOYEE_QUERY.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_employee_query[번호]
-- ============================================================
-- 변환 사항:
--   TSTD_EMPLOYEE → SYS_USER
--   TSTD_EMPLOYEE.EMP_CODE → SYS_USER.USER_ID
--   TSTD_EMPLOYEE.EMP_NAME → SYS_USER.USER_NAME
--   TSTD_EMPLOYEE.MOBILE_PHONE → SYS_USER.USER_HP
--   TSTD_EMPLOYEE.EMAIL → SYS_USER.USER_MAIL
--   TSTD_EMPLOYEE.REG_DATE → SYS_USER.REGI_DATE
--   TSTD_EMPLOYEE.REG_EMP → SYS_USER.REGI_ID
--   TSTD_EMPLOYEE.MDFY_DATE → SYS_USER.CHNG_DATE
--   TSTD_EMPLOYEE.MDFY_EMP → SYS_USER.CHNG_ID
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_employee_query1: 작업자 기본 조회
-- 원본: TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY1()
-- 변환: TSTD_EMPLOYEE → SYS_USER
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_employee_query1//

CREATE PROCEDURE sp_imes_tstd_employee_query1(
    IN p_plt_code    VARCHAR(3),
    IN p_emp_code    VARCHAR(50),
    IN p_emp_name    VARCHAR(100),
    IN p_org_code    VARCHAR(20),
    IN p_org_like    VARCHAR(100),
    IN p_usrgrp_code VARCHAR(20),
    IN p_acc_pwd     VARCHAR(100),
    IN p_avail_mc    VARCHAR(20),
    IN p_emp_like    VARCHAR(100),
    IN p_emp_type    VARCHAR(10),
    IN p_rfid_no     VARCHAR(50),
    IN p_data_flag   INT
)
BEGIN
    SELECT
        U.PLT_CODE           AS pltCode,
        U.USER_ID             AS empCode,
        U.USER_NAME           AS empName,
        U.EMP_TYPE            AS empType,
        U.POSITION            AS empTitle,
        U.EMP_SEQ             AS empSeq,
        U.ORG_CODE            AS orgCode,
        U.CPROC_CODE          AS cprocCode,
        UG.GROUP_ID           AS usrgrpCode,
        U.USER_HP             AS mobilePhone,
        U.USER_MAIL           AS email,
        U.USER_PWD            AS accPwd,
        IFNULL(U.IS_SYSTEM, 0) AS isSystem,
        DATE_FORMAT(U.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        U.REGI_ID             AS regEmp,
        DATE_FORMAT(U.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        U.CHNG_ID             AS mdfyEmp,
        U.USE_FLAG            AS dataFlag,
        NULL                  AS delDate,
        NULL                  AS delEmp,
        O.ORG_NAME            AS orgName,
        IFNULL(U.IS_VND, 0)   AS isVnd,
        G.USRGRP_NAME         AS usrgrpName,
        U.RFID_NO             AS rfidNo,
        U.MAIN_MC_CODE        AS mainMcCode,
        M.MC_NAME             AS mainMcName,
        U.FIRE_FLAG           AS fireFlag,
        DATE_FORMAT(U.FIRE_DATE, '%Y-%m-%d') AS fireDate,
        U.EMP_GUBUN           AS empGubun,
        U.EMP_GUBUN2          AS empGubun2,
        U.IF_MC_CODE          AS ifMcCode,
        IM.MC_NAME            AS ifMcName
    FROM sys_user U
    LEFT JOIN TSTD_ORG O
        ON U.PLT_CODE = O.PLT_CODE
        AND U.ORG_CODE = O.ORG_CODE
    LEFT JOIN sys_ugrp UG
        ON U.SYS_ID = UG.SYS_ID
        AND U.USER_ID = UG.USER_ID
    LEFT JOIN TSYS_USERGRP G
        ON U.PLT_CODE = G.PLT_CODE
        AND UG.GROUP_ID = G.USRGRP_CODE
    LEFT JOIN LSE_MACHINE M
        ON U.PLT_CODE = M.PLT_CODE
        AND U.MAIN_MC_CODE = M.MC_CODE
    LEFT JOIN LSE_MACHINE IM
        ON U.PLT_CODE = IM.PLT_CODE
        AND U.IF_MC_CODE = IM.MC_CODE
    WHERE U.PLT_CODE = p_plt_code
      AND (p_emp_code IS NULL OR p_emp_code = '' OR U.USER_ID = p_emp_code)
      AND (p_emp_name IS NULL OR p_emp_name = '' OR U.USER_NAME = p_emp_name)
      AND (p_org_code IS NULL OR p_org_code = '' OR U.ORG_CODE = p_org_code)
      AND (p_org_like IS NULL OR p_org_like = '' OR 
           U.ORG_CODE LIKE CONCAT('%', p_org_like, '%') OR 
           O.ORG_NAME LIKE CONCAT('%', p_org_like, '%'))
      AND (p_usrgrp_code IS NULL OR p_usrgrp_code = '' OR UG.GROUP_ID = p_usrgrp_code)
      AND (p_acc_pwd IS NULL OR p_acc_pwd = '' OR U.USER_PWD = p_acc_pwd)
      AND (p_avail_mc IS NULL OR p_avail_mc = '' OR 
           U.USER_ID IN (SELECT EMP_CODE FROM TSTD_MC_AVAILEMP WHERE MC_CODE = p_avail_mc))
      AND (p_emp_like IS NULL OR p_emp_like = '' OR 
           U.USER_ID LIKE CONCAT('%', p_emp_like, '%') OR 
           U.USER_NAME LIKE CONCAT('%', p_emp_like, '%'))
      AND (p_emp_type IS NULL OR p_emp_type = '' OR U.EMP_TYPE = p_emp_type)
      AND (p_rfid_no IS NULL OR p_rfid_no = '' OR U.RFID_NO = p_rfid_no)
      AND (p_data_flag IS NULL OR U.USE_FLAG = CASE WHEN p_data_flag = 0 THEN 'Y' ELSE 'N' END)
    ORDER BY U.EMP_SEQ;
END//

-- ============================================================
-- sp_imes_tstd_employee_query5: 작업자 조회 (등록자/수정자명 포함)
-- 원본: TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY5()
-- 변환: TSTD_EMPLOYEE → SYS_USER
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_employee_query5//

CREATE PROCEDURE sp_imes_tstd_employee_query5(
    IN p_plt_code    VARCHAR(3),
    IN p_emp_code    VARCHAR(50),
    IN p_emp_name    VARCHAR(100),
    IN p_org_code    VARCHAR(20),
    IN p_avail_mc    VARCHAR(20),
    IN p_emp_like    VARCHAR(100),
    IN p_data_flag   INT,
    IN p_is_system   INT,
    IN p_is_org      VARCHAR(1)
)
BEGIN
    SELECT
        U.PLT_CODE           AS pltCode,
        U.USER_ID             AS empCode,
        U.USER_NAME           AS empName,
        U.EMP_TYPE            AS empType,
        U.POSITION            AS empTitle,
        U.EMP_SEQ             AS empSeq,
        U.ORG_CODE            AS orgCode,
        O.ORG_NAME            AS orgName,
        O.ORG_SEQ             AS orgSeq,
        U.CPROC_CODE          AS cprocCode,
        UG.GROUP_ID           AS usrgrpCode,
        CM.UTC_NAME           AS cprocName,
        G.USRGRP_NAME         AS usrgrpName,
        IFNULL(G.IS_POP, 0)   AS isPop,
        U.USER_HP             AS mobilePhone,
        U.USER_MAIL           AS email,
        IFNULL(U.IS_SYSTEM, 0) AS isSystem,
        DATE_FORMAT(U.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        U.REGI_ID             AS regEmp,
        REG.USER_NAME         AS regEmpName,
        DATE_FORMAT(U.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        U.CHNG_ID             AS mdfyEmp,
        MDFY.USER_NAME        AS mdfyEmpName,
        IFNULL(U.IS_VND, 0)   AS isVnd,
        U.EMP_VND             AS empVnd,
        U.IF_EMP_CODE         AS ifEmpCode,
        U.INS_DIRECTION       AS insDirection,
        CASE WHEN (SELECT MAIN_EMP FROM LSE_MACHINE 
                   WHERE PLT_CODE = U.PLT_CODE 
                     AND MAIN_EMP = U.USER_ID 
                     AND MC_CODE = p_avail_mc) IS NULL 
             THEN '' 
             ELSE '1' 
        END AS isMainEmp
    FROM sys_user U
    LEFT JOIN TSTD_ORG O
        ON U.PLT_CODE = O.PLT_CODE
        AND U.ORG_CODE = O.ORG_CODE
    LEFT JOIN sys_ugrp UG
        ON U.SYS_ID = UG.SYS_ID
        AND U.USER_ID = UG.USER_ID
    LEFT JOIN TSYS_USERGRP G
        ON U.PLT_CODE = G.PLT_CODE
        AND UG.GROUP_ID = G.USRGRP_CODE
    LEFT JOIN TCST_UNIT_COST_MASTER CM
        ON U.PLT_CODE = CM.PLT_CODE
        AND U.CPROC_CODE = CM.UTC_CODE
    LEFT JOIN sys_user REG
        ON U.PLT_CODE = REG.PLT_CODE
        AND U.REGI_ID = REG.USER_ID
        AND REG.SYS_ID = 'IMMES'
    LEFT JOIN sys_user MDFY
        ON U.PLT_CODE = MDFY.PLT_CODE
        AND U.CHNG_ID = MDFY.USER_ID
        AND MDFY.SYS_ID = 'IMMES'
    WHERE U.PLT_CODE = p_plt_code
      AND (p_emp_code IS NULL OR p_emp_code = '' OR U.USER_ID = p_emp_code)
      AND (p_emp_name IS NULL OR p_emp_name = '' OR U.USER_NAME = p_emp_name)
      AND (p_org_code IS NULL OR p_org_code = '' OR U.ORG_CODE = p_org_code)
      AND (p_avail_mc IS NULL OR p_avail_mc = '' OR 
           U.USER_ID IN (SELECT EMP_CODE FROM TSTD_MC_AVAILEMP WHERE MC_CODE = p_avail_mc))
      AND (p_emp_like IS NULL OR p_emp_like = '' OR 
           U.USER_ID LIKE CONCAT('%', p_emp_like, '%') OR 
           U.USER_NAME LIKE CONCAT('%', p_emp_like, '%'))
      AND (p_data_flag IS NULL OR U.USE_FLAG = CASE WHEN p_data_flag = 0 THEN 'Y' ELSE 'N' END)
      AND (p_is_system IS NULL OR IFNULL(U.IS_SYSTEM, 0) = p_is_system)
      AND (p_is_org IS NULL OR p_is_org = '' OR U.ORG_CODE IS NOT NULL)
    ORDER BY U.USER_NAME, U.EMP_SEQ;
END//

-- ============================================================
-- sp_imes_tstd_employee_query6: 작업자 목록 조회
-- 원본: TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY6()
-- 용도: POP32A_SER2 (작업자 선택 팝업)
-- 사용화면: POP32A_D1A (작업자 선택 팝업)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_employee_query6//

CREATE PROCEDURE sp_imes_tstd_employee_query6(
    IN p_plt_code    VARCHAR(3),
    IN p_emp_code    VARCHAR(50),
    IN p_org_code    VARCHAR(20),
    IN p_emp_type    VARCHAR(10),
    IN p_main_mc     VARCHAR(20),
    IN p_avail_mc    VARCHAR(20),
    IN p_emp_like    VARCHAR(100),
    IN p_is_assy    VARCHAR(1),
    IN p_is_mc       VARCHAR(1),
    IN p_mc_group    VARCHAR(10),
    IN p_emp_gubun2  VARCHAR(10),
    IN p_not_p2      VARCHAR(1),
    IN p_data_flag   INT
)
BEGIN
    SELECT
        U.PLT_CODE           AS pltCode,
        U.USER_ID             AS empCode,
        U.USER_NAME           AS empName,
        U.EMP_TYPE            AS empType,
        U.POSITION            AS empTitle,
        U.EMP_SEQ             AS empSeq,
        U.ORG_CODE            AS orgCode,
        O.ORG_NAME            AS orgName,
        U.CPROC_CODE          AS cprocCode,
        CM.UTC_NAME           AS cprocName,
        UG.GROUP_ID           AS usrgrpCode,
        G.USRGRP_NAME         AS usrgrpName,
        IFNULL(G.IS_POP, 0)   AS isPop,
        U.USER_HP             AS mobilePhone,
        U.USER_MAIL           AS email,
        U.USER_PWD            AS accPwd,
        IFNULL(U.IS_SYSTEM, 0) AS isSystem,
        U.IF_EMP_CODE         AS ifEmpCode,
        IFNULL(U.IS_VND, 0)   AS isVnd,
        U.EMP_VND             AS empVnd,
        U.INS_DIRECTION       AS insDirection,
        DATE_FORMAT(U.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        U.REGI_ID             AS regEmp,
        DATE_FORMAT(U.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        U.CHNG_ID             AS mdfyEmp,
        U.USE_FLAG            AS dataFlag,
        NULL                  AS delDate,
        NULL                  AS delEmp,
        ''                    AS isMainEmp,
        U.MAIN_MC_CODE        AS mainMcCode,
        M.MC_NAME             AS mainMcName,
        MI.MC_FLAG            AS mcFlag
    FROM sys_user U
    LEFT JOIN TSTD_ORG O
        ON U.PLT_CODE = O.PLT_CODE
        AND U.ORG_CODE = O.ORG_CODE
    LEFT JOIN sys_ugrp UG
        ON U.SYS_ID = UG.SYS_ID
        AND U.USER_ID = UG.USER_ID
    LEFT JOIN TSYS_USERGRP G
        ON U.PLT_CODE = G.PLT_CODE
        AND UG.GROUP_ID = G.USRGRP_CODE
    LEFT JOIN TCST_UNIT_COST_MASTER CM
        ON U.PLT_CODE = CM.PLT_CODE
        AND U.CPROC_CODE = CM.UTC_CODE
    LEFT JOIN LSE_MACHINE M
        ON U.PLT_CODE = M.PLT_CODE
        AND U.MAIN_MC_CODE = M.MC_CODE
    LEFT JOIN LSE_MACHINE MI
        ON U.PLT_CODE = MI.PLT_CODE
        AND U.IF_MC_CODE = MI.MC_CODE
    WHERE U.PLT_CODE = p_plt_code
      AND (p_emp_code IS NULL OR p_emp_code = '' OR U.USER_ID = p_emp_code)
      AND (p_org_code IS NULL OR p_org_code = '' OR U.ORG_CODE = p_org_code)
      AND (p_emp_type IS NULL OR p_emp_type = '' OR U.EMP_TYPE = p_emp_type)
      AND (p_main_mc IS NULL OR p_main_mc = '' OR U.MAIN_MC_CODE IS NOT NULL)
      AND (p_avail_mc IS NULL OR p_avail_mc = '' OR 
           U.USER_ID IN (SELECT EMP_CODE FROM TSTD_MC_AVAILEMP WHERE MC_CODE = p_avail_mc))
      AND (p_emp_like IS NULL OR p_emp_like = '' OR 
           U.USER_ID LIKE CONCAT('%', p_emp_like, '%') OR 
           U.USER_NAME LIKE CONCAT('%', p_emp_like, '%'))
      AND (p_is_assy IS NULL OR p_is_assy = '' OR O.IS_ASSY = p_is_assy)
      AND (p_is_mc IS NULL OR p_is_mc = '' OR O.IS_MC = p_is_mc)
      AND (p_mc_group IS NULL OR p_mc_group = '' OR M.MC_GROUP = p_mc_group)
      AND (p_emp_gubun2 IS NULL OR p_emp_gubun2 = '' OR U.EMP_GUBUN2 = p_emp_gubun2)
      AND (p_not_p2 IS NULL OR p_not_p2 = '' OR U.EMP_GUBUN2 <> 'P2')
      AND (p_data_flag IS NULL OR U.USE_FLAG = CASE WHEN p_data_flag = 0 THEN 'Y' ELSE 'N' END)
    ORDER BY U.USER_NAME, U.EMP_SEQ;
END//

-- ============================================================
-- sp_imes_tstd_employee_query7: 작업자 코드만 조회 (설정 확인용)
-- 원본: TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY7()
-- 변환: TSTD_EMPLOYEE → SYS_USER
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_employee_query7//

CREATE PROCEDURE sp_imes_tstd_employee_query7(
    IN p_plt_code    VARCHAR(3),
    IN p_emp_code    VARCHAR(50),
    IN p_org_code    VARCHAR(20),
    IN p_reg_emp     VARCHAR(50),
    IN p_var         VARCHAR(100)
)
BEGIN
    SELECT
        U.PLT_CODE AS pltCode,
        U.USER_ID  AS empCode
    FROM sys_user U
    LEFT JOIN TSYS_EMP_CONF EC
        ON U.PLT_CODE = EC.PLT_CODE
        AND U.USER_ID = EC.EMP_CODE
    WHERE U.PLT_CODE = p_plt_code
      AND (p_emp_code IS NULL OR p_emp_code = '' OR U.USER_ID = p_emp_code)
      AND (p_org_code IS NULL OR p_org_code = '' OR U.ORG_CODE = p_org_code)
      AND (p_reg_emp IS NULL OR p_reg_emp = '' OR U.USER_ID <> p_reg_emp)
      AND U.USE_FLAG = 'Y'
      AND (p_var IS NULL OR p_var = '' OR 
           (EC.CONF_NAME = p_var AND EC.CONF_VALUE = '1'));
END//

-- ============================================================
-- sp_imes_tstd_employee_query8: 작업자 조회 (공정명 포함)
-- 원본: TSTD_EMPLOYEE_QUERY.TSTD_EMPLOYEE_QUERY8()
-- 변환: TSTD_EMPLOYEE → SYS_USER
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_employee_query8//

CREATE PROCEDURE sp_imes_tstd_employee_query8(
    IN p_plt_code    VARCHAR(3),
    IN p_emp_code    VARCHAR(50),
    IN p_emp_name    VARCHAR(100),
    IN p_org_code    VARCHAR(20),
    IN p_usrgrp_code VARCHAR(20),
    IN p_org_like    VARCHAR(100),
    IN p_acc_pwd     VARCHAR(100),
    IN p_avail_mc    VARCHAR(20),
    IN p_emp_like    VARCHAR(100),
    IN p_emp_type    VARCHAR(10),
    IN p_rfid_no     VARCHAR(50),
    IN p_data_flag   INT
)
BEGIN
    SELECT
        U.PLT_CODE           AS pltCode,
        U.USER_ID             AS empCode,
        U.USER_NAME           AS empName,
        U.EMP_TYPE            AS empType,
        U.POSITION            AS empTitle,
        U.EMP_SEQ             AS empSeq,
        U.ORG_CODE            AS orgCode,
        U.CPROC_CODE          AS cprocCode,
        UG.GROUP_ID           AS usrgrpCode,
        U.USER_HP             AS mobilePhone,
        U.USER_MAIL           AS email,
        U.USER_PWD            AS accPwd,
        IFNULL(U.IS_SYSTEM, 0) AS isSystem,
        DATE_FORMAT(U.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        U.REGI_ID             AS regEmp,
        DATE_FORMAT(U.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        U.CHNG_ID             AS mdfyEmp,
        U.USE_FLAG            AS dataFlag,
        NULL                  AS delDate,
        NULL                  AS delEmp,
        O.ORG_NAME            AS orgName,
        IFNULL(U.IS_VND, 0)   AS isVnd,
        G.USRGRP_NAME         AS usrgrpName,
        IFNULL(G.IS_POP, 0)   AS isPop,
        U.RFID_NO             AS rfidNo,
        PRC.PROC_CODE         AS procCode,
        PRC.PROC_NAME          AS procName,
        U.MAIN_MC_CODE        AS mainMcCode,
        M.MC_NAME             AS mainMcName,
        U.IF_MC_CODE          AS ifMcCode,
        IM.MC_NAME            AS ifMcName,
        IM.MC_FLAG            AS mcFlag
    FROM sys_user U
    LEFT JOIN TSTD_ORG O
        ON U.PLT_CODE = O.PLT_CODE
        AND U.ORG_CODE = O.ORG_CODE
    LEFT JOIN sys_ugrp UG
        ON U.SYS_ID = UG.SYS_ID
        AND U.USER_ID = UG.USER_ID
    LEFT JOIN TSYS_USERGRP G
        ON U.PLT_CODE = G.PLT_CODE
        AND UG.GROUP_ID = G.USRGRP_CODE
    LEFT JOIN LSE_STD_PROC PRC
        ON U.PLT_CODE = PRC.PLT_CODE
        AND U.CPROC_CODE = PRC.PROC_CODE
    LEFT JOIN LSE_MACHINE M
        ON U.PLT_CODE = M.PLT_CODE
        AND U.MAIN_MC_CODE = M.MC_CODE
    LEFT JOIN LSE_MACHINE IM
        ON U.PLT_CODE = IM.PLT_CODE
        AND U.IF_MC_CODE = IM.MC_CODE
    WHERE U.PLT_CODE = p_plt_code
      AND (p_emp_code IS NULL OR p_emp_code = '' OR U.USER_ID = p_emp_code)
      AND (p_emp_name IS NULL OR p_emp_name = '' OR U.USER_NAME = p_emp_name)
      AND (p_org_code IS NULL OR p_org_code = '' OR U.ORG_CODE = p_org_code)
      AND (p_usrgrp_code IS NULL OR p_usrgrp_code = '' OR UG.GROUP_ID = p_usrgrp_code)
      AND (p_org_like IS NULL OR p_org_like = '' OR 
           U.ORG_CODE LIKE CONCAT('%', p_org_like, '%'))
      AND (p_acc_pwd IS NULL OR p_acc_pwd = '' OR U.USER_PWD = p_acc_pwd)
      AND (p_avail_mc IS NULL OR p_avail_mc = '' OR 
           U.USER_ID IN (SELECT EMP_CODE FROM TSTD_MC_AVAILEMP WHERE MC_CODE = p_avail_mc))
      AND (p_emp_like IS NULL OR p_emp_like = '' OR 
           U.USER_ID LIKE CONCAT('%', p_emp_like, '%') OR 
           U.USER_NAME LIKE CONCAT('%', p_emp_like, '%'))
      AND (p_emp_type IS NULL OR p_emp_type = '' OR U.EMP_TYPE = p_emp_type)
      AND (p_rfid_no IS NULL OR p_rfid_no = '' OR U.RFID_NO = p_rfid_no)
      AND (p_data_flag IS NULL OR U.USE_FLAG = CASE WHEN p_data_flag = 0 THEN 'Y' ELSE 'N' END)
    ORDER BY U.EMP_SEQ;
END//

DELIMITER ;
