-- ============================================================
-- Sampleboard Stored Procedures
-- 생성일: 2026-01-15
-- 대상 테이블: SYS_BORD (BORD_GRUP = 'B12')
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_sampleboard_search: 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_sampleboard_search//
CREATE PROCEDURE sp_sampleboard_search(
    IN p_sys_id       VARCHAR(20),
    IN p_use_flag     VARCHAR(1),
    IN p_regi_id      VARCHAR(50),
    IN p_bord_title   VARCHAR(200),
    IN p_bord_text    TEXT,
    IN p_bord_type    VARCHAR(10),
    IN p_bord_bgn     VARCHAR(10),
    IN p_bord_end     VARCHAR(10),
    IN p_open_type    VARCHAR(10),
    IN p_search_key   VARCHAR(10),
    IN p_search_text  VARCHAR(200),
    IN p_sort_str     VARCHAR(500),
    IN p_start        INT,
    IN p_end          INT
)
BEGIN
    -- 정렬 조건 설정
    SET @v_sort = IFNULL(p_sort_str, 'A.BORD_SEQ ASC, A.REGI_DATE DESC');

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
                    A.BORD_TITLE    AS bordTitle,
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
                    A.REGI_ID       AS regiName,
                    A.CHNG_ID       AS chngName,
                    A.BORD_NO       AS id,
                    A.BORD_PNO      AS parentId,
                    CASE WHEN (SELECT COUNT(*)
                                FROM SYS_BORD
                               WHERE SYS_ID    = A.SYS_ID
                                 AND BORD_PNO  = A.BORD_NO
                                 AND BORD_GRUP = A.BORD_GRUP) = 0
                          THEN 'open'
                          ELSE 'closed'
                     END           AS state,
                    (SELECT COUNT(ATCH_NO)
                        FROM SYS_FILE
                       WHERE SYS_ID    = A.SYS_ID
                         AND ATCH_NO   = A.BORD_NO
                         AND ATCH_GRUP = A.BORD_GRUP
                    )              AS fileCnt
                FROM SYS_BORD A
                WHERE A.SYS_ID    = '", p_sys_id, "'
                  AND A.BORD_GRUP = 'B12'");

    -- 동적 조건 추가
    IF p_use_flag IS NOT NULL AND p_use_flag != '' THEN
        SET @sql = CONCAT(@sql, " AND A.USE_FLAG = '", p_use_flag, "'");
    END IF;

    IF p_regi_id IS NOT NULL AND p_regi_id != '' THEN
        SET @sql = CONCAT(@sql, " AND A.REGI_ID = '", p_regi_id, "'");
    END IF;

    IF p_bord_title IS NOT NULL AND p_bord_title != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_bord_title, "%'");
    END IF;

    IF p_bord_text IS NOT NULL AND p_bord_text != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_bord_text, "%'");
    END IF;

    IF p_bord_type IS NOT NULL AND p_bord_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TYPE = '", p_bord_type, "'");
    END IF;

    IF p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_BGN = '", p_bord_bgn, "'");
    END IF;

    IF p_bord_end IS NOT NULL AND p_bord_end != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_END = '", p_bord_end, "'");
    END IF;

    IF p_open_type IS NOT NULL AND p_open_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.OPEN_TYPE = '", p_open_type, "'");
    END IF;

    -- 검색조건, 검색텍스트 입력시
    IF p_search_text IS NOT NULL AND p_search_text != '' AND p_search_key IS NOT NULL AND p_search_key != '' THEN
        IF p_search_key = 'S01' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_search_text, "%'");
        ELSEIF p_search_key = 'S02' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_search_text, "%'");
        ELSEIF p_search_key = 'S03' THEN
            SET @sql = CONCAT(@sql, " AND EXISTS (
                SELECT 1
                  FROM SYS_USER
                 WHERE SYS_ID  = A.SYS_ID
                   AND USER_ID = A.REGI_ID
                   AND USER_NAME LIKE '%", p_search_text, "%'
            )");
        END IF;
    END IF;

    -- 정렬 및 페이징 추가
    SET @sql = CONCAT(@sql, "
                ORDER BY ", @v_sort, "
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
-- sp_sampleboard_search_count: 목록 건수 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_sampleboard_search_count//
CREATE PROCEDURE sp_sampleboard_search_count(
    IN p_sys_id       VARCHAR(20),
    IN p_use_flag     VARCHAR(1),
    IN p_regi_id      VARCHAR(50),
    IN p_bord_title   VARCHAR(200),
    IN p_bord_text    TEXT,
    IN p_bord_type    VARCHAR(10),
    IN p_bord_bgn     VARCHAR(10),
    IN p_bord_end     VARCHAR(10),
    IN p_open_type    VARCHAR(10),
    IN p_search_key   VARCHAR(10),
    IN p_search_text  VARCHAR(200)
)
BEGIN
    -- 동적 SQL 구성
    SET @sql = CONCAT("
        SELECT COUNT(1) AS cnt
          FROM SYS_BORD A
         WHERE A.SYS_ID    = '", p_sys_id, "'
           AND A.BORD_GRUP = 'B12'");

    -- 동적 조건 추가
    IF p_use_flag IS NOT NULL AND p_use_flag != '' THEN
        SET @sql = CONCAT(@sql, " AND A.USE_FLAG = '", p_use_flag, "'");
    END IF;

    IF p_regi_id IS NOT NULL AND p_regi_id != '' THEN
        SET @sql = CONCAT(@sql, " AND A.REGI_ID = '", p_regi_id, "'");
    END IF;

    IF p_bord_title IS NOT NULL AND p_bord_title != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_bord_title, "%'");
    END IF;

    IF p_bord_text IS NOT NULL AND p_bord_text != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_bord_text, "%'");
    END IF;

    IF p_bord_type IS NOT NULL AND p_bord_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_TYPE = '", p_bord_type, "'");
    END IF;

    IF p_bord_bgn IS NOT NULL AND p_bord_bgn != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_BGN = '", p_bord_bgn, "'");
    END IF;

    IF p_bord_end IS NOT NULL AND p_bord_end != '' THEN
        SET @sql = CONCAT(@sql, " AND A.BORD_END = '", p_bord_end, "'");
    END IF;

    IF p_open_type IS NOT NULL AND p_open_type != '' THEN
        SET @sql = CONCAT(@sql, " AND A.OPEN_TYPE = '", p_open_type, "'");
    END IF;

    -- 검색조건, 검색텍스트 입력시
    IF p_search_text IS NOT NULL AND p_search_text != '' AND p_search_key IS NOT NULL AND p_search_key != '' THEN
        IF p_search_key = 'S01' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TITLE LIKE '%", p_search_text, "%'");
        ELSEIF p_search_key = 'S02' THEN
            SET @sql = CONCAT(@sql, " AND A.BORD_TEXT LIKE '%", p_search_text, "%'");
        ELSEIF p_search_key = 'S03' THEN
            SET @sql = CONCAT(@sql, " AND EXISTS (
                SELECT 1
                  FROM SYS_USER
                 WHERE SYS_ID  = A.SYS_ID
                   AND USER_ID = A.REGI_ID
                   AND USER_NAME LIKE '%", p_search_text, "%'
            )");
        END IF;
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//


