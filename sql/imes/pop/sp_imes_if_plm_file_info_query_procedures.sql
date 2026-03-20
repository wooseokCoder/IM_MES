-- ============================================================================
-- 파일명: sp_imes_if_plm_file_info_query_procedures.sql
-- 설명: PLM 파일 정보 조회 (IF_PLM_FILE_INFO 테이블)
-- 원본: ProActive IF_PLM_FILE_INFO_QUERY.cs (namespace: DIF)
-- 작성일: 2026-03-03
-- ============================================================================

-- ============================================================================
-- sp_imes_if_plm_file_info_query1
-- 용도: PLM 도면 파일 목록 조회
-- 원본: IF_PLM_FILE_INFO_QUERY.IF_PLM_FILE_INFO_QUERY1
--
-- AS-IS SQL:
--   SELECT PLT_CODE, IF_CODE, CAT_CODE, ORD_NO, LINE_NO, REV_NO,
--          FILE_NAME, FILE_SIZE, SAVE_PATH, REG_DATE
--   FROM IF_PLM_FILE_INFO
--   WHERE PLT_CODE  = @PLT_CODE   (선택)
--     AND CAT_CODE  = @CAT_CODE   (선택)
--     AND ORD_NO    = @ORD_NO     (선택)
--     AND LINE_NO   = @LINE_NO    (선택)
--     AND PROC_STAT = @PROC_STAT  (선택)
--   GROUP BY PLT_CODE, IF_CODE, CAT_CODE, ORD_NO, LINE_NO, REV_NO,
--            FILE_NAME, FILE_SIZE, SAVE_PATH, REG_DATE
--   ORDER BY REV_NO DESC
--
-- MAT02A 호출 시: PLT_CODE='3603', CAT_CODE='2', ORD_NO=PART_CODE
-- ============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_if_plm_file_info_query1//

CREATE PROCEDURE sp_imes_if_plm_file_info_query1(
    IN p_plt_code   VARCHAR(10),   -- 공장코드 (MAT02A: '3603' 고정)
    IN p_cat_code   VARCHAR(10),   -- 카테고리 코드 (MAT02A: '2' = 도면)
    IN p_ord_no     VARCHAR(100),  -- 자재번호 (PART_CODE)
    IN p_line_no    VARCHAR(10),   -- 라인번호 (선택)
    IN p_proc_stat  VARCHAR(10)    -- 처리상태 (선택)
)
BEGIN
    SELECT
         PLT_CODE   AS pltCode
        ,IF_CODE    AS ifCode
        ,CAT_CODE   AS catCode
        ,ORD_NO     AS ordNo
        ,LINE_NO    AS lineNo
        ,REV_NO     AS revNo
        ,FILE_NAME  AS fileName
        ,FILE_SIZE  AS fileSize
        ,SAVE_PATH  AS savePath
        ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate
    FROM IF_PLM_FILE_INFO
    WHERE (p_plt_code  IS NULL OR p_plt_code  = '' OR PLT_CODE  = p_plt_code)
      AND (p_cat_code  IS NULL OR p_cat_code  = '' OR CAT_CODE  = p_cat_code)
      AND (p_ord_no    IS NULL OR p_ord_no    = '' OR ORD_NO    = p_ord_no)
      AND (p_line_no   IS NULL OR p_line_no   = '' OR LINE_NO   = p_line_no)
      AND (p_proc_stat IS NULL OR p_proc_stat = '' OR PROC_STAT = p_proc_stat)
    GROUP BY PLT_CODE, IF_CODE, CAT_CODE, ORD_NO, LINE_NO, REV_NO,
             FILE_NAME, FILE_SIZE, SAVE_PATH, REG_DATE
    ORDER BY REV_NO DESC;
END //

DELIMITER ;
