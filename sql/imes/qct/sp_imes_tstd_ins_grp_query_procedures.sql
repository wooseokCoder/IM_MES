-- ============================================================================
-- TSTD_INS_GRP QUERY 프로시저 (QCT05A용)
-- 검사그룹 조회: SER (디테일), D0A용 조회
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-03-04
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_ins_grp_list_ser
-- 선택된 검사그룹의 연결 검사항목 목록 조회 (디테일 그리드)
-- TSTD_INS_GRP_LIST JOIN TSTD_PROC_INS JOIN LSE_STD_PROC
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_list_ser//

CREATE PROCEDURE sp_imes_tstd_ins_grp_list_ser(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20)
)
BEGIN
    SELECT
        ROW_NUMBER() OVER(ORDER BY I.PROC_CODE, I.INS_SEQ) AS seq,
        L.PLT_CODE       AS pltCode,
        L.INS_GRP_CODE   AS insGrpCode,
        L.INS_CODE       AS insCode,
        I.PROD_TYPE      AS prodType,
        I.PROC_CODE      AS procCode,
        PRC.PROC_NAME    AS procName,
        I.INS_NAME       AS insName,
        I.INS_DESC       AS insDesc,
        I.INS_TYPE       AS insType,
        I.INS_UNIT       AS insUnit,
        I.AVG_VAL        AS avgVal,
        I.MIN_VAL        AS minVal,
        I.MAX_VAL        AS maxVal,
        L.INS_SEQ        AS insSeq
    FROM TSTD_INS_GRP_LIST L
        LEFT JOIN TSTD_PROC_INS I
            ON L.PLT_CODE = I.PLT_CODE AND L.INS_CODE = I.INS_CODE AND I.DATA_FLAG = 0
        LEFT JOIN LSE_STD_PROC PRC
            ON I.PROC_CODE = PRC.PROC_CODE
    WHERE L.PLT_CODE = p_plt_code
      AND L.INS_GRP_CODE = p_ins_grp_code
      AND I.DATA_FLAG = 0
    ORDER BY I.PROC_CODE, I.INS_SEQ;
END//


-- ============================================================================
-- sp_imes_tstd_proc_ins_ser2
-- D0A: 미매핑 검사항목 조회 (해당 그룹에 매핑되지 않은 항목만)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_ser2//

CREATE PROCEDURE sp_imes_tstd_proc_ins_ser2(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20),
    IN p_lproc_code     VARCHAR(10)
)
BEGIN
    SELECT
        A.PLT_CODE       AS pltCode,
        A.PROD_TYPE      AS prodType,
        A.PROC_CODE      AS procCode,
        C.PROC_NAME      AS procName,
        A.INS_CODE       AS insCode,
        A.INS_NAME       AS insName,
        A.INS_DESC       AS insDesc,
        A.INS_TYPE       AS insType,
        A.INS_UNIT       AS insUnit,
        A.AVG_VAL        AS avgVal,
        A.MIN_VAL        AS minVal,
        A.MAX_VAL        AS maxVal,
        A.INS_SEQ        AS insSeq
    FROM TSTD_PROC_INS A
        LEFT JOIN TSTD_INS_GRP_LIST B
            ON A.INS_CODE = B.INS_CODE AND B.INS_GRP_CODE = p_ins_grp_code
        LEFT JOIN LSE_STD_PROC C
            ON A.PROC_CODE = C.PROC_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.DATA_FLAG = 0
      AND C.LPROC_CODE = p_lproc_code
      AND B.INS_CODE IS NULL
    ORDER BY A.PROC_CODE, A.INS_SEQ;
END//


-- ============================================================================
-- sp_imes_tstd_proc_ins_d0a_search
-- D0A: 전체 검사항목 검색 (공정/키워드 필터, 그룹에 이미 매핑된 항목 제외)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_d0a_search//

CREATE PROCEDURE sp_imes_tstd_proc_ins_d0a_search(
    IN p_plt_code       VARCHAR(3),
    IN p_plants         VARCHAR(4),
    IN p_ins_grp_code   VARCHAR(20),
    IN p_proc_code      VARCHAR(10),
    IN p_search_like    VARCHAR(100),
    IN p_lproc_code     VARCHAR(10)
)
BEGIN
    SELECT
        A.PLT_CODE       AS pltCode,
        A.PROD_TYPE      AS prodType,
        A.PROC_CODE      AS procCode,
        C.PROC_NAME      AS procName,
        A.INS_CODE       AS insCode,
        A.INS_NAME       AS insName,
        A.INS_DESC       AS insDesc,
        A.INS_TYPE       AS insType,
        A.INS_UNIT       AS insUnit,
        A.AVG_VAL        AS avgVal,
        A.MIN_VAL        AS minVal,
        A.MAX_VAL        AS maxVal,
        A.INS_SEQ        AS insSeq
    FROM TSTD_PROC_INS A
        LEFT JOIN LSE_STD_PROC C ON A.PROC_CODE = C.PROC_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.DATA_FLAG = 0
      AND (p_ins_grp_code IS NULL OR p_ins_grp_code = ''
           OR A.INS_CODE NOT IN (
               SELECT INS_CODE FROM TSTD_INS_GRP_LIST
               WHERE PLT_CODE = p_plt_code AND INS_GRP_CODE = p_ins_grp_code
           ))
      AND (p_proc_code IS NULL OR p_proc_code = '' OR A.PROC_CODE = p_proc_code)
      AND (p_lproc_code IS NULL OR p_lproc_code = '' OR C.LPROC_CODE = p_lproc_code)
      AND (p_plants IS NULL OR p_plants = '' OR A.PLANTS = p_plants)
      AND (p_search_like IS NULL OR p_search_like = ''
           OR C.PROC_NAME LIKE CONCAT('%', p_search_like, '%')
           OR A.INS_NAME LIKE CONCAT('%', p_search_like, '%')
           OR A.INS_DESC LIKE CONCAT('%', p_search_like, '%'))
    ORDER BY A.PROC_CODE, A.INS_SEQ;
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_list_del2
-- 특정 검사그룹의 매핑 전체 삭제
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_list_del2//

CREATE PROCEDURE sp_imes_tstd_ins_grp_list_del2(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20)
)
BEGIN
    DELETE FROM TSTD_INS_GRP_LIST
    WHERE PLT_CODE = p_plt_code
      AND INS_GRP_CODE = p_ins_grp_code;
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_list_del
-- 검사그룹 매핑 개별 삭제 (그룹코드 + 항목코드)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_list_del//

CREATE PROCEDURE sp_imes_tstd_ins_grp_list_del(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20),
    IN p_ins_code       VARCHAR(20)
)
BEGIN
    DELETE FROM TSTD_INS_GRP_LIST
    WHERE PLT_CODE = p_plt_code
      AND INS_GRP_CODE = p_ins_grp_code
      AND INS_CODE = p_ins_code;
END//

DELIMITER ;
