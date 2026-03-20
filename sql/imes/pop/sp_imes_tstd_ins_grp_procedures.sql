-- ============================================================
-- TSTD_INS_GRP 검사그룹 조회 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: TSTD_INS_GRP
-- 원본: ProActive TSTD_INS_GRP.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (2개):
--   1. sp_imes_tstd_ins_grp_ser2    - 검사그룹 전체 조회
--   2. sp_imes_tstd_ins_grp_query2  - 검사그룹 조건 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tstd_ins_grp_ser2: 검사그룹 전체 조회
-- 원본: TSTD_INS_GRP.TSTD_INS_GRP_SER2()
-- 용도: POP30B 검사그룹 목록 전체 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_ser2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ins_grp_ser2(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_plants    VARCHAR(200)     /* 공장 */
)
BEGIN
    SELECT
        ROW_NUMBER() OVER(ORDER BY IFNULL(GRP_SEQ,999999), INS_GRP_NAME) AS "seq"
       ,PLT_CODE       AS "pltCode"
       ,PLANTS          AS "plants"
       ,INS_GRP_CODE    AS "insGrpCode"
       ,INS_GRP_NAME    AS "insGrpName"
       ,INS_GRP_MODEL   AS "insGrpModel"
       ,USE_FLAG         AS "useFlag"
       ,SCOMMENT         AS "scomment"
       ,GRP_SEQ          AS "grpSeq"
       ,INS_IMG          AS "insImg"
    FROM TSTD_INS_GRP
    WHERE PLT_CODE = p_plt_code
      AND PLANTS   = p_plants
      AND DATA_FLAG = 0
    ORDER BY IFNULL(GRP_SEQ,999999), INS_GRP_NAME;
END//


-- ============================================================
-- 2. sp_imes_tstd_ins_grp_query2: 검사그룹 조건 조회
-- 원본: TSTD_INS_GRP.TSTD_INS_GRP_QUERY2()
-- 용도: POP30B 검사그룹 사용여부 필터 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_query2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ins_grp_query2(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_plants    VARCHAR(200),    /* 공장 */
    IN p_use_flag  VARCHAR(1)       /* 사용여부 */
)
BEGIN
    SELECT
        ROW_NUMBER() OVER(ORDER BY IFNULL(GRP_SEQ,999999), INS_GRP_NAME) AS "seq"
       ,PLT_CODE       AS "pltCode"
       ,PLANTS          AS "plants"
       ,INS_GRP_CODE    AS "insGrpCode"
       ,INS_GRP_NAME    AS "insGrpName"
       ,INS_GRP_MODEL   AS "insGrpModel"
       ,USE_FLAG         AS "useFlag"
       ,SCOMMENT         AS "scomment"
       ,GRP_SEQ          AS "grpSeq"
       ,INS_IMG          AS "insImg"
    FROM TSTD_INS_GRP
    WHERE PLT_CODE = p_plt_code
      AND PLANTS   = p_plants
      AND DATA_FLAG = 0
      AND (p_use_flag IS NULL OR p_use_flag = '' OR USE_FLAG = p_use_flag)
    ORDER BY IFNULL(GRP_SEQ,999999), INS_GRP_NAME;
END//


DELIMITER ;
