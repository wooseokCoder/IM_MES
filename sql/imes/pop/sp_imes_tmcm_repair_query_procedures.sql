-- ============================================================
-- TMCM_REPAIR QUERY 프로시저
-- 생성일: 2026-03-11
-- 대상 테이블: TMCM_REPAIR
-- 원본: ProActive TMCM_REPAIR_QUERY.cs
-- ============================================================
-- 명명 규칙: sp_imes_tmcm_repair_query[번호]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tmcm_repair_query1: 목록 조회
-- 원본: TMCM_REPAIR_QUERY.TMCM_REPAIR_QUERY1()
-- 용도: 메인 그리드 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tmcm_repair_query1//

CREATE PROCEDURE sp_imes_tmcm_repair_query1(
    IN p_plt_code VARCHAR(10),
    IN p_mcr_id VARCHAR(30),
    IN p_s_repair_date VARCHAR(10),
    IN p_e_repair_date VARCHAR(10),
    IN p_repair_vendor_like VARCHAR(100),
    IN p_repair_mc_like VARCHAR(100),
    IN p_data_flag INT
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        MCR_ID AS mcrId,
        REPAIR_DATE AS repairDate,
        REPAIR_VENDOR AS repairVendor,
        REPAIR_MC AS repairMc,
        REPAIR_MC_TYPE AS repairMcType,
        REPAIR_NAME AS repairName,
        REPAIR_CONTENTS AS repairContents,
        REPAIR_AMOUNT AS repairAmount
    FROM TMCM_REPAIR
    WHERE PLT_CODE = p_plt_code
      AND DATA_FLAG = p_data_flag
      AND (p_mcr_id IS NULL OR p_mcr_id = '' OR MCR_ID = p_mcr_id)
      AND (p_s_repair_date IS NULL OR p_s_repair_date = '' OR REPAIR_DATE BETWEEN p_s_repair_date AND p_e_repair_date)
      AND (p_repair_vendor_like IS NULL OR p_repair_vendor_like = '' OR REPAIR_VENDOR LIKE CONCAT('%', p_repair_vendor_like, '%'))
      AND (p_repair_mc_like IS NULL OR p_repair_mc_like = '' OR REPAIR_MC LIKE CONCAT('%', p_repair_mc_like, '%'))
    ORDER BY REPAIR_DATE DESC;
END//

DELIMITER ;

