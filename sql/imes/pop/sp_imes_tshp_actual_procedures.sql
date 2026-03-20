-- ============================================================
-- TSHP_ACTUAL CRUD 프로시저 (POP 모듈)
-- 생성일: 2026-03-05
-- 대상 테이블: TSHP_ACTUAL
-- 원본: ProActive TSHP_ACTUAL.cs
-- 화면: POP33A (공수오류현황)
-- ============================================================
-- 포함 프로시저 (7개):
--   1. sp_imes_tshp_actual_upd11                   - 실적 IF_SEL_FLAG 수정
--   2. sp_imes_tshp_actual_ser2                    - 실적 단건 조회
--   3. sp_imes_tshp_actual_del                     - 실적 삭제 (물리)
--   4. sp_imes_tshp_actual_ins3                    - 실적 복원 (DEL→ACTUAL)
--   5. sp_imes_tshp_actual_idletime_upd            - IF_SEL_FLAG 업데이트 (ACT/IL 분기)
--   6. sp_imes_tshp_actual_idletime_del            - 실적삭제 래퍼 (ACT: 백업+삭제, IL: 논리삭제)
--   7. sp_imes_tshp_actual_idletime_del_restore    - 삭제취소 래퍼 (ACT: 복원+백업삭제, IL: 복원)
-- ============================================================


DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_actual_upd11: 실적 IF_SEL_FLAG 수정
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_UPD11()
-- 용도: POP33A Grid2에서 SAP 전송 플래그 변경
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_upd11//

CREATE PROCEDURE sp_imes_tshp_actual_upd11(
    IN p_plt_code    VARCHAR(10),    /* 공장코드 */
    IN p_actual_id   VARCHAR(30),    /* 실적ID (PK) */
    IN p_if_sel_flag VARCHAR(5),     /* SAP 선택 플래그 */
    IN p_user_id     VARCHAR(50)     /* 수정자 */
)
BEGIN
    UPDATE TSHP_ACTUAL SET
        IF_SEL_FLAG = p_if_sel_flag,
        MDFY_DATE   = NOW(),
        MDFY_EMP    = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


-- ============================================================
-- 2. sp_imes_tshp_actual_ser2: 실적 단건 조회
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_SER2()
-- 용도: POP33A 실적 삭제 전 백업용 데이터 조회
-- 컬럼: 31개 (TSHP_ACTUAL 전체 컬럼)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_ser2//

CREATE PROCEDURE sp_imes_tshp_actual_ser2(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_actual_id VARCHAR(30)     /* 실적ID (PK) */
)
BEGIN
    SELECT
        PLT_CODE                AS "pltCode"
       ,ACTUAL_ID               AS "actualId"
       ,WORK_DATE               AS "workDate"
       ,WO_NO                   AS "woNo"
       ,EMP_CODE                AS "empCode"
       ,MC_CODE                 AS "mcCode"
       ,MC_NM_CHECK             AS "mcNmCheck"
       ,PROC_STAT               AS "procStat"
       ,PANEL_STAT              AS "panelStat"
       ,DATE_FORMAT(ACT_START_TIME, '%Y-%m-%d %H:%i:%s')  AS "actStartTime"
       ,DATE_FORMAT(ACT_END_TIME, '%Y-%m-%d %H:%i:%s')   AS "actEndTime"
       ,SELF_TIME               AS "selfTime"
       ,DATE_FORMAT(SELF_START_TIME, '%Y-%m-%d %H:%i:%s') AS "selfStartTime"
       ,DATE_FORMAT(SELF_END_TIME, '%Y-%m-%d %H:%i:%s')  AS "selfEndTime"
       ,MAN_TIME                AS "manTime"
       ,DATE_FORMAT(MAN_START_TIME, '%Y-%m-%d %H:%i:%s')  AS "manStartTime"
       ,DATE_FORMAT(MAN_END_TIME, '%Y-%m-%d %H:%i:%s')   AS "manEndTime"
       ,OT_TIME                 AS "otTime"
       ,PAUSE_TIME              AS "pauseTime"
       ,DATE_FORMAT(PAUSE_START_TIME, '%Y-%m-%d %H:%i:%s') AS "pauseStartTime"
       ,DATE_FORMAT(PAUSE_END_TIME, '%Y-%m-%d %H:%i:%s')  AS "pauseEndTime"
       ,OK_QTY                  AS "okQty"
       ,NG_QTY                  AS "ngQty"
       ,MULTI_START_CNT         AS "multiStartCnt"
       ,ACT_TL_NO               AS "actTlNo"
       ,INPUT_FLAG              AS "inputFlag"
       ,STK_ID                  AS "stkId"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')       AS "regDate"
       ,REG_EMP                 AS "regEmp"
       ,DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s')      AS "mdfyDate"
       ,MDFY_EMP                AS "mdfyEmp"
       ,IF_FLAG                 AS "ifFlag"
    FROM TSHP_ACTUAL
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


