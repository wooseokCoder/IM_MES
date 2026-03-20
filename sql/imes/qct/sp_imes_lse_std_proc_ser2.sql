-- ============================================================================
-- LSE_STD_PROC 공정코드 조회 프로시저 (1개)
-- QCT04A/QCT05A 검사공정 콤보박스 + acProcForm 공통 팝업용: SER2
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-27
-- 수정일: 2026-03-06 acProcForm 컬럼 추가 (lprocName, mprocName, procColor, isOs)
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_std_proc_ser2
-- 공정코드 목록 조회 (LPROC_CODE 기반 필터)
-- acProcForm 공통 팝업에서 사용: 대일정/중일정/색상/외주가능 포함
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_std_proc_ser2//

CREATE PROCEDURE sp_imes_lse_std_proc_ser2(
    IN p_plt_code       VARCHAR(3),
    IN p_lproc_code     VARCHAR(10)
)
BEGIN
    SELECT
        LPROC_CODE      AS lprocName,
        MPROC_CODE      AS mprocName,
        PROC_COLOR      AS procColor,
        PROC_CODE       AS procCode,
        PROC_NAME       AS procName,
        IS_OS           AS isOs
    FROM LSE_STD_PROC
    WHERE PLT_CODE = p_plt_code
      AND DATA_FLAG = 0
      AND (p_lproc_code IS NULL OR p_lproc_code = '' OR LPROC_CODE = p_lproc_code)
    ORDER BY PROC_SEQ, PROC_CODE;
END//

DELIMITER ;
