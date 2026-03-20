-- ============================================================
-- BatchStatus.xml, BatchWork.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- ============================================================

DELIMITER //

-- ============================================================
-- BatchStatus 프로시저
-- ============================================================

-- 1. 배치 상태 목록 조회 (페이징)
DROP PROCEDURE IF EXISTS sp_batchstatus_search//

CREATE PROCEDURE sp_batchstatus_search(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_succ_fail VARCHAR(10),
    IN p_acc_time_bgn VARCHAR(20),
    IN p_acc_time_end VARCHAR(20),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;

    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
            FROM (
                SELECT
                    A.JOB_ID AS jobId,
                    JOB_DESC AS jobDesc,
                    JOB_TERM AS jobTerm,
                    JOB_TIME AS jobTime,
                    BGN_DATE AS bgnDate,
                    END_DATE AS endDate,
                    FILE_SEQ AS fileSeq,
                    JOB_RSLT AS jobRslt,
                    RSLT_DESC AS rsltDesc,
                    JOB_FILE AS jobFile,
                    JOB_REMK AS jobRemk
                FROM SYS_JOB_MAST A
                JOIN SYS_JOB_HIST B ON A.JOB_ID = B.JOB_ID AND A.SYS_ID = B.SYS_ID
                WHERE A.SYS_ID = p_sys_id
                  AND (p_job_id IS NULL OR p_job_id = '' OR A.JOB_ID = p_job_id)
                  AND (p_succ_fail IS NULL OR p_succ_fail = '' OR B.JOB_RSLT = p_succ_fail)
                  AND (
                      CASE WHEN (p_acc_time_bgn IS NOT NULL AND p_acc_time_bgn != '') OR (p_acc_time_end IS NOT NULL AND p_acc_time_end != '')
                           THEN B.BGN_DATE >= p_acc_time_bgn AND B.END_DATE <= p_acc_time_end
                           ELSE B.BGN_DATE >= DATE_FORMAT(NOW() - INTERVAL 1 DAY, '%Y-%m-%d') AND B.END_DATE <= DATE_FORMAT(NOW(), '%Y-%m-%d')
                      END
                  )
                ORDER BY A.REGI_DATE, A.JOB_ID DESC
            ) Z1
        ) X
        WHERE (p_end IS NULL OR RNUM < p_end)
    ) X
    WHERE (p_start IS NULL OR RNUM >= p_start);
END//

-- 2. 배치 상태 카운트
DROP PROCEDURE IF EXISTS sp_batchstatus_search_count//

CREATE PROCEDURE sp_batchstatus_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_succ_fail VARCHAR(10),
    IN p_acc_time_bgn VARCHAR(20),
    IN p_acc_time_end VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_JOB_MAST A
    JOIN SYS_JOB_HIST B ON A.JOB_ID = B.JOB_ID AND A.SYS_ID = B.SYS_ID
    WHERE A.SYS_ID = p_sys_id
      AND (p_job_id IS NULL OR p_job_id = '' OR A.JOB_ID = p_job_id)
      AND (p_succ_fail IS NULL OR p_succ_fail = '' OR B.JOB_RSLT = p_succ_fail)
      AND (
          CASE WHEN (p_acc_time_bgn IS NOT NULL AND p_acc_time_bgn != '') OR (p_acc_time_end IS NOT NULL AND p_acc_time_end != '')
               THEN B.BGN_DATE >= p_acc_time_bgn AND B.END_DATE <= p_acc_time_end
               ELSE B.BGN_DATE >= DATE_FORMAT(NOW() - INTERVAL 1 DAY, '%Y-%m-%d') AND B.END_DATE <= DATE_FORMAT(NOW(), '%Y-%m-%d')
          END
      );
END//

-- 3. Job ID 목록 조회
DROP PROCEDURE IF EXISTS sp_batchstatus_get_select_job_id//

