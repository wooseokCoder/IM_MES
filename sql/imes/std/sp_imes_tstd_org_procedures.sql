-- ============================================================
-- TSTD_ORG CRUD 프로시저
-- 생성일: 2026-02-11
-- 대상 테이블: TSTD_ORG
-- 원본: ProActive TSTD_ORG.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_org_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_org_ser: 단건 조회 (PK: PLT_CODE + ORG_CODE)
-- 원본: TSTD_ORG.TSTD_ORG_SER()
-- 용도: 존재 여부 확인, 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_org_ser//

CREATE PROCEDURE sp_imes_tstd_org_ser(
    IN p_plt_code VARCHAR(20),
    IN p_org_code VARCHAR(20)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        ORG_CODE AS orgCode,
        ORG_NAME AS orgName,
        ORG_PARENT AS orgParent,
        ORG_LEADER AS orgLeader,
        ORG_SEQ AS orgSeq,
        COST_CENTER AS costCenter,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DEL_REASON AS delReason,
        DATA_FLAG AS dataFlag
    FROM TSTD_ORG
    WHERE PLT_CODE = p_plt_code
      AND ORG_CODE = p_org_code;
END//

-- ============================================================
-- sp_imes_tstd_org_ins: 등록
-- 원본: TSTD_ORG.TSTD_ORG_INS()
-- 용도: 신규 부서 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_org_ins//

CREATE PROCEDURE sp_imes_tstd_org_ins(
    IN p_plt_code VARCHAR(20),
    IN p_org_code VARCHAR(20),
    IN p_org_name VARCHAR(100),
    IN p_org_parent VARCHAR(20),
    IN p_org_leader VARCHAR(20),
    IN p_org_seq INT,
    IN p_cost_center VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_ORG (
        PLT_CODE, ORG_CODE, ORG_NAME, ORG_PARENT, ORG_LEADER,
        ORG_SEQ, COST_CENTER, REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_org_code, p_org_name, p_org_parent, p_org_leader,
        p_org_seq, p_cost_center, NOW(), p_user_id, 0
    );
END//

-- ============================================================
-- sp_imes_tstd_org_upd: 수정 (+ DATA_FLAG=0 복원)
-- 원본: TSTD_ORG.TSTD_ORG_UPD()
-- 용도: 부서 정보 수정 및 삭제 복원
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_org_upd//

CREATE PROCEDURE sp_imes_tstd_org_upd(
    IN p_plt_code VARCHAR(20),
    IN p_org_code VARCHAR(20),
    IN p_org_name VARCHAR(100),
    IN p_org_parent VARCHAR(20),
    IN p_org_leader VARCHAR(20),
    IN p_org_seq INT,
    IN p_cost_center VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_ORG SET
        ORG_NAME = p_org_name,
        ORG_PARENT = p_org_parent,
        ORG_LEADER = p_org_leader,
        ORG_SEQ = p_org_seq,
        COST_CENTER = p_cost_center,
        MDFY_DATE = NOW(),
        MDFY_EMP = p_user_id,
        DATA_FLAG = 0
    WHERE PLT_CODE = p_plt_code
      AND ORG_CODE = p_org_code;
END//

-- ============================================================
-- sp_imes_tstd_org_ude: 삭제 (논리삭제)
-- 원본: TSTD_ORG.TSTD_ORG_UDE()
-- 용도: DATA_FLAG = 2로 논리 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_org_ude//

CREATE PROCEDURE sp_imes_tstd_org_ude(
    IN p_plt_code VARCHAR(20),
    IN p_org_code VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_ORG SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND ORG_CODE = p_org_code;
END//

DELIMITER ;

-- ============================================================
-- 실행 안내
-- ============================================================
-- 1. MySQL Workbench 또는 CLI에서 이 스크립트 실행
-- 2. 운영 DB에 적용 후 doc/PROCEDURE_SYNC_RULE.md에 기록
-- ============================================================
