-- ============================================================================
-- TSYS_SERIAL CRUD 프로시저 (1개)
-- 일련번호 관리: UPD (순번 수정)
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-10
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tsys_serial_upd
-- 일련번호 순번 수정
-- UPDATE TSYS_SERIAL SET SR_NO WHERE PLT_CODE + SR_CODE + SR_KEY (PK)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_serial_upd//

CREATE PROCEDURE sp_imes_tsys_serial_upd(
    IN p_plt_code   VARCHAR(3),
    IN p_sr_code    VARCHAR(20),
    IN p_sr_key     VARCHAR(15),
    IN p_sr_no      INT
)
BEGIN
    UPDATE TSYS_SERIAL
       SET SR_NO = p_sr_no
     WHERE PLT_CODE = p_plt_code
       AND SR_CODE  = p_sr_code
       AND SR_KEY   = p_sr_key;
END//

DELIMITER ;
