-- ============================================================================
-- LSE_STD_AVAILMC CRUD 프로시저 (1개)
-- 공정별 가용설비: DEL2
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-23
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_std_availmc_del2
-- 설비별 가용설비 매핑 삭제 (PLT_CODE + MC_CODE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_std_availmc_del2//

CREATE PROCEDURE sp_imes_lse_std_availmc_del2(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10)
)
BEGIN
    DELETE FROM LSE_STD_AVAILMC
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE = p_mc_code;
END//

DELIMITER ;
