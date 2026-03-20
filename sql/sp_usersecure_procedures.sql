-- ============================================================
-- UserSecure.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- 수정일: 2026-01-15 (동적 정렬 지원 추가)
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. 사용자 보안 목록 조회 (페이징) - 동적 정렬 지원
-- AS-IS: search (SELECT with paging, dynamic sort)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_usersecure_search//

CREATE PROCEDURE sp_usersecure_search(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_secure_key VARCHAR(100),
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
                    A.USER_ID AS userId,
                    A.SECURE_KEY AS secureKey,
                    DATE_FORMAT(A.LOGIN_DATE, '%Y-%m-%d %H:%i:%s') AS accTime,
                    A.REGI_ID AS regiId,
                    DATE_FORMAT(A.REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
                    A.CHNG_ID AS chngId,
                    DATE_FORMAT(A.CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
                FROM SYS_USEC A
                WHERE A.SYS_ID = '", p_sys_id, "'
                  AND (CASE WHEN '", IFNULL(p_user_id,''), "' != '' THEN A.USER_ID = '", IFNULL(p_user_id,''), "' ELSE 1=1 END)
                  AND (CASE WHEN '", IFNULL(p_secure_key,''), "' != '' THEN A.SECURE_KEY = '", IFNULL(p_secure_key,''), "' ELSE 1=1 END)
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
-- 2. 사용자 보안 카운트
-- AS-IS: searchCount (SELECT COUNT)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_usersecure_search_count//

CREATE PROCEDURE sp_usersecure_search_count(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_secure_key VARCHAR(100)
)
BEGIN
    SELECT COUNT(1) AS cnt
    FROM SYS_USEC A
    WHERE SYS_ID = p_sys_id
      AND (p_user_id IS NULL OR p_user_id = '' OR USER_ID = p_user_id)
      AND (p_secure_key IS NULL OR p_secure_key = '' OR SECURE_KEY = p_secure_key);
END//

-- ============================================================
-- 3. 사용자 보안 단건 조회
-- AS-IS: select (유효한 보안키 확인 - 미사용, 1일 이내)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_usersecure_select//

CREATE PROCEDURE sp_usersecure_select(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_secure_key VARCHAR(100)
)
BEGIN
    SELECT
        SYS_ID AS sysId,
        USER_ID AS userId,
        SECURE_KEY AS secureKey,
        DATE_FORMAT(LOGIN_DATE, '%Y-%m-%d %H:%i:%s') AS accTime,
        REGI_ID AS regiId,
        DATE_FORMAT(REGI_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        CHNG_ID AS chngId,
        DATE_FORMAT(CHNG_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate
    FROM SYS_USEC A
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND SECURE_KEY = p_secure_key
      AND LOGIN_DATE IS NULL
      AND REGI_DATE > (NOW() - INTERVAL 1 DAY);
END//

-- ============================================================
-- 4. 사용자 보안 등록
-- AS-IS: insert (보안키 신규 등록)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_usersecure_insert//

CREATE PROCEDURE sp_usersecure_insert(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_secure_key VARCHAR(100),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO SYS_USEC (
        SYS_ID, USER_ID, SECURE_KEY, LOGIN_DATE,
        REGI_ID, REGI_DATE, CHNG_ID, CHNG_DATE
    ) VALUES (
        p_sys_id, p_user_id, p_secure_key, NULL,
        p_gs_user_id, NOW(), p_gs_user_id, NOW()
    );
END//

-- ============================================================
-- 5. 사용자 보안 수정
-- AS-IS: update (로그인 일시 갱신)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_usersecure_update//

CREATE PROCEDURE sp_usersecure_update(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_secure_key VARCHAR(100)
)
BEGIN
    UPDATE SYS_USEC
    SET LOGIN_DATE = NOW(),
        CHNG_DATE = NOW(),
        CHNG_ID = p_user_id
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND SECURE_KEY = p_secure_key;
END//

-- ============================================================
-- 6. 사용자 보안 삭제
-- AS-IS: delete (보안키 삭제)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_usersecure_delete//

CREATE PROCEDURE sp_usersecure_delete(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_secure_key VARCHAR(100)
)
BEGIN
    DELETE FROM SYS_USEC
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND SECURE_KEY = p_secure_key;
END//

DELIMITER ;
