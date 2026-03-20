-- ============================================================
-- TSHP_IDLETIME CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-04
-- 대상 테이블: TSHP_IDLETIME (비가동 실적)
-- 원본: ProActive TSHP_IDLETIME.cs - UDE
-- 화면: POB32A (비가동 현황 - 조립)
-- ============================================================
-- 명명 규칙: sp_imes_tshp_idletime_[액션]
-- ============================================================
-- 포함: UDE(삭제), UPD_ORD16A(ORD16A 비가동종료), UPD9(상세원인),
--       UPD8(IF_SEL_FLAG), UDE_RESTORE(삭제취소),
--       SER2(단건조회), UPD3(D2A수정), INS(D0A등록)
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_idletime_ude: 논리 삭제
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UDE()
-- 용도: POP32A 메인 그리드 삭제 버튼 (POP32A_DEL)
-- 삭제 방식: DATA_FLAG = 2로 논리 삭제 (물리 삭제 아님)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ude//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ude(
    IN p_plt_code VARCHAR(10),
    IN p_idle_id VARCHAR(20),
    IN p_user_id VARCHAR(50)
)
BEGIN
    UPDATE TSHP_IDLETIME SET
        DATA_FLAG = 2,
        DEL_EMP = p_user_id,
        DEL_DATE = NOW()
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//

-- ============================================================
-- sp_imes_tshp_idletime_upd_ord16a: 비가동 종료 처리 (ORD16A 전용)
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UPD() (ORD16A 전용 버전)
-- 용도: ORD16A 완료처리 시 진행중인 비가동을 종료
-- 로직:
--   - IDLE_TIME = TIMESTAMPDIFF(MINUTE, START_TIME, END_TIME)
--     → 비가동 시간(분) 자동 계산 (종료시간 - 시작시간)
--   - IDLE_STATE 변경 ('1'→'2': 진행→종료)
--   - END_TIME 설정
-- 변환: DATEDIFF(MINUTE, ...) → TIMESTAMPDIFF(MINUTE, ...)
-- 참고: POP32A의 sp_imes_tshp_idletime_upd와는 별도 프로시저
--       (ORD16A는 파라미터 구조가 다름)
-- 파라미터:
--   p_plt_code   - 공장코드
--   p_idle_id    - 비가동ID (PK)
--   p_idle_state - 변경할 비가동상태 ('2'=종료)
--   p_end_time   - 종료시간 (yyyyMMddHHmmss 문자열)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_upd_ord16a//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_upd_ord16a(
    IN p_plt_code   VARCHAR(20),   /* 공장코드 */
    IN p_idle_id    VARCHAR(30),   /* 비가동ID */
    IN p_idle_state VARCHAR(5),    /* 변경할 비가동상태 ('2'=종료) */
    IN p_end_time   VARCHAR(20)    /* 종료시간 (yyyyMMddHHmmss) */
)
BEGIN
    UPDATE TSHP_IDLETIME
    SET IDLE_TIME  = TIMESTAMPDIFF(MINUTE,
                        START_TIME,
                        STR_TO_DATE(p_end_time, '%Y%m%d%H%i%s')
                     ),                                                    /* 비가동시간(분) 자동계산 */
        IDLE_STATE = p_idle_state,                                         /* 비가동상태 변경 */
        END_TIME   = STR_TO_DATE(p_end_time, '%Y%m%d%H%i%s')              /* 종료시간 설정 */
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID  = p_idle_id;
END//

-- ============================================================
-- sp_imes_tshp_idletime_upd9: 상세원인 수정
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UPD9()
-- 용도: POP32A_INS3 (상세원인 수정 및 확인)
-- 수정 필드: MCT_SCOMMENT (발생원인), MCT_SCOMMENT_RESULT (처리내용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_upd9//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_upd9(
    IN p_plt_code            VARCHAR(10),
    IN p_idle_id             VARCHAR(20),
    IN p_mct_scomment        TEXT,
    IN p_mct_scomment_result TEXT,
    IN p_user_id             VARCHAR(50)
)
BEGIN
    UPDATE TSHP_IDLETIME SET
        MCT_SCOMMENT = p_mct_scomment,
        MCT_SCOMMENT_RESULT = p_mct_scomment_result,
        MDFY_DATE = NOW(),
        MDFY_EMP = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//

