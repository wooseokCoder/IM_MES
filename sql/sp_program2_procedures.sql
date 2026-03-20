-- ============================================================
-- Program2.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- 대상 테이블: SYS_PROG, SYS_GPGM, SYS_UPGM
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 프로그램 목록 조회 (페이징) - search
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_search//

CREATE PROCEDURE sp_program2_search(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_prog_name VARCHAR(200),
    IN p_prog_type VARCHAR(20),
    IN p_sys_loc VARCHAR(50),
    IN p_use_flag VARCHAR(1),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;
    SET @sort_clause = IF(p_sort_str IS NULL OR p_sort_str = '', 'A.REGI_DATE DESC, A.CHNG_DATE DESC', p_sort_str);

    SET @sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
                FROM (
                    SELECT
                        A.SYS_ID AS sysId,
                        A.PROG_ID AS progId,
                        A.TRAN_A AS tranA,
                        A.TRAN_C AS tranC,
                        A.TRAN_R AS tranR,
                        A.TRAN_U AS tranU,
                        A.TRAN_D AS tranD,
                        A.TRAN_P AS tranP,
                        A.TRAN_S AS tranS,
                        A.TRAN_1 AS tran1,
                        A.TRAN_2 AS tran2,
                        A.TRAN_3 AS tran3,
                        A.TRAN_4 AS tran4,
                        A.TRAN_5 AS tran5,
                        A.REGI_ID AS regiId,
                        DATE_FORMAT(A.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                        A.CHNG_ID AS chngId,
                        DATE_FORMAT(A.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate,
                        A.PROG_NAME AS progName,
                        A.PROG_TYPE AS progType,
                        A.SYS_LOC AS sysLoc,
                        A.USE_FLAG AS useFlag
                    FROM SYS_PROG A
                    WHERE A.SYS_ID = ''', p_sys_id, '''
                      AND (''', IFNULL(p_prog_id, ''), ''' = '''' OR A.PROG_ID LIKE CONCAT(''%'', ''', IFNULL(p_prog_id, ''), ''', ''%''))
                      AND (''', IFNULL(p_prog_name, ''), ''' = '''' OR A.PROG_NAME LIKE CONCAT(''%'', ''', IFNULL(p_prog_name, ''), ''', ''%''))
                      AND (''', IFNULL(p_prog_type, ''), ''' = '''' OR A.PROG_TYPE = ''', IFNULL(p_prog_type, ''), ''')
                      AND (''', IFNULL(p_sys_loc, ''), ''' = '''' OR A.SYS_LOC = ''', IFNULL(p_sys_loc, ''), ''')
                      AND (''', IFNULL(p_use_flag, ''), ''' = '''' OR A.USE_FLAG = ''', IFNULL(p_use_flag, ''), ''')
                      AND (''', IFNULL(p_tran_a, ''), ''' = '''' OR A.TRAN_A = ''', IFNULL(p_tran_a, ''), ''')
                      AND (''', IFNULL(p_tran_c, ''), ''' = '''' OR A.TRAN_C = ''', IFNULL(p_tran_c, ''), ''')
                      AND (''', IFNULL(p_tran_r, ''), ''' = '''' OR A.TRAN_R = ''', IFNULL(p_tran_r, ''), ''')
                      AND (''', IFNULL(p_tran_u, ''), ''' = '''' OR A.TRAN_U = ''', IFNULL(p_tran_u, ''), ''')
                      AND (''', IFNULL(p_tran_d, ''), ''' = '''' OR A.TRAN_D = ''', IFNULL(p_tran_d, ''), ''')
                      AND (''', IFNULL(p_tran_p, ''), ''' = '''' OR A.TRAN_P = ''', IFNULL(p_tran_p, ''), ''')
                      AND (''', IFNULL(p_tran_s, ''), ''' = '''' OR A.TRAN_S = ''', IFNULL(p_tran_s, ''), ''')
                      AND (''', IFNULL(p_tran_1, ''), ''' = '''' OR A.TRAN_1 = ''', IFNULL(p_tran_1, ''), ''')
                      AND (''', IFNULL(p_tran_2, ''), ''' = '''' OR A.TRAN_2 = ''', IFNULL(p_tran_2, ''), ''')
                      AND (''', IFNULL(p_tran_3, ''), ''' = '''' OR A.TRAN_3 = ''', IFNULL(p_tran_3, ''), ''')
                      AND (''', IFNULL(p_tran_4, ''), ''' = '''' OR A.TRAN_4 = ''', IFNULL(p_tran_4, ''), ''')
                      AND (''', IFNULL(p_tran_5, ''), ''' = '''' OR A.TRAN_5 = ''', IFNULL(p_tran_5, ''), ''')
                    ORDER BY ', @sort_clause, '
                ) Z1, (SELECT @rownum := 0) Z2
            ) X
            WHERE (CASE WHEN ', IFNULL(p_end, 'NULL'), ' IS NOT NULL THEN RNUM < ', IFNULL(p_end, 0), ' ELSE 1=1 END)
        ) X
        WHERE (CASE WHEN ', IFNULL(p_start, 'NULL'), ' IS NOT NULL THEN RNUM >= ', IFNULL(p_start, 0), ' ELSE 1=1 END)
    ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. 프로그램 목록 카운트 - searchCount
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_search_count//

CREATE PROCEDURE sp_program2_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_prog_name VARCHAR(200),
    IN p_prog_type VARCHAR(20),
    IN p_sys_loc VARCHAR(50),
    IN p_use_flag VARCHAR(1),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_PROG A
    WHERE A.SYS_ID = p_sys_id
      AND (p_prog_id IS NULL OR p_prog_id = '' OR A.PROG_ID LIKE CONCAT('%', p_prog_id, '%'))
      AND (p_prog_name IS NULL OR p_prog_name = '' OR A.PROG_NAME LIKE CONCAT('%', p_prog_name, '%'))
      AND (p_prog_type IS NULL OR p_prog_type = '' OR A.PROG_TYPE = p_prog_type)
      AND (p_sys_loc IS NULL OR p_sys_loc = '' OR A.SYS_LOC = p_sys_loc)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR A.USE_FLAG = p_use_flag)
      AND (p_tran_a IS NULL OR p_tran_a = '' OR A.TRAN_A = p_tran_a)
      AND (p_tran_c IS NULL OR p_tran_c = '' OR A.TRAN_C = p_tran_c)
      AND (p_tran_r IS NULL OR p_tran_r = '' OR A.TRAN_R = p_tran_r)
      AND (p_tran_u IS NULL OR p_tran_u = '' OR A.TRAN_U = p_tran_u)
      AND (p_tran_d IS NULL OR p_tran_d = '' OR A.TRAN_D = p_tran_d)
      AND (p_tran_p IS NULL OR p_tran_p = '' OR A.TRAN_P = p_tran_p)
      AND (p_tran_s IS NULL OR p_tran_s = '' OR A.TRAN_S = p_tran_s)
      AND (p_tran_1 IS NULL OR p_tran_1 = '' OR A.TRAN_1 = p_tran_1)
      AND (p_tran_2 IS NULL OR p_tran_2 = '' OR A.TRAN_2 = p_tran_2)
      AND (p_tran_3 IS NULL OR p_tran_3 = '' OR A.TRAN_3 = p_tran_3)
      AND (p_tran_4 IS NULL OR p_tran_4 = '' OR A.TRAN_4 = p_tran_4)
      AND (p_tran_5 IS NULL OR p_tran_5 = '' OR A.TRAN_5 = p_tran_5);
END//

-- ============================================================
-- 3. 프로그램 단건 조회 - select
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_select//

CREATE PROCEDURE sp_program2_select(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100)
)
BEGIN
    SELECT
        A.SYS_ID AS sysId,
        A.PROG_ID AS progId,
        A.TRAN_A AS tranA,
        A.TRAN_C AS tranC,
        A.TRAN_R AS tranR,
        A.TRAN_U AS tranU,
        A.TRAN_D AS tranD,
        A.TRAN_P AS tranP,
        A.TRAN_S AS tranS,
        A.TRAN_1 AS tran1,
        A.TRAN_2 AS tran2,
        A.TRAN_3 AS tran3,
        A.TRAN_4 AS tran4,
        A.TRAN_5 AS tran5,
        A.REGI_ID AS regiId,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID AS chngId,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        A.PROG_NAME AS progName,
        A.PROG_TYPE AS progType,
        A.SYS_LOC AS sysLoc,
        A.USE_FLAG AS useFlag
    FROM SYS_PROG A
    WHERE A.SYS_ID = p_sys_id
      AND A.PROG_ID = p_prog_id;
END//

-- ============================================================
-- 4. 프로그램 등록 - insert
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_insert//

CREATE PROCEDURE sp_program2_insert(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_prog_name VARCHAR(200),
    IN p_prog_type VARCHAR(20),
    IN p_sys_loc VARCHAR(50),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_PROG (
        SYS_ID,
        PROG_ID,
        TRAN_A,
        TRAN_C,
        TRAN_R,
        TRAN_U,
        TRAN_D,
        TRAN_P,
        TRAN_S,
        TRAN_1,
        TRAN_2,
        TRAN_3,
        TRAN_4,
        TRAN_5,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE,
        PROG_TYPE,
        SYS_LOC,
        PROG_NAME,
        USE_FLAG
    ) VALUES (
        p_sys_id,
        p_prog_id,
        IFNULL(p_tran_a, '0'),
        IFNULL(p_tran_c, '0'),
        IFNULL(p_tran_r, '0'),
        IFNULL(p_tran_u, '0'),
        IFNULL(p_tran_d, '0'),
        IFNULL(p_tran_p, '0'),
        IFNULL(p_tran_s, '0'),
        IFNULL(p_tran_1, '0'),
        IFNULL(p_tran_2, '0'),
        IFNULL(p_tran_3, '0'),
        IFNULL(p_tran_4, '0'),
        IFNULL(p_tran_5, '0'),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW(),
        IFNULL(p_prog_type, ''),
        IFNULL(p_sys_loc, ''),
        p_prog_name,
        'Y'
    );
END//

-- ============================================================
-- 5. 프로그램 수정 - update
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_update//

CREATE PROCEDURE sp_program2_update(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_prog_name VARCHAR(200),
    IN p_prog_type VARCHAR(20),
    IN p_sys_loc VARCHAR(50),
    IN p_use_flag VARCHAR(1),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_PROG
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        TRAN_A = CASE WHEN p_tran_a IS NOT NULL AND p_tran_a != '' THEN p_tran_a ELSE TRAN_A END,
        TRAN_C = CASE WHEN p_tran_c IS NOT NULL AND p_tran_c != '' THEN p_tran_c ELSE TRAN_C END,
        TRAN_R = CASE WHEN p_tran_r IS NOT NULL AND p_tran_r != '' THEN p_tran_r ELSE TRAN_R END,
        TRAN_U = CASE WHEN p_tran_u IS NOT NULL AND p_tran_u != '' THEN p_tran_u ELSE TRAN_U END,
        TRAN_D = CASE WHEN p_tran_d IS NOT NULL AND p_tran_d != '' THEN p_tran_d ELSE TRAN_D END,
        TRAN_P = CASE WHEN p_tran_p IS NOT NULL AND p_tran_p != '' THEN p_tran_p ELSE TRAN_P END,
        TRAN_S = CASE WHEN p_tran_s IS NOT NULL AND p_tran_s != '' THEN p_tran_s ELSE TRAN_S END,
        TRAN_1 = CASE WHEN p_tran_1 IS NOT NULL AND p_tran_1 != '' THEN p_tran_1 ELSE TRAN_1 END,
        TRAN_2 = CASE WHEN p_tran_2 IS NOT NULL AND p_tran_2 != '' THEN p_tran_2 ELSE TRAN_2 END,
        TRAN_3 = CASE WHEN p_tran_3 IS NOT NULL AND p_tran_3 != '' THEN p_tran_3 ELSE TRAN_3 END,
        TRAN_4 = CASE WHEN p_tran_4 IS NOT NULL AND p_tran_4 != '' THEN p_tran_4 ELSE TRAN_4 END,
        TRAN_5 = CASE WHEN p_tran_5 IS NOT NULL AND p_tran_5 != '' THEN p_tran_5 ELSE TRAN_5 END,
        PROG_NAME = CASE WHEN p_prog_name IS NOT NULL AND p_prog_name != '' THEN p_prog_name ELSE PROG_NAME END,
        PROG_TYPE = CASE WHEN p_prog_type IS NOT NULL AND p_prog_type != '' THEN p_prog_type ELSE PROG_TYPE END,
        SYS_LOC = CASE WHEN p_sys_loc IS NOT NULL AND p_sys_loc != '' THEN p_sys_loc ELSE SYS_LOC END,
        USE_FLAG = CASE WHEN p_use_flag IS NOT NULL AND p_use_flag != '' THEN p_use_flag ELSE USE_FLAG END
    WHERE SYS_ID = p_sys_id
      AND PROG_ID = p_prog_id;
END//

-- ============================================================
-- 6. 프로그램 삭제 - delete
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_delete//

CREATE PROCEDURE sp_program2_delete(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100)
)
BEGIN
    DELETE FROM SYS_PROG
    WHERE SYS_ID = p_sys_id
      AND PROG_ID = p_prog_id;
END//

-- ============================================================
-- 7. 그룹-프로그램 목록 조회 (페이징) - searchGroupProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_search_group_program//

CREATE PROCEDURE sp_program2_search_group_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_group_id VARCHAR(50),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;
    SET @sort_clause = IF(p_sort_str IS NULL OR p_sort_str = '', 'A.REGI_DATE DESC, A.CHNG_DATE DESC', p_sort_str);

    SET @sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
                FROM (
                    SELECT
                        A.SYS_ID AS sysId,
                        A.PROG_ID AS progId,
                        A.TRAN_A AS tranA,
                        A.TRAN_C AS tranC,
                        A.TRAN_R AS tranR,
                        A.TRAN_U AS tranU,
                        A.TRAN_D AS tranD,
                        A.TRAN_P AS tranP,
                        A.TRAN_S AS tranS,
                        A.TRAN_1 AS tran1,
                        A.TRAN_2 AS tran2,
                        A.TRAN_3 AS tran3,
                        A.TRAN_4 AS tran4,
                        A.TRAN_5 AS tran5,
                        A.REGI_ID AS regiId,
                        DATE_FORMAT(A.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                        A.CHNG_ID AS chngId,
                        DATE_FORMAT(A.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate,
                        A.GROUP_ID AS groupId,
                        (SELECT GROUP_NAME FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS groupName,
                        (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS progName
                    FROM SYS_GPGM A
                    WHERE A.SYS_ID = ''', p_sys_id, '''
                      AND (''', IFNULL(p_prog_id, ''), ''' = '''' OR A.PROG_ID = ''', IFNULL(p_prog_id, ''), ''')
                      AND (''', IFNULL(p_group_id, ''), ''' = '''' OR A.GROUP_ID = ''', IFNULL(p_group_id, ''), ''')
                    ORDER BY ', @sort_clause, '
                ) Z1, (SELECT @rownum := 0) Z2
            ) X
            WHERE (CASE WHEN ', IFNULL(p_end, 'NULL'), ' IS NOT NULL THEN RNUM < ', IFNULL(p_end, 0), ' ELSE 1=1 END)
        ) X
        WHERE (CASE WHEN ', IFNULL(p_start, 'NULL'), ' IS NOT NULL THEN RNUM >= ', IFNULL(p_start, 0), ' ELSE 1=1 END)
    ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 8. 그룹-프로그램 목록 카운트 - searchGroupProgramCount
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_search_group_program_count//

CREATE PROCEDURE sp_program2_search_group_program_count(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_group_id VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_GPGM A
    WHERE A.SYS_ID = p_sys_id
      AND (p_prog_id IS NULL OR p_prog_id = '' OR A.PROG_ID = p_prog_id)
      AND (p_group_id IS NULL OR p_group_id = '' OR A.GROUP_ID = p_group_id);
END//

-- ============================================================
-- 9. 그룹-프로그램 단건 조회 - selectGroupProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_select_group_program//

CREATE PROCEDURE sp_program2_select_group_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_group_id VARCHAR(50),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1)
)
BEGIN
    SELECT
        A.SYS_ID AS sysId,
        A.PROG_ID AS progId,
        A.TRAN_A AS tranA,
        A.TRAN_C AS tranC,
        A.TRAN_R AS tranR,
        A.TRAN_U AS tranU,
        A.TRAN_D AS tranD,
        A.TRAN_P AS tranP,
        A.TRAN_S AS tranS,
        A.TRAN_1 AS tran1,
        A.TRAN_2 AS tran2,
        A.TRAN_3 AS tran3,
        A.TRAN_4 AS tran4,
        A.TRAN_5 AS tran5,
        A.REGI_ID AS regiId,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID AS chngId,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        A.GROUP_ID AS groupId,
        (SELECT GROUP_NAME FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS groupName,
        (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS progName
    FROM SYS_GPGM A
    WHERE A.SYS_ID = p_sys_id
      AND A.PROG_ID = p_prog_id
      AND A.GROUP_ID = p_group_id
      AND (p_tran_a IS NULL OR p_tran_a = '' OR A.TRAN_A = p_tran_a)
      AND (p_tran_c IS NULL OR p_tran_c = '' OR A.TRAN_C = p_tran_c)
      AND (p_tran_r IS NULL OR p_tran_r = '' OR A.TRAN_R = p_tran_r)
      AND (p_tran_u IS NULL OR p_tran_u = '' OR A.TRAN_U = p_tran_u)
      AND (p_tran_d IS NULL OR p_tran_d = '' OR A.TRAN_D = p_tran_d)
      AND (p_tran_p IS NULL OR p_tran_p = '' OR A.TRAN_P = p_tran_p)
      AND (p_tran_s IS NULL OR p_tran_s = '' OR A.TRAN_S = p_tran_s)
      AND (p_tran_1 IS NULL OR p_tran_1 = '' OR A.TRAN_1 = p_tran_1)
      AND (p_tran_2 IS NULL OR p_tran_2 = '' OR A.TRAN_2 = p_tran_2)
      AND (p_tran_3 IS NULL OR p_tran_3 = '' OR A.TRAN_3 = p_tran_3)
      AND (p_tran_4 IS NULL OR p_tran_4 = '' OR A.TRAN_4 = p_tran_4)
      AND (p_tran_5 IS NULL OR p_tran_5 = '' OR A.TRAN_5 = p_tran_5);
END//

-- ============================================================
-- 10. 그룹-프로그램 등록 - insertGroupProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_insert_group_program//

CREATE PROCEDURE sp_program2_insert_group_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_group_id VARCHAR(50),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_GPGM (
        GROUP_ID,
        SYS_ID,
        PROG_ID,
        TRAN_A,
        TRAN_C,
        TRAN_R,
        TRAN_U,
        TRAN_D,
        TRAN_P,
        TRAN_S,
        TRAN_1,
        TRAN_2,
        TRAN_3,
        TRAN_4,
        TRAN_5,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_group_id,
        p_sys_id,
        p_prog_id,
        IFNULL(p_tran_a, '0'),
        IFNULL(p_tran_c, '0'),
        IFNULL(p_tran_r, '0'),
        IFNULL(p_tran_u, '0'),
        IFNULL(p_tran_d, '0'),
        IFNULL(p_tran_p, '0'),
        IFNULL(p_tran_s, '0'),
        IFNULL(p_tran_1, '0'),
        IFNULL(p_tran_2, '0'),
        IFNULL(p_tran_3, '0'),
        IFNULL(p_tran_4, '0'),
        IFNULL(p_tran_5, '0'),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 11. 그룹-프로그램 수정 - updateGroupProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_update_group_program//

CREATE PROCEDURE sp_program2_update_group_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_group_id VARCHAR(50),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_GPGM
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        TRAN_A = CASE WHEN p_tran_a IS NOT NULL AND p_tran_a != '' THEN p_tran_a ELSE TRAN_A END,
        TRAN_C = CASE WHEN p_tran_c IS NOT NULL AND p_tran_c != '' THEN p_tran_c ELSE TRAN_C END,
        TRAN_R = CASE WHEN p_tran_r IS NOT NULL AND p_tran_r != '' THEN p_tran_r ELSE TRAN_R END,
        TRAN_U = CASE WHEN p_tran_u IS NOT NULL AND p_tran_u != '' THEN p_tran_u ELSE TRAN_U END,
        TRAN_D = CASE WHEN p_tran_d IS NOT NULL AND p_tran_d != '' THEN p_tran_d ELSE TRAN_D END,
        TRAN_P = CASE WHEN p_tran_p IS NOT NULL AND p_tran_p != '' THEN p_tran_p ELSE TRAN_P END,
        TRAN_S = CASE WHEN p_tran_s IS NOT NULL AND p_tran_s != '' THEN p_tran_s ELSE TRAN_S END,
        TRAN_1 = CASE WHEN p_tran_1 IS NOT NULL AND p_tran_1 != '' THEN p_tran_1 ELSE TRAN_1 END,
        TRAN_2 = CASE WHEN p_tran_2 IS NOT NULL AND p_tran_2 != '' THEN p_tran_2 ELSE TRAN_2 END,
        TRAN_3 = CASE WHEN p_tran_3 IS NOT NULL AND p_tran_3 != '' THEN p_tran_3 ELSE TRAN_3 END,
        TRAN_4 = CASE WHEN p_tran_4 IS NOT NULL AND p_tran_4 != '' THEN p_tran_4 ELSE TRAN_4 END,
        TRAN_5 = CASE WHEN p_tran_5 IS NOT NULL AND p_tran_5 != '' THEN p_tran_5 ELSE TRAN_5 END
    WHERE SYS_ID = p_sys_id
      AND PROG_ID = p_prog_id
      AND GROUP_ID = p_group_id;
END//

-- ============================================================
-- 12. 그룹-프로그램 삭제 - deleteGroupProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_delete_group_program//

CREATE PROCEDURE sp_program2_delete_group_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_group_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_GPGM
    WHERE SYS_ID = p_sys_id
      AND PROG_ID = p_prog_id
      AND GROUP_ID = p_group_id;
END//

-- ============================================================
-- 13. 사용자-프로그램 목록 조회 (페이징) - searchUserProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_search_user_program//

CREATE PROCEDURE sp_program2_search_user_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_user_id VARCHAR(50),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;
    SET @sort_clause = IF(p_sort_str IS NULL OR p_sort_str = '', 'A.REGI_DATE DESC, A.CHNG_DATE DESC', p_sort_str);

    SET @sql = CONCAT('
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
                FROM (
                    SELECT
                        A.SYS_ID AS sysId,
                        A.PROG_ID AS progId,
                        A.TRAN_A AS tranA,
                        A.TRAN_C AS tranC,
                        A.TRAN_R AS tranR,
                        A.TRAN_U AS tranU,
                        A.TRAN_D AS tranD,
                        A.TRAN_P AS tranP,
                        A.TRAN_S AS tranS,
                        A.TRAN_1 AS tran1,
                        A.TRAN_2 AS tran2,
                        A.TRAN_3 AS tran3,
                        A.TRAN_4 AS tran4,
                        A.TRAN_5 AS tran5,
                        A.REGI_ID AS regiId,
                        DATE_FORMAT(A.REGI_DATE, ''%Y-%m-%d %H:%i:%s'') AS regiDate,
                        A.CHNG_ID AS chngId,
                        DATE_FORMAT(A.CHNG_DATE, ''%Y-%m-%d %H:%i:%s'') AS chngDate,
                        A.USER_ID AS userId,
                        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS userName,
                        (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS progName
                    FROM SYS_UPGM A
                    WHERE A.SYS_ID = ''', p_sys_id, '''
                      AND (''', IFNULL(p_prog_id, ''), ''' = '''' OR A.PROG_ID = ''', IFNULL(p_prog_id, ''), ''')
                      AND (''', IFNULL(p_user_id, ''), ''' = '''' OR A.USER_ID = ''', IFNULL(p_user_id, ''), ''')
                    ORDER BY ', @sort_clause, '
                ) Z1, (SELECT @rownum := 0) Z2
            ) X
            WHERE (CASE WHEN ', IFNULL(p_end, 'NULL'), ' IS NOT NULL THEN RNUM < ', IFNULL(p_end, 0), ' ELSE 1=1 END)
        ) X
        WHERE (CASE WHEN ', IFNULL(p_start, 'NULL'), ' IS NOT NULL THEN RNUM >= ', IFNULL(p_start, 0), ' ELSE 1=1 END)
    ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 14. 사용자-프로그램 목록 카운트 - searchUserProgramCount
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_search_user_program_count//

CREATE PROCEDURE sp_program2_search_user_program_count(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_UPGM A
    WHERE A.SYS_ID = p_sys_id
      AND (p_prog_id IS NULL OR p_prog_id = '' OR A.PROG_ID = p_prog_id)
      AND (p_user_id IS NULL OR p_user_id = '' OR A.USER_ID = p_user_id);
END//

-- ============================================================
-- 15. 사용자-프로그램 단건 조회 - selectUserProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_select_user_program//

CREATE PROCEDURE sp_program2_select_user_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_user_id VARCHAR(50),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1)
)
BEGIN
    SELECT
        A.SYS_ID AS sysId,
        A.PROG_ID AS progId,
        A.TRAN_A AS tranA,
        A.TRAN_C AS tranC,
        A.TRAN_R AS tranR,
        A.TRAN_U AS tranU,
        A.TRAN_D AS tranD,
        A.TRAN_P AS tranP,
        A.TRAN_S AS tranS,
        A.TRAN_1 AS tran1,
        A.TRAN_2 AS tran2,
        A.TRAN_3 AS tran3,
        A.TRAN_4 AS tran4,
        A.TRAN_5 AS tran5,
        A.REGI_ID AS regiId,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID AS chngId,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        A.USER_ID AS userId,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS userName,
        (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS progName
    FROM SYS_UPGM A
    WHERE A.SYS_ID = p_sys_id
      AND A.PROG_ID = p_prog_id
      AND A.USER_ID = p_user_id
      AND (p_tran_a IS NULL OR p_tran_a = '' OR A.TRAN_A = p_tran_a)
      AND (p_tran_c IS NULL OR p_tran_c = '' OR A.TRAN_C = p_tran_c)
      AND (p_tran_r IS NULL OR p_tran_r = '' OR A.TRAN_R = p_tran_r)
      AND (p_tran_u IS NULL OR p_tran_u = '' OR A.TRAN_U = p_tran_u)
      AND (p_tran_d IS NULL OR p_tran_d = '' OR A.TRAN_D = p_tran_d)
      AND (p_tran_p IS NULL OR p_tran_p = '' OR A.TRAN_P = p_tran_p)
      AND (p_tran_s IS NULL OR p_tran_s = '' OR A.TRAN_S = p_tran_s)
      AND (p_tran_1 IS NULL OR p_tran_1 = '' OR A.TRAN_1 = p_tran_1)
      AND (p_tran_2 IS NULL OR p_tran_2 = '' OR A.TRAN_2 = p_tran_2)
      AND (p_tran_3 IS NULL OR p_tran_3 = '' OR A.TRAN_3 = p_tran_3)
      AND (p_tran_4 IS NULL OR p_tran_4 = '' OR A.TRAN_4 = p_tran_4)
      AND (p_tran_5 IS NULL OR p_tran_5 = '' OR A.TRAN_5 = p_tran_5);
END//

-- ============================================================
-- 16. 사용자-프로그램 등록 - insertUserProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_insert_user_program//

CREATE PROCEDURE sp_program2_insert_user_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_user_id VARCHAR(50),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_UPGM (
        USER_ID,
        SYS_ID,
        PROG_ID,
        TRAN_A,
        TRAN_C,
        TRAN_R,
        TRAN_U,
        TRAN_D,
        TRAN_P,
        TRAN_S,
        TRAN_1,
        TRAN_2,
        TRAN_3,
        TRAN_4,
        TRAN_5,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_user_id,
        p_sys_id,
        p_prog_id,
        IFNULL(p_tran_a, '0'),
        IFNULL(p_tran_c, '0'),
        IFNULL(p_tran_r, '0'),
        IFNULL(p_tran_u, '0'),
        IFNULL(p_tran_d, '0'),
        IFNULL(p_tran_p, '0'),
        IFNULL(p_tran_s, '0'),
        IFNULL(p_tran_1, '0'),
        IFNULL(p_tran_2, '0'),
        IFNULL(p_tran_3, '0'),
        IFNULL(p_tran_4, '0'),
        IFNULL(p_tran_5, '0'),
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 17. 사용자-프로그램 수정 - updateUserProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_update_user_program//

CREATE PROCEDURE sp_program2_update_user_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_user_id VARCHAR(50),
    IN p_tran_a VARCHAR(1),
    IN p_tran_c VARCHAR(1),
    IN p_tran_r VARCHAR(1),
    IN p_tran_u VARCHAR(1),
    IN p_tran_d VARCHAR(1),
    IN p_tran_p VARCHAR(1),
    IN p_tran_s VARCHAR(1),
    IN p_tran_1 VARCHAR(1),
    IN p_tran_2 VARCHAR(1),
    IN p_tran_3 VARCHAR(1),
    IN p_tran_4 VARCHAR(1),
    IN p_tran_5 VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_UPGM
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        TRAN_A = CASE WHEN p_tran_a IS NOT NULL AND p_tran_a != '' THEN p_tran_a ELSE TRAN_A END,
        TRAN_C = CASE WHEN p_tran_c IS NOT NULL AND p_tran_c != '' THEN p_tran_c ELSE TRAN_C END,
        TRAN_R = CASE WHEN p_tran_r IS NOT NULL AND p_tran_r != '' THEN p_tran_r ELSE TRAN_R END,
        TRAN_U = CASE WHEN p_tran_u IS NOT NULL AND p_tran_u != '' THEN p_tran_u ELSE TRAN_U END,
        TRAN_D = CASE WHEN p_tran_d IS NOT NULL AND p_tran_d != '' THEN p_tran_d ELSE TRAN_D END,
        TRAN_P = CASE WHEN p_tran_p IS NOT NULL AND p_tran_p != '' THEN p_tran_p ELSE TRAN_P END,
        TRAN_S = CASE WHEN p_tran_s IS NOT NULL AND p_tran_s != '' THEN p_tran_s ELSE TRAN_S END,
        TRAN_1 = CASE WHEN p_tran_1 IS NOT NULL AND p_tran_1 != '' THEN p_tran_1 ELSE TRAN_1 END,
        TRAN_2 = CASE WHEN p_tran_2 IS NOT NULL AND p_tran_2 != '' THEN p_tran_2 ELSE TRAN_2 END,
        TRAN_3 = CASE WHEN p_tran_3 IS NOT NULL AND p_tran_3 != '' THEN p_tran_3 ELSE TRAN_3 END,
        TRAN_4 = CASE WHEN p_tran_4 IS NOT NULL AND p_tran_4 != '' THEN p_tran_4 ELSE TRAN_4 END,
        TRAN_5 = CASE WHEN p_tran_5 IS NOT NULL AND p_tran_5 != '' THEN p_tran_5 ELSE TRAN_5 END
    WHERE SYS_ID = p_sys_id
      AND PROG_ID = p_prog_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 18. 사용자-프로그램 삭제 - deleteUserProgram
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_delete_user_program//

CREATE PROCEDURE sp_program2_delete_user_program(
    IN p_sys_id VARCHAR(20),
    IN p_prog_id VARCHAR(100),
    IN p_user_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_UPGM
    WHERE SYS_ID = p_sys_id
      AND PROG_ID = p_prog_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 19. 보안 정보 조회 (selectSecurity) - V_SYS_AUTH 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_program2_select_security//

CREATE PROCEDURE sp_program2_select_security(
    IN p_sys_id VARCHAR(20),
    IN p_uri VARCHAR(200),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT A.SYS_ID AS sysId,
           A.PROG_ID AS progId,
           A.TRAN_A AS tranA,
           A.TRAN_C AS tranC,
           A.TRAN_R AS tranR,
           A.TRAN_U AS tranU,
           A.TRAN_D AS tranD,
           A.TRAN_P AS tranP,
           A.TRAN_S AS tranS,
           A.TRAN_1 AS tran1,
           A.TRAN_2 AS tran2,
           A.TRAN_3 AS tran3,
           A.TRAN_4 AS tran4,
           A.TRAN_5 AS tran5,
           (SELECT PROG_NAME FROM SYS_PROG WHERE SYS_ID = A.SYS_ID AND PROG_ID = A.PROG_ID) AS progName,
           (SELECT MENU_KEY FROM SYS_MENU WHERE SYS_ID = A.SYS_ID AND MENU_URL = A.PROG_ID LIMIT 0, 1) AS menuKey
    FROM (
        SELECT x.sys_id, x.user_id,
               CASE x.auth_type
                    WHEN '10.USER' THEN 'USER'
                    WHEN '20.GROUP' THEN 'GROUP'
                    ELSE 'DEFAULT' END auth_type,
               x.prog_id, x.tran_a, x.tran_c, x.tran_r, x.tran_u, x.tran_d,
               x.tran_p, x.tran_s, x.tran_1, x.tran_2, x.tran_3, x.tran_4,
               x.tran_5
        FROM (
            SELECT a.*
            FROM (
                SELECT (CASE @vjob WHEN a.prog_id THEN @rownum:=@rownum+1 ELSE @rownum:=1 END) auth_seq,
                       (@vjob:=a.prog_id) vjob,
                       a.*
                FROM (
                    -- USER level auth
                    SELECT a.sys_id AS sys_id,
                           a.user_id AS user_id,
                           '10.USER' AS auth_type,
                           a.prog_id AS prog_id,
                           a.tran_a AS tran_a,
                           a.tran_c AS tran_c,
                           a.tran_r AS tran_r,
                           a.tran_u AS tran_u,
                           a.tran_d AS tran_d,
                           a.tran_p AS tran_p,
                           a.tran_s AS tran_s,
                           a.tran_1 AS tran_1,
                           a.tran_2 AS tran_2,
                           a.tran_3 AS tran_3,
                           a.tran_4 AS tran_4,
                           a.tran_5 AS tran_5
                    FROM sys_upgm a
                    WHERE a.sys_id = p_sys_id
                      AND a.user_id = p_user_id
                    UNION
                    -- GROUP level auth
                    SELECT a.sys_id AS sys_id,
                           b.user_id AS user_id,
                           '20.GROUP' AS auth_type,
                           a.prog_id AS prog_id,
                           MAX(a.tran_a) AS tran_a,
                           MAX(a.tran_c) AS tran_c,
                           MAX(a.tran_r) AS tran_r,
                           MAX(a.tran_u) AS tran_u,
                           MAX(a.tran_d) AS tran_d,
                           MAX(a.tran_p) AS tran_p,
                           MAX(a.tran_s) AS tran_s,
                           MAX(a.tran_1) AS tran_1,
                           MAX(a.tran_2) AS tran_2,
                           MAX(a.tran_3) AS tran_3,
                           MAX(a.tran_4) AS tran_4,
                           MAX(a.tran_5) AS tran_5
                    FROM sys_gpgm a
                    JOIN sys_ugrp b ON a.sys_id = b.sys_id AND a.group_id = b.group_id
                    WHERE b.sys_id = p_sys_id
                      AND b.user_id = p_user_id
                    GROUP BY a.sys_id, b.user_id, a.prog_id
                    UNION
                    -- DEFAULT level auth
                    SELECT a.sys_id AS sys_id,
                           b.user_id AS user_id,
                           '30.DEFAULT' AS auth_type,
                           a.prog_id AS prog_id,
                           '0' AS tran_a,
                           '0' AS tran_c,
                           '0' AS tran_r,
                           '0' AS tran_u,
                           '0' AS tran_d,
                           '0' AS tran_p,
                           '0' AS tran_s,
                           '0' AS tran_1,
                           '0' AS tran_2,
                           '0' AS tran_3,
                           '0' AS tran_4,
                           '0' AS tran_5
                    FROM sys_prog a
                    JOIN sys_user b ON a.sys_id = b.sys_id
                    WHERE b.sys_id = p_sys_id
                      AND b.user_id = p_user_id
                ) a, (SELECT @vjob:='', @rownum:=0 FROM DUAL) b
                ORDER BY a.sys_id, a.user_id, a.prog_id, a.auth_type
            ) a
            WHERE a.auth_seq = 1
        ) x
    ) A
    WHERE A.SYS_ID = p_sys_id
      AND A.PROG_ID = p_uri
      AND A.USER_ID = p_user_id
      AND A.USER_ID = '2';
END//

DELIMITER ;
