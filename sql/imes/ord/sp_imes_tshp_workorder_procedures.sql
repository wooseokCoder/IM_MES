-- ============================================================
-- TSHP_WORKORDER CRUD 프로시저
-- 생성일: 2026-02-23
-- 수정일: 2026-02-24 (ORD06A용 SER, SER4, UPD4, UPD4_1, UPD28_1, UPD28_2 추가)
-- 대상 테이블: TSHP_WORKORDER
-- 원본: ProActive TSHP_WORKORDER.cs
-- ============================================================
-- 명명 규칙: sp_imes_tshp_workorder_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_workorder_upd32: 비고(SCOMMENT) 저장
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD32()
-- 용도: SAP_WO_NO 단위 비고 일괄 수정
-- 사용화면: ORD13A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd32//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd32(
    IN p_plt_code    VARCHAR(3),
    IN p_sap_wo_no   VARCHAR(50),
    IN p_scomment    VARCHAR(500),
    IN p_mdfy_emp    VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET SCOMMENT  = p_scomment,
           MDFY_DATE = NOW(),
           MDFY_EMP  = p_mdfy_emp,
           DATA_FLAG = 0
     WHERE PLT_CODE  = p_plt_code
       AND SAP_WO_NO = p_sap_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd35: 공정명(PROC_CODE) 저장
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD35()
-- 용도: SAP_WO_NO + WO_SEQ 단위 공정명 수정
-- 사용화면: ORD13A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd35//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd35(
    IN p_plt_code    VARCHAR(3),
    IN p_sap_wo_no   VARCHAR(50),
    IN p_wo_seq      VARCHAR(10),
    IN p_proc_code   VARCHAR(50),
    IN p_mdfy_emp    VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET PROC_CODE = p_proc_code,
           MDFY_DATE = NOW(),
           MDFY_EMP  = p_mdfy_emp,
           DATA_FLAG = 0
     WHERE PLT_CODE  = p_plt_code
       AND SAP_WO_NO = p_sap_wo_no
       AND WO_SEQ    = p_wo_seq;
END//

