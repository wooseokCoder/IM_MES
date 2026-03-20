-- ============================================================================
-- TSTD_MC_AVAILEMP QUERY 프로시저 (1개)
-- 설비 가용사원 조회: QUERY1
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-23
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_mc_availemp_query1
-- 특정 설비의 가용사원 목록 조회
-- JOIN: SYS_USER(사원명), TSTD_ORG(부서명), LSE_MACHINE(설비명)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_availemp_query1//

CREATE PROCEDURE sp_imes_tstd_mc_availemp_query1(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10)
)
BEGIN
    SELECT
        M.PLT_CODE      AS pltCode,
        M.MC_CODE       AS mcCode,
        MC.MC_NAME      AS mcName,
        E.ORG_CODE      AS orgCode,
        O.ORG_NAME      AS orgName,
        M.EMP_CODE      AS empCode,
        E.USER_NAME     AS empName,
        M.EMP_SEQ       AS empSeq
    FROM TSTD_MC_AVAILEMP M
        LEFT JOIN SYS_USER E
            ON E.SYS_ID = 'IMMES' AND M.PLT_CODE = E.PLT_CODE AND M.EMP_CODE = E.USER_ID
        LEFT JOIN TSTD_ORG O
            ON E.PLT_CODE = O.PLT_CODE AND E.ORG_CODE = O.ORG_CODE
        LEFT JOIN LSE_MACHINE MC
            ON M.PLT_CODE = MC.PLT_CODE AND M.MC_CODE = MC.MC_CODE
    WHERE M.PLT_CODE = p_plt_code
      AND (p_mc_code IS NULL OR p_mc_code = '' OR M.MC_CODE = p_mc_code)
    ORDER BY M.EMP_SEQ;
END//

DELIMITER ;
