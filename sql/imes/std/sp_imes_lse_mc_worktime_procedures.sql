-- ============================================================================
-- LSE_MC_WORKTIME CRUD 프로시저 (4개)
-- 설비 요일별 근무시간: SER, SER2, DEL2, INS
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- 수정일: 2026-02-23 (STD04A용 SER2, DEL2, INS 추가)
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_mc_worktime_ser
-- 설비/교대별 요일 근무시간 조회 (단건, MC_CODE + MC_SHIFT + PLT_CODE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_worktime_ser//

CREATE PROCEDURE sp_imes_lse_mc_worktime_ser(
    IN p_mc_code    VARCHAR(10),
    IN p_mc_shift   TINYINT,
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        MC_CODE     AS mcCode,
        MC_SHIFT    AS mcShift,
        MON_TIME    AS monTime,
        TUE_TIME    AS tueTime,
        WED_TIME    AS wedTime,
        THR_TIME    AS thrTime,
        FRI_TIME    AS friTime,
        SAT_TIME    AS satTime,
        SUN_TIME    AS sunTime
    FROM LSE_MC_WORKTIME
    WHERE MC_CODE = p_mc_code
      AND MC_SHIFT = p_mc_shift
      AND PLT_CODE = p_plt_code;
END//

-- ============================================================================
-- sp_imes_lse_mc_worktime_ser2
-- 설비별 전체 교대 근무시간 조회 (MC_CODE + PLT_CODE, MC_SHIFT 필터 없음)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_worktime_ser2//

CREATE PROCEDURE sp_imes_lse_mc_worktime_ser2(
    IN p_mc_code    VARCHAR(10),
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    SELECT
        PLT_CODE    AS pltCode,
        MC_CODE     AS mcCode,
        MC_SHIFT    AS mcShift,
        MON_TIME    AS monTime,
        TUE_TIME    AS tueTime,
        WED_TIME    AS wedTime,
        THR_TIME    AS thrTime,
        FRI_TIME    AS friTime,
        SAT_TIME    AS satTime,
        SUN_TIME    AS sunTime
    FROM LSE_MC_WORKTIME
    WHERE MC_CODE = p_mc_code
      AND PLT_CODE = p_plt_code;
END//

-- ============================================================================
-- sp_imes_lse_mc_worktime_del2
-- 설비별 근무시간 전체 삭제 (MC_CODE + PLT_CODE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_worktime_del2//

CREATE PROCEDURE sp_imes_lse_mc_worktime_del2(
    IN p_mc_code    VARCHAR(10),
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    DELETE FROM LSE_MC_WORKTIME
    WHERE MC_CODE = p_mc_code
      AND PLT_CODE = p_plt_code;
END//

-- ============================================================================
-- sp_imes_lse_mc_worktime_ins
-- 설비 교대별 근무시간 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_mc_worktime_ins//

CREATE PROCEDURE sp_imes_lse_mc_worktime_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_mc_shift   TINYINT,
    IN p_mon_time   FLOAT,
    IN p_tue_time   FLOAT,
    IN p_wed_time   FLOAT,
    IN p_thr_time   FLOAT,
    IN p_fri_time   FLOAT,
    IN p_sat_time   FLOAT,
    IN p_sun_time   FLOAT
)
BEGIN
    INSERT INTO LSE_MC_WORKTIME (
        PLT_CODE, MC_CODE, MC_SHIFT,
        MON_TIME, TUE_TIME, WED_TIME, THR_TIME,
        FRI_TIME, SAT_TIME, SUN_TIME
    ) VALUES (
        p_plt_code, p_mc_code, p_mc_shift,
        p_mon_time, p_tue_time, p_wed_time, p_thr_time,
        p_fri_time, p_sat_time, p_sun_time
    );
END//

DELIMITER ;
