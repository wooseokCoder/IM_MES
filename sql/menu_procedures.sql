
DELIMITER //

-- ====================================================================================
-- 1. SP_SEARCH_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SEARCH_MENU //
CREATE PROCEDURE SP_SEARCH_MENU(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuLevel VARCHAR(10),
    IN p_menuDesc VARCHAR(100),
    IN p_menuDir VARCHAR(500),
    IN p_menuUrl VARCHAR(200),
    IN p_parentKey VARCHAR(50),
    IN p_parentType VARCHAR(50),
    IN p_childYn VARCHAR(1),
    IN p_procType VARCHAR(10),
    IN p_actionYn VARCHAR(1),
    IN p_iconCls VARCHAR(50),
    IN p_menuSeq VARCHAR(10),
    IN p_sepaText VARCHAR(50),
    IN p_useFlag VARCHAR(1),
    IN p_enableYn VARCHAR(1),
    IN p_sfdcYn VARCHAR(1),
    IN p_gsLang VARCHAR(10),
    IN p_start INT,
    IN p_end INT,
    IN p_sortClause VARCHAR(200)
)
BEGIN
    DECLARE v_sql LONGTEXT;
    DECLARE v_col_menuDesc VARCHAR(1000);
    DECLARE v_col_parentDesc VARCHAR(1000);
    DECLARE v_limit INT;
    DECLARE v_offset INT;

    -- 다국어 처리
    IF p_gsLang = 'ko' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_KOR, A.MENU_DESC)';
    ELSEIF p_gsLang = 'en' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_EN, A.MENU_DESC)';
    ELSEIF p_gsLang = 'vi' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_VIET, A.MENU_DESC)';
    ELSEIF p_gsLang = 'etc' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_ETC, A.MENU_DESC)';
    ELSEIF p_gsLang = 'pt' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_PORT, A.MENU_DESC)';
    ELSE
        SET v_col_menuDesc = 'A.MENU_DESC';
    END IF;

    SET v_col_parentDesc = CONCAT('fn_get_menu_path(A.MENU_KEY, ''', p_gsLang, ''')');

    -- 기본 쿼리 생성
    SET v_sql = CONCAT(
        'SELECT A.SYS_ID AS "sysId", A.MENU_KEY AS "menuKey", ',
        v_col_menuDesc, ' AS "menuDesc", ',
        'A.MENU_DESC AS "menuDescKr", A.MENU_DESC_EN AS "menuDescEn", ',
        'A.MENU_DESC_VIET AS "menuDescVi", A.MENU_DESC_ETC AS "menuDescEtc", A.MENU_DESC_PORT AS "menuDescPort", ',
        'A.MENU_DIR AS "menuDir", A.MOBILE_TYPE AS "mobileType", A.MENU_URL AS "menuUrl", ',
        'A.PARENT_KEY AS "parentKey", A.PARENT_TYPE AS "parentType", A.CHILD_YN AS "childYn", ',
        'A.PROC_TYPE AS "procType", A.ACTION_YN AS "actionYn", A.ICON_CLS AS "iconCls", ',
        'A.SEPA_TEXT AS "sepaText", A.USE_FLAG AS "useFlag", A.ENABLE_YN AS "enableYn", ',
        'A.SFDC_YN AS "sfdcYn", A.REGI_ID AS "regiId", ',
        'DATE_FORMAT(A.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS "regiDate", ',
        'A.CHNG_ID AS "chngId", ',
        'DATE_FORMAT(A.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS "chngDate", ',
        'IFNULL(A.MENU_LEVEL, 0) AS "menuLevel", IFNULL(A.MENU_SEQ, 0) AS "menuSeq", ',
        v_col_parentDesc, ' AS "parentDesc", ',
        '''N'' AS "menuPath", ''N'' AS "helpYn" ',
        'FROM SYS_MENU A WHERE A.SYS_ID = ''', p_sysId, ''' '
    );

    -- 동적 WHERE 절
    IF p_menuKey IS NOT NULL AND p_menuKey != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_KEY = ''', p_menuKey, ''''); END IF;
    IF p_menuLevel IS NOT NULL AND p_menuLevel != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_LEVEL = ''', p_menuLevel, ''''); END IF;
    IF p_menuDesc IS NOT NULL AND p_menuDesc != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_DESC LIKE CONCAT(''%'', ''', p_menuDesc, ''', ''%'')'); END IF;
    IF p_menuDir IS NOT NULL AND p_menuDir != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_DIR = ''', p_menuDir, ''''); END IF;
    IF p_menuUrl IS NOT NULL AND p_menuUrl != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_URL LIKE CONCAT(''%'', ''', p_menuUrl, ''', ''%'')'); END IF;
    IF p_parentKey IS NOT NULL AND p_parentKey != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.PARENT_KEY LIKE CONCAT(''%'', ''', p_parentKey, ''', ''%'')'); END IF;
    IF p_parentType IS NOT NULL AND p_parentType != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.PARENT_TYPE = ''', p_parentType, ''''); END IF;
    IF p_childYn IS NOT NULL AND p_childYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.CHILD_YN = ''', p_childYn, ''''); END IF;
    IF p_procType IS NOT NULL AND p_procType != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.PROC_TYPE = ''', p_procType, ''''); END IF;
    IF p_actionYn IS NOT NULL AND p_actionYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.ACTION_YN = ''', p_actionYn, ''''); END IF;
    IF p_iconCls IS NOT NULL AND p_iconCls != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.ICON_CLS = ''', p_iconCls, ''''); END IF;
    IF p_menuSeq IS NOT NULL AND p_menuSeq != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_SEQ = ''', p_menuSeq, ''''); END IF;
    IF p_sepaText IS NOT NULL AND p_sepaText != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.SEPA_TEXT = ''', p_sepaText, ''''); END IF;
    IF p_useFlag IS NOT NULL AND p_useFlag != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.USE_FLAG = ''', p_useFlag, ''''); END IF;
    IF p_enableYn IS NOT NULL AND p_enableYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.ENABLE_YN = ''', p_enableYn, ''''); END IF;
    IF p_sfdcYn IS NOT NULL AND p_sfdcYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.SFDC_YN = ''', p_sfdcYn, ''''); END IF;

    -- 정렬
    IF p_sortClause IS NOT NULL AND p_sortClause != '' THEN
        SET v_sql = CONCAT(v_sql, ' ORDER BY ', p_sortClause);
    ELSE
        SET v_sql = CONCAT(v_sql, ' ORDER BY A.PARENT_KEY, A.MENU_SEQ, A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    -- 페이징 (MySQL LIMIT 사용)
    -- MyBatis: start (1-based index usually, but logic is RNUM >= start AND RNUM < end)
    -- MySQL LIMIT offset, count
    -- If p_start=1, p_end=11 (10 rows), then offset=0, count=10.
    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SET v_offset = p_start - 1;
        SET v_limit = p_end - p_start;
        SET v_sql = CONCAT(v_sql, ' LIMIT ', v_offset, ', ', v_limit);
    END IF;

    SET @stmt = v_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ====================================================================================
-- 2. SP_SEARCH_COUNT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SEARCH_COUNT_MENU //
CREATE PROCEDURE SP_SEARCH_COUNT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuLevel VARCHAR(10),
    IN p_menuDesc VARCHAR(100),
    IN p_menuDir VARCHAR(500),
    IN p_menuUrl VARCHAR(200),
    IN p_parentKey VARCHAR(50),
    IN p_parentType VARCHAR(50),
    IN p_childYn VARCHAR(1),
    IN p_procType VARCHAR(10),
    IN p_actionYn VARCHAR(1),
    IN p_iconCls VARCHAR(50),
    IN p_menuSeq VARCHAR(10),
    IN p_sepaText VARCHAR(50),
    IN p_useFlag VARCHAR(1),
    IN p_enableYn VARCHAR(1),
    IN p_sfdcYn VARCHAR(1)
)
BEGIN
    DECLARE v_sql LONGTEXT;

    SET v_sql = CONCAT('SELECT COUNT(1) FROM SYS_MENU A WHERE A.SYS_ID = ''', p_sysId, ''' ');

    IF p_menuKey IS NOT NULL AND p_menuKey != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_KEY = ''', p_menuKey, ''''); END IF;
    IF p_menuLevel IS NOT NULL AND p_menuLevel != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_LEVEL = ''', p_menuLevel, ''''); END IF;
    IF p_menuDesc IS NOT NULL AND p_menuDesc != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_DESC LIKE CONCAT(''%'', ''', p_menuDesc, ''', ''%'')'); END IF;
    IF p_menuDir IS NOT NULL AND p_menuDir != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_DIR = ''', p_menuDir, ''''); END IF;
    IF p_menuUrl IS NOT NULL AND p_menuUrl != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_URL LIKE CONCAT(''%'', ''', p_menuUrl, ''', ''%'')'); END IF;
    IF p_parentKey IS NOT NULL AND p_parentKey != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.PARENT_KEY LIKE CONCAT(''%'', ''', p_parentKey, ''', ''%'')'); END IF;
    IF p_parentType IS NOT NULL AND p_parentType != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.PARENT_TYPE = ''', p_parentType, ''''); END IF;
    IF p_childYn IS NOT NULL AND p_childYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.CHILD_YN = ''', p_childYn, ''''); END IF;
    IF p_procType IS NOT NULL AND p_procType != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.PROC_TYPE = ''', p_procType, ''''); END IF;
    IF p_actionYn IS NOT NULL AND p_actionYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.ACTION_YN = ''', p_actionYn, ''''); END IF;
    IF p_iconCls IS NOT NULL AND p_iconCls != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.ICON_CLS = ''', p_iconCls, ''''); END IF;
    IF p_menuSeq IS NOT NULL AND p_menuSeq != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.MENU_SEQ = ''', p_menuSeq, ''''); END IF;
    IF p_sepaText IS NOT NULL AND p_sepaText != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.SEPA_TEXT = ''', p_sepaText, ''''); END IF;
    IF p_useFlag IS NOT NULL AND p_useFlag != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.USE_FLAG = ''', p_useFlag, ''''); END IF;
    IF p_enableYn IS NOT NULL AND p_enableYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.ENABLE_YN = ''', p_enableYn, ''''); END IF;
    IF p_sfdcYn IS NOT NULL AND p_sfdcYn != '' THEN SET v_sql = CONCAT(v_sql, ' AND A.SFDC_YN = ''', p_sfdcYn, ''''); END IF;

    SET @stmt = v_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ====================================================================================
-- 3. SP_SELECT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SELECT_MENU //
CREATE PROCEDURE SP_SELECT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_gsLang VARCHAR(10)
)
BEGIN
    DECLARE v_col_menuDesc VARCHAR(1000);
    DECLARE v_col_parentDesc VARCHAR(1000);

    IF p_gsLang = 'ko' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_KOR, A.MENU_DESC)';
    ELSEIF p_gsLang = 'en' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_EN, A.MENU_DESC)';
    ELSEIF p_gsLang = 'vi' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_VIET, A.MENU_DESC)';
    ELSEIF p_gsLang = 'etc' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_ETC, A.MENU_DESC)';
    ELSEIF p_gsLang = 'pt' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_PORT, A.MENU_DESC)';
    ELSE
        SET v_col_menuDesc = 'A.MENU_DESC';
    END IF;

    SET @sql = CONCAT(
        'SELECT A.SYS_ID AS "sysId", A.MENU_KEY AS "menuKey", ',
        v_col_menuDesc, ' AS "menuDesc", ',
        'A.MENU_DESC AS "menuDescKr", A.MENU_DESC_EN AS "menuDescEn", ',
        'A.MENU_DESC_VIET AS "menuDescVi", A.MENU_DESC_ETC AS "menuDescEtc", A.MENU_DESC_PORT AS "menuDescPort", ',
        'A.MENU_DIR AS "menuDir", A.MOBILE_TYPE AS "mobileType", A.MENU_URL AS "menuUrl", ',
        'A.PARENT_KEY AS "parentKey", A.PARENT_TYPE AS "parentType", A.CHILD_YN AS "childYn", ',
        'A.PROC_TYPE AS "procType", A.ACTION_YN AS "actionYn", A.ICON_CLS AS "iconCls", ',
        'A.SEPA_TEXT AS "sepaText", A.USE_FLAG AS "useFlag", A.ENABLE_YN AS "enableYn", ',
        'A.SFDC_YN AS "sfdcYn", A.REGI_ID AS "regiId", ',
        'DATE_FORMAT(A.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS "regiDate", ',
        'A.CHNG_ID AS "chngId", ',
        'DATE_FORMAT(A.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS "chngDate", ',
        'IFNULL(A.MENU_LEVEL, 0) AS "menuLevel", IFNULL(A.MENU_SEQ, 0) AS "menuSeq", ',
        'fn_get_menu_path(A.MENU_KEY, ''', p_gsLang, ''') AS "parentDesc", ',
        '''N'' AS "menuPath", ''N'' AS "helpYn" ',
        'FROM SYS_MENU A WHERE A.SYS_ID = ''', p_sysId, ''' AND A.MENU_KEY = ''', p_menuKey, ''''
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ====================================================================================
-- 4. SP_INSERT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_INSERT_MENU //
CREATE PROCEDURE SP_INSERT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuLevel INT,
    IN p_menuDescKr VARCHAR(100),
    IN p_menuDescEn VARCHAR(100),
    IN p_menuDescPort VARCHAR(100),
    IN p_menuDescViet VARCHAR(100),
    IN p_menuDescEtc VARCHAR(100),
    IN p_menuDir VARCHAR(500),
    IN p_mobileType VARCHAR(10),
    IN p_menuUrl VARCHAR(200),
    IN p_parentKey VARCHAR(50),
    IN p_parentType VARCHAR(50),
    IN p_childYn VARCHAR(1),
    IN p_procType VARCHAR(10),
    IN p_actionYn VARCHAR(1),
    IN p_iconCls VARCHAR(50),
    IN p_menuSeq INT,
    IN p_sepaText VARCHAR(50),
    IN p_enableYn VARCHAR(1),
    IN p_sfdcYn VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_MENU (
        SYS_ID, MENU_KEY, MENU_LEVEL, MENU_DESC, MENU_DESC_EN, MENU_DESC_PORT, MENU_DESC_VIET, MENU_DESC_ETC,
        MENU_DIR, MOBILE_TYPE, MENU_URL, PARENT_KEY, PARENT_TYPE, CHILD_YN, PROC_TYPE, ACTION_YN, ICON_CLS,
        MENU_SEQ, SEPA_TEXT, ENABLE_YN, SFDC_YN, USE_FLAG, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sysId, p_menuKey, p_menuLevel, p_menuDescKr, p_menuDescEn, p_menuDescPort, p_menuDescViet, p_menuDescEtc,
        p_menuDir, p_mobileType, p_menuUrl, p_parentKey, p_parentType, p_childYn, p_procType, p_actionYn, p_iconCls,
        p_menuSeq, p_sepaText, p_enableYn, p_sfdcYn, 'Y', p_gsUserId, NOW(), p_gsUserId, NOW()
    );
END //

-- ====================================================================================
-- 5. SP_UPDATE_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_UPDATE_MENU //
CREATE PROCEDURE SP_UPDATE_MENU(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_menuLevel INT,
    IN p_menuDescKr VARCHAR(100),
    IN p_menuDescEn VARCHAR(100),
    IN p_menuDescPort VARCHAR(100),
    IN p_menuDescViet VARCHAR(100),
    IN p_menuDescEtc VARCHAR(100),
    IN p_menuDir VARCHAR(500),
    IN p_mobileType VARCHAR(10),
    IN p_menuUrl VARCHAR(200),
    IN p_parentKey VARCHAR(50),
    IN p_parentType VARCHAR(50),
    IN p_childYn VARCHAR(1),
    IN p_procType VARCHAR(10),
    IN p_actionYn VARCHAR(1),
    IN p_iconCls VARCHAR(50),
    IN p_menuSeq INT,
    IN p_sepaText VARCHAR(50),
    IN p_enableYn VARCHAR(1),
    IN p_useFlag VARCHAR(1),
    IN p_sfdcYn VARCHAR(1),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    UPDATE SYS_MENU
    SET CHNG_ID = p_gsUserId, CHNG_DATE = NOW(),
        MENU_LEVEL = IF(p_menuLevel IS NULL, MENU_LEVEL, p_menuLevel),
        MENU_DESC = IF(p_menuDescKr IS NULL, MENU_DESC, p_menuDescKr),
        MENU_DESC_EN = IF(p_menuDescEn IS NULL, MENU_DESC_EN, p_menuDescEn),
        MENU_DESC_PORT = IF(p_menuDescPort IS NULL, MENU_DESC_PORT, p_menuDescPort),
        MENU_DESC_VIET = IF(p_menuDescViet IS NULL, MENU_DESC_VIET, p_menuDescViet),
        MENU_DESC_ETC = IF(p_menuDescEtc IS NULL, MENU_DESC_ETC, p_menuDescEtc),
        MENU_DIR = IF(p_menuDir IS NULL, MENU_DIR, p_menuDir),
        MOBILE_TYPE = IF(p_mobileType IS NULL, MOBILE_TYPE, p_mobileType),
        MENU_URL = IF(p_menuUrl IS NULL, MENU_URL, p_menuUrl),
        PARENT_KEY = IF(p_parentKey IS NULL, PARENT_KEY, p_parentKey),
        PARENT_TYPE = IF(p_parentType IS NULL, PARENT_TYPE, p_parentType),
        CHILD_YN = IF(p_childYn IS NULL, CHILD_YN, p_childYn),
        PROC_TYPE = IF(p_procType IS NULL, PROC_TYPE, p_procType),
        ACTION_YN = IF(p_actionYn IS NULL, ACTION_YN, p_actionYn),
        ICON_CLS = p_iconCls,
        MENU_SEQ = IF(p_menuSeq IS NULL, MENU_SEQ, p_menuSeq),
        SEPA_TEXT = IF(p_sepaText IS NULL, SEPA_TEXT, p_sepaText),
        ENABLE_YN = IF(p_enableYn IS NULL, ENABLE_YN, p_enableYn),
        USE_FLAG = IF(p_useFlag IS NULL, USE_FLAG, p_useFlag),
        SFDC_YN = IF(p_sfdcYn IS NULL, SFDC_YN, p_sfdcYn)
    WHERE SYS_ID = p_sysId AND MENU_KEY = p_menuKey;
END //

-- ====================================================================================
-- 6. SP_DELETE_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_DELETE_MENU //
CREATE PROCEDURE SP_DELETE_MENU(
    IN p_sysId VARCHAR(50),
    IN p_menuKey VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_MENU WHERE SYS_ID = p_sysId AND MENU_KEY = p_menuKey;
END //

-- ====================================================================================
-- 7. SP_SEARCH_AUTHORIZED_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SEARCH_AUTHORIZED_MENU //

CREATE PROCEDURE SP_SEARCH_AUTHORIZED_MENU(
    IN p_sysId      VARCHAR(50),
    IN p_userId     VARCHAR(50),
    IN p_lang       VARCHAR(10),
    IN p_mobileType VARCHAR(10),
    IN p_menuType   VARCHAR(50)
)
BEGIN
    -- ========================================
    -- 1. 변수 선언
    -- ========================================
    DECLARE v_sql LONGTEXT;
    DECLARE v_col_menuDesc VARCHAR(1000);
    DECLARE v_where_mobile VARCHAR(1000) DEFAULT '';
    DECLARE v_where_menuType VARCHAR(1000) DEFAULT '';
    DECLARE v_dealer_check VARCHAR(1000) DEFAULT '';

    -- ========================================
    -- 2. 다국어 컬럼 설정
    -- ========================================
    IF p_lang = 'ko' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_KOR, A.MENU_DESC)';
    ELSEIF p_lang = 'en' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_EN, A.MENU_DESC)';
    ELSEIF p_lang = 'vi' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_VIET, A.MENU_DESC)';
    ELSEIF p_lang = 'etc' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_ETC, A.MENU_DESC)';
    ELSEIF p_lang = 'pt' THEN
        SET v_col_menuDesc = 'IFNULL(A.MENU_DESC_PORT, A.MENU_DESC)';
    ELSE
        SET v_col_menuDesc = 'A.MENU_DESC';
    END IF;

    -- ========================================
    -- 3. WHERE 조건 설정
    -- ========================================
    -- 3-1. 모바일 타입 조건
    IF p_mobileType IS NOT NULL AND p_mobileType != '' THEN
        SET v_where_mobile = CONCAT(' AND A.MOBILE_TYPE = ''', p_mobileType, '''');
    ELSE
        -- 3-2. 메뉴 타입 조건
        IF p_menuType IS NOT NULL AND p_menuType != '' THEN
            SET v_where_menuType = CONCAT(
                ' AND FIND_IN_SET(''', p_menuType, ''', REPLACE(A.MENU_DIR, '' '', '''')) > 0'
            );
        ELSE
            SET v_where_menuType = ' AND A.MENU_DIR LIKE ''%Z%''';
        END IF;
    END IF;

    -- 3-3. 딜러 체크 조건 (menuType = 'A' 일 때만)
    IF p_menuType = 'A' THEN
        SET v_dealer_check = CONCAT(
            ' AND CASE WHEN (',
            '     SELECT COUNT(1) FROM nda_mast_info',
            '     WHERE sys_id = ''', p_sysId, '''',
            '       AND deal_code = ''', p_userId, '''',
            '       AND use_yn = ''Y''',
            ' ) = 0',
            ' THEN A.MENU_KEY NOT IN (''LS011'', ''LS120'')',
            ' ELSE 1 = 1 END '
        );
    ELSE
        SET v_dealer_check = ' AND 1 = 1 ';
    END IF;

    -- ========================================
    -- 4. 권한 조회 서브쿼리 (공통 사용)
    --    - 우선순위: 10.USER > 20.GROUP > 30.DEFAULT
    --    - auth_seq = 1 로 최고 우선순위만 선택
    -- ========================================
    -- 참고: 이 서브쿼리는 PROG_AUTH 조회와 childCnt 계산에 동일하게 사용됨

    -- ========================================
    -- 5. 메인 쿼리 생성
    -- ========================================
    SET v_sql = CONCAT(
        -- =====================================
        -- 전체 래퍼
        -- =====================================
        'SELECT * FROM ( ',

        -- =====================================
        -- PART 1: SYS_MENU 기반 메뉴 조회
        -- =====================================
        '  SELECT ',
        '    A.SYS_ID AS "sysId", ',
        '    A.MENU_KEY AS "menuKey", ',
             v_col_menuDesc, ' AS "menuDesc", ',
        '    A.MENU_DESC AS "menuDescKr", ',
        '    A.MENU_DESC_EN AS "menuDescEn", ',
        '    A.MENU_DESC_VIET AS "menuDescVi", ',
        '    A.MENU_DESC_ETC AS "menuDescEtc", ',
        '    A.MENU_DESC_PORT AS "menuDescPort", ',
        '    A.MENU_DIR AS "menuDir", ',
        '    A.MOBILE_TYPE AS "mobileType", ',
        '    A.MENU_URL AS "menuUrl", ',
        '    A.PARENT_KEY AS "parentKey", ',
        '    A.PARENT_TYPE AS "parentType", ',
        '    A.CHILD_YN AS "childYn", ',
        '    A.PROC_TYPE AS "procType", ',
        '    A.ACTION_YN AS "actionYn", ',
        '    A.ICON_CLS AS "iconCls", ',
        '    A.SEPA_TEXT AS "sepaText", ',
        '    A.USE_FLAG AS "useFlag", ',
        '    A.ENABLE_YN AS "enableYn", ',
        '    A.SFDC_YN AS "sfdcYn", ',
        '    A.REGI_ID AS "regiId", ',
        '    DATE_FORMAT(A.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS "regiDate", ',
        '    A.CHNG_ID AS "chngId", ',
        '    DATE_FORMAT(A.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS "chngDate", ',
        '    IFNULL(A.MENU_LEVEL, 0) AS "menuLevel", ',
        '    IFNULL(A.MENU_SEQ, 0) AS "menuSeq", ',
        '    fn_get_menu_path(A.MENU_KEY, ''', p_lang, ''') AS "parentDesc", ',
        '    ''N'' AS "menuPath", ',
        '    ''N'' AS "helpYn", ',

        -- -----------------------------------------
        -- 프로그램 권한 (B 서브쿼리)
        -- -----------------------------------------
        '    B.PROG_AUTH AS "progAuth", ',

        -- -----------------------------------------
        -- 하위 메뉴 개수 (MENU_LEVEL=1 일 때만 계산)
        -- -----------------------------------------
        '    (CASE A.MENU_LEVEL ',
        '       WHEN ''1'' THEN (',
        '         SELECT COUNT(C.MENU_KEY) ',
        '         FROM ( ',
        '           SELECT D.MENU_KEY, D.SYS_ID, D.PARENT_KEY ',
        '           FROM SYS_MENU D ',
        '           INNER JOIN ( ',
                       -- 권한 서브쿼리 (childCnt용)
        '             SELECT a.sys_id, a.user_id, a.prog_id, a.tran_a ',
        '             FROM sys_upgm a ',
        '             WHERE a.sys_id = ''', p_sysId, ''' ',
        '               AND a.user_id = ''', p_userId, ''' ',
        '             UNION ',
        '             SELECT a.sys_id, b.user_id, a.prog_id, MAX(a.tran_a) as tran_a ',
        '             FROM sys_gpgm a ',
        '             JOIN sys_ugrp b ON a.sys_id = b.sys_id AND a.group_id = b.group_id ',
        '             WHERE b.sys_id = ''', p_sysId, ''' ',
        '               AND b.user_id = ''', p_userId, ''' ',
        '             GROUP BY a.sys_id, b.user_id, a.prog_id ',
        '             UNION ',
        '             SELECT a.sys_id, b.user_id, a.prog_id, ''0'' as tran_a ',
        '             FROM sys_prog a ',
        '             JOIN sys_user b ON a.sys_id = b.sys_id ',
        '             WHERE b.sys_id = ''', p_sysId, ''' ',
        '               AND b.user_id = ''', p_userId, ''' ',
        '           ) E ON D.SYS_ID = E.SYS_ID AND D.MENU_URL = E.PROG_ID ',
        '           WHERE E.USER_ID = ''', p_userId, ''' ',
        '             AND TRAN_A = ''1'' ',
        '         ) C ',
        '         WHERE C.SYS_ID = A.SYS_ID ',
        '           AND C.PARENT_KEY = A.MENU_KEY',
        '       ) ',
        '       WHEN ''2'' THEN 1 ',
        '       ELSE 1 ',
        '     END) AS "childCnt" ',

        -- -----------------------------------------
        -- FROM 절
        -- -----------------------------------------
        '  FROM SYS_MENU A ',

        -- -----------------------------------------
        -- LEFT JOIN: 권한 정보 (B 서브쿼리)
        -- -----------------------------------------
        '  LEFT OUTER JOIN ( ',
        '    SELECT PROG_ID, TRAN_A AS PROG_AUTH ',
        '    FROM ( ',
        '      SELECT x.sys_id, x.user_id, x.prog_id, x.tran_a ',
        '      FROM ( ',
        '        SELECT a.* ',
        '        FROM ( ',
                   -- 행번호 매기기 (우선순위 적용)
        '          SELECT ',
        '            (CASE @vjob WHEN a.prog_id THEN @rownum:=@rownum+1 ELSE @rownum:=1 END) auth_seq, ',
        '            (@vjob:=a.prog_id) vjob, ',
        '            a.* ',
        '          FROM ( ',
                     -- 1순위: 개인 권한 (SYS_UPGM)
        '            SELECT a.sys_id, a.user_id, ''10.USER'' as auth_type, a.prog_id, a.tran_a ',
        '            FROM sys_upgm a ',
        '            WHERE a.sys_id = ''', p_sysId, ''' ',
        '              AND a.user_id = ''', p_userId, ''' ',
        '            UNION ',
                     -- 2순위: 그룹 권한 (SYS_GPGM)
        '            SELECT a.sys_id, b.user_id, ''20.GROUP'' as auth_type, a.prog_id, MAX(a.tran_a) ',
        '            FROM sys_gpgm a ',
        '            JOIN sys_ugrp b ON a.sys_id = b.sys_id AND a.group_id = b.group_id ',
        '            WHERE b.sys_id = ''', p_sysId, ''' ',
        '              AND b.user_id = ''', p_userId, ''' ',
        '            GROUP BY a.sys_id, b.user_id, a.prog_id ',
        '            UNION ',
                     -- 3순위: 기본 권한 (SYS_PROG)
        '            SELECT a.sys_id, b.user_id, ''30.DEFAULT'' as auth_type, a.prog_id, ''0'' ',
        '            FROM sys_prog a ',
        '            JOIN sys_user b ON a.sys_id = b.sys_id ',
        '            WHERE b.sys_id = ''', p_sysId, ''' ',
        '              AND b.user_id = ''', p_userId, ''' ',
        '          ) a, (SELECT @vjob:='''', @rownum:=0 FROM DUAL) b ',
        '          ORDER BY a.sys_id, a.user_id, a.prog_id, a.auth_type ',
        '        ) a ',
        '        WHERE a.auth_seq = 1 ',  -- 가장 높은 우선순위만
        '      ) x ',
        '    ) B_SUB ',
        '    WHERE SYS_ID = ''', p_sysId, ''' ',
        '      AND USER_ID = ''', p_userId, ''' ',
        '  ) B ON A.MENU_URL = B.PROG_ID ',

        -- -----------------------------------------
        -- WHERE 절
        -- -----------------------------------------
        '  WHERE A.SYS_ID = ''', p_sysId, ''' ',
             v_where_mobile,
             v_where_menuType,
             v_dealer_check,
        '    AND A.USE_FLAG = ''Y'' ',

        -- =====================================
        -- PART 2: 동호회 메뉴 (COMU_INFO)
        -- =====================================
        ' UNION ALL ',
        ' SELECT ',
        '   C.SYS_ID AS "sysId", ',
        '   C.COMU_ID AS "menuKey", ',
        '   C.COMU_NAME AS "menuDesc", ',
        '   C.COMU_NAME AS "menuDescKr", ',
        '   C.COMU_NAME AS "menuDescEn", ',
        '   C.COMU_NAME AS "menuDescVi", ',
        '   C.COMU_NAME AS "menuDescEtc", ',
        '   C.COMU_NAME AS "menuDescPort", ',
        '   ''Z,M'' AS "menuDir", ',
        '   ''M'' AS "mobileType", ',
        '   ''/common/board/alter/alter.do'' AS "menuUrl", ',
        '   ''동호회'' AS "parentKey", ',
        '   ''SHOOT'' AS "parentType", ',
        '   ''N'' AS "childYn", ',
        '   ''T'' AS "procType", ',
        '   ''N'' AS "actionYn", ',
        '   ''fa-print'' AS "iconCls", ',
        '   '''' AS "sepaText", ',
        '   ''Y'' AS "useFlag", ',
        '   ''Y'' AS "enableYn", ',
        '   C.REGI_ID AS "regiId", ',
        '   DATE_FORMAT(C.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS "regiDate", ',
        '   C.CHNG_ID AS "chngId", ',
        '   DATE_FORMAT(C.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS "chngDate", ',
        '   3 AS "menuLevel", ',
        '   C.COMU_SEQ AS "menuSeq", ',
        '   ''동호회2'' AS "parentDesc", ',
        '   ''1'' AS "progAuth", ',
        '   6 AS "childCnt", ',
        '   ''N'' AS "sfdcYn", ',
        '   ''N'' AS "menuPath", ',
        '   ''N'' AS "helpYn" ',
        ' FROM COMU_INFO C ',
        ' WHERE C.SYS_ID = ''', p_sysId, ''' ',
        '   AND C.USE_YN = ''Y'' ',

        -- =====================================
        -- PART 3: 동호회 하위 메뉴 (COMU_MENU)
        -- =====================================
        ' UNION ALL ',
        ' SELECT ',
        '   D.SYS_ID AS "sysId", ',
        '   CONCAT(D.COMU_ID, D.MENU_ID) AS "menuKey", ',
        '   D.MENU_NAME AS "menuDesc", ',
        '   D.MENU_NAME AS "menuDescKr", ',
        '   D.MENU_NAME AS "menuDescEn", ',
        '   D.MENU_NAME AS "menuDescVi", ',
        '   D.MENU_NAME AS "menuDescEtc", ',
        '   D.MENU_NAME AS "menuDescPort", ',
        '   ''Z,M'' AS "menuDir", ',
        '   ''M'' AS "mobileType", ',
        '   ''/common/board/reference/reference.do'' AS "menuUrl", ',
        '   D.COMU_ID AS "parentKey", ',
        '   ''SHOOT'' AS "parentType", ',
        '   ''N'' AS "childYn", ',
        '   ''T'' AS "procType", ',
        '   ''N'' AS "actionYn", ',
        '   ''fa-print'' AS "iconCls", ',
        '   '''' AS "sepaText", ',
        '   ''Y'' AS "useFlag", ',
        '   ''Y'' AS "enableYn", ',
        '   D.REGI_ID AS "regiId", ',
        '   DATE_FORMAT(D.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS "regiDate", ',
        '   D.CHNG_ID AS "chngId", ',
        '   DATE_FORMAT(D.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS "chngDate", ',
        '   4 AS "menuLevel", ',
        '   SUBSTRING(D.BORD_NO, 2, 9)+0 AS "menuSeq", ',
        '   (SELECT COMU_NAME FROM COMU_INFO A ',
        '    WHERE A.SYS_ID = D.SYS_ID AND A.COMU_ID = D.COMU_ID) AS "parentDesc", ',
        '   ''1'' AS "progAuth", ',
        '   1 AS "childCnt", ',
        '   ''N'' AS "sfdcYn", ',
        '   ''N'' AS "menuPath", ',
        '   ''N'' AS "helpYn" ',
        ' FROM COMU_MENU D ',
        ' WHERE D.SYS_ID = ''', p_sysId, ''' ',
        '   AND D.USE_YN = ''Y'' ',

        -- =====================================
        -- 정렬
        -- =====================================
        ' ) M ',
        ' ORDER BY M.menuLevel, CAST(M.menuSeq AS DECIMAL(5,0)) '
    );

    -- ========================================
    -- 6. 쿼리 실행
    -- ========================================
    SET @stmt = v_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //

-- ====================================================================================
-- 8. SP_SEARCH_HOT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SEARCH_HOT_MENU //
CREATE PROCEDURE SP_SEARCH_HOT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_userId VARCHAR(50),
    IN p_gsUserId VARCHAR(50),
    IN p_gsLang VARCHAR(10),
    IN p_gsMobileType VARCHAR(10),
    IN p_gsMenuType VARCHAR(50)
)
BEGIN
    DECLARE v_sql LONGTEXT;
    DECLARE v_col_menuDesc VARCHAR(1000);
    DECLARE v_where_mobile VARCHAR(1000) DEFAULT '';
    DECLARE v_where_menuType VARCHAR(1000) DEFAULT '';

    IF p_gsLang = 'ko' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_KOR, B.MENU_DESC)';
    ELSEIF p_gsLang = 'en' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_EN, B.MENU_DESC)';
    ELSEIF p_gsLang = 'vi' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_VIET, B.MENU_DESC)';
    ELSEIF p_gsLang = 'etc' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_ETC, B.MENU_DESC)';
    ELSEIF p_gsLang = 'pt' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_PORT, B.MENU_DESC)';
    ELSE SET v_col_menuDesc = 'B.MENU_DESC';
    END IF;

    IF p_gsMobileType IS NOT NULL AND p_gsMobileType != '' THEN
        SET v_where_mobile = CONCAT(' AND B.MOBILE_TYPE = ''', p_gsMobileType, '''');
    ELSE
        IF p_gsMenuType IS NOT NULL AND p_gsMenuType != '' THEN
            SET v_where_menuType = CONCAT(' AND (B.MENU_DIR LIKE ''%Z%'' OR B.MENU_DIR LIKE CONCAT(''%'', ''', p_gsMenuType, ''', ''%''))');
        ELSE
            SET v_where_menuType = ' AND B.MENU_DIR LIKE ''%Z%''';
        END IF;
    END IF;

    SET v_sql = CONCAT(
        'SELECT A.SYS_ID AS "sysId", A.USER_ID AS "userId", A.MENU_KEY AS "menuKey", ',
        v_col_menuDesc, ' AS "menuDesc", ',
        'B.MENU_URL AS "menuUrl", B.ICON_CLS AS "iconCls", B.ENABLE_YN AS "enableYn", ',
        'A.SORT_SEQ AS "sortSeq", A.REGI_ID AS "regiId", ',
        'DATE_FORMAT(A.REGI_DATE,''%Y-%m-%d %H:%i:%s'') AS "regiDate", ',
        'A.CHNG_ID AS "chngId", ',
        'DATE_FORMAT(A.CHNG_DATE,''%Y-%m-%d %H:%i:%s'') AS "chngDate", ',
        'IFNULL(C.PROG_AUTH, ''0'') AS "progAuth" ',
        'FROM SYS_MENU_HOT A ',
        'INNER JOIN SYS_MENU B ON A.SYS_ID = B.SYS_ID AND A.MENU_KEY = B.MENU_KEY ',
        'LEFT OUTER JOIN ( ',
        '    SELECT PROG_ID, TRAN_A AS PROG_AUTH FROM ( ',
        '        SELECT x.sys_id, x.user_id, x.prog_id, x.tran_a ',
        '        FROM ( ',
        '            SELECT a.* FROM ( ',
        '                SELECT (CASE @vjob WHEN a.prog_id THEN @rownum:=@rownum+1 ELSE @rownum:=1 END) auth_seq, ',
        '                       (@vjob:=a.prog_id) vjob, a.* ',
        '                FROM ( ',
        '                    SELECT a.sys_id, a.user_id, ''10.USER'' as auth_type, a.prog_id, a.tran_a ',
        '                    FROM sys_upgm a WHERE a.sys_id = ''', p_sysId, ''' AND a.user_id = ''', p_gsUserId, ''' ',
        '                    UNION ',
        '                    SELECT a.sys_id, b.user_id, ''20.GROUP'' as auth_type, a.prog_id, MAX(a.tran_a) ',
        '                    FROM sys_gpgm a JOIN sys_ugrp b ON a.sys_id = b.sys_id AND a.group_id = b.group_id ',
        '                    WHERE b.sys_id = ''', p_sysId, ''' AND b.user_id = ''', p_gsUserId, ''' GROUP BY a.sys_id, b.user_id, a.prog_id ',
        '                    UNION ',
        '                    SELECT a.sys_id, b.user_id, ''30.DEFAULT'' as auth_type, a.prog_id, ''0'' ',
        '                    FROM sys_prog a JOIN sys_user b ON a.sys_id = b.sys_id ',
        '                    WHERE b.sys_id = ''', p_sysId, ''' AND b.user_id = ''', p_gsUserId, ''' ',
        '                ) a, (SELECT @vjob:='''', @rownum:=0 FROM DUAL) b ',
        '                ORDER BY a.sys_id, a.user_id, a.prog_id, a.auth_type ',
        '            ) a WHERE a.auth_seq = 1 ',
        '        ) x ',
        '    ) B_SUB WHERE SYS_ID = ''', p_sysId, ''' AND USER_ID = ''', p_gsUserId, ''' ',
        ') C ON B.MENU_URL = C.PROG_ID ',
        'WHERE A.SYS_ID = ''', p_sysId, ''' AND A.USER_ID = ''', p_userId, ''' ',
        v_where_mobile,
        v_where_menuType,
        ' ORDER BY A.SORT_SEQ, A.REGI_DATE, A.CHNG_DATE'
    );

    SET @stmt = v_sql;
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ====================================================================================
-- 9. SP_SEARCH_HOT_COUNT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SEARCH_HOT_COUNT_MENU //
CREATE PROCEDURE SP_SEARCH_HOT_COUNT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_userId VARCHAR(50)
)
BEGIN
    SELECT COUNT(1)
    FROM SYS_MENU_HOT A
    INNER JOIN SYS_MENU B ON A.SYS_ID = B.SYS_ID AND A.MENU_KEY = B.MENU_KEY
    WHERE A.SYS_ID = p_sysId AND A.USER_ID = p_userId;
END //

-- ====================================================================================
-- 10. SP_SELECT_HOT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SELECT_HOT_MENU //
CREATE PROCEDURE SP_SELECT_HOT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_userId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_gsLang VARCHAR(10)
)
BEGIN
    DECLARE v_col_menuDesc VARCHAR(1000);

    IF p_gsLang = 'ko' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_KOR, B.MENU_DESC)';
    ELSEIF p_gsLang = 'en' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_EN, B.MENU_DESC)';
    ELSEIF p_gsLang = 'vi' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_VIET, B.MENU_DESC)';
    ELSEIF p_gsLang = 'etc' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_ETC, B.MENU_DESC)';
    ELSEIF p_gsLang = 'pt' THEN SET v_col_menuDesc = 'IFNULL(B.MENU_DESC_PORT, B.MENU_DESC)';
    ELSE SET v_col_menuDesc = 'B.MENU_DESC';
    END IF;

    SET @sql = CONCAT(
        'SELECT A.SYS_ID AS "sysId", A.USER_ID AS "userId", A.MENU_KEY AS "menuKey", ',
        v_col_menuDesc, ' AS "menuDesc", ',
        'B.MENU_URL AS "menuUrl", B.ICON_CLS AS "iconCls", B.ENABLE_YN AS "enableYn", ',
        'A.SORT_SEQ AS "sortSeq", A.REGI_ID AS "regiId", ',
        'DATE_FORMAT(A.REGI_DATE,''%Y-%m-%d %H:%i:%s'') AS "regiDate", ',
        'A.CHNG_ID AS "chngId", ',
        'DATE_FORMAT(A.CHNG_DATE,''%Y-%m-%d %H:%i:%s'') AS "chngDate" ',
        'FROM SYS_MENU_HOT A ',
        'INNER JOIN SYS_MENU B ON A.SYS_ID = B.SYS_ID AND A.MENU_KEY = B.MENU_KEY ',
        'WHERE A.SYS_ID = ''', p_sysId, ''' AND A.USER_ID = ''', p_userId, ''' AND A.MENU_KEY = ''', p_menuKey, ''''
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ====================================================================================
-- 11. SP_INSERT_HOT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_INSERT_HOT_MENU //
CREATE PROCEDURE SP_INSERT_HOT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_userId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_MENU_HOT (SYS_ID, MENU_KEY, USER_ID, SORT_SEQ, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE)
    VALUES (
        p_sysId, p_menuKey, p_userId,
        IFNULL((SELECT MAX(A.SORT_SEQ) FROM SYS_MENU_HOT A WHERE A.SYS_ID = p_sysId AND A.USER_ID = p_userId), 0) + 1,
        p_gsUserId, NOW(), p_gsUserId, NOW()
    );
END //

-- ====================================================================================
-- 12. SP_UPDATE_HOT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_UPDATE_HOT_MENU //
CREATE PROCEDURE SP_UPDATE_HOT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_userId VARCHAR(50),
    IN p_menuKey VARCHAR(50),
    IN p_sortSeq INT,
    IN p_gsUserId VARCHAR(50)
)
BEGIN
    UPDATE SYS_MENU_HOT
    SET CHNG_ID = p_gsUserId, CHNG_DATE = NOW(), SORT_SEQ = p_sortSeq
    WHERE SYS_ID = p_sysId AND USER_ID = p_userId AND MENU_KEY = p_menuKey;
END //

-- ====================================================================================
-- 13. SP_DELETE_HOT_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_DELETE_HOT_MENU //
CREATE PROCEDURE SP_DELETE_HOT_MENU(
    IN p_sysId VARCHAR(50),
    IN p_userId VARCHAR(50),
    IN p_menuKey VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_MENU_HOT WHERE SYS_ID = p_sysId AND USER_ID = p_userId AND MENU_KEY = p_menuKey;
END //

-- ====================================================================================
-- 14. SP_SEARCH_TYPE_MENU
-- ====================================================================================
DROP PROCEDURE IF EXISTS SP_SEARCH_TYPE_MENU //
CREATE PROCEDURE SP_SEARCH_TYPE_MENU(
    IN p_sysId VARCHAR(50)
)
BEGIN
    SELECT CODE_CD AS "menuType", CODE_NAME AS "menuTypeName"
    FROM SYS_CODE
    WHERE SYS_ID = p_sysId AND CODE_GRUP = 'MENU_GB' AND USE_FLAG = 'Y'
    ORDER BY SORT_SEQ;
END //

DELIMITER ;
