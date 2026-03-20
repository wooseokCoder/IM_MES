-- ============================================================
-- JobHist.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- DBeaver 실행: Alt+X -> Statement delimiter를 // 로 설정
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 작업 이력 목록 조회 (페이징, 동적 정렬 지원)
-- AS-IS: search 쿼리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_jobhist_search//

CREATE PROCEDURE sp_jobhist_search(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_job_desc VARCHAR(200),
    IN p_job_rslt VARCHAR(50),
    IN p_bgn_date VARCHAR(20),
    IN p_end_date VARCHAR(20),
    IN p_rslt_desc VARCHAR(200),
    IN p_job_file VARCHAR(200),
    IN p_acc_time_bgn VARCHAR(20),
    IN p_acc_time_end VARCHAR(20),
    IN p_start INT,
    IN p_end INT,
    IN p_sort_str TEXT
)
BEGIN
    -- 동적 정렬 처리: sortStr이 있으면 사용, 없으면 기본 정렬
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'A.BGN_DATE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성 (Board.xml 페이징 스타일)
    SET @sql = CONCAT("
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT
                        A.SYS_ID AS sysId,
                        JOB_ID AS jobId,
                        JOB_NO AS jobNo,
                        JOB_DESC AS jobDesc,
                        A.REGI_ID AS regiId,
                        A.CHNG_ID AS chngId,
                        BGN_DATE AS bgnDate,
                        END_DATE AS endDate,
                        RSLT_DESC AS rsltDesc,
                        A.REGI_DATE AS regiDate,
                        A.CHNG_DATE AS chngDate,
                        JOB_FILE AS jobFile,
                        JOB_RSLT AS jobRslt,
                        FILE_SEQ AS fileSeq
                    FROM SYS_JOB_HIST A
                    JOIN DATA_OPER_MAST B ON A.JOB_ID = B.JOB_NO
                    WHERE A.SYS_ID = '", p_sys_id, "'
                      AND JOB_FILE NOT LIKE '%dummy%'
                      AND (CASE WHEN '", IFNULL(p_job_id, ''), "' != '' THEN JOB_ID = '", IFNULL(p_job_id, ''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_job_rslt, ''), "' != '' THEN JOB_RSLT LIKE CONCAT('", IFNULL(p_job_rslt, ''), "', '%') ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_bgn_date, ''), "' != '' THEN BGN_DATE = '", IFNULL(p_bgn_date, ''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_end_date, ''), "' != '' THEN END_DATE = '", IFNULL(p_end_date, ''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_job_file, ''), "' != '' THEN JOB_FILE = '", IFNULL(p_job_file, ''), "' ELSE 1=1 END)
                      AND (
                          CASE WHEN ('", IFNULL(p_acc_time_bgn, ''), "' != '' OR '", IFNULL(p_acc_time_end, ''), "' != '')
                               THEN DATE_FORMAT(BGN_DATE, '%Y-%m-%d') BETWEEN FN_CONV_DATE('", IFNULL(p_acc_time_bgn, ''), "') AND FN_CONV_DATE('", IFNULL(p_acc_time_end, ''), "')
                               ELSE DATE_FORMAT(BGN_DATE, '%Y-%m-%d') BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%d') AND DATE_FORMAT(NOW(), '%Y-%m-%d')
                          END
                      )
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

-- ============================================================
-- 2. 작업 이력 카운트
-- AS-IS: searchCount 쿼리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_jobhist_search_count//

CREATE PROCEDURE sp_jobhist_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_job_desc VARCHAR(200),
    IN p_job_rslt VARCHAR(50),
    IN p_bgn_date VARCHAR(20),
    IN p_end_date VARCHAR(20),
    IN p_rslt_desc VARCHAR(200),
    IN p_job_file VARCHAR(200),
    IN p_acc_time_bgn VARCHAR(20),
    IN p_acc_time_end VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_JOB_HIST A
    JOIN DATA_OPER_MAST B ON A.JOB_ID = B.JOB_NO
    WHERE A.SYS_ID = p_sys_id
      AND JOB_FILE NOT LIKE '%dummy%'
      AND (p_job_id IS NULL OR p_job_id = '' OR JOB_ID = p_job_id)
      AND (p_job_rslt IS NULL OR p_job_rslt = '' OR JOB_RSLT LIKE CONCAT(p_job_rslt, '%'))
      AND (p_bgn_date IS NULL OR p_bgn_date = '' OR BGN_DATE = p_bgn_date)
      AND (p_end_date IS NULL OR p_end_date = '' OR END_DATE = p_end_date)
      AND (p_job_file IS NULL OR p_job_file = '' OR JOB_FILE = p_job_file)
      AND (
          CASE WHEN (p_acc_time_bgn IS NOT NULL AND p_acc_time_bgn != '') OR (p_acc_time_end IS NOT NULL AND p_acc_time_end != '')
               THEN DATE_FORMAT(BGN_DATE, '%Y-%m-%d') BETWEEN FN_CONV_DATE(p_acc_time_bgn) AND FN_CONV_DATE(p_acc_time_end)
               ELSE DATE_FORMAT(BGN_DATE, '%Y-%m-%d') BETWEEN DATE_FORMAT(NOW(), '%Y-%m-%d') AND DATE_FORMAT(NOW(), '%Y-%m-%d')
          END
      );
END//

-- ============================================================
-- 3. 작업 이력 등록
-- AS-IS: insert 쿼리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_jobhist_insert//

CREATE PROCEDURE sp_jobhist_insert(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_regi_id VARCHAR(50),
    IN p_chng_id VARCHAR(50),
    IN p_job_file VARCHAR(200),
    IN p_job_rslt VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_JOB_HIST (
        SYS_ID, JOB_ID, REGI_ID, CHNG_ID,
        BGN_DATE, REGI_DATE, CHNG_DATE,
        JOB_FILE, JOB_RSLT
    ) VALUES (
        p_sys_id, p_job_id, p_regi_id, p_chng_id,
        DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'),
        DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'),
        DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'),
        p_job_file, p_job_rslt
    );
END//

-- ============================================================
-- 4. 작업 이력 삭제
-- AS-IS: delete 쿼리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_jobhist_delete//

CREATE PROCEDURE sp_jobhist_delete(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_regi_id VARCHAR(50),
    IN p_chng_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_JOB_HIST
    WHERE SYS_ID = p_sys_id
      AND JOB_ID = p_job_id
      AND REGI_ID = p_regi_id
      AND CHNG_ID = p_chng_id;
END//

-- ============================================================
-- 5. Job ID 목록 조회
-- AS-IS: selectJobIdList 쿼리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_jobhist_select_job_id_list//

CREATE PROCEDURE sp_jobhist_select_job_id_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT DISTINCT JOB_ID AS jobId, JOB_DESC AS jobDesc
    FROM SYS_JOB_HIST A
    JOIN DATA_OPER_MAST B ON A.JOB_ID = B.JOB_NO
    WHERE A.SYS_ID = p_sys_id;
END//

-- ============================================================
-- 6. Job 결과 목록 조회
-- AS-IS: selectJobRsltList 쿼리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_jobhist_select_job_rslt_list//

CREATE PROCEDURE sp_jobhist_select_job_rslt_list(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT DISTINCT JOB_RSLT AS jobRslt
    FROM SYS_JOB_HIST
    WHERE SYS_ID = p_sys_id
      AND JOB_RSLT IS NOT NULL;
END//

-- ============================================================
-- 7. 작업 이력 그룹 조회 (페이징, 동적 정렬 지원)
-- AS-IS: searchJobHistGroup 쿼리
-- ============================================================
DROP PROCEDURE IF EXISTS sp_jobhist_search_group//

CREATE PROCEDURE sp_jobhist_search_group(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_group_id VARCHAR(50),
    IN p_start INT,
    IN p_end INT,
    IN p_sort_str TEXT
)
BEGIN
    -- 동적 정렬 처리: sortStr이 있으면 사용, 없으면 기본 정렬
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'A.BGN_DATE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성 (Board.xml 페이징 스타일)
    SET @sql = CONCAT("
        SELECT * FROM (
            SELECT X.* FROM (
                SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                    SELECT
                        A.SYS_ID AS sysId,
                        JOB_ID AS jobId,
                        JOB_NO AS jobNo,
                        JOB_DESC AS jobDesc,
                        A.REGI_ID AS regiId,
                        A.CHNG_ID AS chngId,
                        BGN_DATE AS bgnDate,
                        END_DATE AS endDate,
                        RSLT_DESC AS rsltDesc,
                        A.REGI_DATE AS regiDate,
                        A.CHNG_DATE AS chngDate,
                        JOB_FILE AS jobFile,
                        JOB_RSLT AS jobRslt,
                        FILE_SEQ AS fileSeq
                    FROM SYS_JOB_HIST A
                    JOIN DATA_OPER_MAST B ON A.JOB_ID = B.JOB_NO
                    WHERE A.SYS_ID = '", p_sys_id, "'
                      AND (CASE WHEN '", IFNULL(p_user_id, ''), "' != '' THEN USER_ID = '", IFNULL(p_user_id, ''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_group_id, ''), "' != '' THEN GROUP_ID = '", IFNULL(p_group_id, ''), "' ELSE 1=1 END)
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

DELIMITER ;
