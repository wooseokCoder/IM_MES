-- ============================================================
-- 프로시저명: sp_imes_tshp_ins_result_img
-- 화면: QCT08A - 자주검사 현황
-- 설명: 검사 이미지 base64 단건 조회
-- 테이블: TSHP_INS_RESULT
-- 작성자: 송우석
-- 작성일: 2026-03-17
-- ============================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_img//

CREATE PROCEDURE sp_imes_tshp_ins_result_img(
    IN p_plt_code   VARCHAR(10),
    IN p_ins_no     VARCHAR(30)
)
BEGIN
    SELECT
        TO_BASE64(INS_RESULT_IMG) AS imgBase64
    FROM TSHP_INS_RESULT
    WHERE PLT_CODE = p_plt_code
      AND INS_NO = p_ins_no
      AND INS_RESULT_IMG IS NOT NULL;
END//

DELIMITER ;
