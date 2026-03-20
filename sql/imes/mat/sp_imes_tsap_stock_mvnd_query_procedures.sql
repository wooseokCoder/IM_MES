-- ============================================================================
-- 파일명: sp_imes_tsap_stock_mvnd_query_procedures.sql
-- 설명: 재고정보 조회 - 공급업체 특별재고 (TSAP_STOCK_MVND 테이블)
-- 원본: ProActive TSAP_STOCK_MVND_QUERY.cs
-- 작성일: 2026-03-03
-- ============================================================================

-- ============================================================================
-- sp_imes_tsap_stock_mvnd_query1
-- 용도: MAT02A 공급업체 특별재고 조회
-- 원본: TSAP_STOCK_MVND_QUERY.TSAP_STOCK_MVND_QUERY1
--
-- AS-IS SQL:
--   SELECT S.PART_CODE, S.PART_NAME, S.PLANTS, S.STK_LOC,
--          S.QTY, S.QINS_FLAG, S.PART_UNIT,
--          S.BATCH_NO, S.STOCK_EMP, S.MVND_CODE, S.MVND_NAME
--   FROM TSAP_STOCK_MVND S
--   WHERE (S.PART_CODE LIKE '%' + @PART_LIKE + '%'
--      OR S.PART_NAME LIKE '%' + @PART_LIKE + '%')
--   AND CONVERT(DECIMAL, QTY) > 0
--
-- 변환 사항:
--   - '%' + @PART_LIKE + '%' → CONCAT('%', p_part_like, '%')
--   - CONVERT(DECIMAL, QTY) → CAST(S.QTY AS DECIMAL)
--   - hinsFlag: MVND 타입에는 없음 → NULL
--   - IS_FILE: IF_PLM_FILE_INFO LEFT JOIN (도면 여부 확인)
-- ============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_tsap_stock_mvnd_query1//

CREATE PROCEDURE sp_imes_tsap_stock_mvnd_query1(
    IN p_plt_code   VARCHAR(10),   -- 세션 공장코드 (현재 SQL 미사용)
    IN p_part_like  VARCHAR(100)   -- 자재번호/명 LIKE 검색어
)
BEGIN
    SELECT
         '공급업체 특별재고'                                    AS stockType
        ,S.PART_CODE                                            AS partCode
        ,S.PART_NAME                                            AS partName
        ,S.PLANTS                                               AS plants
        ,S.STK_LOC                                              AS bin
        ,S.QTY                                                  AS qty
        ,S.QINS_FLAG                                            AS qinsFlag
        ,NULL                                                   AS hinsFlag
        ,S.PART_UNIT                                            AS partUnit
        ,S.BATCH_NO                                             AS batchNo
        ,S.STOCK_EMP                                            AS stockEmp
        ,NULL                                                   AS orderNo
        ,NULL                                                   AS orderLine
        ,NULL                                                   AS cvndCode
        ,NULL                                                   AS cvndName
        ,S.MVND_CODE                                            AS mvndCode
        ,S.MVND_NAME                                            AS mvndName
        ,CASE WHEN FI.ORD_NO IS NOT NULL THEN '1' ELSE '0' END AS isFile
    FROM TSAP_STOCK_MVND S
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
