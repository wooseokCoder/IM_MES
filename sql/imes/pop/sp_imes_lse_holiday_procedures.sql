-- ============================================================
-- LSE_HOLIDAY 휴일 조회 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: LSE_HOLIDAY
-- 원본: ProActive LSE_HOLIDAY.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (1개):
--   1. sp_imes_lse_holiday_ser - 휴일 목록 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_lse_holiday_ser: 휴일 목록 조회
-- 원본: LSE_HOLIDAY.LSE_HOLIDAY_SER()
-- 용도: POP30B 휴일 목록 조회 (기간 필터)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_holiday_ser//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_lse_holiday_ser(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_s_date    VARCHAR(8),      /* 시작일 */
    IN p_e_date    VARCHAR(8)       /* 종료일 */
)
BEGIN
    SELECT
        PLT_CODE       AS "pltCode"
       ,HOLI_DATE       AS "holiDate"
       ,HOLI_NAME       AS "holiName"
    FROM LSE_HOLIDAY
    WHERE PLT_CODE = p_plt_code
      AND DATA_FLAG = 0
      AND (p_s_date IS NULL OR p_s_date = '' OR HOLI_DATE >= p_s_date)
      AND (p_e_date IS NULL OR p_e_date = '' OR HOLI_DATE <= p_e_date)
    ORDER BY HOLI_DATE;
END//


DELIMITER ;
