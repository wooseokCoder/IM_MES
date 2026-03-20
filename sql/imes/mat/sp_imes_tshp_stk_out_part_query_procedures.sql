-- ============================================================
-- TSHP_STK_OUT_PART_QUERY 조회 프로시저
-- 생성일: 2026-03-04
-- 대상 테이블: TSHP_STK_OUT + TSHP_STK_OUT_PART + TSHP_PART_USE
-- 원본: ProActive TSHP_STK_OUT_PART_QUERY.cs
-- 사용화면: MAT05A
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_stk_out_part_query1: 불출율 계산용 불출건 조회
-- 원본: TSHP_STK_OUT_PART_QUERY.TSHP_STK_OUT_PART_QUERY1()
-- 용도: 불출율 분자 (제외 코드 필터 적용, OUT_FLAG='1' 카운트)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_part_query1//

CREATE PROCEDURE sp_imes_tshp_stk_out_part_query1(
    IN p_plt_code    VARCHAR(3),
    IN p_stk_out_no  VARCHAR(50)
)
BEGIN
    SELECT
        SO.PLT_CODE          AS pltCode,
        SO.STK_OUT_NO        AS stkOutNo,
        SOP.STK_OUT_PART_NO  AS stkOutPartNo,
        SOP.PART_CODE        AS partCode,
        SOP.OUT_FLAG         AS outFlag
    FROM TSHP_STK_OUT SO
    LEFT JOIN TSHP_STK_OUT_PART SOP
        ON SO.PLT_CODE = SOP.PLT_CODE
       AND SO.STK_OUT_NO = SOP.STK_OUT_NO
    LEFT JOIN TSHP_PART_USE PU
        ON SO.PLT_CODE = PU.PLT_CODE
       AND SO.PROD_CODE = PU.PROD_CODE
       AND SO.SAP_WO_NO = PU.SAP_WO_NO
       AND SO.PROC_CODE = PU.PROC_CODE
       AND SO.MRP_EMP = PU.MRP_EMP
       AND SOP.PART_CODE = PU.PART_SPEC
    WHERE SO.PLT_CODE = p_plt_code
      AND (p_stk_out_no IS NULL OR p_stk_out_no = '' OR SO.STK_OUT_NO = p_stk_out_no)
      AND IFNULL(SO.MRP_EMP, '') NOT IN (SELECT CD_NAME FROM TSTD_CODES WHERE CAT_CODE = 'A002' AND VALUE = 'MRP_EMP')
      AND IFNULL(PU.MVND_CODE, '') NOT IN (SELECT CD_NAME FROM TSTD_CODES WHERE CAT_CODE = 'A002' AND VALUE = 'MVND_CODE')
      AND IFNULL(SO.PROC_CODE, '') NOT IN (SELECT CD_NAME FROM TSTD_CODES WHERE CAT_CODE = 'A002' AND VALUE = 'PROC_CODE')
      AND (PU.STK_USE_QTY > 0 OR PU.SHIP_QTY > 0);
END//

DELIMITER ;
