-- ============================================================================
-- LSE_MC_CAPAPLAN CRUD 프로시저 (4개)
-- 설비 CAPA 계획: SER, INS, UPD, DEL3
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_mc_capaplan_ser
-- 단건 조회 (PLT_CODE + MC_CODE + MC_DATE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_capaplan_ser//

CREATE PROCEDURE sp_imes_lse_mc_capaplan_ser(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_mc_date    VARCHAR(8)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        MC_CODE     AS mcCode,
        MC_DATE     AS mcDate,
        FT1         AS ft1,
        FT2         AS ft2,
        FOT         AS fot,
        SD1         AS sd1,
        SD2         AS sd2,
        SOT         AS sot,
        TD1         AS td1,
        TD2         AS td2,
        TOT         AS tot,
        SCOMMENT    AS scomment
    FROM LSE_MC_CAPAPLAN
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE  = p_mc_code
      AND MC_DATE  = p_mc_date;
END//

-- ============================================================================
-- sp_imes_lse_mc_capaplan_ins
-- CAPA 계획 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_capaplan_ins//

CREATE PROCEDURE sp_imes_lse_mc_capaplan_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_mc_date    VARCHAR(8),
    IN p_ft1        FLOAT,
    IN p_ft2        FLOAT,
    IN p_fot        FLOAT,
    IN p_sd1        FLOAT,
    IN p_sd2        FLOAT,
    IN p_sot        FLOAT,
    IN p_td1        FLOAT,
    IN p_td2        FLOAT,
    IN p_tot        FLOAT,
    IN p_scomment   VARCHAR(100)
)
BEGIN
    INSERT INTO LSE_MC_CAPAPLAN (PLT_CODE, MC_CODE, MC_DATE, FT1, FT2, FOT, SD1, SD2, SOT, TD1, TD2, TOT, SCOMMENT)
    VALUES (p_plt_code, p_mc_code, p_mc_date, p_ft1, p_ft2, p_fot, p_sd1, p_sd2, p_sot, p_td1, p_td2, p_tot, p_scomment);
END//

-- ============================================================================
-- sp_imes_lse_mc_capaplan_upd
-- CAPA 계획 수정
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_capaplan_upd//

CREATE PROCEDURE sp_imes_lse_mc_capaplan_upd(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_mc_date    VARCHAR(8),
    IN p_ft1        FLOAT,
    IN p_ft2        FLOAT,
    IN p_fot        FLOAT,
    IN p_sd1        FLOAT,
    IN p_sd2        FLOAT,
    IN p_sot        FLOAT,
    IN p_td1        FLOAT,
    IN p_td2        FLOAT,
    IN p_tot        FLOAT,
    IN p_scomment   VARCHAR(100)
)
BEGIN
    UPDATE LSE_MC_CAPAPLAN
    SET FT1      = p_ft1,
        FT2      = p_ft2,
        FOT      = p_fot,
        SD1      = p_sd1,
        SD2      = p_sd2,
        SOT      = p_sot,
        TD1      = p_td1,
        TD2      = p_td2,
        TOT      = p_tot,
        SCOMMENT = p_scomment
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE  = p_mc_code
      AND MC_DATE  = p_mc_date;
END//

-- ============================================================================
-- sp_imes_lse_mc_capaplan_del3
-- CAPA 계획 삭제
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_capaplan_del3//

CREATE PROCEDURE sp_imes_lse_mc_capaplan_del3(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_mc_date    VARCHAR(8)
)
BEGIN
    DELETE FROM LSE_MC_CAPAPLAN
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE  = p_mc_code
      AND MC_DATE  = p_mc_date;
END//

DELIMITER ;
