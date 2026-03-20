-- ============================================================================
-- SYS_USER 사원 검증 프로시저
-- TSTD_EMPLOYEE 폐기에 따른 SYS_USER 기반 사원 존재 확인
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-25
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_sys_user_emp_ser
-- 사원 존재 여부 확인 (SYS_USER 기반)
-- 용도: 엑셀업로드 사원코드 검증 등
-- TSTD_EMPLOYEE.TSTD_EMPLOYEE_SER 대체
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_sys_user_emp_ser//

CREATE PROCEDURE sp_imes_sys_user_emp_ser(
    IN p_plt_code  VARCHAR(3),
    IN p_emp_code  VARCHAR(50)
)
BEGIN
    SELECT
        A.PLT_CODE        AS pltCode,
        A.USER_ID         AS empCode,
        A.USER_NAME       AS empName,
        A.ORG_CODE        AS orgCode,
        A.USER_MAIL       AS email,
        B.ORG_NAME        AS orgName,
        A.USE_FLAG        AS useFlag
    FROM SYS_USER A
        LEFT JOIN TSTD_ORG B ON A.PLT_CODE = B.PLT_CODE AND A.ORG_CODE = B.ORG_CODE
    WHERE A.SYS_ID = 'IMMES'
      AND A.PLT_CODE = p_plt_code
      AND A.USER_ID = p_emp_code
      AND A.USE_FLAG = 'Y'
      AND IFNULL(A.IS_SYSTEM, 0) = 0;
END//

DELIMITER ;
