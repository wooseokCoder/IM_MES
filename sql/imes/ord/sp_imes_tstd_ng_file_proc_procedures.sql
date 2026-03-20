-- ============================================================================
-- TSTD_NG_FILE_PROC: NG파일 공정 매핑 관련 프로시저
-- ============================================================================
-- 용도: ORD32A Grid3 / D0A Grid3 (선택 파일의 적용 공정)
-- 원본: ProActive TSTD_NG_FILE_PROC.cs, TSTD_NG_FILE_PROC_QUERY.cs
-- 작성일: 2026-03-10
-- ============================================================================

-- ============================================================
-- sp_imes_tstd_ng_file_proc_ser
--   선택 파일의 적용 공정 조회 (Grid3 / D0A Grid3)
--   JOIN: LSE_STD_PROC (공정명 가져오기, DATA_FLAG=0)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_file_proc_ser;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_file_proc_ser(
    IN p_plt_code   VARCHAR(3),
    IN p_file_id    VARCHAR(30)
)
BEGIN
    SELECT F.PLT_CODE   AS pltCode
          ,M.PROC_NAME  AS procName
          ,F.PROC_CODE  AS procCode
      FROM TSTD_NG_FILE_PROC F
      LEFT JOIN LSE_STD_PROC M
        ON F.PLT_CODE  = M.PLT_CODE
       AND F.PROC_CODE = M.PROC_CODE
       AND M.DATA_FLAG = 0
     WHERE F.PLT_CODE = p_plt_code
       AND F.FILE_ID  = p_file_id;
END$$
DELIMITER ;


-- ============================================================
-- sp_imes_tstd_ng_file_proc_del
--   공정 매핑 전체 삭제 (FILE_ID 단위)
--   용도: ORD32A_INS 저장 시 기존 매핑 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_file_proc_del;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_file_proc_del(
    IN p_plt_code   VARCHAR(3),
    IN p_file_id    VARCHAR(30)
)
BEGIN
    DELETE FROM TSTD_NG_FILE_PROC
     WHERE PLT_CODE = p_plt_code
       AND FILE_ID  = p_file_id;
END$$
DELIMITER ;


-- ============================================================
-- sp_imes_tstd_ng_file_proc_ins
--   공정 매핑 개별 등록
--   용도: ORD32A_INS 저장 시 선택된 공정 행별 INSERT
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_file_proc_ins;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_file_proc_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_file_id    VARCHAR(30),
    IN p_proc_code  VARCHAR(50),
    IN p_user_id    VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_NG_FILE_PROC (PLT_CODE, FILE_ID, PROC_CODE, REG_DATE, REG_EMP)
    VALUES (p_plt_code, p_file_id, p_proc_code, NOW(), p_user_id);
END$$
DELIMITER ;