-- ============================================================
-- 3. sp_imes_tshp_actual_del: 실적 물리 삭제
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_DEL()
-- 용도: POP33A 실적 삭제 (ACTUAL_DEL로 이동 후 원본 삭제)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_del//

CREATE PROCEDURE sp_imes_tshp_actual_del(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_actual_id VARCHAR(30)     /* 실적ID (PK) */
)
BEGIN
    DELETE FROM TSHP_ACTUAL
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


-- ============================================================
-- 4. sp_imes_tshp_actual_ins3: 실적 복원 (DEL→ACTUAL)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_INS3()
-- 용도: POP33A 삭제 실적 복원 시 TSHP_ACTUAL에 재등록
-- 컬럼: 21개 (IF_FLAG 포함)
-- 참고: INS3은 REG_DATE, REG_EMP를 파라미터로 받음
--       (원본 등록일시/등록자 유지를 위해)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_ins3//

CREATE PROCEDURE sp_imes_tshp_actual_ins3(
    IN p_plt_code        VARCHAR(10),
    IN p_actual_id       VARCHAR(30),
    IN p_work_date       VARCHAR(8),
    IN p_wo_no           VARCHAR(20),
    IN p_emp_code        VARCHAR(20),
    IN p_mc_code         VARCHAR(20),
    IN p_mc_nm_check     VARCHAR(50),
    IN p_proc_stat       VARCHAR(5),
    IN p_panel_stat      VARCHAR(5),
    IN p_act_start_time  DATETIME,
    IN p_act_end_time    DATETIME,
    IN p_self_time       DECIMAL(18,4),
    IN p_man_time        DECIMAL(18,4),
    IN p_ot_time         DECIMAL(18,4),
    IN p_ok_qty          DECIMAL(18,4),
    IN p_ng_qty          DECIMAL(18,4),
    IN p_multi_start_cnt INT,
    IN p_input_flag      VARCHAR(5),
    IN p_reg_date        DATETIME,
    IN p_reg_emp         VARCHAR(50),
    IN p_if_flag         VARCHAR(5)
)
BEGIN
    INSERT INTO TSHP_ACTUAL (
        PLT_CODE, ACTUAL_ID, WORK_DATE, WO_NO, EMP_CODE, MC_CODE, MC_NM_CHECK,
        PROC_STAT, PANEL_STAT, ACT_START_TIME, ACT_END_TIME,
        SELF_TIME, MAN_TIME, OT_TIME, OK_QTY, NG_QTY,
        MULTI_START_CNT, INPUT_FLAG, REG_DATE, REG_EMP, IF_FLAG
    ) VALUES (
        p_plt_code, p_actual_id, p_work_date, p_wo_no, p_emp_code, p_mc_code, p_mc_nm_check,
        p_proc_stat, p_panel_stat, p_act_start_time, p_act_end_time,
        p_self_time, p_man_time, p_ot_time, p_ok_qty, p_ng_qty,
        p_multi_start_cnt, p_input_flag, p_reg_date, p_reg_emp, p_if_flag
    );
END//


-- ============================================================
-- 5. sp_imes_tshp_actual_idletime_upd: IF_SEL_FLAG 업데이트 (ACT/IL 분기)
-- 용도: POP33A pop33aIns/pop33aIns2에서 KEY 접두어 분기 로직을 SP로 통합
-- 로직: ACT% → sp_imes_tshp_actual_upd11 호출
--       IL%  → sp_imes_tshp_idletime_upd8 호출
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_idletime_upd//

