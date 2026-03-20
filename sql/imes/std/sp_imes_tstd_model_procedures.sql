-- ============================================================
-- 파일명: sp_imes_tstd_model_procedures.sql
-- 테이블: TSTD_MODEL
-- 설명: 모델군 관리 CRUD 프로시저
-- 작성자: 송우석
-- 작성일: 2026-02-20
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_model_ser_b
-- 설명: B(구분) 타입 중복 체크 (PLT_CODE + DATA_TYPE + MODEL_TYPE)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_ser_b//

CREATE PROCEDURE sp_imes_tstd_model_ser_b(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_DATA_TYPE       VARCHAR(3),
    IN p_MODEL_TYPE      VARCHAR(50)
)
BEGIN
    SELECT
        M.PLT_CODE      AS pltCode,
        M.SCODE          AS scode,
        M.DATA_TYPE      AS dataType,
        M.MODEL_TYPE     AS modelType,
        M.DATA_FLAG      AS dataFlag
    FROM TSTD_MODEL M
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_TYPE = p_DATA_TYPE
      AND M.MODEL_TYPE = p_MODEL_TYPE;
END//

-- ============================================================
-- sp_imes_tstd_model_ser_m
-- 설명: M(시리즈) 타입 중복 체크 (PLT_CODE + DATA_TYPE + MODEL_TYPE + MODEL_SERISE)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_ser_m//

CREATE PROCEDURE sp_imes_tstd_model_ser_m(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_DATA_TYPE       VARCHAR(3),
    IN p_MODEL_TYPE      VARCHAR(50),
    IN p_MODEL_SERISE    VARCHAR(50)
)
BEGIN
    SELECT
        M.PLT_CODE      AS pltCode,
        M.SCODE          AS scode,
        M.DATA_TYPE      AS dataType,
        M.MODEL_TYPE     AS modelType,
        M.MODEL_SERISE   AS modelSerise,
        M.DATA_FLAG      AS dataFlag
    FROM TSTD_MODEL M
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_TYPE = p_DATA_TYPE
      AND M.MODEL_TYPE = p_MODEL_TYPE
      AND M.MODEL_SERISE = p_MODEL_SERISE;
END//

-- ============================================================
-- sp_imes_tstd_model_ser_s
-- 설명: S(모델) 타입 중복 체크 (PLT_CODE + DATA_TYPE + MODEL_TYPE + MODEL_SERISE + MODEL_NO)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_ser_s//

CREATE PROCEDURE sp_imes_tstd_model_ser_s(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_DATA_TYPE       VARCHAR(3),
    IN p_MODEL_TYPE      VARCHAR(50),
    IN p_MODEL_SERISE    VARCHAR(50),
    IN p_MODEL_NO        VARCHAR(50)
)
BEGIN
    SELECT
        M.PLT_CODE      AS pltCode,
        M.SCODE          AS scode,
        M.DATA_TYPE      AS dataType,
        M.MODEL_TYPE     AS modelType,
        M.MODEL_SERISE   AS modelSerise,
        M.MODEL_NO       AS modelNo,
        M.DATA_FLAG      AS dataFlag
    FROM TSTD_MODEL M
    WHERE M.PLT_CODE = p_PLT_CODE
      AND M.DATA_TYPE = p_DATA_TYPE
      AND M.MODEL_TYPE = p_MODEL_TYPE
      AND M.MODEL_SERISE = p_MODEL_SERISE
      AND M.MODEL_NO = p_MODEL_NO;
END//

-- ============================================================
-- sp_imes_tstd_model_ins
-- 설명: 모델군 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_ins//

