-- ============================================================
-- TSHP_INS_RESULT CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: TSHP_INS_RESULT
-- 원본: ProActive TSHP_INS_RESULT.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (3개):
--   1. sp_imes_tshp_ins_result_ins   - 검사결과 등록
--   2. sp_imes_tshp_ins_result_upd   - 검사결과 수정
--   3. sp_imes_tshp_ins_result_ser   - INSM_NO+INS_CODE 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_ins_result_ins: 검사결과 등록
-- 원본: TSHP_INS_RESULT.TSHP_INS_RESULT_INS()
-- 용도: POP30B 검사결과 상세 항목 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_ins(
    IN p_plt_code        VARCHAR(10),     /* 공장코드 */
    IN p_insm_no         VARCHAR(30),     /* 검사마스터번호 */
    IN p_ins_no          VARCHAR(30),     /* 검사번호 */
    IN p_proc_code       VARCHAR(20),     /* 공정코드 */
    IN p_prod_type       VARCHAR(20),     /* 제품유형 */
    IN p_ins_name        VARCHAR(200),    /* 검사항목명 */
    IN p_ins_desc        VARCHAR(500),    /* 검사설명 */
    IN p_ins_type        VARCHAR(20),     /* 검사유형 */
    IN p_ins_unit        VARCHAR(20),     /* 검사단위 */
    IN p_avg_val         DECIMAL(18,4),   /* 평균값 */
    IN p_min_val         DECIMAL(18,4),   /* 최소값 */
    IN p_max_val         DECIMAL(18,4),   /* 최대값 */
    IN p_ins_result      VARCHAR(200),    /* 검사결과 */
    IN p_ins_result_img  VARCHAR(500),    /* 검사결과 이미지 */
    IN p_ins_seq         INT,             /* 검사순서 */
    IN p_ins_grp_code    VARCHAR(20),     /* 검사그룹코드 */
    IN p_ins_code        VARCHAR(20),     /* 검사코드 */
    IN p_ins_nong        VARCHAR(20),     /* 검사 합부 */
    IN p_scomment        VARCHAR(500),    /* 비고 */
    IN p_user_id         VARCHAR(50)      /* 등록자 */
)
BEGIN
    INSERT INTO TSHP_INS_RESULT (
        PLT_CODE, INSM_NO, INS_NO, PROC_CODE, PROD_TYPE,
        INS_NAME, INS_DESC, INS_TYPE, INS_UNIT,
        AVG_VAL, MIN_VAL, MAX_VAL,
        INS_RESULT, INS_RESULT_IMG, INS_SEQ,
        INS_GRP_CODE, INS_CODE, INS_NONG, SCOMMENT,
        REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_insm_no, p_ins_no, p_proc_code, p_prod_type,
        p_ins_name, p_ins_desc, p_ins_type, p_ins_unit,
        p_avg_val, p_min_val, p_max_val,
        p_ins_result, p_ins_result_img, p_ins_seq,
        p_ins_grp_code, p_ins_code, p_ins_nong, p_scomment,
        NOW(), p_user_id, 0
    );
END//


-- ============================================================
-- 2. sp_imes_tshp_ins_result_upd: 검사결과 수정
-- 원본: TSHP_INS_RESULT.TSHP_INS_RESULT_UPD()
-- 용도: POP30B 검사결과 상세 항목 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_upd//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_upd(
    IN p_plt_code        VARCHAR(10),     /* 공장코드 */
    IN p_ins_no          VARCHAR(30),     /* 검사번호 (PK) */
    IN p_ins_result      VARCHAR(200),    /* 검사결과 */
    IN p_ins_result_img  VARCHAR(500),    /* 검사결과 이미지 */
    IN p_ins_nong        VARCHAR(20),     /* 검사 합부 */
    IN p_scomment        VARCHAR(500),    /* 비고 */
    IN p_data_flag       INT,             /* 데이터 플래그 */
    IN p_user_id         VARCHAR(50)      /* 수정자 */
)
BEGIN
    UPDATE TSHP_INS_RESULT SET
        INS_RESULT     = p_ins_result,
        INS_RESULT_IMG = p_ins_result_img,
        INS_NONG       = p_ins_nong,
        SCOMMENT       = p_scomment,
        MDFY_DATE      = NOW(),
        MDFY_EMP       = p_user_id,
        DATA_FLAG      = p_data_flag
    WHERE PLT_CODE = p_plt_code
      AND INS_NO   = p_ins_no;
END//


-- ============================================================
-- 3. sp_imes_tshp_ins_result_ser: INSM_NO+INS_CODE 조회
-- 원본: TSHP_INS_RESULT.TSHP_INS_RESULT_SER()
-- 용도: POP30B 검사마스터번호+검사코드 기준 검사결과 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_ser//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_ser(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_insm_no   VARCHAR(30),     /* 검사마스터번호 */
    IN p_ins_code  VARCHAR(20)      /* 검사코드 */
)
BEGIN
    SELECT
        PLT_CODE    AS "pltCode"
       ,INS_NO      AS "insNo"
       ,INSM_NO     AS "insmNo"
       ,INS_CODE    AS "insCode"
       ,INS_RESULT  AS "insResult"
    FROM TSHP_INS_RESULT
    WHERE PLT_CODE  = p_plt_code
      AND INSM_NO   = p_insm_no
      AND INS_CODE  = p_ins_code
      AND DATA_FLAG = 0;
END//


DELIMITER ;
