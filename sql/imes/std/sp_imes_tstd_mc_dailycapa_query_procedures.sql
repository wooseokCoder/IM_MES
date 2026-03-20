-- ============================================================================
-- TSTD_MC_DAILYCAPA QUERY 프로시저 (2개)
-- 설비 일일 CAPA 조회: QUERY1, QUERY5
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_mc_dailycapa_query1
-- 동적 WHERE 조건 조회 (PLT_CODE 필수, MC_CODE/WORK_DATE/AFTER_WORK_DATE 선택)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_dailycapa_query1//

CREATE PROCEDURE sp_imes_tstd_mc_dailycapa_query1(
    IN p_plt_code        VARCHAR(3),
    IN p_mc_code         VARCHAR(10),
    IN p_work_date       VARCHAR(8),
    IN p_after_work_date VARCHAR(8)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        MC_CODE     AS mcCode,
        WORK_DATE   AS workDate,
        CAPA        AS capa
    FROM TSTD_MC_DAILYCAPA
    WHERE PLT_CODE = p_plt_code
      AND (p_mc_code IS NULL OR p_mc_code = '' OR MC_CODE = p_mc_code)
      AND (p_work_date IS NULL OR p_work_date = '' OR WORK_DATE = p_work_date)
      AND (p_after_work_date IS NULL OR p_after_work_date = '' OR WORK_DATE >= p_after_work_date);
END//

-- ============================================================================
-- sp_imes_tstd_mc_dailycapa_query5
-- 메인 그리드용 JOIN 조회 (날짜별 설비 CAPA + 설비명 + 휴일명)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_dailycapa_query5//

CREATE PROCEDURE sp_imes_tstd_mc_dailycapa_query5(
    IN p_plt_code   VARCHAR(3),
    IN p_date1      VARCHAR(8),
    IN p_date2      VARCHAR(8)
)
BEGIN
    SELECT
        A.PLT_CODE      AS pltCode,
        A.WORK_DATE     AS workDate,
        A.MC_CODE       AS mcCode,
        B.MC_NAME       AS mcName,
        A.CAPA          AS capa,
        C.HOLI_NAME     AS holiName,
        B.MC_GROUP      AS mcGroup,
        A.SCOMMENT      AS scomment
    FROM TSTD_MC_DAILYCAPA A
        LEFT JOIN LSE_MACHINE B
            ON A.MC_CODE = B.MC_CODE AND A.PLT_CODE = B.PLT_CODE
        LEFT JOIN LSE_HOLIDAY C
            ON A.WORK_DATE = C.HOLI_DATE AND A.PLT_CODE = C.PLT_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND (p_date1 IS NULL OR p_date1 = '' OR A.WORK_DATE BETWEEN p_date1 AND p_date2)
      AND B.MC_MGT_FLAG = 1
      AND B.DATA_FLAG = 0
    ORDER BY A.PLT_CODE, A.WORK_DATE, B.MC_SEQ, A.MC_CODE;
END//

DELIMITER ;
