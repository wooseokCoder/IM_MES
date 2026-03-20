-- ============================================================================
-- TSTD_PROC_INS 이미지 조회 프로시저 (2개)
-- 검사항목 이미지 base64 조회: 단건(IMG_SER), 일괄(IMG_BATCH_SER)
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-03-04
-- 수정일: 2026-03-05 - 일괄 조회 SP 추가 (성능 개선: N회 요청 → 1회)
-- 설명: RecordMap이 byte[]를 String으로 자동 변환하는 문제 회피
--       TO_BASE64()로 DB에서 문자열 반환 → RecordMap 손상 없음
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_proc_ins_img_ser
-- 검사항목 이미지 base64 문자열 단건 조회
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_img_ser//

CREATE PROCEDURE sp_imes_tstd_proc_ins_img_ser(
    IN p_plt_code   VARCHAR(3),
    IN p_ins_code   VARCHAR(30)
)
BEGIN
    SELECT
        TO_BASE64(INS_IMG) AS insImgBase64
    FROM TSTD_PROC_INS
    WHERE PLT_CODE = p_plt_code
      AND INS_CODE = p_ins_code
      AND DATA_FLAG = 0;
END//

-- ============================================================================
-- sp_imes_tstd_proc_ins_img_batch_ser
-- 검사항목 이미지 base64 일괄 조회 (쉼표 구분 insCode 목록)
-- 그리드 로드 후 hasImg=1인 행들의 이미지를 1회 요청으로 조회
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_img_batch_ser//

CREATE PROCEDURE sp_imes_tstd_proc_ins_img_batch_ser(
    IN p_plt_code    VARCHAR(3),
    IN p_ins_codes   TEXT
)
BEGIN
    SELECT
        INS_CODE                AS insCode,
        TO_BASE64(INS_IMG)      AS insImgBase64
    FROM TSTD_PROC_INS
    WHERE PLT_CODE = p_plt_code
      AND FIND_IN_SET(INS_CODE, p_ins_codes) > 0
      AND DATA_FLAG = 0
      AND INS_IMG IS NOT NULL;
END//

DELIMITER ;