-- ============================================================
-- sp_sampleboard_select: 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_sampleboard_select//
CREATE PROCEDURE sp_sampleboard_select(
    IN p_sys_id    VARCHAR(20),
    IN p_bord_no   VARCHAR(20),
    IN p_bord_grup VARCHAR(10)
)
BEGIN
    SELECT
         SYS_ID        AS "sysId"
        ,BORD_NO       AS "bordNo"
        ,BORD_GRUP     AS "bordGrup"
        ,BORD_TITLE    AS "bordTitle"
        ,BORD_TYPE     AS "bordType"
        ,BORD_BGN      AS "bordBgn"
        ,BORD_END      AS "bordEnd"
        ,READ_CNT      AS "readCnt"
        ,BORD_SEQ      AS "bordSeq"
        ,BORD_PNO      AS "bordPno"
        ,OPEN_TYPE     AS "openType"
        ,USE_FLAG      AS "useFlag"
        ,REGI_ID       AS "regiId"
        ,REGI_DATE     AS "regiDate"
        ,CHNG_ID       AS "chngId"
        ,CHNG_DATE     AS "chngDate"
        ,A.REGI_ID     AS "regiName"
        ,A.CHNG_ID     AS "chngName"
        ,BORD_NO       AS "id"
        ,BORD_PNO      AS "parentId"
        ,CASE WHEN (SELECT COUNT(*)
                      FROM SYS_BORD
                     WHERE SYS_ID    = A.SYS_ID
                       AND BORD_PNO  = A.BORD_NO
                       AND BORD_GRUP = A.BORD_GRUP) = 0
              THEN 'open'
              ELSE 'closed'
         END           AS "state"
        ,(SELECT COUNT(Atch_No)
            FROM SYS_FILE
           WHERE SYS_ID    = A.SYS_ID
             AND ATCH_NO   = A.BORD_NO
             AND ATCH_GRUP = A.BORD_GRUP
        )              AS "fileCnt"
      FROM SYS_BORD A
     WHERE SYS_ID    = p_sys_id
       AND BORD_NO   = p_bord_no
       AND BORD_GRUP = p_bord_grup;
