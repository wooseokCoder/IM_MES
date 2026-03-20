-- ============================================================
-- TSYS_FILELIST_MASTER 파일 목록 조회 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: TSYS_FILELIST_MASTER
-- 원본: ProActive TSYS_FILELIST_MASTER.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (1개):
--   1. sp_imes_tsys_filelist_master_query1 - 파일 목록 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tsys_filelist_master_query1: 파일 목록 조회
-- 원본: TSYS_FILELIST_MASTER.TSYS_FILELIST_MASTER_QUERY1()
-- 용도: POP30B 첨부파일 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_filelist_master_query1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tsys_filelist_master_query1(
    IN p_plt_code   VARCHAR(10),     /* 공장코드 */
    IN p_cat_code   VARCHAR(20),     /* 카테고리코드 */
    IN p_ref_code   VARCHAR(50)      /* 참조코드 */
)
BEGIN
    SELECT
        PLT_CODE       AS "pltCode"
       ,FILE_CODE       AS "fileCode"
       ,FILE_NAME       AS "fileName"
       ,FILE_PATH       AS "filePath"
       ,FILE_SIZE       AS "fileSize"
       ,REG_EMP         AS "regEmp"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d') AS "regDate"
    FROM TSYS_FILELIST_MASTER
    WHERE PLT_CODE = p_plt_code
      AND DATA_FLAG = 0
      AND (p_cat_code IS NULL OR p_cat_code = '' OR CAT_CODE = p_cat_code)
      AND (p_ref_code IS NULL OR p_ref_code = '' OR REF_CODE = p_ref_code)
    ORDER BY REG_DATE DESC;
END//


DELIMITER ;
