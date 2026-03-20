-- ============================================================================
-- TSYS_SERIAL_QUERY 조회 프로시저 (1개)
-- 일련번호 관리: QUERY1 (목록 조회)
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-10
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tsys_serial_query1
-- 일련번호 목록 조회 (동적 WHERE)
-- 파라미터: PLT_CODE (필수), MODEL_LIKE/IS_HOGI/SR_CODE/SR_KEY (선택)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_serial_query1//

CREATE PROCEDURE sp_imes_tsys_serial_query1(
    IN p_plt_code    VARCHAR(3),
    IN p_model_like  VARCHAR(100),
    IN p_is_hogi     VARCHAR(1),
    IN p_sr_code     VARCHAR(20),
    IN p_sr_key      VARCHAR(15)
)
BEGIN
    SELECT
        PLT_CODE        AS pltCode,
        SR_CODE         AS srCode,
        SR_KEY          AS srKey,
        SR_NO           AS srNo
    FROM TSYS_SERIAL
    WHERE PLT_CODE = p_plt_code
      AND (p_model_like IS NULL OR p_model_like = '' OR SR_CODE LIKE CONCAT('%', p_model_like, '%'))
      AND (p_is_hogi IS NULL OR p_is_hogi = '' OR IS_HOGI = p_is_hogi)
      AND (p_sr_code IS NULL OR p_sr_code = '' OR SR_CODE = p_sr_code)
      AND (p_sr_key IS NULL OR p_sr_key = '' OR SR_KEY = p_sr_key)
    ;
END//

DELIMITER ;
