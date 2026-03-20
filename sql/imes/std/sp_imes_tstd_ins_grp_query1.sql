-- ============================================================================
-- 프로시져명: sp_imes_tstd_ins_grp_query1
-- 설명: 검사그룹 목록 조회 (STD51A_SER)
-- 원본: ProActive TSTD_INS_GRP_QUERY.cs → TSTD_INS_GRP_QUERY1
-- 테이블: TSTD_INS_GRP
-- 작성일: 2026-03-11
-- ============================================================================

DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_query1;

DELIMITER $$

CREATE PROCEDURE sp_imes_tstd_ins_grp_query1(
    IN p_PLT_CODE    VARCHAR(3),
    IN p_PLANTS      VARCHAR(4),
    IN p_SEARCH_LIKE VARCHAR(200),
    IN p_DATA_FLAG   TINYINT
)
BEGIN
    SELECT IG.PLT_CODE      AS pltCode
         , IG.PLANTS        AS plants
         , IG.INS_GRP_CODE  AS insGrpCode
         , IG.INS_GRP_NAME  AS insGrpName
         , IG.INS_GRP_MODEL AS insGrpModel
         , IG.USE_FLAG      AS useFlag
         , IG.SCOMMENT      AS scomment
         , IG.GRP_SEQ       AS grpSeq
         , DATE_FORMAT(IG.REG_DATE, '%Y-%m-%d %H:%i:%s')  AS regDate
         , IG.REG_EMP       AS regEmp
         , DATE_FORMAT(IG.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate
         , IG.MDFY_EMP      AS mdfyEmp
         , DATE_FORMAT(IG.DEL_DATE, '%Y-%m-%d %H:%i:%s')  AS delDate
         , IG.DEL_EMP       AS delEmp
         , IG.DATA_FLAG     AS dataFlag
      FROM TSTD_INS_GRP IG
     WHERE IG.PLT_CODE = p_PLT_CODE
       AND IG.DATA_FLAG = p_DATA_FLAG
       AND (p_PLANTS IS NULL OR p_PLANTS = '' OR IG.PLANTS = p_PLANTS)
       AND (p_SEARCH_LIKE IS NULL OR p_SEARCH_LIKE = ''
            OR IG.INS_GRP_CODE  LIKE CONCAT('%', p_SEARCH_LIKE, '%')
            OR IG.INS_GRP_NAME  LIKE CONCAT('%', p_SEARCH_LIKE, '%')
            OR IG.INS_GRP_MODEL LIKE CONCAT('%', p_SEARCH_LIKE, '%')
            OR IG.SCOMMENT      LIKE CONCAT('%', p_SEARCH_LIKE, '%')
           )
     ORDER BY IFNULL(IG.GRP_SEQ, 999999), IG.INS_GRP_NAME;
END$$

DELIMITER ;
