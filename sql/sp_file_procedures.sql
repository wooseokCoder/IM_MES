-- ============================================================
-- File.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 파일 목록 조회 (페이징 없음, 동적 정렬)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_search//

CREATE PROCEDURE sp_file_search(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50),
    IN p_file_no VARCHAR(20),
    IN p_file_name VARCHAR(200),
    IN p_save_name VARCHAR(200),
    IN p_file_path VARCHAR(500),
    IN p_file_type VARCHAR(200),
    IN p_file_size VARCHAR(20),
    IN p_sort_str VARCHAR(500)
)
BEGIN
    -- 정렬 조건: sortStr이 있으면 사용, 없으면 기본값
    SET @v_sort = IFNULL(NULLIF(p_sort_str, ''), 'ATCH_GRUP, ATCH_NO, FILE_NO');

    SET @v_sql = CONCAT('
        SELECT SYS_ID        AS sysId
             , ATCH_GRUP     AS atchGrup
             , ATCH_NO       AS atchNo
             , FILE_NO       AS fileNo
             , FILE_NAME     AS fileName
             , SAVE_NAME     AS saveName
             , FILE_PATH     AS filePath
             , FILE_TYPE     AS fileType
             , FILE_SIZE     AS fileSize
             , IFNULL(FILE_REMK, '''') AS comment
             , REGI_ID       AS regiId
             , DATE_FORMAT(REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate
             , CHNG_ID       AS chngId
             , DATE_FORMAT(CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate
          FROM SYS_FILE
         WHERE SYS_ID = ''', p_sys_id, '''
           AND ATCH_GRUP = ''', p_atch_grup, '''
           AND ATCH_NO = ''', p_atch_no, '''
           AND (''', IFNULL(p_file_no, ''), ''' = '''' OR FILE_NO = ''', IFNULL(p_file_no, ''), ''')
           AND (''', IFNULL(p_file_name, ''), ''' = '''' OR FILE_NAME = ''', IFNULL(p_file_name, ''), ''')
           AND (''', IFNULL(p_save_name, ''), ''' = '''' OR SAVE_NAME = ''', IFNULL(p_save_name, ''), ''')
           AND (''', IFNULL(p_file_path, ''), ''' = '''' OR FILE_PATH = ''', IFNULL(p_file_path, ''), ''')
           AND (''', IFNULL(p_file_type, ''), ''' = '''' OR FILE_TYPE = ''', IFNULL(p_file_type, ''), ''')
           AND (''', IFNULL(p_file_size, ''), ''' = '''' OR FILE_SIZE = ''', IFNULL(p_file_size, ''), ''')
           AND FILE_NO != ''F9999''
         ORDER BY ', @v_sort
    );

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. 파일 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_search_count//

CREATE PROCEDURE sp_file_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50),
    IN p_file_no VARCHAR(20),
    IN p_file_name VARCHAR(200),
    IN p_save_name VARCHAR(200),
    IN p_file_path VARCHAR(500),
    IN p_file_type VARCHAR(50),
    IN p_file_size VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_FILE A
    WHERE SYS_ID = p_sys_id
      AND ATCH_GRUP = p_atch_grup
      AND ATCH_NO = p_atch_no
      AND (p_file_no IS NULL OR p_file_no = '' OR FILE_NO = p_file_no)
      AND (p_file_name IS NULL OR p_file_name = '' OR FILE_NAME = p_file_name)
      AND (p_save_name IS NULL OR p_save_name = '' OR SAVE_NAME = p_save_name)
      AND (p_file_path IS NULL OR p_file_path = '' OR FILE_PATH = p_file_path)
      AND (p_file_type IS NULL OR p_file_type = '' OR FILE_TYPE = p_file_type)
      AND (p_file_size IS NULL OR p_file_size = '' OR FILE_SIZE = p_file_size)
      AND FILE_NO != 'F9999';
END//

-- ============================================================
-- 3. 파일 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_select//

CREATE PROCEDURE sp_file_select(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50),
    IN p_file_no VARCHAR(20)
)
BEGIN
    SELECT
        SYS_ID AS "sysId",
        ATCH_GRUP AS "atchGrup",
        ATCH_NO AS "atchNo",
        FILE_NO AS "fileNo",
        FILE_NAME AS "fileName",
        SAVE_NAME AS "saveName",
        FILE_PATH AS "filePath",
        FILE_TYPE AS "fileType",
        FILE_SIZE AS "fileSize",
        IFNULL(FILE_REMK, '') AS "comment",
        REGI_ID AS "regiId",
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS "regiDate",
        CHNG_ID AS "chngId",
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS "chngDate"
    FROM SYS_FILE A
    WHERE SYS_ID = p_sys_id
      AND ATCH_GRUP = p_atch_grup
      AND ATCH_NO = p_atch_no
      AND FILE_NO = p_file_no
      AND FILE_NO != 'F9999';
END//

-- ============================================================
-- 4. 파일 등록
-- NULLIF 패턴: 빈문자열이면 NULL로 변환
-- 생성된 fileNo를 SELECT로 반환
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_insert//

CREATE PROCEDURE sp_file_insert(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50),
    IN p_file_name VARCHAR(200),
    IN p_save_name VARCHAR(200),
    IN p_file_path VARCHAR(500),
    IN p_file_type VARCHAR(200),
    IN p_file_size VARCHAR(20),
    IN p_comment VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_file_no VARCHAR(20);

    -- fileNo 생성: F0001, F0002, ...
    SELECT CONCAT('F', LPAD(CAST(IFNULL(SUBSTR(MAX(FILE_NO), 2, 4), '0') AS UNSIGNED) + 1, 4, '0'))
      INTO v_file_no
      FROM SYS_FILE
     WHERE SYS_ID = p_sys_id
       AND ATCH_GRUP = p_atch_grup
       AND ATCH_NO = p_atch_no;

    INSERT INTO SYS_FILE (
        SYS_ID,
        ATCH_GRUP,
        ATCH_NO,
        FILE_NO,
        FILE_NAME,
        SAVE_NAME,
        FILE_PATH,
        FILE_TYPE,
        FILE_SIZE,
        FILE_REMK,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_sys_id,
        p_atch_grup,
        p_atch_no,
        v_file_no,
        NULLIF(p_file_name, ''),
        NULLIF(p_save_name, ''),
        NULLIF(p_file_path, ''),
        NULLIF(p_file_type, ''),
        NULLIF(p_file_size, ''),
        IFNULL(NULLIF(p_comment, ''), ''),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );

    -- 생성된 fileNo 반환
    SELECT v_file_no AS "fileNo";
END//

-- ============================================================
-- 5. 파일 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_delete//

CREATE PROCEDURE sp_file_delete(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50),
    IN p_file_no VARCHAR(20)
)
BEGIN
    DELETE FROM SYS_FILE
    WHERE SYS_ID = p_sys_id
      AND ATCH_GRUP = p_atch_grup
      AND ATCH_NO = p_atch_no
      AND FILE_NO = p_file_no;
END//

-- ============================================================
-- 6. 파일 전체 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_delete_all//

CREATE PROCEDURE sp_file_delete_all(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_FILE
    WHERE SYS_ID = p_sys_id
      AND ATCH_GRUP = p_atch_grup
      AND ATCH_NO = p_atch_no;
END//

-- ============================================================
-- 7. 썸네일 업데이트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_update_thumbnail//

CREATE PROCEDURE sp_file_update_thumbnail(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50),
    IN p_h_thumbnail VARCHAR(200)
)
BEGIN
    UPDATE SYS_FILE
    SET THUMB_NAIL = 'Y'
    WHERE SYS_ID = p_sys_id
      AND ATCH_GRUP = p_atch_grup
      AND ATCH_NO = p_atch_no
      AND FILE_NAME = p_h_thumbnail;
END//

-- ============================================================
-- 8. 썸네일 NULL 업데이트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_file_update_thumbnail_null//

CREATE PROCEDURE sp_file_update_thumbnail_null(
    IN p_sys_id VARCHAR(20),
    IN p_atch_grup VARCHAR(50),
    IN p_atch_no VARCHAR(50)
)
BEGIN
    UPDATE SYS_FILE
    SET THUMB_NAIL = NULL
    WHERE SYS_ID = p_sys_id
      AND ATCH_GRUP = p_atch_grup
      AND ATCH_NO = p_atch_no;
END//

DELIMITER ;
