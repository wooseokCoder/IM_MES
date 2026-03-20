-- ============================================================================
-- TSTD_MODEL: 모델 마스터 관련 프로시저
-- ============================================================================
-- 용도: ORD32A D0A Grid2 (전체 모델 마스터 조회)
-- 원본: ProActive TSTD_MODEL_QUERY.cs
-- 작성일: 2026-03-10
-- ============================================================================

-- ============================================================
-- sp_imes_tstd_model_ser
--   전체 모델 마스터 조회 (D0A Grid2 - 전체 모델)
--   조건: DATA_TYPE='S', DATA_FLAG=0
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_ser;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_model_ser(
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    SELECT M.PLT_CODE     AS pltCode
          ,M.MODEL_TYPE   AS modelType
          ,M.MODEL_SERISE AS modelSerise
          ,M.MODEL_NO     AS model
          ,M.SCODE        AS scode
      FROM TSTD_MODEL M
     WHERE M.PLT_CODE  = p_plt_code
       AND M.DATA_TYPE = 'S'
       AND M.DATA_FLAG = 0;
END$$
DELIMITER ;