CREATE PROCEDURE sp_imes_tshp_actual_idletime_upd(
    IN p_plt_code    VARCHAR(10),    /* 공장코드 */
    IN p_key         VARCHAR(30),    /* KEY (ACT... 또는 IL...) */
    IN p_if_sel_flag VARCHAR(5),     /* SAP 선택 플래그 */
    IN p_user_id     VARCHAR(50)     /* 수정자 */
)
BEGIN
    IF p_key LIKE 'ACT%' THEN
        /* TSHP_ACTUAL: IF_SEL_FLAG 업데이트 */
        CALL sp_imes_tshp_actual_upd11(p_plt_code, p_key, p_if_sel_flag, p_user_id);
    ELSEIF p_key LIKE 'IL%' THEN
        /* TSHP_IDLETIME: IF_SEL_FLAG 업데이트 */
        CALL sp_imes_tshp_idletime_upd8(p_plt_code, p_key, p_if_sel_flag, p_user_id);
    END IF;
END//


-- ============================================================
-- 6. sp_imes_tshp_actual_idletime_del: 실적삭제 래퍼 (ACT/IL 분기)
-- 용도: ORD18A Tab1 삭제, POP33A 삭제
-- 로직: ACT% → TSHP_ACTUAL→TSHP_ACTUAL_DEL 백업 후 원본 삭제
--       IL%  → sp_imes_tshp_idletime_ude 호출 (논리삭제 DATA_FLAG=2)
-- 기존 Java 3회 왕복(SER2→DEL_INS→DEL)을 SP 1회 호출로 통합
-- 두 테이블 컬럼 동일(44개)하여 INSERT...SELECT * 사용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_idletime_del//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_idletime_del(
    IN p_plt_code VARCHAR(10),    /* 공장코드 */
    IN p_key      VARCHAR(30),    /* KEY (ACT... 또는 IL...) */
    IN p_user_id  VARCHAR(50)     /* 삭제자 */
)
BEGIN
    IF p_key LIKE 'ACT%' THEN
        /* TSHP_ACTUAL → TSHP_ACTUAL_DEL (전체 44컬럼 백업) */
        INSERT INTO TSHP_ACTUAL_DEL
        SELECT * FROM TSHP_ACTUAL
        WHERE PLT_CODE = p_plt_code
          AND ACTUAL_ID = p_key;

        /* 원본 삭제 */
        DELETE FROM TSHP_ACTUAL
        WHERE PLT_CODE = p_plt_code
          AND ACTUAL_ID = p_key;

    ELSEIF p_key LIKE 'IL%' THEN
        /* TSHP_IDLETIME: 논리삭제 (DATA_FLAG=2) */
        CALL sp_imes_tshp_idletime_ude(p_plt_code, p_key, p_user_id);
    END IF;
END//


-- ============================================================
-- 7. sp_imes_tshp_actual_idletime_del_restore: 삭제취소 래퍼 (ACT/IL 분기)
-- 용도: ORD18A Tab2 삭제취소, POP33A 삭제취소
-- 로직: ACT% → TSHP_ACTUAL_DEL→TSHP_ACTUAL 복원 후 백업 삭제
--       IL%  → sp_imes_tshp_idletime_ude_restore 호출 (DATA_FLAG=0)
-- 기존 Java 3회 왕복(DEL_SER→INS3→DEL_DEL)을 SP 1회 호출로 통합
-- 두 테이블 컬럼 동일(44개)하여 INSERT...SELECT * 사용
-- 참고: 기존 ins3는 21컬럼만 복원 → 23컬럼 손실 문제 해결
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_idletime_del_restore//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_idletime_del_restore(
    IN p_plt_code VARCHAR(10),    /* 공장코드 */
    IN p_key      VARCHAR(30),    /* KEY (ACT... 또는 IL...) */
    IN p_user_id  VARCHAR(50)     /* 복원자 */
)
BEGIN
    IF p_key LIKE 'ACT%' THEN
        /* TSHP_ACTUAL_DEL → TSHP_ACTUAL (전체 44컬럼 복원) */
        INSERT INTO TSHP_ACTUAL
        SELECT * FROM TSHP_ACTUAL_DEL
        WHERE PLT_CODE = p_plt_code
          AND ACTUAL_ID = p_key;

        /* 백업 삭제 */
        DELETE FROM TSHP_ACTUAL_DEL
        WHERE PLT_CODE = p_plt_code
          AND ACTUAL_ID = p_key;

    ELSEIF p_key LIKE 'IL%' THEN
        /* TSHP_IDLETIME: 복원 (DATA_FLAG=0) */
        CALL sp_imes_tshp_idletime_ude_restore(p_plt_code, p_key, p_user_id);
    END IF;
