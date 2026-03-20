-- =============================================================================
-- EmailInsert 프로시저 스크립트
-- 원본 파일: /src/main/resources/mappers/com/wsc/common/user/EmailInsert.xml
-- 생성일: 2026-01-15
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. sp_emailinsert_update
-- 설명: 사용자의 SMTP 이메일 정보 업데이트
-- 원본 쿼리 ID: EmailInsert
-- -----------------------------------------------------------------------------
-- AS-IS:
-- UPDATE SYS_USER
--    SET SMTP_MAIL = #{SMTP_MAIL}
--       ,SMTP_PW = #{SMTP_PW}
--  WHERE SYS_ID   = #{sysId}
--    AND USER_ID  = #{gsUserId}
-- -----------------------------------------------------------------------------

DELIMITER //

DROP PROCEDURE IF EXISTS sp_emailinsert_update //

CREATE PROCEDURE sp_emailinsert_update(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50),
    IN p_smtp_mail VARCHAR(200),
    IN p_smtp_pw VARCHAR(200)
)
BEGIN
    UPDATE SYS_USER
       SET SMTP_MAIL = p_smtp_mail
          ,SMTP_PW = p_smtp_pw
     WHERE SYS_ID = p_sys_id
       AND USER_ID = p_user_id;
END //

DELIMITER ;


-- -----------------------------------------------------------------------------
-- 2. sp_emailinsert_get_smtp_mail
-- 설명: 사용자의 SMTP 메일 주소 조회 (도메인 제외)
-- 원본 쿼리 ID: gsSmtpMail
-- -----------------------------------------------------------------------------
-- AS-IS:
-- SELECT replace(SMTP_MAIL,'@lstractorusa.com','')as SMTP_MAIL
-- FROM   SYS_USER
-- WHERE  USER_ID  = #{gsUserId}
-- AND SYS_ID      = #{sysId}
-- -----------------------------------------------------------------------------

DELIMITER //

DROP PROCEDURE IF EXISTS sp_emailinsert_get_smtp_mail //

CREATE PROCEDURE sp_emailinsert_get_smtp_mail(
    IN p_sys_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    SELECT REPLACE(SMTP_MAIL, '@lstractorusa.com', '') AS SMTP_MAIL
      FROM SYS_USER
     WHERE SYS_ID = p_sys_id
       AND USER_ID = p_user_id;
END //

DELIMITER ;
