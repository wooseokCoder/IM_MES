-- ============================================================
-- Group.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- 수정일: 2026-01-15 (동적 정렬 지원 추가)
-- ============================================================

DELIMITER //

-- 1. 그룹 목록 조회 (페이징 + 동적 정렬)
DROP PROCEDURE IF EXISTS sp_group_search//
CREATE PROCEDURE sp_group_search(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_start INT,
    IN p_end INT,
    IN p_sort_str TEXT
)
BEGIN
    -- 정렬 조건 설정 (gsSorts -> p_sort_str)
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT
                        A.SYS_ID AS sysId,
                        A.GROUP_ID AS groupId,
                        A.REGI_ID AS regiId,
                        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
                        A.CHNG_ID AS chngId,
                        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
                        GROUP_NAME AS groupName,
                        IFNULL(BLUE_AUTH_YN, 'N') AS useFlag
                    FROM SYS_GRUP A
                    WHERE SYS_ID = '", p_sys_id, "'
                      AND (CASE WHEN '", IFNULL(p_group_id, ''), "' != '' THEN GROUP_ID LIKE CONCAT('%', '", IFNULL(p_group_id, ''), "', '%') ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_group_name, ''), "' != '' THEN GROUP_NAME LIKE CONCAT('%', '", IFNULL(p_group_name, ''), "', '%') ELSE 1=1 END)
                    ORDER BY ", @sort_order, "
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
        ) X
        WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)
    ");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- 2. 그룹 목록 카운트
DROP PROCEDURE IF EXISTS sp_group_search_count//
CREATE PROCEDURE sp_group_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_GRUP A
    WHERE SYS_ID = p_sys_id
      AND (p_group_id IS NULL OR p_group_id = '' OR GROUP_ID LIKE CONCAT('%', p_group_id, '%'))
      AND (p_group_name IS NULL OR p_group_name = '' OR GROUP_NAME LIKE CONCAT('%', p_group_name, '%'));
END//

-- 3. 그룹 단건 조회
DROP PROCEDURE IF EXISTS sp_group_select//
CREATE PROCEDURE sp_group_select(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50)
)
BEGIN
    SELECT
        A.SYS_ID AS sysId,
        A.GROUP_ID AS groupId,
        A.REGI_ID AS regiId,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID AS chngId,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        GROUP_NAME AS groupName,
        IFNULL(BLUE_AUTH_YN, 'N') AS useFlag
    FROM SYS_GRUP A
    WHERE SYS_ID = p_sys_id
      AND GROUP_ID = p_group_id;
END//

-- 4. 그룹 등록
DROP PROCEDURE IF EXISTS sp_group_insert//
CREATE PROCEDURE sp_group_insert(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_GRUP (
        SYS_ID, GROUP_ID, GROUP_NAME, BLUE_AUTH_YN,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, p_group_id, p_group_name, p_use_flag,
        p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- 5. 그룹 수정
DROP PROCEDURE IF EXISTS sp_group_update//
CREATE PROCEDURE sp_group_update(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_GRUP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        GROUP_NAME = p_group_name,
        BLUE_AUTH_YN = p_use_flag
    WHERE SYS_ID = p_sys_id
      AND GROUP_ID = p_group_id;
END//

-- 6. 그룹 삭제
DROP PROCEDURE IF EXISTS sp_group_delete//
CREATE PROCEDURE sp_group_delete(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_GRUP
    WHERE SYS_ID = p_sys_id
      AND GROUP_ID = p_group_id;
END//

-- 7. 사용자-그룹 목록 조회 (페이징 + 동적 정렬)
DROP PROCEDURE IF EXISTS sp_usergroup_search//
CREATE PROCEDURE sp_usergroup_search(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50),
    IN p_start INT,
    IN p_end INT,
    IN p_sort_str TEXT
)
BEGIN
    -- 정렬 조건 설정 (gsSorts -> p_sort_str)
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT
                        A.SYS_ID AS sysId,
                        A.GROUP_ID AS groupId,
                        A.REGI_ID AS regiId,
                        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
                        A.CHNG_ID AS chngId,
                        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
                        A.USER_ID AS userId,
                        (SELECT GROUP_NAME FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS groupName,
                        (SELECT BLUE_AUTH_YN FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS useFlag,
                        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS userName,
                        A.GROUP_ID AS groupId2
                    FROM SYS_UGRP A
                    WHERE SYS_ID = '", p_sys_id, "'
                      AND (CASE WHEN '", IFNULL(p_user_id, ''), "' != '' THEN USER_ID = '", IFNULL(p_user_id, ''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_group_id, ''), "' != '' THEN GROUP_ID = '", IFNULL(p_group_id, ''), "' ELSE 1=1 END)
                    ORDER BY ", @sort_order, "
                ) Z1, (SELECT @rownum:=0) Z2
            ) X
            WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
        ) X
        WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)
    ");

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- 8. 사용자-그룹 목록 카운트
DROP PROCEDURE IF EXISTS sp_usergroup_search_count//
CREATE PROCEDURE sp_usergroup_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_UGRP A
    WHERE SYS_ID = p_sys_id
      AND (p_user_id IS NULL OR p_user_id = '' OR USER_ID = p_user_id)
      AND (p_group_id IS NULL OR p_group_id = '' OR GROUP_ID = p_group_id);
END//

-- 9. 사용자-그룹 단건 조회
DROP PROCEDURE IF EXISTS sp_usergroup_select//
CREATE PROCEDURE sp_usergroup_select(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50)
)
BEGIN
    SELECT
        A.SYS_ID AS sysId,
        A.GROUP_ID AS groupId,
        A.REGI_ID AS regiId,
        DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        A.CHNG_ID AS chngId,
        DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        A.USER_ID AS userId,
        (SELECT GROUP_NAME FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS groupName,
        (SELECT BLUE_AUTH_YN FROM SYS_GRUP WHERE SYS_ID = A.SYS_ID AND GROUP_ID = A.GROUP_ID) AS useFlag,
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS userName,
        A.GROUP_ID AS groupId2
    FROM SYS_UGRP A
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND GROUP_ID = p_group_id;
END//

-- 10. 사용자-그룹 등록
DROP PROCEDURE IF EXISTS sp_usergroup_insert//
CREATE PROCEDURE sp_usergroup_insert(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_user_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_UGRP (
        SYS_ID, GROUP_ID, USER_ID, REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, p_group_id, p_user_id, p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- 11. 사용자-그룹 수정
DROP PROCEDURE IF EXISTS sp_usergroup_update//
CREATE PROCEDURE sp_usergroup_update(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50),
    IN p_group_id2 VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_UGRP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        GROUP_ID = p_group_id
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND GROUP_ID = p_group_id2;
END//

-- 12. 사용자-그룹 삭제
DROP PROCEDURE IF EXISTS sp_usergroup_delete//
CREATE PROCEDURE sp_usergroup_delete(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_UGRP
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND GROUP_ID = p_group_id;
END//

-- 13. 사용자 목록 조회
DROP PROCEDURE IF EXISTS sp_group_select_user_list//
CREATE PROCEDURE sp_group_select_user_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT SYS_ID, USER_ID, USER_NAME
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USE_FLAG = 'Y';
END//

-- 14. 그룹 목록 조회 (콤보용)
DROP PROCEDURE IF EXISTS sp_group_select_list//
CREATE PROCEDURE sp_group_select_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT GROUP_ID, GROUP_NAME
    FROM SYS_GRUP
    WHERE SYS_ID = p_sys_id;
END//

DELIMITER ;
