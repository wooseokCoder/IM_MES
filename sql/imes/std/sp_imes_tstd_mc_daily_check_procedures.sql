-- ============================================================
-- TSTD_MC_DAILY_CHECK CRUD 프로시저
-- 생성일: 2026-02-06
-- 대상 테이블: TSTD_MC_DAILY_CHECK
-- 작성자: 송우석
-- ============================================================
-- 명명 규칙: sp_imes_tstd_mc_daily_check_[액션]
-- ============================================================
-- 의존성: TSYS_SERIAL 테이블 (SMDC_NO 채번용)
--         sql/imes/common/sp_imes_utility_serial_procedures.sql 먼저 실행 필요
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_mc_daily_check_ser: 단건 조회 (PLT_CODE + SMDC_NO)
-- 용도: 존재 여부 확인, 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_daily_check_ser//

CREATE PROCEDURE sp_imes_tstd_mc_daily_check_ser(
    IN p_plt_code VARCHAR(10),
    IN p_smdc_no VARCHAR(20)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        SMDC_NO AS smdcNo,
        SMDC_TYPE AS smdcType,
        SMDC_NUM AS smdcNum,
        SMDC_CONTENTS AS smdcContents,
        SMDC_CHECK AS smdcCheck,
        SMDC_MEANS AS smdcMeans,
        SMDC_SEQ AS smdcSeq,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DATA_FLAG AS dataFlag
    FROM TSTD_MC_DAILY_CHECK
    WHERE PLT_CODE = p_plt_code
      AND SMDC_NO = p_smdc_no;
END//

-- ============================================================
-- sp_imes_tstd_mc_daily_check_ins: 등록
-- 용도: 신규 점검항목 등록
-- 참고: SMDC_NO는 Service에서 UtilityService.getSerialNo로 채번하여 전달
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_daily_check_ins//

CREATE PROCEDURE sp_imes_tstd_mc_daily_check_ins(
    IN p_plt_code VARCHAR(10),
    IN p_smdc_no VARCHAR(20),
    IN p_smdc_type VARCHAR(50),
    IN p_smdc_num VARCHAR(20),
    IN p_smdc_contents TEXT,
    IN p_smdc_check TEXT,
    IN p_smdc_means VARCHAR(100),
    IN p_smdc_seq INT,
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_MC_DAILY_CHECK (
        PLT_CODE, SMDC_NO, SMDC_TYPE, SMDC_NUM,
        SMDC_CONTENTS, SMDC_CHECK, SMDC_MEANS, SMDC_SEQ,
        REG_EMP, REG_DATE, DATA_FLAG
    ) VALUES (
        p_plt_code, p_smdc_no, p_smdc_type, p_smdc_num,
        p_smdc_contents, p_smdc_check, p_smdc_means, p_smdc_seq,
        p_user_id, NOW(), 0
    );
END//

-- ============================================================
-- sp_imes_tstd_mc_daily_check_upd: 수정 (전체 필드)
-- 용도: 팝업에서 전체 필드 수정 (DATA_FLAG=0 복원)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_daily_check_upd//

CREATE PROCEDURE sp_imes_tstd_mc_daily_check_upd(
    IN p_plt_code VARCHAR(10),
    IN p_smdc_no VARCHAR(20),
    IN p_smdc_type VARCHAR(50),
    IN p_smdc_num VARCHAR(20),
    IN p_smdc_contents TEXT,
    IN p_smdc_check TEXT,
    IN p_smdc_means VARCHAR(100),
    IN p_smdc_seq INT,
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_MC_DAILY_CHECK SET
        SMDC_TYPE = p_smdc_type,
        SMDC_NUM = p_smdc_num,
        SMDC_CONTENTS = p_smdc_contents,
        SMDC_CHECK = p_smdc_check,
        SMDC_MEANS = p_smdc_means,
        SMDC_SEQ = p_smdc_seq,
        MDFY_DATE = NOW(),
        MDFY_EMP = p_user_id,
        DATA_FLAG = 0,
        DEL_DATE = NULL,
        DEL_EMP = NULL
    WHERE PLT_CODE = p_plt_code
      AND SMDC_NO = p_smdc_no;
END//

-- ============================================================
-- sp_imes_tstd_mc_daily_check_ude: 삭제 (논리삭제)
-- 용도: DATA_FLAG = 2로 논리 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_daily_check_ude//

CREATE PROCEDURE sp_imes_tstd_mc_daily_check_ude(
    IN p_plt_code VARCHAR(10),
    IN p_smdc_no VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_MC_DAILY_CHECK SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND SMDC_NO = p_smdc_no;
END//

DELIMITER ;

-- ============================================================
-- 실행 안내
-- ============================================================
-- 1. [필수] 먼저 TSYS_SERIAL 테이블 생성:
--    sql/imes/common/sp_imes_utility_serial_procedures.sql 실행
-- 2. MySQL Workbench 또는 CLI에서 이 스크립트 실행
-- 3. 운영 DB에 적용 후 doc/PROCEDURE_SYNC_RULE.md에 기록
-- ============================================================
