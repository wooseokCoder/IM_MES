-- ============================================================================
-- LSE_HOLIDAY QUERY 프로시저 (1개)
-- 휴일 마스터 조회: QUERY1
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_holiday_query1
-- 기간별 휴일 목록 조회 (달력 표시용)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_holiday_query1//

CREATE PROCEDURE sp_imes_lse_holiday_query1(
    IN p_plt_code     VARCHAR(3),
    IN p_s_holi_date  VARCHAR(8),
    IN p_e_holi_date  VARCHAR(8)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        HOLI_DATE   AS dispHoliDate,
        HOLI_DATE   AS holiDate,
        HOLI_NAME   AS holiName
    FROM LSE_HOLIDAY
    WHERE PLT_CODE = p_plt_code
      AND (p_s_holi_date IS NULL OR p_s_holi_date = '' OR HOLI_DATE BETWEEN p_s_holi_date AND p_e_holi_date);
END//

DELIMITER ;
