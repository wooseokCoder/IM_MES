-- ============================================================
-- 파일명: sp_imes_tpop_mc_daily_check_result_query_procedures.sql
-- 설명: 일일점검 이력 조회 프로시저 (POP42A)
--       TPOP_MC_DAILY_CHECK_RESULT 테이블 조회
-- 작성자: 송우석
-- 작성일: 2026-03-10
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tpop_mc_daily_check_result_query2
-- 용도: POP42A 마스터 그리드 조회 (설비별 점검일 목록)
-- JOIN: LSE_MACHINE (설비명)
-- 파라미터:
--   p_plt_code      - 공장코드 (gsPltCode)
--   p_mc_like       - 설비코드/명 LIKE 검색
--   p_s_mdcr_date   - 점검일 시작 (yyyyMMdd)
--   p_e_mdcr_date   - 점검일 종료 (yyyyMMdd)
--   p_data_flag     - 데이터 상태 (0=활성)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tpop_mc_daily_check_result_query2//

CREATE PROCEDURE sp_imes_tpop_mc_daily_check_result_query2(
    IN p_plt_code       VARCHAR(3),
    IN p_mc_like        VARCHAR(100),
    IN p_s_mdcr_date    VARCHAR(8),
    IN p_e_mdcr_date    VARCHAR(8),
    IN p_data_flag      INT
)
BEGIN
    SELECT DISTINCT
        A.MDCR_MC_CODE      AS mdcrMcCode,
        B.MC_NAME            AS mdcrMcName,
        A.MDCR_DATE          AS mdcrDate
    FROM TPOP_MC_DAILY_CHECK_RESULT A
        INNER JOIN LSE_MACHINE B
            ON A.PLT_CODE = B.PLT_CODE
            AND A.MDCR_MC_CODE = B.MC_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND (A.DATA_FLAG IS NULL OR A.DATA_FLAG = p_data_flag)
      AND (p_s_mdcr_date IS NULL OR p_s_mdcr_date = ''
           OR A.MDCR_DATE >= p_s_mdcr_date)
      AND (p_e_mdcr_date IS NULL OR p_e_mdcr_date = ''
           OR A.MDCR_DATE <= p_e_mdcr_date)
      AND (p_mc_like IS NULL OR p_mc_like = ''
           OR B.MC_NAME LIKE CONCAT('%', p_mc_like, '%')
           OR A.MDCR_MC_CODE LIKE CONCAT('%', p_mc_like, '%'))
    ORDER BY A.MDCR_DATE ASC, B.MC_NAME ASC;
END//

-- ============================================================
-- sp_imes_tpop_mc_daily_check_result_query1
-- 용도: POP42A 디테일 그리드 조회 (선택된 설비/일의 점검항목 상세)
-- 파라미터:
--   p_plt_code    - 공장코드
--   p_mc_code     - 설비코드 (마스터에서 선택)
--   p_mdcr_date   - 점검일 (마스터에서 선택)
--   p_data_flag   - 데이터 상태
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tpop_mc_daily_check_result_query1//

CREATE PROCEDURE sp_imes_tpop_mc_daily_check_result_query1(
    IN p_plt_code       VARCHAR(3),
    IN p_mc_code        VARCHAR(20),
    IN p_mdcr_date      VARCHAR(8),
    IN p_data_flag      INT
)
BEGIN
    SELECT
        A.MDCR_NO            AS mdcrNo,
        A.MDCR_TYPE          AS mdcrType,
        A.MDCR_NUM           AS mdcrNum,
        A.MDCR_CONTENTS      AS mdcrContents,
        A.MDCR_CHECK         AS mdcrCheck,
        A.MDCR_MEANS         AS mdcrMeans,
        A.MDCR_RESULT        AS mdcrResult,
        A.MDCR_SCOMMENT      AS mdcrScomment,
        A.MDCR_SEQ           AS mdcrSeq
    FROM TPOP_MC_DAILY_CHECK_RESULT A
    WHERE A.PLT_CODE = p_plt_code
      AND A.MDCR_MC_CODE = p_mc_code
      AND A.MDCR_DATE = p_mdcr_date
      AND (A.DATA_FLAG IS NULL OR A.DATA_FLAG = p_data_flag)
    ORDER BY A.MDCR_SEQ ASC, A.MDCR_TYPE ASC, A.MDCR_NUM ASC;
END//

DELIMITER ;
