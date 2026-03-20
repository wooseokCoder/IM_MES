-- ============================================================
-- Group2.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- 네임스페이스: com.wsc.common.user2.Group2
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 그룹 관리 (SYS_GRUP)
-- ============================================================

-- 1.1 그룹 목록 조회 (페이징 + 동적 정렬)
-- AS-IS: search
DROP PROCEDURE IF EXISTS sp_group2_search//
CREATE PROCEDURE sp_group2_search(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
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
                        GROUP_NAME AS groupName
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

-- 1.2 그룹 목록 카운트
-- AS-IS: searchCount
DROP PROCEDURE IF EXISTS sp_group2_search_count//
CREATE PROCEDURE sp_group2_search_count(
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

-- 1.3 그룹 단건 조회
-- AS-IS: select
DROP PROCEDURE IF EXISTS sp_group2_select//
CREATE PROCEDURE sp_group2_select(
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
        GROUP_NAME AS groupName
    FROM SYS_GRUP A
    WHERE SYS_ID = p_sys_id
      AND GROUP_ID = p_group_id;
END//

-- 1.4 그룹 등록
-- AS-IS: insert
DROP PROCEDURE IF EXISTS sp_group2_insert//
CREATE PROCEDURE sp_group2_insert(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_GRUP (
        SYS_ID, GROUP_ID, GROUP_NAME,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, p_group_id, p_group_name,
        p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- 1.5 그룹 수정
-- AS-IS: update
DROP PROCEDURE IF EXISTS sp_group2_update//
CREATE PROCEDURE sp_group2_update(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_GRUP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        GROUP_NAME = p_group_name
    WHERE SYS_ID = p_sys_id
      AND GROUP_ID = p_group_id;
END//

-- 1.6 그룹 삭제
-- AS-IS: delete
DROP PROCEDURE IF EXISTS sp_group2_delete//
CREATE PROCEDURE sp_group2_delete(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_GRUP
    WHERE SYS_ID = p_sys_id
      AND GROUP_ID = p_group_id;
END//

-- ============================================================
-- 2. 사용자-그룹 관리 (SYS_UGRP)
-- ============================================================

-- 2.1 사용자-그룹 목록 조회 (페이징 + 동적 정렬)
-- AS-IS: searchUserGroup
DROP PROCEDURE IF EXISTS sp_group2_search_user_group//
CREATE PROCEDURE sp_group2_search_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
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
                        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS userName
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

-- 2.2 사용자-그룹 목록 카운트
-- AS-IS: searchUserGroupCount
DROP PROCEDURE IF EXISTS sp_group2_search_user_group_count//
CREATE PROCEDURE sp_group2_search_user_group_count(
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

-- 2.3 사용자-그룹 단건 조회
-- AS-IS: selectUserGroup
DROP PROCEDURE IF EXISTS sp_group2_select_user_group//
CREATE PROCEDURE sp_group2_select_user_group(
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
        (SELECT USER_NAME FROM SYS_USER WHERE SYS_ID = A.SYS_ID AND USER_ID = A.USER_ID) AS userName
    FROM SYS_UGRP A
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND GROUP_ID = p_group_id;
END//

-- 2.4 사용자-그룹 등록
-- AS-IS: insertUserGroup
DROP PROCEDURE IF EXISTS sp_group2_insert_user_group//
CREATE PROCEDURE sp_group2_insert_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_user_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_UGRP (
        SYS_ID, GROUP_ID, USER_ID,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, p_group_id, p_user_id,
        p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- 2.5 사용자-그룹 수정
-- AS-IS: updateUserGroup
DROP PROCEDURE IF EXISTS sp_group2_update_user_group//
CREATE PROCEDURE sp_group2_update_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_UGRP
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND GROUP_ID = p_group_id;
END//

-- 2.6 사용자-그룹 삭제
-- AS-IS: deleteUserGroup
DROP PROCEDURE IF EXISTS sp_group2_delete_user_group//
CREATE PROCEDURE sp_group2_delete_user_group(
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

DELIMITER ;
