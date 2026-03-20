-- ============================================================================
-- 파일명: sp_imes_tsap_more_less_query_procedures.sql
-- 설명: 과부족정보 조회 프로시저 (TSAP_MORE_LESS 테이블)
-- 원본: ProActive TSAP_MORE_LESS_QUERY.cs
-- 작성일: 2026-03-03
-- ============================================================================

-- ============================================================================
-- sp_imes_tsap_more_less_query2
-- 용도: MAT01A 메인 조회 (과부족정보)
-- 원본: TSAP_MORE_LESS_QUERY.TSAP_MORE_LESS_QUERY2
--
-- AS-IS SQL:
--   SELECT ML.*, P.INDUE_DATE
--   FROM TSAP_MORE_LESS ML
--   LEFT JOIN TORD_PRODUCT P ON ML.ORDER_NO = P.ORDER_NO
--     AND ML.ORDER_LINE = P.ORDER_LINE AND P.DATA_FLAG = '0'
--   WHERE ML.ORDER_NO LIKE '%' + @ORDER_LIKE + '%'
--     AND ML.PART_SPEC LIKE '%' + @PART_LIKE + '%'
--     AND P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE
--     AND ML.PLANTS IN @PLANTS
--     AND ML.ORDER_NO IS NOT NULL
--   ORDER BY ML.ORDER_NO, ML.ORDER_LINE, ML.SAP_WO_NO
--
-- 변환 사항:
--   - CONVERT(INT, SUBSTRING(LASS_F, 0, CHARINDEX('.', LASS_F)))
--     → CAST(FLOOR(CAST(ML.LASS_F AS DECIMAL(20,4))) AS SIGNED)
--   - '%' + @param + '%' → CONCAT('%', p_param, '%')
--   - ML.PLANTS IN @PLANTS → FIND_IN_SET(ML.PLANTS, p_plants)
-- ============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_tsap_more_less_query2//

CREATE PROCEDURE sp_imes_tsap_more_less_query2(
    IN p_plt_code       VARCHAR(10),
    IN p_order_like     VARCHAR(100),
    IN p_part_like      VARCHAR(100),
    IN p_s_indue_date   VARCHAR(10),
    IN p_e_indue_date   VARCHAR(10),
    IN p_plants         VARCHAR(500)
)
BEGIN
    SELECT
         ML.ORDER_NO                AS orderNo
        ,ML.ORDER_LINE              AS orderLine
        ,ML.PLANTS                  AS plants
        ,ML.GUBUN                   AS gubun
        ,ML.LASS_TYPE               AS lassType
        ,ML.MODEL                   AS model
        ,ML.HOGI                    AS hogi
        ,ML.CVND_CODE               AS cvndCode
        ,ML.CVND_NAME               AS cvndName
        ,ML.ORD_DATE                AS ordDate
        ,P.INDUE_DATE               AS indueDate
        ,ML.DUE_DATE                AS dueDate
        ,ML.PLAN_MONTH              AS planMonth
        ,ML.ASSY_DATE               AS assyDate
        ,ML.SUB_DATE                AS subDate
        ,ML.PART_NAME               AS partName
        ,ML.SAP_WO_NO               AS sapWoNo
        ,ML.BAN_PART_CODE           AS banPartCode
        ,ML.BAN_PART_NAME           AS banPartName
        ,ML.MRP_EMP                 AS mrpEmp
        ,ML.MRP_EMP_NAME            AS mrpEmpName
        ,ML.PART_SPEC               AS partSpec
        ,ML.PRJ_NAME                AS prjName
        ,ML.BIN                     AS bin
        ,ML.TOT_QTY                 AS totQty
        ,ML.SHIP_QTY                AS shipQty
        ,ML.USE_QTY                 AS useQty
        ,ML.STK_USE_QTY             AS stkUseQty
        ,CAST(FLOOR(CAST(ML.LASS_F AS DECIMAL(20,4))) AS SIGNED) AS lassF
        ,ML.LASS_F_CAUSE            AS lassFCause
        ,ML.MVND_CODE               AS mvndCode
        ,ML.MVND_NAME               AS mvndName
        ,ML.PROC_NAME               AS procName
        ,ML.PROC_CODE               AS procCode
        ,ML.YPGO_PLAN_QTY           AS ypgoPlanQty
        ,ML.YPGO_PLAN_DATE          AS ypgoPlanDate
        ,ML.STK_VND_QTY             AS stkVndQty
        ,ML.STK_SUM_QTY             AS stkSumQty
        ,ML.PLAN_DUE_DATE           AS planDueDate
        ,ML.STK_NON_QTY             AS stkNonQty
        ,ML.IN_BOUND_QTY            AS inBoundQty
        ,ML.NO_BAL_QTY              AS noBalQty
        ,ML.NO_IN_QTY               AS noInQty
        ,ML.PART_EMP                AS partEmp
        ,ML.SUPPLY_VND              AS supplyVnd
        ,ML.SUPPLY_VND_NAME         AS supplyVndName
    FROM TSAP_MORE_LESS ML
    LEFT JOIN TORD_PRODUCT P
        ON ML.ORDER_NO = P.ORDER_NO
        AND ML.ORDER_LINE = P.ORDER_LINE
        AND P.DATA_FLAG = '0'
    WHERE ML.ORDER_NO IS NOT NULL
        AND (p_order_like IS NULL OR p_order_like = ''
             OR ML.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
        AND (p_part_like IS NULL OR p_part_like = ''
             OR ML.PART_SPEC LIKE CONCAT('%', p_part_like, '%'))
        AND P.INDUE_DATE BETWEEN p_s_indue_date AND p_e_indue_date
        AND (p_plants IS NULL OR p_plants = ''
             OR FIND_IN_SET(ML.PLANTS, p_plants))
    ORDER BY ML.ORDER_NO, ML.ORDER_LINE, ML.SAP_WO_NO;
END //

DELIMITER ;
