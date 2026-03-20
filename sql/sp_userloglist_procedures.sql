-- ============================================================
-- UserLogList Procedures
-- Source: /mappers/com/wsc/common/user/UserLogList.xml
-- Generated: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. sp_userloglist_search : 사용자 로그 목록 조회 (페이징)
-- AS-IS: search
-- ============================================================
DROP PROCEDURE IF EXISTS sp_userloglist_search//
CREATE PROCEDURE sp_userloglist_search(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(100),
    IN p_login_date VARCHAR(10),
    IN p_client_ip VARCHAR(50),
    IN p_client_name VARCHAR(100),
    IN p_client_agent VARCHAR(500),
    IN p_prog_id VARCHAR(50),
    IN p_user_type VARCHAR(20),
    IN p_acc_time_bgn VARCHAR(10),
    IN p_acc_time_end VARCHAR(10),
    IN p_sort_str TEXT,
    IN p_start INT,
    IN p_end INT
)
BEGIN
    -- 동적 SQL 구성
    SET @sql = '';
    SET @where_clause = '';
    SET @sort_clause = '';
    SET @rownum := 0;

    -- WHERE 절 구성
    SET @where_clause = CONCAT('A.SYS_ID = ''', p_sys_id, '''');

    IF p_user_id IS NOT NULL AND p_user_id != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.USER_ID LIKE ''%', p_user_id, '%''');
    END IF;

    IF p_login_date IS NOT NULL AND p_login_date != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.LOGIN_DATE = ''', p_login_date, '''');
    END IF;

    IF p_client_ip IS NOT NULL AND p_client_ip != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.CLIENT_IP = ''', p_client_ip, '''');
    END IF;

    IF p_client_name IS NOT NULL AND p_client_name != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.CLIENT_NAME = ''', p_client_name, '''');
    END IF;

    IF p_client_agent IS NOT NULL AND p_client_agent != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.CLIENT_AGENT = ''', p_client_agent, '''');
    END IF;

    IF p_prog_id IS NOT NULL AND p_prog_id != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.PROG_ID LIKE ''', p_prog_id, '%''');
    END IF;

    IF p_user_type IS NOT NULL AND p_user_type != '' THEN
        IF p_user_type = 'LSTA' THEN
            SET @where_clause = CONCAT(@where_clause, ' AND B.USER_TYPE = ''A''');
        ELSEIF p_user_type = 'DEALER' THEN
            SET @where_clause = CONCAT(@where_clause, ' AND B.USER_TYPE = ''C''');
        END IF;
    END IF;

    -- 날짜 범위 조건
    IF (p_acc_time_bgn IS NOT NULL AND p_acc_time_bgn != '') OR (p_acc_time_end IS NOT NULL AND p_acc_time_end != '') THEN
        SET @where_clause = CONCAT(@where_clause,
            ' AND DATE_FORMAT(A.ACC_TIME,''%Y-%m-%d'') BETWEEN FN_CONV_DATE(''',
            IFNULL(p_acc_time_bgn, ''), ''') AND FN_CONV_DATE(''', IFNULL(p_acc_time_end, ''), ''')');
    ELSE
        SET @where_clause = CONCAT(@where_clause,
            ' AND DATE_FORMAT(A.ACC_TIME,''%Y-%m-%d'') BETWEEN DATE_FORMAT(NOW(),''%Y-%m-%d'') AND DATE_FORMAT(NOW(),''%Y-%m-%d'')');
    END IF;

    -- SORT 절 구성
    IF p_sort_str IS NOT NULL AND p_sort_str != '' THEN
        SET @sort_clause = p_sort_str;
    ELSE
        SET @sort_clause = 'A.ACC_TIME DESC';
    END IF;

    -- 페이징 처리 여부에 따른 SQL 구성
    IF p_start IS NOT NULL AND p_end IS NOT NULL THEN
        SET @sql = CONCAT('
            SELECT *
              FROM (
                    SELECT X.*
                      FROM (
                            SELECT Z1.*, @rownum := @rownum+1 as RNUM
                              FROM (
                                    SELECT
                                        A.SYS_ID AS sysId,
                                        A.ACC_TIME AS accTime,
                                        A.USER_ID AS userId,
                                        A.PROG_ID AS progId,
                                        A.LOGIN_DATE AS loginDate,
                                        A.CLIENT_IP AS clientIp,
                                        A.CLIENT_NAME AS clientName,
                                        A.CLIENT_AGENT AS clientAgent,
                                        B.USER_TYPE AS userType,
                                        IFNULL(A.LOG_REMK,'''') AS logRemk
                                      FROM SYS_ULOG A
                                      INNER JOIN sys_user B ON A.SYS_ID = B.SYS_ID AND A.USER_ID = B.USER_ID
                                     WHERE ', @where_clause, '
                                     ORDER BY ', @sort_clause, '
                                   ) Z1, (SELECT @rownum:=0) Z2
                           ) X
                     WHERE RNUM < ', p_end, '
                   ) X
             WHERE RNUM >= ', p_start);
    ELSE
        SET @sql = CONCAT('
            SELECT
                A.SYS_ID AS sysId,
                A.ACC_TIME AS accTime,
                A.USER_ID AS userId,
                A.PROG_ID AS progId,
                A.LOGIN_DATE AS loginDate,
                A.CLIENT_IP AS clientIp,
                A.CLIENT_NAME AS clientName,
                A.CLIENT_AGENT AS clientAgent,
                B.USER_TYPE AS userType,
                IFNULL(A.LOG_REMK,'''') AS logRemk,
                0 AS RNUM
              FROM SYS_ULOG A
              INNER JOIN sys_user B ON A.SYS_ID = B.SYS_ID AND A.USER_ID = B.USER_ID
             WHERE ', @where_clause, '
             ORDER BY ', @sort_clause);
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 2. sp_userloglist_search_count : 사용자 로그 건수 조회
-- AS-IS: searchCount
-- ============================================================
DROP PROCEDURE IF EXISTS sp_userloglist_search_count//
CREATE PROCEDURE sp_userloglist_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(100),
    IN p_login_date VARCHAR(10),
    IN p_client_ip VARCHAR(50),
    IN p_client_name VARCHAR(100),
    IN p_client_agent VARCHAR(500),
    IN p_prog_id VARCHAR(50),
    IN p_user_type VARCHAR(20),
    IN p_acc_time_bgn VARCHAR(10),
    IN p_acc_time_end VARCHAR(10)
)
BEGIN
    -- 동적 SQL 구성
    SET @sql = '';
    SET @where_clause = '';

    -- WHERE 절 구성
    SET @where_clause = CONCAT('A.SYS_ID = ''', p_sys_id, '''');

    IF p_user_id IS NOT NULL AND p_user_id != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.USER_ID LIKE ''%', p_user_id, '%''');
    END IF;

    IF p_login_date IS NOT NULL AND p_login_date != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.LOGIN_DATE = ''', p_login_date, '''');
    END IF;

    IF p_client_ip IS NOT NULL AND p_client_ip != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.CLIENT_IP = ''', p_client_ip, '''');
    END IF;

    IF p_client_name IS NOT NULL AND p_client_name != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.CLIENT_NAME = ''', p_client_name, '''');
    END IF;

    IF p_client_agent IS NOT NULL AND p_client_agent != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.CLIENT_AGENT = ''', p_client_agent, '''');
    END IF;

    IF p_prog_id IS NOT NULL AND p_prog_id != '' THEN
        SET @where_clause = CONCAT(@where_clause, ' AND A.PROG_ID LIKE ''', p_prog_id, '%''');
    END IF;

    IF p_user_type IS NOT NULL AND p_user_type != '' THEN
        IF p_user_type = 'LSTA' THEN
            SET @where_clause = CONCAT(@where_clause, ' AND B.USER_TYPE = ''A''');
        ELSEIF p_user_type = 'DEALER' THEN
            SET @where_clause = CONCAT(@where_clause, ' AND B.USER_TYPE = ''C''');
        END IF;
    END IF;

    -- 날짜 범위 조건
    IF (p_acc_time_bgn IS NOT NULL AND p_acc_time_bgn != '') OR (p_acc_time_end IS NOT NULL AND p_acc_time_end != '') THEN
        SET @where_clause = CONCAT(@where_clause,
            ' AND DATE_FORMAT(A.ACC_TIME,''%Y-%m-%d'') BETWEEN FN_CONV_DATE(''',
            IFNULL(p_acc_time_bgn, ''), ''') AND FN_CONV_DATE(''', IFNULL(p_acc_time_end, ''), ''')');
    ELSE
        SET @where_clause = CONCAT(@where_clause,
            ' AND DATE_FORMAT(A.ACC_TIME,''%Y-%m-%d'') BETWEEN DATE_FORMAT(NOW(),''%Y-%m-%d'') AND DATE_FORMAT(NOW(),''%Y-%m-%d'')');
    END IF;

    -- SQL 구성
    SET @sql = CONCAT('
        SELECT COUNT(1) AS cnt
          FROM SYS_ULOG A
          INNER JOIN sys_user B ON A.SYS_ID = B.SYS_ID AND A.USER_ID = B.USER_ID
         WHERE ', @where_clause);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- 3. sp_userloglist_delete : 사용자 로그 삭제
-- AS-IS: delete
-- ============================================================
DROP PROCEDURE IF EXISTS sp_userloglist_delete//
CREATE PROCEDURE sp_userloglist_delete(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(100),
    IN p_prog_id VARCHAR(50)
)
BEGIN
    DELETE FROM SYS_ULOG
     WHERE SYS_ID = p_sys_id
       AND USER_ID = p_user_id
       AND PROG_ID = p_prog_id;

END//

-- ============================================================
-- 4. sp_userloglist_get_user_type1 : 사용자 타입 조회
-- AS-IS: getUserType1
-- ============================================================
DROP PROCEDURE IF EXISTS sp_userloglist_get_user_type1//
CREATE PROCEDURE sp_userloglist_get_user_type1(
    IN p_sys_id VARCHAR(20)
)
BEGIN
    SELECT CODE_NAME AS CODE_NAME
      FROM SYS_CODE
     WHERE SYS_ID = p_sys_id
       AND CODE_GRUP = 'USER_TYPE'
       AND CODE_CD IN ('A','C');
END//

DELIMITER ;

-- ============================================================
-- NOTE: sp_insert_sys_ulog 프로시저는 이미 존재하므로 생성하지 않음
-- 기존 insert 문에서 이미 CALL sp_insert_sys_ulog(...) 사용 중
-- ============================================================
