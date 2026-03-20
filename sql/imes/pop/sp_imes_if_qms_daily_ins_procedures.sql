-- ============================================================
-- IF_QMS_DAILY_INS QMS 일상검사 연동 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: IF_QMS_DAILY_INS
-- 원본: ProActive IF_QMS_DAILY_INS.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (1개):
--   1. sp_imes_if_qms_daily_ins_ins - QMS 일상검사 등록
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_if_qms_daily_ins_ins: QMS 일상검사 등록
-- 원본: IF_QMS_DAILY_INS.IF_QMS_DAILY_INS_INS()
-- 용도: POP30B 검사 완료 시 QMS 인터페이스 테이블에 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_if_qms_daily_ins_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_if_qms_daily_ins_ins(
    IN p_plt_code      VARCHAR(10),     /* 공장코드 */
    IN p_insm_no       VARCHAR(30),     /* 검사마스터번호 */
    IN p_wo_no         VARCHAR(20),     /* 작업오더번호 */
    IN p_sap_wo_no     VARCHAR(20),     /* SAP 작업오더번호 */
    IN p_ins_grp_code  VARCHAR(20),     /* 검사그룹코드 */
    IN p_emp_code      VARCHAR(20),     /* 작업자코드 */
    IN p_qms_state     VARCHAR(5),      /* QMS 상태 */
    IN p_user_id       VARCHAR(50)      /* 등록자 */
)
BEGIN
    INSERT INTO IF_QMS_DAILY_INS (
        PLT_CODE, INSM_NO, WO_NO, SAP_WO_NO, INS_GRP_CODE, EMP_CODE,
        QMS_STATE, REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_insm_no, p_wo_no, p_sap_wo_no, p_ins_grp_code, p_emp_code,
        p_qms_state, NOW(), p_user_id, 0
    );
END//


DELIMITER ;
