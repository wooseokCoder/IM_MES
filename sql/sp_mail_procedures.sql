-- ============================================================
-- Mail.xml (메일 관리) -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 보낸 메일함 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search//
CREATE PROCEDURE sp_mail_search(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_sort_str VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @v_sort = IFNULL(NULLIF(p_sort_str, ''), 'DATE_FORMAT(A.REGI_DATE,''%Y-%m-%d %H:%i:%s'') DESC');
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT A.SYS_ID        AS sysId
                          ,A.BORD_NO       AS bordNo
                          ,A.BORD_GRUP     AS bordGrup
                          ,A.BORD_TITLE    AS bordTitle
                          ,A.REGI_ID       AS regiId
                          ,DATE_FORMAT(A.REGI_DATE,''%Y-%m-%d %H:%i:%s'') AS regiDate
                          ,(SELECT COUNT(ATCH_NO) FROM SYS_FILE
                             WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP) AS fileCnt
                          ,MAX(CASE WHEN (SELECT COUNT(*)-1 FROM SYS_BORD_TGT
                                           WHERE SYS_ID = A.SYS_ID AND BORD_NO = A.BORD_NO
                                             AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = ''Y'') = 0
                                    THEN B.TGT_USER_ID
                                    ELSE CONCAT(B.TGT_USER_ID, ''외'',
                                         (SELECT COUNT(*)-1 FROM SYS_BORD_TGT
                                           WHERE SYS_ID = A.SYS_ID AND BORD_NO = A.BORD_NO
                                             AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = ''Y''), ''명'')
                               END) AS tgtUserId
                          ,MAX(CASE B.USE_FLAG WHEN ''E'' THEN ''ERROR''
                               ELSE DATE_FORMAT(B.READ_DATE,''%Y-%m-%d %H:%i:%s'') END) AS readDate
                          ,''A'' AS mailType
                      FROM SYS_BORD A, SYS_BORD_TGT B
                     WHERE A.SYS_ID = ''', p_sys_id, '''
                       AND A.SYS_ID = B.SYS_ID
                       AND A.BORD_GRUP = ''', p_bord_grup, '''
                       AND A.BORD_GRUP = B.BORD_GRUP
                       AND A.BORD_NO = B.BORD_NO
                       AND A.REGI_ID = ''', p_gs_user_id, '''
                       AND A.USE_FLAG != ''N''');

    -- 검색 조건 추가
    IF p_search_key IS NOT NULL AND p_search_key != '' AND p_search_text IS NOT NULL AND p_search_text != '' THEN
        IF p_search_key = 'S01' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.BORD_TITLE LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        ELSEIF p_search_key = 'S02' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.BORD_TEXT LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        ELSEIF p_search_key = 'S03' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND B.TGT_USER_ID LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        END IF;
    END IF;

    SET @v_sql = CONCAT(@v_sql, '
                     GROUP BY A.SYS_ID, A.BORD_NO, A.BORD_GRUP, A.BORD_TITLE, A.REGI_ID, DATE_FORMAT(A.REGI_DATE,''%Y-%m-%d %H:%i:%s'')
                     ORDER BY ', @v_sort, '
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (', IFNULL(p_end, 'NULL'), ' IS NULL OR RNUM < ', IFNULL(p_end, 999999999), ')
        ) X
        WHERE (', IFNULL(p_start, 'NULL'), ' IS NULL OR RNUM >= ', IFNULL(p_start, 0), ')');

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. 보낸 메일함 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_count//
CREATE PROCEDURE sp_mail_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM SYS_BORD A, SYS_BORD_TGT B
     WHERE A.SYS_ID = p_sys_id
       AND A.SYS_ID = B.SYS_ID
       AND A.BORD_GRUP = p_bord_grup
       AND A.BORD_GRUP = B.BORD_GRUP
       AND A.BORD_NO = B.BORD_NO
       AND A.REGI_ID = p_gs_user_id
       AND A.USE_FLAG != 'N'
       AND (CASE
            WHEN p_search_key = 'S01' AND p_search_text IS NOT NULL AND p_search_text != ''
                THEN A.BORD_TITLE LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            WHEN p_search_key = 'S02' AND p_search_text IS NOT NULL AND p_search_text != ''
                THEN A.BORD_TEXT LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            WHEN p_search_key = 'S03' AND p_search_text IS NOT NULL AND p_search_text != ''
                THEN B.TGT_USER_ID LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            ELSE 1=1 END);
END//

-- ============================================================
-- 3. 메일 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_select//
CREATE PROCEDURE sp_mail_select(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT A.SYS_ID        AS sysId
          ,A.BORD_NO       AS bordNo
          ,A.BORD_GRUP     AS bordGrup
          ,(SELECT BORD_TITLE FROM SYS_BORD
             WHERE SYS_ID = A.SYS_ID AND BORD_NO = A.BORD_NO AND BORD_GRUP = A.BORD_GRUP) AS bordTitle
          ,A.REGI_ID       AS regiId
          ,DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate
          ,(SELECT COUNT(ATCH_NO) FROM SYS_FILE
             WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP) AS fileCnt
          ,GROUP_CONCAT(TGT_USER_ID ORDER BY BORD_NO) AS tgtUserId
          ,MAX(CASE A.USE_FLAG WHEN 'E' THEN 'ERROR'
               ELSE DATE_FORMAT(A.READ_DATE,'%Y-%m-%d %H:%i:%s') END) AS readDate
      FROM SYS_BORD_TGT A
     WHERE A.SYS_ID = p_sys_id
       AND A.BORD_NO = p_bord_no
       AND A.BORD_GRUP = p_bord_grup
     GROUP BY A.SYS_ID, A.BORD_NO, A.BORD_GRUP, A.REGI_ID, DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s');
END//

-- ============================================================
-- 4. 메일 번호 생성
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_get_no//
CREATE PROCEDURE sp_mail_get_no(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT CONCAT('B', LPAD(CAST(IFNULL(SUBSTR(MAX(BORD_NO),2,9),'0') AS UNSIGNED)+1, 9, '0')) AS bordNo
      FROM SYS_BORD
     WHERE SYS_ID = p_sys_id
       AND BORD_GRUP = p_bord_grup;
END//

-- ============================================================
-- 5. 메일 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_insert//
CREATE PROCEDURE sp_mail_insert(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_title VARCHAR(500),
    IN p_bord_text LONGTEXT,
    IN p_bord_type VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_bord_no VARCHAR(20);

    -- bordNo 생성
    SELECT CONCAT('B', LPAD(CAST(IFNULL(SUBSTR(MAX(BORD_NO),2,9),'0') AS UNSIGNED)+1, 9, '0'))
      INTO v_bord_no
      FROM SYS_BORD
     WHERE SYS_ID = p_sys_id
       AND BORD_GRUP = p_bord_grup;

    INSERT INTO SYS_BORD (
        SYS_ID, BORD_NO, BORD_GRUP, BORD_TITLE, USE_FLAG, REGI_ID, REGI_DATE, BORD_TYPE, BORD_TEXT
    ) VALUES (
        p_sys_id, v_bord_no, p_bord_grup, p_bord_title, 'Y', p_gs_user_id, NOW(),
        NULLIF(p_bord_type, ''), NULLIF(p_bord_text, '')
    );
END//

-- ============================================================
-- 6. 메일 삭제 (논리 삭제)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_delete//
CREATE PROCEDURE sp_mail_delete(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_mail_type VARCHAR(1)
)
BEGIN
    UPDATE SYS_BORD
       SET USE_FLAG = 'N'
     WHERE SYS_ID = p_sys_id
       AND BORD_NO = p_bord_no
       AND BORD_GRUP = p_bord_grup
       AND p_mail_type != 'B';
END//

-- ============================================================
-- 7. 대상자 전체 삭제 (논리 삭제)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_delete_target_all//
CREATE PROCEDURE sp_mail_delete_target_all(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_mail_type VARCHAR(1)
)
BEGIN
    UPDATE SYS_BORD_TGT
       SET USE_FLAG = 'N'
     WHERE SYS_ID = p_sys_id
       AND BORD_NO = p_bord_no
       AND BORD_GRUP = p_bord_grup
       AND p_mail_type != 'A';
END//

-- ============================================================
-- 8. 메일 대상자 물리 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_tgt_delete//
CREATE PROCEDURE sp_mail_tgt_delete(
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

-- ============================================================
-- 9. 대상자 등록 (WHILE 루프 방식)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_board_target_insert//

CREATE PROCEDURE sp_board_target_insert(
    IN p_targets    TEXT,
    IN p_sys_id     VARCHAR(20),
    IN p_bord_no    VARCHAR(20),
    IN p_bord_grup  VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_target_id VARCHAR(50);
    DECLARE v_pos       INT DEFAULT 1;

    -- 루프를 돌며 INSERT 실행
    WHILE (LOCATE(',', p_targets, v_pos) > 0) DO
        SET v_target_id = TRIM(SUBSTRING(p_targets, v_pos, LOCATE(',', p_targets, v_pos) - v_pos));
        
        IF v_target_id != '' THEN
            INSERT INTO SYS_BORD_TGT (
                SYS_ID, BORD_NO, BORD_GRUP, TGT_USER_ID, USE_FLAG, REGI_ID, REGI_DATE
            ) VALUES (
                p_sys_id, p_bord_no, p_bord_grup, v_target_id, 'Y', p_gs_user_id, NOW()
            );
        END IF;
        
        SET v_pos = LOCATE(',', p_targets, v_pos) + 1;
    END WHILE;

    -- 마지막 항목 처리
    SET v_target_id = TRIM(SUBSTRING(p_targets, v_pos));
    IF v_target_id != '' THEN
        INSERT INTO SYS_BORD_TGT (
            SYS_ID, BORD_NO, BORD_GRUP, TGT_USER_ID, USE_FLAG, REGI_ID, REGI_DATE
        ) VALUES (
            p_sys_id, p_bord_no, p_bord_grup, v_target_id, 'Y', p_gs_user_id, NOW()
        );
    END IF;
    
    -- <insert> 태그를 위해 SELECT ROW_COUNT()를 과감히 삭제함
END//

-- ============================================================
-- 10. 메일 읽음 처리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_update_read//
CREATE PROCEDURE sp_mail_update_read(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_BORD_TGT
       SET READ_DATE = NOW(),
           CHNG_ID = p_user_id,
           CHNG_DATE = NOW()
     WHERE SYS_ID = p_sys_id
       AND BORD_NO = p_bord_no
       AND BORD_GRUP = p_bord_grup
       AND TGT_USER_ID = p_user_id
       AND READ_DATE IS NULL;
END//

-- ============================================================
-- 11. 메일 실패 처리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_update_fail//
CREATE PROCEDURE sp_mail_update_fail(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    UPDATE SYS_BORD_TGT
       SET USE_FLAG = 'E'
     WHERE SYS_ID = p_sys_id
       AND BORD_NO = p_bord_no
       AND BORD_GRUP = p_bord_grup;
END//

-- ============================================================
-- 12. 메일 대상자 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_select_target//
CREATE PROCEDURE sp_mail_select_target(
    IN p_sys_id VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_bord_grup VARCHAR(20)
)
BEGIN
    SELECT A.SYS_ID        AS sysId
          ,A.USE_FLAG      AS useFlag
          ,A.REGI_ID       AS regiId
          ,DATE_FORMAT(A.REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate
          ,A.CHNG_ID       AS chngId
          ,DATE_FORMAT(A.CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate
          ,A.BORD_TITLE    AS bordTitle
          ,A.BORD_NO       AS bordNo
          ,A.BORD_GRUP     AS bordGrup
          ,A.BORD_TYPE     AS bordType
          ,A.BORD_BGN      AS bordBgn
          ,A.BORD_END      AS bordEnd
          ,A.READ_CNT      AS readCnt
          ,A.BORD_SEQ      AS bordSeq
          ,(SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.REGI_ID) AS regiName
          ,(SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.CHNG_ID) AS chngName
          ,(SELECT GROUP_CONCAT(TGT_USER_ID ORDER BY BORD_NO) FROM SYS_BORD_TGT
             WHERE SYS_ID = A.SYS_ID AND BORD_GRUP = A.BORD_GRUP AND BORD_NO = A.BORD_NO) AS tgtUserId
          ,A.BORD_TEXT     AS bordText
      FROM SYS_BORD A
     WHERE A.SYS_ID = p_sys_id
       AND A.BORD_NO = p_bord_no
       AND A.BORD_GRUP = p_bord_grup;
END//

-- ============================================================
-- 13. 주소록 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_user_address//
CREATE PROCEDURE sp_mail_search_user_address(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT A.TGT_USER_ID   AS tgtUserId
                          ,A.TGT_USER_NAME AS tgtUserName
                      FROM SYS_BORD_ADDR A
                     WHERE A.SYS_ID = ''', p_sys_id, '''
                       AND A.BORD_GRUP = ''', p_bord_grup, '''
                       AND A.USER_ID = ''', p_gs_user_id, '''');

    -- 검색 조건 추가
    IF p_search_key IS NOT NULL AND p_search_key != '' AND p_search_text IS NOT NULL AND p_search_text != '' THEN
        IF p_search_key = 'S01' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.TGT_USER_ID LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        ELSEIF p_search_key = 'S02' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.TGT_USER_NAME LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        END IF;
    END IF;

    SET @v_sql = CONCAT(@v_sql, '
                     ORDER BY A.TGT_USER_ID ASC, A.TGT_USER_NAME ASC
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (', IFNULL(p_end, 'NULL'), ' IS NULL OR RNUM < ', IFNULL(p_end, 999999999), ')
        ) X
        WHERE (', IFNULL(p_start, 'NULL'), ' IS NULL OR RNUM >= ', IFNULL(p_start, 0), ')');

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 14. 주소록 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_user_address_count//
CREATE PROCEDURE sp_mail_search_user_address_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM SYS_BORD_ADDR A
     WHERE A.SYS_ID = p_sys_id
       AND A.BORD_GRUP = p_bord_grup
       AND A.USER_ID = p_gs_user_id;
END//

-- ============================================================
-- 15. 주소록 단건 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_select_user_address//
CREATE PROCEDURE sp_mail_select_user_address(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    SELECT A.TGT_USER_ID   AS tgtUserId
          ,A.TGT_USER_NAME AS tgtUserName
      FROM SYS_BORD_ADDR A
     WHERE A.SYS_ID = p_sys_id
       AND A.BORD_GRUP = 'B09'
       AND A.USER_ID = p_gs_user_id
       AND A.TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 16. 주소록 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_insert_user_address//
CREATE PROCEDURE sp_mail_insert_user_address(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100)
)
BEGIN
    INSERT INTO SYS_BORD_ADDR (
        SYS_ID, BORD_GRUP, USER_ID, TGT_USER_ID, TGT_USER_NAME, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id, 'B09', p_gs_user_id, p_tgt_user_id, p_tgt_user_name, p_gs_user_id, NOW()
    );
END//

-- ============================================================
-- 17. 주소록 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_update_user_address//
CREATE PROCEDURE sp_mail_update_user_address(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50),
    IN p_tgt_user_name VARCHAR(100)
)
BEGIN
    UPDATE SYS_BORD_ADDR
       SET CHNG_ID = p_gs_user_id,
           CHNG_DATE = NOW(),
           TGT_USER_NAME = p_tgt_user_name
     WHERE SYS_ID = p_sys_id
       AND USER_ID = p_gs_user_id
       AND BORD_GRUP = 'B09'
       AND TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 18. 주소록 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_delete_user_address//
CREATE PROCEDURE sp_mail_delete_user_address(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_tgt_user_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_BORD_ADDR
     WHERE SYS_ID = p_sys_id
       AND USER_ID = p_gs_user_id
       AND BORD_GRUP = 'B09'
       AND TGT_USER_ID = p_tgt_user_id;
END//

-- ============================================================
-- 19. 내부 사용자 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_user_internal_list//
CREATE PROCEDURE sp_mail_search_user_internal_list(
    IN p_sys_id VARCHAR(20),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT A.USER_ID   AS userId
                          ,A.USER_NAME AS userName
                      FROM SYS_USER A
                     WHERE A.SYS_ID = ''', p_sys_id, '''');

    -- 검색 조건 추가
    IF p_search_key IS NOT NULL AND p_search_key != '' AND p_search_text IS NOT NULL AND p_search_text != '' THEN
        IF p_search_key = 'S01' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.USER_ID LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        ELSEIF p_search_key = 'S02' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.USER_NAME LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        END IF;
    END IF;

    SET @v_sql = CONCAT(@v_sql, '
                     ORDER BY A.USER_ID ASC, A.USER_NAME ASC
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (', IFNULL(p_end, 'NULL'), ' IS NULL OR RNUM < ', IFNULL(p_end, 999999999), ')
        ) X
        WHERE (', IFNULL(p_start, 'NULL'), ' IS NULL OR RNUM >= ', IFNULL(p_start, 0), ')');

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 20. 받은 메일함 목록 조회 (페이징 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_internal_list//
CREATE PROCEDURE sp_mail_search_internal_list(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200),
    IN p_sort_str VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @v_sort = IFNULL(NULLIF(p_sort_str, ''), 'DATE_FORMAT(A.REGI_DATE,''%Y-%m-%d %H:%i:%s'') DESC');
    SET @rownum = 0;

    SET @v_sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT A.SYS_ID        AS sysId
                          ,A.BORD_NO       AS bordNo
                          ,A.BORD_GRUP     AS bordGrup
                          ,A.BORD_TITLE    AS bordTitle
                          ,A.REGI_ID       AS regiId
                          ,DATE_FORMAT(A.REGI_DATE,''%Y-%m-%d %H:%i:%s'') AS regiDate
                          ,(SELECT COUNT(ATCH_NO) FROM SYS_FILE
                             WHERE SYS_ID = A.SYS_ID AND ATCH_NO = A.BORD_NO AND ATCH_GRUP = A.BORD_GRUP) AS fileCnt
                          ,MAX(CASE WHEN (SELECT COUNT(*)-1 FROM SYS_BORD_TGT
                                           WHERE SYS_ID = A.SYS_ID AND BORD_NO = A.BORD_NO
                                             AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = ''Y'') = 0
                                    THEN B.TGT_USER_ID
                                    ELSE CONCAT(B.TGT_USER_ID, ''외'',
                                         (SELECT COUNT(*)-1 FROM SYS_BORD_TGT
                                           WHERE SYS_ID = A.SYS_ID AND BORD_NO = A.BORD_NO
                                             AND BORD_GRUP = A.BORD_GRUP AND USE_FLAG = ''Y''), ''명'')
                               END) AS tgtUserId
                          ,(CASE B.USE_FLAG WHEN ''E'' THEN ''ERROR''
                            ELSE DATE_FORMAT(B.READ_DATE,''%Y-%m-%d %H:%i:%s'') END) AS readDate
                          ,''B'' AS mailType
                      FROM SYS_BORD A, SYS_BORD_TGT B
                     WHERE A.SYS_ID = ''', p_sys_id, '''
                       AND A.SYS_ID = B.SYS_ID
                       AND A.BORD_GRUP = ''', p_bord_grup, '''
                       AND A.BORD_GRUP = B.BORD_GRUP
                       AND A.BORD_NO = B.BORD_NO
                       AND B.TGT_USER_ID = ''', p_gs_user_id, '''
                       AND B.USE_FLAG != ''N''');

    -- 검색 조건 추가
    IF p_search_key IS NOT NULL AND p_search_key != '' AND p_search_text IS NOT NULL AND p_search_text != '' THEN
        IF p_search_key = 'S01' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.BORD_TITLE LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        ELSEIF p_search_key = 'S02' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND A.BORD_TEXT LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        ELSEIF p_search_key = 'S03' THEN
            SET @v_sql = CONCAT(@v_sql, ' AND B.REGI_ID LIKE ''%', p_search_text, '%'' COLLATE utf8mb4_unicode_ci');
        END IF;
    END IF;

    SET @v_sql = CONCAT(@v_sql, '
                     ORDER BY ', @v_sort, '
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (', IFNULL(p_end, 'NULL'), ' IS NULL OR RNUM < ', IFNULL(p_end, 999999999), ')
        ) X
        WHERE (', IFNULL(p_start, 'NULL'), ' IS NULL OR RNUM >= ', IFNULL(p_start, 0), ')');

    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 21. 받은 메일함 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_internal_list_count//
