-- ============================================================
-- TSHP_IDLE_TIMER CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-19
-- 대상 테이블: TSHP_IDLE_TIMER (비가동 타이머)
-- 원본: ProActive TSHP_IDLE_TIMER.cs - INS
-- 용도: WorkIdle "분 후 시작" 선택 시 타이머 레코드 등록
-- ============================================================
-- 명명 규칙: sp_imes_tshp_idle_timer_[액션]
-- ============================================================
-- 포함: INS(등록)
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_idle_timer_ins: 비가동 타이머 등록
-- 원본: TSHP_IDLE_TIMER.TSHP_IDLE_TIMER_INS()
-- 호출처: POP30A_INS2 (비가동 시작, IDLE_MINUTE 있을 때)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idle_timer_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idle_timer_ins(
    IN p_plt_code          VARCHAR(10),
    IN p_idt_id            VARCHAR(20),
    IN p_mc_code           VARCHAR(20),
    IN p_emp_code          VARCHAR(20),
    IN p_idle_code         VARCHAR(20),
    IN p_wo_no             VARCHAR(20),
    IN p_start_time        DATETIME,
    IN p_timer_update_time DATETIME,
    IN p_idle_minute       INT,
    IN p_remain_minute     INT,
    IN p_ing_minute        INT,
    IN p_scomment          VARCHAR(500),
    IN p_data_flag         TINYINT,
    IN p_user_id           VARCHAR(50)
)
BEGIN
    INSERT INTO TSHP_IDLE_TIMER (
        PLT_CODE, IDT_ID, MC_CODE, EMP_CODE, IDLE_CODE,
        WO_NO, START_TIME, TIMER_UPDATE_TIME,
        IDLE_MINUTE, REMAIN_MINUTE, ING_MINUTE,
        SCOMMENT, REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_idt_id, p_mc_code, p_emp_code, p_idle_code,
        p_wo_no, p_start_time, p_timer_update_time,
        p_idle_minute, p_remain_minute, p_ing_minute,
        p_scomment, NOW(), p_user_id, p_data_flag
    );
END//

DELIMITER ;
