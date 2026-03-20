-- ============================================================
-- TSHP_ACTUAL 프로시저
-- 생성일: 2026-03-05
-- 대상 테이블: TSHP_ACTUAL (공정 실적)
-- 원본: ProActive TSHP_ACTUAL.cs, TSHP_ACTUAL_QUERY.cs
-- ============================================================
-- 포함 프로시저:
--   1. sp_imes_tshp_actual_query19  - 작업자별 최신 실적 조회 (ORD16A)
--   2. sp_imes_tshp_actual_query42  - 작업자 상태 집계 (ORD16A)
--   3. sp_imes_tshp_actual_upd9     - 실적 완료 처리 (ORD16A)
--   4. sp_imes_tshp_actual_ins2     - 완료 실적 생성 (ORD16A)
--   5. sp_imes_tshp_actual_query6   - 실적 상세 조회 (ORD14A)
--   6. sp_imes_tshp_actual_query15  - Tab1 실적삭제 조회 (ORD18A)
--   7. sp_imes_tshp_actual_query15_3 - Tab2 삭제현황 조회 (ORD18A)
--   8. sp_imes_tshp_actual_query15_4 - 실적/비가동 현황 조회 (ORD15A)
-- ============================================================
-- 명명 규칙: sp_imes_tshp_actual_[액션]
-- ============================================================
-- ⚠️ 주의: 이 스크립트 실행 전에 반드시 아래 명령어를 먼저 실행할 것
--   SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //

-- ============================================================
-- sp_imes_tshp_actual_query19: 작업자별 최신 실적 조회
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY19()
-- 용도: ORD16A 완료처리 시 특정 상태의 작업자 목록 조회
-- 로직:
--   1. 지정된 WO_NO의 모든 실적에서 EMP_CODE별 최신 1건 추출
--      (ROW_NUMBER() OVER(PARTITION BY EMP_CODE ORDER BY ACT_START_TIME DESC))
--   2. 외부 쿼리에서 PROC_STAT 필터 + num=1 (최신만)
-- 파라미터:
--   p_plt_code  - 공장코드
--   p_wo_no     - 작업지시번호
--   p_proc_stat - 공정상태 ('2'=진행, '3'=중단, '4'=완료)
-- 정렬: 작업자명 → 작업자코드
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query19//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_query19(
    IN p_plt_code  VARCHAR(20),   /* 공장코드 */
    IN p_wo_no     VARCHAR(20),   /* 작업지시번호 */
    IN p_proc_stat VARCHAR(5)     /* 공정상태 (2=진행, 3=중단, 4=완료) */
)
BEGIN
    SELECT
        pltCode,       /* 공장코드 */
        num,           /* 순번 (항상 1) */
        empCode,       /* 작업자코드 */
        empName,       /* 작업자명 */
        procStat,      /* 공정상태 */
        actualId,      /* 실적ID */
        mcCode,        /* 설비코드 */
        isPreWork,     /* 선행작업여부 */
        panelStat      /* 패널상태 */
    FROM (
        SELECT
            A.PLT_CODE                                                           AS pltCode,
            ROW_NUMBER() OVER(PARTITION BY E.USER_ID ORDER BY A.ACT_START_TIME DESC) AS num,
            E.USER_ID                                                           AS empCode,
            E.USER_NAME                                                           AS empName,
            A.PROC_STAT                                                          AS procStat,
            A.ACTUAL_ID                                                          AS actualId,
            A.MC_CODE                                                            AS mcCode,
            A.IS_PRE_WORK                                                        AS isPreWork,
            A.PANEL_STAT                                                         AS panelStat
        FROM TSHP_ACTUAL A
        LEFT JOIN SYS_USER E
            ON A.PLT_CODE = E.PLT_CODE
            AND A.EMP_CODE = E.USER_ID
        WHERE A.WO_NO = p_wo_no
          AND A.PLT_CODE = p_plt_code
    ) EMPS
    WHERE procStat = p_proc_stat
      AND num = 1  /* 각 작업자의 최신 실적만 */
    ORDER BY empName, empCode;
END//


-- ============================================================
-- sp_imes_tshp_actual_query42: 작업자 상태 집계
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY42()
-- 용도: ORD16A 완료처리 전 작업자 현재 상태 파악
-- 로직:
--   1. 지정된 WO_NO의 모든 실적에서 EMP_CODE별 최신 1건 추출
--      (RANK() OVER(PARTITION BY EMP_CODE ORDER BY ACT_START_TIME DESC))
--   2. actSeq=1 (최신 상태만) 필터
-- 참고: QUERY19는 ROW_NUMBER + 특정 PROC_STAT 필터,
--       QUERY42는 RANK + 전체 PROC_STAT (상태 집계 목적)
-- 파라미터:
--   p_plt_code - 공장코드
--   p_wo_no    - 작업지시번호
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query42//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_query42(
    IN p_plt_code VARCHAR(20),   /* 공장코드 */
    IN p_wo_no    VARCHAR(20)    /* 작업지시번호 */
)
BEGIN
    SELECT
        actSeq,        /* 순번 (항상 1) */
        pltCode,       /* 공장코드 */
        empCode,       /* 작업자코드 */
        procStat       /* 공정상태 (현재 최신) */
    FROM (
        SELECT
            RANK() OVER(PARTITION BY EMP_CODE ORDER BY ACT_START_TIME DESC) AS actSeq,
            PLT_CODE AS pltCode,
            EMP_CODE AS empCode,
            PROC_STAT AS procStat
        FROM TSHP_ACTUAL
        WHERE PLT_CODE = p_plt_code
          AND WO_NO = p_wo_no
    ) A
    WHERE actSeq = 1;  /* 각 작업자의 최신 상태만 */
END//


