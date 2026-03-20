-- ============================================================================
-- LSE_STD_PROC QUERY 프로시저 (2개)
-- 표준공정 조회: QUERY8, QUERY10
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-23
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_std_proc_query10
-- 공정 콤보 데이터 조회 (MPROC_CODE 중복 제거)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_std_proc_query10//

CREATE PROCEDURE sp_imes_lse_std_proc_query10(
    IN p_plt_code   VARCHAR(3),
    IN p_data_flag  VARCHAR(3)
)
BEGIN
    SELECT
        PLT_CODE        AS pltCode,
        MPROC_CODE      AS mprocCode
    FROM LSE_STD_PROC
    WHERE PLT_CODE = p_plt_code
      AND (p_data_flag IS NULL OR p_data_flag = '' OR DATA_FLAG = p_data_flag)
    GROUP BY PLT_CODE, MPROC_CODE;
END//

-- ============================================================================
-- sp_imes_lse_std_proc_query8
-- 마스터 공정 목록 (ORD04A_PROC 서비스, Tab3 동적 컬럼용)
-- AS-IS: LSE_STD_PROC_QUERY8
-- 화면 전달: PLT_CODE, IS_FIRST_PROC
-- BIZ 고정: DATA_FLAG=0, LPROC_CODE='ASSY', USE_FLAG='1'
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_std_proc_query8//

CREATE PROCEDURE sp_imes_lse_std_proc_query8(
    IN p_plt_code       VARCHAR(3),
    IN p_is_first_proc  VARCHAR(1),
    IN p_lproc_code     VARCHAR(10),
    IN p_data_flag      VARCHAR(3),
    IN p_use_flag       VARCHAR(1)
)
BEGIN
    SELECT
        SP.PLT_CODE    AS pltCode,
        SP.PROC_CODE   AS procCode,
        SP.PROC_NAME   AS procName,
        SP.MPROC_CODE  AS mprocCode,
        SP.LPROC_CODE  AS lprocCode,
        SP.PROC_TYPE   AS procType,
        SP.PROC_SEQ    AS procSeq,
        SP.PROC_COLOR  AS procColor,
        SP.IS_OS       AS isOs,
        SP.PROC_NO     AS procNo,
        SP.ST_TIME     AS stTime,
        SP.USE_FLAG    AS useFlag,
        PG.PRG_SEQ     AS prgSeq,
        PG.PRG_CODE    AS prgCode
    FROM LSE_STD_PROC SP
    LEFT JOIN TSTD_PROCGRP PG
        ON SP.PLT_CODE = PG.PLT_CODE
       AND SP.MPROC_CODE = PG.PRG_CODE
       AND SP.LPROC_CODE = PG.UP_CLASS
    WHERE SP.PLT_CODE = p_plt_code
      AND (p_lproc_code IS NULL OR p_lproc_code = '' OR SP.LPROC_CODE = p_lproc_code)
      AND (p_data_flag IS NULL OR p_data_flag = '' OR SP.DATA_FLAG = p_data_flag)
      AND (p_data_flag IS NULL OR p_data_flag = '' OR PG.DATA_FLAG = p_data_flag)
      AND (p_use_flag IS NULL OR p_use_flag = '' OR PG.USE_FLAG = p_use_flag)
      AND (p_is_first_proc IS NULL OR p_is_first_proc = '' OR SP.PROC_NO = '10')
    ORDER BY PG.PRG_SEQ, PG.PRG_CODE, SP.PROC_CODE;
END//

DELIMITER ;
