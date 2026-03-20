-- ============================================================================
-- POP30B_D4A 자주검사 팝업 전용 조회 프로시저
-- 작성자: 송우석
-- 작성일: 2026-03-20
-- ============================================================================
-- 포함 프로시저 (1개):
--   1. sp_imes_pop30b_d4a_wo_info - 작업지시 정보 조회 (정보 라벨용)
-- ============================================================================

DELIMITER //

-- ============================================================================
-- 1. sp_imes_pop30b_d4a_wo_info: 작업지시 정보 조회
-- TO-BE 신규 쿼리 (AS-IS 대응 없음)
-- - 메인 QUERY27과 동일 테이블/JOIN, woNo 기준 단건 조회
-- - TSHP_WORKORDER W LEFT JOIN LSE_STD_PART P
-- 용도: D4A 팝업 상단 정보 라벨 표시
--   1행: SAP_WO_NO - PROC_CODE - MC_CODE - MODEL
--   2행: PART_CODE
--   3행: PART_NAME
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_pop30b_d4a_wo_info//

CREATE PROCEDURE sp_imes_pop30b_d4a_wo_info(
    IN p_plt_code  VARCHAR(3),
    IN p_wo_no     VARCHAR(20)
)
BEGIN
    SELECT
        W.WO_NO        AS "woNo"
       ,W.SAP_WO_NO    AS "sapWoNo"
       ,W.PROC_CODE    AS "procCode"
       ,W.MC_CODE      AS "mcCode"
       ,W.MODEL        AS "model"
       ,W.PART_CODE    AS "partCode"
       ,P.PART_NAME    AS "partName"
       ,W.PLANTS       AS "plants"
       ,W.EMP_CODE     AS "empCode"
    FROM TSHP_WORKORDER W
    LEFT JOIN LSE_STD_PART P
        ON W.PLT_CODE = P.PLT_CODE
       AND W.PART_CODE = P.PART_CODE
    WHERE W.PLT_CODE  = p_plt_code
      AND W.WO_NO     = p_wo_no
      AND W.DATA_FLAG  = 0;
END//

DELIMITER ;
