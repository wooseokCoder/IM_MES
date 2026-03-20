-- ============================================================
-- TSHP_SAP_ACT_SEND_LOG CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-05
-- 대상 테이블: TSHP_SAP_ACT_SEND_LOG (SAP 전송 로그)
-- 원본: ProActive TSHP_SAP_SEND_LOG.cs
-- 화면: POP33A (공수오류현황)
-- ============================================================
-- 포함 프로시저 (4개):
--   1. sp_imes_tshp_sap_act_send_log_ser   - SAP 전송 로그 조회
--   2. sp_imes_tshp_sap_act_send_log_ins   - SAP 전송 로그 등록
--   3. sp_imes_tshp_sap_act_send_log_upd   - SAP 전송 로그 수정
--   4. sp_imes_tshp_sap_act_send_log_save  - SAP 전송 로그 UPSERT
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_sap_act_send_log_ser: SAP 전송 로그 조회
-- 원본: TSHP_SAP_SEND_LOG.TSHP_SAP_ACT_SEND_LOG_SER()
-- 용도: POP33A SAP 전송 이력 확인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_sap_act_send_log_ser//

CREATE PROCEDURE sp_imes_tshp_sap_act_send_log_ser(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_work_date VARCHAR(8)      /* 작업일자 (yyyyMMdd) */
)
BEGIN
    SELECT
        PLT_CODE                AS "pltCode"
       ,EMP_CODE                AS "empCode"
       ,WORK_DATE               AS "workDate"
       ,SEND_FLAG               AS "sendFlag"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')  AS "regDate"
       ,REG_EMP                 AS "regEmp"
       ,DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS "mdfyDate"
       ,MDFY_EMP                AS "mdfyEmp"
    FROM TSHP_SAP_ACT_SEND_LOG
    WHERE PLT_CODE = p_plt_code
      AND EMP_CODE = p_emp_code
      AND WORK_DATE = p_work_date;
END//


-- ============================================================
-- 2. sp_imes_tshp_sap_act_send_log_ins: SAP 전송 로그 등록
-- 원본: TSHP_SAP_SEND_LOG.TSHP_SAP_ACT_SEND_LOG_INS()
-- 용도: POP33A SAP 전송 시 최초 로그 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_sap_act_send_log_ins//

CREATE PROCEDURE sp_imes_tshp_sap_act_send_log_ins(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_send_flag VARCHAR(5),     /* 전송 플래그 */
    IN p_user_id   VARCHAR(50)     /* 등록자 */
)
BEGIN
    INSERT INTO TSHP_SAP_ACT_SEND_LOG (
        PLT_CODE, EMP_CODE, WORK_DATE, SEND_FLAG, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_emp_code, p_work_date, p_send_flag, NOW(), p_user_id
    );
END//


-- ============================================================
-- 3. sp_imes_tshp_sap_act_send_log_upd: SAP 전송 로그 수정
-- 원본: TSHP_SAP_SEND_LOG.TSHP_SAP_ACT_SEND_LOG_UPD()
-- 용도: POP33A SAP 재전송 시 로그 업데이트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_sap_act_send_log_upd//

CREATE PROCEDURE sp_imes_tshp_sap_act_send_log_upd(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_send_flag VARCHAR(5),     /* 전송 플래그 */
    IN p_user_id   VARCHAR(50)     /* 수정자 */
)
BEGIN
    UPDATE TSHP_SAP_ACT_SEND_LOG SET
        SEND_FLAG = p_send_flag,
        MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND EMP_CODE = p_emp_code
      AND WORK_DATE = p_work_date;
END//


-- ============================================================
-- 4. sp_imes_tshp_sap_act_send_log_save: SAP 전송 로그 UPSERT (저장)
-- 용도: POP33A SAP 전송 로그 — 있으면 UPDATE, 없으면 INSERT
-- 호출: pop33aIns2()에서 SER→INS/UPD 3번 호출을 1번으로 통합
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_sap_act_send_log_save//

CREATE PROCEDURE sp_imes_tshp_sap_act_send_log_save(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_send_flag VARCHAR(5),     /* 전송 플래그 */
    IN p_user_id   VARCHAR(50)     /* 등록/수정자 */
)
BEGIN
    INSERT INTO TSHP_SAP_ACT_SEND_LOG (
        PLT_CODE, EMP_CODE, WORK_DATE, SEND_FLAG, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_emp_code, p_work_date, p_send_flag, NOW(), p_user_id
    )
    ON DUPLICATE KEY UPDATE
        SEND_FLAG = p_send_flag,
        MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id;
END//


DELIMITER ;
