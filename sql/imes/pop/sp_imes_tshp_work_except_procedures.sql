-- ============================================================
-- TSHP_WORK_EXCEPT CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-05
-- 대상 테이블: TSHP_WORK_EXCEPT (예외 처리)
-- 원본: ProActive TSHP_WORK_EXCEPT.cs
-- 화면: POP33A (공수오류현황)
-- ============================================================
-- 포함 프로시저 (4개):
--   1. sp_imes_tshp_work_except_ser   - 예외 처리 조회
--   2. sp_imes_tshp_work_except_ins   - 예외 처리 등록
--   3. sp_imes_tshp_work_except_upd   - 예외 처리 수정
--   4. sp_imes_tshp_work_except_save  - 예외 처리 UPSERT
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_work_except_ser: 예외 처리 조회
-- 원본: TSHP_WORK_EXCEPT.TSHP_WORK_EXCEPT_SER()
-- 용도: POP33A 작업자/일자별 예외 처리 여부 확인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_work_except_ser//

CREATE PROCEDURE sp_imes_tshp_work_except_ser(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_emp_code  VARCHAR(20)     /* 작업자코드 */
)
BEGIN
    SELECT
        PLT_CODE                AS "pltCode"
       ,WORK_DATE               AS "workDate"
       ,EMP_CODE                AS "empCode"
       ,IS_EXCEPT               AS "isExcept"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')  AS "regDate"
       ,REG_EMP                 AS "regEmp"
       ,DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS "mdfyDate"
       ,MDFY_EMP                AS "mdfyEmp"
    FROM TSHP_WORK_EXCEPT
    WHERE PLT_CODE = p_plt_code
      AND WORK_DATE = p_work_date
      AND EMP_CODE = p_emp_code;
END//


-- ============================================================
-- 2. sp_imes_tshp_work_except_ins: 예외 처리 등록
-- 원본: TSHP_WORK_EXCEPT.TSHP_WORK_EXCEPT_INS()
-- 용도: POP33A 예외 처리 최초 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_work_except_ins//

CREATE PROCEDURE sp_imes_tshp_work_except_ins(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_is_except VARCHAR(5),     /* 예외 여부 */
    IN p_user_id   VARCHAR(50)     /* 등록자 */
)
BEGIN
    INSERT INTO TSHP_WORK_EXCEPT (
        PLT_CODE, WORK_DATE, EMP_CODE, IS_EXCEPT, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_work_date, p_emp_code, p_is_except, NOW(), p_user_id
    );
END//


-- ============================================================
-- 3. sp_imes_tshp_work_except_upd: 예외 처리 수정
-- 원본: TSHP_WORK_EXCEPT.TSHP_WORK_EXCEPT_UPD()
-- 용도: POP33A 예외 처리 상태 변경
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_work_except_upd//

CREATE PROCEDURE sp_imes_tshp_work_except_upd(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_is_except VARCHAR(5),     /* 예외 여부 */
    IN p_user_id   VARCHAR(50)     /* 수정자 */
)
BEGIN
    UPDATE TSHP_WORK_EXCEPT SET
        IS_EXCEPT = p_is_except,
        MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND WORK_DATE = p_work_date
      AND EMP_CODE = p_emp_code;
END//


-- ============================================================
-- 4. sp_imes_tshp_work_except_save: 예외 처리 UPSERT (저장)
-- 용도: POP33A 제외 여부 저장 — 있으면 UPDATE, 없으면 INSERT
-- 호출: pop33aIns3()에서 SER→INS/UPD 3번 호출을 1번으로 통합
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_work_except_save//

CREATE PROCEDURE sp_imes_tshp_work_except_save(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_is_except VARCHAR(5),     /* 예외 여부 */
    IN p_user_id   VARCHAR(50)     /* 등록/수정자 */
)
BEGIN
    INSERT INTO TSHP_WORK_EXCEPT (
        PLT_CODE, WORK_DATE, EMP_CODE, IS_EXCEPT, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_work_date, p_emp_code, p_is_except, NOW(), p_user_id
    )
    ON DUPLICATE KEY UPDATE
        IS_EXCEPT = p_is_except,
        MDFY_DATE = NOW(),
        MDFY_EMP  = p_user_id;
END//


DELIMITER ;
