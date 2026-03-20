-- ============================================================
-- TSHP_WORKORDER_QUERY 조회 프로시저
-- 생성일: 2026-02-23
-- 수정일: 2026-02-24 (ORD06A용 QUERY5 확장)
-- 대상 테이블: TSHP_WORKORDER, LSE_STD_PART, LSE_MACHINE, TSTD_EMPLOYEE, TSHP_ACTUAL
-- 원본: ProActive TSHP_WORKORDER_QUERY.cs
-- ============================================================
-- 명명 규칙: sp_imes_tshp_workorder_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_workorder_query6: 생산오더 요약 조회
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY6()
-- 용도: SAP_WO_NO별 공정 수, 모델, 부품, 비고 집계
-- 사용화면: ORD13A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query6//

CREATE PROCEDURE sp_imes_tshp_workorder_query6(
    IN p_plt_code    VARCHAR(3),
    IN p_plants      VARCHAR(10),
    IN p_model_like  VARCHAR(100),
    IN p_proc_like   VARCHAR(100),
    IN p_part_like   VARCHAR(100),
    IN p_s_pln_date  VARCHAR(8),
    IN p_e_pln_date  VARCHAR(8)
)
BEGIN
    SELECT
        WO.PLT_CODE                     AS pltCode,
        MAX(WO.MODEL)                   AS model,
        WO.SAP_WO_NO                    AS sapWoNo,
        WO.PART_CODE                    AS partCode,
        SP.PART_NAME                    AS partName,
        COUNT(WO.WO_NO)                AS procCnt,
        MAX(WO.SCOMMENT)               AS scomment
    FROM TSHP_WORKORDER WO
    LEFT JOIN LSE_STD_PART SP
        ON WO.PLT_CODE = SP.PLT_CODE
       AND WO.PART_CODE = SP.PART_CODE
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.PLANTS = p_plants
      AND WO.DATA_FLAG = 0
      AND (p_model_like IS NULL OR p_model_like = '' OR WO.MODEL LIKE CONCAT('%', p_model_like, '%'))
      AND (p_proc_like IS NULL OR p_proc_like = '' OR WO.PROC_CODE LIKE CONCAT('%', p_proc_like, '%'))
      AND (p_part_like IS NULL OR p_part_like = '' OR WO.PART_CODE LIKE CONCAT('%', p_part_like, '%') OR SP.PART_NAME LIKE CONCAT('%', p_part_like, '%'))
      AND (p_s_pln_date IS NULL OR p_s_pln_date = '' OR p_e_pln_date IS NULL OR p_e_pln_date = ''
           OR WO.SAP_WO_NO IN (
               SELECT WWO.SAP_WO_NO
               FROM TSHP_WORKORDER WWO
               WHERE SUBSTRING(WWO.PLN_START_TIME, 1, 8) BETWEEN p_s_pln_date AND p_e_pln_date
                 AND WWO.PLANTS = p_plants
           ))
    GROUP BY WO.PLT_CODE, WO.SAP_WO_NO, WO.PART_CODE, SP.PART_NAME
    ORDER BY MAX(WO.MODEL), WO.SAP_WO_NO;
END//

-- ============================================================
-- sp_imes_tshp_workorder_query5: 생산오더 상세 조회
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY5()
-- 용도: WO_SEQ 단위 상세 레코드
-- 사용화면: ORD13A (동적컬럼 매핑), ORD06A (메인 그리드)
-- 수정이력:
--   2026-02-23 최초 생성 (ORD13A, 14컬럼, 7파라미터)
--   2026-02-24 확장 (ORD06A, 28컬럼, 11파라미터)
--     추가 컬럼: confirmDate, mprocCode, actStartTime, actEndTime,
--       actSt, plnStartTime, plnEndTime, bfPlnStartTime, bfPlnEndTime,
--       plnProcRdyTime, plnProcManTime, plnProcSelfTime, plnProcTime,
--       workContents, mctVenName, prodCode
--     추가 파라미터: p_sap_wo_like, p_s_reg_date, p_e_reg_date, p_is_zero
--     추가 JOIN: TSHP_ACTUAL (실적시간 집계)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query5//

CREATE PROCEDURE sp_imes_tshp_workorder_query5(
    IN p_plt_code     VARCHAR(3),
    IN p_plants       VARCHAR(10),
    IN p_model_like   VARCHAR(100),
    IN p_proc_like    VARCHAR(100),
    IN p_part_like    VARCHAR(100),
    IN p_s_pln_date   VARCHAR(8),
    IN p_e_pln_date   VARCHAR(8),
    IN p_sap_wo_like  VARCHAR(100),
    IN p_s_reg_date   VARCHAR(8),
    IN p_e_reg_date   VARCHAR(8),
    IN p_is_zero      VARCHAR(1)
)
BEGIN
    SELECT
        WO.PLT_CODE                     AS pltCode,
        WO.MODEL                        AS model,
        WO.WO_NO                        AS woNo,
        WO.SAP_WO_NO                    AS sapWoNo,
        WO.WO_SEQ                       AS woSeq,
        WO.PART_CODE                    AS partCode,
        SP.PART_NAME                    AS partName,
        DATE_FORMAT(WO.CONFIRM_DATE, '%Y%m%d%H%i') AS confirmDate,
        WO.MPROC_CODE                   AS mprocCode,
        WO.PROC_CODE                    AS procCode,
        WO.MC_CODE                      AS mcCode,
        MC.MC_NAME                      AS mcName,
        DATE_FORMAT(WO.ACT_START_TIME, '%Y%m%d%H%i') AS actStartTime,
        DATE_FORMAT(WO.ACT_END_TIME, '%Y%m%d%H%i')   AS actEndTime,
        (SELECT SUM(FLOOR(UNIX_TIMESTAMP(A.ACT_END_TIME)/60) - FLOOR(UNIX_TIMESTAMP(A.ACT_START_TIME)/60))
         FROM TSHP_ACTUAL A
         WHERE A.PLT_CODE = WO.PLT_CODE AND A.WO_NO = WO.WO_NO
           AND A.ACT_END_TIME IS NOT NULL) AS actSt,
        WO.WO_FLAG                      AS woFlag,
        WO.PLN_START_TIME               AS plnStartTime,
        WO.PLN_END_TIME                 AS plnEndTime,
        WO.BF_PLN_START_TIME            AS bfPlnStartTime,
        WO.BF_PLN_END_TIME              AS bfPlnEndTime,
        WO.PLN_PROC_RDY_TIME            AS plnProcRdyTime,
        WO.PLN_PROC_MAN_TIME            AS plnProcManTime,
        WO.PLN_PROC_SELF_TIME           AS plnProcSelfTime,
        WO.PLN_PROC_TIME               AS plnProcTime,
        WO.WORK_CONTENTS                AS workContents,
        WO.SCOMMENT                     AS scomment,
        WO.ACT_EMP_CODE                 AS actEmpCode,
        E.EMP_NAME                      AS empName,
        WO.MCT_VEN_NAME                 AS mctVenName,
        WO.PROD_CODE                    AS prodCode
    FROM TSHP_WORKORDER WO
    LEFT JOIN LSE_STD_PART SP
        ON WO.PLT_CODE = SP.PLT_CODE
       AND WO.PART_CODE = SP.PART_CODE
    LEFT JOIN LSE_MACHINE MC
        ON WO.PLT_CODE = MC.PLT_CODE
       AND WO.MC_CODE = MC.MC_CODE
    LEFT JOIN TSTD_EMPLOYEE E
        ON WO.PLT_CODE = E.PLT_CODE
       AND WO.ACT_EMP_CODE = E.EMP_CODE
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.PLANTS = p_plants
      AND WO.DATA_FLAG = 0
      AND (p_model_like IS NULL OR p_model_like = '' OR WO.MODEL LIKE CONCAT('%', p_model_like, '%'))
      AND (p_proc_like IS NULL OR p_proc_like = '' OR WO.PROC_CODE LIKE CONCAT('%', p_proc_like, '%'))
      AND (p_part_like IS NULL OR p_part_like = '' OR WO.PART_CODE LIKE CONCAT('%', p_part_like, '%') OR SP.PART_NAME LIKE CONCAT('%', p_part_like, '%'))
      AND (p_s_pln_date IS NULL OR p_s_pln_date = '' OR p_e_pln_date IS NULL OR p_e_pln_date = ''
           OR (SUBSTRING(WO.PLN_START_TIME, 1, 8) BETWEEN p_s_pln_date AND p_e_pln_date
               OR SUBSTRING(WO.PLN_END_TIME, 1, 8) BETWEEN p_s_pln_date AND p_e_pln_date))
      AND (p_sap_wo_like IS NULL OR p_sap_wo_like = '' OR WO.SAP_WO_NO LIKE CONCAT('%', p_sap_wo_like, '%'))
      AND (p_s_reg_date IS NULL OR p_s_reg_date = '' OR p_e_reg_date IS NULL OR p_e_reg_date = ''
           OR DATE_FORMAT(WO.REG_DATE, '%Y%m%d') BETWEEN p_s_reg_date AND p_e_reg_date)
      AND (p_is_zero IS NULL OR p_is_zero = '' OR p_is_zero != '1' OR WO.PLN_PROC_TIME > 0)
    ORDER BY WO.MODEL, WO.SAP_WO_NO, WO.WO_SEQ;
