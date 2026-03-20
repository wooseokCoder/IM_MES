-- ============================================================
-- TSTD_WORKGROUP / TSTD_WORKGROUP_MC / TSTD_WORKGROUP_EMP CRUD 프로시저
-- 생성일: 2026-02-10
-- 대상 테이블: TSTD_WORKGROUP, TSTD_WORKGROUP_MC, TSTD_WORKGROUP_EMP
-- 원본: ProActive TSTD_WORKGROUP.cs, TSTD_WORKGROUP_MC.cs, TSTD_WORKGROUP_EMP.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_workgroup[_mc|_emp]_[액션]
-- ============================================================
-- 의존성: TSYS_SERIAL 테이블 (GROUP_NO 채번용)
--         sql/imes/common/sp_imes_utility_serial_procedures.sql 먼저 실행 필요
-- ============================================================

DELIMITER //

-- ============================================================
-- TSTD_WORKGROUP (마스터) - 4개
-- ============================================================

-- sp_imes_tstd_workgroup_ser: 단건 조회 (PLT_CODE + GROUP_NO)
-- 원본: TSTD_WORKGROUP.TSTD_WORKGROUP_SER()
-- 용도: 존재 여부 확인, 상세 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_ser//

CREATE PROCEDURE sp_imes_tstd_workgroup_ser(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        GROUP_NO AS groupNo,
        GROUP_NAME AS groupName,
        EMP_COUNT AS empCount,
        MC_COUNT AS mcCount,
        SCOMMENT AS scomment,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DATA_FLAG AS dataFlag
    FROM TSTD_WORKGROUP
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no;
END//

-- sp_imes_tstd_workgroup_ins: 등록
-- 원본: TSTD_WORKGROUP.TSTD_WORKGROUP_INS()
-- 참고: GROUP_NO는 Service에서 UtilityService.getSerialNo로 생성하여 전달
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_ins//

CREATE PROCEDURE sp_imes_tstd_workgroup_ins(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_group_name VARCHAR(200),
    IN p_emp_count INT,
    IN p_mc_count INT,
    IN p_scomment VARCHAR(500),
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_WORKGROUP (
        PLT_CODE, GROUP_NO, GROUP_NAME,
        EMP_COUNT, MC_COUNT, SCOMMENT,
        REG_EMP, REG_DATE, DATA_FLAG
    ) VALUES (
        p_plt_code, p_group_no, p_group_name,
        p_emp_count, p_mc_count, p_scomment,
        p_user_id, NOW(), 0
    );
END//

-- sp_imes_tstd_workgroup_upd: 수정
-- 원본: TSTD_WORKGROUP.TSTD_WORKGROUP_UPD()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_upd//

CREATE PROCEDURE sp_imes_tstd_workgroup_upd(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_group_name VARCHAR(200),
    IN p_emp_count INT,
    IN p_mc_count INT,
    IN p_scomment VARCHAR(500),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP SET
        GROUP_NAME = p_group_name,
        EMP_COUNT = p_emp_count,
        MC_COUNT = p_mc_count,
        SCOMMENT = p_scomment,
        MDFY_EMP = p_user_id,
        MDFY_DATE = NOW(),
        DATA_FLAG = 0
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no;
END//

-- sp_imes_tstd_workgroup_ude: 논리삭제
-- 원본: TSTD_WORKGROUP.TSTD_WORKGROUP_UDE()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_ude//

CREATE PROCEDURE sp_imes_tstd_workgroup_ude(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no;
END//

-- ============================================================
-- TSTD_WORKGROUP_MC (자식: 작업장 매핑) - 5개
-- ============================================================

-- sp_imes_tstd_workgroup_mc_ser: 단건 조회 (PLT_CODE + GROUP_NO + MC_CODE)
-- 원본: TSTD_WORKGROUP_MC.TSTD_WORKGROUP_MC_SER()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_mc_ser//

CREATE PROCEDURE sp_imes_tstd_workgroup_mc_ser(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_mc_code VARCHAR(30)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        GROUP_NO AS groupNo,
        MC_CODE AS mcCode,
        MC_SEQ AS mcSeq,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DATA_FLAG AS dataFlag
    FROM TSTD_WORKGROUP_MC
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND MC_CODE = p_mc_code;
END//

-- sp_imes_tstd_workgroup_mc_ins: 등록
-- 원본: TSTD_WORKGROUP_MC.TSTD_WORKGROUP_MC_INS()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_mc_ins//

CREATE PROCEDURE sp_imes_tstd_workgroup_mc_ins(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_mc_code VARCHAR(30),
    IN p_mc_seq INT,
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_WORKGROUP_MC (
        PLT_CODE, GROUP_NO, MC_CODE, MC_SEQ,
        REG_EMP, REG_DATE, DATA_FLAG
    ) VALUES (
        p_plt_code, p_group_no, p_mc_code, p_mc_seq,
        p_user_id, NOW(), 0
    );
END//

-- sp_imes_tstd_workgroup_mc_upd: 수정 (DATA_FLAG=0 복원 포함)
-- 원본: TSTD_WORKGROUP_MC.TSTD_WORKGROUP_MC_UPD()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_mc_upd//

CREATE PROCEDURE sp_imes_tstd_workgroup_mc_upd(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_mc_code VARCHAR(30),
    IN p_mc_seq INT,
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP_MC SET
        MC_SEQ = p_mc_seq,
        MDFY_EMP = p_user_id,
        MDFY_DATE = NOW(),
        DATA_FLAG = 0
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND MC_CODE = p_mc_code;
END//

-- sp_imes_tstd_workgroup_mc_ude: 개별 논리삭제
-- 원본: TSTD_WORKGROUP_MC.TSTD_WORKGROUP_MC_UDE()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_mc_ude//

CREATE PROCEDURE sp_imes_tstd_workgroup_mc_ude(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_mc_code VARCHAR(30),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP_MC SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND MC_CODE = p_mc_code;
END//

-- sp_imes_tstd_workgroup_mc_ude2: 그룹 전체 논리삭제
-- 용도: 그룹 삭제 시 소속 작업장 전체 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_mc_ude2//

CREATE PROCEDURE sp_imes_tstd_workgroup_mc_ude2(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP_MC SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND DATA_FLAG = 0;
END//

-- ============================================================
-- TSTD_WORKGROUP_EMP (자식: 작업자 매핑) - 5개
-- ============================================================

-- sp_imes_tstd_workgroup_emp_ser: 단건 조회 (PLT_CODE + GROUP_NO + EMP_CODE)
-- 원본: TSTD_WORKGROUP_EMP.TSTD_WORKGROUP_EMP_SER()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_emp_ser//

CREATE PROCEDURE sp_imes_tstd_workgroup_emp_ser(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_emp_code VARCHAR(30)
)
BEGIN
    SELECT
        PLT_CODE AS pltCode,
        GROUP_NO AS groupNo,
        EMP_CODE AS empCode,
        EMP_SEQ AS empSeq,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP AS regEmp,
        DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        MDFY_EMP AS mdfyEmp,
        DATE_FORMAT(DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        DEL_EMP AS delEmp,
        DATA_FLAG AS dataFlag
    FROM TSTD_WORKGROUP_EMP
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND EMP_CODE = p_emp_code;
END//

-- sp_imes_tstd_workgroup_emp_ins: 등록
-- 원본: TSTD_WORKGROUP_EMP.TSTD_WORKGROUP_EMP_INS()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_emp_ins//

CREATE PROCEDURE sp_imes_tstd_workgroup_emp_ins(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_emp_code VARCHAR(30),
    IN p_emp_seq INT,
    IN p_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_WORKGROUP_EMP (
        PLT_CODE, GROUP_NO, EMP_CODE, EMP_SEQ,
        REG_EMP, REG_DATE, DATA_FLAG
    ) VALUES (
        p_plt_code, p_group_no, p_emp_code, p_emp_seq,
        p_user_id, NOW(), 0
    );
END//

-- sp_imes_tstd_workgroup_emp_upd: 수정 (DATA_FLAG=0 복원 포함)
-- 원본: TSTD_WORKGROUP_EMP.TSTD_WORKGROUP_EMP_UPD()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_emp_upd//

CREATE PROCEDURE sp_imes_tstd_workgroup_emp_upd(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_emp_code VARCHAR(30),
    IN p_emp_seq INT,
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP_EMP SET
        EMP_SEQ = p_emp_seq,
        MDFY_EMP = p_user_id,
        MDFY_DATE = NOW(),
        DATA_FLAG = 0
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND EMP_CODE = p_emp_code;
END//

-- sp_imes_tstd_workgroup_emp_ude: 개별 논리삭제
-- 원본: TSTD_WORKGROUP_EMP.TSTD_WORKGROUP_EMP_UDE()
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_emp_ude//

CREATE PROCEDURE sp_imes_tstd_workgroup_emp_ude(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_emp_code VARCHAR(30),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP_EMP SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND EMP_CODE = p_emp_code;
END//

-- sp_imes_tstd_workgroup_emp_ude2: 그룹 전체 논리삭제
-- 용도: 그룹 삭제 시 소속 작업자 전체 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_workgroup_emp_ude2//

CREATE PROCEDURE sp_imes_tstd_workgroup_emp_ude2(
    IN p_plt_code VARCHAR(10),
    IN p_group_no VARCHAR(30),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSTD_WORKGROUP_EMP SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND GROUP_NO = p_group_no
      AND DATA_FLAG = 0;
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
