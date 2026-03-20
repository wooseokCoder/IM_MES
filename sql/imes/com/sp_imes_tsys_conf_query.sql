-- ============================================================================
-- 시스템 설정 조회 프로시저 (1개)
-- TSYS_CONF: sp_imes_tsys_conf_search
-- ============================================================================
-- AS-IS: MAINFORM_INIT_SYSTEM → SYS_CONF DataTable 로딩
-- 작성일: 2026-03-04
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tsys_conf_search
-- 공장코드별 시스템 설정 전체 조회
-- AS-IS: acSysConfig(DataTable dt) → Dictionary 로딩
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_conf_search//

CREATE PROCEDURE sp_imes_tsys_conf_search(
    IN p_plt_code  VARCHAR(10)
)
BEGIN
    SELECT
        CONF_NAME     AS confName,
        CONF_VALUE    AS confValue
    FROM TSYS_CONF
    WHERE PLT_CODE     = p_plt_code
      AND CONF_SECTION = 'SYS'
    ORDER BY CONF_NAME;
END//

DELIMITER ;
