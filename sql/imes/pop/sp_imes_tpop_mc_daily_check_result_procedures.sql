-- ============================================================
-- TPOP_MC_DAILY_CHECK_RESULT 일일점검 CRUD 프로시저 (POP30B)
-- 생성일: 2026-03-18
-- 대상 테이블: TPOP_MC_DAILY_CHECK_RESULT
-- 원본: ProActive TPOP_MC_DAILY_CHECK_RESULT.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (3개):
--   1. sp_imes_tpop_mc_daily_check_result_ins   - 일일점검 결과 등록
--   2. sp_imes_tpop_mc_daily_check_result_upd   - 일일점검 결과 수정
--   3. sp_imes_tpop_mc_daily_check_result_ser   - 일일점검 결과 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tpop_mc_daily_check_result_ins: 일일점검 결과 등록
-- 원본: TPOP_MC_DAILY_CHECK_RESULT.TPOP_MC_DAILY_CHECK_RESULT_INS()
-- 용도: POP30B 일일점검 결과 신규 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tpop_mc_daily_check_result_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tpop_mc_daily_check_result_ins(
    IN p_plt_code       VARCHAR(10),     /* 공장코드 */
    IN p_mdcr_no        VARCHAR(30),     /* 점검번호 */
    IN p_mdcr_date      VARCHAR(8),      /* 점검일자 */
    IN p_mdcr_mc_code   VARCHAR(20),     /* 설비코드 */
    IN p_mdcr_type      VARCHAR(10),     /* 점검유형 */
    IN p_mdcr_num       VARCHAR(10),     /* 점검번호 */
    IN p_mdcr_contents  VARCHAR(500),    /* 점검내용 */
    IN p_mdcr_check     VARCHAR(100),    /* 점검기준 */
    IN p_mdcr_means     VARCHAR(100),    /* 점검방법 */
    IN p_mdcr_result    VARCHAR(100),    /* 점검결과 */
    IN p_mdcr_scomment  VARCHAR(500),    /* 비고 */
    IN p_mdcr_seq       INT,             /* 순서 */
    IN p_user_id        VARCHAR(50)      /* 등록자 */
)
BEGIN
    INSERT INTO TPOP_MC_DAILY_CHECK_RESULT (
        PLT_CODE, MDCR_NO, MDCR_DATE, MDCR_MC_CODE,
        MDCR_TYPE, MDCR_NUM, MDCR_CONTENTS, MDCR_CHECK,
        MDCR_MEANS, MDCR_RESULT, MDCR_SCOMMENT, MDCR_SEQ,
        REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_mdcr_no, p_mdcr_date, p_mdcr_mc_code,
        p_mdcr_type, p_mdcr_num, p_mdcr_contents, p_mdcr_check,
        p_mdcr_means, p_mdcr_result, p_mdcr_scomment, p_mdcr_seq,
        NOW(), p_user_id, 0
    );
END//


-- ============================================================
-- 2. sp_imes_tpop_mc_daily_check_result_upd: 일일점검 결과 수정
-- 원본: TPOP_MC_DAILY_CHECK_RESULT.TPOP_MC_DAILY_CHECK_RESULT_UPD()
-- AS-IS: 모든 MDCR_* 컬럼 UPDATE (RESULT/SCOMMENT뿐 아니라 전체)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tpop_mc_daily_check_result_upd//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tpop_mc_daily_check_result_upd(
    IN p_plt_code       VARCHAR(10),     /* 공장코드 */
    IN p_mdcr_no        VARCHAR(30),     /* 점검번호 (PK) */
    IN p_mdcr_date      VARCHAR(8),      /* 점검일자 */
    IN p_mdcr_mc_code   VARCHAR(20),     /* 설비코드 */
    IN p_mdcr_type      VARCHAR(10),     /* 점검유형 */
    IN p_mdcr_num       VARCHAR(10),     /* 점검번호 */
    IN p_mdcr_contents  VARCHAR(500),    /* 점검내용 */
    IN p_mdcr_check     VARCHAR(100),    /* 점검기준 */
    IN p_mdcr_means     VARCHAR(100),    /* 점검방법 */
    IN p_mdcr_result    VARCHAR(100),    /* 점검결과 */
    IN p_mdcr_scomment  VARCHAR(500),    /* 비고 */
    IN p_mdcr_seq       INT,             /* 순서 */
    IN p_user_id        VARCHAR(50)      /* 수정자 */
)
BEGIN
    UPDATE TPOP_MC_DAILY_CHECK_RESULT SET
        MDCR_DATE      = p_mdcr_date,
        MDCR_MC_CODE   = p_mdcr_mc_code,
        MDCR_TYPE      = p_mdcr_type,
        MDCR_NUM       = p_mdcr_num,
        MDCR_CONTENTS  = p_mdcr_contents,
        MDCR_CHECK     = p_mdcr_check,
        MDCR_MEANS     = p_mdcr_means,
        MDCR_RESULT    = p_mdcr_result,
        MDCR_SCOMMENT  = p_mdcr_scomment,
        MDCR_SEQ       = p_mdcr_seq,
        MDFY_DATE      = NOW(),
        MDFY_EMP       = p_user_id,
        DATA_FLAG      = 0
    WHERE PLT_CODE = p_plt_code
      AND MDCR_NO  = p_mdcr_no;
END//


-- ============================================================
-- 3. sp_imes_tpop_mc_daily_check_result_ser: 일일점검 결과 단건 조회
-- 원본: TPOP_MC_DAILY_CHECK_RESULT.TPOP_MC_DAILY_CHECK_RESULT_SER()
-- AS-IS WHERE: PLT_CODE + MDCR_NO (PK 기준)
-- 용도: POP30B_INS3에서 INSERT/UPDATE 분기 판단
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tpop_mc_daily_check_result_ser//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tpop_mc_daily_check_result_ser(
    IN p_plt_code   VARCHAR(10),     /* 공장코드 */
    IN p_mdcr_no    VARCHAR(30)      /* 점검번호 (PK) */
)
BEGIN
    -- AS-IS: TPOP_MC_DAILY_CHECK_RESULT_SER (Line 19-36) 전체 컬럼 반환
    SELECT
        PLT_CODE       AS "pltCode"
       ,MDCR_NO        AS "mdcrNo"
       ,MDCR_DATE      AS "mdcrDate"
       ,MDCR_MC_CODE   AS "mdcrMcCode"
       ,MDCR_TYPE      AS "mdcrType"
       ,MDCR_NUM       AS "mdcrNum"
       ,MDCR_CONTENTS  AS "mdcrContents"
       ,MDCR_CHECK     AS "mdcrCheck"
       ,MDCR_MEANS     AS "mdcrMeans"
       ,MDCR_RESULT    AS "mdcrResult"
       ,MDCR_SCOMMENT  AS "mdcrScomment"
       ,MDCR_SEQ       AS "mdcrSeq"
       ,REG_DATE       AS "regDate"
       ,REG_EMP        AS "regEmp"
       ,MDFY_DATE      AS "mdfyDate"
       ,MDFY_EMP       AS "mdfyEmp"
       ,DEL_DATE       AS "delDate"
       ,DEL_EMP        AS "delEmp"
       ,DATA_FLAG      AS "dataFlag"
    FROM TPOP_MC_DAILY_CHECK_RESULT
    WHERE PLT_CODE = p_plt_code
      AND MDCR_NO = p_mdcr_no;
END//


DELIMITER ;
