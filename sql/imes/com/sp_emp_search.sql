-- ============================================================================
-- 사원 검색 공통 팝업 프로시저 (1개)
-- acEmpForm: sp_emp_search
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-12
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_emp_search
-- 사원 목록 조회 (acEmpForm 팝업용)
-- SYS_USER + TSTD_ORG JOIN
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_emp_search//

CREATE PROCEDURE sp_emp_search(
    IN p_plt_code   VARCHAR(3),
    IN p_emp_like   VARCHAR(100)
)
BEGIN
    SELECT
        U.USER_ID       AS empCode,
        U.USER_NAME     AS empName,
        U.ORG_CODE      AS orgCode,
        O.ORG_NAME      AS orgName,
        U.EMP_TYPE      AS empType,
        U.POSITION      AS empTitle,
        U.USER_MAIL     AS email
    FROM SYS_USER U
        LEFT JOIN TSTD_ORG O ON U.PLT_CODE = O.PLT_CODE
                             AND U.ORG_CODE = O.ORG_CODE
    WHERE U.SYS_ID = 'IMMES'
      AND U.PLT_CODE = IFNULL(p_plt_code, '100')
      AND U.USE_FLAG = 'Y'
      AND U.IS_SYSTEM = 0
      AND (p_emp_like IS NULL OR p_emp_like = ''
           OR U.USER_ID LIKE CONCAT('%', p_emp_like, '%')
           OR U.USER_NAME LIKE CONCAT('%', p_emp_like, '%'))
    ORDER BY U.ORG_CODE, U.USER_ID;
END//

DELIMITER ;
