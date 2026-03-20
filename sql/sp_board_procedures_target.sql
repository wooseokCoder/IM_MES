-- ============================================================
-- Board.xml (대상자 관리) -> 프로시저 전환 스크립트
-- 생성일: 2026-01-14
-- 파일 2/3: 대상자(SYS_BORD_TGT) 관련
-- ============================================================

DELIMITER //

-- ============================================================
-- 2. 대상자 관리 (SYS_BORD_TGT)
-- ============================================================

-- [sp_board_search_target] 대상자 목록 조회
DROP PROCEDURE IF EXISTS sp_board_search_target//
CREATE PROCEDURE sp_board_search_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
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
                INNER JOIN SYS_BORD B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP
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

-- [sp_board_search_target_count] 대상자 목록 카운트
DROP PROCEDURE IF EXISTS sp_board_search_target_count//
CREATE PROCEDURE sp_board_search_target_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
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
    INNER JOIN SYS_BORD B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP
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

-- [sp_board_select_target] 대상자 단건 조회
DROP PROCEDURE IF EXISTS sp_board_select_target//
CREATE PROCEDURE sp_board_select_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
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
    INNER JOIN SYS_BORD B ON B.SYS_ID = A.SYS_ID AND B.BORD_NO = A.BORD_NO AND B.BORD_GRUP = A.BORD_GRUP
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_NO = p_bord_no
      AND A.BORD_GRUP = p_bord_grup
      AND A.TGT_USER_ID = p_tgt_user_id
      AND (CASE WHEN p_use_flag IS NOT NULL THEN A.USE_FLAG = p_use_flag ELSE 1=1 END);
END//

-- [sp_board_insert_target] 대상자 등록
DROP PROCEDURE IF EXISTS sp_board_insert_target//
CREATE PROCEDURE sp_board_insert_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_targets TEXT,
    IN p_gs_user_id VARCHAR(50),
    IN p_read_yn VARCHAR(1)
)
BEGIN
    INSERT INTO SYS_BORD_TGT (
        SYS_ID, BORD_NO, BORD_GRUP, TGT_USER_ID, VNDR_CODE, VNDR_NAME, USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE, READ_DATE
    )
    SELECT p_sys_id, p_bord_no, p_bord_grup, A.USER_ID, A.DEPT_CODE,
           IFNULL(A.DEPT_NAME, (SELECT CODE_NAME FROM SYS_CODE WHERE SYS_ID = A.SYS_ID AND CODE_CD = A.DEPT_CODE AND CODE_GRUP = 'DEPT_CODE')),
           'Y', p_gs_user_id, NOW(), p_gs_user_id, NOW(),
           (CASE WHEN p_read_yn = 'Y' THEN NOW() ELSE NULL END)
    FROM SYS_USER A
    WHERE A.SYS_ID = p_sys_id
      AND ((p_targets IS NULL AND A.USER_ID = p_gs_user_id) OR (p_targets IS NOT NULL AND FIND_IN_SET(A.USER_ID, p_targets)));
END//

-- [sp_board_update_target] 대상자 정보 수정
DROP PROCEDURE IF EXISTS sp_board_update_target//
CREATE PROCEDURE sp_board_update_target(
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

-- [sp_board_update_target_disable] 대상자 비활성화 처리
DROP PROCEDURE IF EXISTS sp_board_update_target_disable//
CREATE PROCEDURE sp_board_update_target_disable(
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

-- [sp_board_delete_target_all] 대상자 일괄 삭제
DROP PROCEDURE IF EXISTS sp_board_delete_target_all//
CREATE PROCEDURE sp_board_delete_target_all(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_BORD_TGT WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup;
END//

-- [sp_board_update_target_read] 대상자 읽음 처리
DROP PROCEDURE IF EXISTS sp_board_update_target_read//
CREATE PROCEDURE sp_board_update_target_read(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT SET READ_DATE = NOW()
    WHERE SYS_ID = p_sys_id AND BORD_NO = p_bord_no AND BORD_GRUP = p_bord_grup AND TGT_USER_ID = p_tgt_user_id;
END//

-- [sp_board_search_views_list] 조회자 목록
DROP PROCEDURE IF EXISTS sp_board_search_views_list//
CREATE PROCEDURE sp_board_search_views_list(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200)
)
BEGIN
    SELECT
        A.TGT_USER_ID AS tgtUserId,
        A.VNDR_CODE   AS vndrCode,
        A.VNDR_NAME   AS vndrName,
        DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS readDate
    FROM SYS_BORD_TGT A
    WHERE A.SYS_ID = p_sys_id
      AND A.BORD_GRUP = p_bord_grup
      AND A.BORD_NO = p_bord_no
      AND (CASE
            WHEN p_search_key = 'S01' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.TGT_USER_ID LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S02' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.VNDR_CODE LIKE CONCAT('%', p_search_text, '%')
            WHEN p_search_key = 'S03' AND p_search_text IS NOT NULL AND p_search_text != '' THEN A.VNDR_NAME LIKE CONCAT('%', p_search_text, '%')
            ELSE 1=1 END)
    ORDER BY A.READ_DATE ASC, A.TGT_USER_ID ASC;
END//

-- [sp_board_search_views_list_count] 조회자 목록 카운트
DROP PROCEDURE IF EXISTS sp_board_search_views_list_count//
CREATE PROCEDURE sp_board_search_views_list_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_BORD_ADDR A
    WHERE A.SYS_ID = p_sys_id AND A.BORD_GRUP = p_bord_grup AND A.BORD_NO = p_bord_no;
END//

DELIMITER ;
