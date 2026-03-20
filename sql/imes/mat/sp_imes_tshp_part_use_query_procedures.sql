-- ============================================================
-- TSHP_PART_USE_QUERY 조회 프로시저
-- 생성일: 2026-03-04
-- 대상 테이블: TSHP_PART_USE (+ JOIN)
-- 원본: ProActive TSHP_PART_USE_QUERY.cs
-- 사용화면: MAT05A
-- ============================================================
-- 명명 규칙: sp_imes_tshp_part_use_[쿼리명]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_part_use_query3: 소요자재 디테일 조회
-- 원본: TSHP_PART_USE_QUERY.TSHP_PART_USE_QUERY3()
-- 용도: Tab1 디테일 그리드 (MAT05A_SER2)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_part_use_query3//

CREATE PROCEDURE sp_imes_tshp_part_use_query3(
    IN p_plt_code     VARCHAR(3),
    IN p_sap_wo_no    VARCHAR(50),
    IN p_order_no     VARCHAR(50),
    IN p_order_line   VARCHAR(10),
    IN p_part_code    VARCHAR(50),
    IN p_mrp_emp_in   VARCHAR(500)
)
BEGIN
    SELECT
        PU.PLT_CODE          AS pltCode,
        PU.SAP_WO_NO         AS sapWoNo,
        PU.PROD_CODE         AS prodCode,
        PU.ORDER_NO          AS orderNo,
        PU.ORDER_LINE        AS orderLine,
        PU.PART_CODE         AS partCode,
        PU.PART_SPEC         AS partSpec,
        SP.PART_NAME         AS partName,
        PU.PROC_CODE         AS procCode,
        PU.USE_QTY           AS useQty,
        PU.SHIP_QTY          AS shipQty,
        PU.STK_USE_QTY       AS stkUseQty,
        PU.STK_INS_QTY       AS stkInsQty,
        PU.STK_VND_QTY       AS stkVndQty,
        PU.IS_MAT            AS isMat,
        PU.IS_SHIP           AS isShip,
        SOP.OUT_FLAG         AS outFlag,
        PU.YPGO_PLAN_DATE    AS ypgoPlanDate,
        PU.MVND_NAME         AS mvndName,
        PU.MRP_EMP           AS mrpEmp,
        PU.MRP_EMP_NAME      AS mrpEmpName,
        PU.BIN               AS bin,
        PU.LASS_F_CAUSE      AS lassFCause,
        PU.LASS_F            AS lassF,
        CASE WHEN EXISTS (
            SELECT 1 FROM IF_PLM_FILE_INFO WHERE CAT_CODE = '2' AND ORD_NO = PU.PART_SPEC
        ) THEN '1' ELSE '0' END AS isFile,
        P.PROD_HOGI          AS prodHogi,
        SH.CUSTOMER          AS customer,
        W.PLN_START_TIME     AS plnStartTime
    FROM TSHP_PART_USE PU
    LEFT JOIN LSE_STD_PART SP
        ON PU.PLT_CODE = SP.PLT_CODE
       AND PU.PART_SPEC = SP.PART_CODE
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
    LEFT JOIN TORD_PRODUCT P
        ON PU.PLT_CODE = P.PLT_CODE
       AND PU.PROD_CODE = P.PROD_CODE
    LEFT JOIN IF_SAP_SHIPINFO SH
        ON P.ORDER_NO = SH.ORDER_NO
       AND P.ORDER_LINE = SH.ORDER_LINE
    LEFT JOIN TSHP_WORKORDER W
        ON PU.PLT_CODE = W.PLT_CODE
       AND P.PROD_CODE = W.PROD_CODE
       AND PU.SAP_WO_NO = W.SAP_WO_NO
       AND PU.PROC_CODE = W.MPROC_CODE
       AND W.WO_SEQ = '10'
    WHERE PU.PLT_CODE = p_plt_code
      AND (p_sap_wo_no IS NULL OR p_sap_wo_no = '' OR PU.SAP_WO_NO = p_sap_wo_no)
      AND (p_order_no IS NULL OR p_order_no = '' OR PU.ORDER_NO = p_order_no)
      AND (p_order_line IS NULL OR p_order_line = '' OR PU.ORDER_LINE = p_order_line)
      AND (p_part_code IS NULL OR p_part_code = '' OR PU.PART_CODE = p_part_code)
      AND (p_mrp_emp_in IS NULL OR p_mrp_emp_in = '' OR FIND_IN_SET(PU.MRP_EMP, p_mrp_emp_in) > 0)
    ORDER BY PU.MRP_EMP, PU.PART_SPEC;
