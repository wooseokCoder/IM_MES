-- ============================================================
-- TSHP_PART_SHIP_RATE_QUERY 조회 프로시저
-- 생성일: 2026-03-04
-- 대상 테이블: TSHP_PART_SHIP_RATE
-- 원본: ProActive TSHP_PART_SHIP_RATE_QUERY.cs
-- 사용화면: MAT05A
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_part_ship_rate_query1: 불출율 조회
-- 원본: TSHP_PART_SHIP_RATE_QUERY.TSHP_PART_SHIP_RATE_QUERY1()
-- 용도: MAT05A_SER - rateList (MRP_EMP별 불출율)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_part_ship_rate_query1//

CREATE PROCEDURE sp_imes_tshp_part_ship_rate_query1(
    IN p_plants            VARCHAR(200),
    IN p_is_sim            VARCHAR(1),
    IN p_order_no          VARCHAR(50),
    IN p_order_line        VARCHAR(10),
    IN p_s_pln_start_date  VARCHAR(8),
    IN p_e_pln_start_date  VARCHAR(8)
)
BEGIN
    -- AS-IS: 메인/서브 모두 PLT_CODE 필터 없음, SAP_WO_NO 필터 없음
    SELECT
        PLT_CODE      AS pltCode,
        PROD_CODE     AS prodCode,
        ORDER_NO      AS orderNo,
        ORDER_LINE    AS orderLine,
        SAP_WO_NO     AS sapWoNo,
        PART_CODE     AS partCode,
        MRP_EMP       AS mrpEmp,
        PROC_CODE     AS procCode,
        SHIP_RATE     AS shipRate
    FROM TSHP_PART_SHIP_RATE PU
    WHERE PROD_CODE IN (
        SELECT WO.PROD_CODE
        FROM TSHP_WORKORDER WO
        LEFT JOIN TORD_PRODUCT P ON WO.PLT_CODE = P.PLT_CODE AND WO.PROD_CODE = P.PROD_CODE
        WHERE 1=1
          AND (p_plants IS NULL OR p_plants = '' OR FIND_IN_SET(WO.PLANTS, p_plants))
          AND (p_is_sim IS NULL OR p_is_sim = '' OR WO.IS_SIM = p_is_sim)
          AND (p_order_no IS NULL OR p_order_no = '' OR P.ORDER_NO = p_order_no)
          AND (p_order_line IS NULL OR p_order_line = '' OR P.ORDER_LINE = p_order_line)
          AND (p_s_pln_start_date IS NULL OR p_s_pln_start_date = ''
               OR LEFT(WO.PLN_START_TIME, 8) BETWEEN p_s_pln_start_date AND p_e_pln_start_date)
      );
END//

DELIMITER ;
