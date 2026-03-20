-- ============================================================
-- Group3 Stored Procedures
-- Source: com.wsc.common.user3.Group3.xml
-- Created: 2026-01-15
-- Description: Stored procedures for Group3 management
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. Group Management (SYS_GRUP)
-- ============================================================

-- ------------------------------------------------------------
-- [sp_group3_search] Group list search with pagination and dynamic sorting
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_search //
CREATE PROCEDURE sp_group3_search(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_sort_str VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- Set SQL for dynamic sorting
    SET @sql = CONCAT('
        SELECT *
          FROM (
                SELECT X.*
                  FROM (
                        SELECT Z1.*, @rownum := @rownum+1 as RNUM
                          FROM (
                                SELECT A.SYS_ID         AS sysId
                                      ,A.GROUP_ID       AS groupId
                                      ,A.REGI_ID        AS regiId
                                      ,DATE_FORMAT(A.REGI_DATE ,''%Y-%m-%d %H:%i:%s'') AS regiDate
                                      ,A.CHNG_ID        AS chngId
                                      ,DATE_FORMAT(A.CHNG_DATE ,''%Y-%m-%d %H:%i:%s'') AS chngDate
                                      ,GROUP_NAME       AS groupName
                                      ,0 AS RNUM
                                  FROM SYS_GRUP A
                                 WHERE SYS_ID = ''', p_sys_id, '''');

    -- Dynamic WHERE conditions
    IF p_group_id IS NOT NULL AND p_group_id != '' THEN
        SET @sql = CONCAT(@sql, ' AND GROUP_ID LIKE ''%', p_group_id, '%''');
    END IF;

    IF p_group_name IS NOT NULL AND p_group_name != '' THEN
        SET @sql = CONCAT(@sql, ' AND GROUP_NAME LIKE ''%', p_group_name, '%''');
    END IF;

    -- Dynamic ORDER BY
    SET @sql = CONCAT(@sql, ' ORDER BY ');
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @sql = CONCAT(@sql, p_sort_str);
    ELSE
        SET @sql = CONCAT(@sql, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    -- Pagination handling
    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SET @sql = CONCAT(@sql, '
                               ) Z1, (SELECT @rownum:=0 ) Z2
                       ) X
                 WHERE RNUM < ', p_end, '
               ) X
         WHERE RNUM >= ', p_start);
    ELSE
        SET @sql = CONCAT(@sql, '
                               ) Z1, (SELECT @rownum:=0 ) Z2
                       ) X
               ) X');
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ------------------------------------------------------------
-- [sp_group3_search_count] Group count
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_search_count //
CREATE PROCEDURE sp_group3_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100)
)
BEGIN
    SET @sql = CONCAT('
        SELECT COUNT(1) AS cnt
          FROM SYS_GRUP A
         WHERE SYS_ID = ''', p_sys_id, '''');

    -- Dynamic WHERE conditions
    IF p_group_id IS NOT NULL AND p_group_id != '' THEN
        SET @sql = CONCAT(@sql, ' AND GROUP_ID LIKE ''%', p_group_id, '%''');
    END IF;

    IF p_group_name IS NOT NULL AND p_group_name != '' THEN
        SET @sql = CONCAT(@sql, ' AND GROUP_NAME LIKE ''%', p_group_name, '%''');
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ------------------------------------------------------------
-- [sp_group3_select] Group single record select
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_select //
CREATE PROCEDURE sp_group3_select(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50)
)
BEGIN
    SELECT A.SYS_ID         AS sysId
          ,A.GROUP_ID       AS groupId
          ,A.REGI_ID        AS regiId
          ,DATE_FORMAT(A.REGI_DATE ,'%Y-%m-%d %H:%i:%s') AS regiDate
          ,A.CHNG_ID        AS chngId
          ,DATE_FORMAT(A.CHNG_DATE ,'%Y-%m-%d %H:%i:%s') AS chngDate
          ,GROUP_NAME       AS groupName
      FROM SYS_GRUP A
     WHERE SYS_ID   = p_sys_id
       AND GROUP_ID = p_group_id;
