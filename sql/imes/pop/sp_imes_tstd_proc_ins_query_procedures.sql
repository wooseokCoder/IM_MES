-- ============================================================
-- TSTD_PROC_INS 검사항목 템플릿 조회 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 수정일: 2026-03-20 (INS_GRP_CODE → TSTD_INS_GRP_LIST JOIN으로 수정)
-- 대상 테이블: TSTD_PROC_INS, TSTD_INS_GRP_LIST
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (1개):
--   1. sp_imes_tstd_proc_ins_query3 - 검사그룹 기준 검사항목 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tstd_proc_ins_query3: 검사그룹 기준 검사항목 조회
-- 용도: POP30B 검사그룹 선택 시 검사항목 템플릿 조회
-- JOIN 구조 (AS-IS 동일):
--   TSTD_INS_GRP IG → TSTD_INS_GRP_LIST IGL → TSTD_PROC_INS PRI → LSE_STD_PROC LSP
-- 조건: PLANTS(공장), INS_GRP_CODE(검사그룹), PROC_CODE(3605 아닐때만)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_query3//

CREATE PROCEDURE sp_imes_tstd_proc_ins_query3(
    IN p_plt_code      VARCHAR(10),
    IN p_ins_grp_code  VARCHAR(20),
    IN p_plants        VARCHAR(10),
    IN p_proc_code     VARCHAR(10)
)
BEGIN
    SELECT
        IG.PLT_CODE         AS "pltCode"
       ,IG.INS_GRP_CODE     AS "insGrpCode"
       ,IGL.INS_CODE        AS "insCode"
       ,PRI.PROC_CODE       AS "procCode"
       ,PRI.PROD_TYPE       AS "prodType"
       ,LSP.PROC_NAME       AS "procName"
       ,PRI.INS_NAME        AS "insName"
       ,PRI.INS_DESC        AS "insDesc"
       ,PRI.AVG_VAL         AS "avgVal"
       ,PRI.MIN_VAL         AS "minVal"
       ,PRI.MAX_VAL         AS "maxVal"
       ,PRI.INS_SEQ         AS "insSeq"
       ,PRI.INS_TYPE        AS "insType"
       ,PRI.INS_UNIT        AS "insUnit"
       ,PRI.INS_IMG         AS "insImg"
    FROM TSTD_INS_GRP IG
    LEFT JOIN TSTD_INS_GRP_LIST IGL
        ON IG.PLT_CODE = IGL.PLT_CODE
       AND IG.INS_GRP_CODE = IGL.INS_GRP_CODE
    LEFT JOIN TSTD_PROC_INS PRI
        ON IGL.PLT_CODE = PRI.PLT_CODE
       AND IGL.INS_CODE = PRI.INS_CODE
       AND PRI.DATA_FLAG = 0
    LEFT JOIN LSE_STD_PROC LSP
        ON PRI.PLT_CODE = LSP.PLT_CODE
       AND PRI.PROC_CODE = LSP.PROC_CODE
       AND LSP.DATA_FLAG = 0
    WHERE IG.PLT_CODE       = p_plt_code
      AND IG.INS_GRP_CODE   = p_ins_grp_code
      AND IG.DATA_FLAG       = 0
      AND PRI.DATA_FLAG      = 0
      AND (p_plants IS NULL OR IG.PLANTS = p_plants)
      AND (p_plants = '3605' OR p_proc_code IS NULL OR PRI.PROC_CODE = p_proc_code)
    ORDER BY PRI.INS_SEQ ASC;
END//


DELIMITER ;