END//


-- ============================================================
-- 8. sp_imes_tshp_actual_ins_pop30b: 실적 등록 (작업 시작)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_INS() - POP30B용
-- 용도: POP30B 작업 시작 시 실적 등록 (ACT_END_TIME 없음)
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_ins_pop30b//

CREATE PROCEDURE sp_imes_tshp_actual_ins_pop30b(
    IN p_plt_code        VARCHAR(10),
    IN p_actual_id       VARCHAR(30),
    IN p_work_date       VARCHAR(8),
    IN p_wo_no           VARCHAR(20),
    IN p_emp_code        VARCHAR(20),
    IN p_mc_code         VARCHAR(20),
    IN p_mc_nm_check     VARCHAR(50),
    IN p_proc_stat       VARCHAR(5),
    IN p_panel_stat      VARCHAR(5),
    IN p_act_start_time  DATETIME,
    IN p_self_time       INT,
    IN p_man_time        INT,
    IN p_ot_time         INT,
    IN p_ok_qty          DECIMAL(18,4),
    IN p_ng_qty          DECIMAL(18,4),
    IN p_multi_start_cnt INT,
    IN p_input_flag      VARCHAR(5),
    IN p_is_pre_work     VARCHAR(5),
    IN p_user_id         VARCHAR(50)
)
BEGIN
    INSERT INTO TSHP_ACTUAL (
        PLT_CODE, ACTUAL_ID, WORK_DATE, WO_NO, EMP_CODE, MC_CODE, MC_NM_CHECK,
        PROC_STAT, PANEL_STAT, ACT_START_TIME,
        SELF_TIME, MAN_TIME, OT_TIME, OK_QTY, NG_QTY,
        MULTI_START_CNT, INPUT_FLAG, IS_PRE_WORK, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_actual_id, p_work_date, p_wo_no, p_emp_code, p_mc_code, p_mc_nm_check,
        p_proc_stat, p_panel_stat, p_act_start_time,
        IFNULL(p_self_time, 0), IFNULL(p_man_time, 0), IFNULL(p_ot_time, 0),
        IFNULL(p_ok_qty, 0), IFNULL(p_ng_qty, 0),
        IFNULL(p_multi_start_cnt, 0), p_input_flag, p_is_pre_work, NOW(), p_user_id
    );
END//


-- ============================================================
-- 9. sp_imes_tshp_actual_ins2_pop30b: 실적 등록 (작업 완료)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_INS2() - POP30B용
-- 용도: POP30B 작업 완료 시 실적 등록 (ACT_END_TIME 포함)
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_ins2_pop30b//

CREATE PROCEDURE sp_imes_tshp_actual_ins2_pop30b(
    IN p_plt_code        VARCHAR(10),
    IN p_actual_id       VARCHAR(30),
    IN p_work_date       VARCHAR(8),
    IN p_wo_no           VARCHAR(20),
    IN p_emp_code        VARCHAR(20),
    IN p_mc_code         VARCHAR(20),
    IN p_mc_nm_check     VARCHAR(50),
    IN p_proc_stat       VARCHAR(5),
    IN p_panel_stat      VARCHAR(5),
    IN p_act_start_time  DATETIME,
    IN p_act_end_time    DATETIME,
    IN p_self_time       INT,
    IN p_man_time        INT,
    IN p_ot_time         INT,
    IN p_ok_qty          DECIMAL(18,4),
    IN p_ng_qty          DECIMAL(18,4),
    IN p_multi_start_cnt INT,
    IN p_input_flag      VARCHAR(5),
    IN p_is_pre_work     VARCHAR(5),
    IN p_user_id         VARCHAR(50)
)
BEGIN
    INSERT INTO TSHP_ACTUAL (
        PLT_CODE, ACTUAL_ID, WORK_DATE, WO_NO, EMP_CODE, MC_CODE, MC_NM_CHECK,
        PROC_STAT, PANEL_STAT, ACT_START_TIME, ACT_END_TIME,
        SELF_TIME, MAN_TIME, OT_TIME, OK_QTY, NG_QTY,
        MULTI_START_CNT, INPUT_FLAG, IS_PRE_WORK, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_actual_id, p_work_date, p_wo_no, p_emp_code, p_mc_code, p_mc_nm_check,
        p_proc_stat, p_panel_stat, p_act_start_time, p_act_end_time,
        IFNULL(p_self_time, 0), IFNULL(p_man_time, 0), IFNULL(p_ot_time, 0),
        IFNULL(p_ok_qty, 0), IFNULL(p_ng_qty, 0),
        IFNULL(p_multi_start_cnt, 0), p_input_flag, p_is_pre_work, NOW(), p_user_id
    );
