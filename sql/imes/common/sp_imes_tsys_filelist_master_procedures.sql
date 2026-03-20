-- ============================================================================
-- sp_imes_tsys_filelist_master_procedures.sql
-- ============================================================================
-- 설명: TSYS_FILELIST_MASTER 관련 프로시저 모음
--       - SER: 파일 메타정보 조회 (FTP 다운로드용)
-- ============================================================================
-- 작성일: 2026-03-07
-- ============================================================================

-- sp_imes_tsys_filelist_master_ser: 파일 메타정보 조회
-- ============================================================================
-- 설명: TSYS_FILELIST_MASTER에서 FILE_ID로 파일 메타정보 조회
--       FTP 다운로드 시 파일명, 등록일자 등 필요 정보 제공
-- 파라미터:
--   p_plt_code: 공장 코드 (PLT_CODE)
--   p_file_id:  파일 ID (FILE_ID)
-- 반환: FILE_ID, FILE_NAME, FILE_SIZE, REG_DATE 등
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_filelist_master_ser;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tsys_filelist_master_ser(
    IN p_plt_code VARCHAR(3),
    IN p_file_id VARCHAR(20)
)
BEGIN
    SELECT
        PLT_CODE AS "pltCode",
        FILE_ID AS "fileId",
        FILE_NAME AS "fileName",
        FILE_SIZE AS "fileSize",
        LINK_KEY AS "linkKey",
        IS_UPLOAD AS "isUpload",
        UPLOAD_MENU AS "uploadMenu",
        UPLOAD_CLASS AS "uploadClass",
        DATE_FORMAT(REG_DATE, '%Y-%m-%d') AS "regDate",
        REG_EMP AS "regEmp",
        DATA_FLAG AS "dataFlag"
    FROM TSYS_FILELIST_MASTER
    WHERE PLT_CODE = p_plt_code
      AND FILE_ID = p_file_id
      AND DATA_FLAG = 0;
END$$
DELIMITER ;
