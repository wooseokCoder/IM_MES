-- ============================================================================
-- 설비 검색 공통 팝업 프로시저 (1개)
-- acMachineForm: sp_machine_search
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-12
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_machine_search
-- 설비 목록 조회 (acMachineForm 팝업용)
-- LSE_MACHINE 테이블
-- AS-IS: CONTROL_MACHINE_SEARCH 서비스 대응
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_machine_search//

CREATE PROCEDURE sp_machine_search(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_like    VARCHAR(100),
    IN p_mc_group   VARCHAR(20),
    IN p_is_sap     TINYINT
)
BEGIN
    SELECT
        A.MC_CODE       AS mcCode,
        A.MC_NAME       AS mcName,
        A.MC_GROUP      AS mcGroup,
        A.MC_FLAG       AS mcFlag,
        A.MC_MODEL      AS mcModel,
        A.MC_SEQ        AS mcSeq,
        A.MAIN_EMP      AS mainEmp,
        A.SCOMMENT      AS scomment,
        A.IS_SAP        AS isSap,
        A.CPROC_CODE    AS cprocCode
    FROM LSE_MACHINE A
    WHERE A.PLT_CODE = IFNULL(p_plt_code, '100')
      AND A.DATA_FLAG = 0
      AND (p_mc_like IS NULL OR p_mc_like = ''
           OR A.MC_CODE LIKE CONCAT('%', p_mc_like, '%')
           OR A.MC_NAME LIKE CONCAT('%', p_mc_like, '%'))
      AND (p_mc_group IS NULL OR p_mc_group = ''
           OR A.MC_GROUP = p_mc_group)
      AND (p_is_sap IS NULL
           OR A.IS_SAP = p_is_sap)
    ORDER BY A.MC_SEQ;
END//

DELIMITER ;
