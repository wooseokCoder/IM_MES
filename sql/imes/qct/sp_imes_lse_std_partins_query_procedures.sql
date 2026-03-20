-- ============================================================
-- LSE_STD_PARTINS 조회 프로시저
-- 부품-검사그룹 연계 관리 (QCT06A)
-- 작성자: 송우석
-- ============================================================

DELIMITER //

-- 부품 목록 조회 (ASSY/MACH 탭)
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_query1//
CREATE PROCEDURE sp_imes_lse_std_partins_query1(
    IN p_pltCode    VARCHAR(3),
    IN p_partCode   VARCHAR(30),
    IN p_searchLike VARCHAR(100)
)
BEGIN
    SELECT P.PLT_CODE   AS pltCode
         , P.PART_CODE  AS partCode
         , P.PART_NAME  AS partName
      FROM LSE_STD_PART P
     WHERE P.PLT_CODE   = p_pltCode
       AND P.DATA_FLAG  = 0
       AND P.MAT_TYPE   = '1'
       AND (p_partCode IS NULL OR p_partCode = '' OR P.PART_CODE = p_partCode)
       AND (p_searchLike IS NULL OR p_searchLike = ''
            OR P.PART_CODE LIKE CONCAT('%', p_searchLike, '%')
            OR P.MAT_SPEC LIKE CONCAT('%', p_searchLike, '%'))
    ;
END//

-- 부품의 연계 검사그룹 조회 (부품 선택 시)
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_query2//
CREATE PROCEDURE sp_imes_lse_std_partins_query2(
    IN p_pltCode  VARCHAR(3),
    IN p_partCode VARCHAR(30),
    IN p_plants   VARCHAR(4)
)
BEGIN
    SELECT A.PLT_CODE      AS pltCode
         , A.PART_CODE     AS partCode
         , B.INS_GRP_CODE  AS insGrpCode
         , B.INS_GRP_SEQ   AS insGrpSeq
         , C.INS_GRP_NAME  AS insGrpName
         , C.SCOMMENT      AS scomment
      FROM LSE_STD_PART A
      JOIN LSE_STD_PARTINS B ON A.PART_CODE = B.PART_CODE
       AND A.PLT_CODE = B.PLT_CODE
      JOIN TSTD_INS_GRP C ON B.INS_GRP_CODE = C.INS_GRP_CODE
       AND B.PLT_CODE = C.PLT_CODE
       AND C.USE_FLAG = '1'
       AND C.DATA_FLAG = 0
     WHERE A.PLT_CODE  = p_pltCode
       AND A.PART_CODE = p_partCode
       AND C.PLANTS    = p_plants
     ORDER BY B.INS_GRP_SEQ;
END//

-- LIST 탭 전체 연계 현황 조회
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_query3//
CREATE PROCEDURE sp_imes_lse_std_partins_query3(
    IN p_pltCode   VARCHAR(3),
    IN p_partLike  VARCHAR(100),
    IN p_groupLike VARCHAR(100)
)
BEGIN
    SELECT A.PLT_CODE      AS pltCode
         , A.PART_CODE     AS partCode
         , A.PART_NAME     AS partName
         , B.INS_GRP_CODE  AS insGrpCode
         , B.INS_GRP_SEQ   AS insGrpSeq
         , C.INS_GRP_NAME  AS insGrpName
         , C.SCOMMENT      AS scomment
         , C.USE_FLAG      AS useFlag
         , C.GRP_SEQ       AS grpSeq
      FROM LSE_STD_PART A
      JOIN LSE_STD_PARTINS B ON A.PART_CODE = B.PART_CODE
       AND A.PLT_CODE = B.PLT_CODE
      JOIN TSTD_INS_GRP C ON B.INS_GRP_CODE = C.INS_GRP_CODE
       AND B.PLT_CODE = C.PLT_CODE
       AND C.DATA_FLAG = 0
     WHERE A.PLT_CODE = p_pltCode
       AND (p_partLike IS NULL OR p_partLike = ''
            OR A.PART_CODE LIKE CONCAT('%', p_partLike, '%')
            OR A.PART_NAME LIKE CONCAT('%', p_partLike, '%'))
       AND (p_groupLike IS NULL OR p_groupLike = ''
            OR C.INS_GRP_NAME LIKE CONCAT('%', p_groupLike, '%'))
    ;
END//

-- D0A 검사그룹 목록 조회
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_query4//
CREATE PROCEDURE sp_imes_lse_std_partins_query4(
    IN p_pltCode    VARCHAR(3),
    IN p_plants     VARCHAR(4),
    IN p_searchLike VARCHAR(100)
)
BEGIN
    SELECT INS_GRP_CODE AS insGrpCode
         , INS_GRP_NAME AS insGrpName
         , SCOMMENT     AS scomment
      FROM TSTD_INS_GRP
     WHERE PLT_CODE  = p_pltCode
       AND PLANTS    = p_plants
       AND DATA_FLAG = 0
       AND USE_FLAG  = '1'
       AND (p_searchLike IS NULL OR p_searchLike = ''
            OR INS_GRP_NAME LIKE CONCAT('%', p_searchLike, '%')
            OR SCOMMENT LIKE CONCAT('%', p_searchLike, '%'))
     ORDER BY INS_GRP_NAME;
END//

-- 검사그룹의 검사항목 조회 (SER2/SER4)
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_query5//
CREATE PROCEDURE sp_imes_lse_std_partins_query5(
    IN p_pltCode    VARCHAR(3),
    IN p_insGrpCode VARCHAR(20)
)
BEGIN
    SELECT L.INS_CODE     AS insCode
         , L.INS_GRP_CODE AS insGrpCode
         , PI.PROC_CODE   AS procCode
         , PI.PROD_TYPE   AS prodType
         , PR.PROC_NAME   AS procName
         , PI.INS_NAME    AS insName
         , PI.INS_DESC    AS insDesc
         , PI.INS_TYPE    AS insType
         , PI.AVG_VAL     AS avgVal
         , PI.INS_UNIT    AS insUnit
         , PI.MIN_VAL     AS minVal
         , PI.MAX_VAL     AS maxVal
         , L.INS_SEQ      AS insSeq
      FROM TSTD_INS_GRP_LIST L
      JOIN TSTD_PROC_INS PI ON L.PLT_CODE = PI.PLT_CODE
       AND L.INS_CODE = PI.INS_CODE
       AND PI.DATA_FLAG = 0
      JOIN LSE_STD_PROC PR ON PI.PLT_CODE = PR.PLT_CODE
       AND PI.PROC_CODE = PR.PROC_CODE
     WHERE L.PLT_CODE     = p_pltCode
       AND L.INS_GRP_CODE = p_insGrpCode
     ORDER BY L.INS_SEQ;
END//

DELIMITER ;
