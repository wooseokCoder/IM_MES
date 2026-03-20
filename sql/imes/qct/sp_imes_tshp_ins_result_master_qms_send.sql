-- ============================================================
-- 프로시저명: sp_imes_tshp_ins_result_master_qms_send
-- 화면: QCT08A - 자주검사 현황
-- 설명: QMS 전송 일괄 처리
--       1. TSHP_INS_RESULT_QUERY2 기반 QMS 변환 조회
--       2. IF_QMS_DAILY_INS INSERT
--       3. TSHP_INS_RESULT_MASTER.QMS_STATE 갱신
-- 작성자: 송우석
-- 작성일: 2026-03-17
-- 참고: Phase 3에서 구현 예정
--       현재는 QMS_STATE 갱신만 수행 (IF_QMS_DAILY_INS INSERT는 인프라 협의 후)
-- ============================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_qms_send//

CREATE PROCEDURE sp_imes_tshp_ins_result_master_qms_send(
    IN p_plt_code   VARCHAR(10),
    IN p_insm_no    VARCHAR(30),
    IN p_user_id    VARCHAR(30)
)
BEGIN
    -- QMS_STATE 갱신
    UPDATE TSHP_INS_RESULT_MASTER
    SET QMS_STATE = '1',
        QMS_SEND_DATE = NOW(),
        MDFY_EMP = p_user_id,
        MDFY_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND INSM_NO = p_insm_no;

    -- TODO Phase 3: IF_QMS_DAILY_INS INSERT 구현
    -- TSHP_INS_RESULT_QUERY2 기반 QMS 변환 쿼리 → IF_QMS_DAILY_INS INSERT
    -- 인프라 협의 후 구현 (MySQL → Oracle QMS 연계 방안)

    SELECT ROW_COUNT() AS updCnt;
END//

DELIMITER ;