END //

-- ------------------------------------------------------------
-- [sp_group3_insert] Group insert
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_insert //
CREATE PROCEDURE sp_group3_insert(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_GRUP
         ( SYS_ID
         , GROUP_ID
         , GROUP_NAME
         , REGI_ID
         , REGI_DATE
         , CHNG_ID
         , CHNG_DATE
         )
    VALUES
         ( p_sys_id
         , p_group_id
         , p_group_name
         , p_gs_user_id
         , NOW()
         , p_gs_user_id
         , NOW()
         );
END //

-- ------------------------------------------------------------
-- [sp_group3_update] Group update
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_update //
CREATE PROCEDURE sp_group3_update(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_group_name VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_GRUP
       SET CHNG_ID    = p_gs_user_id
         , CHNG_DATE  = NOW()
         , GROUP_NAME = p_group_name
     WHERE SYS_ID     = p_sys_id
       AND GROUP_ID   = p_group_id;
END //

-- ------------------------------------------------------------
-- [sp_group3_delete] Group delete
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_delete //
CREATE PROCEDURE sp_group3_delete(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_GRUP
     WHERE SYS_ID   = p_sys_id
       AND GROUP_ID = p_group_id;
END //

-- ============================================================
-- 2. User Group Management (SYS_UGRP)
-- ============================================================

-- ------------------------------------------------------------
-- [sp_group3_search_user_group] User group list search with pagination
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_search_user_group //
CREATE PROCEDURE sp_group3_search_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50),
    IN p_sort_str VARCHAR(500),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @sql = CONCAT('
        SELECT *
          FROM (
                SELECT X.*
                  FROM (
                        SELECT Z1.*, @rownum := @rownum+1 as RNUM
                          FROM (
                                SELECT A.SYS_ID         AS sysId
                                      ,A.GROUP_ID       AS groupId
                                      ,A.REGI_ID        AS regiId
                                      ,DATE_FORMAT(A.REGI_DATE ,''%Y-%m-%d %H:%i:%s'') AS regiDate
                                      ,A.CHNG_ID        AS chngId
                                      ,DATE_FORMAT(A.CHNG_DATE ,''%Y-%m-%d %H:%i:%s'') AS chngDate
                                      ,A.USER_ID        AS userId
                                      ,(SELECT GROUP_NAME
                                          FROM SYS_GRUP
                                         WHERE SYS_ID   = A.SYS_ID
                                           AND GROUP_ID = A.GROUP_ID
                                       ) AS groupName
                                      ,(SELECT USER_NAME
                                          FROM SYS_USER
                                         WHERE SYS_ID   = A.SYS_ID
                                           AND USER_ID  = A.USER_ID
                                       ) AS userName
                                      ,A.GROUP_ID AS groupId2
                                      ,0 AS RNUM
                                  FROM SYS_UGRP A
                                 WHERE SYS_ID = ''', p_sys_id, '''');

    -- Dynamic WHERE conditions using CASE WHEN pattern
    IF p_user_id IS NOT NULL AND p_user_id != '' THEN
        SET @sql = CONCAT(@sql, ' AND USER_ID = (CASE WHEN ''', p_user_id, ''' = '''' THEN USER_ID ELSE ''', p_user_id, ''' END)');
    END IF;

    IF p_group_id IS NOT NULL AND p_group_id != '' THEN
        SET @sql = CONCAT(@sql, ' AND GROUP_ID = ''', p_group_id, '''');
    END IF;

    -- Dynamic ORDER BY
    SET @sql = CONCAT(@sql, ' ORDER BY ');
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @sql = CONCAT(@sql, p_sort_str);
    ELSE
        SET @sql = CONCAT(@sql, 'A.REGI_DATE DESC, A.CHNG_DATE DESC');
    END IF;

    -- Pagination handling
    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SET @sql = CONCAT(@sql, '
                               ) Z1, (SELECT @rownum:=0 ) Z2
                       ) X
                 WHERE RNUM < ', p_end, '
               ) X
         WHERE RNUM >= ', p_start);
    ELSE
        SET @sql = CONCAT(@sql, '
                               ) Z1, (SELECT @rownum:=0 ) Z2
                       ) X
               ) X');
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ------------------------------------------------------------
-- [sp_group3_search_user_group_count] User group count
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_search_user_group_count //
CREATE PROCEDURE sp_group3_search_user_group_count(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50)
)
BEGIN
    SET @sql = CONCAT('
        SELECT COUNT(1) AS cnt
          FROM SYS_UGRP A
         WHERE SYS_ID = ''', p_sys_id, '''');

    -- Dynamic WHERE conditions
    IF p_user_id IS NOT NULL AND p_user_id != '' THEN
        SET @sql = CONCAT(@sql, ' AND USER_ID = ''', p_user_id, '''');
    END IF;

    IF p_group_id IS NOT NULL AND p_group_id != '' THEN
        SET @sql = CONCAT(@sql, ' AND GROUP_ID = ''', p_group_id, '''');
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- ------------------------------------------------------------
-- [sp_group3_select_user_group] User group single record select
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_select_user_group //
CREATE PROCEDURE sp_group3_select_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50)
)
BEGIN
    SELECT A.SYS_ID         AS sysId
          ,A.GROUP_ID       AS groupId
          ,A.REGI_ID        AS regiId
          ,DATE_FORMAT(A.REGI_DATE ,'%Y-%m-%d %H:%i:%s') AS regiDate
          ,A.CHNG_ID        AS chngId
          ,DATE_FORMAT(A.CHNG_DATE ,'%Y-%m-%d %H:%i:%s') AS chngDate
          ,A.USER_ID        AS userId
          ,(SELECT GROUP_NAME
              FROM SYS_GRUP
             WHERE SYS_ID   = A.SYS_ID
               AND GROUP_ID = A.GROUP_ID
           ) AS groupName
          ,(SELECT USER_NAME
              FROM SYS_USER
             WHERE SYS_ID   = A.SYS_ID
               AND USER_ID  = A.USER_ID
           ) AS userName
          ,A.GROUP_ID AS groupId2
      FROM SYS_UGRP A
     WHERE SYS_ID   = p_sys_id
       AND USER_ID  = p_user_id
       AND GROUP_ID = p_group_id;
END //

-- ------------------------------------------------------------
-- [sp_group3_insert_user_group] User group insert
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_insert_user_group //
CREATE PROCEDURE sp_group3_insert_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_group_id VARCHAR(50),
    IN p_user_id VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_UGRP
         ( SYS_ID
         , GROUP_ID
         , USER_ID
         , REGI_ID
         , REGI_DATE
         , CHNG_ID
         , CHNG_DATE
         )
    VALUES
         ( p_sys_id
         , p_group_id
         , p_user_id
         , p_gs_user_id
         , NOW()
         , p_gs_user_id
         , NOW()
         );
END //

-- ------------------------------------------------------------
-- [sp_group3_update_user_group] User group update
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_update_user_group //
CREATE PROCEDURE sp_group3_update_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50),
    IN p_group_id2 VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_UGRP
       SET CHNG_ID   = p_gs_user_id
         , CHNG_DATE = NOW()
         , GROUP_ID  = p_group_id
     WHERE SYS_ID    = p_sys_id
       AND USER_ID   = p_user_id
       AND GROUP_ID  = p_group_id2;
END //

-- ------------------------------------------------------------
-- [sp_group3_delete_user_group] User group delete
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_group3_delete_user_group //
CREATE PROCEDURE sp_group3_delete_user_group(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_UGRP
     WHERE SYS_ID    = p_sys_id
       AND USER_ID   = p_user_id
       AND GROUP_ID  = p_group_id;
END //

DELIMITER ;

-- ============================================================
-- END OF FILE
-- ============================================================
