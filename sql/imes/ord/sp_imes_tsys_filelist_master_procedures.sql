-- ============================================================================
-- TSYS_FILELIST_MASTER: 파일목록 관련 프로시저
-- ============================================================================
-- 용도: ORD32A Grid1 파일목록 조회
-- 원본: ProActive TSYS_FILELIST_MASTER_QUERY.cs
-- 작성일: 2026-03-10
-- 수정일: 2026-03-11 SP 이름 변경 (FTP용 SP와 이름 충돌 해소)
-- ============================================================================

-- ============================================================
-- sp_imes_tsys_filelist_master_query1
--   파일목록 조회 (ORD32A Grid1)
--   조건: LINK_KEY='NG_ASSY_FILE', DATA_FLAG=0, IS_UPLOAD=1
--   JOIN: SYS_USER (등록자명)
--   ※ 기존 sp_imes_tsys_filelist_master_ser에서 이름 변경
--     (FTP 다운로드용 동명 SP와 충돌 방지)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_filelist_master_query1;
DROP PROCEDURE IF EXISTS sp_imes_tsys_filelist_master_ser;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tsys_filelist_master_query1(
    IN p_plt_code   VARCHAR(3)
)
BEGIN
    SELECT F.FILE_ID    AS fileId
          ,F.FILE_NAME  AS fileName
          ,DATE_FORMAT(F.REG_DATE, '%Y-%m-%d') AS regDate
          ,F.REG_EMP    AS regEmp
          ,U.USER_NAME  AS regEmpName
      FROM TSYS_FILELIST_MASTER F
      LEFT JOIN SYS_USER U
        ON U.SYS_ID = 'IMMES'
       AND F.REG_EMP = U.USER_ID
     WHERE F.PLT_CODE  = p_plt_code
       AND F.LINK_KEY   = 'NG_ASSY_FILE'
       AND F.IS_UPLOAD  = 1
       AND F.DATA_FLAG  = 0
     ORDER BY F.FILE_SEQ;
END$$
DELIMITER ;
