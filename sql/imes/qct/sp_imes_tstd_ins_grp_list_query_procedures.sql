-- ============================================================================
-- TSTD_INS_GRP_LIST QUERY 프로시저 (2개)
-- 검사그룹 연결 조회: QUERY1(할당그룹), QUERY2(미할당그룹)
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-27
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_ins_grp_list_query1
-- D1A: 할당된 검사그룹 목록 조회
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_list_query1//

CREATE PROCEDURE sp_imes_tstd_ins_grp_list_query1(
    IN p_plt_code   VARCHAR(3),
    IN p_ins_code   VARCHAR(20)
)
BEGIN
    SELECT
        GL.PLT_CODE         AS pltCode,
        GL.INS_GRP_CODE     AS insGrpCode,
        GL.INS_CODE         AS insCode,
        GL.INS_SEQ          AS insSeq,
        G.INS_GRP_NAME      AS insGrpName
    FROM TSTD_INS_GRP_LIST GL
        INNER JOIN TSTD_INS_GRP G ON GL.PLT_CODE = G.PLT_CODE AND GL.INS_GRP_CODE = G.INS_GRP_CODE
    WHERE GL.PLT_CODE = p_plt_code
      AND GL.INS_CODE = p_ins_code
      AND G.DATA_FLAG = 0
    ORDER BY GL.INS_SEQ, G.INS_GRP_NAME;
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_list_query2
-- D1A: 미할당 검사그룹 목록 조회 (검색 키워드 지원)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_list_query2//

CREATE PROCEDURE sp_imes_tstd_ins_grp_list_query2(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_code       VARCHAR(20),
    IN p_search_keyword VARCHAR(30)
)
BEGIN
    SELECT
        G.PLT_CODE          AS pltCode,
        G.INS_GRP_CODE      AS insGrpCode,
        G.INS_GRP_NAME      AS insGrpName
    FROM TSTD_INS_GRP G
    WHERE G.PLT_CODE = p_plt_code
      AND G.DATA_FLAG = 0
      AND NOT EXISTS (
          SELECT 1
          FROM TSTD_INS_GRP_LIST GL
          WHERE GL.PLT_CODE = G.PLT_CODE
            AND GL.INS_GRP_CODE = G.INS_GRP_CODE
            AND GL.INS_CODE = p_ins_code
      )
      AND (p_search_keyword IS NULL OR p_search_keyword = ''
           OR G.INS_GRP_NAME LIKE CONCAT('%', p_search_keyword, '%'))
    ORDER BY G.INS_GRP_NAME;
END//

DELIMITER ;
