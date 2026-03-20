-- ============================================================
-- TSHP_INS_RESULT 조회 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 수정일: 2026-03-20 (INS_RESULT_IMG, INS_IMG → TO_BASE64 변환 추가)
-- 대상 테이블: TSHP_INS_RESULT_MASTER (주), TSHP_INS_RESULT, LSE_STD_PROC, TSTD_PROC_INS
-- 원본: ProActive TSHP_INS_RESULT_QUERY.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (3개):
--   1. sp_imes_tshp_ins_result_query1   - 검사결과 조회 (마스터+상세 JOIN)
--   2. sp_imes_tshp_ins_result_query2   - 예약 (stub)
--   3. sp_imes_tshp_ins_result_query3   - 예약 (stub)
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_ins_result_query1: 검사결과 조회
-- 원본: TSHP_INS_RESULT_QUERY.QUERY1()
-- 용도: POP30B 검사결과 마스터+상세 JOIN 조회
-- JOIN: TSHP_INS_RESULT_MASTER ↔ TSHP_INS_RESULT ↔ LSE_STD_PROC ↔ TSTD_PROC_INS
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_query1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_query1(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_insm_no   VARCHAR(30),     /* 검사마스터번호 */
    IN p_data_flag INT              /* 데이터 플래그 */
)
BEGIN
    SELECT
        IRM.PLT_CODE                AS "pltCode"
       ,IRM.INSM_NO                 AS "insmNo"
       ,IR.INS_NO                   AS "insNo"
       ,IRM.WO_NO                   AS "woNo"
       ,IR.PROC_CODE                AS "procCode"
       ,IR.PROD_TYPE                AS "prodType"
       ,PR.PROC_NAME                AS "procName"
       ,IR.INS_NAME                 AS "insName"
       ,IR.INS_DESC                 AS "insDesc"
       ,IR.INS_TYPE                 AS "insType"
       ,IR.INS_UNIT                 AS "insUnit"
       ,IR.AVG_VAL                  AS "avgVal"
       ,IR.MIN_VAL                  AS "minVal"
       ,IR.MAX_VAL                  AS "maxVal"
       ,IR.INS_RESULT               AS "insResult"
       ,IR.SCOMMENT                 AS "scomment"
       ,IR.INS_SEQ                  AS "insSeq"
       ,IR.INS_GRP_CODE             AS "insGrpCode"
       ,IR.INS_CODE                 AS "insCode"
       ,TO_BASE64(IR.INS_RESULT_IMG) AS "insResultImg"
       ,TO_BASE64(PRI.INS_IMG)      AS "insImg"
       ,IR.INS_NONG                 AS "insNong"
    FROM TSHP_INS_RESULT_MASTER IRM
    LEFT JOIN TSHP_INS_RESULT IR
        ON IRM.PLT_CODE = IR.PLT_CODE
       AND IRM.INSM_NO  = IR.INSM_NO
       AND IR.DATA_FLAG  = 0
    LEFT JOIN LSE_STD_PROC PR
        ON IR.PLT_CODE  = PR.PLT_CODE
       AND IR.PROC_CODE = PR.PROC_CODE
       AND PR.DATA_FLAG  = 0
    LEFT JOIN TSTD_PROC_INS PRI
        ON IR.PLT_CODE = PRI.PLT_CODE
       AND IR.INS_CODE = PRI.INS_CODE
    WHERE IRM.PLT_CODE  = p_plt_code
      AND IRM.INSM_NO   = p_insm_no
      AND IRM.DATA_FLAG  = p_data_flag
    ORDER BY IR.INS_SEQ ASC;
END//


-- ============================================================
-- 2. sp_imes_tshp_ins_result_query2: 예약 (stub)
-- 용도: 향후 확장용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_query2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_query2(
    IN p_plt_code VARCHAR(10)      /* 공장코드 */
)
BEGIN
    /* stub - 향후 구현 예정 */
    SELECT 1 AS "dummy" FROM DUAL WHERE 1 = 0;
END//


-- ============================================================
-- 3. sp_imes_tshp_ins_result_query3: 예약 (stub)
-- 용도: 향후 확장용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_query3//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_query3(
    IN p_plt_code VARCHAR(10)      /* 공장코드 */
)
BEGIN
    /* stub - 향후 구현 예정 */
    SELECT 1 AS "dummy" FROM DUAL WHERE 1 = 0;
END//


DELIMITER ;