END//

-- ============================================================
-- sp_imes_tshp_workorder_query1_2: 작업지시 목록 조회 (SER5용)
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY1_2()
-- 용도: MAT05A_SER5 - 불출/취소 후 부모그리드 갱신
-- 사용화면: MAT05A
-- 추가일: 2026-03-06
-- QUERY1_2_1과 차이:
--   1. PLANTS: 등호(=) 비교 (QUERY1_2_1은 FIND_IN_SET)
--   2. ORDER_NO/ORDER_LINE: 등호(=) (QUERY1_2_1은 LIKE)
--   3. 날짜 범위 조건 없음 (SER5 파라미터에 날짜 없음)
--   4. SELECT에 WO.PLANTS 없음
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query1_2//

CREATE PROCEDURE sp_imes_tshp_workorder_query1_2(
    IN p_plt_code     VARCHAR(3),
    IN p_order_no     VARCHAR(50),
    IN p_order_line   VARCHAR(10),
    IN p_plants       VARCHAR(200),
    IN p_is_sim       VARCHAR(1),
    IN p_wo_flag_in   VARCHAR(100)
)
BEGIN
    SELECT
        WO.PLT_CODE                     AS pltCode,
        P.PROD_CODE                     AS prodCode,
        WO.WO_NO                        AS woNo,
        WO.SAP_WO_NO                    AS sapWoNo,
        P.ORDER_NO                      AS orderNo,
        P.ORDER_LINE                    AS orderLine,
        CONCAT(P.ORDER_NO, '-', CAST(P.ORDER_LINE AS CHAR)) AS prodOrder,
        WO.PART_CODE                    AS partCode,
        P.PROD_HOGI                     AS prodHogi,
        DATE_FORMAT(WO.ACT_END_TIME, '%Y%m%d%H%i') AS actEndTime,
        P.INDUE_DATE                    AS indueDate,
        P.DUE_DATE                      AS dueDate,
        P.PROD_WEEK                     AS prodWeek,
        P.YEAR_WEEK                     AS yearWeek,
        P.MONTH_WEEK                    AS monthWeek,
        P.INDUE_WEEK                    AS indueWeek,
        P.INDUE_MONTH_WEEK              AS indueMonthWeek,
        P.ORD_DATE                      AS ordDate,
        SAP.DUE_DATE                    AS sapDueDate,
        SAP.CUSTOMER                    AS customer,
        SAP.DELIVERY                    AS delivery,
        P.MODEL_TYPE                    AS modelType,
        DATE_FORMAT(WO.CONFIRM_DATE, '%Y%m%d%H%i') AS confirmDate,
        WO.PROC_CODE                    AS procCode,
        WO.MC_CODE                      AS mcCode,
        MC.MC_NAME                      AS mcName,
        DATE_FORMAT(WO.ACT_START_TIME, '%Y%m%d%H%i') AS actStartTime,
        (SELECT SUM(FLOOR(UNIX_TIMESTAMP(A.ACT_END_TIME)/60) - FLOOR(UNIX_TIMESTAMP(A.ACT_START_TIME)/60))
         FROM TSHP_ACTUAL A
         WHERE A.PLT_CODE = p_plt_code AND A.WO_NO = WO.WO_NO
           AND A.ACT_END_TIME IS NOT NULL) AS actSt,
        WO.BF_PLN_START_TIME            AS bfPlnStartTime,
        WO.PLN_START_TIME               AS plnStartTime,
        WO.PLN_END_TIME                 AS plnEndTime,
        WO.PLN_PROC_TIME                AS plnStdSt,
        STP.ST_TIME                     AS plnSt,
        WO.WO_FLAG                      AS woFlag,
        MD.PROD_TYPE                    AS prodType,
        PRG.PRG_SEQ                     AS prgSeq,
        MC.MC_FLAG                      AS mcFlag,
        WO.MAT_OUT_RATE                 AS matOutRate,
        WO.MAT_OUT_RATE_MES             AS matOutRateMes,
        WO.MAT_OUT_STK_RATE             AS matOutStkRate,
        WO.PART_CODE                    AS banPartCode,
        (SELECT GROUP_CONCAT(DISTINCT E.EMP_NAME SEPARATOR ',')
         FROM TSHP_ACTUAL A2
         INNER JOIN TSTD_EMPLOYEE E ON A2.PLT_CODE = E.PLT_CODE AND A2.EMP_CODE = E.EMP_CODE
         WHERE A2.PLT_CODE = p_plt_code AND A2.WO_NO = WO.WO_NO) AS actEmps
    FROM TSHP_WORKORDER WO
    LEFT JOIN TORD_PRODUCT P
        ON WO.PLT_CODE = P.PLT_CODE AND WO.PROD_CODE = P.PROD_CODE
    LEFT JOIN IF_SAP_SHIPINFO SAP
        ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
    LEFT JOIN LSE_MACHINE MC
        ON WO.PLT_CODE = MC.PLT_CODE AND WO.MC_CODE = MC.MC_CODE
    LEFT JOIN TSTD_MODEL MD
        ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_TYPE = MD.MODEL_TYPE
       AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_NO = MD.MODEL_NO
    LEFT JOIN TSTD_PROCGRP PRG
        ON WO.PLT_CODE = PRG.PLT_CODE AND WO.MPROC_CODE = PRG.PRG_CODE
    LEFT JOIN TSTD_ST_GROUP STG
        ON WO.PLT_CODE = STG.PLT_CODE AND WO.PART_CODE = STG.PART_CODE
       AND STG.IS_BASE = '1' AND STG.DATA_FLAG = '0'
    LEFT JOIN TSTD_ST_PROC STP
        ON STG.PLT_CODE = STP.PLT_CODE AND STG.ST_CODE = STP.ST_CODE
       AND WO.PROC_CODE = STP.PROC_CODE AND STP.DATA_FLAG = '0'
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.DATA_FLAG = 0
      AND WO.SAP_WO_NO IS NOT NULL
      AND WO.WO_SEQ = '10'
      AND (p_is_sim IS NULL OR p_is_sim = '' OR WO.IS_SIM = p_is_sim)
      AND (p_wo_flag_in IS NULL OR p_wo_flag_in = '' OR FIND_IN_SET(WO.WO_FLAG, p_wo_flag_in))
      AND (p_plants IS NULL OR p_plants = '' OR WO.PLANTS = p_plants)
      AND (p_order_no IS NULL OR p_order_no = '' OR P.ORDER_NO = p_order_no)
      AND (p_order_line IS NULL OR p_order_line = '' OR P.ORDER_LINE = p_order_line)
    ORDER BY P.PROD_CODE, PRG.PRG_SEQ, WO.SEQ;
END//

