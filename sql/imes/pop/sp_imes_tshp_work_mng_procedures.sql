-- ============================================================
-- TSHP_WORK_MNG 부적합 관리 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: TSHP_WORK_MNG
-- 원본: ProActive TSHP_WORK_MNG.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (2개):
--   1. sp_imes_tshp_work_mng_ins    - 부적합 요청 등록
--   2. sp_imes_tshp_work_mng_query1 - 부적합 목록 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_work_mng_ins: 부적합 요청 등록
-- 원본: TSHP_WORK_MNG.TSHP_WORK_MNG_INS()
-- 용도: POP30B 부적합 발생 시 요청 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_work_mng_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_work_mng_ins(
    IN p_plt_code      VARCHAR(10),     /* 공장코드 */
    IN p_req_code      VARCHAR(30),     /* 요청코드 */
    IN p_mng_type      VARCHAR(10),     /* 관리유형 */
    IN p_wo_no         VARCHAR(20),     /* 작업오더번호 */
    IN p_mc_code       VARCHAR(20),     /* 설비코드 */
    IN p_emp_code      VARCHAR(20),     /* 작업자코드 */
    IN p_proc_code     VARCHAR(20),     /* 공정코드 */
    IN p_part_code     VARCHAR(50),     /* 품목코드 */
    IN p_req_contents  VARCHAR(1000),   /* 요청내용 */
    IN p_user_id       VARCHAR(50)      /* 등록자 */
)
BEGIN
    INSERT INTO TSHP_WORK_MNG (
        PLT_CODE, REQ_CODE, MNG_TYPE, WO_NO, MC_CODE, EMP_CODE,
        PROC_CODE, PART_CODE, REQ_CONTENTS, REQ_DATE,
        REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_req_code, p_mng_type, p_wo_no, p_mc_code, p_emp_code,
        p_proc_code, p_part_code, p_req_contents, NOW(),
        NOW(), p_user_id, 0
    );
END//


-- ============================================================
-- 2. sp_imes_tshp_work_mng_query1: 부적합 목록 조회
-- 원본: TSHP_WORK_MNG.TSHP_WORK_MNG_QUERY1()
-- 용도: POP30B 부적합 이력 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_work_mng_query1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_work_mng_query1(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_mng_type  VARCHAR(10),     /* 관리유형 */
    IN p_wo_no     VARCHAR(20)      /* 작업오더번호 */
)
BEGIN
    SELECT
        W.PLT_CODE         AS "pltCode"
       ,W.REQ_CODE          AS "reqCode"
       ,W.MNG_TYPE          AS "mngType"
       ,W.WO_NO             AS "woNo"
       ,W.MC_CODE           AS "mcCode"
       ,W.EMP_CODE          AS "empCode"
       ,E.EMP_NAME          AS "empName"
       ,W.PROC_CODE         AS "procCode"
       ,W.PART_CODE         AS "partCode"
       ,SP.PART_NAME        AS "partName"
       ,W.REQ_CONTENTS      AS "reqContents"
       ,DATE_FORMAT(W.REQ_DATE, '%Y-%m-%d %H:%i:%s') AS "reqDate"
       ,W.RES_CONTENTS      AS "resContents"
       ,DATE_FORMAT(W.RES_DATE, '%Y-%m-%d %H:%i:%s') AS "resDate"
    FROM TSHP_WORK_MNG W
    LEFT JOIN TSTD_EMPLOYEE E ON W.PLT_CODE = E.PLT_CODE AND W.EMP_CODE = E.EMP_CODE
    LEFT JOIN LSE_STD_PART SP ON W.PLT_CODE = SP.PLT_CODE AND W.PART_CODE = SP.PART_CODE
    WHERE W.PLT_CODE  = p_plt_code
      AND W.MNG_TYPE  = p_mng_type
      AND W.DATA_FLAG = 0
      AND (p_wo_no IS NULL OR p_wo_no = '' OR W.WO_NO = p_wo_no)
    ORDER BY W.REQ_DATE DESC;
END//


DELIMITER ;
