-- ============================================================
-- TSTD_IDLECODE CRUD 프로시저
-- 생성일: 2026-02-05
-- 대상 테이블: TSTD_IDLECODE, TSTD_ORG, TSYS_SERIAL
-- 원본: ProActive TSTD_IDLECODE.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_idlecode_[액션]
-- ============================================================
-- 의존성: TSYS_SERIAL 테이블 (SCODE 채번용)
--         sql/imes/common/sp_imes_utility_serial_procedures.sql 먼저 실행 필요
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_idlecode_ser: 단건 조회 (SCODE로)
-- 원본: TSTD_IDLECODE.TSTD_IDLECODE_SER()
-- 용도: 존재 여부 확인, 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_ser//

CREATE PROCEDURE sp_imes_tstd_idlecode_ser(
    IN p_plt_code VARCHAR(10),
    IN p_scode VARCHAR(20)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        SCODE AS scode,
        PLANTS AS plants,
        IDLE_CODE AS idleCode,
        SAP_CODE AS sapCode,
        IDLE_NAME AS idleName,
        MG_TYPE1 AS mgType1,
        MG_TYPE2 AS mgType2,
        MG_ORG AS mgOrg,
        IDLE_SEQ AS idleSeq,
        ALARM_TYPE AS alarmType,
        SCOMMENT AS scomment,
        USE_FLAG AS useFlag,
        IS_NG AS isNg,
        IS_SAP AS isSap,
        IS_RPT AS isRpt,
        IS_MCT_SCOMMENT AS isMctScomment,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DATA_FLAG AS dataFlag
    FROM TSTD_IDLECODE
    WHERE PLT_CODE = p_plt_code
      AND SCODE = p_scode;
END//

-- ============================================================
-- sp_imes_tstd_idlecode_ser2: 사용중인 목록 조회
-- 원본: TSTD_IDLECODE.TSTD_IDLECODE_SER2()
-- 용도: 콤보박스용 (DATA_FLAG=0, USE_FLAG='1')
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_ser2//

CREATE PROCEDURE sp_imes_tstd_idlecode_ser2(
    IN p_plt_code VARCHAR(10),
    IN p_plants VARCHAR(10)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        PLANTS AS plants,
        SCODE AS scode,
        IDLE_CODE AS idleCode,
        SAP_CODE AS sapCode,
        IDLE_NAME AS idleName,
        MG_TYPE1 AS mgType1,
        MG_TYPE2 AS mgType2,
        MG_ORG AS mgOrg,
        IDLE_SEQ AS idleSeq,
        SCOMMENT AS scomment,
        USE_FLAG AS useFlag,
        IS_NG AS isNg,
        IS_MCT_SCOMMENT AS isMctScomment,
        ALARM_TYPE AS alarmType
    FROM TSTD_IDLECODE
    WHERE PLT_CODE = p_plt_code
      AND PLANTS = p_plants
      AND DATA_FLAG = 0
      AND USE_FLAG = '1'
    ORDER BY IDLE_SEQ;
END//

-- ============================================================
-- sp_imes_tstd_idlecode_ser3: 단건 조회 (IDLE_CODE로)
-- 원본: TSTD_IDLECODE.TSTD_IDLECODE_SER3()
-- 용도: MES코드로 존재 여부 확인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_ser3//

CREATE PROCEDURE sp_imes_tstd_idlecode_ser3(
    IN p_plt_code VARCHAR(10),
    IN p_idle_code VARCHAR(20)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        SCODE AS scode,
        IDLE_CODE AS idleCode,
        SAP_CODE AS sapCode,
        IDLE_NAME AS idleName,
        MG_TYPE1 AS mgType1,
        MG_TYPE2 AS mgType2,
        MG_ORG AS mgOrg,
        IDLE_SEQ AS idleSeq,
        ALARM_TYPE AS alarmType,
        SCOMMENT AS scomment,
        USE_FLAG AS useFlag,
        DATA_FLAG AS dataFlag
    FROM TSTD_IDLECODE
    WHERE PLT_CODE = p_plt_code
      AND IDLE_CODE = p_idle_code;
END//

-- ============================================================
-- sp_imes_tstd_idlecode_get_scode: SCODE 자동 생성
-- 원본: UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "S", bizExecute)
-- 반환 형식: S260205-0001 (sr_code + YYMMDD + - + 4자리순번)
-- 용도: INSERT 전 SCODE 채번
-- 의존성: sp_imes_utility_get_serialno (공통 시리얼 채번)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_get_scode//

CREATE PROCEDURE sp_imes_tstd_idlecode_get_scode(
    IN p_plt_code VARCHAR(10)
)
BEGIN
    DECLARE v_sr_key VARCHAR(20);
    DECLARE v_sr_no INT DEFAULT 0;
    DECLARE v_exists INT DEFAULT 0;
    DECLARE v_result VARCHAR(50);

    -- AS-IS 로직: UTIL.UTILITY_GET_SERIALNO(plt_code, "S", bizExecute)
    -- - sr_code = "S"
    -- - sr_key = YYMMDD (현재 날짜)
    -- - sep = 4 (순번 자릿수)
    -- 결과: S260205-0001

    -- 현재 날짜 YYMMDD
    SET v_sr_key = DATE_FORMAT(NOW(), '%y%m%d');

    -- TSYS_SERIAL에서 조회
    SELECT COUNT(*), IFNULL(MAX(SR_NO), 0)
    INTO v_exists, v_sr_no
    FROM TSYS_SERIAL
    WHERE PLT_CODE = p_plt_code
      AND SR_CODE = 'S'
      AND SR_KEY = v_sr_key;

    -- 순번 증가
    SET v_sr_no = v_sr_no + 1;

    IF v_exists > 0 THEN
        UPDATE TSYS_SERIAL
        SET SR_NO = v_sr_no
        WHERE PLT_CODE = p_plt_code
          AND SR_CODE = 'S'
          AND SR_KEY = v_sr_key;
    ELSE
        INSERT INTO TSYS_SERIAL (PLT_CODE, SR_CODE, SR_KEY, SR_NO)
        VALUES (p_plt_code, 'S', v_sr_key, v_sr_no);
    END IF;

    -- 결과: S + YYMMDD + - + 4자리 순번
    SET v_result = CONCAT('S', v_sr_key, '-', LPAD(v_sr_no, 4, '0'));

    -- 기존 서비스 호환을 위해 컬럼명 scode로 반환
    SELECT v_result AS scode;
END//

-- ============================================================
-- sp_imes_tstd_idlecode_ins: 등록
-- 원본: TSTD_IDLECODE.TSTD_IDLECODE_INS()
-- 용도: 신규 비가동코드 등록
-- 참고: SCODE는 Service에서 생성하여 전달 (AS-IS: UTIL.UTILITY_GET_SERIALNO)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_ins//

CREATE PROCEDURE sp_imes_tstd_idlecode_ins(
    IN p_plt_code VARCHAR(10),
    IN p_scode VARCHAR(20),
    IN p_plants VARCHAR(10),
    IN p_idle_code VARCHAR(20),
    IN p_sap_code VARCHAR(20),
    IN p_idle_name VARCHAR(100),
    IN p_mg_type1 VARCHAR(20),
    IN p_mg_type2 VARCHAR(20),
    IN p_mg_org VARCHAR(20),
    IN p_idle_seq INT,
    IN p_scomment VARCHAR(500),
    IN p_use_flag VARCHAR(10),
    IN p_is_ng VARCHAR(1),
    IN p_alarm_type VARCHAR(10),
    IN p_is_sap VARCHAR(1),
    IN p_is_rpt VARCHAR(1),
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_IDLECODE (
        PLT_CODE, SCODE, PLANTS, IDLE_CODE, SAP_CODE, IDLE_NAME,
        MG_TYPE1, MG_TYPE2, MG_ORG, IDLE_SEQ, SCOMMENT,
        USE_FLAG, IS_NG, ALARM_TYPE, IS_SAP, IS_RPT,
        REG_EMP, REG_DATE, DATA_FLAG
    ) VALUES (
        p_plt_code, p_scode, p_plants, p_idle_code, p_sap_code, p_idle_name,
        p_mg_type1, p_mg_type2, p_mg_org, p_idle_seq, p_scomment,
        p_use_flag, p_is_ng, p_alarm_type, p_is_sap, p_is_rpt,
        p_user_id, NOW(), 0
    );
END//

-- ============================================================
-- sp_imes_tstd_idlecode_upd: 수정 (전체 필드)
-- 원본: TSTD_IDLECODE.TSTD_IDLECODE_UPD()
-- 용도: 상세 팝업에서 전체 필드 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_upd//

CREATE PROCEDURE sp_imes_tstd_idlecode_upd(
    IN p_plt_code VARCHAR(10),
    IN p_scode VARCHAR(20),
    IN p_sap_code VARCHAR(20),
    IN p_idle_name VARCHAR(100),
    IN p_mg_type1 VARCHAR(20),
    IN p_mg_type2 VARCHAR(20),
    IN p_mg_org VARCHAR(20),
    IN p_idle_seq INT,
    IN p_scomment VARCHAR(500),
    IN p_use_flag VARCHAR(10),
    IN p_is_ng VARCHAR(1),
    IN p_alarm_type VARCHAR(10),
    IN p_is_sap VARCHAR(1),
    IN p_is_rpt VARCHAR(1),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_IDLECODE SET
        SAP_CODE = p_sap_code,
        IDLE_NAME = p_idle_name,
        MG_TYPE1 = p_mg_type1,
        MG_TYPE2 = p_mg_type2,
        MG_ORG = p_mg_org,
        IDLE_SEQ = p_idle_seq,
        SCOMMENT = p_scomment,
        USE_FLAG = p_use_flag,
        IS_NG = p_is_ng,
        ALARM_TYPE = p_alarm_type,
        IS_SAP = p_is_sap,
        IS_RPT = p_is_rpt,
        MDFY_DATE = NOW(),
        MDFY_EMP = p_user_id,
        DATA_FLAG = 0
    WHERE PLT_CODE = p_plt_code
      AND SCODE = p_scode;
END//

-- ============================================================
-- sp_imes_tstd_idlecode_upd2: 일괄 수정 (일부 필드)
-- 원본: TSTD_IDLECODE.TSTD_IDLECODE_UPD2()
-- 용도: 그리드에서 일부 필드만 일괄 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_upd2//

CREATE PROCEDURE sp_imes_tstd_idlecode_upd2(
    IN p_plt_code VARCHAR(10),
    IN p_scode VARCHAR(20),
    IN p_use_flag VARCHAR(10),
    IN p_idle_seq INT,
    IN p_is_ng VARCHAR(1),
    IN p_is_sap VARCHAR(1),
    IN p_is_rpt VARCHAR(1),
    IN p_is_mct_scomment VARCHAR(1),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_IDLECODE SET
        USE_FLAG = p_use_flag,
        IDLE_SEQ = p_idle_seq,
        IS_NG = p_is_ng,
        IS_SAP = p_is_sap,
        IS_RPT = p_is_rpt,
        IS_MCT_SCOMMENT = p_is_mct_scomment,
        DATA_FLAG = 0,
        MDFY_EMP = p_user_id,
        MDFY_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND SCODE = p_scode;
END//

-- ============================================================
-- sp_imes_tstd_idlecode_ude: 삭제 (논리삭제)
-- 원본: TSTD_IDLECODE.TSTD_IDLECODE_UDE()
-- 용도: DATA_FLAG = 2로 논리 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_ude//

CREATE PROCEDURE sp_imes_tstd_idlecode_ude(
    IN p_plt_code VARCHAR(10),
    IN p_scode VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_IDLECODE SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND SCODE = p_scode;
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