-- ============================================================
-- sp_imes_tshp_idletime_upd8: 비가동 IF_SEL_FLAG 수정
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UPD8()
-- 용도: POP33A Grid2에서 비가동의 SAP 전송 플래그 변경
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_upd8//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_upd8(
    IN p_plt_code    VARCHAR(10),    /* 공장코드 */
    IN p_idle_id     VARCHAR(30),    /* 비가동ID (PK) */
    IN p_if_sel_flag VARCHAR(5),     /* SAP 선택 플래그 */
    IN p_user_id     VARCHAR(50)     /* 수정자 */
)
BEGIN
    UPDATE TSHP_IDLETIME SET
        IF_SEL_FLAG = p_if_sel_flag,
        MDFY_DATE   = NOW(),
        MDFY_EMP    = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//


-- ============================================================
-- sp_imes_tshp_idletime_ude_restore: 비가동 DATA_FLAG 복원 (삭제취소)
-- 용도: POP33A Grid3에서 삭제된 비가동 복원 시 DATA_FLAG='0'으로 변경
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ude_restore//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ude_restore(
    IN p_plt_code VARCHAR(10),
    IN p_idle_id VARCHAR(20),
    IN p_user_id VARCHAR(20)
)
BEGIN
    UPDATE TSHP_IDLETIME
    SET DATA_FLAG = 0,
        DEL_DATE = NOW(),
        DEL_EMP = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//

-- ============================================================
-- sp_imes_tshp_idletime_ser2: 비가동 단건 조회
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_SER2() (lines 74-131)
-- 용도: POP32A_INS2 (D2A 수정) 시 IF_FLAG 확인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ser2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ser2(
    IN p_plt_code VARCHAR(10),
    IN p_idle_id VARCHAR(30)
)
BEGIN
    SELECT PLT_CODE, IDLE_ID, WORK_DATE, MC_CODE, WO_NO,
           EMP_CODE, IDLE_CODE, IDLE_TIME, IDLE_STATE,
           START_TIME, END_TIME, SCOMMENT,
           REG_DATE, REG_EMP, MDFY_DATE, MDFY_EMP,
           DEL_DATE, DEL_EMP, DATA_FLAG, IF_FLAG, NG_ID
    FROM TSHP_IDLETIME
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//

-- ============================================================
-- sp_imes_tshp_idletime_upd3: 비가동시간 수정
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UPD3() (lines 641-682)
-- 용도: POP32A_INS2 (D2A 수정 팝업 저장)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_upd3//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_upd3(
    IN p_plt_code VARCHAR(10),
    IN p_idle_id VARCHAR(30),
    IN p_work_date VARCHAR(8),
    IN p_idle_time INT,
    IN p_start_time VARCHAR(14),
    IN p_end_time VARCHAR(14),
    IN p_idle_state VARCHAR(1),
    IN p_user_id VARCHAR(20)
)
BEGIN
    UPDATE TSHP_IDLETIME
    SET WORK_DATE = p_work_date,
        IDLE_TIME = p_idle_time,
        START_TIME = STR_TO_DATE(p_start_time, '%Y%m%d%H%i%s'),
        END_TIME = STR_TO_DATE(p_end_time, '%Y%m%d%H%i%s'),
        IDLE_STATE = p_idle_state,
        MDFY_DATE = NOW(),
        MDFY_EMP = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//

