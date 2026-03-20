-- ============================================================
-- TSHP_ACTUAL_DEL CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-05
-- 대상 테이블: TSHP_ACTUAL_DEL (삭제 실적 백업)
-- 원본: ProActive TSHP_ACTUAL_DEL.cs
-- 화면: POP33A (공수오류현황)
-- ============================================================
-- 포함 프로시저 (3개):
--   1. sp_imes_tshp_actual_del_ser  - 삭제 실적 단건 조회
--   2. sp_imes_tshp_actual_del_ins  - 삭제 실적 등록
--   3. sp_imes_tshp_actual_del_del  - 삭제 실적 삭제 (물리)
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_actual_del_ser: 삭제 실적 단건 조회
-- 원본: TSHP_ACTUAL_DEL.TSHP_ACTUAL_DEL_SER()
-- 용도: POP33A 삭제 실적 복원 전 백업용 데이터 조회
-- 컬럼: 44개 (TSHP_ACTUAL_DEL 전체 컬럼)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_del_ser//

CREATE PROCEDURE sp_imes_tshp_actual_del_ser(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_actual_id VARCHAR(30)     /* 실적ID (PK) */
)
BEGIN
    SELECT
        PLT_CODE                AS "pltCode"
       ,ACTUAL_ID               AS "actualId"
       ,WORK_DATE               AS "workDate"
       ,WO_NO                   AS "woNo"
       ,EMP_CODE                AS "empCode"
       ,MC_CODE                 AS "mcCode"
       ,IS_PRE_WORK             AS "isPreWork"
       ,PROC_STAT               AS "procStat"
       ,PANEL_STAT              AS "panelStat"
       ,DATE_FORMAT(ACT_START_TIME, '%Y-%m-%d %H:%i:%s')    AS "actStartTime"
       ,DATE_FORMAT(ACT_END_TIME, '%Y-%m-%d %H:%i:%s')     AS "actEndTime"
       ,MC_NM_CHECK             AS "mcNmCheck"
       ,SELF_TIME               AS "selfTime"
       ,DATE_FORMAT(SELF_START_TIME, '%Y-%m-%d %H:%i:%s')   AS "selfStartTime"
       ,DATE_FORMAT(SELF_END_TIME, '%Y-%m-%d %H:%i:%s')    AS "selfEndTime"
       ,MAN_TIME                AS "manTime"
       ,DATE_FORMAT(MAN_START_TIME, '%Y-%m-%d %H:%i:%s')    AS "manStartTime"
       ,DATE_FORMAT(MAN_END_TIME, '%Y-%m-%d %H:%i:%s')     AS "manEndTime"
       ,OT_TIME                 AS "otTime"
       ,PRE_TIME                AS "preTime"
       ,DATE_FORMAT(PRE_START_TIME, '%Y-%m-%d %H:%i:%s')    AS "preStartTime"
       ,DATE_FORMAT(PRE_END_TIME, '%Y-%m-%d %H:%i:%s')     AS "preEndTime"
       ,PAUSE_TIME              AS "pauseTime"
       ,DATE_FORMAT(PAUSE_START_TIME, '%Y-%m-%d %H:%i:%s')  AS "pauseStartTime"
       ,DATE_FORMAT(PAUSE_END_TIME, '%Y-%m-%d %H:%i:%s')   AS "pauseEndTime"
       ,MC_TIME                 AS "mcTime"
       ,DATE_FORMAT(MC_START_TIME, '%Y-%m-%d %H:%i:%s')     AS "mcStartTime"
       ,DATE_FORMAT(MC_END_TIME, '%Y-%m-%d %H:%i:%s')      AS "mcEndTime"
       ,MCP_TIME                AS "mcpTime"
       ,DATE_FORMAT(MCP_START_TIME, '%Y-%m-%d %H:%i:%s')    AS "mcpStartTime"
       ,DATE_FORMAT(MCP_END_TIME, '%Y-%m-%d %H:%i:%s')     AS "mcpEndTime"
       ,OK_QTY                  AS "okQty"
       ,NG_QTY                  AS "ngQty"
       ,MULTI_START_CNT         AS "multiStartCnt"
       ,ACT_TL_NO               AS "actTlNo"
       ,STK_ID                  AS "stkId"
       ,INPUT_FLAG              AS "inputFlag"
       ,PAUSE_REASON            AS "pauseReason"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')         AS "regDate"
       ,REG_EMP                 AS "regEmp"
       ,DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s')        AS "mdfyDate"
       ,MDFY_EMP                AS "mdfyEmp"
       ,IF_FLAG                 AS "ifFlag"
       ,IF_SEL_FLAG             AS "ifSelFlag"
       ,IS_AUTO_IDLE_FLAG       AS "isAutoIdleFlag"
    FROM TSHP_ACTUAL_DEL
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


-- ============================================================
-- 2. sp_imes_tshp_actual_del_ins: 삭제 실적 등록
-- 원본: TSHP_ACTUAL_DEL.TSHP_ACTUAL_DEL_INS()
-- 용도: POP33A 실적 삭제 시 TSHP_ACTUAL_DEL에 백업 저장
-- 컬럼: 44개 (TSHP_ACTUAL_DEL 전체 컬럼)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_del_ins//

