-- ============================================================================
-- TORD_EMAIL_GROUP_EMP CRUD 프로시저 (4개)
-- 이메일 수신자그룹 사원: SER, INS, UPD, UDE
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-10
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tord_email_group_emp_ser
-- 단건 조회 (PK: PLT_CODE + MCODE + EMP_CODE)
-- 용도: UPSERT 분기용 존재 여부 확인
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_emp_ser//

CREATE PROCEDURE sp_imes_tord_email_group_emp_ser(
    IN p_plt_code  VARCHAR(3),
    IN p_mcode     VARCHAR(20),
    IN p_emp_code  VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE        AS pltCode,
        MCODE           AS mcode,
        EMP_CODE        AS empCode,
        EMP_NAME        AS empName,
        EMAIL           AS email,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')  AS regDate,
        REG_EMP         AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP        AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s')  AS delDate,
        DEL_EMP         AS delEmp,
        DEL_REASON      AS delReason,
        DATA_FLAG       AS dataFlag
    FROM TORD_EMAIL_GROUP_EMP
    WHERE PLT_CODE = p_plt_code
      AND MCODE    = p_mcode
      AND EMP_CODE = p_emp_code;
END//


-- ============================================================================
-- sp_imes_tord_email_group_emp_ins
-- 그룹별 사원 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_emp_ins//

CREATE PROCEDURE sp_imes_tord_email_group_emp_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_mcode      VARCHAR(20),
    IN p_emp_code   VARCHAR(50),
    IN p_emp_name   VARCHAR(100),
    IN p_email      VARCHAR(250),
    IN p_data_flag  TINYINT,
    IN p_user_id    VARCHAR(10)
)
BEGIN
    INSERT INTO TORD_EMAIL_GROUP_EMP (
        PLT_CODE,
        MCODE,
        EMP_CODE,
        EMP_NAME,
        EMAIL,
        REG_DATE,
        REG_EMP,
        DATA_FLAG
    ) VALUES (
        p_plt_code,
        p_mcode,
        p_emp_code,
        p_emp_name,
        p_email,
        NOW(),
        p_user_id,
        IFNULL(p_data_flag, 0)
    );
END//


-- ============================================================================
-- sp_imes_tord_email_group_emp_upd
-- 그룹별 사원 수정 (EMP_NAME, EMAIL 수정, DATA_FLAG=0 복원)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_emp_upd//

CREATE PROCEDURE sp_imes_tord_email_group_emp_upd(
    IN p_plt_code   VARCHAR(3),
    IN p_mcode      VARCHAR(20),
    IN p_emp_code   VARCHAR(50),
    IN p_emp_name   VARCHAR(100),
    IN p_email      VARCHAR(250),
    IN p_data_flag  TINYINT,
    IN p_user_id    VARCHAR(10)
)
BEGIN
    UPDATE TORD_EMAIL_GROUP_EMP
    SET EMP_NAME  = p_emp_name,
        EMAIL     = p_email,
        MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id,
        DATA_FLAG = IFNULL(p_data_flag, 0)
    WHERE PLT_CODE = p_plt_code
      AND MCODE    = p_mcode
      AND EMP_CODE = p_emp_code;
END//


-- ============================================================================
-- sp_imes_tord_email_group_emp_ude
-- 그룹별 사원 논리삭제 (DATA_FLAG = 2)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tord_email_group_emp_ude//

CREATE PROCEDURE sp_imes_tord_email_group_emp_ude(
    IN p_plt_code  VARCHAR(3),
    IN p_mcode     VARCHAR(20),
    IN p_emp_code  VARCHAR(50),
    IN p_user_id   VARCHAR(10)
)
BEGIN
    UPDATE TORD_EMAIL_GROUP_EMP
    SET DATA_FLAG = 2,
        DEL_DATE  = NOW(),
        DEL_EMP   = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND MCODE    = p_mcode
      AND EMP_CODE = p_emp_code;
END//

DELIMITER ;