END//

-- ============================================================
-- sp_imes_tshp_part_use_query4: MRP 담당자 목록 조회
-- 원본: TSHP_PART_USE_QUERY.TSHP_PART_USE_QUERY4()
-- 용도: Tab1 동적 MRP_EMP 컬럼 (MAT05A_SER - empList)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_part_use_query4//

CREATE PROCEDURE sp_imes_tshp_part_use_query4(
    IN p_plants            VARCHAR(200),
    IN p_is_sim            VARCHAR(1),
    IN p_order_no          VARCHAR(50),
    IN p_order_line        VARCHAR(10),
    IN p_s_pln_start_date  VARCHAR(8),
    IN p_e_pln_start_date  VARCHAR(8)
)
BEGIN
    -- AS-IS: 메인/서브 모두 PLT_CODE 필터 없음
    SELECT
        PU.MRP_EMP AS mrpEmp
    FROM TSHP_PART_USE PU
    WHERE PU.PROD_CODE IN (
        SELECT WO.PROD_CODE
        FROM TSHP_WORKORDER WO
        LEFT JOIN TORD_PRODUCT P ON WO.PLT_CODE = P.PLT_CODE AND WO.PROD_CODE = P.PROD_CODE
        WHERE 1=1
          AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(WO.PLANTS, p_plants))
          AND (p_is_sim IS NULL OR p_is_sim = '' OR WO.IS_SIM = p_is_sim)
          AND (p_order_no IS NULL OR p_order_no = '' OR P.ORDER_NO = p_order_no)
          AND (p_order_line IS NULL OR p_order_line = '' OR P.ORDER_LINE = p_order_line)
          AND (p_s_pln_start_date IS NULL OR p_s_pln_start_date = ''
               OR (WO.PLN_START_TIME >= CONCAT(p_s_pln_start_date, '0000')
                   AND WO.PLN_START_TIME < CONCAT(DATE_FORMAT(STR_TO_DATE(p_e_pln_start_date, '%Y%m%d') + INTERVAL 1 DAY, '%Y%m%d'), '0000')))
    )
      AND PU.MRP_EMP IS NOT NULL
    GROUP BY PU.MRP_EMP
    ORDER BY PU.MRP_EMP;
END//

-- ============================================================
-- sp_imes_tshp_part_use_query5: 담당자 목록 (D0A용)
-- 원본: TSHP_PART_USE_QUERY.TSHP_PART_USE_QUERY5()
-- 용도: MAT05A_SER3 - D0A 다이얼로그 담당자 그리드
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_part_use_query5//

CREATE PROCEDURE sp_imes_tshp_part_use_query5(
    IN p_plt_code    VARCHAR(3),
    IN p_sap_wo_no   VARCHAR(50),
    IN p_order_no    VARCHAR(50),
    IN p_order_line  VARCHAR(10),
    IN p_part_code   VARCHAR(50)
)
BEGIN
    SELECT
        PU.PLT_CODE      AS pltCode,
        PU.MRP_EMP       AS mrpEmp,
        PU.MRP_EMP_NAME  AS mrpEmpName
    FROM TSHP_PART_USE PU
    WHERE PU.PLT_CODE = p_plt_code
      AND (p_sap_wo_no IS NULL OR p_sap_wo_no = '' OR PU.SAP_WO_NO = p_sap_wo_no)
      AND (p_order_no IS NULL OR p_order_no = '' OR PU.ORDER_NO = p_order_no)
      AND (p_order_line IS NULL OR p_order_line = '' OR PU.ORDER_LINE = p_order_line)
      AND (p_part_code IS NULL OR p_part_code = '' OR PU.PART_CODE = p_part_code)
    GROUP BY PU.PLT_CODE, PU.MRP_EMP, PU.MRP_EMP_NAME
    ORDER BY PU.MRP_EMP;
END//