-- ============================================================
-- sp_imes_tshp_actual_upd9: 실적 완료 처리 (기존 실적 종료)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_UPD9()
-- 용도: ORD16A 완료처리 시 진행중인 실적의 종료시간 설정
-- 로직:
--   - PROC_STAT 변경 (2→4: 진행→완료)
--   - ACT_END_TIME 설정 (완료시간)
--   - IS_AUTO_IDLE_FLAG='0' (자동 비가동 플래그 초기화)
--   - 수정일시/수정자 갱신
-- 변환: CONVERT(DATETIME, @ACT_END_TIME) → STR_TO_DATE(p_act_end_time, '%Y%m%d%H%i%s')
-- 파라미터:
--   p_plt_code     - 공장코드
--   p_actual_id    - 실적ID (PK)
--   p_proc_stat    - 변경할 공정상태 ('4'=완료)
--   p_act_end_time - 실적종료시간 (yyyyMMddHHmmss 문자열)
--   p_user_id      - 수정자ID
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_upd9//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_upd9(
    IN p_plt_code     VARCHAR(20),   /* 공장코드 */
    IN p_actual_id    VARCHAR(30),   /* 실적ID */
    IN p_proc_stat    VARCHAR(5),    /* 변경할 공정상태 */
    IN p_act_end_time VARCHAR(20),   /* 실적종료시간 (yyyyMMddHHmmss) */
    IN p_user_id      VARCHAR(20)    /* 수정자ID */
)
BEGIN
    UPDATE TSHP_ACTUAL
    SET PROC_STAT         = p_proc_stat,                                         /* 공정상태 변경 */
        ACT_END_TIME      = STR_TO_DATE(p_act_end_time, '%Y%m%d%H%i%s'),        /* 종료시간 설정 */
        IS_AUTO_IDLE_FLAG = '0',                                                 /* 자동비가동 플래그 초기화 */
        MDFY_DATE         = NOW(),                                               /* 수정일시 */
        MDFY_EMP          = p_user_id                                            /* 수정자 */
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID = p_actual_id;
END//


-- ============================================================
-- sp_imes_tshp_actual_ins2: 완료 실적 생성 (신규 INSERT)
-- 원본: TSHP_ACTUAL.TSHP_ACTUAL_INS2() (AS-IS에서 자동채번)
-- 용도: ORD16A 완료처리 시 새로운 완료 실적 레코드 생성
-- 자동채번 규칙:
--   ACTUAL_ID = 'A' + YYYYMMDD + 6자리 순번 (예: A20260304000001)
--   - 당일 기존 최대 순번 + 1
--   - AS-IS: UTILITY_GET_SERIALNO() 사용
--   - TO-BE: SUBSTRING + CAST로 직접 계산
-- 파라미터:
--   p_plt_code         - 공장코드
--   p_actual_id        - (미사용, 자동채번으로 대체)
--   p_work_date        - 작업일자 (yyyyMMdd)
--   p_wo_no            - 작업지시번호
--   p_emp_code         - 작업자코드
--   p_mc_code          - 설비코드
--   p_mc_nm_check      - 설비명 확인 여부
--   p_proc_stat        - 공정상태 ('4'=완료)
--   p_panel_stat       - 패널상태
--   p_act_start_time   - 실적시작시간 (yyyyMMddHHmmss)
--   p_act_end_time     - 실적종료시간 (yyyyMMddHHmmss)
--   p_self_time        - 자체시간 (분)
--   p_man_time         - 인건시간 (분)
--   p_ot_time          - 잔업시간 (분)
--   p_ok_qty           - 양품수량
--   p_ng_qty           - 불량수량
--   p_multi_start_cnt  - 다중시작횟수
--   p_input_flag       - 입력구분
--   p_user_id          - 등록자ID
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_ins2//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_ins2(
    IN p_plt_code        VARCHAR(20),   /* 공장코드 */
    IN p_actual_id       VARCHAR(30),   /* (미사용 - 자동채번) */
    IN p_work_date       VARCHAR(10),   /* 작업일자 (yyyyMMdd) */
    IN p_wo_no           VARCHAR(20),   /* 작업지시번호 */
    IN p_emp_code        VARCHAR(20),   /* 작업자코드 */
    IN p_mc_code         VARCHAR(20),   /* 설비코드 */
    IN p_mc_nm_check     VARCHAR(5),    /* 설비명확인 */
    IN p_proc_stat       VARCHAR(5),    /* 공정상태 ('4'=완료) */
    IN p_panel_stat      VARCHAR(5),    /* 패널상태 */
    IN p_act_start_time  VARCHAR(20),   /* 실적시작시간 (yyyyMMddHHmmss) */
    IN p_act_end_time    VARCHAR(20),   /* 실적종료시간 (yyyyMMddHHmmss) */
    IN p_self_time       VARCHAR(10),   /* 자체시간 (분) */
    IN p_man_time        VARCHAR(10),   /* 인건시간 (분) */
    IN p_ot_time         VARCHAR(10),   /* 잔업시간 (분) */
    IN p_ok_qty          VARCHAR(10),   /* 양품수량 */
    IN p_ng_qty          VARCHAR(10),   /* 불량수량 */
    IN p_multi_start_cnt VARCHAR(10),   /* 다중시작횟수 */
    IN p_input_flag      VARCHAR(5),    /* 입력구분 */
    IN p_user_id         VARCHAR(20)    /* 등록자ID */
)
BEGIN
    /* 자동채번용 변수 */
    DECLARE v_actual_id VARCHAR(30);
    DECLARE v_max_seq   INT DEFAULT 0;
    DECLARE v_date_str  VARCHAR(8);

    /* 당일 날짜 문자열 (YYYYMMDD) */
    SET v_date_str = DATE_FORMAT(NOW(), '%Y%m%d');

    /* 당일 최대 순번 조회
       ACTUAL_ID 형식: A + YYYYMMDD + 6자리 순번
       예: A20260304000001, A20260304000002, ...
       SUBSTRING(ACTUAL_ID, 10): 10번째 문자부터 끝까지 = 6자리 순번 */
    SELECT IFNULL(MAX(CAST(SUBSTRING(ACTUAL_ID, 10) AS UNSIGNED)), 0) + 1
        INTO v_max_seq
    FROM TSHP_ACTUAL
    WHERE PLT_CODE = p_plt_code
      AND ACTUAL_ID LIKE CONCAT('A', v_date_str, '%');

    /* 새 ACTUAL_ID 생성: A + YYYYMMDD + 6자리 순번 (0 패딩) */
    SET v_actual_id = CONCAT('A', v_date_str, LPAD(v_max_seq, 6, '0'));

    /* 완료 실적 INSERT */
    INSERT INTO TSHP_ACTUAL (
        PLT_CODE,          /* 공장코드 */
        ACTUAL_ID,         /* 실적ID (자동채번) */
        WORK_DATE,         /* 작업일자 */
        WO_NO,             /* 작업지시번호 */
        EMP_CODE,          /* 작업자코드 */
        MC_CODE,           /* 설비코드 */
        MC_NM_CHECK,       /* 설비명확인 */
        PROC_STAT,         /* 공정상태 */
        PANEL_STAT,        /* 패널상태 */
        ACT_START_TIME,    /* 실적시작시간 */
        ACT_END_TIME,      /* 실적종료시간 */
        SELF_TIME,         /* 자체시간 */
        MAN_TIME,          /* 인건시간 */
        OT_TIME,           /* 잔업시간 */
        OK_QTY,            /* 양품수량 */
        NG_QTY,            /* 불량수량 */
        MULTI_START_CNT,   /* 다중시작횟수 */
        INPUT_FLAG,        /* 입력구분 */
        REG_DATE,          /* 등록일시 */
        REG_EMP            /* 등록자 */
    ) VALUES (
        p_plt_code,
        v_actual_id,
        p_work_date,
        p_wo_no,
        p_emp_code,
        p_mc_code,
        p_mc_nm_check,
        p_proc_stat,
        p_panel_stat,
        STR_TO_DATE(p_act_start_time, '%Y%m%d%H%i%s'),   /* 문자열 → DATETIME 변환 */
        STR_TO_DATE(p_act_end_time, '%Y%m%d%H%i%s'),     /* 문자열 → DATETIME 변환 */
        CAST(p_self_time AS DECIMAL(10,2)),                /* 문자열 → 숫자 변환 */
        CAST(p_man_time AS DECIMAL(10,2)),
        CAST(p_ot_time AS DECIMAL(10,2)),
        CAST(p_ok_qty AS DECIMAL(10,2)),
        CAST(p_ng_qty AS DECIMAL(10,2)),
        CAST(p_multi_start_cnt AS SIGNED),                 /* 문자열 → 정수 변환 */
        p_input_flag,
        NOW(),             /* 등록일시 = 현재시간 */
        p_user_id          /* 등록자 */
    );
