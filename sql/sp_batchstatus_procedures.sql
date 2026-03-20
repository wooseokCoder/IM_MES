-- ============================================================
-- BatchStatus.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- 동적 정렬 지원 버전
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. sp_batchstatus_search: 배치 상태 목록 조회 (페이징, 동적 정렬)
-- ============================================================
-- AS-IS:
--   SELECT A.JOB_ID AS "jobId", JOB_DESC AS "jobDesc", JOB_TERM AS "jobTerm",
--          JOB_TIME AS "jobTime", BGN_DATE AS "bgnDate", END_DATE AS "endDate",
--          FILE_SEQ AS "fileSeq", JOB_RSLT AS "jobRslt", RSLT_DESC AS "rsltDesc",
--          JOB_FILE AS "jobFile", JOB_REMK AS "jobRemk"
--   FROM SYS_JOB_MAST AS A
--   JOIN SYS_JOB_HIST AS B
--   WHERE A.SYS_ID = #{sysId}
--     AND A.JOB_ID=B.JOB_ID AND A.SYS_ID = B.SYS_ID
--     AND (동적 조건들)
--   ORDER BY (동적 정렬 또는 A.REGI_DATE, A.JOB_ID DESC)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_batchstatus_search//

CREATE PROCEDURE sp_batchstatus_search(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_succ_fail VARCHAR(10),
    IN p_acc_time_bgn VARCHAR(20),
    IN p_acc_time_end VARCHAR(20),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- 동적 정렬 처리: 정렬 문자열이 있으면 사용, 없으면 기본 정렬
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'A.REGI_DATE, A.JOB_ID DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성
    SET @sql = CONCAT("
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
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
                    WHERE A.SYS_ID = '", p_sys_id, "'
                      AND (CASE WHEN '", IFNULL(p_job_id,''), "' != '' THEN A.JOB_ID = '", IFNULL(p_job_id,''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_succ_fail,''), "' != '' THEN B.JOB_RSLT = '", IFNULL(p_succ_fail,''), "' ELSE 1=1 END)
                      AND (
                          CASE WHEN '", IFNULL(p_acc_time_bgn,''), "' != '' OR '", IFNULL(p_acc_time_end,''), "' != ''
                               THEN B.BGN_DATE >= '", IFNULL(p_acc_time_bgn,''), "' AND B.END_DATE <= '", IFNULL(p_acc_time_end,''), "'
                               ELSE B.BGN_DATE >= DATE_FORMAT(NOW() - INTERVAL 1 DAY, '%Y-%m-%d')
                                    AND B.END_DATE <= DATE_FORMAT(NOW(), '%Y-%m-%d')
                          END
                      )
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

-- ============================================================
-- 2. sp_batchstatus_search_count: 배치 상태 카운트
-- ============================================================
-- AS-IS:
--   SELECT COUNT(1)
--   FROM SYS_JOB_MAST AS A
--   JOIN SYS_JOB_HIST AS B
--   WHERE A.SYS_ID = #{sysId}
--     AND A.JOB_ID=B.JOB_ID AND A.SYS_ID = B.SYS_ID
--     AND (동적 조건들)
-- ============================================================
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

-- ============================================================
-- 3. sp_batchstatus_get_select_job_id: Job ID 목록 조회
-- ============================================================
-- AS-IS:
--   SELECT JOB_ID
--   FROM SYS_JOB_MAST
--   WHERE SYS_ID = #{sysId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_batchstatus_get_select_job_id//

CREATE PROCEDURE sp_batchstatus_get_select_job_id(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT JOB_ID AS jobId
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id;
END//

DELIMITER ;

-- ============================================================
-- 검증 쿼리 (프로시저 테스트)
-- ============================================================
-- CALL sp_batchstatus_search('IMMES', NULL, NULL, NULL, NULL, NULL, 0, 20);
-- CALL sp_batchstatus_search('IMMES', 'JOB001', NULL, '2026-01-01', '2026-01-15', 'A.JOB_ID DESC', 0, 20);
-- CALL sp_batchstatus_search_count('IMMES', NULL, NULL, NULL, NULL);
-- CALL sp_batchstatus_get_select_job_id('IMMES');