-- ============================================================
-- sp_imes_tshp_idletime_ins: 비가동시간 신규 등록
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_INS() (lines 438-495)
-- AS-IS 컬럼: PLT_CODE, IDLE_ID, WORK_DATE, MC_CODE, EMP_CODE, IDLE_CODE,
--   IDLE_TIME, IDLE_STATE, START_TIME, END_TIME,
--   ACTUAL_ID, WO_NO, NG_ID, SCOMMENT, MCT_SCOMMENT,
--   REG_DATE, REG_EMP, DATA_FLAG
-- 용도: POP32A_INS (D0A 등록), POP30A_INS2 (비가동입력)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ins//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ins(
    IN p_plt_code      VARCHAR(10),
    IN p_idle_id       VARCHAR(30),
    IN p_mc_code       VARCHAR(20),
    IN p_emp_code      VARCHAR(20),
    IN p_idle_code     VARCHAR(20),
    IN p_start_time    VARCHAR(14),
    IN p_end_time      VARCHAR(14),
    IN p_idle_state    VARCHAR(1),
    IN p_idle_time     INT,
    IN p_work_date     VARCHAR(8),
    IN p_user_id       VARCHAR(20),
    IN p_scomment      VARCHAR(500),
    IN p_wo_no         VARCHAR(20),
    IN p_actual_id     VARCHAR(30),
    IN p_ng_id         VARCHAR(30),
    IN p_mct_scomment  VARCHAR(500)
)
BEGIN
    INSERT INTO TSHP_IDLETIME (
        PLT_CODE, IDLE_ID, WORK_DATE, MC_CODE, EMP_CODE, IDLE_CODE,
        IDLE_TIME, IDLE_STATE, START_TIME, END_TIME,
        ACTUAL_ID, WO_NO, NG_ID, SCOMMENT, MCT_SCOMMENT,
        REG_DATE, REG_EMP, IS_AUTO_IDLE_FLAG, IF_FLAG, DATA_FLAG
    ) VALUES (
        p_plt_code, p_idle_id, p_work_date, p_mc_code, p_emp_code, p_idle_code,
        p_idle_time, p_idle_state, STR_TO_DATE(p_start_time, '%Y%m%d%H%i%s'), STR_TO_DATE(p_end_time, '%Y%m%d%H%i%s'),
        p_actual_id, p_wo_no, p_ng_id, p_scomment, p_mct_scomment,
        NOW(), p_user_id, '0', '0', 0
    );
END//

-- ============================================================
-- sp_imes_tshp_idletime_upd4: 비가동 종료 (IDLE_STATE/END_TIME)
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UPD4()
-- 용도: POP30B 비가동 종료 처리
-- 수정 필드: IDLE_TIME, END_TIME, IDLE_STATE
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_upd4//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_upd4(
    IN p_plt_code   VARCHAR(10),
    IN p_idle_id    VARCHAR(20),
    IN p_idle_state VARCHAR(1),
    IN p_end_time   VARCHAR(14),
    IN p_idle_time  INT,
    IN p_user_id    VARCHAR(50)
)
BEGIN
    UPDATE TSHP_IDLETIME SET
        IDLE_TIME  = p_idle_time,
        END_TIME   = STR_TO_DATE(p_end_time, '%Y%m%d%H%i%s'),
        IDLE_STATE = p_idle_state,
        MDFY_DATE  = NOW(),
        MDFY_EMP   = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND IDLE_ID = p_idle_id;
END//

-- ============================================================
-- sp_imes_tshp_idletime_ser_pop30b: 비가동 단건 조회 (MC_CODE + IDLE_STATE)
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_SER() (POP30B용)
-- 용도: POP30B 설비코드 + 비가동상태 기준 비가동 조회
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ser_pop30b//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ser_pop30b(
    IN p_plt_code   VARCHAR(10),
    IN p_mc_code    VARCHAR(20),
    IN p_idle_state VARCHAR(1)
)
BEGIN
    SELECT PLT_CODE AS "pltCode", IDLE_ID AS "idleId", WORK_DATE AS "workDate", MC_CODE AS "mcCode",
           EMP_CODE AS "empCode", WO_NO AS "woNo", IDLE_CODE AS "idleCode", IDLE_STATE AS "idleState",
           DATE_FORMAT(START_TIME, '%Y-%m-%d %H:%i:%s') AS "startTime",
           DATE_FORMAT(END_TIME, '%Y-%m-%d %H:%i:%s') AS "endTime",
           IDLE_TIME AS "idleTime"
    FROM TSHP_IDLETIME
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE = p_mc_code
      AND IDLE_STATE = p_idle_state
      AND DATA_FLAG = 0;
END//

