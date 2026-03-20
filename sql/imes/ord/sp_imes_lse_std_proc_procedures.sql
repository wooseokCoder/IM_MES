-- ============================================================================
-- LSE_STD_PROC: 공정 마스터 관련 프로시저
-- ============================================================================
-- 용도: ORD32A D0A Grid4 (전체 공정 마스터 조회)
-- 원본: ProActive LSE_STD_PROC_QUERY.cs
-- 작성일: 2026-03-10
-- ============================================================================

-- ============================================================
-- sp_imes_lse_std_proc_ser
--   전체 공정 마스터 조회 (D0A Grid4 - 전체 공정)
--   조건: DATA_FLAG=0
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_std_proc_ser;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_lse_std_proc_ser(
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    SELECT P.PLT_CODE   AS pltCode
          ,P.PROC_CODE  AS procCode
          ,P.PROC_NAME  AS procName
      FROM LSE_STD_PROC P
     WHERE P.PLT_CODE  = p_plt_code
       AND P.DATA_FLAG = 0
     ORDER BY P.PROC_SEQ;
END$$
DELIMITER ;
