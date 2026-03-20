-- ============================================================
-- Help.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 도움말 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_select//

CREATE PROCEDURE sp_board_help_select(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT
        SYS_ID AS "sysId",
        BORD_NO AS "bordNo",
        BORD_GRUP AS "bordGrup",
        BORD_TITLE AS "bordTitle",
        (SELECT MENU_DESC FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = BORD_TITLE) AS "bordTitle2",
        BORD_TYPE AS "bordType",
        BORD_BGN AS "bordBgn",
        BORD_END AS "bordEnd",
        READ_CNT AS "readCnt",
        BORD_SEQ AS "bordSeq",
        BORD_PNO AS "bordPno",
        OPEN_TYPE AS "openType",
        USE_FLAG AS "useFlag",
        REGI_ID AS "regiId",
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS "regiDate",
        CHNG_ID AS "chngId",
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS "chngDate",
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS "regiName",
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS "chngName",
        BORD_NO AS "id",
        BORD_PNO AS "parentId",
        CASE WHEN (SELECT COUNT(*) FROM SYS_HELP WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND SYS_LANG = p_gs_lang) = 0
             THEN 'open' ELSE 'closed' END AS "state",
        BORD_TEXT AS "bordText"
    FROM SYS_HELP A
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = p_gs_lang
      AND BORD_NO = p_bord_no;
END//

-- ============================================================
-- 2. 도움말 단건 조회 (메뉴키 기반)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_select_by_menukey//

CREATE PROCEDURE sp_board_help_select_by_menukey(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_menukey VARCHAR(100),
    IN p_bord_type VARCHAR(20),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT
        SYS_ID AS "sysId",
        BORD_NO AS "bordNo",
        BORD_GRUP AS "bordGrup",
        BORD_TITLE AS "bordTitle",
        (SELECT MENU_DESC FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = BORD_TITLE) AS "bordTitle2",
        BORD_TYPE AS "bordType",
        BORD_BGN AS "bordBgn",
        BORD_END AS "bordEnd",
        READ_CNT AS "readCnt",
        BORD_SEQ AS "bordSeq",
        BORD_PNO AS "bordPno",
        OPEN_TYPE AS "openType",
        USE_FLAG AS "useFlag",
        REGI_ID AS "regiId",
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS "regiDate",
        CHNG_ID AS "chngId",
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS "chngDate",
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS "regiName",
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS "chngName",
        BORD_NO AS "id",
        BORD_PNO AS "parentId",
        CASE WHEN (SELECT COUNT(*) FROM SYS_HELP WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND SYS_LANG = p_gs_lang) = 0
             THEN 'open' ELSE 'closed' END AS "state",
        BORD_TEXT AS "bordText"
    FROM SYS_HELP A
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = p_gs_lang
      AND BORD_NO = (SELECT BORD_NO FROM SYS_HELP WHERE SYS_ID = p_sys_id AND SYS_LANG = p_gs_lang AND BORD_GRUP = p_bord_grup AND BORD_TITLE = p_menukey AND BORD_TYPE = p_bord_type);
END//

-- ============================================================
-- 3. 도움말 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_update//

CREATE PROCEDURE sp_board_help_update(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text LONGTEXT,
    IN p_bord_type VARCHAR(20),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_read_cnt INT,
    IN p_bord_seq INT,
    IN p_use_flag VARCHAR(1),
    IN p_open_type VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_HELP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        BORD_TITLE = CASE WHEN p_bord_title IS NOT NULL AND p_bord_title != '' THEN p_bord_title ELSE BORD_TITLE END,
        BORD_TEXT = CASE WHEN p_bord_text IS NOT NULL AND p_bord_text != '' THEN p_bord_text ELSE BORD_TEXT END,
        BORD_TYPE = CASE WHEN p_bord_type IS NOT NULL AND p_bord_type != '' THEN p_bord_type ELSE BORD_TYPE END,
        BORD_BGN = CASE WHEN p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN p_bord_bgn ELSE BORD_BGN END,
        BORD_END = CASE WHEN p_bord_end IS NOT NULL AND p_bord_end != '' THEN p_bord_end ELSE BORD_END END,
        READ_CNT = CASE WHEN p_read_cnt IS NOT NULL THEN p_read_cnt ELSE READ_CNT END,
        BORD_SEQ = CASE WHEN p_bord_seq IS NOT NULL THEN p_bord_seq ELSE BORD_SEQ END,
        USE_FLAG = CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN p_use_flag ELSE USE_FLAG END,
        OPEN_TYPE = CASE WHEN p_open_type IS NOT NULL AND p_open_type != '' THEN p_open_type ELSE OPEN_TYPE END
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = p_gs_lang;
END//

-- ============================================================
-- 4. 도움말 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_delete//

CREATE PROCEDURE sp_board_help_delete(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    DELETE FROM SYS_HELP
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = p_gs_lang;
END//

-- ============================================================
-- 5. 도움말 조회수 증가
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_update_read_cnt//

CREATE PROCEDURE sp_board_help_update_read_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    UPDATE SYS_HELP
    SET READ_CNT = READ_CNT + 1
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = p_gs_lang;
END//

-- ============================================================
-- 6. 도움말 비활성화
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_update_disable//

CREATE PROCEDURE sp_board_help_update_disable(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_HELP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        USE_FLAG = 'N'
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = p_gs_lang;
END//

-- ============================================================
-- 7. 메뉴 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_get_menu_list//

CREATE PROCEDURE sp_board_help_get_menu_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT
        SYS_ID,
        MENU_KEY,
        MENU_DESC
    FROM SYS_MENU
    WHERE SYS_ID = p_sys_id
      AND MENU_URL != '#'
    ORDER BY MENU_KEY ASC;
END//

-- ============================================================
-- 8. 등록 체크
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_get_insert_chk//

CREATE PROCEDURE sp_board_help_get_insert_chk(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(200),
    IN p_bord_type VARCHAR(20),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT COUNT(1) AS CNT
    FROM SYS_HELP
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND BORD_TITLE = p_bord_title
      AND BORD_TYPE = p_bord_type
      AND SYS_LANG = p_gs_lang;
END//

-- ============================================================
-- 9. 도움말 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_get_help_list//

CREATE PROCEDURE sp_board_help_get_help_list(
    IN p_sys_id VARCHAR(20),
    IN p_emenukey VARCHAR(100),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT
        SYS_ID AS "sysId",
        BORD_NO AS "bordNo",
        BORD_GRUP AS "bordGrup",
        BORD_TITLE AS "bordTitle",
        (SELECT MENU_DESC FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = BORD_TITLE) AS "bordTitle2",
        BORD_TYPE AS "bordType",
        BORD_BGN AS "bordBgn",
        BORD_END AS "bordEnd",
        READ_CNT AS "readCnt",
        BORD_SEQ AS "bordSeq",
        BORD_PNO AS "bordPno",
        OPEN_TYPE AS "openType",
        USE_FLAG AS "useFlag",
        REGI_ID AS "regiId",
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS "regiDate",
        CHNG_ID AS "chngId",
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS "chngDate",
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS "regiName",
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS "chngName",
        BORD_TEXT AS "bordText",
        'HELPVIEW' AS "gubun"
    FROM SYS_HELP A
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = 'B10'
      AND BORD_TYPE = 'HEP'
      AND SYS_LANG = p_gs_lang
      AND BORD_NO = (SELECT BORD_NO FROM SYS_HELP WHERE SYS_ID = p_sys_id AND SYS_LANG = p_gs_lang AND BORD_GRUP = 'B10' AND BORD_TITLE = p_emenukey AND BORD_TYPE = 'HEP');
END//

-- ============================================================
-- 10. 타겟 읽음 처리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_update_target_read//

CREATE PROCEDURE sp_board_help_update_target_read(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET READ_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 11. 타겟 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_update_target//

CREATE PROCEDURE sp_board_help_update_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_vndr_code VARCHAR(50),
    IN p_vndr_name VARCHAR(100),
    IN p_save_idx VARCHAR(50),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        VNDR_CODE = CASE WHEN p_vndr_code IS NOT NULL AND p_vndr_code != '' THEN p_vndr_code ELSE VNDR_CODE END,
        VNDR_NAME = CASE WHEN p_vndr_name IS NOT NULL AND p_vndr_name != '' THEN p_vndr_name ELSE VNDR_NAME END,
        SAVE_IDX = CASE WHEN p_save_idx IS NOT NULL AND p_save_idx != '' THEN p_save_idx ELSE SAVE_IDX END,
        USE_FLAG = CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN p_use_flag ELSE USE_FLAG END
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 12. 타겟 비활성화
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_update_target_disable//

CREATE PROCEDURE sp_board_help_update_target_disable(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        USE_FLAG = 'N'
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 13. 타겟 전체 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_help_delete_target_all//

CREATE PROCEDURE sp_board_help_delete_target_all(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD_TGT
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup;
END//

DELIMITER ;
