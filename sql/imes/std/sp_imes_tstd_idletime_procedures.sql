-- ============================================================
-- TSTD_IDLETIME CRUD 프로시저
-- 생성일: 2026-02-10
-- 대상 테이블: TSTD_IDLETIME
-- 원본: ProActive TSTD_IDLETIME.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_idletime_[액션]
-- ============================================================
-- 의존성: TSYS_SERIAL 테이블 (IDLE_NO 채번용)
--         sql/imes/common/sp_imes_utility_serial_procedures.sql 먼저 실행 필요
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_idletime_ser: 단건 조회 (PLT_CODE + IDLE_NO)
-- 원본: TSTD_IDLETIME.TSTD_IDLETIME_SER()
-- 용도: 존재 여부 확인, 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idletime_ser//

CREATE PROCEDURE sp_imes_tstd_idletime_ser(
    IN p_plt_code VARCHAR(10),
    IN p_idle_no VARCHAR(30)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        IDLE_NO AS idleNo,
        SCODE AS scode,
        IDLE_START_TIME AS idleStartTime,
        IDLE_END_TIME AS idleEndTime,
        SCOMMENT AS scomment,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DATA_FLAG AS dataFlag
    FROM TSTD_IDLETIME
    WHERE PLT_CODE = p_plt_code
      AND IDLE_NO = p_idle_no;
END//

-- ============================================================
-- sp_imes_tstd_idletime_ins: 등록
-- 원본: TSTD_IDLETIME.TSTD_IDLETIME_INS()
-- 용도: 신규 비가동시간 등록
-- 참고: IDLE_NO는 Service에서 생성하여 전달
--       AS-IS: UTIL.UTILITY_GET_SERIALNO(PLT_CODE, "IDT", YYYYMMDD)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idletime_ins//

CREATE PROCEDURE sp_imes_tstd_idletime_ins(
    IN p_plt_code VARCHAR(10),
    IN p_idle_no VARCHAR(30),
    IN p_scode VARCHAR(20),
    IN p_idle_start_time VARCHAR(10),
    IN p_idle_end_time VARCHAR(10),
    IN p_scomment VARCHAR(500),
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_IDLETIME (
        PLT_CODE, IDLE_NO, SCODE,
        IDLE_START_TIME, IDLE_END_TIME, SCOMMENT,
        REG_EMP, REG_DATE, DATA_FLAG
    ) VALUES (
        p_plt_code, p_idle_no, p_scode,
        p_idle_start_time, p_idle_end_time, p_scomment,
        p_user_id, NOW(), 0
    );
END//

-- ============================================================
-- sp_imes_tstd_idletime_upd: 수정
-- 원본: TSTD_IDLETIME.TSTD_IDLETIME_UPD()
-- 용도: 다이얼로그에서 수정 (저장&닫기)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idletime_upd//

CREATE PROCEDURE sp_imes_tstd_idletime_upd(
    IN p_plt_code VARCHAR(10),
    IN p_idle_no VARCHAR(30),
    IN p_scode VARCHAR(20),
    IN p_idle_start_time VARCHAR(10),
    IN p_idle_end_time VARCHAR(10),
    IN p_scomment VARCHAR(500),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_IDLETIME SET
        SCODE = p_scode,
        IDLE_START_TIME = p_idle_start_time,
        IDLE_END_TIME = p_idle_end_time,
        SCOMMENT = p_scomment,
        MDFY_EMP = p_user_id,
        MDFY_DATE = NOW(),
        DATA_FLAG = 0
    WHERE PLT_CODE = p_plt_code
      AND IDLE_NO = p_idle_no;
END//

-- ============================================================
-- sp_imes_tstd_idletime_ude: 삭제 (논리삭제)
-- 용도: DATA_FLAG = 2로 논리 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idletime_ude//

CREATE PROCEDURE sp_imes_tstd_idletime_ude(
    IN p_plt_code VARCHAR(10),
    IN p_idle_no VARCHAR(30),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_IDLETIME SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND IDLE_NO = p_idle_no;
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