END//

-- ============================================================
-- sp_imes_tshp_actual_query6: 실적 상세 조회 (가공 실적관리)
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY6()
-- 용도: ORD14A 하단 그리드 - 작업지시별 실적 상세
-- 사용화면: ORD14A
-- 추가일: 2026-03-06
-- JOIN 구조 (1개 LEFT JOIN):
--   TSHP_ACTUAL A            (실적 - 메인)
--     ↔ TSTD_EMPLOYEE E      (작업자명)
-- 파라미터 (2개):
--   p_plt_code - 공장코드
--   p_wo_no    - 작업지시번호
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query6//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_query6(
    IN p_plt_code  VARCHAR(3),
    IN p_wo_no     VARCHAR(50)
)
BEGIN
    SELECT
        A.PLT_CODE        AS pltCode,
        A.ACTUAL_ID       AS actualId,
        A.PROC_STAT       AS procStat,
        IFNULL(A.IS_PRE_WORK, '0') AS isPreWork,
        A.PANEL_STAT      AS panelStat,
        A.WORK_DATE       AS workDate,
        A.EMP_CODE        AS empCode,
        E.EMP_NAME        AS empName,
        DATE_FORMAT(A.ACT_START_TIME, '%Y%m%d%H%i') AS actStartTime,
        DATE_FORMAT(A.ACT_END_TIME, '%Y%m%d%H%i')   AS actEndTime,
        CASE WHEN A.ACT_END_TIME IS NOT NULL
             THEN FLOOR(UNIX_TIMESTAMP(A.ACT_END_TIME)/60) - FLOOR(UNIX_TIMESTAMP(A.ACT_START_TIME)/60)
             ELSE NULL END AS actTime
    FROM TSHP_ACTUAL A
    LEFT JOIN TSTD_EMPLOYEE E
        ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.EMP_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND (p_wo_no IS NULL OR p_wo_no = '' OR A.WO_NO = p_wo_no)
    ORDER BY A.ACT_START_TIME;
END//