-- ============================================================
-- sp_imes_tshp_idletime_ser4: 비가동 조회 (WO_NO + IDLE_STATE)
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_SER4()
-- 용도: POP30B 작업지시번호 + 비가동상태 기준 비가동 조회
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ser4//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ser4(
    IN p_plt_code   VARCHAR(10),
    IN p_wo_no      VARCHAR(20),
    IN p_idle_state VARCHAR(1)
)
BEGIN
    SELECT PLT_CODE AS "pltCode", IDLE_ID AS "idleId", WO_NO AS "woNo", MC_CODE AS "mcCode",
           EMP_CODE AS "empCode", IDLE_CODE AS "idleCode", IDLE_STATE AS "idleState",
           DATE_FORMAT(START_TIME, '%Y-%m-%d %H:%i:%s') AS "startTime"
    FROM TSHP_IDLETIME
    WHERE PLT_CODE = p_plt_code
      AND WO_NO = p_wo_no
      AND IDLE_STATE = p_idle_state
      AND DATA_FLAG = 0;
END//

-- ============================================================
-- sp_imes_tshp_idletime_ser4_2: 비가동 조회 (MC_CODE + IDLE_STATE, START 용)
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_SER4_2()
-- 용도: POP30B 설비코드 + 비가동상태 기준 비가동 시작 조회
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ser4_2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ser4_2(
    IN p_plt_code   VARCHAR(10),
    IN p_mc_code    VARCHAR(20),
    IN p_idle_state VARCHAR(1)
)
BEGIN
    SELECT PLT_CODE AS "pltCode", IDLE_ID AS "idleId", WO_NO AS "woNo", MC_CODE AS "mcCode",
           EMP_CODE AS "empCode", IDLE_CODE AS "idleCode", IDLE_STATE AS "idleState",
           DATE_FORMAT(START_TIME, '%Y-%m-%d %H:%i:%s') AS "startTime"
    FROM TSHP_IDLETIME
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE = p_mc_code
      AND IDLE_STATE = p_idle_state
      AND DATA_FLAG = 0;
END//

-- ============================================================
-- sp_imes_tshp_idletime_ser5: 비가동 조회 (EMP+WO+STATE)
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_SER5()
-- 용도: POP30B 작업자 + 작업지시 + 비가동상태 기준 비가동 조회
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_ser5//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_ser5(
    IN p_plt_code   VARCHAR(10),
    IN p_emp_code   VARCHAR(20),
    IN p_wo_no      VARCHAR(20),
    IN p_idle_state VARCHAR(1)
)
BEGIN
    SELECT PLT_CODE AS "pltCode", IDLE_ID AS "idleId", WO_NO AS "woNo", MC_CODE AS "mcCode",
           EMP_CODE AS "empCode", IDLE_CODE AS "idleCode", IDLE_STATE AS "idleState",
           DATE_FORMAT(START_TIME, '%Y-%m-%d %H:%i:%s') AS "startTime"
    FROM TSHP_IDLETIME
    WHERE PLT_CODE = p_plt_code
      AND EMP_CODE = p_emp_code
      AND (p_wo_no IS NULL OR p_wo_no = '' OR WO_NO = p_wo_no)
      AND IDLE_STATE = p_idle_state
      AND DATA_FLAG = 0;
END//

-- ============================================================
-- sp_imes_tshp_idletime_upd6: 자동비가동 플래그 해제
-- 원본: TSHP_IDLETIME.TSHP_IDLETIME_UPD6()
-- 용도: POP30A_INS2 비가동 시작/종료 시 IS_AUTO_IDLE_FLAG='0'
-- 추가일: 2026-03-19
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_idletime_upd6//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_idletime_upd6(
    IN p_plt_code  VARCHAR(10),
    IN p_emp_code  VARCHAR(20),
    IN p_work_date VARCHAR(8),
    IN p_user_id   VARCHAR(50)
)
BEGIN
    UPDATE TSHP_IDLETIME SET
        IS_AUTO_IDLE_FLAG = '0',
        MDFY_DATE = NOW(),
        MDFY_EMP = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND EMP_CODE = p_emp_code
      AND DATE_FORMAT(START_TIME, '%Y%m%d') = p_work_date;
END//

DELIMITER ;
