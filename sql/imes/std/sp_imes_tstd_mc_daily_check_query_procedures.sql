-- ============================================================
-- TSTD_MC_DAILY_CHECK 조회 프로시저
-- 생성일: 2026-02-06
-- 대상 테이블: TSTD_MC_DAILY_CHECK
-- 작성자: 송우석
-- ============================================================
-- 명명 규칙: sp_imes_tstd_mc_daily_check_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_mc_daily_check_query1: 점검항목 목록 조회
-- 용도: 메인 그리드 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_daily_check_query1//

CREATE PROCEDURE sp_imes_tstd_mc_daily_check_query1(
    IN p_plt_code VARCHAR(10),
    IN p_type_like VARCHAR(100),
    IN p_contents_like VARCHAR(100),
    IN p_data_flag INT
)
BEGIN
    SELECT
        A.PLT_CODE AS pltCode,
        A.SMDC_NO AS smdcNo,
        A.SMDC_TYPE AS smdcType,
        A.SMDC_NUM AS smdcNum,
        A.SMDC_CONTENTS AS smdcContents,
        A.SMDC_CHECK AS smdcCheck,
        A.SMDC_MEANS AS smdcMeans,
        A.SMDC_SEQ AS smdcSeq,
        DATE_FORMAT(A.REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        A.REG_EMP AS regEmp,
        DATE_FORMAT(A.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        A.MDFY_EMP AS mdfyEmp,
        A.DATA_FLAG AS dataFlag
    FROM TSTD_MC_DAILY_CHECK A
    WHERE A.PLT_CODE = p_plt_code
      AND (p_type_like IS NULL OR p_type_like = ''
           OR A.SMDC_TYPE LIKE CONCAT('%', p_type_like, '%'))
      AND (p_contents_like IS NULL OR p_contents_like = ''
           OR A.SMDC_CONTENTS LIKE CONCAT('%', p_contents_like, '%'))
      AND A.DATA_FLAG = IFNULL(p_data_flag, 0)
    ORDER BY A.SMDC_SEQ, A.SMDC_NO;
END//


-- ============================================================
-- sp_imes_tstd_mc_daily_check_query2: 일일점검 템플릿 조회
-- 원본: TSTD_MC_DAILY_CHECK.TSTD_MC_DAILY_CHECK_QUERY2()
-- 용도: POP30B 일일점검 - 기존 결과 없을 때 템플릿 항목 조회
-- AS-IS: SMDC_* AS MDCR_* 매핑 (기존 결과 컬럼명과 통일)
-- 추가일: 2026-03-19
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_daily_check_query2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_mc_daily_check_query2(
    IN p_plt_code  VARCHAR(10)
)
BEGIN
    SELECT
        PLT_CODE         AS "pltCode"
       ,''               AS "mdcrNo"
       ,''               AS "mdcrDate"
       ,''               AS "mdcrMcCode"
       ,SMDC_TYPE        AS "mdcrType"
       ,SMDC_NUM         AS "mdcrNum"
       ,SMDC_CONTENTS    AS "mdcrContents"
       ,SMDC_CHECK       AS "mdcrCheck"
       ,SMDC_MEANS       AS "mdcrMeans"
       ,''               AS "mdcrResult"
       ,''               AS "mdcrScomment"
       ,SMDC_SEQ         AS "mdcrSeq"
    FROM TSTD_MC_DAILY_CHECK
    WHERE PLT_CODE = p_plt_code
      AND DATA_FLAG = 0
    ORDER BY SMDC_SEQ;
END//

DELIMITER ;