CREATE PROCEDURE sp_batchstatus_get_select_job_id(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT JOB_ID
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id;
END//

-- ============================================================
-- BatchWork 프로시저
-- ============================================================

-- 4. 배치 작업 목록 조회 (페이징)
DROP PROCEDURE IF EXISTS sp_batchwork_search//

CREATE PROCEDURE sp_batchwork_search(
    IN p_sys_id VARCHAR(20),
    IN p_job_grup VARCHAR(50),
    IN p_job_term VARCHAR(20),
    IN p_start INT,
    IN p_end INT
)
BEGIN
    SET @rownum := 0;

    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM
            FROM (
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
                  AND (p_job_grup IS NULL OR p_job_grup = '' OR JOB_GRUP = p_job_grup)
                  AND (p_job_term IS NULL OR p_job_term = '' OR JOB_TERM = p_job_term)
                ORDER BY JOB_ID, JOB_TYPE DESC
            ) Z1
        ) X
        WHERE (p_end IS NULL OR RNUM < p_end)
    ) X
    WHERE (p_start IS NULL OR RNUM >= p_start);
END//

-- 5. 배치 작업 카운트
DROP PROCEDURE IF EXISTS sp_batchwork_search_count//

CREATE PROCEDURE sp_batchwork_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_job_grup VARCHAR(50),
    IN p_job_term VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id
      AND (p_job_grup IS NULL OR p_job_grup = '' OR JOB_GRUP = p_job_grup)
      AND (p_job_term IS NULL OR p_job_term = '' OR JOB_TERM = p_job_term);
END//

-- 6. 배치 작업 단건 조회
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

-- 7. 배치 작업 등록 (자동 ID 생성)
DROP PROCEDURE IF EXISTS sp_batchwork_insert//

CREATE PROCEDURE sp_batchwork_insert(
    IN p_sys_id VARCHAR(20),
    IN p_job_grup VARCHAR(50),
    IN p_job_type VARCHAR(20),
    IN p_job_term VARCHAR(20),
    IN p_job_time VARCHAR(20),
    IN p_job_cmd VARCHAR(500),
    IN p_job_desc VARCHAR(500),
    IN p_err_proc VARCHAR(100),
    IN p_job_mng VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_job_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50),
    OUT p_new_job_id VARCHAR(50)
)
BEGIN
    SELECT CONCAT('SYS-JOB-', LPAD(CAST(IFNULL(SUBSTR(MAX(JOB_ID), 9, 4), '0') AS UNSIGNED) + 1, 4, '0'))
    INTO p_new_job_id
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id;

    INSERT INTO SYS_JOB_MAST (
        SYS_ID, JOB_ID, JOB_GRUP, JOB_TYPE, JOB_TERM, JOB_TIME,
        JOB_CMD, JOB_DESC, ERR_PROC, JOB_MNG, USE_FLAG, JOB_REMK,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, p_new_job_id, p_job_grup, p_job_type, p_job_term, p_job_time,
        p_job_cmd, p_job_desc, p_err_proc, p_job_mng, p_use_flag, p_job_remk,
        p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- 8. 배치 작업 수정
DROP PROCEDURE IF EXISTS sp_batchwork_update//

CREATE PROCEDURE sp_batchwork_update(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_job_grup VARCHAR(50),
    IN p_job_type VARCHAR(20),
    IN p_job_term VARCHAR(20),
    IN p_job_time VARCHAR(20),
    IN p_job_cmd VARCHAR(500),
    IN p_job_desc VARCHAR(500),
    IN p_err_proc VARCHAR(100),
    IN p_job_mng VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_job_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_JOB_MAST
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        JOB_GRUP = p_job_grup,
        JOB_TYPE = p_job_type,
        JOB_TERM = p_job_term,
        JOB_TIME = IFNULL(p_job_time, JOB_TIME),
        JOB_CMD = IFNULL(p_job_cmd, JOB_CMD),
        JOB_DESC = IFNULL(p_job_desc, JOB_DESC),
        ERR_PROC = p_err_proc,
        JOB_MNG = IFNULL(p_job_mng, JOB_MNG),
        USE_FLAG = p_use_flag,
        JOB_REMK = IFNULL(p_job_remk, JOB_REMK)
    WHERE SYS_ID = p_sys_id
      AND JOB_ID = p_job_id;
END//

DELIMITER ;
