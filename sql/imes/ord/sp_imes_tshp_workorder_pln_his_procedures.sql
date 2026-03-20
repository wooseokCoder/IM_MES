-- ============================================================
-- TSHP_WORKORDER_PLN_HIS 프로시저
-- 생성일: 2026-02-24
-- 대상 테이블: TSHP_WORKORDER_PLN_HIS
-- 원본: ProActive TSHP_WORKORDER_PLN_HIS.cs
-- ============================================================
-- 명명 규칙: sp_imes_tshp_workorder_pln_his_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_workorder_pln_his_ins: 계획시간 변경 이력 등록
-- 원본: TSHP_WORKORDER_PLN_HIS.TSHP_WORKORDER_PLN_HIS_INS()
-- 용도: 확정 또는 계획저장 시 기존 PLN 시간 변경분 이력 기록
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_pln_his_ins//

CREATE PROCEDURE sp_imes_tshp_workorder_pln_his_ins(
    IN p_plt_code          VARCHAR(3),
    IN p_wph_id            VARCHAR(20),
    IN p_wo_no             VARCHAR(50),
    IN p_bf_pln_start_time VARCHAR(12),
    IN p_bf_pln_end_time   VARCHAR(12),
    IN p_pln_start_time    VARCHAR(12),
    IN p_pln_end_time      VARCHAR(12),
    IN p_reg_emp           VARCHAR(20)
)
BEGIN
    INSERT INTO TSHP_WORKORDER_PLN_HIS (
        PLT_CODE, WPH_ID, WO_NO,
        BF_PLN_START_TIME, BF_PLN_END_TIME,
        PLN_START_TIME, PLN_END_TIME,
        REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_wph_id, p_wo_no,
        p_bf_pln_start_time, p_bf_pln_end_time,
        p_pln_start_time, p_pln_end_time,
        NOW(), p_reg_emp
    );
END//

-- ============================================================
-- sp_imes_tshp_workorder_pln_his_del: 계획시간 이력 삭제
-- 원본: TSHP_WORKORDER_PLN_HIS.TSHP_WORKORDER_PLN_HIS_DEL()
-- 용도: 확정취소 시 해당 WO의 계획이력 전체 삭제
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_pln_his_del//

CREATE PROCEDURE sp_imes_tshp_workorder_pln_his_del(
    IN p_plt_code  VARCHAR(3),
    IN p_wo_no     VARCHAR(50)
)
BEGIN
    DELETE FROM TSHP_WORKORDER_PLN_HIS
    WHERE PLT_CODE = p_plt_code
      AND WO_NO    = p_wo_no;
END//

DELIMITER ;
