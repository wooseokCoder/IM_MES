-- ============================================================
-- TSHP_NG_FILE_WORK_MASTER CRUD 프로시저
-- 생성일: 2026-03-07
-- 대상 테이블: TSHP_NG_FILE_WORK_MASTER
-- 원본: ProActive POP55A.cs (TSHP_NG_FILE_WORK_MASTER CRUD)
-- 화면: POP55A (NAM공정 NG파일배포 확인)
-- ============================================================
-- 포함 프로시저 (4개):
--   1. sp_imes_tshp_ng_file_work_master_ser  - 존재 여부 조회 (단건)
--   2. sp_imes_tshp_ng_file_work_master_ins  - 신규 등록
--   3. sp_imes_tshp_ng_file_work_master_upd  - 수정
--   4. sp_imes_tshp_ng_file_work_master_del  - 삭제
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_ng_file_work_master_ser: 존재 여부 조회
-- 원본: POP55A TSHP_NG_FILE_WORK_MASTER SER
-- 용도: INS 전 기존 데이터 존재 여부 확인 (UPSERT 분기용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_work_master_ser//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_work_master_ser(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_prod_code VARCHAR(50)      /* 제품코드 */
)
BEGIN
    SELECT
        PLT_CODE    AS "pltCode"
       ,PROD_CODE   AS "prodCode"
       ,WORK_FLAG   AS "workFlag"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')  AS "regDate"
       ,REG_EMP     AS "regEmp"
    FROM TSHP_NG_FILE_WORK_MASTER
    WHERE PLT_CODE = p_plt_code
      AND PROD_CODE = p_prod_code;
END//


-- ============================================================
-- 2. sp_imes_tshp_ng_file_work_master_ins: 신규 등록
-- 원본: POP55A TSHP_NG_FILE_WORK_MASTER INS
-- 용도: NG파일 확인 마스터 신규 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_work_master_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_work_master_ins(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_prod_code VARCHAR(50),     /* 제품코드 */
    IN p_work_flag VARCHAR(5),      /* 작업플래그 */
    IN p_scomment  VARCHAR(500),    /* 코멘트 */
    IN p_user_id   VARCHAR(50)      /* 등록자 */
)
BEGIN
    INSERT INTO TSHP_NG_FILE_WORK_MASTER (
        PLT_CODE, PROD_CODE, WORK_FLAG, SCOMMENT,
        REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_prod_code, p_work_flag, p_scomment,
        NOW(), p_user_id
    );
END//


-- ============================================================
-- 3. sp_imes_tshp_ng_file_work_master_upd: 수정
-- 원본: POP55A TSHP_NG_FILE_WORK_MASTER UPD
-- 용도: NG파일 확인 마스터 수정 (플래그/코멘트/수정자)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_work_master_upd//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_work_master_upd(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_prod_code VARCHAR(50),     /* 제품코드 */
    IN p_work_flag VARCHAR(5),      /* 작업플래그 */
    IN p_scomment  VARCHAR(500),    /* 코멘트 */
    IN p_user_id   VARCHAR(50)      /* 수정자 */
)
BEGIN
    UPDATE TSHP_NG_FILE_WORK_MASTER SET
        SCOMMENT  = p_scomment,
        WORK_FLAG = p_work_flag,
        MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND PROD_CODE = p_prod_code;
END//


-- ============================================================
-- 4. sp_imes_tshp_ng_file_work_master_del: 삭제
-- 원본: POP55A TSHP_NG_FILE_WORK_MASTER DEL
-- 용도: NG파일 확인 마스터 삭제 (물리 삭제)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_work_master_del//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_work_master_del(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_prod_code VARCHAR(50)      /* 제품코드 */
)
BEGIN
    DELETE FROM TSHP_NG_FILE_WORK_MASTER
    WHERE PLT_CODE = p_plt_code
      AND PROD_CODE = p_prod_code;
END//


DELIMITER ;
