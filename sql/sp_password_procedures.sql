-- ============================================================
-- Password.xml 쿼리 -> 프로시저 전환 스크립트
-- 생성일: 2026-01-13
-- 수정일: 2026-01-15
-- 대상 파일: src/main/resources/mappers/com/wsc/common/user/Password.xml
-- ============================================================

DELIMITER //

-- ============================================================
-- 1. sp_password_update_user_pw
--    사용자 비밀번호 업데이트 (관리자용)
--    MyBatis ID: updateUserPw
-- ============================================================
-- AS-IS:
--   UPDATE SYS_USER
--      SET USER_PWD = HEX( AES_ENCRYPT( #{userId},#{newPw}))
--         ,PWD_CHNG_DATE = NOW()
--         ,USE_FLAG = 'Y'
--         ,LOGIN_FAIL_CNT = 0
--    WHERE SYS_ID   = #{sysId}
--      AND USER_ID  = #{userId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_update_user_pw//

CREATE PROCEDURE sp_password_update_user_pw(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_new_pw VARCHAR(100)
)
BEGIN
    UPDATE SYS_USER
    SET USER_PWD = HEX(AES_ENCRYPT(p_user_id, p_new_pw)),
        PWD_CHNG_DATE = NOW(),
        USE_FLAG = 'Y',
        LOGIN_FAIL_CNT = 0
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id;
END//

-- ============================================================
-- 2. sp_password_chk_user_pw
--    사용자 비밀번호 확인
--    MyBatis ID: chkUserPw
-- ============================================================
-- AS-IS:
--   SELECT USER_ID
--     FROM SYS_USER
--    WHERE SYS_ID   = #{sysId}
--      AND USER_ID  = #{gsUserId}
--      AND USER_PWD =  HEX( AES_ENCRYPT( #{gsUserId},#{oldPw}))
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_chk_user_pw//

CREATE PROCEDURE sp_password_chk_user_pw(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_old_pw VARCHAR(100)
)
BEGIN
    SELECT USER_ID
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id
      AND USER_PWD = HEX(AES_ENCRYPT(p_gs_user_id, p_old_pw));
END//

-- ============================================================
-- 3. sp_password_chk_user_pw2
--    사용자 비밀번호 확인2 (함수 포함)
--    MyBatis ID: chkUserPw2
-- ============================================================
-- AS-IS:
--   SELECT USER_ID
--     FROM SYS_USER
--    WHERE SYS_ID   = #{sysId}
--      AND USER_ID  = #{gsUserId}
--      AND (USER_PWD =  HEX( AES_ENCRYPT( #{gsUserId},#{oldPw}))
--          OR fn_chk_user_pwd(#{oldPw}) = 'Y')
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_chk_user_pw2//

CREATE PROCEDURE sp_password_chk_user_pw2(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_old_pw VARCHAR(100)
)
BEGIN
    SELECT USER_ID
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id
      AND (USER_PWD = HEX(AES_ENCRYPT(p_gs_user_id, p_old_pw))
           OR fn_chk_user_pwd(p_old_pw) = 'Y');
END//

-- ============================================================
-- 4. sp_password_update_user_pw_user
--    사용자 본인 비밀번호 업데이트 (사용자용)
--    MyBatis ID: updateUserPw-user
-- ============================================================
-- AS-IS:
--   UPDATE SYS_USER
--      SET USER_PWD = HEX( AES_ENCRYPT( #{gsUserId},#{newPw}))
--         ,PWD_CHNG_DATE = NOW()
--    WHERE SYS_ID   = #{sysId}
--      AND USER_ID  = #{gsUserId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_update_user_pw_user//

CREATE PROCEDURE sp_password_update_user_pw_user(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50),
    IN p_new_pw VARCHAR(100)
)
BEGIN
    UPDATE SYS_USER
    SET USER_PWD = HEX(AES_ENCRYPT(p_gs_user_id, p_new_pw)),
        PWD_CHNG_DATE = NOW()
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id;
END//

-- ============================================================
-- 5. sp_password_email_check
--    이메일 확인 (비밀번호 재설정용 임시 비밀번호 생성)
--    MyBatis ID: emailCheck
-- ============================================================
-- AS-IS:
--   SELECT CONCAT( LPAD(CONV(FLOOR(RAND()*POW(36,8)), 10, 36), 5, 0),
--                  LPAD(CONV(FLOOR(RAND()*POW(36,8)), 10, 36), 5, 0)) AS "newPw"
--     FROM SYS_USER
--    WHERE SYS_ID   = #{sysId}
--      AND USER_ID  = #{userId}
--      AND USER_MAIL = #{email}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_email_check//

CREATE PROCEDURE sp_password_email_check(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_email VARCHAR(100)
)
BEGIN
    SELECT CONCAT(
        LPAD(CONV(FLOOR(RAND()*POW(36,8)), 10, 36), 5, 0),
        LPAD(CONV(FLOOR(RAND()*POW(36,8)), 10, 36), 5, 0)
    ) AS newPw
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_user_id
      AND USER_MAIL = p_email;
END//

-- ============================================================
-- 6. sp_password_chk_user_char
--    사용자 특성 확인 (로그인 ID 검증)
--    MyBatis ID: chkUserChar
-- ============================================================
-- AS-IS:
--   SELECT USER_ID,USE_FLAG AS LockYn,
--          IFNULL(OLD_USER_ID, '') AS oldUserId,
--          USER_TYPE AS userType,
--          ORG_AUTH_CODE AS orgAuthCode
--     FROM SYS_USER
--    WHERE SYS_ID   = #{sysId}
--      AND (LOWER(USER_ID)  = TRIM(LOWER(#{userId}))
--      OR  LOWER(OLD_USER_ID)  = TRIM(LOWER(#{userId})))
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_chk_user_char//

CREATE PROCEDURE sp_password_chk_user_char(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT USER_ID,
           USE_FLAG AS LockYn,
           IFNULL(OLD_USER_ID, '') AS oldUserId,
           USER_TYPE AS userType,
           ORG_AUTH_CODE AS orgAuthCode
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND (LOWER(USER_ID) = TRIM(LOWER(p_user_id))
           OR LOWER(OLD_USER_ID) = TRIM(LOWER(p_user_id)));
END//

-- ============================================================
-- 7. sp_password_update_login_ng
--    로그인 실패 처리 (실패 카운트 증가 및 계정 잠금)
--    MyBatis ID: updateLoginNG
-- ============================================================
-- AS-IS:
--   UPDATE SYS_USER
--      SET LOGIN_FAIL_CNT = LOGIN_FAIL_CNT + 1
--         ,LAST_LOGIN_DATE = DATE_FORMAT( Now(),'%Y-%m-%d %H:%i:%s')
--         ,USE_FLAG = CASE WHEN LOGIN_FAIL_CNT * 1 >= fn_get_code_desc( 'SYS_VAR', 'LOGIN_FAIL_CNT') * 1 THEN 'N' ELSE USE_FLAG END
--    WHERE SYS_ID         = #{sysId}
--      AND USER_ID        = #{gsUserId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_update_login_ng//

CREATE PROCEDURE sp_password_update_login_ng(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET LOGIN_FAIL_CNT = LOGIN_FAIL_CNT + 1,
        LAST_LOGIN_DATE = DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'),
        USE_FLAG = CASE
            WHEN LOGIN_FAIL_CNT * 1 >= fn_get_code_desc('SYS_VAR', 'LOGIN_FAIL_CNT') * 1
            THEN 'N'
            ELSE USE_FLAG
        END
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id;
END//

-- ============================================================
-- 8. sp_password_update_login_ok
--    로그인 성공 처리 (실패 카운트 리셋 및 최종 로그인 일시 업데이트)
--    MyBatis ID: updateLoginOK
-- ============================================================
-- AS-IS:
--   UPDATE SYS_USER
--      SET LOGIN_FAIL_CNT  = 0
--         ,LAST_LOGIN_DATE = DATE_FORMAT( Now(),'%Y-%m-%d %H:%i:%s')
--    WHERE SYS_ID          = #{sysId}
--      AND USER_ID         = #{gsUserId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_update_login_ok//

CREATE PROCEDURE sp_password_update_login_ok(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE SYS_USER
    SET LOGIN_FAIL_CNT = 0,
        LAST_LOGIN_DATE = DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id;
END//

-- ============================================================
-- 9. sp_password_check_login_sts
--    로그인 상태 확인 (계정 잠금 여부)
--    MyBatis ID: checkLoginSts
-- ============================================================
-- AS-IS:
--   SELECT USE_FLAG  AS LockYn
--     FROM SYS_USER
--    WHERE SYS_ID = #{sysId}
--      AND USER_ID = #{gsUserId}
-- ============================================================
DROP PROCEDURE IF EXISTS sp_password_check_login_sts//

CREATE PROCEDURE sp_password_check_login_sts(
    IN p_sys_id VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    SELECT USE_FLAG AS LockYn
    FROM SYS_USER
    WHERE SYS_ID = p_sys_id
      AND USER_ID = p_gs_user_id;
END//

DELIMITER ;

-- ============================================================
-- 변환 요약
-- ============================================================
-- | MyBatis ID          | 프로시저명                        | 유형   |
-- |---------------------|-----------------------------------|--------|
-- | updateUserPw        | sp_password_update_user_pw        | UPDATE |
-- | chkUserPw           | sp_password_chk_user_pw           | SELECT |
-- | chkUserPw2          | sp_password_chk_user_pw2          | SELECT |
-- | updateUserPw-user   | sp_password_update_user_pw_user   | UPDATE |
-- | emailCheck          | sp_password_email_check           | SELECT |
-- | chkUserChar         | sp_password_chk_user_char         | SELECT |
-- | updateLoginNG       | sp_password_update_login_ng       | UPDATE |
-- | updateLoginOK       | sp_password_update_login_ok       | UPDATE |
-- | checkLoginSts       | sp_password_check_login_sts       | SELECT |
-- | RejectCheck         | sp_update_gate_pass_reject        | UPDATE | (기존 유지)
-- ============================================================