-- ============================================================
-- sp_imes_tshp_workorder_ser: 작업지시 단건 조회
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_SER()
-- 용도: WO_NO 기준 단건 조회 (확정/계획저장 전 상태 검증용)
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_ser//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_ser(
    IN p_plt_code  VARCHAR(3),
    IN p_wo_no     VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE          AS pltCode,
        WO_NO             AS woNo,
        SAP_WO_NO         AS sapWoNo,
        PROD_CODE         AS prodCode,
        PART_CODE         AS partCode,
        PROC_CODE         AS procCode,
        MC_CODE           AS mcCode,
        PLN_START_TIME    AS plnStartTime,
        PLN_END_TIME      AS plnEndTime,
        BF_PLN_START_TIME AS bfPlnStartTime,
        BF_PLN_END_TIME   AS bfPlnEndTime,
        PLN_PROC_TIME     AS plnProcTime,
        WO_FLAG           AS woFlag,
        CONFIRM_DATE      AS confirmDate
    FROM TSHP_WORKORDER
    WHERE PLT_CODE = p_plt_code
      AND WO_NO = p_wo_no
      AND DATA_FLAG = 0;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd4: WO_FLAG + CONFIRM_DATE 업데이트
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD4()
-- 용도: 확정(WO_FLAG=1) 또는 확정취소(WO_FLAG=0) 처리
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd4//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd4(
    IN p_plt_code      VARCHAR(3),
    IN p_wo_no         VARCHAR(50),
    IN p_wo_flag       VARCHAR(1),
    IN p_confirm_date  VARCHAR(14),
    IN p_mdfy_emp      VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET WO_FLAG      = p_wo_flag,
           CONFIRM_DATE = p_confirm_date,
           MDFY_DATE    = NOW(),
           MDFY_EMP     = p_mdfy_emp
     WHERE PLT_CODE = p_plt_code
       AND WO_NO    = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd4_1: BF_PLN 시간 업데이트
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD4_1()
-- 용도: 확정취소 시 BF_PLN 시간 초기화
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd4_1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd4_1(
    IN p_plt_code          VARCHAR(3),
    IN p_wo_no             VARCHAR(50),
    IN p_bf_pln_start_time VARCHAR(12),
    IN p_bf_pln_end_time   VARCHAR(12)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET BF_PLN_START_TIME = p_bf_pln_start_time,
           BF_PLN_END_TIME   = p_bf_pln_end_time
     WHERE PLT_CODE = p_plt_code
       AND WO_NO    = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd28_1: 계획시간 + 설비 업데이트
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD28_1()
-- 용도: PLN_START_TIME, PLN_END_TIME, BF_PLN, MC_CODE 수정
-- 사용화면: ORD06A (계획 저장, 확정)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd28_1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd28_1(
    IN p_plt_code          VARCHAR(3),
    IN p_wo_no             VARCHAR(50),
    IN p_pln_start_time    VARCHAR(12),
    IN p_pln_end_time      VARCHAR(12),
    IN p_bf_pln_start_time VARCHAR(12),
    IN p_bf_pln_end_time   VARCHAR(12),
    IN p_mc_code           VARCHAR(20),
    IN p_mdfy_emp          VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET PLN_START_TIME    = p_pln_start_time,
           PLN_END_TIME      = p_pln_end_time,
           BF_PLN_START_TIME = p_bf_pln_start_time,
           BF_PLN_END_TIME   = p_bf_pln_end_time,
           MC_CODE           = p_mc_code,
           MDFY_DATE         = NOW(),
           MDFY_EMP          = p_mdfy_emp
     WHERE PLT_CODE = p_plt_code
       AND WO_NO    = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd28_2: 고객명(MCT_VEN_NAME) 업데이트
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD28_2()
-- 용도: SAP_WO_NO 단위 고객명 일괄 수정
-- 사용화면: ORD06A (계획 저장)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd28_2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd28_2(
    IN p_plt_code      VARCHAR(3),
    IN p_sap_wo_no     VARCHAR(50),
    IN p_mct_ven_name  VARCHAR(200),
    IN p_mdfy_emp      VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET MCT_VEN_NAME = p_mct_ven_name,
           MDFY_DATE    = NOW(),
           MDFY_EMP     = p_mdfy_emp
     WHERE PLT_CODE  = p_plt_code
       AND SAP_WO_NO = p_sap_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_ser4: 동일 제품의 확정 WO 존재 여부 확인
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_SER4()
-- 용도: 확정취소 시 다른 확정 WO가 남아있는지 확인
--       → 없으면 TORD_PRODUCT.PROD_STATE='WK'로 변경
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_ser4//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_ser4(
    IN p_plt_code   VARCHAR(3),
    IN p_prod_code  VARCHAR(50),
    IN p_wo_no      VARCHAR(50)
)
BEGIN
    SELECT COUNT(*) AS cnt
    FROM TSHP_WORKORDER
    WHERE PLT_CODE = p_plt_code
      AND PROD_CODE = p_prod_code
      AND WO_NO != p_wo_no
      AND WO_FLAG IN ('1','2','3','4')
      AND DATA_FLAG = 0;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd17: 불출율 업데이트
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD17()
-- 용도: MAT05A_INS/DEL - 현장불출/불출취소 후 불출율 갱신
-- 사용화면: MAT05A
-- 추가일: 2026-03-04
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd17//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd17(
    IN p_plt_code          VARCHAR(3),
    IN p_wo_no             VARCHAR(50),
    IN p_mat_out_rate_mes  DECIMAL(10,2),
    IN p_is_out_mes        VARCHAR(1),
    IN p_mat_out_stk_rate  DECIMAL(10,2),
    IN p_mdfy_emp          VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET MAT_OUT_RATE_MES  = p_mat_out_rate_mes,
           IS_OUT_MES        = p_is_out_mes,
           MAT_OUT_STK_RATE  = p_mat_out_stk_rate,
           MDFY_DATE         = NOW(),
           MDFY_EMP          = p_mdfy_emp
     WHERE PLT_CODE = p_plt_code
       AND WO_NO = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd31: 작업지시 완료 처리
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD31()
-- 용도: ORD16A 완료처리의 최종 단계 - 작업지시 상태 변경
-- 로직:
--   - WO_FLAG 변경 ('1'→'4': 진행→완료, 또는 다른 상태)
--   - ACT_START_TIME: 빈 값이 아닌 경우에만 설정 (CASE WHEN)
--     → 최초 완료처리 시에만 시작시간 기록
--   - ACT_END_TIME: 완료시간 설정
--   - PRE_WORK: AS-IS에서 전달하지 않음 → SET 제거
--   - DATA_FLAG = 0: 활성 상태 유지
--   - 수정일시/수정자 갱신
-- 변환:
--   CONVERT(DATETIME, @ACT_START_TIME) → STR_TO_DATE(...)
--   GETDATE() → NOW()
-- 파라미터:
--   p_plt_code       - 공장코드
--   p_wo_no          - 작업지시번호
--   p_wo_flag        - 변경할 작업지시상태 ('4'=완료)
--   p_act_start_time - 실적시작시간 (yyyyMMddHHmmss, 빈값 허용)
--   p_act_end_time   - 실적종료시간 (yyyyMMddHHmmss)
--   p_user_id        - 수정자ID
-- 참고: AS-IS PRE_WORK는 UPD31 호출 시 DataTable에 미포함 → 파라미터/SET 제거
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd31//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd31(
    IN p_plt_code       VARCHAR(20),   /* 공장코드 */
    IN p_wo_no          VARCHAR(20),   /* 작업지시번호 */
    IN p_wo_flag        VARCHAR(5),    /* 변경할 작업지시상태 ('2'=진행,'3'=중단,'4'=완료) */
    IN p_act_start_time VARCHAR(20),   /* 실적시작시간 (yyyyMMddHHmmss, 빈값 허용) */
    IN p_act_end_time   VARCHAR(20),   /* 실적종료시간 (yyyyMMddHHmmss) */
    IN p_user_id        VARCHAR(20)    /* 수정자ID */
)
BEGIN
    /* AS-IS: PRE_WORK는 UPD31 호출 시 전달하지 않음 (DataTable에 미포함)
       → PRE_WORK SET 제거, 파라미터에서도 제거 */
    UPDATE TSHP_WORKORDER
    SET WO_FLAG        = p_wo_flag,                                        /* 작업지시상태 변경 */
        /* ACT_START_TIME: 파라미터가 비어있지 않을 때만 설정 (CASE WHEN)
           → 이미 시작시간이 있는 경우 기존 값 유지 */
        ACT_START_TIME = CASE
                            WHEN p_act_start_time IS NOT NULL AND p_act_start_time <> ''
                            THEN STR_TO_DATE(p_act_start_time, '%Y%m%d%H%i%s')
                            ELSE ACT_START_TIME  /* 기존 값 유지 */
                         END,
        ACT_END_TIME   = STR_TO_DATE(p_act_end_time, '%Y%m%d%H%i%s'),     /* 완료시간 설정 */
        MDFY_DATE      = NOW(),                                            /* 수정일시 */
        MDFY_EMP       = p_user_id,                                        /* 수정자 */
        DATA_FLAG      = 0                                                 /* 활성 상태 유지 */
    WHERE PLT_CODE = p_plt_code
      AND WO_NO = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd36: 오더완료일 수정 (ORD18A D0A 팝업)
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD36
-- ACT_START_TIME, ACT_END_TIME 업데이트
-- 사용화면: ORD18A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd36//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd36(
    IN p_plt_code       VARCHAR(10),
    IN p_wo_no          VARCHAR(30),
    IN p_act_start_time VARCHAR(20),
    IN p_act_end_time   VARCHAR(20),
    IN p_user_id        VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER SET
        ACT_START_TIME = p_act_start_time
        ,ACT_END_TIME = p_act_end_time
        ,MDFY_DATE = NOW()
        ,MDFY_EMP = p_user_id
    WHERE PLT_CODE = p_plt_code
        AND WO_NO = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd5_5: WO_FLAG 업데이트 (비가동 시)
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD5_5()
-- 용도: 비가동 발생 시 WO_FLAG 상태 변경
-- 사용화면: POP30B
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd5_5//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd5_5(
    IN p_plt_code    VARCHAR(3),
    IN p_wo_no       VARCHAR(50),
    IN p_wo_flag     VARCHAR(1),
    IN p_user_id     VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET WO_FLAG   = p_wo_flag,
           MDFY_DATE = NOW(),
           MDFY_EMP  = p_user_id
     WHERE PLT_CODE = p_plt_code
       AND WO_NO    = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd15: WO_FLAG 단순 업데이트
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD15()
-- 용도: WO_FLAG만 변경 (수정일시/수정자 없이)
-- 사용화면: POP30B
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd15//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd15(
    IN p_plt_code    VARCHAR(3),
    IN p_wo_no       VARCHAR(50),
    IN p_wo_flag     VARCHAR(1)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET WO_FLAG = p_wo_flag
     WHERE PLT_CODE = p_plt_code
       AND WO_NO    = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd30: IS_INS_CHK 업데이트 (by WO_NO)
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD30()
-- 용도: WO_NO 기준 검사체크(IS_INS_CHK) 업데이트
-- 사용화면: POP30B
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd30//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd30(
    IN p_plt_code    VARCHAR(3),
    IN p_wo_no       VARCHAR(50),
    IN p_is_ins_chk  VARCHAR(1),
    IN p_user_id     VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET IS_INS_CHK = p_is_ins_chk,
           MDFY_DATE  = NOW(),
           MDFY_EMP   = p_user_id,
           DATA_FLAG  = 0
     WHERE PLT_CODE = p_plt_code
       AND WO_NO    = p_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd30_1: IS_INS_CHK 업데이트 (by SAP_WO_NO)
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD30_1()
-- 용도: SAP_WO_NO 기준 검사체크(IS_INS_CHK) 업데이트
-- 사용화면: POP30B
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd30_1//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd30_1(
    IN p_plt_code    VARCHAR(3),
    IN p_sap_wo_no   VARCHAR(50),
    IN p_is_ins_chk  VARCHAR(1),
    IN p_user_id     VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET IS_INS_CHK = p_is_ins_chk,
           MDFY_DATE  = NOW(),
           MDFY_EMP   = p_user_id,
           DATA_FLAG  = 0
     WHERE PLT_CODE  = p_plt_code
       AND SAP_WO_NO = p_sap_wo_no;
END//

-- ============================================================
-- sp_imes_tshp_workorder_upd34: ACT_EMP_CODE, ACT_MC_CODE, PRE_WORK 업데이트
-- 원본: TSHP_WORKORDER.TSHP_WORKORDER_UPD34()
-- 용도: 작업자, 실적설비, 전작업 정보 업데이트
-- 사용화면: POP30B
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_upd34//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_workorder_upd34(
    IN p_plt_code      VARCHAR(3),
    IN p_wo_no         VARCHAR(50),
    IN p_act_emp_code  VARCHAR(20),
    IN p_act_mc_code   VARCHAR(20),
    IN p_pre_work      VARCHAR(500),
    IN p_user_id       VARCHAR(20)
)
BEGIN
    UPDATE TSHP_WORKORDER
       SET ACT_EMP_CODE = p_act_emp_code,
           ACT_MC_CODE  = p_act_mc_code,
           PRE_WORK     = p_pre_work,
           MDFY_DATE    = NOW(),
           MDFY_EMP     = p_user_id,
           DATA_FLAG    = 0
     WHERE PLT_CODE = p_plt_code
       AND WO_NO    = p_wo_no;
END//

DELIMITER ;
