-- ============================================================================
-- TSTD_MC_DAILYCAPA CRUD 프로시저 (5개)
-- 설비 일일 CAPA: SER, INS, INS2, UPD, DEL2
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_mc_dailycapa_ser
-- 단건 조회 (PLT_CODE + MC_CODE + WORK_DATE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_dailycapa_ser//

CREATE PROCEDURE sp_imes_tstd_mc_dailycapa_ser(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_work_date  VARCHAR(8)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        MC_CODE     AS mcCode,
        WORK_DATE   AS workDate,
        CAPA        AS capa
    FROM TSTD_MC_DAILYCAPA
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE  = p_mc_code
      AND WORK_DATE = p_work_date;
END//

-- ============================================================================
-- sp_imes_tstd_mc_dailycapa_ins
-- CAPA 등록 (지정 CAPA 값)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_dailycapa_ins//

CREATE PROCEDURE sp_imes_tstd_mc_dailycapa_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_work_date  VARCHAR(8),
    IN p_capa       DECIMAL(4,0)
)
BEGIN
    INSERT INTO TSTD_MC_DAILYCAPA (PLT_CODE, MC_CODE, WORK_DATE, CAPA)
    VALUES (p_plt_code, p_mc_code, p_work_date, p_capa);
END//

-- ============================================================================
-- sp_imes_tstd_mc_dailycapa_ins2
-- CAPA=0 고정 등록 (비근무일용)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_dailycapa_ins2//

CREATE PROCEDURE sp_imes_tstd_mc_dailycapa_ins2(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_work_date  VARCHAR(8)
)
BEGIN
    INSERT INTO TSTD_MC_DAILYCAPA (PLT_CODE, MC_CODE, WORK_DATE, CAPA)
    VALUES (p_plt_code, p_mc_code, p_work_date, 0);
END//

-- ============================================================================
-- sp_imes_tstd_mc_dailycapa_upd
-- CAPA 수정 (CAPA + SCOMMENT)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_dailycapa_upd//

CREATE PROCEDURE sp_imes_tstd_mc_dailycapa_upd(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_work_date  VARCHAR(8),
    IN p_capa       DECIMAL(4,0),
    IN p_scomment   VARCHAR(100)
)
BEGIN
    UPDATE TSTD_MC_DAILYCAPA
    SET CAPA     = p_capa,
        SCOMMENT = p_scomment
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE  = p_mc_code
      AND WORK_DATE = p_work_date;
END//

-- ============================================================================
-- sp_imes_tstd_mc_dailycapa_del2
-- 삭제 (PLT_CODE + MC_CODE + WORK_DATE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_dailycapa_del2//

CREATE PROCEDURE sp_imes_tstd_mc_dailycapa_del2(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_work_date  VARCHAR(8)
)
BEGIN
    DELETE FROM TSTD_MC_DAILYCAPA
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE  = p_mc_code
      AND WORK_DATE = p_work_date;
END//

DELIMITER ;
