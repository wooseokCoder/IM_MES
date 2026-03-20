-- ============================================================================
-- 불량메일 발신자 관리 프로시저 (5개 + TSYS_CONF UPSERT 1개 = 총 6개)
-- TSTD_NG_MAIL_EMP: query1, ser, ins, upd, ude
-- TSYS_CONF: upsert (발신자 설정 저장)
-- ============================================================================
-- 화면: POP56A (불량메일 발신자 관리)
-- AS-IS: ProActive POP56A_M0A.cs
-- MSSQL -> MySQL 변환: GETDATE()->NOW(), ISNULL()->IFNULL()
-- 작성일: 2026-03-07
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_ng_mail_emp_query1
-- 수신자 목록 조회 (DATA_FLAG=0인 활성 사원만)
-- AS-IS: TSTD_NG_MAIL_EMP_QUERY1
-- 파라미터: p_plt_code - 공장코드
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_mail_emp_query1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_mail_emp_query1(
    IN p_plt_code  VARCHAR(10)
)
BEGIN
    SELECT
        PE.PLT_CODE   AS pltCode,
        PE.EMP_CODE   AS empCode,
        E.USER_NAME   AS empName,
        PE.PROD_TYPE  AS prodType
    FROM TSTD_NG_MAIL_EMP PE
    LEFT JOIN SYS_USER E ON PE.PLT_CODE = E.PLT_CODE AND PE.EMP_CODE = E.USER_ID
    WHERE PE.PLT_CODE  = p_plt_code
      AND PE.DATA_FLAG = 0
    ORDER BY PE.PROD_TYPE, PE.EMP_CODE;
END//

-- ============================================================================
-- sp_imes_tstd_ng_mail_emp_ser
-- 존재 확인 (단건 조회)
-- AS-IS: TSTD_NG_MAIL_EMP_SER
-- 파라미터: p_plt_code, p_emp_code, p_prod_type
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_mail_emp_ser//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_mail_emp_ser(
    IN p_plt_code   VARCHAR(10),
    IN p_emp_code   VARCHAR(20),
    IN p_prod_type  VARCHAR(10)
)
BEGIN
    SELECT
        PLT_CODE   AS pltCode,
        EMP_CODE   AS empCode,
        PROD_TYPE  AS prodType,
        REG_DATE   AS regDate,
        REG_EMP    AS regEmp,
        DATA_FLAG  AS dataFlag
    FROM TSTD_NG_MAIL_EMP
    WHERE PLT_CODE = p_plt_code
      AND EMP_CODE = p_emp_code
      AND PROD_TYPE = p_prod_type;
END//

-- ============================================================================
-- sp_imes_tstd_ng_mail_emp_ins
-- 등록 (신규 사원 추가)
-- AS-IS: TSTD_NG_MAIL_EMP_INS
-- 파라미터: p_plt_code, p_emp_code, p_prod_type, p_user_id
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_mail_emp_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_mail_emp_ins(
    IN p_plt_code   VARCHAR(10),
    IN p_emp_code   VARCHAR(20),
    IN p_prod_type  VARCHAR(10),
    IN p_user_id    VARCHAR(20)
)
BEGIN
    INSERT INTO TSTD_NG_MAIL_EMP (
        PLT_CODE, EMP_CODE, PROD_TYPE, REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_emp_code, p_prod_type, NOW(), p_user_id, 0
    );
END//

-- ============================================================================
-- sp_imes_tstd_ng_mail_emp_upd
-- 수정 (재활성화: DATA_FLAG=0으로 복원)
-- AS-IS: TSTD_NG_MAIL_EMP_UPD
-- 파라미터: p_plt_code, p_emp_code, p_prod_type, p_user_id
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_mail_emp_upd//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_mail_emp_upd(
    IN p_plt_code   VARCHAR(10),
    IN p_emp_code   VARCHAR(20),
    IN p_prod_type  VARCHAR(10),
    IN p_user_id    VARCHAR(20)
)
BEGIN
    UPDATE TSTD_NG_MAIL_EMP
    SET MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id,
        DATA_FLAG = 0
    WHERE PLT_CODE  = p_plt_code
      AND EMP_CODE  = p_emp_code
      AND PROD_TYPE = p_prod_type;
END//

-- ============================================================================
-- sp_imes_tstd_ng_mail_emp_ude
-- 삭제 (논리삭제: DATA_FLAG=2)
-- AS-IS: TSTD_NG_MAIL_EMP_UDE
-- 파라미터: p_plt_code, p_emp_code, p_prod_type, p_user_id
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_mail_emp_ude//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_mail_emp_ude(
    IN p_plt_code   VARCHAR(10),
    IN p_emp_code   VARCHAR(20),
    IN p_prod_type  VARCHAR(10),
    IN p_user_id    VARCHAR(20)
)
BEGIN
    UPDATE TSTD_NG_MAIL_EMP
    SET DEL_DATE   = NOW(),
        DEL_EMP    = p_user_id,
        DATA_FLAG  = 2
    WHERE PLT_CODE  = p_plt_code
      AND EMP_CODE  = p_emp_code
      AND PROD_TYPE = p_prod_type;
END//

-- ============================================================================
-- sp_imes_tsys_conf_upsert
-- TSYS_CONF 설정값 UPSERT (INSERT ON DUPLICATE KEY UPDATE)
-- 용도: POP56A 발신자 설정 저장 (NG_MAIL_E, NG_MAIL_P)
-- AS-IS: acInfo.SysConfig.SetSysConfigByServer()
-- 파라미터: p_plt_code, p_conf_section, p_conf_name, p_conf_value, p_user_id
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_conf_upsert//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tsys_conf_upsert(
    IN p_plt_code      VARCHAR(10),
    IN p_conf_section  VARCHAR(50),
    IN p_conf_name     VARCHAR(100),
    IN p_conf_value    VARCHAR(500),
    IN p_user_id       VARCHAR(20)
)
BEGIN
    /* REG_DATE, REG_EMP: NOT NULL 컬럼이므로 INSERT 시 반드시 포함 */
    /* MDFY_DATE, MDFY_EMP: UPDATE 시 수정자/수정일 갱신 */
    INSERT INTO TSYS_CONF (PLT_CODE, CONF_SECTION, CONF_NAME, CONF_VALUE, REG_DATE, REG_EMP)
    VALUES (p_plt_code, p_conf_section, p_conf_name, p_conf_value, NOW(), p_user_id)
    ON DUPLICATE KEY UPDATE
        CONF_VALUE = p_conf_value,
        MDFY_DATE  = NOW(),
        MDFY_EMP   = p_user_id;
END//

-- ============================================================================
-- sp_imes_sys_user_get_name
-- 사원코드로 사원명 조회 (SYS_USER)
-- 용도: POP56A 발신자 설정 화면 오픈 시 EMP_CODE → EMP_NAME 변환
-- 파라미터: p_plt_code - 공장코드, p_emp_code - 사원코드
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_sys_user_get_name//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_sys_user_get_name(
    IN p_plt_code  VARCHAR(10),
    IN p_emp_code  VARCHAR(20)
)
BEGIN
    SELECT USER_NAME AS empName
    FROM SYS_USER
    WHERE PLT_CODE = p_plt_code
      AND USER_ID  = p_emp_code;
END//

DELIMITER ;
