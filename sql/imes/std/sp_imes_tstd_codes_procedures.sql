-- ============================================================================
-- TSTD_CODES 코드 조회 프로시저
-- ============================================================================
-- AS-IS: acStdCodes.GetCatTable(catCode) → TSTD_CODES 테이블 조회
-- 용도: WorkIdle(W005), 기타 코드 콤보박스 동적 로드
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_codes_ser2: 카테고리별 코드 목록 조회
-- AS-IS: acStdCodes.GetCatTable() - CAT_CODE 기준 활성 코드 조회
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_codes_ser2//
CREATE PROCEDURE sp_imes_tstd_codes_ser2(
    IN p_plt_code   VARCHAR(20),
    IN p_cat_code   VARCHAR(20)
)
BEGIN
    SELECT
        CAT_CODE    AS catCode,
        CD_CODE     AS codeValue,
        CD_NAME     AS codeName,
        CD_PARENT   AS codeParent,
        IS_DEFAULT  AS isDefault,
        VALUE       AS value,
        SCOMMENT    AS scomment,
        CD_SEQ      AS codeSeq
    FROM TSTD_CODES
    WHERE DATA_FLAG = 0
      AND (p_plt_code IS NULL OR p_plt_code = '' OR PLT_CODE = p_plt_code)
      AND CAT_CODE = p_cat_code
    ORDER BY CD_SEQ, CD_CODE;
END//

DELIMITER ;