CREATE PROCEDURE sp_imes_tstd_model_ins(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_SCODE           VARCHAR(20),
    IN p_P_SCODE         VARCHAR(20),
    IN p_PROD_TYPE       VARCHAR(10),
    IN p_DATA_TYPE       VARCHAR(3),
    IN p_MODEL_TYPE      VARCHAR(50),
    IN p_MODEL_SERISE    VARCHAR(50),
    IN p_MODEL_NO        VARCHAR(50),
    IN p_MODEL_CODE      VARCHAR(50),
    IN p_USE_FLAG        VARCHAR(1),
    IN p_USER_ID         VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_MODEL (
        PLT_CODE,
        SCODE,
        P_SCODE,
        PROD_TYPE,
        DATA_TYPE,
        MODEL_TYPE,
        MODEL_SERISE,
        MODEL_NO,
        MODEL_CODE,
        USE_FLAG,
        REG_EMP,
        REG_DATE,
        DATA_FLAG
    ) VALUES (
        p_PLT_CODE,
        p_SCODE,
        p_P_SCODE,
        p_PROD_TYPE,
        p_DATA_TYPE,
        p_MODEL_TYPE,
        p_MODEL_SERISE,
        p_MODEL_NO,
        p_MODEL_CODE,
        p_USE_FLAG,
        p_USER_ID,
        NOW(),
        0
    );
END//

-- ============================================================
-- sp_imes_tstd_model_upd_b
-- 설명: B(구분) 타입 수정 (PROD_TYPE, USE_FLAG)
-- WHERE: PLT_CODE + MODEL_TYPE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_upd_b//

CREATE PROCEDURE sp_imes_tstd_model_upd_b(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_MODEL_TYPE      VARCHAR(50),
    IN p_PROD_TYPE       VARCHAR(10),
    IN p_USE_FLAG        VARCHAR(1),
    IN p_USER_ID         VARCHAR(50)
)
BEGIN
    UPDATE TSTD_MODEL SET
        PROD_TYPE = p_PROD_TYPE,
        USE_FLAG = p_USE_FLAG,
        DATA_FLAG = 0,
        MDFY_EMP = p_USER_ID,
        MDFY_DATE = NOW()
    WHERE PLT_CODE = p_PLT_CODE
      AND MODEL_TYPE = p_MODEL_TYPE;
END//

-- ============================================================
-- sp_imes_tstd_model_upd_m
-- 설명: M(시리즈) 타입 수정 (USE_FLAG)
-- WHERE: PLT_CODE + MODEL_TYPE + MODEL_SERISE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_upd_m//

CREATE PROCEDURE sp_imes_tstd_model_upd_m(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_MODEL_TYPE      VARCHAR(50),
    IN p_MODEL_SERISE    VARCHAR(50),
    IN p_USE_FLAG        VARCHAR(1),
    IN p_USER_ID         VARCHAR(50)
)
BEGIN
    UPDATE TSTD_MODEL SET
        USE_FLAG = p_USE_FLAG,
        DATA_FLAG = 0,
        MDFY_EMP = p_USER_ID,
        MDFY_DATE = NOW()
    WHERE PLT_CODE = p_PLT_CODE
      AND MODEL_TYPE = p_MODEL_TYPE
      AND MODEL_SERISE = p_MODEL_SERISE;
END//

-- ============================================================
-- sp_imes_tstd_model_upd_s
-- 설명: S(모델) 타입 수정 (USE_FLAG, MODEL_CODE)
-- WHERE: PLT_CODE + MODEL_TYPE + MODEL_SERISE + MODEL_NO
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_upd_s//

CREATE PROCEDURE sp_imes_tstd_model_upd_s(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_MODEL_TYPE      VARCHAR(50),
    IN p_MODEL_SERISE    VARCHAR(50),
    IN p_MODEL_NO        VARCHAR(50),
    IN p_USE_FLAG        VARCHAR(1),
    IN p_MODEL_CODE      VARCHAR(50),
    IN p_USER_ID         VARCHAR(50)
)
BEGIN
    UPDATE TSTD_MODEL SET
        USE_FLAG = p_USE_FLAG,
        MODEL_CODE = p_MODEL_CODE,
        DATA_FLAG = 0,
        MDFY_EMP = p_USER_ID,
        MDFY_DATE = NOW()
    WHERE PLT_CODE = p_PLT_CODE
      AND MODEL_TYPE = p_MODEL_TYPE
      AND MODEL_SERISE = p_MODEL_SERISE
      AND MODEL_NO = p_MODEL_NO;
END//

-- ============================================================
-- sp_imes_tstd_model_ude
-- 설명: 논리 삭제 (DATA_FLAG = 2)
-- WHERE: PLT_CODE + SCODE
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_model_ude//

CREATE PROCEDURE sp_imes_tstd_model_ude(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_SCODE           VARCHAR(20),
    IN p_USER_ID         VARCHAR(50)
)
BEGIN
    UPDATE TSTD_MODEL SET
        DATA_FLAG = 2,
        DEL_EMP = p_USER_ID,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_PLT_CODE
      AND SCODE = p_SCODE;
END//

DELIMITER ;