CREATE PROCEDURE sp_mail_search_internal_list_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_search_key VARCHAR(10),
    IN p_search_text VARCHAR(200)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM SYS_BORD A, SYS_BORD_TGT B
     WHERE A.SYS_ID = p_sys_id
       AND A.SYS_ID = B.SYS_ID
       AND A.BORD_GRUP = p_bord_grup
       AND A.BORD_GRUP = B.BORD_GRUP
       AND A.BORD_NO = B.BORD_NO
       AND B.TGT_USER_ID = p_gs_user_id
       AND B.USE_FLAG != 'N'
       AND (CASE
            WHEN p_search_key = 'S01' AND p_search_text IS NOT NULL AND p_search_text != ''
                THEN A.BORD_TITLE LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            WHEN p_search_key = 'S02' AND p_search_text IS NOT NULL AND p_search_text != ''
                THEN A.BORD_TEXT LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            WHEN p_search_key = 'S03' AND p_search_text IS NOT NULL AND p_search_text != ''
                THEN B.REGI_ID LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%')
            ELSE 1=1 END);
END//

-- ============================================================
-- 22. 메일 열람자 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_views_list//
CREATE PROCEDURE sp_mail_search_views_list(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20),
    IN p_search_text VARCHAR(200)
)
BEGIN
    SELECT A.TGT_USER_ID AS tgtUserId
          ,DATE_FORMAT(A.READ_DATE,'%Y-%m-%d %H:%i:%s') AS readDate
      FROM SYS_BORD_TGT A
     WHERE A.SYS_ID = p_sys_id
       AND A.BORD_GRUP = p_bord_grup
       AND A.BORD_NO = p_bord_no
       AND (p_search_text IS NULL OR p_search_text = ''
            OR A.TGT_USER_ID LIKE CONCAT('%', p_search_text COLLATE utf8mb4_unicode_ci, '%'))
     ORDER BY A.READ_DATE ASC, A.TGT_USER_ID ASC;