-- ============================================================
-- sp_imes_tshp_part_use_query6: 자재 상세 (D0A/D1A 자재 목록)
-- 원본: TSHP_PART_USE_QUERY.TSHP_PART_USE_QUERY6()
-- 용도: MAT05A_SER4 - D0A/D1A 다이얼로그 자재 그리드
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_part_use_query6//

CREATE PROCEDURE sp_imes_tshp_part_use_query6(
    IN p_plt_code       VARCHAR(3),
    IN p_sap_wo_no      VARCHAR(50),
    IN p_order_no       VARCHAR(50),
    IN p_order_line     VARCHAR(10),
    IN p_part_code      VARCHAR(50),
    IN p_mrp_emp        VARCHAR(50),
    IN p_mrp_emp_name   VARCHAR(100),
    IN p_stk_out_no     VARCHAR(50),
    IN p_out_flag       VARCHAR(1)
)
BEGIN
    SET @sql = CONCAT(
        'SELECT '
        ,'PU.PLT_CODE AS pltCode'
        ,',PU.PROD_CODE AS prodCode'
        ,',PU.ORDER_NO AS orderNo'
        ,',PU.ORDER_LINE AS orderLine'
        ,',PU.PART_CODE AS partCode'
        ,',PU.PART_SPEC AS partSpec'
        ,',SP.PART_NAME AS partName'
        ,',PU.PROC_CODE AS procCode'
        ,',PU.USE_QTY AS useQty'
        ,',PU.SHIP_QTY AS shipQty'
        ,',PU.STK_USE_QTY AS stkUseQty'
        ,',PU.STK_INS_QTY AS stkInsQty'
        ,',PU.STK_VND_QTY AS stkVndQty'
        ,',PU.IS_MAT AS isMat'
        ,',PU.IS_SHIP AS isShip'
        ,',PU.YPGO_PLAN_DATE AS ypgoPlanDate'
        ,',PU.MVND_NAME AS mvndName'
        ,',PU.MRP_EMP AS mrpEmp'
        ,',PU.MRP_EMP_NAME AS mrpEmpName'
        ,',PU.BIN AS bin'
        ,',SO.STK_OUT_NO AS stkOutNo'
        ,',SOP.STK_OUT_PART_NO AS stkOutPartNo'
        ,',SOP.OUT_FLAG AS outFlag'
        ,' FROM TSHP_PART_USE PU'
        ,' LEFT JOIN LSE_STD_PART SP'
        ,'   ON PU.PLT_CODE = SP.PLT_CODE'
        ,'  AND PU.PART_SPEC = SP.PART_CODE'
        ,' LEFT JOIN TSHP_STK_OUT SO'
        ,'   ON PU.PLT_CODE = SO.PLT_CODE'
        ,'  AND PU.PROD_CODE = SO.PROD_CODE'
        ,'  AND PU.SAP_WO_NO = SO.SAP_WO_NO'
        ,'  AND PU.PROC_CODE = SO.PROC_CODE'
        ,'  AND PU.MRP_EMP = SO.MRP_EMP'
        ,' LEFT JOIN TSHP_STK_OUT_PART SOP'
        ,'   ON SO.PLT_CODE = SOP.PLT_CODE'
        ,'  AND SO.STK_OUT_NO = SOP.STK_OUT_NO'
        ,'  AND PU.PART_SPEC = SOP.PART_CODE'
        ,' WHERE PU.PLT_CODE = ', QUOTE(p_plt_code)
    );

    IF p_sap_wo_no IS NOT NULL AND p_sap_wo_no != '' THEN
        SET @sql = CONCAT(@sql, ' AND PU.SAP_WO_NO = ', QUOTE(p_sap_wo_no));
    END IF;
    IF p_order_no IS NOT NULL AND p_order_no != '' THEN
        SET @sql = CONCAT(@sql, ' AND PU.ORDER_NO = ', QUOTE(p_order_no));
    END IF;
    IF p_order_line IS NOT NULL AND p_order_line != '' THEN
        SET @sql = CONCAT(@sql, ' AND PU.ORDER_LINE = ', QUOTE(p_order_line));
    END IF;
    IF p_part_code IS NOT NULL AND p_part_code != '' THEN
        SET @sql = CONCAT(@sql, ' AND PU.PART_CODE = ', QUOTE(p_part_code));
    END IF;
    IF p_mrp_emp IS NOT NULL AND p_mrp_emp != '' THEN
        SET @sql = CONCAT(@sql, ' AND PU.MRP_EMP = ', QUOTE(p_mrp_emp));
    END IF;
    IF p_mrp_emp_name IS NOT NULL AND p_mrp_emp_name != '' THEN
        SET @sql = CONCAT(@sql, ' AND PU.MRP_EMP_NAME = ', QUOTE(p_mrp_emp_name));
    END IF;
    IF p_stk_out_no IS NOT NULL AND p_stk_out_no != '' THEN
        SET @sql = CONCAT(@sql, ' AND SO.STK_OUT_NO = ', QUOTE(p_stk_out_no));
    END IF;
    IF p_out_flag IS NOT NULL AND p_out_flag != '' THEN
        SET @sql = CONCAT(@sql, ' AND SOP.OUT_FLAG = ', QUOTE(p_out_flag));
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- ============================================================
-- sp_imes_tshp_part_use_query8: 불출율 계산용 기준 건수
-- 원본: TSHP_PART_USE_QUERY.TSHP_PART_USE_QUERY8()
-- 용도: 불출율 분모 (제외 코드 필터 적용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_part_use_query8//

CREATE PROCEDURE sp_imes_tshp_part_use_query8(
    IN p_plt_code    VARCHAR(3),
    IN p_sap_wo_no   VARCHAR(50),
    IN p_order_no    VARCHAR(50),
    IN p_order_line  VARCHAR(10),
    IN p_part_code   VARCHAR(50),
    IN p_mrp_emp     VARCHAR(50)
)
BEGIN
    SELECT
        PU.PLT_CODE      AS pltCode,
        PU.PROD_CODE     AS prodCode,
        PU.ORDER_NO      AS orderNo,
        PU.ORDER_LINE    AS orderLine,
        PU.PART_CODE     AS partCode,
        PU.PART_SPEC     AS partSpec,
        PU.PROC_CODE     AS procCode,
        PU.USE_QTY       AS useQty,
        PU.SHIP_QTY      AS shipQty,
        PU.STK_USE_QTY   AS stkUseQty,
        PU.STK_INS_QTY   AS stkInsQty,
        PU.STK_VND_QTY   AS stkVndQty,
        PU.IS_MAT        AS isMat,
        PU.IS_SHIP       AS isShip,
        PU.YPGO_PLAN_DATE AS ypgoPlanDate,
        PU.MVND_NAME     AS mvndName,
        PU.MRP_EMP       AS mrpEmp,
        PU.MRP_EMP_NAME  AS mrpEmpName
    FROM TSHP_PART_USE PU
    WHERE PU.PLT_CODE = p_plt_code
      AND (p_sap_wo_no IS NULL OR p_sap_wo_no = '' OR PU.SAP_WO_NO = p_sap_wo_no)
      AND (p_order_no IS NULL OR p_order_no = '' OR PU.ORDER_NO = p_order_no)
      AND (p_order_line IS NULL OR p_order_line = '' OR PU.ORDER_LINE = p_order_line)
      AND (p_part_code IS NULL OR p_part_code = '' OR PU.PART_CODE = p_part_code)
      AND (p_mrp_emp IS NULL OR p_mrp_emp = '' OR PU.MRP_EMP = p_mrp_emp)
      AND IFNULL(PU.MRP_EMP, '') NOT IN (SELECT CD_NAME FROM TSTD_CODES WHERE CAT_CODE = 'A002' AND VALUE = 'MRP_EMP')
      AND IFNULL(PU.MVND_CODE, '') NOT IN (SELECT CD_NAME FROM TSTD_CODES WHERE CAT_CODE = 'A002' AND VALUE = 'MVND_CODE')
      AND IFNULL(PU.PROC_CODE, '') NOT IN (SELECT CD_NAME FROM TSTD_CODES WHERE CAT_CODE = 'A002' AND VALUE = 'PROC_CODE')
      AND (PU.STK_USE_QTY > 0 OR PU.SHIP_QTY > 0);
END//

DELIMITER ;
