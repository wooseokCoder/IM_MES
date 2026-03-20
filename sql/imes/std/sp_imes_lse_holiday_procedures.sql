-- ============================================================================
-- LSE_HOLIDAY CRUD 프로시저 (4개)
-- 휴일 마스터: SER, INS, UPD, DEL3
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_holiday_ser
-- 단건 조회 (PLT_CODE + HOLI_DATE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_holiday_ser//

CREATE PROCEDURE sp_imes_lse_holiday_ser(
    IN p_plt_code   VARCHAR(3),
    IN p_holi_date  VARCHAR(8)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        HOLI_DATE   AS holiDate,
        HOLI_NAME   AS holiName
    FROM LSE_HOLIDAY
    WHERE PLT_CODE = p_plt_code
      AND HOLI_DATE = p_holi_date;
END//

-- ============================================================================
-- sp_imes_lse_holiday_ins
-- 휴일 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_holiday_ins//

CREATE PROCEDURE sp_imes_lse_holiday_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_holi_date  VARCHAR(8),
    IN p_holi_name  VARCHAR(50)
)
BEGIN
    INSERT INTO LSE_HOLIDAY (PLT_CODE, HOLI_DATE, HOLI_NAME)
    VALUES (p_plt_code, p_holi_date, p_holi_name);
END//

-- ============================================================================
-- sp_imes_lse_holiday_upd
-- 휴일에 해당하는 모든 설비 CAPA를 0으로 갱신 (TSTD_MC_DAILYCAPA 대상)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_holiday_upd//

CREATE PROCEDURE sp_imes_lse_holiday_upd(
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    UPDATE TSTD_MC_DAILYCAPA
    SET CAPA = 0
    WHERE PLT_CODE = p_plt_code
      AND WORK_DATE IN (
          SELECT HOLI_DATE
          FROM LSE_HOLIDAY
          WHERE PLT_CODE = p_plt_code
      );
END//

-- ============================================================================
-- sp_imes_lse_holiday_del3
-- 휴일 삭제 (PLT_CODE + HOLI_DATE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_holiday_del3//

CREATE PROCEDURE sp_imes_lse_holiday_del3(
    IN p_plt_code   VARCHAR(3),
    IN p_holi_date  VARCHAR(8)
)
BEGIN
    DELETE FROM LSE_HOLIDAY
    WHERE PLT_CODE = p_plt_code
      AND HOLI_DATE = p_holi_date;
END//

DELIMITER ;