END//


-- ============================================================
-- sp_sampleboard_insert: 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_sampleboard_insert//
CREATE PROCEDURE sp_sampleboard_insert(
    IN p_sys_id     VARCHAR(20),
    IN p_bord_grup  VARCHAR(10),
    IN p_bord_title VARCHAR(200),
    IN p_user_id    VARCHAR(50),
    OUT p_bord_no   VARCHAR(20)
)
BEGIN
    -- 새로운 BORD_NO 생성
    SELECT CONCAT('B', LPAD(CAST(IFNULL(SUBSTR(MAX(BORD_NO),2,9),'0') AS UNSIGNED)+1, 9, '0'))
      INTO p_bord_no
      FROM SYS_BORD
     WHERE SYS_ID    = p_sys_id
       AND BORD_GRUP = p_bord_grup;

    -- NULL인 경우 기본값 설정
    IF p_bord_no IS NULL THEN
        SET p_bord_no = 'B000000001';
    END IF;

    -- INSERT 실행
    INSERT INTO SYS_BORD (
         SYS_ID
        ,BORD_NO
        ,BORD_GRUP
        ,BORD_TITLE
        ,READ_CNT
        ,BORD_SEQ
        ,USE_FLAG
        ,REGI_ID
        ,REGI_DATE
        ,CHNG_ID
        ,CHNG_DATE
    ) VALUES (
         p_sys_id
        ,p_bord_no
        ,p_bord_grup
        ,p_bord_title
        ,0
        ,999999999
        ,'Y'
        ,p_user_id
        ,NOW()
        ,p_user_id
        ,NOW()
    );

    -- 생성된 BORD_NO 반환 (OUT 파라미터)
    SELECT p_bord_no AS bordNo;
END//


-- ============================================================
-- sp_sampleboard_update: 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_sampleboard_update//
CREATE PROCEDURE sp_sampleboard_update(
    IN p_sys_id     VARCHAR(20),
    IN p_bord_no    VARCHAR(20),
    IN p_bord_grup  VARCHAR(10),
    IN p_bord_title VARCHAR(200),
    IN p_user_id    VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD
       SET CHNG_ID    = p_user_id
          ,CHNG_DATE  = NOW()
          ,BORD_TITLE = p_bord_title
     WHERE SYS_ID    = p_sys_id
       AND BORD_NO   = p_bord_no
       AND BORD_GRUP = p_bord_grup;
END//


-- ============================================================
-- sp_sampleboard_delete: 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_sampleboard_delete//
CREATE PROCEDURE sp_sampleboard_delete(
    IN p_sys_id    VARCHAR(20),
    IN p_bord_no   VARCHAR(20),
    IN p_bord_grup VARCHAR(10)
)
BEGIN
    DELETE FROM SYS_BORD
     WHERE SYS_ID    = p_sys_id
       AND BORD_NO   = p_bord_no
       AND BORD_GRUP = p_bord_grup;
END//


DELIMITER ;

-- ============================================================
-- End of Sampleboard Stored Procedures
-- ============================================================