CREATE PROCEDURE sp_imes_tshp_actual_del_ins(
    IN p_plt_code            VARCHAR(10),
    IN p_actual_id           VARCHAR(30),
    IN p_work_date           VARCHAR(8),
    IN p_wo_no               VARCHAR(20),
    IN p_emp_code            VARCHAR(20),
    IN p_mc_code             VARCHAR(20),
    IN p_is_pre_work         VARCHAR(5),
    IN p_proc_stat           VARCHAR(5),
    IN p_panel_stat          VARCHAR(5),
    IN p_act_start_time      DATETIME,
    IN p_act_end_time        DATETIME,
    IN p_mc_nm_check         VARCHAR(50),
    IN p_self_time           DECIMAL(18,4),
    IN p_self_start_time     DATETIME,
    IN p_self_end_time       DATETIME,
    IN p_man_time            DECIMAL(18,4),
    IN p_man_start_time      DATETIME,
    IN p_man_end_time        DATETIME,
    IN p_ot_time             DECIMAL(18,4),
    IN p_pre_time            DECIMAL(18,4),
    IN p_pre_start_time      DATETIME,
    IN p_pre_end_time        DATETIME,
    IN p_pause_time          DECIMAL(18,4),
    IN p_pause_start_time    DATETIME,
    IN p_pause_end_time      DATETIME,
    IN p_mc_time             DECIMAL(18,4),
    IN p_mc_start_time       DATETIME,
    IN p_mc_end_time         DATETIME,
    IN p_mcp_time            DECIMAL(18,4),
    IN p_mcp_start_time      DATETIME,
    IN p_mcp_end_time        DATETIME,
    IN p_ok_qty              DECIMAL(18,4),
    IN p_ng_qty              DECIMAL(18,4),
    IN p_multi_start_cnt     INT,
    IN p_act_tl_no           VARCHAR(20),
    IN p_stk_id              VARCHAR(30),
    IN p_input_flag          VARCHAR(5),
    IN p_pause_reason        VARCHAR(200),
    IN p_reg_date            DATETIME,
    IN p_reg_emp             VARCHAR(50),
    IN p_mdfy_date           DATETIME,
    IN p_mdfy_emp            VARCHAR(50),
    IN p_if_flag             VARCHAR(5),
    IN p_if_sel_flag         VARCHAR(5),
    IN p_is_auto_idle_flag   VARCHAR(5)
)
BEGIN
    INSERT INTO TSHP_ACTUAL_DEL (
        PLT_CODE, ACTUAL_ID, WORK_DATE, WO_NO, EMP_CODE, MC_CODE, IS_PRE_WORK,
        PROC_STAT, PANEL_STAT, ACT_START_TIME, ACT_END_TIME, MC_NM_CHECK,
        SELF_TIME, SELF_START_TIME, SELF_END_TIME,
        MAN_TIME, MAN_START_TIME, MAN_END_TIME,
        OT_TIME, PRE_TIME, PRE_START_TIME, PRE_END_TIME,
        PAUSE_TIME, PAUSE_START_TIME, PAUSE_END_TIME,
        MC_TIME, MC_START_TIME, MC_END_TIME,
        MCP_TIME, MCP_START_TIME, MCP_END_TIME,
        OK_QTY, NG_QTY, MULTI_START_CNT, ACT_TL_NO, STK_ID,
        INPUT_FLAG, PAUSE_REASON,
        REG_DATE, REG_EMP, MDFY_DATE, MDFY_EMP,
        IF_FLAG, IF_SEL_FLAG, IS_AUTO_IDLE_FLAG
    ) VALUES (
        p_plt_code, p_actual_id, p_work_date, p_wo_no, p_emp_code, p_mc_code, p_is_pre_work,
        p_proc_stat, p_panel_stat, p_act_start_time, p_act_end_time, p_mc_nm_check,
        p_self_time, p_self_start_time, p_self_end_time,
        p_man_time, p_man_start_time, p_man_end_time,
        p_ot_time, p_pre_time, p_pre_start_time, p_pre_end_time,
        p_pause_time, p_pause_start_time, p_pause_end_time,
        p_mc_time, p_mc_start_time, p_mc_end_time,
        p_mcp_time, p_mcp_start_time, p_mcp_end_time,
        p_ok_qty, p_ng_qty, p_multi_start_cnt, p_act_tl_no, p_stk_id,
        p_input_flag, p_pause_reason,
        p_reg_date, p_reg_emp, p_mdfy_date, p_mdfy_emp,
        p_if_flag, p_if_sel_flag, p_is_auto_idle_flag
    );
END//


-- ============================================================
-- 3. sp_imes_tshp_actual_del_del: 삭제 실적 물리 삭제
-- 원본: TSHP_ACTUAL_DEL.TSHP_ACTUAL_DEL_DEL()
-- 용도: POP33A 삭제 실적 복원 후 TSHP_ACTUAL_DEL에서 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_del_del//

CREATE PROCEDURE sp_imes_tshp_actual_del_del(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_actual_id VARCHAR(30)     /* 실적ID (PK) */
)
BEGIN
    DELETE FROM TSHP_ACTUAL_DEL
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


DELIMITER ;