-- ============================================================
-- sp_imes_tshp_workorder_query1_2_1: 작업지시 목록 조회 (Tab1 메인)
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY1_2_1()
-- 용도: MAT05A Tab1 공정별 메인 그리드
-- 사용화면: MAT05A
-- 추가일: 2026-03-04
-- 수정일: 2026-03-05 (AS-IS 재검토)
--   1. actEmps 컬럼 추가 (AS-IS: GET_ACT_EMPS 함수)
--   2. SAP_DUE_DATE 조건: SAP.DUE_DATE → P.DUE_DATE (AS-IS 일치)
--   3. PLN_DATE 조건: PLN_START_TIME만 체크 (AS-IS: S_PLN_START_DATE → PLN_START_TIME만)
--   4. PLANTS: FIND_IN_SET (AS-IS: IN @PLANTS, SqlCondType.IN)
--   5. WO_FLAG_IN: 파라미터화 (AS-IS: WO_FLAG_IN 동적 전달)
--   6. IS_SIM: 파라미터화 (AS-IS: @IS_SIM 선택적 조건)
-- 수정일: 2026-03-06 (성능 개선)
--   1. actSt/actEmps: LEFT JOIN 서브쿼리 → 스칼라 서브쿼리 (결과행 수 적을 때 인덱스 활용 유리)
--   2. PLN_START_TIME: LEFT() 함수 제거 → 범위 비교 (인덱스 활용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query1_2_1//

CREATE PROCEDURE sp_imes_tshp_workorder_query1_2_1(
    IN p_plt_code          VARCHAR(3),
    IN p_order_like        VARCHAR(100),
    IN p_hogi_like         VARCHAR(100),
    IN p_customer_like     VARCHAR(100),
    IN p_plants            VARCHAR(200),
    IN p_s_pln_start_date  VARCHAR(8),
    IN p_e_pln_start_date  VARCHAR(8),
    IN p_s_indue_date      VARCHAR(8),
    IN p_e_indue_date      VARCHAR(8),
    IN p_s_sap_due_date    VARCHAR(8),
    IN p_e_sap_due_date    VARCHAR(8),
    IN p_s_due_date        VARCHAR(8),
    IN p_e_due_date        VARCHAR(8),
    IN p_wo_flag_in        VARCHAR(100),
    IN p_is_sim            VARCHAR(1)
)
BEGIN
    SELECT
        WO.PLT_CODE                     AS pltCode,
        P.PROD_CODE                     AS prodCode,
        WO.WO_NO                        AS woNo,
        WO.SAP_WO_NO                    AS sapWoNo,
        P.ORDER_NO                      AS orderNo,
        P.ORDER_LINE                    AS orderLine,
        CONCAT(P.ORDER_NO, '-', CAST(P.ORDER_LINE AS CHAR)) AS prodOrder,
        WO.PART_CODE                    AS partCode,
        P.PROD_HOGI                     AS prodHogi,
        DATE_FORMAT(WO.ACT_END_TIME, '%Y%m%d%H%i') AS actEndTime,
        P.INDUE_DATE                    AS indueDate,
        P.DUE_DATE                      AS dueDate,
        P.PROD_WEEK                     AS prodWeek,
        P.YEAR_WEEK                     AS yearWeek,
        P.MONTH_WEEK                    AS monthWeek,
        P.INDUE_WEEK                    AS indueWeek,
        P.INDUE_MONTH_WEEK              AS indueMonthWeek,
        P.ORD_DATE                      AS ordDate,
        SAP.DUE_DATE                    AS sapDueDate,
        SAP.CUSTOMER                    AS customer,
        SAP.DELIVERY                    AS delivery,
        P.MODEL_TYPE                    AS modelType,
        DATE_FORMAT(WO.CONFIRM_DATE, '%Y%m%d%H%i') AS confirmDate,
        WO.PROC_CODE                    AS procCode,
        WO.MC_CODE                      AS mcCode,
        MC.MC_NAME                      AS mcName,
        DATE_FORMAT(WO.ACT_START_TIME, '%Y%m%d%H%i') AS actStartTime,
        (SELECT SUM(FLOOR(UNIX_TIMESTAMP(A.ACT_END_TIME)/60) - FLOOR(UNIX_TIMESTAMP(A.ACT_START_TIME)/60))
         FROM TSHP_ACTUAL A
         WHERE A.PLT_CODE = p_plt_code AND A.WO_NO = WO.WO_NO
           AND A.ACT_END_TIME IS NOT NULL) AS actSt,
        WO.BF_PLN_START_TIME            AS bfPlnStartTime,
        WO.PLN_START_TIME               AS plnStartTime,
        WO.PLN_END_TIME                 AS plnEndTime,
        WO.PLN_PROC_TIME                AS plnStdSt,
        STP.ST_TIME                     AS plnSt,
        WO.WO_FLAG                      AS woFlag,
        MD.PROD_TYPE                    AS prodType,
        PRG.PRG_SEQ                     AS prgSeq,
        MC.MC_FLAG                      AS mcFlag,
        WO.MAT_OUT_RATE                 AS matOutRate,
        WO.MAT_OUT_RATE_MES             AS matOutRateMes,
        WO.MAT_OUT_STK_RATE             AS matOutStkRate,
        WO.PART_CODE                    AS banPartCode,
        (SELECT GROUP_CONCAT(DISTINCT E.EMP_NAME SEPARATOR ',')
         FROM TSHP_ACTUAL A2
         INNER JOIN TSTD_EMPLOYEE E ON A2.PLT_CODE = E.PLT_CODE AND A2.EMP_CODE = E.EMP_CODE
         WHERE A2.PLT_CODE = p_plt_code AND A2.WO_NO = WO.WO_NO) AS actEmps,
        WO.PLANTS                       AS plants
    FROM TSHP_WORKORDER WO
    LEFT JOIN TORD_PRODUCT P
        ON WO.PLT_CODE = P.PLT_CODE AND WO.PROD_CODE = P.PROD_CODE
    LEFT JOIN IF_SAP_SHIPINFO SAP
        ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
    LEFT JOIN LSE_MACHINE MC
        ON WO.PLT_CODE = MC.PLT_CODE AND WO.MC_CODE = MC.MC_CODE
    LEFT JOIN TSTD_MODEL MD
        ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_TYPE = MD.MODEL_TYPE
       AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_NO = MD.MODEL_NO
    LEFT JOIN TSTD_PROCGRP PRG
        ON WO.PLT_CODE = PRG.PLT_CODE AND WO.MPROC_CODE = PRG.PRG_CODE
    LEFT JOIN TSTD_ST_GROUP STG
        ON WO.PLT_CODE = STG.PLT_CODE AND WO.PART_CODE = STG.PART_CODE
       AND STG.IS_BASE = '1' AND STG.DATA_FLAG = '0'
    LEFT JOIN TSTD_ST_PROC STP
        ON STG.PLT_CODE = STP.PLT_CODE AND STG.ST_CODE = STP.ST_CODE
       AND WO.PROC_CODE = STP.PROC_CODE AND STP.DATA_FLAG = '0'
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.DATA_FLAG = 0
      AND WO.SAP_WO_NO IS NOT NULL
      AND WO.WO_SEQ = '10'
      -- AS-IS: @IS_SIM 선택적 조건 (BIZ에서 1 전달)
      AND (p_is_sim IS NULL OR p_is_sim = '' OR WO.IS_SIM = p_is_sim)
      -- AS-IS: WO_FLAG_IN 파라미터 동적 전달 (UI에서 '1,2,3,4' 전달)
      AND (p_wo_flag_in IS NULL OR p_wo_flag_in = '' OR FIND_IN_SET(WO.WO_FLAG, p_wo_flag_in))
      -- AS-IS: IN @PLANTS (SqlCondType.IN, 콤마 구분 복수값)
      AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(WO.PLANTS, p_plants))
      AND (p_order_like IS NULL OR p_order_like = '' OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
      AND (p_hogi_like IS NULL OR p_hogi_like = '' OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
      AND (p_customer_like IS NULL OR p_customer_like = '' OR SAP.CUSTOMER LIKE CONCAT('%', p_customer_like, '%'))
      -- PLN_START_TIME: 범위 비교 (인덱스 활용, LEFT() 함수 제거)
      AND (p_s_pln_start_date IS NULL OR p_s_pln_start_date = ''
           OR (WO.PLN_START_TIME >= CONCAT(p_s_pln_start_date, '0000')
               AND WO.PLN_START_TIME < CONCAT(DATE_FORMAT(STR_TO_DATE(p_e_pln_start_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d'), '0000')))
      AND (p_s_indue_date IS NULL OR p_s_indue_date = ''
           OR (P.INDUE_DATE >= p_s_indue_date
               AND P.INDUE_DATE < DATE_FORMAT(STR_TO_DATE(p_e_indue_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d')))
      -- AS-IS: SAP_DUE_DATE 조건도 P.DUE_DATE 사용
      AND (p_s_sap_due_date IS NULL OR p_s_sap_due_date = ''
           OR (P.DUE_DATE >= p_s_sap_due_date
               AND P.DUE_DATE < DATE_FORMAT(STR_TO_DATE(p_e_sap_due_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d')))
      AND (p_s_due_date IS NULL OR p_s_due_date = ''
           OR (P.DUE_DATE >= p_s_due_date
               AND P.DUE_DATE < DATE_FORMAT(STR_TO_DATE(p_e_due_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d')))
    ORDER BY P.PROD_CODE, PRG.PRG_SEQ, WO.SEQ;
END//

-- ============================================================
-- sp_imes_tshp_workorder_query1_3: 작업지시+소요자재 결합 조회
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY1_3()
-- 용도: MAT05A Tab2(전체), Tab3(불출현황)
-- 사용화면: MAT05A
-- 추가일: 2026-03-04
-- 수정일: 2026-03-05 (AS-IS 재검토)
--   1. actEmps 컬럼 추가
--   2. SAP_DUE_DATE 조건: SAP.DUE_DATE → P.DUE_DATE (AS-IS 일치)
--   3. PLN_DATE 조건: PLN_START_TIME만 체크 (AS-IS: S_PLN_START_DATE → PLN_START_TIME만)
--   4. puPartName → partName 별칭 수정 (Grid3 필드 매칭)
--   5. PLANTS: FIND_IN_SET (AS-IS: IN @PLANTS, SqlCondType.IN)
--   6. WO_FLAG_IN: 파라미터화 (AS-IS: WO_FLAG_IN 동적 전달)
--   7. IS_SIM: 파라미터화 (AS-IS: @IS_SIM 선택적 조건)
-- 수정일: 2026-03-06 (성능 개선)
--   1. actSt/actEmps: LEFT JOIN 서브쿼리 → 스칼라 서브쿼리 (결과행 수 적을 때 인덱스 활용 유리)
--   2. PLN_START_TIME: LEFT() 함수 제거 → 범위 비교 (인덱스 활용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query1_3//

CREATE PROCEDURE sp_imes_tshp_workorder_query1_3(
    IN p_plt_code          VARCHAR(3),
    IN p_order_like        VARCHAR(100),
    IN p_hogi_like         VARCHAR(100),
    IN p_customer_like     VARCHAR(100),
    IN p_plants            VARCHAR(200),
    IN p_s_pln_start_date  VARCHAR(8),
    IN p_e_pln_start_date  VARCHAR(8),
    IN p_s_indue_date      VARCHAR(8),
    IN p_e_indue_date      VARCHAR(8),
    IN p_s_sap_due_date    VARCHAR(8),
    IN p_e_sap_due_date    VARCHAR(8),
    IN p_s_due_date        VARCHAR(8),
    IN p_e_due_date        VARCHAR(8),
    IN p_wo_flag_in        VARCHAR(100),
    IN p_is_sim            VARCHAR(1)
)
BEGIN
    SELECT
        WO.PLT_CODE                     AS pltCode,
        P.PROD_CODE                     AS prodCode,
        WO.WO_NO                        AS woNo,
        WO.SAP_WO_NO                    AS sapWoNo,
        P.ORDER_NO                      AS orderNo,
        CAST(P.ORDER_LINE AS CHAR)      AS orderLine,
        CONCAT(P.ORDER_NO, '-', CAST(P.ORDER_LINE AS CHAR)) AS prodOrder,
        WO.PART_CODE                    AS partCode,
        P.PROD_HOGI                     AS prodHogi,
        P.INDUE_DATE                    AS indueDate,
        P.DUE_DATE                      AS dueDate,
        P.PROD_WEEK                     AS prodWeek,
        P.YEAR_WEEK                     AS yearWeek,
        P.MONTH_WEEK                    AS monthWeek,
        P.INDUE_WEEK                    AS indueWeek,
        P.INDUE_MONTH_WEEK              AS indueMonthWeek,
        P.ORD_DATE                      AS ordDate,
        SAP.DUE_DATE                    AS sapDueDate,
        SAP.CUSTOMER                    AS customer,
        SAP.DELIVERY                    AS delivery,
        P.MODEL_TYPE                    AS modelType,
        DATE_FORMAT(WO.CONFIRM_DATE, '%Y%m%d%H%i') AS confirmDate,
        WO.PROC_CODE                    AS procCode,
        WO.MC_CODE                      AS mcCode,
        MC.MC_NAME                      AS mcName,
        DATE_FORMAT(WO.ACT_START_TIME, '%Y%m%d%H%i') AS actStartTime,
        DATE_FORMAT(WO.ACT_END_TIME, '%Y%m%d%H%i')   AS actEndTime,
        (SELECT SUM(FLOOR(UNIX_TIMESTAMP(A.ACT_END_TIME)/60) - FLOOR(UNIX_TIMESTAMP(A.ACT_START_TIME)/60))
         FROM TSHP_ACTUAL A
         WHERE A.PLT_CODE = p_plt_code AND A.WO_NO = WO.WO_NO
           AND A.ACT_END_TIME IS NOT NULL) AS actSt,
        WO.BF_PLN_START_TIME            AS bfPlnStartTime,
        WO.PLN_START_TIME               AS plnStartTime,
        WO.PLN_END_TIME                 AS plnEndTime,
        WO.PLN_PROC_TIME                AS plnStdSt,
        STP.ST_TIME                     AS plnSt,
        WO.WO_FLAG                      AS woFlag,
        MD.PROD_TYPE                    AS prodType,
        PRG.PRG_SEQ                     AS prgSeq,
        MC.MC_FLAG                      AS mcFlag,
        WO.MAT_OUT_RATE                 AS matOutRate,
        WO.MAT_OUT_RATE_MES             AS matOutRateMes,
        WO.MAT_OUT_STK_RATE             AS matOutStkRate,
        WO.PART_CODE                    AS banPartCode,
        (SELECT GROUP_CONCAT(DISTINCT E.EMP_NAME SEPARATOR ',')
         FROM TSHP_ACTUAL A2
         INNER JOIN TSTD_EMPLOYEE E ON A2.PLT_CODE = E.PLT_CODE AND A2.EMP_CODE = E.EMP_CODE
         WHERE A2.PLT_CODE = p_plt_code AND A2.WO_NO = WO.WO_NO) AS actEmps,
        WO.PLANTS                       AS plants,
        PU.PART_SPEC                    AS partSpec,
        SP2.PART_NAME                   AS partName,
        PU.USE_QTY                      AS useQty,
        PU.SHIP_QTY                     AS shipQty,
        PU.STK_USE_QTY                  AS stkUseQty,
        PU.STK_INS_QTY                  AS stkInsQty,
        PU.STK_VND_QTY                  AS stkVndQty,
        PU.IS_MAT                       AS isMat,
        PU.IS_SHIP                      AS isShip,
        SOP.OUT_FLAG                    AS outFlag,
        PU.YPGO_PLAN_DATE               AS ypgoPlanDate,
        PU.MVND_NAME                    AS mvndName,
        PU.MRP_EMP                      AS mrpEmp,
        PU.MRP_EMP_NAME                 AS mrpEmpName,
        PU.BIN                          AS bin,
        PU.LASS_F                       AS lassF,
        PU.LASS_F_CAUSE                 AS lassFCause
    FROM TSHP_WORKORDER WO
    LEFT JOIN TORD_PRODUCT P
        ON WO.PLT_CODE = P.PLT_CODE AND WO.PROD_CODE = P.PROD_CODE
    LEFT JOIN IF_SAP_SHIPINFO SAP
        ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
    LEFT JOIN LSE_MACHINE MC
        ON WO.PLT_CODE = MC.PLT_CODE AND WO.MC_CODE = MC.MC_CODE
    LEFT JOIN TSTD_MODEL MD
        ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_TYPE = MD.MODEL_TYPE
       AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_NO = MD.MODEL_NO
    LEFT JOIN TSTD_PROCGRP PRG
        ON WO.PLT_CODE = PRG.PLT_CODE AND WO.MPROC_CODE = PRG.PRG_CODE
    LEFT JOIN TSTD_ST_GROUP STG
        ON WO.PLT_CODE = STG.PLT_CODE AND WO.PART_CODE = STG.PART_CODE
       AND STG.IS_BASE = '1' AND STG.DATA_FLAG = '0'
    LEFT JOIN TSTD_ST_PROC STP
        ON STG.PLT_CODE = STP.PLT_CODE AND STG.ST_CODE = STP.ST_CODE
       AND WO.PROC_CODE = STP.PROC_CODE AND STP.DATA_FLAG = '0'
    LEFT JOIN TSHP_PART_USE PU
        ON PU.ORDER_NO = P.ORDER_NO
       AND PU.ORDER_LINE = P.ORDER_LINE
       AND PU.SAP_WO_NO = WO.SAP_WO_NO
       AND PU.PART_CODE = WO.PART_CODE
    LEFT JOIN LSE_STD_PART SP2
        ON PU.PLT_CODE = SP2.PLT_CODE
       AND PU.PART_SPEC = SP2.PART_CODE
    LEFT JOIN TSHP_STK_OUT SO
        ON PU.PLT_CODE = SO.PLT_CODE
       AND PU.PROD_CODE = SO.PROD_CODE
       AND PU.SAP_WO_NO = SO.SAP_WO_NO
       AND PU.PROC_CODE = SO.PROC_CODE
       AND PU.MRP_EMP = SO.MRP_EMP
    LEFT JOIN TSHP_STK_OUT_PART SOP
        ON SO.PLT_CODE = SOP.PLT_CODE
       AND SO.STK_OUT_NO = SOP.STK_OUT_NO
       AND PU.PART_SPEC = SOP.PART_CODE
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.DATA_FLAG = 0
      AND WO.SAP_WO_NO IS NOT NULL
      AND WO.WO_SEQ = '10'
      -- AS-IS: @IS_SIM 선택적 조건 (BIZ에서 1 전달)
      AND (p_is_sim IS NULL OR p_is_sim = '' OR WO.IS_SIM = p_is_sim)
      -- AS-IS: WO_FLAG_IN 파라미터 동적 전달 (UI에서 '1,2,3,4' 전달)
      AND (p_wo_flag_in IS NULL OR p_wo_flag_in = '' OR FIND_IN_SET(WO.WO_FLAG, p_wo_flag_in))
      AND WO.MPROC_CODE NOT IN (SELECT CD_NAME COLLATE utf8mb4_unicode_ci FROM TSTD_CODES WHERE CAT_CODE = 'A002' AND VALUE = 'PROC_CODE')
      -- AS-IS: IN @PLANTS (SqlCondType.IN, 콤마 구분 복수값)
      AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(WO.PLANTS, p_plants))
      AND (p_order_like IS NULL OR p_order_like = '' OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
      AND (p_hogi_like IS NULL OR p_hogi_like = '' OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
      AND (p_customer_like IS NULL OR p_customer_like = '' OR SAP.CUSTOMER LIKE CONCAT('%', p_customer_like, '%'))
      -- PLN_START_TIME: 범위 비교 (인덱스 활용, LEFT() 함수 제거)
      AND (p_s_pln_start_date IS NULL OR p_s_pln_start_date = ''
           OR (WO.PLN_START_TIME >= CONCAT(p_s_pln_start_date, '0000')
               AND WO.PLN_START_TIME < CONCAT(DATE_FORMAT(STR_TO_DATE(p_e_pln_start_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d'), '0000')))
      AND (p_s_indue_date IS NULL OR p_s_indue_date = ''
           OR (P.INDUE_DATE >= p_s_indue_date
               AND P.INDUE_DATE < DATE_FORMAT(STR_TO_DATE(p_e_indue_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d')))
      -- AS-IS: SAP_DUE_DATE 조건도 P.DUE_DATE 사용
      AND (p_s_sap_due_date IS NULL OR p_s_sap_due_date = ''
           OR (P.DUE_DATE >= p_s_sap_due_date
               AND P.DUE_DATE < DATE_FORMAT(STR_TO_DATE(p_e_sap_due_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d')))
      AND (p_s_due_date IS NULL OR p_s_due_date = ''
           OR (P.DUE_DATE >= p_s_due_date
               AND P.DUE_DATE < DATE_FORMAT(STR_TO_DATE(p_e_due_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d')))
    ORDER BY P.PROD_CODE, PRG.PRG_SEQ, WO.SEQ;
END//


-- ============================================================
-- sp_imes_tshp_workorder_query29: 메인 조회 (생산오더 완료처리 목록)
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY29()
-- 용도: ORD16A 메인 그리드 조회 (ORD16A_SER 서비스)
-- 수정: 2026-03-05 AS-IS 동일화 (3→15 파라미터, SELECT 컬럼 AS-IS 순서,
--       SYS_USER JOIN 삭제, 동적 검색조건 추가, DATA_FLAG=0 하드코딩)
--       성능최적화 시도 후 원복: ACT LEFT JOIN 제거 → SELECT 서브쿼리로 변경
--       함수→인라인 서브쿼리 변환 (RDS log_bin_trust_function_creators=OFF 대응)
-- JOIN 구조 (6개 LEFT JOIN):
--   TSHP_WORKORDER WO           (작업지시 - 메인)
--     ↔ TORD_PRODUCT P          (수주/제품 정보)
--     ↔ IF_SAP_SHIPINFO SAP     (SAP 출하정보)
--     ↔ LSE_MACHINE MC          (설비명)
--     ↔ TSTD_MODEL MD           (모델명, MODEL_SERISE+MODEL_NO 조건 추가)
--     ↔ TSTD_PROCGRP PRG        (공정그룹명, 정렬용 PRG_SEQ)
--     ↔ TSTD_CODES TC           (공장코드→공장명 변환, CAT_CODE='P009')
-- SELECT 서브쿼리 (5개):
--     - ingEmps:  TSHP_ACTUAL에서 진행중 작업자 (PROC_STAT='2')
--     - stopEmps: TSHP_ACTUAL에서 중지 작업자 (PROC_STAT='3')
--     - finEmps:  TSHP_ACTUAL에서 완료 작업자 (PROC_STAT='4')
--     - idleEmps: TSHP_IDLETIME에서 비가동 작업자 (IDLE_STATE='1')
--     - actSt:    TSHP_ACTUAL에서 실적시간 합계 (ACT_END_TIME IS NOT NULL)
-- 파라미터 (15개):
--   p_plt_code         - 공장코드 (예: '100')
--   p_is_sim           - 시뮬레이션 여부
--   p_order_like       - 생산오더번호 LIKE
--   p_hogi_like        - 호기 LIKE
--   p_customer_like    - 수주처 LIKE
--   p_plants           - 공장(SAP)
--   p_s_due_date       - 계약납기 시작일
--   p_e_due_date       - 계약납기 종료일
--   p_s_indue_date     - 생산완료일 시작
--   p_e_indue_date     - 생산완료일 종료
--   p_s_sap_due_date   - 납기일(SAP) 시작
--   p_e_sap_due_date   - 납기일(SAP) 종료
--   p_s_pln_date       - 계획시작일 시작
--   p_e_pln_date       - 계획시작일 종료
--   p_prod_type        - 모델유형
-- 필터조건: DATA_FLAG=0 하드코딩, WO_FLAG <> '0'
-- 정렬: 제품코드 → 공정순서(PRG_SEQ) → 작업순서(SEQ)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query29//

CREATE PROCEDURE sp_imes_tshp_workorder_query29(
    IN p_plt_code         VARCHAR(20),   /* 공장코드 */
    IN p_is_sim           VARCHAR(5),    /* 시뮬레이션 여부 */
    IN p_order_like       VARCHAR(100),  /* 생산오더번호 LIKE */
    IN p_hogi_like        VARCHAR(100),  /* 호기 LIKE */
    IN p_customer_like    VARCHAR(100),  /* 수주처 LIKE */
    IN p_plants           VARCHAR(20),   /* 공장(SAP) */
    IN p_s_due_date       VARCHAR(10),   /* 계약납기 시작일 */
    IN p_e_due_date       VARCHAR(10),   /* 계약납기 종료일 */
    IN p_s_indue_date     VARCHAR(10),   /* 생산완료일 시작 */
    IN p_e_indue_date     VARCHAR(10),   /* 생산완료일 종료 */
    IN p_s_sap_due_date   VARCHAR(10),   /* 납기일(SAP) 시작 */
    IN p_e_sap_due_date   VARCHAR(10),   /* 납기일(SAP) 종료 */
    IN p_s_pln_date       VARCHAR(10),   /* 계획시작일 시작 */
    IN p_e_pln_date       VARCHAR(10),   /* 계획시작일 종료 */
    IN p_prod_type        VARCHAR(20)    /* 모델유형 */
)
BEGIN
    SELECT
        WO.PLT_CODE                                              AS pltCode,        /* 공장코드 */
        P.PROD_CODE                                              AS prodCode,       /* 제품코드 (hidden) */
        IFNULL(TC.CD_NAME, WO.PLANTS)                                AS plants,         /* 공장명 (TSTD_CODES P009 코드→이름 변환) */
        WO.WO_NO                                                 AS woNo,           /* 작업지시번호 (hidden) */
        CONCAT(P.ORDER_NO, '-', P.ORDER_LINE)                    AS prodOrder,      /* 판매오더 (hidden, ORDER_NO+'-'+ORDER_LINE) */
        P.ORDER_NO                                               AS orderNo,        /* 판매오더 (수주번호) */
        P.ORDER_LINE                                             AS orderLine,      /* 품목 (수주라인) */
        WO.SAP_WO_NO                                             AS sapWoNo,        /* 생산오더 */
        P.INDUE_WEEK                                             AS indueWeek,      /* 생산완료주차 (hidden) */
        P.PROD_HOGI                                              AS prodHogi,       /* 호기 */
        P.PROD_WEEK                                              AS prodWeek,       /* 생산시작주차 */
        P.YEAR_WEEK                                              AS yearWeek,       /* 수주주차 (hidden) */
        P.DUE_DATE                                               AS dueDate,        /* 계약납기일 (hidden, VARCHAR(8) YYYYMMDD) */
        SAP.DUE_DATE                                             AS sapDueDate,     /* 납기일 (IF_SAP_SHIPINFO, VARCHAR(8)) */
        P.INDUE_DATE                                             AS indueDate,      /* 생산완료일 (VARCHAR(8)) */
        SAP.CUSTOMER                                             AS customer,       /* 수주처 (IF_SAP_SHIPINFO) */
        P.MODEL_TYPE                                             AS modelType,      /* 타입 */
        WO.PART_CODE                                             AS partCode,       /* 품목코드 (hidden) */
        WO.PROC_CODE                                             AS procCode,       /* 공정 */
        /* 작업자(진행) - PROC_STAT='2', 인라인 서브쿼리 (fn_get_act_ing_emps 대체) */
        IFNULL((
            SELECT GROUP_CONCAT(E.USER_NAME ORDER BY E.USER_NAME, E.USER_ID SEPARATOR ', ')
            FROM (
                SELECT DISTINCT A.PLT_CODE, A.EMP_CODE
                FROM TSHP_ACTUAL A
                WHERE A.PLT_CODE = WO.PLT_CODE AND A.WO_NO = WO.WO_NO AND A.PROC_STAT = '2'
            ) D
            JOIN SYS_USER E ON E.PLT_CODE = D.PLT_CODE AND E.USER_ID = D.EMP_CODE
        ), '')                                                       AS ingEmps,
        /* 작업자(중지) - PROC_STAT='3', 인라인 서브쿼리 (fn_get_act_stop_emps 대체) */
        IFNULL((
            SELECT GROUP_CONCAT(E.USER_NAME ORDER BY E.USER_NAME, E.USER_ID SEPARATOR ', ')
            FROM (
                SELECT DISTINCT A.PLT_CODE, A.EMP_CODE
                FROM TSHP_ACTUAL A
                WHERE A.PLT_CODE = WO.PLT_CODE AND A.WO_NO = WO.WO_NO AND A.PROC_STAT = '3'
            ) D
            JOIN SYS_USER E ON E.PLT_CODE = D.PLT_CODE AND E.USER_ID = D.EMP_CODE
        ), '')                                                       AS stopEmps,
        /* 작업자(완료) - PROC_STAT='4', 인라인 서브쿼리 (fn_get_act_fin_emps 대체) */
        IFNULL((
            SELECT GROUP_CONCAT(E.USER_NAME ORDER BY E.USER_NAME, E.USER_ID SEPARATOR ', ')
            FROM (
                SELECT DISTINCT A.PLT_CODE, A.EMP_CODE
                FROM TSHP_ACTUAL A
                WHERE A.PLT_CODE = WO.PLT_CODE AND A.WO_NO = WO.WO_NO AND A.PROC_STAT = '4'
            ) D
            JOIN SYS_USER E ON E.PLT_CODE = D.PLT_CODE AND E.USER_ID = D.EMP_CODE
        ), '')                                                       AS finEmps,
        /* 작업자(비가동) - IDLE_STATE='1', 인라인 서브쿼리 (fn_get_idle_ing_emps 대체) */
        IFNULL((
            SELECT GROUP_CONCAT(E.USER_NAME ORDER BY E.USER_NAME, E.USER_ID SEPARATOR ', ')
            FROM (
                SELECT DISTINCT S.PLT_CODE, S.EMP_CODE
                FROM TSHP_IDLETIME S
                WHERE S.PLT_CODE = WO.PLT_CODE AND S.WO_NO = WO.WO_NO AND S.IDLE_STATE = '1'
            ) D
            JOIN SYS_USER E ON E.PLT_CODE = D.PLT_CODE AND E.USER_ID = D.EMP_CODE
        ), '')                                                       AS idleEmps,
        DATE_FORMAT(WO.CONFIRM_DATE, '%Y%m%d%H%i%s')             AS confirmDate,    /* 작업지시확정일 (hidden, datetime→문자열) */
        WO.MC_CODE                                               AS mcCode,         /* 작업장 코드 (hidden) */
        MC.MC_NAME                                               AS mcName,         /* 작업장 (hidden) */
        DATE_FORMAT(WO.ACT_START_TIME, '%Y%m%d%H%i%s')          AS actStartTime,   /* 실적 시작 (hidden) */
        DATE_FORMAT(WO.ACT_END_TIME, '%Y%m%d%H%i%s')            AS actEndTime,     /* 실적 종료 (hidden) */
        IFNULL((SELECT SUM(TIMESTAMPDIFF(MINUTE, ACT_START_TIME, ACT_END_TIME)) FROM TSHP_ACTUAL WHERE PLT_CODE = WO.PLT_CODE AND WO_NO = WO.WO_NO AND ACT_END_TIME IS NOT NULL), 0) AS actSt,          /* 실적 ST(분) - 서브쿼리로 직접 계산 (hidden) */
        WO.WO_FLAG                                               AS woFlag,         /* 상태 */
        WO.BF_PLN_START_TIME                                     AS bfPlnStartTime, /* 이전 계획 시작 (hidden, VARCHAR(12)) */
        WO.BF_PLN_END_TIME                                       AS bfPlnEndTime,   /* 이전 계획 종료 (hidden, VARCHAR(12)) */
        WO.PLN_START_TIME                                        AS plnStartTime,   /* 계획 시작 (VARCHAR(12)) */
        WO.PLN_END_TIME                                          AS plnEndTime,     /* 계획 종료 (VARCHAR(12)) */
        IFNULL(WO.PLN_PROC_TIME, 0)                                  AS plnSt, /* 계획 ST(분) (hidden, AS-IS: WO.PLN_PROC_TIME) */
        PRG.PRG_SEQ                                              AS prgSeq,         /* 공정순서 (hidden) */
        WO.SEQ                                                   AS orderSeq,       /* 판매오더순서 (hidden) */
        MC.MC_FLAG                                               AS mcFlag,         /* 작업장순서 (hidden, AS-IS: MC.MC_FLAG from LSE_MACHINE) */
        MD.PROD_TYPE                                             AS prodType,       /* (hidden, TSTD_MODEL) */
        P.MONTH_WEEK                                             AS indueMonthWeek, /* 생산완료월주차 (hidden) */
        P.ORD_DATE                                               AS ordDate,        /* 수주일 (hidden) */
        SAP.DELIVERY                                             AS delivery,       /* 배송 (hidden) */
        WO.PART_CODE                                             AS banPartCode     /* 반제품코드 (hidden, AS-IS: WO.PART_CODE AS BAN_PART_CODE) */
    FROM TSHP_WORKORDER WO
    /* 수주/제품 정보 */
    LEFT JOIN TORD_PRODUCT P
        ON WO.PLT_CODE = P.PLT_CODE
        AND WO.PROD_CODE = P.PROD_CODE
    /* SAP 출하정보 (수주번호+라인 기준) */
    LEFT JOIN IF_SAP_SHIPINFO SAP
        ON P.ORDER_NO = SAP.ORDER_NO
        AND P.ORDER_LINE = SAP.ORDER_LINE
    /* 설비명 */
    LEFT JOIN LSE_MACHINE MC
        ON WO.PLT_CODE = MC.PLT_CODE
        AND WO.MC_CODE = MC.MC_CODE
    /* 모델명 (AS-IS: MODEL_TYPE + MODEL_SERISE + MODEL_NO, MODEL_CODE 조건 없음) */
    LEFT JOIN TSTD_MODEL MD
        ON P.PLT_CODE = MD.PLT_CODE
        AND P.MODEL_TYPE = MD.MODEL_TYPE
        AND P.MODEL_SERISE = MD.MODEL_SERISE
        AND P.MODEL_NO = MD.MODEL_NO
    /* 공정그룹명 (정렬용 PRG_SEQ 포함) */
    LEFT JOIN TSTD_PROCGRP PRG
        ON WO.PLT_CODE = PRG.PLT_CODE
        AND WO.MPROC_CODE = PRG.PRG_CODE
    /* 공장코드→공장명 변환 (TSTD_CODES P009, AS-IS LookUpEdit P009 대체) */
    /* COLLATE: tstd_codes(utf8mb4_0900_ai_ci) ↔ tshp_workorder(utf8mb4_unicode_ci) */
    LEFT JOIN TSTD_CODES TC
        ON TC.PLT_CODE = WO.PLT_CODE COLLATE utf8mb4_0900_ai_ci
        AND TC.CAT_CODE = 'P009'
        AND TC.CD_CODE = WO.PLANTS COLLATE utf8mb4_0900_ai_ci
        AND TC.DATA_FLAG = 0
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.DATA_FLAG = 0                               /* 하드코딩: 활성 데이터만 */
      AND WO.WO_FLAG <> '0'                              /* 대기 상태('0') 제외 */
      /* ---- 동적 검색 조건 (NULL/빈값이면 무시) ---- */
      AND (p_is_sim IS NULL OR p_is_sim = '' OR WO.IS_SIM = p_is_sim)
      AND (p_order_like IS NULL OR p_order_like = '' OR WO.SAP_WO_NO LIKE CONCAT('%', p_order_like, '%'))
      AND (p_hogi_like IS NULL OR p_hogi_like = '' OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
      AND (p_customer_like IS NULL OR p_customer_like = '' OR SAP.CUSTOMER LIKE CONCAT('%', p_customer_like, '%'))
      AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(WO.PLANTS, p_plants) > 0)
      AND (p_s_due_date IS NULL OR p_s_due_date = '' OR P.DUE_DATE BETWEEN p_s_due_date AND p_e_due_date)
      AND (p_s_indue_date IS NULL OR p_s_indue_date = '' OR P.INDUE_DATE BETWEEN p_s_indue_date AND p_e_indue_date)
      AND (p_s_sap_due_date IS NULL OR p_s_sap_due_date = '' OR P.DUE_DATE BETWEEN p_s_sap_due_date AND p_e_sap_due_date)
      AND (p_s_pln_date IS NULL OR p_s_pln_date = '' OR (LEFT(WO.PLN_START_TIME, 8) BETWEEN p_s_pln_date AND p_e_pln_date OR LEFT(WO.PLN_END_TIME, 8) BETWEEN p_s_pln_date AND p_e_pln_date))
      AND (p_prod_type IS NULL OR p_prod_type = '' OR MD.PROD_TYPE = p_prod_type)
    ORDER BY P.PROD_CODE, PRG.PRG_SEQ, WO.SEQ;
END//

-- ============================================================
-- sp_imes_tshp_workorder_query12: 작업지시 목록 조회 (가공 실적관리)
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY12()
-- 용도: ORD14A 상단 그리드 - 작업지시 목록
-- 사용화면: ORD14A
-- 추가일: 2026-03-06
-- JOIN 구조 (4개 LEFT JOIN):
--   TSHP_WORKORDER W         (작업지시 - 메인)
--     ↔ LSE_STD_PART P       (품목명)
--     ↔ LSE_MACHINE M        (자원명 - MC_CODE)
--     ↔ LSE_MACHINE AM       (최근진행자원명 - ACT_MC_CODE)
--     ↔ TSTD_EMPLOYEE E      (최근진행작업자명 - ACT_EMP_CODE)
-- 파라미터 (7개):
--   p_plt_code    - 공장코드
--   p_order_like  - 오더번호 LIKE (SAP_WO_NO)
--   p_proc_like   - 공정 LIKE (PROC_CODE)
--   p_s_pln_date  - 계획시작일 시작 (YYYYMMDD)
--   p_e_pln_date  - 계획시작일 종료 (YYYYMMDD)
--   p_plants      - 공장(SAP)
--   p_data_flag   - 데이터 구분
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query12//

CREATE PROCEDURE sp_imes_tshp_workorder_query12(
    IN p_plt_code      VARCHAR(3),
    IN p_order_like    VARCHAR(50),
    IN p_proc_like     VARCHAR(50),
    IN p_s_pln_date    VARCHAR(8),
    IN p_e_pln_date    VARCHAR(8),
    IN p_plants        VARCHAR(200),
    IN p_data_flag     VARCHAR(3)
)
BEGIN
    SELECT
        W.PLT_CODE        AS pltCode,
        W.WO_FLAG         AS woFlag,
        W.WO_NO           AS woNo,
        W.SAP_WO_NO       AS sapWoNo,
        W.PART_CODE        AS partCode,
        P.PART_NAME        AS partName,
        W.PROC_CODE        AS procCode,
        W.MC_CODE          AS mcCode,
        M.MC_NAME          AS mcName,
        W.ACT_MC_CODE      AS actMcCode,
        AM.MC_NAME         AS actMcName,
        W.ACT_EMP_CODE     AS actEmpCode,
        E.EMP_NAME         AS actEmpName,
        W.PLN_START_TIME   AS plnStartTime,
        W.PLN_END_TIME     AS plnEndTime,
        DATE_FORMAT(W.ACT_START_TIME, '%Y%m%d%H%i') AS actStartTime,
        DATE_FORMAT(W.ACT_END_TIME, '%Y%m%d%H%i')   AS actEndTime,
        W.WORK_CONTENTS    AS workContents
    FROM TSHP_WORKORDER W
    LEFT JOIN LSE_STD_PART P
        ON W.PLT_CODE = P.PLT_CODE AND W.PART_CODE = P.PART_CODE
    LEFT JOIN LSE_MACHINE M
        ON W.PLT_CODE = M.PLT_CODE AND W.MC_CODE = M.MC_CODE
    LEFT JOIN LSE_MACHINE AM
        ON W.PLT_CODE = AM.PLT_CODE AND W.ACT_MC_CODE = AM.MC_CODE
    LEFT JOIN TSTD_EMPLOYEE E
        ON W.PLT_CODE = E.PLT_CODE AND W.ACT_EMP_CODE = E.EMP_CODE
    WHERE W.PLT_CODE = p_plt_code
      AND (p_order_like IS NULL OR p_order_like = '' OR W.SAP_WO_NO LIKE CONCAT('%', p_order_like, '%'))
      AND (p_proc_like IS NULL OR p_proc_like = '' OR W.PROC_CODE LIKE CONCAT('%', p_proc_like, '%'))
      AND (p_s_pln_date IS NULL OR p_s_pln_date = '' OR LEFT(W.PLN_START_TIME, 8) BETWEEN p_s_pln_date AND p_e_pln_date)
      AND (p_plants IS NULL OR p_plants = '' OR W.PLANTS = p_plants)
      AND (p_data_flag IS NULL OR p_data_flag = '' OR W.DATA_FLAG = p_data_flag);
END//

-- ============================================================
-- sp_imes_tshp_workorder_query32: Tab3 오더완료일 조회 (ORD18A)
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY32
-- WO_FLAG=4(완료) 조건 하드코딩
-- MSSQL→MySQL: ISNULL→IFNULL, CONVERT→DATE_FORMAT, IN @PLANTS→FIND_IN_SET
-- 사용화면: ORD18A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query32//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_query32(
    IN p_plt_code     VARCHAR(10),
    IN p_order_like   VARCHAR(50),
    IN p_sap_wo_like  VARCHAR(50),
    IN p_hogi_like    VARCHAR(50),
    IN p_proc_like    VARCHAR(50),
    IN p_s_wo_date    VARCHAR(8),
    IN p_e_wo_date    VARCHAR(8),
    IN p_plants       VARCHAR(100)
)
BEGIN
    SELECT
        W.PLT_CODE AS "pltCode"
        ,W.PLANTS AS "plants"
        ,W.WO_NO AS "woNo"
        ,W.SAP_WO_NO AS "sapWoNo"
        ,W.WO_SEQ AS "woSeq"
        ,W.PART_CODE AS "partCode"
        ,PT.PART_NAME AS "partName"
        ,W.PROC_CODE AS "procCode"
        ,DATE_FORMAT(W.PLN_START_TIME, '%Y-%m-%d %H:%i:%s') AS "plnStartTime"
        ,DATE_FORMAT(W.PLN_END_TIME, '%Y-%m-%d %H:%i:%s') AS "plnEndTime"
        ,DATE_FORMAT(W.ACT_START_TIME, '%Y-%m-%d %H:%i:%s') AS "actStartTime"
        ,DATE_FORMAT(W.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS "actEndTime"
        ,P.PROD_HOGI AS "prodHogi"
        ,P.CVND_CONTENTS AS "cvndContents"
        ,P.ORDER_NO AS "orderNo"
        ,P.ORDER_LINE AS "orderLine"
    FROM TSHP_WORKORDER W
    LEFT JOIN TORD_PRODUCT P
        ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
    LEFT JOIN LSE_STD_PART PT
        ON W.PLT_CODE = PT.PLT_CODE AND W.PART_CODE = PT.PART_CODE
    WHERE P.PLT_CODE = p_plt_code
        AND W.WO_FLAG = '4'
        AND (p_order_like = '' OR p_order_like IS NULL
             OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
        AND (p_hogi_like = '' OR p_hogi_like IS NULL
             OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
        AND (p_sap_wo_like = '' OR p_sap_wo_like IS NULL
             OR W.SAP_WO_NO LIKE CONCAT('%', p_sap_wo_like, '%'))
        AND (p_proc_like = '' OR p_proc_like IS NULL
             OR W.PROC_CODE LIKE CONCAT('%', p_proc_like, '%'))
        AND (p_s_wo_date = '' OR p_s_wo_date IS NULL
             OR (W.ACT_END_TIME >= STR_TO_DATE(p_s_wo_date, '%Y%m%d')
                 AND W.ACT_END_TIME < DATE_ADD(STR_TO_DATE(p_e_wo_date, '%Y%m%d'), INTERVAL 1 DAY)))
        AND (p_plants = '' OR p_plants IS NULL
             OR FIND_IN_SET(W.PLANTS, p_plants) > 0)
    ORDER BY W.ACT_END_TIME DESC;
END//

-- ============================================================
-- sp_imes_tshp_workorder_query27: 생산오더 일정 조회 (기계별)
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY27()
-- 용도: 기계(MC_CODE)별 또는 전체 공장 기준 작업지시 일정 조회
-- 사용화면: POP30B
-- 추가일: 2026-03-18
-- 파라미터 (7개):
--   p_plt_code      - 공장코드
--   p_plants        - 공장(SAP) 콤마 구분
--   p_mc_code       - 기계코드 (IS_ALL='N'일 때 사용)
--   p_is_all        - 전체 조회 여부 ('Y': PLANTS 기준, 'N': MC_CODE 기준)
--   p_s_plan_time   - 계획시작일 시작 (YYYYMMDD)
--   p_e_plan_time   - 계획시작일 종료 (YYYYMMDD)
--   p_include_done  - 완료(WO_FLAG='4') 포함 여부 ('Y': 포함)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query27//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_query27(
    IN p_plt_code       VARCHAR(3),
    IN p_plants         VARCHAR(200),
    IN p_mc_code        VARCHAR(20),
    IN p_is_all         VARCHAR(1),
    IN p_s_plan_time    VARCHAR(8),
    IN p_e_plan_time    VARCHAR(8),
    IN p_include_done   VARCHAR(1)
)
BEGIN
    SELECT
        W.PLT_CODE        AS pltCode,
        W.WO_NO           AS woNo,
        W.SAP_WO_NO       AS sapWoNo,
        W.WO_SEQ          AS woSeq,
        W.PART_CODE       AS partCode,
        SP.PART_NAME      AS partName,
        W.PROC_CODE       AS procCode,
        W.MC_CODE         AS mcCode,
        M.MC_NAME         AS mcName,
        W.SCOMMENT        AS scomment,
        W.WORK_CONTENTS   AS workContents,
        W.WO_FLAG         AS woFlag,
        (SELECT TA.PANEL_STAT
         FROM TSHP_ACTUAL TA
         WHERE TA.PLT_CODE = W.PLT_CODE
           AND TA.WO_NO = W.WO_NO
         ORDER BY TA.ACT_START_TIME DESC
         LIMIT 1)         AS panelStat,
        W.ACT_EMP_CODE    AS actEmpCode,
        E.USER_NAME       AS actEmpName,
        W.ACT_MC_CODE     AS actMcCode,
        AM.MC_NAME        AS actMcName,
        W.MODEL           AS model,
        W.IS_MAT_CHK      AS isMatChk,
        W.IS_INS_CHK      AS isInsChk,
        W.PRE_WORK        AS preWork,
        W.MCT_VEN_NAME    AS mctVenName
    FROM TSHP_WORKORDER W
    LEFT JOIN LSE_STD_PART SP
        ON W.PLT_CODE = SP.PLT_CODE AND W.PART_CODE = SP.PART_CODE
    LEFT JOIN sys_user E
        ON W.PLT_CODE = E.PLT_CODE AND W.ACT_EMP_CODE = E.USER_ID
    LEFT JOIN LSE_MACHINE M
        ON W.PLT_CODE = M.PLT_CODE AND W.MC_CODE = M.MC_CODE
    LEFT JOIN LSE_MACHINE AM
        ON W.PLT_CODE = AM.PLT_CODE AND W.ACT_MC_CODE = AM.MC_CODE
    WHERE W.PLT_CODE = p_plt_code
      AND W.DATA_FLAG = 0
      /* WO_FLAG 조건: 기본 '1','2','3','5', p_include_done='Y'이면 '4' 포함 */
      AND (
          W.WO_FLAG IN ('1','2','3','5')
          OR (p_include_done = 'Y' AND W.WO_FLAG = '4')
      )
      /* AS-IS 조건 충실 전환 */
      AND (
          /* Case 1: IS_ALL='Y' - 전체 공장, 날짜 범위 필터 */
          (p_is_all = 'Y'
           AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(W.PLANTS, p_plants))
           AND (p_s_plan_time IS NULL OR p_s_plan_time = ''
                OR LEFT(W.PLN_START_TIME, 8) BETWEEN p_s_plan_time AND p_e_plan_time)
          )
          OR
          /* Case 2: IS_ALL='N' (기본) - 기계코드 기준, 날짜 범위 필터 */
          ((p_is_all IS NULL OR p_is_all = '' OR p_is_all = 'N')
           AND (W.MC_CODE = p_mc_code OR W.ACT_MC_CODE = p_mc_code)
           AND (p_s_plan_time IS NULL OR p_s_plan_time = ''
                OR LEFT(W.PLN_START_TIME, 8) BETWEEN p_s_plan_time AND p_e_plan_time)
          )
          OR
          /* Case 3: 시작일 이전 진행중 오더도 표시 (AS-IS 추가 OR 조건) */
          (W.WO_FLAG IN ('1','2','3','5')
           AND LEFT(W.PLN_START_TIME, 8) <= p_s_plan_time
           AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(W.PLANTS, p_plants))
           AND (p_is_all = 'Y' OR W.MC_CODE = p_mc_code OR W.ACT_MC_CODE = p_mc_code)
          )
      )
    ORDER BY W.PLN_START_TIME ASC;
END//

-- ============================================================
-- sp_imes_tshp_workorder_query28: 생산오더 상태별 조회
-- 원본: TSHP_WORKORDER_QUERY.TSHP_WORKORDER_QUERY28()
-- 용도: 공장/상태/작업자 기준 작업지시 목록 조회
-- 사용화면: POP30B
-- 추가일: 2026-03-18
-- 파라미터 (4개):
--   p_plt_code   - 공장코드
--   p_plants     - 공장(SAP) 콤마 구분
--   p_wo_flag    - 작업지시상태
--   p_emp_code   - 작업자코드
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_query28//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_query28(
    IN p_plt_code    VARCHAR(3),
    IN p_plants      VARCHAR(200),
    IN p_wo_flag     VARCHAR(1),
    IN p_emp_code    VARCHAR(20)
)
BEGIN
    SELECT
        W.PLT_CODE        AS pltCode,
        W.WO_NO           AS woNo,
        W.SAP_WO_NO       AS sapWoNo,
        W.WO_SEQ          AS woSeq,
        W.PART_CODE       AS partCode,
        W.PROC_CODE       AS procCode,
        W.MC_CODE         AS mcCode,
        W.SCOMMENT        AS scomment,
        W.WORK_CONTENTS   AS workContents,
        W.WO_FLAG         AS woFlag,
        W.ACT_EMP_CODE    AS actEmpCode,
        W.ACT_MC_CODE     AS actMcCode,
        W.MODEL           AS model,
        W.IS_MAT_CHK      AS isMatChk,
        W.PRE_WORK        AS preWork
    FROM TSHP_WORKORDER W
    WHERE W.PLT_CODE = p_plt_code
      AND W.DATA_FLAG = 0
      AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(W.PLANTS, p_plants))
      AND (p_wo_flag IS NULL OR p_wo_flag = '' OR W.WO_FLAG = p_wo_flag)
      AND (p_emp_code IS NULL OR p_emp_code = '' OR W.ACT_EMP_CODE = p_emp_code);
END//

DELIMITER ;
