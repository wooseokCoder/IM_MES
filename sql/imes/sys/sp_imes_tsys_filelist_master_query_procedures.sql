-- ============================================================
-- 파일명: sp_imes_tsys_filelist_master_query_procedures.sql
-- 테이블: TSYS_FILELIST_MASTER
-- 설명: 파일 목록 조회 프로시저
-- 원본: ProActive TSYS_FILELIST_MASTER_QUERY.cs
-- 작성일: 2026-03-03
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tsys_filelist_master_query6
-- 설명: 파일 목록 조회 (UPLOAD_MENU, MODEL_LIKE 조건)
-- 용도: STD47A_SER2 (작업표준서 리스트)
-- 원본: TSYS_FILELIST_MASTER_QUERY.cs > TSYS_FILELIST_MASTER_QUERY6
-- ※ LINK_KEY 포맷: {MODEL_NO}-{PROC_CODE}  (마지막 '-' 기준 분리)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tsys_filelist_master_query6//

CREATE PROCEDURE sp_imes_tsys_filelist_master_query6(
    IN p_PLT_CODE       VARCHAR(3),
    IN p_UPLOAD_MENU    VARCHAR(20),
    IN p_MODEL_LIKE     VARCHAR(100),
    IN p_DATA_FLAG      TINYINT
)
BEGIN
    SELECT
        A.PLT_CODE,
        A.FILE_ID,
        -- LINK_KEY에서 마지막 '-' 앞부분 → MODEL_NO
        LEFT(A.LINK_KEY,
             LENGTH(A.LINK_KEY) - LOCATE('-', REVERSE(A.LINK_KEY))
        )                                                                   AS MODEL_NO,
        -- LINK_KEY에서 마지막 '-' 뒷부분 → PROC_CODE
        SUBSTRING_INDEX(A.LINK_KEY, '-', -1)                               AS PROC_CODE,
        M.MODEL_TYPE,
        M.MODEL_SERISE,
        A.FILE_NAME,
        A.LINK_KEY,
        DATE_FORMAT(A.REG_DATE, '%Y-%m-%d %H:%i:%s')                       AS REG_DATE,
        A.REG_EMP,
        U.USER_NAME                                                         AS REG_EMP_NAME
    FROM  TSYS_FILELIST_MASTER A
    -- 프로세스 그룹 (ORDER BY PRG_SEQ 용도)
    LEFT JOIN TSTD_PROCGRP B
           ON  A.PLT_CODE = B.PLT_CODE
           AND SUBSTRING_INDEX(A.LINK_KEY, '-', -1) = B.PRG_CODE
    -- 모델 정보 (DATA_TYPE='S' 조건, LINK_KEY에서 추출한 MODEL_NO로 JOIN)
    LEFT JOIN TSTD_MODEL M
           ON  A.PLT_CODE = M.PLT_CODE
           AND LEFT(A.LINK_KEY,
                    LENGTH(A.LINK_KEY) - LOCATE('-', REVERSE(A.LINK_KEY))
               ) = M.MODEL_NO
           AND M.DATA_TYPE = 'S'
    -- 등록자 정보
    LEFT JOIN SYS_USER U
           ON  A.PLT_CODE = U.PLT_CODE
           AND A.REG_EMP  = U.USER_ID
    WHERE A.PLT_CODE  = p_PLT_CODE
      AND A.IS_UPLOAD = '1'
      AND A.DATA_FLAG = p_DATA_FLAG
      AND (p_UPLOAD_MENU IS NULL OR p_UPLOAD_MENU = ''
           OR A.UPLOAD_MENU = p_UPLOAD_MENU)
      -- MODEL_LIKE: 원본과 동일하게 완전일치(=) 조건. 빈값이면 조건 무시
      AND (p_MODEL_LIKE IS NULL OR p_MODEL_LIKE = ''
           OR LEFT(A.LINK_KEY,
                   LENGTH(A.LINK_KEY) - LOCATE('-', REVERSE(A.LINK_KEY))
              ) = p_MODEL_LIKE)
    ORDER BY
        LEFT(A.LINK_KEY,
             LENGTH(A.LINK_KEY) - LOCATE('-', REVERSE(A.LINK_KEY))
        ),
        B.PRG_SEQ;
END//

DELIMITER ;
