-- ============================================================
-- TMCM_REPAIR CRUD 프로시저
-- 생성일: 2026-03-11
-- 대상 테이블: TMCM_REPAIR
-- 원본: ProActive TMCM_REPAIR.cs
-- ============================================================
-- 명명 규칙: sp_imes_tmcm_repair_[액션]
-- ============================================================
-- 의존성: TSYS_SERIAL 테이블 (MCR_ID 채번용)
--         sql/imes/common/sp_imes_utility_serial_procedures.sql 먼저 실행 필요
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tmcm_repair_ser: 단건 조회 (PLT_CODE + MCR_ID)
-- 원본: TMCM_REPAIR.TMCM_REPAIR_SER()
-- 용도: 존재 여부 확인, 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tmcm_repair_ser//

CREATE PROCEDURE sp_imes_tmcm_repair_ser(
    IN p_plt_code VARCHAR(10),
    IN p_mcr_id VARCHAR(30)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        MCR_ID AS mcrId,
        REPAIR_DATE AS repairDate,
        REPAIR_VENDOR AS repairVendor,
        REPAIR_MC AS repairMc,
        REPAIR_MC_TYPE AS repairMcType,
        REPAIR_NAME AS repairName,
        REPAIR_CONTENTS AS repairContents,
        REPAIR_AMOUNT AS repairAmount,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regiDate,
        REG_EMP AS regiId,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS chngDate,
        MDFY_EMP AS chngId,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DATA_FLAG AS dataFlag
    FROM TMCM_REPAIR
    WHERE PLT_CODE = p_plt_code
      AND MCR_ID = p_mcr_id;
END//

-- ============================================================
-- sp_imes_tmcm_repair_ins: 등록
-- 원본: TMCM_REPAIR.TMCM_REPAIR_INS()
-- 용도: 신규 수리수선 등록
-- 참고: MCR_ID는 Service에서 생성하여 전달
--       AS-IS: UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "", YYYYMMDD, 4)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tmcm_repair_ins//

CREATE PROCEDURE sp_imes_tmcm_repair_ins(
    IN p_plt_code VARCHAR(10),
    IN p_mcr_id VARCHAR(30),
    IN p_repair_date VARCHAR(10),
    IN p_repair_vendor VARCHAR(100),
    IN p_repair_mc VARCHAR(100),
    IN p_repair_mc_type VARCHAR(100),
    IN p_repair_name VARCHAR(100),
    IN p_repair_contents VARCHAR(1000),
    IN p_repair_amount DECIMAL(18,2),
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TMCM_REPAIR (
        PLT_CODE, MCR_ID, REPAIR_DATE,
        REPAIR_VENDOR, REPAIR_MC, REPAIR_MC_TYPE,
        REPAIR_NAME, REPAIR_CONTENTS, REPAIR_AMOUNT,
        REG_EMP, REG_DATE, DATA_FLAG
    ) VALUES (
        p_plt_code, p_mcr_id, p_repair_date,
        p_repair_vendor, p_repair_mc, p_repair_mc_type,
        p_repair_name, p_repair_contents, p_repair_amount,
        p_user_id, NOW(), 0
    );
END//

-- ============================================================
-- sp_imes_tmcm_repair_upd: 수정
-- 원본: TMCM_REPAIR.TMCM_REPAIR_UPD()
-- 용도: 다이얼로그에서 수정 (저장&닫기)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tmcm_repair_upd//

CREATE PROCEDURE sp_imes_tmcm_repair_upd(
    IN p_plt_code VARCHAR(10),
    IN p_mcr_id VARCHAR(30),
    IN p_repair_date VARCHAR(10),
    IN p_repair_vendor VARCHAR(100),
    IN p_repair_mc VARCHAR(100),
    IN p_repair_mc_type VARCHAR(100),
    IN p_repair_name VARCHAR(100),
    IN p_repair_contents VARCHAR(1000),
    IN p_repair_amount DECIMAL(18,2),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TMCM_REPAIR SET
        REPAIR_DATE = p_repair_date,
        REPAIR_VENDOR = p_repair_vendor,
        REPAIR_MC = p_repair_mc,
        REPAIR_MC_TYPE = p_repair_mc_type,
        REPAIR_NAME = p_repair_name,
        REPAIR_CONTENTS = p_repair_contents,
        REPAIR_AMOUNT = p_repair_amount,
        MDFY_EMP = p_user_id,
        MDFY_DATE = NOW(),
        DATA_FLAG = 0
    WHERE PLT_CODE = p_plt_code
      AND MCR_ID = p_mcr_id;
END//

-- ============================================================
-- sp_imes_tmcm_repair_ude: 삭제 (논리삭제)
-- 용도: DATA_FLAG = 2로 논리 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tmcm_repair_ude//

CREATE PROCEDURE sp_imes_tmcm_repair_ude(
    IN p_plt_code VARCHAR(10),
    IN p_mcr_id VARCHAR(30),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TMCM_REPAIR SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND MCR_ID = p_mcr_id;
END//

DELIMITER ;