-- ============================================================
-- sp_imes_tshp_actual_query15: Tab1 실적삭제 조회 (ORD18A)
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY15
-- UNION ALL: TSHP_ACTUAL(실적) + TSHP_IDLETIME(비가동, DATA_FLAG=0)
-- MSSQL→MySQL: DATEDIFF→TIMESTAMPDIFF, CONVERT→DATE_FORMAT,
--              ISNULL→IFNULL, [KEY]→`KEY`, WITH(NOLOCK) 제거
-- 사용화면: ORD18A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query15//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_query15(
    IN p_plt_code     VARCHAR(10),
    IN p_s_work_date  VARCHAR(8),
    IN p_e_work_date  VARCHAR(8),
    IN p_s_wo_date    VARCHAR(8),
    IN p_e_wo_date    VARCHAR(8),
    IN p_order_like   VARCHAR(50),
    IN p_hogi_like    VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE AS "pltCode"
        ,`KEY` AS "key"
        ,ACT_TYPE AS "actType"
        ,ACT_CONTENTS AS "actContents"
        ,SAP_CODE AS "sapCode"
        ,IDLE_NAME AS "idleName"
        ,ORDER_NO AS "orderNo"
        ,ORDER_LINE AS "orderLine"
        ,PROD_HOGI AS "prodHogi"
        ,CUSTOMER AS "customer"
        ,PROC_ST AS "procSt"
        ,EMP_CODE AS "empCode"
        ,EMP_NAME AS "empName"
        ,ACT_START_TIME AS "actStartTime"
        ,ACT_END_TIME AS "actEndTime"
        ,ACT_TIME AS "actTime"
        ,WO_END_TIME AS "woEndTime"
        ,SAP_WO_NO AS "sapWoNo"
        ,WO_SEQ AS "woSeq"
        ,PROC_CODE AS "procCode"
        ,SAP_MC_CODE AS "sapMcCode"
        ,PRE_WORK AS "preWork"
        ,PROD_TYPE AS "prodType"
        ,PROC_STAT AS "procStat"
        ,READY_ST AS "readySt"
        ,MC_NAME AS "mcName"
        ,NG_ID AS "ngId"
        ,MC_NO AS "mcNo"
        ,MODEL_TYPE AS "modelType"
        ,PART_CODE AS "partCode"
        ,MODEL_NO AS "modelNo"
    FROM
    (
        -- ========== ACTUAL (실적) ==========
        SELECT
            A.PLT_CODE
            ,A.ACTUAL_ID AS `KEY`
            ,'실적' AS ACT_TYPE
            ,'' AS ACT_CONTENTS
            ,'' AS SAP_CODE
            ,'' AS IDLE_NAME
            ,P.ORDER_NO
            ,P.ORDER_LINE
            ,P.PROD_HOGI
            ,SAP.CUSTOMER
            ,W.PLN_PROC_TIME AS PROC_ST
            ,W.PLN_PROC_RDY_TIME AS READY_ST
            ,A.EMP_CODE
            ,E.EMP_NAME
            ,DATE_FORMAT(A.ACT_START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME
            ,DATE_FORMAT(A.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME
            ,TIMESTAMPDIFF(MINUTE, A.ACT_START_TIME, A.ACT_END_TIME) AS ACT_TIME
            ,DATE_FORMAT(W.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS WO_END_TIME
            ,W.SAP_WO_NO
            ,W.WO_SEQ
            ,W.PROC_CODE
            ,CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                  WHEN W.PLANTS = '3605' THEN A.MC_CODE END AS SAP_MC_CODE
            ,M.MC_NAME
            ,CASE WHEN IFNULL(A.IS_PRE_WORK,0) = '1' THEN '준비작업'
                  ELSE '' END AS PRE_WORK
            ,CASE WHEN MD.PROD_TYPE = 'E' THEN '전동'
                  WHEN MD.PROD_TYPE = 'P' THEN '유압'
                  WHEN MD.PROD_TYPE IS NULL THEN '가공' END AS PROD_TYPE
            ,A.PROC_STAT
            ,NULL AS NG_ID
            ,W.MC_NO
            ,P.MODEL_TYPE
            ,P.PART_CODE
            ,P.MODEL_NO
        FROM TSHP_ACTUAL A
        LEFT JOIN TSHP_WORKORDER W
            ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
        LEFT JOIN TORD_PRODUCT P
            ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
        LEFT JOIN IF_SAP_SHIPINFO SAP
            ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
        LEFT JOIN TSTD_MODEL MD
            ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_NO = MD.MODEL_NO
            AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_TYPE = MD.MODEL_TYPE
        LEFT JOIN TSTD_EMPLOYEE E
            ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.EMP_CODE
        LEFT JOIN LSE_MACHINE M
            ON A.PLT_CODE = M.PLT_CODE
            AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                     WHEN W.PLANTS = '3605' THEN A.MC_CODE END = M.MC_CODE
        WHERE A.PLT_CODE = p_plt_code
            AND (p_s_work_date = '' OR p_s_work_date IS NULL
                 OR (A.ACT_START_TIME >= STR_TO_DATE(p_s_work_date, '%Y%m%d')
                     AND A.ACT_START_TIME < DATE_ADD(STR_TO_DATE(p_e_work_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND (p_s_wo_date = '' OR p_s_wo_date IS NULL
                 OR (W.ACT_END_TIME >= STR_TO_DATE(p_s_wo_date, '%Y%m%d')
                     AND W.ACT_END_TIME < DATE_ADD(STR_TO_DATE(p_e_wo_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND A.ACT_START_TIME <> CASE
                WHEN A.PROC_STAT = '4' AND A.ACT_START_TIME = A.ACT_END_TIME
                THEN DATE_ADD(IFNULL(A.ACT_END_TIME, NOW()), INTERVAL 1 SECOND)
                ELSE IFNULL(A.ACT_END_TIME, NOW()) END
            AND A.EMP_CODE <> 'acitve'
            AND (p_order_like = '' OR p_order_like IS NULL
                 OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
            AND (p_hogi_like = '' OR p_hogi_like IS NULL
                 OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))

        UNION ALL

        -- ========== IDLETIME (비가동, DATA_FLAG=0) ==========
        SELECT
            I.PLT_CODE
            ,I.IDLE_ID AS `KEY`
            ,'비가동' AS ACT_TYPE
            ,IC.IDLE_CODE AS ACT_CONTENTS
            ,IC.SAP_CODE
            ,IC.IDLE_NAME
            ,P.ORDER_NO
            ,P.ORDER_LINE
            ,P.PROD_HOGI
            ,SAP.CUSTOMER
            ,W.PLN_PROC_TIME AS PROC_ST
            ,W.PLN_PROC_RDY_TIME AS READY_ST
            ,I.EMP_CODE
            ,E.EMP_NAME
            ,DATE_FORMAT(I.START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME
            ,DATE_FORMAT(I.END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME
            ,TIMESTAMPDIFF(MINUTE, I.START_TIME, I.END_TIME) AS ACT_TIME
            ,DATE_FORMAT(W.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS WO_END_TIME
            ,W.SAP_WO_NO
            ,W.WO_SEQ
            ,W.PROC_CODE
            ,CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                  WHEN W.PLANTS = '3605' THEN I.MC_CODE END AS SAP_MC_CODE
            ,M.MC_NAME
            ,'' AS PRE_WORK
            ,CASE WHEN MD.PROD_TYPE = 'E' THEN '전동'
                  WHEN MD.PROD_TYPE = 'P' THEN '유압'
                  WHEN MD.PROD_TYPE IS NULL THEN '가공' END AS PROD_TYPE
            ,NULL AS PROC_STAT
            ,I.NG_ID
            ,W.MC_NO
            ,P.MODEL_TYPE
            ,P.PART_CODE
            ,P.MODEL_NO
        FROM TSHP_IDLETIME I
        LEFT JOIN TSHP_WORKORDER W
            ON I.PLT_CODE = W.PLT_CODE AND I.WO_NO = W.WO_NO
        LEFT JOIN TORD_PRODUCT P
            ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
        LEFT JOIN IF_SAP_SHIPINFO SAP
            ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
        LEFT JOIN TSTD_MODEL MD
            ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_NO = MD.MODEL_NO
            AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_TYPE = MD.MODEL_TYPE
        LEFT JOIN TSTD_EMPLOYEE E
            ON I.PLT_CODE = E.PLT_CODE AND I.EMP_CODE = E.EMP_CODE
        LEFT JOIN TSTD_IDLECODE IC
            ON I.PLT_CODE = IC.PLT_CODE AND I.IDLE_CODE = IC.IDLE_CODE
        LEFT JOIN LSE_MACHINE M
            ON I.PLT_CODE = M.PLT_CODE
            AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                     WHEN W.PLANTS = '3605' THEN I.MC_CODE END = M.MC_CODE
        WHERE I.PLT_CODE = p_plt_code
            AND (p_s_work_date = '' OR p_s_work_date IS NULL
                 OR (I.START_TIME >= STR_TO_DATE(p_s_work_date, '%Y%m%d')
                     AND I.START_TIME < DATE_ADD(STR_TO_DATE(p_e_work_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND (p_s_wo_date = '' OR p_s_wo_date IS NULL
                 OR (W.ACT_END_TIME >= STR_TO_DATE(p_s_wo_date, '%Y%m%d')
                     AND W.ACT_END_TIME < DATE_ADD(STR_TO_DATE(p_e_wo_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND I.START_TIME <> IFNULL(I.END_TIME, NOW())
            AND I.EMP_CODE <> 'active'
            AND I.DATA_FLAG = 0
            AND (p_order_like = '' OR p_order_like IS NULL
                 OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
            AND (p_hogi_like = '' OR p_hogi_like IS NULL
                 OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
    ) A
    ORDER BY EMP_NAME, EMP_CODE, A.ACT_START_TIME, A.SAP_WO_NO;
END//

-- ============================================================
-- sp_imes_tshp_actual_query15_3: Tab2 삭제현황 조회 (ORD18A)
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY15_3
-- UNION ALL: TSHP_ACTUAL_DEL(삭제백업) + TSHP_IDLETIME(DATA_FLAG=2)
-- SAPA 서브쿼리 포함 (IF_SAP_WO_HEADER + IF_SAP_WO_ACTUAL)
-- 사용화면: ORD18A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query15_3//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_actual_query15_3(
    IN p_plt_code     VARCHAR(10),
    IN p_s_work_date  VARCHAR(8),
    IN p_e_work_date  VARCHAR(8),
    IN p_s_wo_date    VARCHAR(8),
    IN p_e_wo_date    VARCHAR(8),
    IN p_order_like   VARCHAR(50),
    IN p_hogi_like    VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE AS "pltCode"
        ,`KEY` AS "key"
        ,ACT_TYPE AS "actType"
        ,ACT_CONTENTS AS "actContents"
        ,SAP_CODE AS "sapCode"
        ,IDLE_NAME AS "idleName"
        ,ORDER_NO AS "orderNo"
        ,ORDER_LINE AS "orderLine"
        ,PROD_HOGI AS "prodHogi"
        ,CUSTOMER AS "customer"
        ,PROC_ST AS "procSt"
        ,EMP_CODE AS "empCode"
        ,EMP_NAME AS "empName"
        ,ACT_START_TIME AS "actStartTime"
        ,ACT_END_TIME AS "actEndTime"
        ,ACT_TIME AS "actTime"
        ,WO_END_TIME AS "woEndTime"
        ,SAP_WO_NO AS "sapWoNo"
        ,WO_SEQ AS "woSeq"
        ,PROC_CODE AS "procCode"
        ,SAP_MC_CODE AS "sapMcCode"
        ,PRE_WORK AS "preWork"
        ,PROD_TYPE AS "prodType"
        ,PROC_STAT AS "procStat"
        ,MC_NAME AS "mcName"
        ,MODEL AS "model"
        ,WORK_LOC AS "workLoc"
        ,ORDER_CONF_VALUE AS "orderConfValue"
        ,ORDER_CONF_COUNT AS "orderConfCount"
        ,CONF_VALUE AS "confValue"
        ,CONF_COUNT AS "confCount"
        ,EAI_RESULT AS "eaiResult"
        ,EAI_SCOMMENT AS "eaiScomment"
        ,IFNULL(IF_SEL_FLAG,'0') AS "ifSelFlag"
    FROM
    (
        -- ========== ACTUAL_DEL (삭제백업 실적) ==========
        SELECT
            A.PLT_CODE
            ,A.ACTUAL_ID AS `KEY`
            ,'실적' AS ACT_TYPE
            ,'' AS ACT_CONTENTS
            ,'' AS SAP_CODE
            ,'' AS IDLE_NAME
            ,P.ORDER_NO
            ,P.ORDER_LINE
            ,P.PROD_HOGI
            ,SAP.CUSTOMER
            ,W.PLN_PROC_TIME AS PROC_ST
            ,A.EMP_CODE
            ,E.EMP_NAME
            ,DATE_FORMAT(A.ACT_START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME
            ,DATE_FORMAT(A.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME
            ,TIMESTAMPDIFF(MINUTE, A.ACT_START_TIME, A.ACT_END_TIME) AS ACT_TIME
            ,DATE_FORMAT(W.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS WO_END_TIME
            ,W.SAP_WO_NO
            ,W.WO_SEQ
            ,W.PROC_CODE
            ,CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                  WHEN W.PLANTS = '3605' THEN A.MC_CODE END AS SAP_MC_CODE
            ,M.MC_NAME
            ,CASE WHEN IFNULL(A.IS_PRE_WORK,0) = '1' THEN '준비작업'
                  ELSE '' END AS PRE_WORK
            ,CASE WHEN MD.PROD_TYPE = 'E' THEN '전동'
                  WHEN MD.PROD_TYPE = 'P' THEN '유압'
                  WHEN MD.PROD_TYPE IS NULL THEN '가공' END AS PROD_TYPE
            ,A.PROC_STAT
            ,CASE WHEN W.PLANTS = '3603' THEN MD.MODEL_NO
                  WHEN W.PLANTS = '3605' THEN W.MODEL END AS MODEL
            ,SAPA.WORK_LOC
            ,SAPA.ORDER_CONF_VALUE
            ,SAPA.ORDER_CONF_COUNT
            ,SAPA.CONF_VALUE
            ,SAPA.CONF_COUNT
            ,SAPA.EAI_RESULT
            ,SAPA.EAI_SCOMMENT
            ,IFNULL(A.IF_SEL_FLAG,'0') AS IF_SEL_FLAG
        FROM TSHP_ACTUAL_DEL A
        LEFT JOIN TSHP_WORKORDER W
            ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
        LEFT JOIN TORD_PRODUCT P
            ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
        LEFT JOIN IF_SAP_SHIPINFO SAP
            ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
        LEFT JOIN TSTD_MODEL MD
            ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_NO = MD.MODEL_NO
            AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_TYPE = MD.MODEL_TYPE
        LEFT JOIN TSTD_EMPLOYEE E
            ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.EMP_CODE
        LEFT JOIN (
            SELECT
                H.KEY_VALUE
                ,H.WORK_LOC
                ,A2.WORK_TIME
                ,A2.IDLE_CODE
                ,A2.IDLE_TIME
                ,H.CONF_VALUE AS ORDER_CONF_VALUE
                ,H.CONF_COUNT AS ORDER_CONF_COUNT
                ,A2.CONF_VALUE
                ,A2.CONF_COUNT
                ,H.EAI_RESULT
                ,H.EAI_SCOMMENT
            FROM IF_SAP_WO_HEADER H
            LEFT JOIN IF_SAP_WO_ACTUAL A2
                ON H.KEY_VALUE = A2.KEY_VALUE
            WHERE H.KEY_VALUE IS NOT NULL
        ) SAPA
            ON A.ACTUAL_ID = SAPA.KEY_VALUE
        LEFT JOIN LSE_MACHINE M
            ON A.PLT_CODE = M.PLT_CODE
            AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                     WHEN W.PLANTS = '3605' THEN A.MC_CODE END = M.MC_CODE
        WHERE A.PLT_CODE = p_plt_code
            AND (p_s_work_date = '' OR p_s_work_date IS NULL
                 OR (A.ACT_START_TIME >= STR_TO_DATE(p_s_work_date, '%Y%m%d')
                     AND A.ACT_START_TIME < DATE_ADD(STR_TO_DATE(p_e_work_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND (p_s_wo_date = '' OR p_s_wo_date IS NULL
                 OR (W.ACT_END_TIME >= STR_TO_DATE(p_s_wo_date, '%Y%m%d')
                     AND W.ACT_END_TIME < DATE_ADD(STR_TO_DATE(p_e_wo_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND A.ACT_START_TIME <> IFNULL(A.ACT_END_TIME, NOW())
            AND A.EMP_CODE <> 'acitve'

        UNION ALL

        -- ========== IDLETIME (비가동, DATA_FLAG=2) ==========
        SELECT
            I.PLT_CODE
            ,I.IDLE_ID AS `KEY`
            ,'비가동' AS ACT_TYPE
            ,IC.IDLE_CODE AS ACT_CONTENTS
            ,IC.SAP_CODE
            ,IC.IDLE_NAME
            ,P.ORDER_NO
            ,P.ORDER_LINE
            ,P.PROD_HOGI
            ,SAP.CUSTOMER
            ,W.PLN_PROC_TIME AS PROC_ST
            ,I.EMP_CODE
            ,E.EMP_NAME
            ,DATE_FORMAT(I.START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME
            ,DATE_FORMAT(I.END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME
            ,TIMESTAMPDIFF(MINUTE, I.START_TIME, I.END_TIME) AS ACT_TIME
            ,DATE_FORMAT(W.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS WO_END_TIME
            ,W.SAP_WO_NO
            ,W.WO_SEQ
            ,W.PROC_CODE
            ,CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                  WHEN W.PLANTS = '3605' THEN I.MC_CODE END AS SAP_MC_CODE
            ,M.MC_NAME
            ,'' AS PRE_WORK
            ,CASE WHEN MD.PROD_TYPE = 'E' THEN '전동'
                  WHEN MD.PROD_TYPE = 'P' THEN '유압'
                  WHEN MD.PROD_TYPE IS NULL THEN '가공' END AS PROD_TYPE
            ,NULL AS PROC_STAT
            ,CASE WHEN W.PLANTS = '3603' THEN MD.MODEL_NO
                  WHEN W.PLANTS = '3605' THEN W.MODEL END AS MODEL
            ,SAPA.WORK_LOC
            ,SAPA.ORDER_CONF_VALUE
            ,SAPA.ORDER_CONF_COUNT
            ,SAPA.CONF_VALUE
            ,SAPA.CONF_COUNT
            ,SAPA.EAI_RESULT
            ,SAPA.EAI_SCOMMENT
            ,IFNULL(I.IF_SEL_FLAG,'0') AS IF_SEL_FLAG
        FROM TSHP_IDLETIME I
        LEFT JOIN TSHP_WORKORDER W
            ON I.PLT_CODE = W.PLT_CODE AND I.WO_NO = W.WO_NO
        LEFT JOIN TORD_PRODUCT P
            ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
        LEFT JOIN IF_SAP_SHIPINFO SAP
            ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
        LEFT JOIN TSTD_MODEL MD
            ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_NO = MD.MODEL_NO
            AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_TYPE = MD.MODEL_TYPE
        LEFT JOIN TSTD_EMPLOYEE E
            ON I.PLT_CODE = E.PLT_CODE AND I.EMP_CODE = E.EMP_CODE
        LEFT JOIN TSTD_IDLECODE IC
            ON I.PLT_CODE = IC.PLT_CODE AND I.IDLE_CODE = IC.IDLE_CODE
        LEFT JOIN LSE_MACHINE M
            ON I.PLT_CODE = M.PLT_CODE
            AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                     WHEN W.PLANTS = '3605' THEN I.MC_CODE END = M.MC_CODE
        LEFT JOIN (
            SELECT
                H.KEY_VALUE
                ,H.WORK_LOC
                ,A2.WORK_TIME
                ,A2.IDLE_CODE
                ,A2.IDLE_TIME
                ,H.CONF_VALUE AS ORDER_CONF_VALUE
                ,H.CONF_COUNT AS ORDER_CONF_COUNT
                ,A2.CONF_VALUE
                ,A2.CONF_COUNT
                ,H.EAI_RESULT
                ,H.EAI_SCOMMENT
            FROM IF_SAP_WO_HEADER H
            LEFT JOIN IF_SAP_WO_ACTUAL A2
                ON H.KEY_VALUE = A2.KEY_VALUE
            WHERE H.KEY_VALUE IS NOT NULL
        ) SAPA
            ON I.IDLE_ID = SAPA.KEY_VALUE
        WHERE I.PLT_CODE = p_plt_code
            AND (p_s_work_date = '' OR p_s_work_date IS NULL
                 OR (I.START_TIME >= STR_TO_DATE(p_s_work_date, '%Y%m%d')
                     AND I.START_TIME < DATE_ADD(STR_TO_DATE(p_e_work_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND (p_s_wo_date = '' OR p_s_wo_date IS NULL
                 OR (W.ACT_END_TIME >= STR_TO_DATE(p_s_wo_date, '%Y%m%d')
                     AND W.ACT_END_TIME < DATE_ADD(STR_TO_DATE(p_e_wo_date, '%Y%m%d'), INTERVAL 1 DAY)))
            AND I.START_TIME <> IFNULL(I.END_TIME, NOW())
            AND I.EMP_CODE <> 'active'
            AND I.DATA_FLAG = '2'
    ) A
    ORDER BY EMP_NAME, EMP_CODE, A.ACT_START_TIME, A.SAP_WO_NO;
END//

-- ============================================================
-- sp_imes_tshp_actual_query15_4: 실적/비가동 현황 조회 (ORD15A)
-- UNION ALL: TSHP_ACTUAL(실적) + TSHP_IDLETIME(비가동, DATA_FLAG=0)
-- 검색조건: 날짜구분(작업일/완료일), 판매오더, 호기, 거래처, 기계번호
-- 작성자: 송우석
-- 작성일: 2026-03-16
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query15_4//

CREATE PROCEDURE sp_imes_tshp_actual_query15_4(
    IN p_plt_code       VARCHAR(3),
    IN p_s_work_date    VARCHAR(8),
    IN p_e_work_date    VARCHAR(8),
    IN p_s_wo_date      VARCHAR(8),
    IN p_e_wo_date      VARCHAR(8),
    IN p_order_like     VARCHAR(50),
    IN p_hogi_like      VARCHAR(50),
    IN p_cvnd_like      VARCHAR(50),
    IN p_mc_no_like     VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE,
        `KEY`,
        ACT_TYPE,
        ACT_CONTENTS    AS actContents,
        SAP_CODE        AS sapCode,
        IDLE_NAME       AS idleName,
        ORDER_NO        AS orderNo,
        ORDER_LINE      AS orderLine,
        PROD_HOGI       AS prodHogi,
        CUSTOMER        AS customer,
        PROC_ST         AS procSt,
        READY_ST        AS readySt,
        EMP_CODE        AS empCode,
        EMP_NAME        AS empName,
        ACT_START_TIME  AS actStartTime,
        ACT_END_TIME    AS actEndTime,
        ACT_TIME        AS actTime,
        WO_END_TIME     AS woEndTime,
        SAP_WO_NO       AS sapWoNo,
        WO_SEQ          AS woSeq,
        PROC_CODE       AS procCode,
        SAP_MC_CODE     AS sapMcCode,
        MC_NAME         AS mcName,
        PRE_WORK        AS preWork,
        PROD_TYPE       AS prodType,
        PROC_STAT       AS procStat,
        NG_ID           AS ngId,
        MC_NO           AS mcNo,
        MODEL_TYPE      AS modelType,
        PART_CODE       AS partCode,
        MODEL_NO        AS modelNo
    FROM (
        -- Part 1: 실적 (TSHP_ACTUAL)
        SELECT
            A.PLT_CODE,
            A.ACTUAL_ID AS `KEY`,
            '실적' AS ACT_TYPE,
            '' AS ACT_CONTENTS,
            '' AS SAP_CODE,
            '' AS IDLE_NAME,
            P.ORDER_NO,
            P.ORDER_LINE,
            P.PROD_HOGI,
            SAP.CUSTOMER,
            W.PLN_PROC_TIME AS PROC_ST,
            W.PLN_PROC_RDY_TIME AS READY_ST,
            A.EMP_CODE,
            E.USER_NAME AS EMP_NAME,
            DATE_FORMAT(A.ACT_START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME,
            DATE_FORMAT(A.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME,
            TIMESTAMPDIFF(MINUTE, A.ACT_START_TIME, A.ACT_END_TIME) AS ACT_TIME,
            DATE_FORMAT(W.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS WO_END_TIME,
            W.SAP_WO_NO,
            W.WO_SEQ,
            W.PROC_CODE,
            CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                 WHEN W.PLANTS = '3605' THEN A.MC_CODE END AS SAP_MC_CODE,
            M.MC_NAME,
            CASE WHEN IFNULL(A.IS_PRE_WORK, 0) = '1' THEN '준비작업'
                 ELSE '' END AS PRE_WORK,
            CASE WHEN MD.PROD_TYPE = 'E' THEN '전동'
                 WHEN MD.PROD_TYPE = 'P' THEN '유압'
                 WHEN MD.PROD_TYPE IS NULL THEN '가공' END AS PROD_TYPE,
            A.PROC_STAT,
            NULL AS NG_ID,
            W.MC_NO,
            P.MODEL_TYPE,
            P.PART_CODE,
            P.MODEL_NO
        FROM TSHP_ACTUAL A
            LEFT JOIN TSHP_WORKORDER W
                ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
            LEFT JOIN TORD_PRODUCT P
                ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
            LEFT JOIN IF_SAP_SHIPINFO SAP
                ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
            LEFT JOIN TSTD_MODEL MD
                ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_NO = MD.MODEL_NO
                AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_TYPE = MD.MODEL_TYPE
            LEFT JOIN SYS_USER E
                ON E.SYS_ID = 'IMMES' AND A.EMP_CODE = E.USER_ID
            LEFT JOIN LSE_MACHINE M
                ON A.PLT_CODE = M.PLT_CODE
                AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                         WHEN W.PLANTS = '3605' THEN A.MC_CODE END = M.MC_CODE
        WHERE A.PLT_CODE = p_plt_code
            AND (p_s_work_date = '' OR p_s_work_date IS NULL
                 OR DATE_FORMAT(A.ACT_START_TIME, '%Y%m%d') BETWEEN p_s_work_date AND p_e_work_date)
            AND (p_s_wo_date = '' OR p_s_wo_date IS NULL
                 OR DATE_FORMAT(W.ACT_END_TIME, '%Y%m%d') BETWEEN p_s_wo_date AND p_e_wo_date)
            AND A.ACT_START_TIME <> CASE
                WHEN A.PROC_STAT = '4' AND A.ACT_START_TIME = A.ACT_END_TIME
                THEN DATE_ADD(IFNULL(A.ACT_END_TIME, NOW()), INTERVAL 1 SECOND)
                ELSE IFNULL(A.ACT_END_TIME, NOW()) END
            AND A.EMP_CODE <> 'acitve'
            AND (p_order_like = '' OR p_order_like IS NULL
                 OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
            AND (p_hogi_like = '' OR p_hogi_like IS NULL
                 OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
            AND (p_cvnd_like = '' OR p_cvnd_like IS NULL
                 OR SAP.CUSTOMER LIKE CONCAT('%', p_cvnd_like, '%'))
            AND (p_mc_no_like = '' OR p_mc_no_like IS NULL
                 OR P.PROD_CODE IN (
                    SELECT PROD_CODE FROM TSHP_WORKORDER
                    WHERE MC_NO LIKE CONCAT('%', p_mc_no_like, '%')
                    AND DATA_FLAG = '0' GROUP BY PROD_CODE))

        UNION ALL

        -- Part 2: 비가동 (TSHP_IDLETIME)
        SELECT
            I.PLT_CODE,
            I.IDLE_ID AS `KEY`,
            '비가동' AS ACT_TYPE,
            IC.IDLE_CODE AS ACT_CONTENTS,
            IC.SAP_CODE,
            IC.IDLE_NAME,
            P.ORDER_NO,
            P.ORDER_LINE,
            P.PROD_HOGI,
            SAP.CUSTOMER,
            W.PLN_PROC_TIME AS PROC_ST,
            W.PLN_PROC_RDY_TIME AS READY_ST,
            I.EMP_CODE,
            E.USER_NAME AS EMP_NAME,
            DATE_FORMAT(I.START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME,
            DATE_FORMAT(I.END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME,
            TIMESTAMPDIFF(MINUTE, I.START_TIME, I.END_TIME) AS ACT_TIME,
            DATE_FORMAT(W.ACT_END_TIME, '%Y-%m-%d %H:%i:%s') AS WO_END_TIME,
            W.SAP_WO_NO,
            W.WO_SEQ,
            W.PROC_CODE,
            CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                 WHEN W.PLANTS = '3605' THEN I.MC_CODE END AS SAP_MC_CODE,
            M.MC_NAME,
            '' AS PRE_WORK,
            CASE WHEN MD.PROD_TYPE = 'E' THEN '전동'
                 WHEN MD.PROD_TYPE = 'P' THEN '유압'
                 WHEN MD.PROD_TYPE IS NULL THEN '가공' END AS PROD_TYPE,
            NULL AS PROC_STAT,
            I.NG_ID,
            W.MC_NO,
            P.MODEL_TYPE,
            P.PART_CODE,
            P.MODEL_NO
        FROM TSHP_IDLETIME I
            LEFT JOIN TSHP_WORKORDER W
                ON I.PLT_CODE = W.PLT_CODE AND I.WO_NO = W.WO_NO
            LEFT JOIN TORD_PRODUCT P
                ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
            LEFT JOIN IF_SAP_SHIPINFO SAP
                ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE
            LEFT JOIN TSTD_MODEL MD
                ON P.PLT_CODE = MD.PLT_CODE AND P.MODEL_NO = MD.MODEL_NO
                AND P.MODEL_SERISE = MD.MODEL_SERISE AND P.MODEL_TYPE = MD.MODEL_TYPE
            LEFT JOIN SYS_USER E
                ON E.SYS_ID = 'IMMES' AND I.EMP_CODE = E.USER_ID
            LEFT JOIN TSTD_IDLECODE IC
                ON I.PLT_CODE = IC.PLT_CODE AND I.IDLE_CODE = IC.IDLE_CODE
            LEFT JOIN LSE_MACHINE M
                ON I.PLT_CODE = M.PLT_CODE
                AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                         WHEN W.PLANTS = '3605' THEN I.MC_CODE END = M.MC_CODE
        WHERE I.PLT_CODE = p_plt_code
            AND (p_s_work_date = '' OR p_s_work_date IS NULL
                 OR DATE_FORMAT(I.START_TIME, '%Y%m%d') BETWEEN p_s_work_date AND p_e_work_date)
            AND (p_s_wo_date = '' OR p_s_wo_date IS NULL
                 OR DATE_FORMAT(W.ACT_END_TIME, '%Y%m%d') BETWEEN p_s_wo_date AND p_e_wo_date)
            AND I.START_TIME <> IFNULL(I.END_TIME, NOW())
            AND I.EMP_CODE <> 'active'
            AND I.DATA_FLAG = 0
            AND (p_order_like = '' OR p_order_like IS NULL
                 OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
            AND (p_hogi_like = '' OR p_hogi_like IS NULL
                 OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
            AND (p_cvnd_like = '' OR p_cvnd_like IS NULL
                 OR SAP.CUSTOMER LIKE CONCAT('%', p_cvnd_like, '%'))
            AND (p_mc_no_like = '' OR p_mc_no_like IS NULL
                 OR P.PROD_CODE IN (
                    SELECT PROD_CODE FROM TSHP_WORKORDER
                    WHERE MC_NO LIKE CONCAT('%', p_mc_no_like, '%')
                    AND DATA_FLAG = '0' GROUP BY PROD_CODE))
    ) A
    ORDER BY EMP_NAME, EMP_CODE, A.ACT_START_TIME, A.SAP_WO_NO;
END//

DELIMITER ;
