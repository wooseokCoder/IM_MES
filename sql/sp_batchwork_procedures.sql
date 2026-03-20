-- ============================================================================
-- BatchWork Procedures
-- Source: com.wsc.common.user.BatchWork
-- Table: SYS_JOB_MAST
-- Created: 2026-01-15
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_batchwork_search
-- Purpose: Search batch work list with pagination and dynamic sorting
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_batchwork_search//
CREATE PROCEDURE sp_batchwork_search(
    IN p_sys_id VARCHAR(20),
    IN p_job_grup VARCHAR(50),
    IN p_job_term VARCHAR(50),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- Sort order setting (gsSorts -> p_sort_str)
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'JOB_ID, JOB_TYPE DESC');

    SET @rownum := 0;

    -- Build dynamic SQL with RNUM pagination (Board.xml style)
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    JOB_ID AS jobId,
                    JOB_GRUP AS jobGrup,
                    JOB_TYPE AS jobType,
                    JOB_TERM AS jobTerm,
                    JOB_TIME AS jobTime,
                    JOB_CMD AS jobCmd,
                    JOB_DESC AS jobDesc,
                    ERR_PROC AS errProc,
                    JOB_MNG AS jobMng,
                    USE_FLAG AS useFlag,
                    JOB_REMK AS jobRemk,
                    REGI_ID AS regiId,
                    DATE_FORMAT(REGI_DATE,'%Y-%m-%d %H:%i:%s') AS regiDate,
                    CHNG_ID AS chngId,
                    DATE_FORMAT(CHNG_DATE,'%Y-%m-%d %H:%i:%s') AS chngDate
                FROM SYS_JOB_MAST
                WHERE SYS_ID = '", p_sys_id, "'
                  AND (CASE WHEN '", IFNULL(p_job_grup,''), "' != '' THEN JOB_GRUP = '", IFNULL(p_job_grup,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_job_term,''), "' != '' THEN JOB_TERM = '", IFNULL(p_job_term,''), "' ELSE 1=1 END)
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

-- ============================================================================
-- sp_batchwork_search_count
-- Purpose: Count batch work records matching search criteria
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_batchwork_search_count//
CREATE PROCEDURE sp_batchwork_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_job_grup VARCHAR(50),
    IN p_job_term VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id
        AND (p_job_grup IS NULL OR p_job_grup = '' OR JOB_GRUP = p_job_grup)
        AND (p_job_term IS NULL OR p_job_term = '' OR JOB_TERM = p_job_term);
END//

-- ============================================================================
-- sp_batchwork_select
-- Purpose: Select single batch work record by ID
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_batchwork_select//
CREATE PROCEDURE sp_batchwork_select(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50)
)
BEGIN
    SELECT
        JOB_ID AS jobId,
        JOB_GRUP AS jobGrup,
        JOB_TYPE AS jobType,
        JOB_TERM AS jobTerm,
        JOB_TIME AS jobTime,
        JOB_CMD AS jobCmd,
        JOB_DESC AS jobDesc,
        ERR_PROC AS errProc,
        JOB_MNG AS jobMng,
        USE_FLAG AS useFlag,
        JOB_REMK AS jobRemk,
        REGI_ID AS regiId,
        REGI_DATE AS regiDate,
        CHNG_ID AS chngId,
        CHNG_DATE AS chngDate
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id
        AND JOB_ID = p_job_id;
END//

-- ============================================================================
-- sp_batchwork_get_next_job_id
-- Purpose: Generate next JOB_ID for insert
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_batchwork_get_next_job_id//
CREATE PROCEDURE sp_batchwork_get_next_job_id(
    IN p_sys_id VARCHAR(20),
    OUT p_job_id VARCHAR(50)
)
BEGIN
    SELECT CONCAT('SYS-JOB-', LPAD(CAST(IFNULL(SUBSTR(MAX(JOB_ID), 9, 4), '0') AS UNSIGNED) + 1, 4, '0'))
    INTO p_job_id
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id;

    -- If null (no records), set default
    IF p_job_id IS NULL THEN
        SET p_job_id = 'SYS-JOB-0001';
    END IF;
END//

