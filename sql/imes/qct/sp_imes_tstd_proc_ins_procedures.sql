-- ============================================================================
-- TSTD_PROC_INS CRUD 프로시저 (3개)
-- 자주검사 항목: INS, UPD, UDE
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-27
-- 수정일: 2026-03-03 - DECIMAL/INT 파라미터를 VARCHAR로 변경 (빈 문자열 오류 방지)
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_proc_ins_ins
-- 검사항목 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_ins//

CREATE PROCEDURE sp_imes_tstd_proc_ins_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_ins_code   VARCHAR(20),
    IN p_plants     VARCHAR(10),
    IN p_proc_code  VARCHAR(10),
    IN p_proc_name  VARCHAR(20),
    IN p_ins_name   VARCHAR(50),
    IN p_ins_desc   VARCHAR(200),
    IN p_ins_type   VARCHAR(5),
    IN p_ins_unit   VARCHAR(5),
    IN p_avg_val    VARCHAR(50),
    IN p_min_val    VARCHAR(50),
    IN p_max_val    VARCHAR(50),
    IN p_ins_seq    VARCHAR(10),
    IN p_ins_img    LONGTEXT,
    IN p_user_id    VARCHAR(10)
)
BEGIN
    INSERT INTO TSTD_PROC_INS (
        PLT_CODE, INS_CODE, PLANTS, PROC_CODE, PROC_NAME,
        INS_NAME, INS_DESC, INS_TYPE, INS_UNIT, AVG_VAL,
        MIN_VAL, MAX_VAL, INS_SEQ,
        INS_IMG,
        REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_ins_code, p_plants, p_proc_code, p_proc_name,
        p_ins_name, p_ins_desc, p_ins_type, p_ins_unit, NULLIF(p_avg_val, ''),
        CAST(NULLIF(p_min_val, '') AS DECIMAL(10,4)),
        CAST(NULLIF(p_max_val, '') AS DECIMAL(10,4)),
        CAST(NULLIF(p_ins_seq, '') AS SIGNED),
        CASE WHEN p_ins_img IS NOT NULL AND p_ins_img != '' AND p_ins_img != '__KEEP__' THEN FROM_BASE64(p_ins_img) ELSE NULL END,
        NOW(), p_user_id, 0
    );
END//

-- ============================================================================
-- sp_imes_tstd_proc_ins_upd
-- 검사항목 수정
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_upd//

CREATE PROCEDURE sp_imes_tstd_proc_ins_upd(
    IN p_plt_code   VARCHAR(3),
    IN p_ins_code   VARCHAR(20),
    IN p_proc_code  VARCHAR(10),
    IN p_proc_name  VARCHAR(20),
    IN p_ins_name   VARCHAR(50),
    IN p_ins_desc   VARCHAR(200),
    IN p_ins_type   VARCHAR(5),
    IN p_ins_unit   VARCHAR(5),
    IN p_avg_val    VARCHAR(50),
    IN p_min_val    VARCHAR(50),
    IN p_max_val    VARCHAR(50),
    IN p_ins_seq    VARCHAR(10),
    IN p_ins_img    LONGTEXT,
    IN p_user_id    VARCHAR(10)
)
BEGIN
    UPDATE TSTD_PROC_INS
    SET PROC_CODE  = p_proc_code,
        PROC_NAME  = p_proc_name,
        INS_NAME   = p_ins_name,
        INS_DESC   = p_ins_desc,
        INS_TYPE   = p_ins_type,
        INS_UNIT   = p_ins_unit,
        AVG_VAL    = NULLIF(p_avg_val, ''),
        MIN_VAL    = CAST(NULLIF(p_min_val, '') AS DECIMAL(10,4)),
        MAX_VAL    = CAST(NULLIF(p_max_val, '') AS DECIMAL(10,4)),
        INS_SEQ    = CAST(NULLIF(p_ins_seq, '') AS SIGNED),
        INS_IMG    = CASE
                         WHEN p_ins_img = '__KEEP__' THEN INS_IMG
                         WHEN p_ins_img IS NULL OR p_ins_img = '' THEN NULL
                         ELSE FROM_BASE64(p_ins_img)
                     END,
        MDFY_DATE  = NOW(),
        MDFY_EMP   = p_user_id,
        DATA_FLAG  = 0
    WHERE PLT_CODE = p_plt_code
      AND INS_CODE = p_ins_code;
END//

-- ============================================================================
-- sp_imes_tstd_proc_ins_ude
-- 검사항목 논리삭제 (DATA_FLAG=2)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_ude//

CREATE PROCEDURE sp_imes_tstd_proc_ins_ude(
    IN p_plt_code   VARCHAR(3),
    IN p_ins_code   VARCHAR(20),
    IN p_user_id    VARCHAR(10)
)
BEGIN
    UPDATE TSTD_PROC_INS
    SET DATA_FLAG = 2,
        DEL_DATE  = NOW(),
        DEL_EMP   = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND INS_CODE = p_ins_code;
END//

DELIMITER ;
