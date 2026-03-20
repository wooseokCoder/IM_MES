-- ============================================================================
-- LSE_MACHINE CRUD 프로시저 (4개)
-- 설비 마스터: SER, INS, UPD, UDE
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- 수정일: 2026-02-23 (STD04A용 INS, UPD, UDE 추가)
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_machine_ser
-- 단건 설비 조회 (PLT_CODE + MC_CODE) — 존재여부 확인, 중복체크용
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_ser//

CREATE PROCEDURE sp_imes_lse_machine_ser(
    IN p_mc_code    VARCHAR(10),
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    SELECT
        PLT_CODE        AS pltCode,
        MC_CODE         AS mcCode,
        MC_NAME         AS mcName,
        MC_GROUP        AS mcGroup,
        CTRL_SYS        AS ctrlSys,
        SPEC_X          AS specX,
        SPEC_Y          AS specY,
        SPEC_Z          AS specZ,
        RPM             AS rpm,
        BUY_DATE        AS buyDate,
        MC_LOCATION     AS mcLocation,
        GRADE           AS grade,
        MC_AUTOMATED    AS mcAutomated,
        MC_OS           AS mcOs,
        MC_SHIFT        AS mcShift,
        MC_MGT_FLAG     AS mcMgtFlag,
        MC_OPEN_DATE    AS mcOpenDate,
        MC_CLOSE_DATE   AS mcCloseDate,
        MC_MODEL        AS mcModel,
        MC_EFFICIENCY   AS mcEfficiency,
        CPROC_CODE      AS cprocCode,
        MC_TYPE         AS mcType,
        MC_SEQ          AS mcSeq,
        MAIN_EMP        AS mainEmp,
        VEN_CODE        AS venCode,
        PLC_IP          AS plcIp,
        MC_MAKER        AS mcMaker,
        ASSET_NO        AS assetNo,
        AS_TEL          AS asTel,
        IS_SIGNAL       AS isSignal,
        IS_OPERATE_STATE AS isOperateState,
        IS_MULTI_START  AS isMultiStart,
        MULTI_START_DIV AS multiStartDiv,
        SCOMMENT        AS scomment,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP         AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP        AS mdfyEmp,
        DATA_FLAG       AS dataFlag,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP         AS delEmp,
        DEL_REASON      AS delReason,
        MC_IP           AS mcIp,
        FTP_PORT        AS ftpPort,
        FTP_USER        AS ftpUser,
        FTP_USER_PW     AS ftpUserPw,
        FTP_DIR         AS ftpDir
    FROM LSE_MACHINE
    WHERE MC_CODE = p_mc_code
      AND PLT_CODE = p_plt_code;
END//

-- ============================================================================
-- sp_imes_lse_machine_ins
-- 설비 신규 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_ins//

CREATE PROCEDURE sp_imes_lse_machine_ins(
    IN p_plt_code       VARCHAR(3),
    IN p_mc_code        VARCHAR(10),
    IN p_mc_name        VARCHAR(50),
    IN p_mc_group       VARCHAR(20),
    IN p_ctrl_sys       VARCHAR(50),
    IN p_spec_x         INT,
    IN p_spec_y         INT,
    IN p_spec_z         INT,
    IN p_rpm            INT,
    IN p_buy_date       VARCHAR(6),
    IN p_mc_location    VARCHAR(10),
    IN p_grade          VARCHAR(10),
    IN p_mc_automated   TINYINT,
    IN p_mc_os          TINYINT,
    IN p_mc_shift       TINYINT,
    IN p_mc_mgt_flag    TINYINT,
    IN p_mc_open_date   VARCHAR(8),
    IN p_mc_close_date  VARCHAR(8),
    IN p_mc_model       VARCHAR(50),
    IN p_cproc_code     VARCHAR(10),
    IN p_mc_seq         INT,
    IN p_main_emp       VARCHAR(10),
    IN p_scomment       VARCHAR(100),
    IN p_ven_code       VARCHAR(10),
    IN p_is_operate_state TINYINT,
    IN p_is_multi_start TINYINT,
    IN p_multi_start_div TINYINT,
    IN p_plc_ip         VARCHAR(15),
    IN p_mc_maker       VARCHAR(50),
    IN p_asset_no       VARCHAR(50),
    IN p_as_tel         VARCHAR(50),
    IN p_mc_flag        VARCHAR(10),
    IN p_is_sap         TINYINT,
    IN p_is_sim_gantt   TINYINT,
    IN p_proc_code      VARCHAR(50),
    IN p_is_pop         TINYINT,
    IN p_user_id        VARCHAR(50)
)
BEGIN
    INSERT INTO LSE_MACHINE (
        PLT_CODE, MC_CODE, MC_NAME, MC_GROUP, CTRL_SYS,
        SPEC_X, SPEC_Y, SPEC_Z, RPM, BUY_DATE,
        MC_LOCATION, GRADE, MC_AUTOMATED, MC_OS, MC_SHIFT,
        MC_MGT_FLAG, MC_OPEN_DATE, MC_CLOSE_DATE, MC_MODEL,
        CPROC_CODE, MC_TYPE, MC_SEQ, MAIN_EMP, SCOMMENT,
        VEN_CODE, IS_OPERATE_STATE, IS_MULTI_START, MULTI_START_DIV,
        PLC_IP, MC_MAKER, ASSET_NO, AS_TEL,
        MC_FLAG, IS_SAP, IS_SIM_GANTT, PROC_CODE, IS_POP,
        REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_mc_code, p_mc_name, p_mc_group, p_ctrl_sys,
        p_spec_x, p_spec_y, p_spec_z, p_rpm, p_buy_date,
        p_mc_location, p_grade, p_mc_automated, p_mc_os, p_mc_shift,
        p_mc_mgt_flag, p_mc_open_date, p_mc_close_date, p_mc_model,
        p_cproc_code, 0, p_mc_seq, p_main_emp, p_scomment,
        p_ven_code, p_is_operate_state, p_is_multi_start, p_multi_start_div,
        p_plc_ip, p_mc_maker, p_asset_no, p_as_tel,
        p_mc_flag, p_is_sap, p_is_sim_gantt, p_proc_code, p_is_pop,
        NOW(), p_user_id, 0
    );
END//

-- ============================================================================
-- sp_imes_lse_machine_upd
-- 설비 수정
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_upd//

CREATE PROCEDURE sp_imes_lse_machine_upd(
    IN p_plt_code       VARCHAR(3),
    IN p_mc_code        VARCHAR(10),
    IN p_mc_name        VARCHAR(50),
    IN p_mc_group       VARCHAR(20),
    IN p_ctrl_sys       VARCHAR(50),
    IN p_spec_x         INT,
    IN p_spec_y         INT,
    IN p_spec_z         INT,
    IN p_rpm            INT,
    IN p_buy_date       VARCHAR(6),
    IN p_mc_location    VARCHAR(10),
    IN p_grade          VARCHAR(10),
    IN p_mc_automated   TINYINT,
    IN p_mc_os          TINYINT,
    IN p_mc_shift       TINYINT,
    IN p_mc_mgt_flag    TINYINT,
    IN p_mc_open_date   VARCHAR(8),
    IN p_mc_close_date  VARCHAR(8),
    IN p_mc_model       VARCHAR(50),
    IN p_cproc_code     VARCHAR(10),
    IN p_mc_seq         INT,
    IN p_main_emp       VARCHAR(10),
    IN p_scomment       VARCHAR(100),
    IN p_ven_code       VARCHAR(10),
    IN p_plc_ip         VARCHAR(15),
    IN p_mc_maker       VARCHAR(50),
    IN p_asset_no       VARCHAR(50),
    IN p_as_tel         VARCHAR(50),
    IN p_is_signal      TINYINT,
    IN p_is_operate_state TINYINT,
    IN p_is_multi_start TINYINT,
    IN p_multi_start_div TINYINT,
    IN p_mc_flag        VARCHAR(10),
    IN p_is_sap         TINYINT,
    IN p_is_sim_gantt   TINYINT,
    IN p_proc_code      VARCHAR(50),
    IN p_is_pop         TINYINT,
    IN p_user_id        VARCHAR(50)
)
BEGIN
    UPDATE LSE_MACHINE SET
        MC_NAME         = p_mc_name,
        MC_GROUP        = p_mc_group,
        CTRL_SYS        = p_ctrl_sys,
        SPEC_X          = p_spec_x,
        SPEC_Y          = p_spec_y,
        SPEC_Z          = p_spec_z,
        RPM             = p_rpm,
        BUY_DATE        = p_buy_date,
        MC_LOCATION     = p_mc_location,
        GRADE           = p_grade,
        MC_AUTOMATED    = p_mc_automated,
        MC_OS           = p_mc_os,
        MC_SHIFT        = p_mc_shift,
        MC_MGT_FLAG     = p_mc_mgt_flag,
        MC_OPEN_DATE    = p_mc_open_date,
        MC_CLOSE_DATE   = p_mc_close_date,
        MC_MODEL        = p_mc_model,
        CPROC_CODE      = p_cproc_code,
        MC_SEQ          = p_mc_seq,
        MAIN_EMP        = p_main_emp,
        SCOMMENT        = p_scomment,
        VEN_CODE        = p_ven_code,
        PLC_IP          = p_plc_ip,
        MC_MAKER        = p_mc_maker,
        ASSET_NO        = p_asset_no,
        AS_TEL          = p_as_tel,
        IS_SIGNAL       = p_is_signal,
        IS_OPERATE_STATE = p_is_operate_state,
        IS_MULTI_START  = p_is_multi_start,
        MULTI_START_DIV = p_multi_start_div,
        MC_FLAG         = p_mc_flag,
        IS_SAP          = p_is_sap,
        IS_SIM_GANTT    = p_is_sim_gantt,
        PROC_CODE       = p_proc_code,
        IS_POP          = p_is_pop,
        MDFY_DATE       = NOW(),
        MDFY_EMP        = p_user_id,
        DATA_FLAG       = 0
    WHERE MC_CODE = p_mc_code
      AND PLT_CODE = p_plt_code;
END//

-- ============================================================================
-- sp_imes_lse_machine_ude
-- 설비 논리삭제 (DATA_FLAG=2)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_ude//

CREATE PROCEDURE sp_imes_lse_machine_ude(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_del_reason VARCHAR(100),
    IN p_user_id    VARCHAR(50)
)
BEGIN
    UPDATE LSE_MACHINE SET
        DATA_FLAG  = 2,
        DEL_DATE   = NOW(),
        DEL_EMP    = p_user_id,
        DEL_REASON = p_del_reason
    WHERE MC_CODE = p_mc_code
      AND PLT_CODE = p_plt_code;
END//

DELIMITER ;
