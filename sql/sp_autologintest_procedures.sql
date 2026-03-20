-- ============================================================================
-- Autologintest 프로시저
-- 원본 파일: src/main/resources/mappers/com/wsc/common/sample/Autologintest.xml
-- 생성일: 2026-01-15
-- 참고: createTokenForTest는 기존 SP_CREATE_TOKEN 프로시저 사용
-- ============================================================================

DELIMITER //

-- ============================================================================
-- 프로시저: sp_autologintest_get_menu_key_by_url
-- 설명: URL 경로로 메뉴 키 조회
-- 파라미터:
--   p_sys_id   - 시스템 ID
--   p_menu_url - 메뉴 URL
-- 반환: MENU_KEY (VARCHAR)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_autologintest_get_menu_key_by_url//
CREATE PROCEDURE sp_autologintest_get_menu_key_by_url(
    IN p_sys_id   VARCHAR(50),
    IN p_menu_url VARCHAR(500)
)
BEGIN
    SELECT MENU_KEY
      FROM SYS_MENU
     WHERE SYS_ID   = p_sys_id
       AND MENU_URL = p_menu_url
     LIMIT 0, 1;
END//

DELIMITER ;
