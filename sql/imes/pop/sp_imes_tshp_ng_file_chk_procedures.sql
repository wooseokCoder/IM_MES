-- ============================================================
-- TSHP_NG_FILE_CHK 삭제 프로시저
-- 생성일: 2026-03-07
-- 대상 테이블: TSHP_NG_FILE_CHK
-- 원본: ProActive POP55A.cs (TSHP_NG_FILE_CHK DEL)
-- 화면: POP55A (NAM공정 NG파일배포 확인)
-- ============================================================
-- 포함 프로시저 (1개):
--   1. sp_imes_tshp_ng_file_chk_del  - 삭제 (PROD_CODE 기반 일괄)
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_ng_file_chk_del: 삭제 (PROD_CODE 기반 일괄)
-- 원본: POP55A TSHP_NG_FILE_CHK DEL
-- 용도: 제품코드 기반 NG파일 체크 데이터 일괄 삭제
-- 삭제 방식: TSHP_WORKORDER에서 PROD_CODE로 WO_NO 조회 후 일괄 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_chk_del//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_chk_del(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_prod_code VARCHAR(50)      /* 제품코드 */
)
BEGIN
    DELETE FROM TSHP_NG_FILE_CHK
    WHERE PLT_CODE = p_plt_code
      AND WO_NO IN (
          SELECT WO_NO FROM TSHP_WORKORDER
          WHERE PROD_CODE = p_prod_code
      );
END//


DELIMITER ;
