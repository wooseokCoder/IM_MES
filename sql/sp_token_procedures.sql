-- ============================================================
-- Token.xml (토큰 관리) -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. API 임시 로그 관리 (SYS_API_TEMP_LOG)
-- ============================================================

-- [sp_token_tmp_log_insert] API 임시 로그 등록
-- 동적 필드를 모두 파라미터로 받아 처리
DROP PROCEDURE IF EXISTS sp_token_tmp_log_insert//
CREATE PROCEDURE sp_token_tmp_log_insert(
    IN p_user_id VARCHAR(50),
    IN p_token VARCHAR(100),
    IN p_ordr_no VARCHAR(50),
    IN p_assy_no VARCHAR(50),
    IN p_type VARCHAR(50),
    IN p_val VARCHAR(500),
    IN p_val2 VARCHAR(500),
    IN p_val3 VARCHAR(500),
    IN p_val4 VARCHAR(500),
    IN p_val5 VARCHAR(500),
    IN p_val6 VARCHAR(500),
    IN p_val7 VARCHAR(500),
    IN p_val8 VARCHAR(500),
    IN p_val9 VARCHAR(500),
    IN p_val10 VARCHAR(500),
    IN p_val11 VARCHAR(500),
    IN p_val12 VARCHAR(500),
    IN p_val13 VARCHAR(500),
    IN p_val14 VARCHAR(500),
    IN p_val15 VARCHAR(500),
    IN p_val16 VARCHAR(500),
    IN p_val17 VARCHAR(500)
)
BEGIN
    INSERT INTO SYS_API_TEMP_LOG (
        SYS_ID,
        SEQ,
        USER_ID,
        TOKEN_NO,
        LOG_1,
        LOG_2,
        LOG_3,
        LOG_4,
        LOG_5,
        LOG_6,
        LOG_7,
        LOG_8,
        LOG_9,
        LOG_10,
        LOG_11,
        LOG_12,
        LOG_13,
        LOG_14,
        LOG_15,
        LOG_16,
        LOG_17,
        LOG_18,
        LOG_19,
        LOG_20,
        RET,
        CON_DATE
    ) VALUES (
        'IMMES',
        fn_get_next_seq_d('TL', '10'),
        p_user_id,
        p_token,
        NULLIF(p_ordr_no, ''),
        NULLIF(p_assy_no, ''),
        NULLIF(p_type, ''),
        NULLIF(p_val, ''),
        NULLIF(p_val2, ''),
        NULLIF(p_val3, ''),
        NULLIF(p_val4, ''),
        NULLIF(p_val5, ''),
        NULLIF(p_val6, ''),
        NULLIF(p_val7, ''),
        NULLIF(p_val8, ''),
        NULLIF(p_val9, ''),
        NULLIF(p_val10, ''),
        NULLIF(p_val11, ''),
        NULLIF(p_val12, ''),
        NULLIF(p_val13, ''),
        NULLIF(p_val14, ''),
        NULLIF(p_val15, ''),
        NULL,
        NOW()
    );
END//

-- [sp_token_tmp_log_update] API 임시 로그 결과 업데이트
DROP PROCEDURE IF EXISTS sp_token_tmp_log_update//
CREATE PROCEDURE sp_token_tmp_log_update(
    IN p_user_id VARCHAR(50),
    IN p_token VARCHAR(100),
    IN p_ret VARCHAR(500)
)
BEGIN
    UPDATE SYS_API_TEMP_LOG
       SET RET      = p_ret,
           CON_DATE = NOW()
     WHERE SYS_ID   = 'IMMES'
       AND USER_ID  = p_user_id
       AND TOKEN_NO = p_token;
END//

DELIMITER ;
