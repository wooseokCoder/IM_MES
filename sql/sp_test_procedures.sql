-- ====================================================================================
-- Test 프로시저 스크립트
-- 테이블: SYS_MENU (테스트용 메뉴 관리)
-- 생성일: 2026-01-15
-- ====================================================================================

DELIMITER //

-- ====================================================================================
-- 1. sp_test_search - 메뉴 목록 조회 (페이징)
-- ====================================================================================
-- AS-IS:
--   SELECT A.SYS_ID AS "sysId", A.MENU_KEY AS "menuKey", ...
--   FROM SYS_MENU A
--   WHERE SYS_ID = #{sysId}
--     AND MENU_KEY = #{menuKey} (조건부)
--     AND MENU_DESC LIKE CONCAT('%',#{menuDesc},'%') (조건부)
--   ORDER BY A.MENU_KEY
--   (페이징: @rownum 변수 사용 RNUM 계산)
-- ====================================================================================
DROP PROCEDURE IF EXISTS sp_test_search //
CREATE PROCEDURE sp_test_search(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuDesc VARCHAR(200),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- rownum 변수 초기화 (Board.xml 스타일)
    SET @rownum := 0;

    -- 동적 SQL 구성 (Board.xml 페이징 패턴)
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID AS sysId,
                    A.MENU_KEY AS menuKey,
                    A.MENU_DESC AS menuDesc,
                    A.MENU_URL AS menuUrl,
                    A.PARENT_KEY AS parentKey,
                    A.MENU_LEVEL AS menuLevel,
                    A.MENU_SEQ AS menuSeq,
                    A.USE_FLAG AS useFlag,
                    A.REGI_ID AS regiId,
                    DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate
                FROM SYS_MENU A
                WHERE A.SYS_ID = '", p_sysId, "'
                  AND (CASE WHEN '", IFNULL(p_menuKey,''), "' != '' THEN A.MENU_KEY = '", IFNULL(p_menuKey,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_menuDesc,''), "' != '' THEN A.MENU_DESC LIKE '%", IFNULL(p_menuDesc,''), "%' ELSE 1=1 END)
                ORDER BY A.MENU_KEY
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    -- 동적 SQL 실행
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ====================================================================================
-- 2. sp_test_search_count - 메뉴 카운트 조회
-- ====================================================================================
-- AS-IS:
--   SELECT COUNT(1)
--   FROM SYS_MENU A
--   WHERE SYS_ID = #{sysId}
--     AND MENU_KEY = #{menuKey} (조건부)
--     AND MENU_DESC LIKE CONCAT('%',#{menuDesc},'%') (조건부)
-- ====================================================================================
DROP PROCEDURE IF EXISTS sp_test_search_count //
CREATE PROCEDURE sp_test_search_count(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuDesc VARCHAR(200)
)
BEGIN
    -- 기본 COUNT 쿼리 생성
    SET @sql = CONCAT(
        'SELECT COUNT(1)',
        ' FROM SYS_MENU A',
        ' WHERE A.SYS_ID = ''', p_sysId, ''''
    );

    -- 동적 WHERE 조건 (search와 동일)
    IF p_menuKey IS NOT NULL AND p_menuKey != '' THEN
        SET @sql = CONCAT(@sql, ' AND A.MENU_KEY = ''', p_menuKey, '''');
    END IF;

    IF p_menuDesc IS NOT NULL AND p_menuDesc != '' THEN
        SET @sql = CONCAT(@sql, ' AND A.MENU_DESC LIKE CONCAT(''%'', ''', p_menuDesc, ''', ''%'')');
    END IF;

    -- 동적 SQL 실행
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ====================================================================================
-- 3. sp_test_insert - 메뉴 등록
-- ====================================================================================
-- AS-IS:
--   INSERT INTO SYS_MENU (
--       SYS_ID, MENU_KEY, MENU_DESC, MENU_URL, PARENT_KEY, MENU_LEVEL, MENU_SEQ, USE_FLAG, REGI_ID, REGI_DATE
--   ) VALUES (
--       #{sysId}, #{menuKey}, #{menuDesc}, #{menuUrl}, #{parentKey}, #{menuLevel}, #{menuSeq}, 'Y', #{gsUserId}, NOW()
--   )
-- ====================================================================================
DROP PROCEDURE IF EXISTS sp_test_insert //
CREATE PROCEDURE sp_test_insert(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuDesc VARCHAR(200),
    IN p_menuUrl VARCHAR(500),
    IN p_parentKey VARCHAR(50),
    IN p_menuLevel INT,
    IN p_menuSeq INT,
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_MENU (
        SYS_ID,
        MENU_KEY,
        MENU_DESC,
        MENU_URL,
        PARENT_KEY,
        MENU_LEVEL,
        MENU_SEQ,
        USE_FLAG,
        REGI_ID,
        REGI_DATE
    ) VALUES (
        p_sysId,
        p_menuKey,
        p_menuDesc,
        p_menuUrl,
        p_parentKey,
        p_menuLevel,
        p_menuSeq,
        'Y',
        p_gsUserId,
        NOW()
    );
END //

-- ====================================================================================
-- 4. sp_test_update - 메뉴 수정
-- ====================================================================================
-- AS-IS:
--   UPDATE SYS_MENU
--   SET MENU_DESC = #{menuDesc}
--     , MENU_URL  = #{menuUrl}
--     , CHNG_ID   = #{gsUserId}
--     , CHNG_DATE = NOW()
--   WHERE SYS_ID    = #{sysId}
--     AND MENU_KEY  = #{menuKey}
-- ====================================================================================
DROP PROCEDURE IF EXISTS sp_test_update //
CREATE PROCEDURE sp_test_update(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuDesc VARCHAR(200),
    IN p_menuUrl VARCHAR(500),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    UPDATE SYS_MENU
    SET MENU_DESC = p_menuDesc,
        MENU_URL  = p_menuUrl,
        CHNG_ID   = p_gsUserId,
        CHNG_DATE = NOW()
    WHERE SYS_ID   = p_sysId
      AND MENU_KEY = p_menuKey;
END //

-- ====================================================================================
-- 5. sp_test_delete - 메뉴 삭제
-- ====================================================================================
-- AS-IS:
--   DELETE FROM SYS_MENU
--   WHERE SYS_ID    = #{sysId}
--     AND MENU_KEY  = #{menuKey}
-- ====================================================================================
DROP PROCEDURE IF EXISTS sp_test_delete //
CREATE PROCEDURE sp_test_delete(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_MENU
    WHERE SYS_ID   = p_sysId
      AND MENU_KEY = p_menuKey;
END //

DELIMITER ;
