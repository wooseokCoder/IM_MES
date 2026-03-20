-- ============================================================================
-- 파일명: sp_imes_tsap_stock_comm_query_procedures.sql
-- 설명: 재고정보 조회 - 일반재고 (TSAP_STOCK_COMM 테이블)
-- 원본: ProActive TSAP_STOCK_COMM_QUERY.cs
-- 작성일: 2026-03-03
-- ============================================================================

-- ============================================================================
-- sp_imes_tsap_stock_comm_query1
-- 용도: MAT02A 일반재고 조회
-- 원본: TSAP_STOCK_COMM_QUERY.TSAP_STOCK_COMM_QUERY1
--
-- AS-IS SQL:
--   SELECT S.PART_CODE, S.PART_NAME, S.PLANTS, S.BIN,
--          S.QTY, S.QINS_FLAG, S.HINS_FLAG, S.PART_UNIT
--   FROM TSAP_STOCK_COMM S
--   WHERE S.PART_CODE LIKE '%' + @PART_LIKE + '%'
--      OR S.PART_NAME LIKE '%' + @PART_LIKE + '%'
--   AND CONVERT(DECIMAL, QTY) > 0
--
-- 변환 사항:
--   - '%' + @PART_LIKE + '%' → CONCAT('%', p_part_like, '%')
--   - CONVERT(DECIMAL, QTY) → CAST(S.QTY AS DECIMAL)
--   - IS_FILE: IF_PLM_FILE_INFO LEFT JOIN (도면 여부 확인)
-- ============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_tsap_stock_comm_query1//

CREATE PROCEDURE sp_imes_tsap_stock_comm_query1(
    IN p_plt_code   VARCHAR(10),   -- 세션 공장코드 (현재 SQL 미사용)
    IN p_part_like  VARCHAR(100)   -- 자재번호/명 LIKE 검색어
)
BEGIN
    SELECT
         '일반재고'                                              AS stockType
        ,S.PART_CODE                                            AS partCode
        ,S.PART_NAME                                            AS partName
        ,S.PLANTS                                               AS plants
        ,S.BIN                                                  AS bin
        ,S.QTY                                                  AS qty
        ,S.QINS_FLAG                                            AS qinsFlag
        ,S.HINS_FLAG                                            AS hinsFlag
        ,S.PART_UNIT                                            AS partUnit
        ,NULL                                                   AS batchNo
        ,NULL                                                   AS stockEmp
        ,NULL                                                   AS orderNo
        ,NULL                                                   AS orderLine
        ,NULL                                                   AS cvndCode
        ,NULL                                                   AS cvndName
        ,NULL                                                   AS mvndCode
        ,NULL                                                   AS mvndName
        ,CASE WHEN FI.ORD_NO IS NOT NULL THEN '1' ELSE '0' END AS isFile
    FROM TSAP_STOCK_COMM S
    LEFT JOIN (
        SELECT ORD_NO FROM IF_PLM_FILE_INFO
        WHERE CAT_CODE = '2'
        GROUP BY ORD_NO
    ) FI ON S.PART_CODE = FI.ORD_NO
    WHERE (p_part_like IS NULL OR p_part_like = ''
           OR S.PART_CODE LIKE CONCAT('%', p_part_like, '%')
           OR S.PART_NAME LIKE CONCAT('%', p_part_like, '%'))
      AND CAST(S.QTY AS DECIMAL) > 0
    ORDER BY S.PART_CODE, S.PART_NAME;
END //

DELIMITER ;
