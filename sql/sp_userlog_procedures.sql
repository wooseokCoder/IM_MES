-- ============================================================
-- UserLog.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- 수정일: 2026-01-15 (동적 정렬 기능 추가)
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 사용자 로그 목록 조회 (페이징 + 동적 정렬)
-- AS-IS:
--     SELECT SYS_ID AS "sysId"
--           ,DATE_FORMAT(ACC_TIME,'%Y-%m-%d %H:%i:%s') AS "accTime"
--           ,USER_ID AS "userId"
--           ,PROG_ID AS "progId"
--           ,LOGIN_DATE AS "loginDate"
--           ,CLIENT_IP AS "clientIp"
--           ,CLIENT_NAME AS "clientName"
--           ,CLIENT_AGENT AS "clientAgent"
--           ,LOG_REMK AS "logRemk"
--       FROM SYS_ULOG A
--      WHERE SYS_ID = #{sysId}
--        AND (userId 조건)
--        AND (progId 조건)
--        AND (loginDate 조건)
--        AND (clientIp 조건)
--        AND (clientName 조건)
--        AND (clientAgent 조건)
--      ORDER BY gsSorts 또는 A.ACC_TIME DESC
--      (페이징 처리)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_userlog_search//

CREATE PROCEDURE sp_userlog_search(
    IN p_sys_id       VARCHAR(20),
    IN p_user_id      VARCHAR(50),
    IN p_prog_id      VARCHAR(50),
    IN p_login_date   VARCHAR(10),
    IN p_client_ip    VARCHAR(50),
    IN p_client_name  VARCHAR(100),
    IN p_client_agent VARCHAR(200),
    IN p_sort_str     TEXT,
    IN p_start        INT,
    IN p_end          INT
)
BEGIN
    -- 정렬 조건 설정 (Board.xml 스타일)
    SET @sort_order = IF(p_sort_str IS NOT NULL AND p_sort_str != '', p_sort_str, 'A.ACC_TIME DESC');

    -- rownum 변수 초기화 (Board.xml 스타일: SET 문으로 별도 초기화)
    SET @rownum := 0;

    -- 동적 SQL 구성 (Board.xml 스타일: @sql 세션 변수 사용)
    SET @sql = CONCAT("
    SELECT * FROM (
        SELECT X.* FROM (
            SELECT Z1.*, @rownum := @rownum + 1 AS RNUM FROM (
                SELECT
                    A.SYS_ID AS sysId,
                    DATE_FORMAT(A.ACC_TIME, '%Y-%m-%d %H:%i:%s') AS accTime,
                    A.USER_ID AS userId,
                    A.PROG_ID AS progId,
                    A.LOGIN_DATE AS loginDate,
                    A.CLIENT_IP AS clientIp,
                    A.CLIENT_NAME AS clientName,
                    A.CLIENT_AGENT AS clientAgent,
                    A.LOG_REMK AS logRemk
                FROM SYS_ULOG A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND (CASE WHEN '", IFNULL(p_user_id,''), "' != '' THEN A.USER_ID = '", IFNULL(p_user_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_prog_id,''), "' != '' THEN A.PROG_ID = '", IFNULL(p_prog_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_login_date,''), "' != '' THEN A.LOGIN_DATE = '", IFNULL(p_login_date,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_client_ip,''), "' != '' THEN A.CLIENT_IP = '", IFNULL(p_client_ip,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_client_name,''), "' != '' THEN A.CLIENT_NAME = '", IFNULL(p_client_name,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_client_agent,''), "' != '' THEN A.CLIENT_AGENT = '", IFNULL(p_client_agent,''), "' ELSE 1=1 END)
                ORDER BY ", @sort_order, "
            ) Z1, (SELECT @rownum:=0) Z2
        ) X
        WHERE (CASE WHEN ", IFNULL(p_end, 'NULL'), " IS NOT NULL THEN RNUM < ", IFNULL(p_end, 0), " ELSE 1=1 END)
    ) X
    WHERE (CASE WHEN ", IFNULL(p_start, 'NULL'), " IS NOT NULL THEN RNUM >= ", IFNULL(p_start, 0), " ELSE 1=1 END)");

    -- 동적 SQL 실행 (Board.xml 스타일: PREPARE/EXECUTE/DEALLOCATE)
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. 사용자 로그 카운트
-- AS-IS:
--     SELECT COUNT(1)
--       FROM SYS_ULOG A
--      WHERE SYS_ID = #{sysId}
--        AND (userId 조건)
--        AND (progId 조건)
--        AND (loginDate 조건)
--        AND (clientIp 조건)
--        AND (clientName 조건)
--        AND (clientAgent 조건)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_userlog_search_count//

CREATE PROCEDURE sp_userlog_search_count(
    IN p_sys_id       VARCHAR(20),
    IN p_user_id      VARCHAR(50),
    IN p_prog_id      VARCHAR(50),
    IN p_login_date   VARCHAR(10),
    IN p_client_ip    VARCHAR(50),
    IN p_client_name  VARCHAR(100),
    IN p_client_agent VARCHAR(200)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_ULOG A
    WHERE SYS_ID = p_sys_id
      AND (p_user_id IS NULL OR p_user_id = '' OR USER_ID = p_user_id)
      AND (p_prog_id IS NULL OR p_prog_id = '' OR PROG_ID = p_prog_id)
      AND (p_login_date IS NULL OR p_login_date = '' OR LOGIN_DATE = p_login_date)
      AND (p_client_ip IS NULL OR p_client_ip = '' OR CLIENT_IP = p_client_ip)
      AND (p_client_name IS NULL OR p_client_name = '' OR CLIENT_NAME = p_client_name)
      AND (p_client_agent IS NULL OR p_client_agent = '' OR CLIENT_AGENT = p_client_agent);
END//

-- ============================================================
-- 3. 사용자 로그 등록
-- 주의: 기존 프로시저명 sp_insert_sys_ulog 유지
-- AS-IS:
--     INSERT INTO SYS_ULOG
--          ( SYS_ID, PROG_ID, USER_ID, ACC_TIME
--           [, LOGIN_DATE][, CLIENT_IP][, CLIENT_NAME][, CLIENT_AGENT])
--     VALUES
--          ( #{sysId}, #{progId}, #{userId}, NOW()
--           [, #{loginDate}][, #{clientIp}][, #{clientName}][, #{clientAgent}])
-- ============================================================
DROP PROCEDURE IF EXISTS sp_insert_sys_ulog//

CREATE PROCEDURE sp_insert_sys_ulog(
    IN p_sys_id       VARCHAR(20),
    IN p_user_id      VARCHAR(50),
    IN p_prog_id      VARCHAR(50),
    IN p_login_date   VARCHAR(10),
    IN p_client_ip    VARCHAR(50),
    IN p_client_name  VARCHAR(100),
    IN p_client_agent VARCHAR(200),
    IN p_log_remk     TEXT
)
BEGIN
    INSERT INTO SYS_ULOG
         ( SYS_ID
         , PROG_ID
         , USER_ID
         , ACC_TIME
         , LOGIN_DATE
         , CLIENT_IP
         , CLIENT_NAME
         , CLIENT_AGENT
         , LOG_REMK
         )
    VALUES
         ( p_sys_id
         , p_prog_id
         , p_user_id
         , NOW()
         , CASE WHEN p_login_date IS NOT NULL AND p_login_date != '' THEN p_login_date ELSE NULL END
         , CASE WHEN p_client_ip IS NOT NULL AND p_client_ip != '' THEN p_client_ip ELSE NULL END
         , CASE WHEN p_client_name IS NOT NULL AND p_client_name != '' THEN p_client_name ELSE NULL END
         , CASE WHEN p_client_agent IS NOT NULL AND p_client_agent != '' THEN p_client_agent ELSE NULL END
         , CASE WHEN p_log_remk IS NOT NULL AND p_log_remk != '' THEN p_log_remk ELSE NULL END
         );
END//

-- ============================================================
-- 4. 사용자 로그 삭제
-- AS-IS:
--     DELETE FROM SYS_ULOG
--      WHERE SYS_ID    = #{sysId}
--        AND USER_ID   = #{userId}
--        AND PROG_ID   = #{progId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_userlog_delete//

CREATE PROCEDURE sp_userlog_delete(
    IN p_sys_id  VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_prog_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_ULOG
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND PROG_ID = p_prog_id;
END//

DELIMITER ;
