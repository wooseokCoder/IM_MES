-- ============================================================
-- IF_SAP_ACTUAL SAP 실적 조회 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: IF_SAP_ACTUAL
-- 원본: ProActive IF_SAP_ACTUAL.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (3개):
--   1. sp_imes_if_sap_actual_query1 - WO_NO 기준 SAP 실적 조회
--   2. sp_imes_if_sap_actual_query2 - 기간/공장 기준 SAP 실적 조회
--   3. sp_imes_if_sap_actual_query3 - SAP_WO_NO 기준 SAP 실적 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_if_sap_actual_query1: WO_NO 기준 SAP 실적 조회
-- 원본: IF_SAP_ACTUAL.IF_SAP_ACTUAL_QUERY1()
-- 용도: POP30B 작업오더번호 기준 SAP 실적 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_if_sap_actual_query1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_if_sap_actual_query1(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_wo_no     VARCHAR(20)      /* 작업오더번호 */
)
BEGIN
    SELECT
        PLT_CODE       AS "pltCode"
       ,WO_NO           AS "woNo"
       ,WORK_DATE       AS "workDate"
       ,SAP_WORK_TIME   AS "sapWorkTime"
    FROM IF_SAP_ACTUAL
    WHERE PLT_CODE = p_plt_code
      AND WO_NO    = p_wo_no;
END//


-- ============================================================
-- 2. sp_imes_if_sap_actual_query2: 기간/공장 기준 SAP 실적 조회
-- 원본: IF_SAP_ACTUAL.IF_SAP_ACTUAL_QUERY2()
-- 용도: POP30B 기간/공장별 SAP 실적 조회 (작업오더 JOIN)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_if_sap_actual_query2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_if_sap_actual_query2(
    IN p_plt_code    VARCHAR(10),     /* 공장코드 */
    IN p_s_work_date VARCHAR(8),      /* 작업일 시작 */
    IN p_e_work_date VARCHAR(8),      /* 작업일 종료 */
    IN p_plants      VARCHAR(200)     /* 공장 (콤마구분) */
)
BEGIN
    SELECT
        A.PLT_CODE       AS "pltCode"
       ,A.WO_NO           AS "woNo"
       ,A.WORK_DATE       AS "workDate"
       ,A.SAP_WORK_TIME   AS "sapWorkTime"
       ,W.PART_CODE       AS "partCode"
       ,W.PROC_CODE       AS "procCode"
       ,W.MC_CODE         AS "mcCode"
    FROM IF_SAP_ACTUAL A
    LEFT JOIN TSHP_WORKORDER W ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
    WHERE A.PLT_CODE = p_plt_code
      AND (p_s_work_date IS NULL OR p_s_work_date = '' OR A.WORK_DATE >= p_s_work_date)
      AND (p_e_work_date IS NULL OR p_e_work_date = '' OR A.WORK_DATE <= p_e_work_date)
      AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(W.PLANTS, p_plants));
END//


-- ============================================================
-- 3. sp_imes_if_sap_actual_query3: SAP_WO_NO 기준 SAP 실적 조회
-- 원본: IF_SAP_ACTUAL.IF_SAP_ACTUAL_QUERY3()
-- 용도: POP30B SAP 작업오더번호 기준 실적 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_if_sap_actual_query3//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_if_sap_actual_query3(
    IN p_plt_code    VARCHAR(10),     /* 공장코드 */
    IN p_sap_wo_no   VARCHAR(20)      /* SAP 작업오더번호 */
)
BEGIN
    SELECT
        PLT_CODE       AS "pltCode"
       ,WO_NO           AS "woNo"
       ,WORK_DATE       AS "workDate"
       ,SAP_WORK_TIME   AS "sapWorkTime"
    FROM IF_SAP_ACTUAL
    WHERE PLT_CODE  = p_plt_code
      AND SAP_WO_NO = p_sap_wo_no;
END//


DELIMITER ;