END//


-- ============================================================
-- 10. sp_imes_tshp_actual_upd8: 종료시간+상태 업데이트
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_UPD8()
-- 용도: POP30B 작업 종료 시 종료시간 및 공정상태 업데이트
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_upd8//

CREATE PROCEDURE sp_imes_tshp_actual_upd8(
    IN p_plt_code      VARCHAR(10),    /* 공장코드 */
    IN p_actual_id     VARCHAR(30),    /* 실적ID (PK) */
    IN p_proc_stat     VARCHAR(5),     /* 공정상태 */
    IN p_act_end_time  DATETIME,       /* 종료시간 */
    IN p_user_id       VARCHAR(50)     /* 수정자 */
)
BEGIN
    UPDATE TSHP_ACTUAL SET
        PROC_STAT    = p_proc_stat,
        ACT_END_TIME = p_act_end_time,
        MDFY_DATE    = NOW(),
        MDFY_EMP     = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


-- ============================================================
-- 11. sp_imes_tshp_actual_upd9: 종료+IS_AUTO_IDLE_FLAG 리셋
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_UPD9()
-- 용도: POP30B 작업 종료 시 종료시간/상태 업데이트 + IS_AUTO_IDLE_FLAG 리셋
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_upd9//

CREATE PROCEDURE sp_imes_tshp_actual_upd9(
    IN p_plt_code      VARCHAR(10),    /* 공장코드 */
    IN p_actual_id     VARCHAR(30),    /* 실적ID (PK) */
    IN p_proc_stat     VARCHAR(5),     /* 공정상태 */
    IN p_act_end_time  DATETIME,       /* 종료시간 */
    IN p_user_id       VARCHAR(50)     /* 수정자 */
)
BEGIN
    UPDATE TSHP_ACTUAL SET
        PROC_STAT         = p_proc_stat,
        ACT_END_TIME      = p_act_end_time,
        IS_AUTO_IDLE_FLAG = '0',
        MDFY_DATE         = NOW(),
        MDFY_EMP          = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


-- ============================================================
-- 12. sp_imes_tshp_actual_upd10: IS_AUTO_IDLE_FLAG 리셋 (작업자+날짜별)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_UPD10()
-- 용도: POP30B 작업자의 해당 날짜 실적 IS_AUTO_IDLE_FLAG 일괄 리셋
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_upd10//

CREATE PROCEDURE sp_imes_tshp_actual_upd10(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_work_date VARCHAR(8),     /* 작업일자 (yyyyMMdd) */
    IN p_user_id   VARCHAR(50)     /* 수정자 */
)
BEGIN
    UPDATE TSHP_ACTUAL SET
        IS_AUTO_IDLE_FLAG = '0',
        MDFY_DATE         = NOW(),
        MDFY_EMP          = p_user_id
    WHERE PLT_CODE = p_plt_code
      AND EMP_CODE = p_emp_code
      AND DATE_FORMAT(ACT_START_TIME, '%Y%m%d') = p_work_date;
END//


-- ============================================================
-- 13. sp_imes_tshp_actual_ser4: 진행 중 실적 조회 (WO+EMP)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_SER4()
-- 용도: POP30B 작업 시작 전 동일 WO/EMP의 진행 중 실적 확인
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_ser4//

