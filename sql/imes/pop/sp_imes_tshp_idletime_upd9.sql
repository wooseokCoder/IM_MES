-- ============================================================
-- sp_imes_tshp_idletime_upd9: 상세원인 수정
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UPD9()
-- 용도: POP32A_INS3 (상세원인 수정 및 확인)
-- 수정 필드: MCT_SCOMMENT (발생원인), MCT_SCOMMENT_RESULT (처리내용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_upd9//

CREATE PROCEDURE sp_imes_tshp_idletime_upd9(
    IN p_plt_code            VARCHAR(10),
    IN p_idle_id             VARCHAR(20),
    IN p_mct_scomment        TEXT,
    IN p_mct_scomment_result TEXT,
    IN p_user_id             VARCHAR(50)
)
BEGIN
    UPDATE TSHP_IDLETIME SET
        MCT_SCOMMENT = p_mct_scomment,
        MCT_SCOMMENT_RESULT = p_mct_scomment_result,
        MDFY_DATE = NOW(),
        MDFY_EMP = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//