-- ============================================================================
-- sp_batchwork_insert
-- Purpose: Insert new batch work record with auto-generated JOB_ID
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_batchwork_insert//
CREATE PROCEDURE sp_batchwork_insert(
    IN p_sys_id VARCHAR(20),
    IN p_job_grup VARCHAR(50),
    IN p_job_type VARCHAR(50),
    IN p_job_term VARCHAR(50),
    IN p_job_time VARCHAR(50),
    IN p_job_cmd TEXT,
    IN p_job_desc TEXT,
    IN p_err_proc VARCHAR(50),
    IN p_job_mng VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_job_remk TEXT,
    IN p_user_id VARCHAR(50),
    OUT p_out_job_id VARCHAR(50)
)
BEGIN
    DECLARE v_job_id VARCHAR(50);

    -- Generate next JOB_ID
    CALL sp_batchwork_get_next_job_id(p_sys_id, v_job_id);

    INSERT INTO SYS_JOB_MAST (
        SYS_ID,
        JOB_ID,
        JOB_GRUP,
        JOB_TYPE,
        JOB_TERM,
        JOB_TIME,
        JOB_CMD,
        JOB_DESC,
        ERR_PROC,
        JOB_MNG,
        USE_FLAG,
        JOB_REMK,
        REGI_ID,
        REGI_DATE,
        CHNG_ID,
        CHNG_DATE
    ) VALUES (
        p_sys_id,
        v_job_id,
        p_job_grup,
        p_job_type,
        p_job_term,
        p_job_time,
        p_job_cmd,
        p_job_desc,
        p_err_proc,
        p_job_mng,
        p_use_flag,
        p_job_remk,
        p_user_id,
        NOW(),
        p_user_id,
        NOW()
    );

    -- Return generated job_id
    SET p_out_job_id = v_job_id;
END//

-- ============================================================================
-- sp_batchwork_update
-- Purpose: Update batch work record with conditional field updates
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_batchwork_update//
CREATE PROCEDURE sp_batchwork_update(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_new_job_id VARCHAR(50),
    IN p_job_grup VARCHAR(50),
    IN p_job_type VARCHAR(50),
    IN p_job_term VARCHAR(50),
    IN p_job_time VARCHAR(50),
    IN p_job_cmd TEXT,
    IN p_job_desc TEXT,
    IN p_err_proc VARCHAR(50),
    IN p_job_mng VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_job_remk TEXT,
    IN p_regi_id VARCHAR(50),
    IN p_regi_date DATETIME,
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_JOB_MAST
    SET
        CHNG_ID = p_user_id,
        CHNG_DATE = NOW(),
        JOB_ID = CASE WHEN p_new_job_id IS NOT NULL AND p_new_job_id != '' THEN p_new_job_id ELSE JOB_ID END,
        JOB_GRUP = p_job_grup,
        JOB_TYPE = p_job_type,
        JOB_TERM = p_job_term,
        JOB_TIME = CASE WHEN p_job_time IS NOT NULL AND p_job_time != '' THEN p_job_time ELSE JOB_TIME END,
        JOB_CMD = CASE WHEN p_job_cmd IS NOT NULL AND p_job_cmd != '' THEN p_job_cmd ELSE JOB_CMD END,
        JOB_DESC = CASE WHEN p_job_desc IS NOT NULL AND p_job_desc != '' THEN p_job_desc ELSE JOB_DESC END,
        ERR_PROC = p_err_proc,
        JOB_MNG = CASE WHEN p_job_mng IS NOT NULL AND p_job_mng != '' THEN p_job_mng ELSE JOB_MNG END,
        USE_FLAG = p_use_flag,
        JOB_REMK = CASE WHEN p_job_remk IS NOT NULL AND p_job_remk != '' THEN p_job_remk ELSE JOB_REMK END,
        REGI_ID = CASE WHEN p_regi_id IS NOT NULL AND p_regi_id != '' THEN p_regi_id ELSE REGI_ID END,
        REGI_DATE = CASE WHEN p_regi_date IS NOT NULL THEN p_regi_date ELSE REGI_DATE END
    WHERE SYS_ID = p_sys_id
        AND JOB_ID = p_job_id;
END//

DELIMITER ;

-- ============================================================================
-- Verification Queries
-- ============================================================================
-- Test sp_batchwork_search:
-- CALL sp_batchwork_search('IMMES', NULL, NULL, NULL, 0, 10);
-- CALL sp_batchwork_search('IMMES', 'GROUP1', 'DAILY', 'JOB_ID DESC', 0, 20);

-- Test sp_batchwork_search_count:
-- CALL sp_batchwork_search_count('IMMES', NULL, NULL);

-- Test sp_batchwork_select:
-- CALL sp_batchwork_select('IMMES', 'SYS-JOB-0001');

-- Test sp_batchwork_insert:
-- SET @new_id = '';
-- CALL sp_batchwork_insert('IMMES', 'GROUP1', 'TYPE1', 'DAILY', '0900', 'cmd', 'desc', 'STOP', 'admin', 'Y', 'remark', 'admin', @new_id);
-- SELECT @new_id;

-- Test sp_batchwork_update:
-- CALL sp_batchwork_update('IMMES', 'SYS-JOB-0001', NULL, 'GROUP2', 'TYPE2', 'WEEKLY', '1000', 'new_cmd', 'new_desc', 'CONTINUE', 'admin', 'Y', 'new_remark', NULL, NULL, 'admin');
