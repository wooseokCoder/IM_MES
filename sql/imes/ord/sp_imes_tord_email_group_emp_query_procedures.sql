-- ============================================================================
-- TORD_EMAIL_GROUP_EMP QUERY 프로시저 (1개)
-- 이메일 수신자그룹 사원 목록 조회
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-10
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tord_email_group_emp_query1
-- 그룹별 사원 목록 조회 (우측 그리드)
-- JOIN: TSTD_EMPLOYEE E (사원명), TSTD_ORG O (부서명)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_emp_query1//

CREATE PROCEDURE sp_imes_tord_email_group_emp_query1(
    IN p_plt_code   VARCHAR(3),
    IN p_data_flag  INT,
    IN p_mcode      VARCHAR(20),
    IN p_emp_code   VARCHAR(50)
)
BEGIN
    SELECT
        A.PLT_CODE        AS pltCode,
        A.MCODE           AS mcode,
        A.EMP_CODE        AS empCode,
        E.EMP_NAME        AS empName,
        O.ORG_NAME        AS orgName,
        A.EMAIL           AS email,
        DATE_FORMAT(A.REG_DATE, '%Y-%m-%d %H:%i:%s')  AS regDate,
        A.REG_EMP         AS regEmp,
        DATE_FORMAT(A.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        A.MDFY_EMP        AS mdfyEmp
    FROM TORD_EMAIL_GROUP_EMP A
        LEFT JOIN TSTD_EMPLOYEE E ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.EMP_CODE
        LEFT JOIN TSTD_ORG O      ON E.PLT_CODE = O.PLT_CODE AND E.ORG_CODE = O.ORG_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND (p_data_flag IS NULL OR A.DATA_FLAG = p_data_flag)
      AND (p_mcode IS NULL OR p_mcode = '' OR A.MCODE = p_mcode)
      AND (p_emp_code IS NULL OR p_emp_code = '' OR A.EMP_CODE = p_emp_code)
    ORDER BY A.EMP_CODE;
END//

DELIMITER ;
