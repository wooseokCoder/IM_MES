-- ============================================================================
-- TORD_EMAIL_GROUP CRUD 프로시저 (5개)
-- 이메일 수신자그룹 마스터: SER, SER2, INS, UPD, UDE
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-10
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tord_email_group_ser
-- 단건 조회 (PK: PLT_CODE + MCODE)
-- 용도: UPSERT 분기용 존재 여부 확인
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_ser//

CREATE PROCEDURE sp_imes_tord_email_group_ser(
    IN p_plt_code   VARCHAR(3),
    IN p_mcode      VARCHAR(20)
)
BEGIN
    SELECT
        PLT_CODE        AS pltCode,
        MCODE           AS mcode,
        GROUP_NAME      AS groupName,
        USE_FLAG        AS useFlag,
        SCOMMENT        AS scomment,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')  AS regDate,
        REG_EMP         AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP        AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s')  AS delDate,
        DEL_EMP         AS delEmp,
        DEL_REASON      AS delReason,
        DATA_FLAG       AS dataFlag
    FROM TORD_EMAIL_GROUP
    WHERE PLT_CODE = p_plt_code
      AND MCODE    = p_mcode;
END//


-- ============================================================================
-- sp_imes_tord_email_group_ser2
-- 그룹명+타입 기준 조회 (PLT_CODE + GROUP_NAME + GROUP_TYPE)
-- 용도: 엑셀 업로드 시 그룹명으로 MCODE 찾기
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_ser2//

CREATE PROCEDURE sp_imes_tord_email_group_ser2(
    IN p_plt_code    VARCHAR(3),
    IN p_group_name  VARCHAR(50),
    IN p_group_type  VARCHAR(5)
)
BEGIN
    SELECT
        PLT_CODE        AS pltCode,
        MCODE           AS mcode,
        GROUP_NAME      AS groupName,
        USE_FLAG        AS useFlag,
        SCOMMENT        AS scomment,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')  AS regDate,
        REG_EMP         AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP        AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s')  AS delDate,
        DEL_EMP         AS delEmp,
        DEL_REASON      AS delReason,
        DATA_FLAG       AS dataFlag
    FROM TORD_EMAIL_GROUP
    WHERE PLT_CODE   = p_plt_code
      AND GROUP_NAME = p_group_name
      AND GROUP_TYPE = p_group_type;
END//


-- ============================================================================
-- sp_imes_tord_email_group_ins
-- 수신자그룹 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_ins//

CREATE PROCEDURE sp_imes_tord_email_group_ins(
    IN p_plt_code    VARCHAR(3),
    IN p_mcode       VARCHAR(20),
    IN p_group_type  VARCHAR(5),
    IN p_group_name  VARCHAR(50),
    IN p_use_flag    VARCHAR(10),
    IN p_scomment    VARCHAR(100),
    IN p_del_reason  VARCHAR(100),
    IN p_data_flag   TINYINT,
    IN p_user_id     VARCHAR(10)
)
BEGIN
    INSERT INTO TORD_EMAIL_GROUP (
        PLT_CODE,
        MCODE,
        GROUP_TYPE,
        GROUP_NAME,
        USE_FLAG,
        SCOMMENT,
        REG_DATE,
        REG_EMP,
        DEL_REASON,
        DATA_FLAG
    ) VALUES (
        p_plt_code,
        p_mcode,
        p_group_type,
        p_group_name,
        p_use_flag,
        p_scomment,
        NOW(),
        p_user_id,
        p_del_reason,
        IFNULL(p_data_flag, 0)
    );
END//


-- ============================================================================
-- sp_imes_tord_email_group_upd
-- 수신자그룹 수정 (GROUP_NAME, USE_FLAG 수정, DATA_FLAG=0 복원)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_upd//

CREATE PROCEDURE sp_imes_tord_email_group_upd(
    IN p_plt_code    VARCHAR(3),
    IN p_mcode       VARCHAR(20),
    IN p_group_name  VARCHAR(50),
    IN p_use_flag    VARCHAR(10),
    IN p_scomment    VARCHAR(100),
    IN p_data_flag   TINYINT,
    IN p_user_id     VARCHAR(10)
)
BEGIN
    UPDATE TORD_EMAIL_GROUP
    SET GROUP_NAME = p_group_name,
        USE_FLAG   = p_use_flag,
        SCOMMENT   = p_scomment,
        MDFY_DATE  = NOW(),
        MDFY_EMP   = p_user_id,
        DATA_FLAG  = IFNULL(p_data_flag, 0)
    WHERE PLT_CODE = p_plt_code
      AND MCODE    = p_mcode;
END//


-- ============================================================================
-- sp_imes_tord_email_group_ude
-- 수신자그룹 논리삭제 (DATA_FLAG = 2)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_ude//

CREATE PROCEDURE sp_imes_tord_email_group_ude(
    IN p_plt_code  VARCHAR(3),
    IN p_mcode     VARCHAR(20),
    IN p_user_id   VARCHAR(10)
)
BEGIN
    UPDATE TORD_EMAIL_GROUP
    SET DATA_FLAG = 2,
        DEL_DATE  = NOW(),
        DEL_EMP   = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND MCODE    = p_mcode;
END//

DELIMITER ;
