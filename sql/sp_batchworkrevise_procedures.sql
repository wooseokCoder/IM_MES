-- ============================================================
-- BatchWorkRevise.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- BatchWorkRevise 프로시저
-- ============================================================

-- 1. 배치 작업 수정 목록 조회 (페이징, 동적 정렬)
DROP PROCEDURE IF EXISTS sp_batchworkrevise_search//

CREATE PROCEDURE sp_batchworkrevise_search(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_job_grup VARCHAR(50),
    IN p_job_term VARCHAR(20),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- 정렬 조건 설정 (Board.xml 스타일)
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'JOB_ID, JOB_TYPE DESC');

    SET @rownum := 0;

    -- 동적 SQL 구성 (Board.xml 스타일: 파라미터 값 직접 삽입, PREPARE/EXECUTE/DEALLOCATE 패턴)
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
                      AND (CASE WHEN '", IFNULL(p_job_id,''), "' != '' THEN JOB_ID = '", IFNULL(p_job_id,''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_job_grup,''), "' != '' THEN JOB_GRUP = '", IFNULL(p_job_grup,''), "' ELSE 1=1 END)
                      AND (CASE WHEN '", IFNULL(p_job_term,''), "' != '' THEN JOB_TERM = '", IFNULL(p_job_term,''), "' ELSE 1=1 END)
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

-- 2. 배치 작업 수정 카운트
DROP PROCEDURE IF EXISTS sp_batchworkrevise_search_count//

CREATE PROCEDURE sp_batchworkrevise_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_job_grup VARCHAR(50),
    IN p_job_term VARCHAR(20)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id
      AND (p_job_id IS NULL OR p_job_id = '' OR JOB_ID = p_job_id)
      AND (p_job_grup IS NULL OR p_job_grup = '' OR JOB_GRUP = p_job_grup)
      AND (p_job_term IS NULL OR p_job_term = '' OR JOB_TERM = p_job_term);
END//

-- 3. 배치 작업 등록 (JOB_ID 자동 생성 + INSERT)
DROP PROCEDURE IF EXISTS sp_batchworkrevise_insert//

CREATE PROCEDURE sp_batchworkrevise_insert(
    IN p_sys_id VARCHAR(20),
    IN p_job_grup VARCHAR(50),
    IN p_job_type VARCHAR(20),
    IN p_job_term VARCHAR(20),
    IN p_job_time VARCHAR(20),
    IN p_job_cmd TEXT,
    IN p_job_desc TEXT,
    IN p_err_proc VARCHAR(100),
    IN p_job_mng VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_job_remk TEXT,
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_job_id VARCHAR(50);

    -- JOB_ID 자동 생성 (SYS-JOB-0001 형식)
    SELECT CONCAT('SYS-JOB-', LPAD(CAST(IFNULL(SUBSTR(MAX(JOB_ID), 9, 4), '0') AS UNSIGNED) + 1, 4, '0'))
    INTO v_job_id
    FROM SYS_JOB_MAST
    WHERE SYS_ID = p_sys_id;

    IF v_job_id IS NULL THEN
        SET v_job_id = 'SYS-JOB-0001';
    END IF;

    -- 신규 데이터 INSERT
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
        p_gs_user_id,
        NOW(),
        p_gs_user_id,
        NOW()
    );
END//

-- 4. 배치 작업 수정
-- 리턴값: 1=성공, 0=영향없음, -1=에러
DROP PROCEDURE IF EXISTS sp_batchworkrevise_update//

CREATE PROCEDURE sp_batchworkrevise_update(
    IN p_sys_id VARCHAR(20),
    IN p_job_id VARCHAR(50),
    IN p_job_id_new VARCHAR(50),
    IN p_job_grup VARCHAR(50),
    IN p_job_type VARCHAR(20),
    IN p_job_term VARCHAR(20),
    IN p_job_time VARCHAR(20),
    IN p_job_cmd TEXT,
    IN p_job_desc TEXT,
    IN p_err_proc VARCHAR(100),
    IN p_job_mng VARCHAR(100),
    IN p_use_flag VARCHAR(1),
    IN p_job_remk TEXT,
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    DECLARE v_result INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT -1 AS result;
    END;

    UPDATE SYS_JOB_MAST
    SET CHNG_ID = p_gs_user_id,
        CHNG_DATE = NOW(),
        JOB_ID = CASE WHEN p_job_id_new IS NOT NULL AND p_job_id_new != '' THEN p_job_id_new ELSE JOB_ID END,
        JOB_GRUP = p_job_grup,
        JOB_TYPE = p_job_type,
        JOB_TERM = p_job_term,
        JOB_TIME = CASE WHEN p_job_time IS NOT NULL AND p_job_time != '' THEN p_job_time ELSE JOB_TIME END,
        JOB_CMD = CASE WHEN p_job_cmd IS NOT NULL AND p_job_cmd != '' THEN p_job_cmd ELSE JOB_CMD END,
        JOB_DESC = CASE WHEN p_job_desc IS NOT NULL AND p_job_desc != '' THEN p_job_desc ELSE JOB_DESC END,
        ERR_PROC = p_err_proc,
        JOB_MNG = CASE WHEN p_job_mng IS NOT NULL AND p_job_mng != '' THEN p_job_mng ELSE JOB_MNG END,
        USE_FLAG = p_use_flag,
        JOB_REMK = CASE WHEN p_job_remk IS NOT NULL AND p_job_remk != '' THEN p_job_remk ELSE JOB_REMK END
    WHERE SYS_ID = p_sys_id
      AND JOB_ID = p_job_id;

    SET v_result = ROW_COUNT();

    -- 리턴: 1=성공, 0=영향없음
    SELECT CASE WHEN v_result > 0 THEN 1 ELSE 0 END AS result;
END//

DELIMITER ;
