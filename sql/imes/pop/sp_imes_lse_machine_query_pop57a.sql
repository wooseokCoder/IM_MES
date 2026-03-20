-- ============================================================================
-- 프로시져명: sp_imes_lse_machine_query_pop57a
-- 설명: 설비별 표준문서(검사) 목록 조회 (POP57A_SER)
-- 원본: ProActive POP57A.cs → LSE_MACHINE_QUERY1
-- 테이블: LSE_MACHINE
-- 작성일: 2026-03-12
-- ============================================================================

DROP PROCEDURE IF EXISTS sp_imes_lse_machine_query_pop57a;

DELIMITER $$

CREATE PROCEDURE sp_imes_lse_machine_query_pop57a(
    IN p_PLT_CODE VARCHAR(3)
)
BEGIN
    SELECT M.MC_CODE  AS mcCode
         , M.MC_NAME  AS mcName
      FROM LSE_MACHINE M
     WHERE M.PLT_CODE  = p_PLT_CODE
       AND M.MC_GROUP  = '3605'
       AND M.DATA_FLAG = 0
     ORDER BY M.MC_FLAG, M.MC_SEQ ASC;
END$$

DELIMITER ;