CREATE PROCEDURE sp_imes_tshp_actual_ser4(
    IN p_plt_code VARCHAR(10),    /* 공장코드 */
    IN p_emp_code VARCHAR(20),    /* 작업자코드 */
    IN p_wo_no    VARCHAR(20)     /* 작업오더번호 */
)
BEGIN
    SELECT
        PLT_CODE   AS "pltCode"
       ,ACTUAL_ID  AS "actualId"
    FROM TSHP_ACTUAL
    WHERE PLT_CODE = p_plt_code
      AND EMP_CODE = p_emp_code
      AND WO_NO    = p_wo_no
      AND PROC_STAT = '2';
END//


-- ============================================================
-- 14. sp_imes_tshp_actual_ser5: 실적 단건 조회 (WO+EMP, 최신)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_SER5()
-- 용도: POP30B WO+EMP 기준 최신 실적 단건 조회
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_ser5//

CREATE PROCEDURE sp_imes_tshp_actual_ser5(
    IN p_plt_code VARCHAR(10),    /* 공장코드 */
    IN p_wo_no    VARCHAR(20),    /* 작업오더번호 */
    IN p_emp_code VARCHAR(20)     /* 작업자코드 */
)
BEGIN
    SELECT
        PLT_CODE                                                AS "pltCode"
       ,ACTUAL_ID                                               AS "actualId"
       ,WORK_DATE                                               AS "workDate"
       ,WO_NO                                                   AS "woNo"
       ,EMP_CODE                                                AS "empCode"
       ,MC_CODE                                                 AS "mcCode"
       ,MC_NM_CHECK                                             AS "mcNmCheck"
       ,PROC_STAT                                               AS "procStat"
       ,PANEL_STAT                                              AS "panelStat"
       ,DATE_FORMAT(ACT_START_TIME, '%Y-%m-%d %H:%i:%s')        AS "actStartTime"
       ,DATE_FORMAT(ACT_END_TIME, '%Y-%m-%d %H:%i:%s')          AS "actEndTime"
       ,SELF_TIME                                               AS "selfTime"
       ,DATE_FORMAT(SELF_START_TIME, '%Y-%m-%d %H:%i:%s')       AS "selfStartTime"
       ,DATE_FORMAT(SELF_END_TIME, '%Y-%m-%d %H:%i:%s')         AS "selfEndTime"
       ,MAN_TIME                                                AS "manTime"
       ,DATE_FORMAT(MAN_START_TIME, '%Y-%m-%d %H:%i:%s')        AS "manStartTime"
       ,DATE_FORMAT(MAN_END_TIME, '%Y-%m-%d %H:%i:%s')          AS "manEndTime"
       ,OT_TIME                                                 AS "otTime"
       ,PAUSE_TIME                                              AS "pauseTime"
       ,DATE_FORMAT(PAUSE_START_TIME, '%Y-%m-%d %H:%i:%s')      AS "pauseStartTime"
       ,DATE_FORMAT(PAUSE_END_TIME, '%Y-%m-%d %H:%i:%s')        AS "pauseEndTime"
       ,OK_QTY                                                  AS "okQty"
       ,NG_QTY                                                  AS "ngQty"
       ,MULTI_START_CNT                                         AS "multiStartCnt"
       ,ACT_TL_NO                                               AS "actTlNo"
       ,INPUT_FLAG                                              AS "inputFlag"
       ,IS_PRE_WORK                                             AS "isPreWork"
       ,STK_ID                                                  AS "stkId"
       ,DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s')             AS "regDate"
       ,REG_EMP                                                 AS "regEmp"
       ,DATE_FORMAT(MDFY_DATE, '%Y-%m-%d %H:%i:%s')            AS "mdfyDate"
       ,MDFY_EMP                                                AS "mdfyEmp"
       ,IF_FLAG                                                 AS "ifFlag"
    FROM TSHP_ACTUAL
    WHERE PLT_CODE = p_plt_code
      AND WO_NO    = p_wo_no
      AND EMP_CODE = p_emp_code
      AND ACT_START_TIME = (
          SELECT MAX(ACT_START_TIME)
          FROM TSHP_ACTUAL
          WHERE PLT_CODE = p_plt_code
            AND WO_NO    = p_wo_no
            AND PROC_STAT IN ('2','3','4')
          GROUP BY WO_NO
      );
END//


DELIMITER ;
