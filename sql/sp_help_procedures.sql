-- ============================================================
-- Help.xml (도움말 관리) -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 테이블: SYS_HELP, SYS_BORD_TGT
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 도움말 관리 (SYS_HELP)
-- ============================================================

-- [sp_help_search] 도움말 목록 조회 (페이징 및 동적 검색)
DROP PROCEDURE IF EXISTS sp_help_search//
CREATE PROCEDURE sp_help_search(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_use_flag VARCHAR(1),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text LONGTEXT,
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(10),
    IN p_bord_end VARCHAR(10),
    IN p_open_type VARCHAR(10),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_bord_pno VARCHAR(20),
    IN p_today_yn VARCHAR(1),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- 정렬 조건 설정 (gsSorts -> p_sort_clause)
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'A.BORD_SEQ ASC, A.REGI_DATE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID        AS sysId,
                    A.BORD_NO       AS bordNo,
                    A.BORD_GRUP     AS bordGrup,
                    (SELECT MENU_DESC FROM SYS_MENU WHERE SYS_ID = '", p_sys_id, "' AND MENU_KEY = A.BORD_TITLE) AS bordTitle,
                    A.BORD_TYPE     AS bordType,
                    A.BORD_BGN      AS bordBgn,
                    A.BORD_END      AS bordEnd,
                    A.READ_CNT      AS readCnt,
                    A.BORD_SEQ      AS bordSeq,
                    A.BORD_PNO      AS bordPno,
                    A.OPEN_TYPE     AS openType,
                    A.USE_FLAG      AS useFlag,
                    A.REGI_ID       AS regiId,
                    DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID       AS chngId,
                    DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
                    A.BORD_NO       AS id,
                    A.BORD_PNO      AS parentId,
                    CASE WHEN (SELECT COUNT(*) FROM SYS_HELP WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND SYS_LANG = '", IFNULL(p_gs_lang,'en'), "') = 0 THEN 'open' ELSE 'closed' END AS state
                FROM SYS_HELP A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.BORD_GRUP = '", p_bord_grup, "'
                  AND A.SYS_LANG = '", IFNULL(p_gs_lang,'en'), "'
                  AND (CASE WHEN '", IFNULL(p_use_flag,''), "' != '' THEN A.USE_FLAG = '", IFNULL(p_use_flag,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_regi_id,''), "' != '' THEN A.REGI_ID = '", IFNULL(p_regi_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_title,''), "' != '' THEN A.BORD_TITLE LIKE CONCAT('%','", IFNULL(p_bord_title,''), "','%') ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_type,''), "' != '' THEN A.BORD_TYPE = '", IFNULL(p_bord_type,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_bgn,''), "' != '' THEN A.BORD_BGN = '", IFNULL(p_bord_bgn,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_end,''), "' != '' THEN A.BORD_END = '", IFNULL(p_bord_end,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_open_type,''), "' != '' THEN A.OPEN_TYPE = '", IFNULL(p_open_type,''), "' ELSE 1=1 END)
                  AND (CASE
                        WHEN '", IFNULL(p_search_key,''), "' = 'S01' AND '", IFNULL(p_search_text,''), "' != '' THEN A.BORD_TITLE LIKE CONCAT('%','", IFNULL(p_search_text,''), "','%')
                        WHEN '", IFNULL(p_search_key,''), "' = 'S02' AND '", IFNULL(p_search_text,''), "' != '' THEN A.BORD_TEXT LIKE CONCAT('%','", IFNULL(p_search_text,''), "','%')
                        WHEN '", IFNULL(p_search_key,''), "' = 'S03' AND '", IFNULL(p_search_text,''), "' != '' THEN EXISTS (SELECT 1 FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID AND USER_NAME LIKE CONCAT('%','", IFNULL(p_search_text,''), "','%'))
                        ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_pno,''), "' != '' THEN A.BORD_PNO = '", IFNULL(p_bord_pno,''), "' ELSE A.BORD_PNO IS NULL END)
                  AND (CASE WHEN '", IFNULL(p_bord_grup,''), "' = 'B04' THEN
                        ((A.USE_FLAG = 'Y') OR (A.USE_FLAG = 'N' AND (SELECT COUNT(*) FROM SYS_HELP WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = 'Y' AND SYS_LANG = '", IFNULL(p_gs_lang,'en'), "') > 0))
                        ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_today_yn,''), "' = 'Y' THEN DATE_FORMAT(NOW(),'%Y-%m-%d') BETWEEN A.BORD_BGN AND A.BORD_END ELSE 1=1 END)
                ORDER BY ", @sort_order, "
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- [sp_help_search_count] 도움말 목록 카운트
DROP PROCEDURE IF EXISTS sp_help_search_count//
CREATE PROCEDURE sp_help_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_use_flag VARCHAR(1),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text LONGTEXT,
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(10),
    IN p_bord_end VARCHAR(10),
    IN p_open_type VARCHAR(10),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_bord_pno VARCHAR(20),
    IN p_today_yn VARCHAR(1)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_HELP A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.SYS_LANG = IFNULL(p_gs_lang, 'en')
      AND (CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN A.USE_FLAG = p_use_flag ELSE 1=1 END)
      AND (CASE WHEN p_regi_id IS NOT NULL AND p_regi_id != '' THEN A.REGI_ID = p_regi_id ELSE 1=1 END)
      AND (CASE WHEN p_bord_title IS NOT NULL AND p_bord_title != '' THEN A.BORD_TITLE LIKE CONCAT('%', p_bord_title, '%') ELSE 1=1 END)
      AND (CASE WHEN p_bord_type IS NOT NULL AND p_bord_type != '' THEN A.BORD_TYPE = p_bord_type ELSE 1=1 END)
      AND (CASE WHEN p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN A.BORD_BGN = p_bord_bgn ELSE 1=1 END)
      AND (CASE WHEN p_bord_end IS NOT NULL AND p_bord_end != '' THEN A.BORD_END = p_bord_end ELSE 1=1 END)
      AND (CASE WHEN p_open_type IS NOT NULL AND p_open_type != '' THEN A.OPEN_TYPE = p_open_type ELSE 1=1 END)
      AND (CASE
            WHEN p_search_key = 'S01' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.BORD_TITLE LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S02' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.BORD_TEXT LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S03' AND p_search_text IS NOT NULL AND p_search_text != '' THEN EXISTS (SELECT 1 FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID AND USER_NAME LIKE CONCAT('%', p_search_text, '%'))
            ELSE 1=1 END)
      AND (CASE WHEN p_bord_pno IS NOT NULL AND p_bord_pno != '' THEN A.BORD_PNO = p_bord_pno ELSE A.BORD_PNO IS NULL END)
      AND (CASE WHEN p_bord_grup = 'B04' THEN
            ((A.USE_FLAG = 'Y') OR (A.USE_FLAG = 'N' AND (SELECT COUNT(*) FROM SYS_HELP WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = 'Y' AND SYS_LANG = IFNULL(p_gs_lang, 'en')) > 0))
            ELSE 1=1 END)
      AND (CASE WHEN p_today_yn = 'Y' THEN DATE_FORMAT(NOW(),'%Y-%m-%d') BETWEEN A.BORD_BGN AND A.BORD_END ELSE 1=1 END);
END//

-- [sp_help_select] 도움말 상세 조회
DROP PROCEDURE IF EXISTS sp_help_select//
CREATE PROCEDURE sp_help_select(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_menukey VARCHAR(100),
    IN p_bord_type VARCHAR(10)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_NO       AS bordNo,
        A.BORD_GRUP     AS bordGrup,
        A.BORD_TITLE    AS bordTitle,
        (SELECT MENU_DESC FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = A.BORD_TITLE) AS bordTitle2,
        A.BORD_TYPE     AS bordType,
        A.BORD_BGN      AS bordBgn,
        A.BORD_END      AS bordEnd,
        A.READ_CNT      AS readCnt,
        A.BORD_SEQ      AS bordSeq,
        A.BORD_PNO      AS bordPno,
        A.OPEN_TYPE     AS openType,
        A.USE_FLAG      AS useFlag,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
        A.BORD_NO       AS id,
        A.BORD_PNO      AS parentId,
        CASE WHEN (SELECT COUNT(*) FROM SYS_HELP WHERE SYS_ID = A.SYS_ID AND BORD_PNO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP AND SYS_LANG = IFNULL(p_gs_lang,'en')) = 0 THEN 'open' ELSE 'closed' END AS state,
        A.BORD_TEXT     AS bordText
    FROM SYS_HELP A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.SYS_LANG = IFNULL(p_gs_lang, 'en')
      AND (CASE
            WHEN p_menukey IS NOT NULL AND p_menukey != '' THEN
                A.BORD_NO = (SELECT BORD_NO FROM SYS_HELP WHERE SYS_ID = p_sys_id AND SYS_LANG = IFNULL(p_gs_lang,'en') AND BORD_GRUP = p_bord_grup AND BORD_TITLE = p_menukey AND BORD_TYPE = p_bord_type)
            ELSE A.BORD_NO = p_bord_no
           END);
END//

-- [sp_help_insert] 도움말 등록
DROP PROCEDURE IF EXISTS sp_help_insert//
CREATE PROCEDURE sp_help_insert(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(200),
    IN p_gs_lang VARCHAR(10),
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(10),
    IN p_bord_end VARCHAR(10),
    IN p_bord_pno VARCHAR(20),
    IN p_open_type VARCHAR(10),
    IN p_bord_text LONGTEXT,
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_bord_no VARCHAR(20);

    -- BORD_NO 생성
    SELECT CONCAT('B', LPAD(CAST(IFNULL(SUBSTR(MAX(BORD_NO),2,9),'0') AS UNSIGNED)+1, 9, '0'))
    INTO v_bord_no
    FROM SYS_HELP
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = IFNULL(p_gs_lang, 'en');

    INSERT INTO SYS_HELP (
        SYS_ID, BORD_NO, BORD_GRUP, BORD_TITLE, READ_CNT, BORD_SEQ, USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE, SYS_LANG,
        BORD_TYPE, BORD_BGN, BORD_END, BORD_PNO, OPEN_TYPE, BORD_TEXT
    ) VALUES (
        p_sys_id, v_bord_no, p_bord_grup, p_bord_title, 0, 999999999, 'Y', p_gs_user_id, NOW(), p_gs_user_id, NOW(), IFNULL(p_gs_lang, 'en'),
        p_bord_type, p_bord_bgn, p_bord_end, p_bord_pno, p_open_type, p_bord_text
    );

    -- 생성된 BORD_NO 반환
    SELECT v_bord_no AS bordNo;
END//

-- [sp_help_update] 도움말 수정
DROP PROCEDURE IF EXISTS sp_help_update//
CREATE PROCEDURE sp_help_update(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text LONGTEXT,
    IN p_bord_type VARCHAR(10),
    IN p_bord_bgn VARCHAR(10),
    IN p_bord_end VARCHAR(10),
    IN p_read_cnt INT,
    IN p_bord_seq INT,
    IN p_use_flag VARCHAR(1),
    IN p_open_type VARCHAR(10),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_HELP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        BORD_TITLE = IFNULL(p_bord_title, BORD_TITLE),
        BORD_TEXT = IFNULL(p_bord_text, BORD_TEXT),
        BORD_TYPE = IFNULL(p_bord_type, BORD_TYPE),
        BORD_BGN = IFNULL(p_bord_bgn, BORD_BGN),
        BORD_END = IFNULL(p_bord_end, BORD_END),
        READ_CNT = IFNULL(p_read_cnt, READ_CNT),
        BORD_SEQ = IFNULL(p_bord_seq, BORD_SEQ),
        USE_FLAG = IFNULL(p_use_flag, USE_FLAG),
        OPEN_TYPE = IFNULL(p_open_type, OPEN_TYPE)
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup
      AND SYS_LANG = IFNULL(p_gs_lang, 'en');
END//

-- [sp_help_delete] 도움말 삭제
DROP PROCEDURE IF EXISTS sp_help_delete//
CREATE PROCEDURE sp_help_delete(
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
      AND SYS_LANG = IFNULL(p_gs_lang, 'en');
END//

-- [sp_help_update_read_cnt] 조회수 증가
DROP PROCEDURE IF EXISTS sp_help_update_read_cnt//
CREATE PROCEDURE sp_help_update_read_cnt(
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
      AND SYS_LANG = IFNULL(p_gs_lang, 'en');
END//

-- [sp_help_update_disable] 도움말 비활성화 처리
DROP PROCEDURE IF EXISTS sp_help_update_disable//
CREATE PROCEDURE sp_help_update_disable(
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
      AND SYS_LANG = IFNULL(p_gs_lang, 'en');
END//

-- ============================================================
-- 2. 대상자 관리 (SYS_BORD_TGT for Help)
-- ============================================================

-- [sp_help_search_target] 대상자 목록 조회
DROP PROCEDURE IF EXISTS sp_help_search_target//
CREATE PROCEDURE sp_help_search_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_use_flag VARCHAR(1),
    IN p_bord_no VARCHAR(20),
    IN p_vndr_code VARCHAR(20),
    IN p_vndr_name VARCHAR(100),
    IN p_save_idx INT,
    IN p_page_type VARCHAR(1),
    IN p_gs_user_id VARCHAR(50),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- 정렬 조건 설정 (gsSorts -> p_sort_clause)
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'B.BORD_SEQ ASC, A.REGI_DATE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID        AS sysId,
                    A.BORD_NO       AS bordNo,
                    A.BORD_GRUP     AS bordGrup,
                    A.TGT_USER_ID   AS tgtUserId,
                    A.VNDR_CODE     AS vndrCode,
                    A.VNDR_NAME     AS vndrName,
                    A.SAVE_IDX      AS saveIdx,
                    DATE_FORMAT(A.READ_DATE,'%Y-%m-%d %H:%i:%s') AS readDate,
                    A.USE_FLAG      AS useFlag,
                    A.REGI_ID       AS regiId,
                    DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID       AS chngId,
                    DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
                    B.BORD_TITLE    AS bordTitle,
                    B.BORD_TYPE     AS bordType,
                    B.BORD_BGN      AS bordBgn,
                    B.BORD_END      AS bordEnd,
                    B.READ_CNT      AS readCnt,
                    B.BORD_SEQ      AS bordSeq,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
                    (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.TGT_USER_ID) AS tgtName
                FROM SYS_BORD_TGT A
                INNER JOIN SYS_HELP B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP AND B.SYS_LANG = '", IFNULL(p_gs_lang,'en'), "'
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.BORD_GRUP = '", p_bord_grup, "'
                  AND (CASE WHEN '", IFNULL(p_use_flag,''), "' != '' THEN A.USE_FLAG = '", IFNULL(p_use_flag,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_no,''), "' != '' THEN A.BORD_NO = '", IFNULL(p_bord_no,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_vndr_code,''), "' != '' THEN A.VNDR_CODE = '", IFNULL(p_vndr_code,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_vndr_name,''), "' != '' THEN A.VNDR_NAME = '", IFNULL(p_vndr_name,''), "' ELSE 1=1 END)
                  AND (CASE WHEN ", IFNULL(p_save_idx, 'NULL'), " IS NOT NULL THEN A.SAVE_IDX = ", IFNULL(p_save_idx, 0), " ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_page_type,''), "' = 'R' THEN A.TGT_USER_ID = '", IFNULL(p_gs_user_id,''), "'
                            WHEN '", IFNULL(p_page_type,''), "' = 'S' THEN A.REGI_ID = '", IFNULL(p_gs_user_id,''), "' ELSE 1=1 END)
                ORDER BY ", @sort_order, "
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- [sp_help_search_target_count] 대상자 목록 카운트
DROP PROCEDURE IF EXISTS sp_help_search_target_count//
CREATE PROCEDURE sp_help_search_target_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_use_flag VARCHAR(1),
    IN p_bord_no VARCHAR(20),
    IN p_vndr_code VARCHAR(20),
    IN p_vndr_name VARCHAR(100),
    IN p_save_idx INT,
    IN p_page_type VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD_TGT A
    INNER JOIN SYS_HELP B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP AND B.SYS_LANG = IFNULL(p_gs_lang, 'en')
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND (CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN A.USE_FLAG = p_use_flag ELSE 1=1 END)
      AND (CASE WHEN p_bord_no IS NOT NULL AND p_bord_no != '' THEN A.BORD_NO = p_bord_no ELSE 1=1 END)
      AND (CASE WHEN p_vndr_code IS NOT NULL AND p_vndr_code != '' THEN A.VNDR_CODE = p_vndr_code ELSE 1=1 END)
      AND (CASE WHEN p_vndr_name IS NOT NULL AND p_vndr_name != '' THEN A.VNDR_NAME = p_vndr_name ELSE 1=1 END)
      AND (CASE WHEN p_save_idx IS NOT NULL THEN A.SAVE_IDX = p_save_idx ELSE 1=1 END)
      AND (CASE WHEN p_page_type = 'R' THEN A.TGT_USER_ID = p_gs_user_id
                WHEN p_page_type = 'S' THEN A.REGI_ID = p_gs_user_id ELSE 1=1 END);
END//

-- [sp_help_select_target] 대상자 단건 조회
DROP PROCEDURE IF EXISTS sp_help_select_target//
CREATE PROCEDURE sp_help_select_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_tgt_user_id VARCHAR(50),
    IN p_use_flag VARCHAR(1)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_NO       AS bordNo,
        A.BORD_GRUP     AS bordGrup,
        A.TGT_USER_ID   AS tgtUserId,
        A.VNDR_CODE     AS vndrCode,
        A.VNDR_NAME     AS vndrName,
        A.SAVE_IDX      AS saveIdx,
        DATE_FORMAT(A.READ_DATE,'%Y-%m-%d %H:%i:%s') AS readDate,
        A.USE_FLAG      AS useFlag,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        B.BORD_TITLE    AS bordTitle,
        B.BORD_TYPE     AS bordType,
        B.BORD_BGN      AS bordBgn,
        B.BORD_END      AS bordEnd,
        B.READ_CNT      AS readCnt,
        B.BORD_SEQ      AS bordSeq,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.TGT_USER_ID) AS tgtName,
        B.BORD_TEXT     AS bordText
    FROM SYS_BORD_TGT A
    INNER JOIN SYS_HELP B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP AND B.SYS_LANG = IFNULL(p_gs_lang, 'en')
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_NO = p_bord_no
      AND A.BORD_GRUP = p_bord_grup
      AND A.TGT_USER_ID = p_tgt_user_id
      AND (CASE WHEN p_use_flag IS NOT NULL THEN A.USE_FLAG = p_use_flag ELSE 1=1 END);
END//

-- [sp_help_insert_target] 대상자 등록
DROP PROCEDURE IF EXISTS sp_help_insert_target//
CREATE PROCEDURE sp_help_insert_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_targets TEXT,
    IN p_gs_user_id VARCHAR(50),
    IN p_read_yn VARCHAR(1)
)
BEGIN
    INSERT INTO SYS_BORD_TGT (
        SYS_ID, BORD_NO, BORD_GRUP, TGT_USER_ID, VNDR_CODE, VNDR_NAME, USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE, READ_DATE
    )
    SELECT p_sys_id, p_bord_no, p_bord_grup, A.USER_ID, A.DEPT_CODE,
           IFNULL(A.DEPT_NAME, fn_get_code_name('DEPT_CODE', A.DEPT_CODE, IFNULL(p_gs_lang, 'en'))),
           'Y', p_gs_user_id, NOW(), p_gs_user_id, NOW(),
           (CASE WHEN p_read_yn = 'Y' THEN NOW() ELSE NULL END)
    FROM SYS_USER A
    WHERE A.SYS_ID = p_sys_id
      AND ((p_targets IS NULL AND A.USER_ID = p_gs_user_id) OR (p_targets IS NOT NULL AND FIND_IN_SET(A.USER_ID, p_targets)));
END//

-- [sp_help_update_target] 대상자 정보 수정
DROP PROCEDURE IF EXISTS sp_help_update_target//
CREATE PROCEDURE sp_help_update_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_vndr_code VARCHAR(20),
    IN p_vndr_name VARCHAR(100),
    IN p_save_idx INT,
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        VNDR_CODE = IFNULL(p_vndr_code, VNDR_CODE),
        VNDR_NAME = IFNULL(p_vndr_name, VNDR_NAME),
        SAVE_IDX = IFNULL(p_save_idx, SAVE_IDX),
        USE_FLAG = IFNULL(p_use_flag, USE_FLAG)
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup AND TGT_USER_ID = p_tgt_user_id;
END//

-- [sp_help_update_target_disable] 대상자 비활성화 처리
DROP PROCEDURE IF EXISTS sp_help_update_target_disable//
CREATE PROCEDURE sp_help_update_target_disable(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
    SET CHNG_ID = p_gs_user_id, CHNG_DATE = NOW(), USE_FLAG = 'N'
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup AND TGT_USER_ID = p_tgt_user_id;
END//

-- [sp_help_delete_target_all] 대상자 일괄 삭제
DROP PROCEDURE IF EXISTS sp_help_delete_target_all//
CREATE PROCEDURE sp_help_delete_target_all(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD_TGT WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//

-- [sp_help_update_target_read] 대상자 읽음 처리
DROP PROCEDURE IF EXISTS sp_help_update_target_read//
CREATE PROCEDURE sp_help_update_target_read(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT SET READ_DATE = NOW()
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup AND TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 3. 기타 조회 (Help specific)
-- ============================================================

-- [sp_help_get_menu_list] 메뉴 목록 조회
DROP PROCEDURE IF EXISTS sp_help_get_menu_list//
CREATE PROCEDURE sp_help_get_menu_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT SYS_ID, MENU_KEY, MENU_DESC
    FROM SYS_MENU
    WHERE SYS_ID = p_sys_id
      AND MENU_URL != '#'
    ORDER BY MENU_KEY ASC;
END//

-- [sp_help_get_insert_chk] 등록 중복 체크
DROP PROCEDURE IF EXISTS sp_help_get_insert_chk//
CREATE PROCEDURE sp_help_get_insert_chk(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(200),
    IN p_bord_type VARCHAR(10),
    IN p_gs_lang VARCHAR(10)
)
BEGIN
    SELECT COUNT(1) AS CNT
    FROM SYS_HELP
    WHERE SYS_ID = p_sys_id
      AND BORD_GRUP = p_bord_grup
      AND BORD_TITLE = p_bord_title
      AND BORD_TYPE = p_bord_type
      AND SYS_LANG = IFNULL(p_gs_lang, 'en');
END//

-- [sp_help_get_help_list] 헬프 뷰 목록 조회
DROP PROCEDURE IF EXISTS sp_help_get_help_list//
CREATE PROCEDURE sp_help_get_help_list(
    IN p_sys_id VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_emenukey VARCHAR(100)
)
BEGIN
    SELECT
        A.SYS_ID        AS sysId,
        A.BORD_NO       AS bordNo,
        A.BORD_GRUP     AS bordGrup,
        A.BORD_TITLE    AS bordTitle,
        (SELECT MENU_DESC FROM SYS_MENU WHERE SYS_ID = p_sys_id AND MENU_KEY = A.BORD_TITLE) AS bordTitle2,
        A.BORD_TYPE     AS bordType,
        A.BORD_BGN      AS bordBgn,
        A.BORD_END      AS bordEnd,
        A.READ_CNT      AS readCnt,
        A.BORD_SEQ      AS bordSeq,
        A.BORD_PNO      AS bordPno,
        A.OPEN_TYPE     AS openType,
        A.USE_FLAG      AS useFlag,
        A.REGI_ID       AS regiId,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID       AS chngId,
        DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName,
        A.BORD_TEXT     AS bordText,
        'HELPVIEW'      AS gubun
    FROM SYS_HELP A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = 'B10'
      AND A.BORD_TYPE = 'HEP'
      AND A.SYS_LANG = IFNULL(p_gs_lang, 'en')
      AND A.BORD_NO = (SELECT BORD_NO FROM SYS_HELP WHERE SYS_ID = p_sys_id AND SYS_LANG = IFNULL(p_gs_lang, 'en') AND BORD_GRUP = 'B10' AND BORD_TITLE = p_emenukey AND BORD_TYPE = 'HEP');
END//

DELIMITER ;
