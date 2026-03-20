-- ============================================================================
-- TSTD_EMPLOYEE 프로시저
-- 사원 마스터 조회
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-10
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_employee_ser
-- 사원 마스터 단건 조회 (PK: PLT_CODE + EMP_CODE)
-- 용도: 사원 존재 여부 확인 (엑셀업로드 검증 등)
-- JOIN: TSTD_ORG (부서명)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_employee_ser//

CREATE PROCEDURE sp_imes_tstd_employee_ser(
    IN p_plt_code  VARCHAR(3),
    IN p_emp_code  VARCHAR(10)
)
BEGIN
    SELECT
        A.PLT_CODE        AS pltCode,
        A.EMP_CODE        AS empCode,
        A.EMP_NAME        AS empName,
        A.ORG_CODE        AS orgCode,
        A.EMAIL           AS email,
        B.ORG_NAME        AS orgName,
        A.DATA_FLAG       AS dataFlag
    FROM TSTD_EMPLOYEE A
        LEFT JOIN TSTD_ORG B ON A.PLT_CODE = B.PLT_CODE AND A.ORG_CODE = B.ORG_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.EMP_CODE = p_emp_code;
END//

DELIMITER ;
