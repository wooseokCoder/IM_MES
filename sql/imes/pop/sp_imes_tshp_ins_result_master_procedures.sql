-- ============================================================
-- TSHP_INS_RESULT_MASTER CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-18
-- 대상 테이블: TSHP_INS_RESULT_MASTER
-- 원본: ProActive TSHP_INS_RESULT_MASTER.cs
-- 화면: POP30B (단말기 - 가공)
-- ============================================================
-- 포함 프로시저 (5개):
--   1. sp_imes_tshp_ins_result_master_ins2   - 검사결과 마스터 등록
--   2. sp_imes_tshp_ins_result_master_upd    - 검사결과 마스터 수정
--   3. sp_imes_tshp_ins_result_master_upd2   - QMS 상태 수정
--   4. sp_imes_tshp_ins_result_master_ser3   - WO_NO+INS_GRP_CODE 조회
--   5. sp_imes_tshp_ins_result_master_ser4   - WO_NO 조회
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_ins_result_master_ins2: 검사결과 마스터 등록
-- 원본: TSHP_INS_RESULT_MASTER.TSHP_INS_RESULT_MASTER_INS2()
-- 용도: POP30B 검사결과 마스터 신규 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_ins2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_master_ins2(
    IN p_plt_code      VARCHAR(10),     /* 공장코드 */
    IN p_insm_no       VARCHAR(30),     /* 검사마스터번호 */
    IN p_wo_no         VARCHAR(20),     /* 작업오더번호 */
    IN p_sap_wo_no     VARCHAR(20),     /* SAP 작업오더번호 */
    IN p_ins_grp_code  VARCHAR(20),     /* 검사그룹코드 */
    IN p_emp_code      VARCHAR(20),     /* 작업자코드 */
    IN p_user_id       VARCHAR(50)      /* 등록자 */
)
BEGIN
    INSERT INTO TSHP_INS_RESULT_MASTER (
        PLT_CODE, INSM_NO, WO_NO, SAP_WO_NO, INS_GRP_CODE, EMP_CODE,
        REG_DATE, REG_EMP, DATA_FLAG
    ) VALUES (
        p_plt_code, p_insm_no, p_wo_no, p_sap_wo_no, p_ins_grp_code, p_emp_code,
        NOW(), p_user_id, 0
    );
END//


-- ============================================================
-- 2. sp_imes_tshp_ins_result_master_upd: 검사결과 마스터 수정
-- 원본: TSHP_INS_RESULT_MASTER.TSHP_INS_RESULT_MASTER_UPD()
-- 용도: POP30B 검사결과 마스터 수정 (작업자, DATA_FLAG)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_upd//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_master_upd(
    IN p_plt_code    VARCHAR(10),     /* 공장코드 */
    IN p_insm_no     VARCHAR(30),     /* 검사마스터번호 */
    IN p_emp_code    VARCHAR(20),     /* 작업자코드 */
    IN p_data_flag   INT,             /* 데이터 플래그 */
    IN p_user_id     VARCHAR(50)      /* 수정자 */
)
BEGIN
    UPDATE TSHP_INS_RESULT_MASTER SET
        EMP_CODE   = p_emp_code,
        MDFY_DATE  = NOW(),
        MDFY_EMP   = p_user_id,
        DATA_FLAG  = p_data_flag
    WHERE PLT_CODE = p_plt_code
      AND INSM_NO  = p_insm_no;
END//


-- ============================================================
-- 3. sp_imes_tshp_ins_result_master_upd2: QMS 상태 수정
-- 원본: TSHP_INS_RESULT_MASTER.TSHP_INS_RESULT_MASTER_UPD2()
-- 용도: POP30B QMS 전송 상태 및 전송일시 업데이트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_upd2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_master_upd2(
    IN p_plt_code    VARCHAR(10),     /* 공장코드 */
    IN p_insm_no     VARCHAR(30),     /* 검사마스터번호 */
    IN p_qms_state   VARCHAR(5),      /* QMS 상태 */
    IN p_data_flag   INT,             /* 데이터 플래그 */
    IN p_user_id     VARCHAR(50)      /* 수정자 */
)
BEGIN
    UPDATE TSHP_INS_RESULT_MASTER SET
        QMS_STATE     = p_qms_state,
        QMS_SEND_DATE = NOW(),
        MDFY_DATE     = NOW(),
        MDFY_EMP      = p_user_id,
        DATA_FLAG     = p_data_flag
    WHERE PLT_CODE = p_plt_code
      AND INSM_NO  = p_insm_no;
END//


-- ============================================================
-- 4. sp_imes_tshp_ins_result_master_ser3: WO_NO+INS_GRP_CODE 조회
-- 원본: TSHP_INS_RESULT_MASTER.TSHP_INS_RESULT_MASTER_SER3()
-- 용도: POP30B 작업오더+검사그룹 기준 검사결과 마스터 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_ser3//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_master_ser3(
    IN p_plt_code      VARCHAR(10),     /* 공장코드 */
    IN p_wo_no         VARCHAR(20),     /* 작업오더번호 */
    IN p_ins_grp_code  VARCHAR(20),     /* 검사그룹코드 */
    IN p_data_flag     INT              /* 데이터 플래그 */
)
BEGIN
    SELECT
        PLT_CODE       AS "pltCode"
       ,INSM_NO        AS "insmNo"
       ,WO_NO          AS "woNo"
       ,SAP_WO_NO      AS "sapWoNo"
       ,INS_GRP_CODE   AS "insGrpCode"
       ,EMP_CODE       AS "empCode"
       ,QMS_STATE       AS "qmsState"
       ,DATA_FLAG       AS "dataFlag"
    FROM TSHP_INS_RESULT_MASTER
    WHERE PLT_CODE     = p_plt_code
      AND WO_NO        = p_wo_no
      AND INS_GRP_CODE = p_ins_grp_code
      AND DATA_FLAG    = p_data_flag;
END//


-- ============================================================
-- 5. sp_imes_tshp_ins_result_master_ser4: WO_NO 조회
-- 원본: TSHP_INS_RESULT_MASTER.TSHP_INS_RESULT_MASTER_SER4()
-- 용도: POP30B 작업오더 기준 검사결과 마스터 전체 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_ser4//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ins_result_master_ser4(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_wo_no     VARCHAR(20),     /* 작업오더번호 */
    IN p_data_flag INT              /* 데이터 플래그 */
)
BEGIN
    SELECT
        PLT_CODE       AS "pltCode"
       ,INSM_NO        AS "insmNo"
       ,WO_NO          AS "woNo"
       ,SAP_WO_NO      AS "sapWoNo"
       ,INS_GRP_CODE   AS "insGrpCode"
       ,EMP_CODE       AS "empCode"
       ,QMS_STATE       AS "qmsState"
       ,DATA_FLAG       AS "dataFlag"
    FROM TSHP_INS_RESULT_MASTER
    WHERE PLT_CODE  = p_plt_code
      AND WO_NO     = p_wo_no
      AND DATA_FLAG = p_data_flag;
END//


DELIMITER ;