END//

-- ============================================================
-- 23. 메일 열람자 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_search_views_list_count//
CREATE PROCEDURE sp_mail_search_views_list_count(
    IN p_sys_id VARCHAR(20),
    IN p_bord_grup VARCHAR(20),
    IN p_bord_no VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM SYS_BORD_TGT A
     WHERE A.SYS_ID = p_sys_id
       AND A.BORD_GRUP = p_bord_grup
       AND A.BORD_NO = p_bord_no;
END//

-- ============================================================
-- 24. 메일 플래그 체크 (통합)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_mail_flag_check//
CREATE PROCEDURE sp_mail_flag_check(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_flag_type VARCHAR(20)
)
BEGIN
    SELECT CASE p_flag_type
           WHEN 'RETURN' THEN REVIEW_MAIL_FLAG
           WHEN 'CONFIRM' THEN CONF_MAIL_FLAG
           WHEN 'BOL' THEN BOL_MAIL_FLAG
           WHEN 'REVIEW' THEN REVIEW_MAIL_FLAG
           WHEN 'MONTHLY' THEN MON_MAIL_FLAG
           WHEN 'ORDRCL' THEN ORDRCL_MAIL_FLAG
           END AS flag
      FROM SYS_USER
     WHERE SYS_ID = p_sys_id
       AND USER_ID = p_gs_user_id;
END//

DELIMITER ;
