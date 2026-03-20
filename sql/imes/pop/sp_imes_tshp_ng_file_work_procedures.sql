-- ============================================================
-- TSHP_NG_FILE_WORK CRUD 프로시저
-- 생성일: 2026-03-07
-- 대상 테이블: TSHP_NG_FILE_WORK
-- 원본: ProActive POP55A.cs (TSHP_NG_FILE_WORK CRUD)
-- 화면: POP55A (NAM공정 NG파일배포 확인)
-- ============================================================
-- 포함 프로시저 (3개):
--   1. sp_imes_tshp_ng_file_work_ser  - 존재 여부 조회 (단건)
--   2. sp_imes_tshp_ng_file_work_ins  - 신규 등록
--   3. sp_imes_tshp_ng_file_work_del  - 삭제 (PROD_CODE 기반 일괄)
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_ng_file_work_ser: 존재 여부 조회
-- 원본: POP55A TSHP_NG_FILE_WORK SER
-- 용도: INS 전 기존 데이터 존재 여부 확인 (중복 방지)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_work_ser//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_work_ser(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_file_id   VARCHAR(50),     /* 파일ID */
    IN p_model     VARCHAR(100),    /* 모델번호 */
    IN p_proc_code VARCHAR(20),     /* 공정코드 */
    IN p_wo_no     VARCHAR(50)      /* 작업오더번호 */
)
BEGIN
    SELECT
        PLT_CODE    AS "pltCode"
       ,FILE_ID     AS "fileId"
       ,MODEL       AS "model"
       ,PROC_CODE   AS "procCode"
       ,WO_NO       AS "woNo"
       ,IMAGE       AS "image"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')  AS "regDate"
       ,REG_EMP     AS "regEmp"
    FROM TSHP_NG_FILE_WORK
    WHERE PLT_CODE = p_plt_code
      AND FILE_ID = p_file_id
      AND MODEL = p_model
      AND PROC_CODE = p_proc_code
      AND WO_NO = p_wo_no;
END//


-- ============================================================
-- 2. sp_imes_tshp_ng_file_work_ins: 신규 등록
-- 원본: POP55A TSHP_NG_FILE_WORK INS
-- 용도: NG파일 작업 상세 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_work_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_work_ins(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_file_id   VARCHAR(50),     /* 파일ID */
    IN p_model     VARCHAR(100),    /* 모델번호 */
    IN p_proc_code VARCHAR(20),     /* 공정코드 */
    IN p_wo_no     VARCHAR(50),     /* 작업오더번호 */
    IN p_image     VARCHAR(500),    /* 이미지 경로 */
    IN p_user_id   VARCHAR(50)      /* 등록자 */
)
BEGIN
    INSERT INTO TSHP_NG_FILE_WORK (
        PLT_CODE, FILE_ID, MODEL, PROC_CODE, WO_NO,
        IMAGE, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_file_id, p_model, p_proc_code, p_wo_no,
        p_image, NOW(), p_user_id
    );
END//


-- ============================================================
-- 3. sp_imes_tshp_ng_file_work_del: 삭제 (PROD_CODE 기반 일괄)
-- 원본: POP55A TSHP_NG_FILE_WORK DEL
-- 용도: 제품코드 기반 NG파일 작업 일괄 삭제
-- 삭제 방식: TSHP_WORKORDER에서 PROD_CODE로 WO_NO 조회 후 일괄 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_work_del//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_work_del(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_prod_code VARCHAR(50)      /* 제품코드 */
)
BEGIN
    DELETE FROM TSHP_NG_FILE_WORK
    WHERE PLT_CODE = p_plt_code
      AND WO_NO IN (
          SELECT WO_NO FROM TSHP_WORKORDER
          WHERE PROD_CODE = p_prod_code
      );
END//


DELIMITER ;
