-- ============================================================
-- BoardManagement.xml -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 파일: sp_board_management_procedures.sql
-- 대상: 게시판 관리 (SYS_BORD)
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 게시판 목록 조회 (search)
-- ============================================================

-- [sp_board_management_search] 게시판 목록 조회 (페이징 및 동적 검색)
DROP PROCEDURE IF EXISTS sp_board_management_search//
CREATE PROCEDURE sp_board_management_search(
    IN p_sys_id VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_code_grup VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text LONGTEXT,
    IN p_bord_type VARCHAR(20),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_open_type VARCHAR(20),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_sort_clause VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- 정렬 조건 설정 (gsSorts -> p_sort_clause)
    SET @sort_order = IF(p_sort_clause IS NOT NULL AND p_sort_clause != '', p_sort_clause, 'A.REGI_DATE DESC, A.BORD_SEQ ASC');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID AS sysId,
                    A.BORD_GRUP AS bordGrup,
                    fn_get_code_name('BORD_GRUP', A.BORD_GRUP, '", IFNULL(p_gs_lang, 'en'), "') AS codeName,
                    A.BORD_NO AS bordNo,
                    A.BORD_TITLE AS bordTitle,
                    A.BORD_TYPE AS bordType,
                    A.BORD_BGN AS bordBgn,
                    A.BORD_END AS bordEnd,
                    A.READ_CNT AS readCnt,
                    A.BORD_SEQ AS bordSeq,
                    A.USE_FLAG AS useFlag,
                    A.REGI_ID AS regiId,
                    DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID AS chngId,
                    DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
                    A.BORD_PNO AS bordPno,
                    A.OPEN_TYPE AS openType,
                    0 AS rnum
                FROM SYS_BORD A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND A.USE_FLAG = 'Y'
                  AND A.BORD_TYPE = 'ALL'
                  AND (CASE WHEN '", IFNULL(p_code_grup, ''), "' != '' AND '", IFNULL(p_code_grup, ''), "' != 'ALL' THEN A.BORD_GRUP = '", IFNULL(p_code_grup, ''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_use_flag, ''), "' != '' THEN A.USE_FLAG = '", IFNULL(p_use_flag, ''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_regi_id, ''), "' != '' THEN A.REGI_ID = '", IFNULL(p_regi_id, ''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_title, ''), "' != '' THEN A.BORD_TITLE LIKE CONCAT('%', '", IFNULL(p_bord_title, ''), "', '%') ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_text, ''), "' != '' THEN A.BORD_TEXT LIKE CONCAT('%', '", IFNULL(p_bord_text, ''), "', '%') ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_type, ''), "' != '' THEN A.BORD_TYPE = '", IFNULL(p_bord_type, ''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_bgn, ''), "' != '' THEN A.BORD_BGN = '", IFNULL(p_bord_bgn, ''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_bord_end, ''), "' != '' THEN A.BORD_END = '", IFNULL(p_bord_end, ''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_open_type, ''), "' != '' THEN A.OPEN_TYPE = '", IFNULL(p_open_type, ''), "' ELSE 1=1 END)
                  AND (CASE
                        WHEN '", IFNULL(p_search_key, ''), "' = 'S01' AND '", IFNULL(p_search_text, ''), "' != '' THEN A.BORD_TITLE LIKE CONCAT('%', '", IFNULL(p_search_text, ''), "', '%')
                        WHEN '", IFNULL(p_search_key, ''), "' = 'S02' AND '", IFNULL(p_search_text, ''), "' != '' THEN A.BORD_TEXT LIKE CONCAT('%', '", IFNULL(p_search_text, ''), "', '%')
                        WHEN '", IFNULL(p_search_key, ''), "' = 'S03' AND '", IFNULL(p_search_text, ''), "' != '' THEN EXISTS (
                            SELECT 1 FROM SYS_USER
                            WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID
                              AND USER_NAME LIKE CONCAT('%', '", IFNULL(p_search_text, ''), "', '%')
                        )
                        ELSE 1=1 END)
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


-- ============================================================
-- 2. 게시판 카운트 (searchCount)
-- ============================================================

-- [sp_board_management_search_count] 게시판 목록 카운트
DROP PROCEDURE IF EXISTS sp_board_management_search_count//
CREATE PROCEDURE sp_board_management_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_code_grup VARCHAR(20),
    IN p_use_flag VARCHAR(1),
    IN p_regi_id VARCHAR(50),
    IN p_bord_title VARCHAR(200),
    IN p_bord_text LONGTEXT,
    IN p_bord_type VARCHAR(20),
    IN p_bord_bgn VARCHAR(20),
    IN p_bord_end VARCHAR(20),
    IN p_open_type VARCHAR(20),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD A
    WHERE A.SYS_ID = p_sys_id
      AND A.USE_FLAG = 'Y'
      AND A.BORD_TYPE = 'ALL'
      AND (CASE WHEN p_code_grup IS NOT NULL AND p_code_grup != '' AND p_code_grup != 'ALL' THEN A.BORD_GRUP = p_code_grup ELSE 1=1 END)
      AND (CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN A.USE_FLAG = p_use_flag ELSE 1=1 END)
      AND (CASE WHEN p_regi_id IS NOT NULL AND p_regi_id != '' THEN A.REGI_ID = p_regi_id ELSE 1=1 END)
      AND (CASE WHEN p_bord_title IS NOT NULL AND p_bord_title != '' THEN A.BORD_TITLE LIKE CONCAT('%', p_bord_title, '%') ELSE 1=1 END)
      AND (CASE WHEN p_bord_text IS NOT NULL AND p_bord_text != '' THEN A.BORD_TEXT LIKE CONCAT('%', p_bord_text, '%') ELSE 1=1 END)
      AND (CASE WHEN p_bord_type IS NOT NULL AND p_bord_type != '' THEN A.BORD_TYPE = p_bord_type ELSE 1=1 END)
      AND (CASE WHEN p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN A.BORD_BGN = p_bord_bgn ELSE 1=1 END)
      AND (CASE WHEN p_bord_end IS NOT NULL AND p_bord_end != '' THEN A.BORD_END = p_bord_end ELSE 1=1 END)
      AND (CASE WHEN p_open_type IS NOT NULL AND p_open_type != '' THEN A.OPEN_TYPE = p_open_type ELSE 1=1 END)
      AND (CASE
            WHEN p_search_key = 'S01' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.BORD_TITLE LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S02' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.BORD_TEXT LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S03' AND p_search_text IS NOT NULL AND p_search_text != '' THEN EXISTS (
                SELECT 1 FROM SYS_USER
                WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID
                  AND USER_NAME LIKE CONCAT('%', p_search_text, '%')
            )
            ELSE 1=1 END);
END//


-- ============================================================
-- 3. 게시판 상세 조회 (select)
-- ============================================================

-- [sp_board_management_select] 게시판 상세 조회
DROP PROCEDURE IF EXISTS sp_board_management_select//
CREATE PROCEDURE sp_board_management_select(
    IN p_sys_id VARCHAR(20),
    IN p_gs_lang VARCHAR(10),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_board_seq INT
)
BEGIN
    SELECT
        A.SYS_ID AS sysId,
        A.BORD_GRUP AS bordGrup,
        fn_get_code_name('BORD_GRUP', A.BORD_GRUP, p_gs_lang) AS codeName,
        A.BORD_NO AS bordNo,
        A.BORD_TITLE AS bordTitle,
        A.BORD_TYPE AS bordType,
        A.BORD_BGN AS bordBgn,
        A.BORD_END AS bordEnd,
        A.READ_CNT AS readCnt,
        A.BORD_SEQ AS bordSeq,
        A.USE_FLAG AS useFlag,
        A.REGI_ID AS regiId,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID AS chngId,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        A.BORD_PNO AS bordPno,
        A.OPEN_TYPE AS openType,
        A.BORD_TEXT AS bordText
    FROM SYS_BORD A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_NO = p_bord_no
      AND A.BORD_GRUP = p_bord_grup
      AND A.BORD_SEQ = p_board_seq;
END//


-- ============================================================
-- 4. 게시판 수정 (update)
-- ============================================================

-- [sp_board_management_update] 게시판 수정 (순서 변경)
DROP PROCEDURE IF EXISTS sp_board_management_update//
CREATE PROCEDURE sp_board_management_update(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_seq INT,
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD
    SET BORD_SEQ = p_bord_seq,
        CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup;
END//


-- ============================================================
-- 5. 게시판 삭제 (delete)
-- ============================================================

-- [sp_board_management_delete] 게시판 삭제
DROP PROCEDURE IF EXISTS sp_board_management_delete//
CREATE PROCEDURE sp_board_management_delete(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD
    WHERE SYS_ID = p_sys_id
      AND BORD_NO = p_bord_no
      AND BORD_GRUP = p_bord_grup;
END//


-- ============================================================
-- 6. 게시판 타입 코드 조회 (getBordTypeCode)
-- ============================================================

-- [sp_board_management_get_bord_type_code] 게시판 타입 코드 조회
DROP PROCEDURE IF EXISTS sp_board_management_get_bord_type_code//
CREATE PROCEDURE sp_board_management_get_bord_type_code(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CODE_CD AS codeCd,
           CODE_NAME AS codeName
    FROM SYS_CODE
    WHERE SYS_ID = p_sys_id
      AND CODE_GRUP = 'BORD_GRUP'
      AND USE_FLAG = 'Y'
    ORDER BY SORT_SEQ ASC;
END//


DELIMITER ;
