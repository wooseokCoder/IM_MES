-- ============================================================================
-- TSTD_INS_GRP CRUD 프로시저 (QCT05A용)
-- 검사그룹: SER2, INS, UPD, UPD2
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-03-04
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_ins_grp_ser2
-- 검사그룹 목록 조회 (PLANTS별 필터, DATA_FLAG=0)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_ser2//

CREATE PROCEDURE sp_imes_tstd_ins_grp_ser2(
    IN p_plt_code   VARCHAR(3),
    IN p_plants     VARCHAR(4)
)
BEGIN
    SELECT
        ROW_NUMBER() OVER(ORDER BY IFNULL(GRP_SEQ, 999999), INS_GRP_NAME) AS seq,
        PLT_CODE        AS pltCode,
        PLANTS           AS plants,
        INS_GRP_CODE     AS insGrpCode,
        INS_GRP_NAME     AS insGrpName,
        INS_GRP_MODEL    AS insGrpModel,
        USE_FLAG         AS useFlag,
        SCOMMENT         AS scomment,
        GRP_SEQ          AS grpSeq
    FROM TSTD_INS_GRP
    WHERE PLT_CODE = p_plt_code
      AND PLANTS = p_plants
      AND DATA_FLAG = 0
    ORDER BY IFNULL(GRP_SEQ, 999999), INS_GRP_NAME;
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_ins
-- 검사그룹 신규 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_ins//

CREATE PROCEDURE sp_imes_tstd_ins_grp_ins(
    IN p_plt_code       VARCHAR(3),
    IN p_plants         VARCHAR(4),
    IN p_ins_grp_code   VARCHAR(20),
    IN p_ins_grp_name   VARCHAR(30),
    IN p_ins_grp_model  VARCHAR(30),
    IN p_use_flag       VARCHAR(1),
    IN p_scomment       VARCHAR(200),
    IN p_grp_seq        INT,
    IN p_user_id        VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_INS_GRP (
        PLT_CODE, PLANTS, INS_GRP_CODE, INS_GRP_NAME,
        INS_GRP_MODEL, USE_FLAG, SCOMMENT, GRP_SEQ,
        REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_plants, p_ins_grp_code, p_ins_grp_name,
        p_ins_grp_model, p_use_flag, p_scomment, p_grp_seq,
        NOW(), p_user_id, 0
    );
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_upd
-- 검사그룹 수정 (이름, 모델, 사용여부, 비고, 순번)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_upd//

CREATE PROCEDURE sp_imes_tstd_ins_grp_upd(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20),
    IN p_ins_grp_name   VARCHAR(30),
    IN p_ins_grp_model  VARCHAR(30),
    IN p_use_flag       VARCHAR(1),
    IN p_scomment       VARCHAR(200),
    IN p_grp_seq        INT,
    IN p_user_id        VARCHAR(50)
)
BEGIN
    UPDATE TSTD_INS_GRP SET
        INS_GRP_NAME  = p_ins_grp_name,
        INS_GRP_MODEL = p_ins_grp_model,
        USE_FLAG      = p_use_flag,
        SCOMMENT      = p_scomment,
        GRP_SEQ       = p_grp_seq,
        MDFY_DATE     = NOW(),
        MDFY_EMP      = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND INS_GRP_CODE = p_ins_grp_code;
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_upd2
-- 검사그룹 이미지 저장 (INS_IMG 컬럼 업데이트)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_upd2//

CREATE PROCEDURE sp_imes_tstd_ins_grp_upd2(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20),
    IN p_ins_img        LONGBLOB,
    IN p_user_id        VARCHAR(50)
)
BEGIN
    UPDATE TSTD_INS_GRP SET
        INS_IMG   = p_ins_img,
        MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND INS_GRP_CODE = p_ins_grp_code;
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_img_ser
-- 검사그룹 이미지 단건 조회 (TO_BASE64로 문자열 반환)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_img_ser//

CREATE PROCEDURE sp_imes_tstd_ins_grp_img_ser(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20)
)
BEGIN
    SELECT
        TO_BASE64(INS_IMG) AS insImgBase64
    FROM TSTD_INS_GRP
    WHERE PLT_CODE = p_plt_code
      AND INS_GRP_CODE = p_ins_grp_code;
END//

DELIMITER ;
