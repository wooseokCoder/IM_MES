-- ============================================================
-- TSHP_ACTUAL_QUERY 프로시저 (POP 모듈)
-- 생성일: 2026-03-05
-- 대상 테이블: TSHP_ACTUAL, TSHP_IDLETIME (조회용)
-- 원본: ProActive TSHP_ACTUAL_QUERY.cs
-- 화면: POP33A (공수오류현황)
-- ============================================================
-- 포함 프로시저 (3개):
--   1. sp_imes_tshp_actual_query22     - Grid1: 일별 공수 집계
--   2. sp_imes_tshp_actual_query15_1   - Grid2: 실적현황
--   3. sp_imes_tshp_actual_query15_2   - Grid3: 삭제현황
-- ============================================================

-- SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_actual_query22: 일별 공수 집계 (Grid1)
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY22()
-- 용도: POP33A Grid1 - 작업자별/일별 공수 집계 조회
-- 로직:
--   - TSHP_ACTUAL + TSHP_IDLETIME(IS_SAP='1', DATA_FLAG='0') UNION ALL
--   - LEFT JOIN: IF_SAP_ACTUAL(SAP근무시간), SYS_USER(작업자명),
--     IF_SAP_WO_ACTUAL(SAP실적시간), TSHP_WORK_EXCEPT(예외처리여부)
--   - SAP_RATE 계산: 1.0 - (MES시간 / SAP근무시간)
--   - 'acitve' 필터 유지 (AS-IS 데이터 호환성)
-- 변환:
--   CONVERT(VARCHAR(8), dt, 112) → DATE_FORMAT(dt, '%Y%m%d')
--   DATEDIFF(MINUTE, a, b) → TIMESTAMPDIFF(MINUTE, a, b)
--   ISNULL → IFNULL, GETDATE() → NOW()
--   CONVERT(DECIMAL) → CAST(... AS DECIMAL)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query22//

CREATE PROCEDURE sp_imes_tshp_actual_query22(
    IN p_plt_code    VARCHAR(10),    /* 공장코드 */
    IN p_s_work_date VARCHAR(8),     /* 시작일자 (yyyyMMdd) */
    IN p_e_work_date VARCHAR(8),     /* 종료일자 (yyyyMMdd) */
    IN p_emp_like    VARCHAR(50),    /* 작업자 검색 (사번/이름 LIKE) */
    IN p_emp_gubun2  VARCHAR(10)     /* 작업자 구분2 */
)
BEGIN
    SELECT
        ACT.PLT_CODE                                                                     AS "pltCode"
       ,E.EMP_GUBUN2                                                                     AS "empGubun2"
       ,ACT.WORK_DATE                                                                    AS "workDateKey"
       ,ACT.WORK_DATE                                                                    AS "workDate"
       ,ACT.EMP_CODE                                                                     AS "empCode"
       ,E.USER_NAME                                                                      AS "empName"
       ,SUM(ACT.ACT_TIME)                                                                AS "actTime"
       /* SAP_TIME: 0이면 ACT_TIME으로 대체 (AS-IS 서비스 로직 → SP 이관) */
       ,CASE WHEN SUM(ACT.SAP_TIME) = 0 THEN SUM(ACT.ACT_TIME)
             ELSE SUM(ACT.SAP_TIME) END                                                     AS "sapTime"
       ,SAP.SAP_WORK_TIME                                                                AS "sapWorkTime"
       /* SAP_RATE: 1.0 - (MES실적시간 / SAP근무시간), 0이면 0.0 */
       ,CASE WHEN SAP.SAP_WORK_TIME = 0
                  AND CASE WHEN SUM(ACT.SAP_TIME) = 0
                           THEN CAST(SUM(ACT.ACT_TIME) AS DECIMAL(18,4))
                           ELSE CAST(SUM(ACT.SAP_TIME) AS DECIMAL(18,4))
                      END = 0
             THEN 0.0
             ELSE CAST(1.0 - CASE WHEN SAP.SAP_WORK_TIME = 0 THEN 0.0
                                  ELSE CASE WHEN SUM(ACT.SAP_TIME) = 0
                                            THEN CAST(SUM(ACT.ACT_TIME) AS DECIMAL(18,4))
                                            ELSE CAST(SUM(ACT.SAP_TIME) AS DECIMAL(18,4))
                                       END / CAST(SAP.SAP_WORK_TIME AS DECIMAL(18,4))
                             END AS DECIMAL(18,4))
        END                                                                              AS "sapRate"
       ,SACT.SAP_ACT_TIME                                                                AS "sapActTime"
       ,IFNULL(X.IS_EXCEPT, '0')                                                        AS "isExcept"
    FROM
    (
        /* TSHP_ACTUAL: 공정 실적 집계 */
        SELECT
            PLT_CODE
           ,DATE_FORMAT(ACT_START_TIME, '%Y%m%d') AS WORK_DATE
           ,EMP_CODE
           ,SUM(TIMESTAMPDIFF(MINUTE, ACT_START_TIME, ACT_END_TIME)) AS ACT_TIME
           ,SUM(CASE WHEN IFNULL(IF_SEL_FLAG, '0') = '1' OR IFNULL(IF_SEL_FLAG, '0') = '2'
                     THEN TIMESTAMPDIFF(MINUTE, ACT_START_TIME, ACT_END_TIME)
                     ELSE 0 END) AS SAP_TIME
        FROM TSHP_ACTUAL
        /* 튜닝: DATE_FORMAT → datetime 범위 비교 (인덱스 활용) + PLT_CODE/EMP_CODE Push Down */
        WHERE PLT_CODE = p_plt_code
          AND EMP_CODE <> 'acitve'
          AND ACT_START_TIME >= STR_TO_DATE(p_s_work_date, '%Y%m%d')
          AND ACT_START_TIME < DATE_ADD(STR_TO_DATE(p_e_work_date, '%Y%m%d'), INTERVAL 1 DAY)
        GROUP BY PLT_CODE
                ,DATE_FORMAT(ACT_START_TIME, '%Y%m%d')
                ,EMP_CODE

        UNION ALL

        /* TSHP_IDLETIME: 비가동 실적 집계 (SAP 연동 대상만) */
        SELECT
            I.PLT_CODE
           ,DATE_FORMAT(I.START_TIME, '%Y%m%d') AS WORK_DATE
           ,I.EMP_CODE
           ,SUM(TIMESTAMPDIFF(MINUTE, I.START_TIME, I.END_TIME)) AS ACT_TIME
           ,SUM(CASE WHEN IFNULL(IF_SEL_FLAG, '0') = '1' OR IFNULL(IF_SEL_FLAG, '0') = '2'
                     THEN IDLE_TIME
                     ELSE 0 END) AS SAP_TIME
        FROM TSHP_IDLETIME I
        LEFT JOIN TSTD_IDLECODE IC
            ON I.PLT_CODE = IC.PLT_CODE
            AND I.IDLE_CODE = IC.IDLE_CODE
        /* 튜닝: DATE_FORMAT → datetime 범위 비교 (인덱스 활용) + PLT_CODE Push Down */
        WHERE I.PLT_CODE = p_plt_code
          AND I.EMP_CODE <> 'acitve'
          AND I.START_TIME >= STR_TO_DATE(p_s_work_date, '%Y%m%d')
          AND I.START_TIME < DATE_ADD(STR_TO_DATE(p_e_work_date, '%Y%m%d'), INTERVAL 1 DAY)
          AND IFNULL(IC.IS_SAP,'0') = '1'
          AND I.DATA_FLAG = '0'
        GROUP BY I.PLT_CODE
                ,DATE_FORMAT(START_TIME, '%Y%m%d')
                ,EMP_CODE
    ) ACT
    /* IF_SAP_ACTUAL: SAP 근무시간 (정규+연장+휴일-휴일시간) * 60분 */
    LEFT JOIN (
        SELECT ACT_START_DATE
              ,EMP_CODE
              ,(CAST(ACT_TIME AS DECIMAL(18,2))
                + CAST(OT_TIME AS DECIMAL(18,2))
                + CAST(HOLI_ACT_TIME AS DECIMAL(18,2))
                - CAST(HOLI_TIME AS DECIMAL(18,2))) * 60 AS SAP_WORK_TIME
        FROM IF_SAP_ACTUAL
        /* 튜닝: 날짜 필터 추가 (311K 전체 스캔 → 범위 스캔) */
        WHERE ACT_START_DATE BETWEEN p_s_work_date AND p_e_work_date
    ) SAP
        ON ACT.EMP_CODE = SAP.EMP_CODE
        AND ACT.WORK_DATE = SAP.ACT_START_DATE
    /* SYS_USER: 작업자명, 구분 */
    LEFT JOIN SYS_USER E
        ON ACT.PLT_CODE = E.PLT_CODE
        AND ACT.EMP_CODE = E.USER_ID
    /* IF_SAP_WO_ACTUAL: SAP WO 실적시간 합계 */
    LEFT JOIN (
        SELECT EMP_CODE
              ,WO_DATE
              ,SUM(CAST(WORK_TIME AS DECIMAL(18,4))) + SUM(CAST(IDLE_TIME AS DECIMAL(18,4))) AS SAP_ACT_TIME
        FROM IF_SAP_WO_ACTUAL
        /* 튜닝: 날짜 필터 추가 (539K 전체 스캔 → 범위 스캔) */
        WHERE WO_DATE BETWEEN p_s_work_date AND p_e_work_date
        GROUP BY EMP_CODE, WO_DATE
    ) SACT
        ON ACT.EMP_CODE = SACT.EMP_CODE
        AND SAP.ACT_START_DATE = SACT.WO_DATE
    /* TSHP_WORK_EXCEPT: 예외 처리 여부 */
    LEFT JOIN TSHP_WORK_EXCEPT X
        ON ACT.PLT_CODE = X.PLT_CODE
        AND ACT.WORK_DATE = X.WORK_DATE
        AND ACT.EMP_CODE = X.EMP_CODE
    WHERE ACT.PLT_CODE = p_plt_code
      AND (p_emp_like IS NULL OR p_emp_like = ''
           OR (ACT.EMP_CODE LIKE CONCAT('%', p_emp_like, '%')
               OR E.USER_NAME LIKE CONCAT('%', p_emp_like, '%')))
      AND (p_emp_gubun2 IS NULL OR p_emp_gubun2 = '' OR E.EMP_GUBUN2 = p_emp_gubun2)
      AND ACT.EMP_CODE <> 'acitve'                      /* AS-IS 오타 유지 (데이터 호환) */
    GROUP BY ACT.PLT_CODE, E.EMP_GUBUN2, ACT.WORK_DATE, ACT.EMP_CODE, E.USER_NAME
            ,SACT.SAP_ACT_TIME, SAP.SAP_WORK_TIME, X.IS_EXCEPT
    ORDER BY E.USER_NAME, ACT.EMP_CODE, ACT.WORK_DATE;
END//


-- ============================================================
-- 2. sp_imes_tshp_actual_query15_1: 실적현황 (Grid2)
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY15_1()
-- 용도: POP33A Grid2 - 특정 작업자/일자의 실적 상세 조회
-- 로직:
--   - TSHP_ACTUAL(실적) UNION ALL TSHP_IDLETIME(비가동, IS_SAP='1', DATA_FLAG='0')
--   - 9개 LEFT JOIN: WORKORDER, PRODUCT, SHIPINFO, MODEL, EMPLOYEE,
--     IDLECODE, MACHINE, SAP_WO_HEADER+ACTUAL
--   - ACT_START_TIME <> ACT_END_TIME (시작=종료 제외)
--   - 'acitve'/'active' 필터 (AS-IS 오타 패턴 유지)
-- 변환: DATEDIFF→TIMESTAMPDIFF, ISNULL→IFNULL, WITH(NOLOCK)→제거
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query15_1//

CREATE PROCEDURE sp_imes_tshp_actual_query15_1(
    IN p_plt_code VARCHAR(10),    /* 공장코드 */
    IN p_emp_code VARCHAR(20),    /* 작업자코드 */
    IN p_work_date VARCHAR(8)     /* 작업일자 (yyyyMMdd) */
)
BEGIN
    SELECT
        PLT_CODE                                    AS "pltCode"
       ,`KEY`                                       AS "key"
       ,ACT_TYPE                                    AS "actType"
       ,ACT_CONTENTS                                AS "actContents"
       ,SAP_CODE                                    AS "sapCode"
       ,IDLE_NAME                                   AS "idleName"
       ,ORDER_NO                                    AS "orderNo"
       ,ORDER_LINE                                  AS "orderLine"
       ,PROD_HOGI                                   AS "prodHogi"
       ,CUSTOMER                                    AS "customer"
       ,PROC_ST                                     AS "procSt"
       ,EMP_CODE                                    AS "empCode"
       ,USER_NAME                                   AS "empName"
       ,ACT_START_TIME                              AS "actStartTime"
       ,ACT_END_TIME                                AS "actEndTime"
       ,ACT_TIME                                    AS "actTime"
       ,WO_END_TIME                                 AS "woEndTime"
       ,SAP_WO_NO                                   AS "sapWoNo"
       ,WO_SEQ                                      AS "woSeq"
       ,PROC_CODE                                   AS "procCode"
       ,SAP_MC_CODE                                 AS "sapMcCode"
       ,PRE_WORK                                    AS "preWork"
       ,PROD_TYPE                                   AS "prodType"
       ,PROC_STAT                                   AS "procStat"
       ,MC_NAME                                     AS "mcName"
       ,MODEL                                       AS "model"
       ,WORK_LOC                                    AS "workLoc"
       ,ORDER_CONF_VALUE                            AS "orderConfValue"
       ,ORDER_CONF_COUNT                            AS "orderConfCount"
       ,CONF_VALUE                                  AS "confValue"
       ,CONF_COUNT                                  AS "confCount"
       ,EAI_RESULT                                  AS "eaiResult"
       ,EAI_SCOMMENT                                AS "eaiScomment"
       ,IFNULL(IF_SEL_FLAG,'0')                     AS "ifSelFlag"
       /* ifSelFlagNm: A003 코드 변환 (0=대기, 1=저장, 2=전송) */
       ,CASE WHEN IFNULL(IF_SEL_FLAG,'0') = '0' THEN '대기'
             WHEN IF_SEL_FLAG = '1' THEN '저장'
             WHEN IF_SEL_FLAG = '2' THEN '전송'
             ELSE IF_SEL_FLAG END                       AS "ifSelFlagNm"
       /* SEL: IF_SEL_FLAG='1'or'2'이면 '1', 전체 0건이면 전부 '1' (AS-IS 서비스 로직 → SP 이관) */
       ,CASE WHEN IFNULL(IF_SEL_FLAG,'0') IN ('1','2') THEN '1'
             WHEN SUM(CASE WHEN IFNULL(IF_SEL_FLAG,'0') IN ('1','2') THEN 1 ELSE 0 END) OVER() = 0 THEN '1'
             ELSE '' END                                AS "sel"
    FROM
    (
        /* ===== 실적 파트: TSHP_ACTUAL ===== */
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
           ,E.USER_NAME
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
            ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.USER_ID
        LEFT JOIN (
            SELECT
                H.KEY_VALUE
               ,H.WORK_LOC
               ,A.WORK_TIME
               ,A.IDLE_CODE
               ,A.IDLE_TIME
               ,H.CONF_VALUE AS ORDER_CONF_VALUE
               ,H.CONF_COUNT AS ORDER_CONF_COUNT
               ,A.CONF_VALUE
               ,A.CONF_COUNT
               ,H.EAI_RESULT
               ,H.EAI_SCOMMENT
            FROM IF_SAP_WO_HEADER H
            LEFT JOIN IF_SAP_WO_ACTUAL A ON H.KEY_VALUE = A.KEY_VALUE
            WHERE H.KEY_VALUE IS NOT NULL
        ) SAPA
            ON A.ACTUAL_ID = SAPA.KEY_VALUE
        LEFT JOIN LSE_MACHINE M
            ON A.PLT_CODE = M.PLT_CODE
            AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                     WHEN W.PLANTS = '3605' THEN A.MC_CODE END = M.MC_CODE
        WHERE A.PLT_CODE = p_plt_code
          AND A.ACT_START_TIME <> IFNULL(A.ACT_END_TIME, NOW())
          AND A.EMP_CODE <> 'acitve'            /* AS-IS 오타 유지 (데이터 호환) */
          AND A.EMP_CODE = p_emp_code
          /* 튜닝: DATE_FORMAT → datetime 범위 비교 (인덱스 활용) */
          AND A.ACT_START_TIME >= STR_TO_DATE(p_work_date, '%Y%m%d')
          AND A.ACT_START_TIME < DATE_ADD(STR_TO_DATE(p_work_date, '%Y%m%d'), INTERVAL 1 DAY)

        UNION ALL

        /* ===== 비가동 파트: TSHP_IDLETIME (IS_SAP='1', DATA_FLAG='0') ===== */
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
           ,E.USER_NAME
           ,DATE_FORMAT(START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME
           ,DATE_FORMAT(END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME
           ,TIMESTAMPDIFF(MINUTE, START_TIME, END_TIME) AS ACT_TIME
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
        LEFT JOIN SYS_USER E
            ON I.PLT_CODE = E.PLT_CODE AND I.EMP_CODE = E.USER_ID
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
               ,A.WORK_TIME
               ,A.IDLE_CODE
               ,A.IDLE_TIME
               ,H.CONF_VALUE AS ORDER_CONF_VALUE
               ,H.CONF_COUNT AS ORDER_CONF_COUNT
               ,A.CONF_VALUE
               ,A.CONF_COUNT
               ,H.EAI_RESULT
               ,H.EAI_SCOMMENT
            FROM IF_SAP_WO_HEADER H
            LEFT JOIN IF_SAP_WO_ACTUAL A ON H.KEY_VALUE = A.KEY_VALUE
            WHERE H.KEY_VALUE IS NOT NULL
        ) SAPA
            ON I.IDLE_ID = SAPA.KEY_VALUE
        WHERE I.PLT_CODE = p_plt_code
          AND I.START_TIME <> IFNULL(I.END_TIME, NOW())
          AND I.EMP_CODE <> 'active'            /* AS-IS 원본: 'active' (query15_1의 비가동 파트) */
          AND I.EMP_CODE = p_emp_code
          /* 튜닝: DATE_FORMAT → datetime 범위 비교 (인덱스 활용) */
          AND I.START_TIME >= STR_TO_DATE(p_work_date, '%Y%m%d')
          AND I.START_TIME < DATE_ADD(STR_TO_DATE(p_work_date, '%Y%m%d'), INTERVAL 1 DAY)
          AND IC.IS_SAP = '1'
          AND I.DATA_FLAG = '0'
    ) A
    ORDER BY USER_NAME, EMP_CODE, A.ACT_START_TIME, A.SAP_WO_NO;
END//


-- ============================================================
-- 3. sp_imes_tshp_actual_query15_2: 삭제현황 (Grid3)
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY15_2()
-- 용도: POP33A Grid3 - 삭제된 실적/비가동 상세 조회
-- 차이점 (query15_1 대비):
--   - ACTUAL 파트: TSHP_ACTUAL_DEL 테이블 사용
--   - IDLETIME 파트: DATA_FLAG = '2' (삭제된 비가동)
--   - EMP_CODE 필터: 'acitve' (ACTUAL, IDLETIME 동일 오타)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query15_2//

CREATE PROCEDURE sp_imes_tshp_actual_query15_2(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_work_date VARCHAR(8)      /* 작업일자 (yyyyMMdd) */
)
BEGIN
    SELECT
        PLT_CODE                                    AS "pltCode"
       ,`KEY`                                       AS "key"
       ,ACT_TYPE                                    AS "actType"
       ,ACT_CONTENTS                                AS "actContents"
       ,SAP_CODE                                    AS "sapCode"
       ,IDLE_NAME                                   AS "idleName"
       ,ORDER_NO                                    AS "orderNo"
       ,ORDER_LINE                                  AS "orderLine"
       ,PROD_HOGI                                   AS "prodHogi"
       ,CUSTOMER                                    AS "customer"
       ,PROC_ST                                     AS "procSt"
       ,EMP_CODE                                    AS "empCode"
       ,USER_NAME                                   AS "empName"
       ,ACT_START_TIME                              AS "actStartTime"
       ,ACT_END_TIME                                AS "actEndTime"
       ,ACT_TIME                                    AS "actTime"
       ,WO_END_TIME                                 AS "woEndTime"
       ,SAP_WO_NO                                   AS "sapWoNo"
       ,WO_SEQ                                      AS "woSeq"
       ,PROC_CODE                                   AS "procCode"
       ,SAP_MC_CODE                                 AS "sapMcCode"
       ,PRE_WORK                                    AS "preWork"
       ,PROD_TYPE                                   AS "prodType"
       ,PROC_STAT                                   AS "procStat"
       ,MC_NAME                                     AS "mcName"
       ,MODEL                                       AS "model"
       ,WORK_LOC                                    AS "workLoc"
       ,ORDER_CONF_VALUE                            AS "orderConfValue"
       ,ORDER_CONF_COUNT                            AS "orderConfCount"
       ,CONF_VALUE                                  AS "confValue"
       ,CONF_COUNT                                  AS "confCount"
       ,EAI_RESULT                                  AS "eaiResult"
       ,EAI_SCOMMENT                                AS "eaiScomment"
       ,IFNULL(IF_SEL_FLAG,'0')                     AS "ifSelFlag"
       /* ifSelFlagNm: A003 코드 변환 (0=대기, 1=저장, 2=전송) */
       ,CASE WHEN IFNULL(IF_SEL_FLAG,'0') = '0' THEN '대기'
             WHEN IF_SEL_FLAG = '1' THEN '저장'
             WHEN IF_SEL_FLAG = '2' THEN '전송'
             ELSE IF_SEL_FLAG END                       AS "ifSelFlagNm"
       ,'' AS "sel"  /* 삭제현황은 SEL 항상 빈값 (AS-IS 서비스 로직 → SP 이관) */
    FROM
    (
        /* ===== 삭제 실적 파트: TSHP_ACTUAL_DEL ===== */
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
           ,E.USER_NAME
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
        FROM TSHP_ACTUAL_DEL A                       /* 삭제 실적 테이블 */
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
            ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.USER_ID
        LEFT JOIN (
            SELECT
                H.KEY_VALUE
               ,H.WORK_LOC
               ,A.WORK_TIME
               ,A.IDLE_CODE
               ,A.IDLE_TIME
               ,H.CONF_VALUE AS ORDER_CONF_VALUE
               ,H.CONF_COUNT AS ORDER_CONF_COUNT
               ,A.CONF_VALUE
               ,A.CONF_COUNT
               ,H.EAI_RESULT
               ,H.EAI_SCOMMENT
            FROM IF_SAP_WO_HEADER H
            LEFT JOIN IF_SAP_WO_ACTUAL A ON H.KEY_VALUE = A.KEY_VALUE
            WHERE H.KEY_VALUE IS NOT NULL
        ) SAPA
            ON A.ACTUAL_ID = SAPA.KEY_VALUE
        LEFT JOIN LSE_MACHINE M
            ON A.PLT_CODE = M.PLT_CODE
            AND CASE WHEN W.PLANTS = '3603' THEN W.SAP_MC_CODE
                     WHEN W.PLANTS = '3605' THEN A.MC_CODE END = M.MC_CODE
        WHERE A.PLT_CODE = p_plt_code
          AND A.ACT_START_TIME <> IFNULL(A.ACT_END_TIME, NOW())
          AND A.EMP_CODE <> 'acitve'            /* AS-IS 오타 유지 (데이터 호환) */
          AND A.EMP_CODE = p_emp_code
          /* 튜닝: DATE_FORMAT → datetime 범위 비교 (인덱스 활용) */
          AND A.ACT_START_TIME >= STR_TO_DATE(p_work_date, '%Y%m%d')
          AND A.ACT_START_TIME < DATE_ADD(STR_TO_DATE(p_work_date, '%Y%m%d'), INTERVAL 1 DAY)

        UNION ALL

        /* ===== 삭제 비가동 파트: TSHP_IDLETIME (DATA_FLAG='2') ===== */
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
           ,E.USER_NAME
           ,DATE_FORMAT(START_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_START_TIME
           ,DATE_FORMAT(END_TIME, '%Y-%m-%d %H:%i:%s') AS ACT_END_TIME
           ,TIMESTAMPDIFF(MINUTE, START_TIME, END_TIME) AS ACT_TIME
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
        LEFT JOIN SYS_USER E
            ON I.PLT_CODE = E.PLT_CODE AND I.EMP_CODE = E.USER_ID
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
               ,A.WORK_TIME
               ,A.IDLE_CODE
               ,A.IDLE_TIME
               ,H.CONF_VALUE AS ORDER_CONF_VALUE
               ,H.CONF_COUNT AS ORDER_CONF_COUNT
               ,A.CONF_VALUE
               ,A.CONF_COUNT
               ,H.EAI_RESULT
               ,H.EAI_SCOMMENT
            FROM IF_SAP_WO_HEADER H
            LEFT JOIN IF_SAP_WO_ACTUAL A ON H.KEY_VALUE = A.KEY_VALUE
            WHERE H.KEY_VALUE IS NOT NULL
        ) SAPA
            ON I.IDLE_ID = SAPA.KEY_VALUE
        WHERE I.PLT_CODE = p_plt_code
          AND I.START_TIME <> IFNULL(I.END_TIME, NOW())
          AND I.EMP_CODE <> 'active'            /* AS-IS 원본: 'active' (query15_2의 비가동 파트도 동일) */
          AND I.EMP_CODE = p_emp_code
          /* 튜닝: DATE_FORMAT → datetime 범위 비교 (인덱스 활용) */
          AND I.START_TIME >= STR_TO_DATE(p_work_date, '%Y%m%d')
          AND I.START_TIME < DATE_ADD(STR_TO_DATE(p_work_date, '%Y%m%d'), INTERVAL 1 DAY)
          AND IC.IS_SAP = '1'
          AND I.DATA_FLAG = '2'                 /* 삭제된 비가동만 */
    ) A
    ORDER BY USER_NAME, EMP_CODE, A.ACT_START_TIME, A.SAP_WO_NO;
END//


-- ============================================================
-- 4. sp_imes_tshp_actual_query40: 진행 중 실적 조회
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY40()
-- 용도: POP30B - 진행 중인 실적 조회 (ACT_END_TIME IS NULL)
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query40//

CREATE PROCEDURE sp_imes_tshp_actual_query40(
    IN p_plt_code  VARCHAR(10),    /* 공장코드 */
    IN p_wo_no     VARCHAR(20),    /* 작업오더번호 */
    IN p_emp_code  VARCHAR(20),    /* 작업자코드 */
    IN p_mc_code   VARCHAR(20),    /* 설비코드 */
    IN p_proc_stat VARCHAR(5)      /* 공정상태 */
)
BEGIN
    SELECT
        PLT_CODE                                                AS "pltCode"
       ,ACTUAL_ID                                               AS "actualId"
       ,WO_NO                                                   AS "woNo"
       ,PROC_STAT                                               AS "procStat"
       ,INPUT_FLAG                                              AS "inputFlag"
       ,DATE_FORMAT(ACT_START_TIME, '%Y-%m-%d %H:%i:%s')        AS "actStartTime"
       ,DATE_FORMAT(ACT_END_TIME, '%Y-%m-%d %H:%i:%s')          AS "actEndTime"
    FROM TSHP_ACTUAL
    WHERE PLT_CODE = p_plt_code
      AND (p_wo_no IS NULL OR p_wo_no = '' OR WO_NO = p_wo_no)
      AND (p_emp_code IS NULL OR p_emp_code = '' OR EMP_CODE = p_emp_code)
      AND (p_mc_code IS NULL OR p_mc_code = '' OR MC_CODE = p_mc_code)
      AND (p_proc_stat IS NULL OR p_proc_stat = '' OR PROC_STAT = p_proc_stat)
      AND ACT_END_TIME IS NULL;
END//


-- ============================================================
-- 5. sp_imes_tshp_actual_query41_2: 실적+비가동 통합 조회
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY41_2()
-- 용도: POP30B - 실적과 비가동을 UNION ALL로 통합 조회
-- 로직:
--   - TSHP_ACTUAL(실적) UNION ALL TSHP_IDLETIME(비가동, DATA_FLAG='0')
--   - LEFT JOIN: WORKORDER, EMPLOYEE, STD_PART, IDLECODE
--   - actStartTime ASC 정렬
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query41_2//

CREATE PROCEDURE sp_imes_tshp_actual_query41_2(
    IN p_plt_code    VARCHAR(10),    /* 공장코드 */
    IN p_s_work_date VARCHAR(8),     /* 시작일자 (yyyyMMdd) */
    IN p_e_work_date VARCHAR(8),     /* 종료일자 (yyyyMMdd) */
    IN p_emp_code    VARCHAR(20),    /* 작업자코드 */
    IN p_mc_code     VARCHAR(20)     /* 설비코드 */
)
BEGIN
    SELECT * FROM (
        /* ===== 실적 파트: TSHP_ACTUAL ===== */
        SELECT
            A.PLT_CODE                                                  AS "pltCode"
           ,'실적'                                                      AS "actType"
           ,CASE WHEN A.PANEL_STAT = '0' THEN '계획'
                 WHEN A.PANEL_STAT = '1' THEN '재작업'
                 ELSE '' END                                            AS "actContents"
           ,CASE WHEN A.IS_PRE_WORK = '1' THEN '작업준비'
                 ELSE '' END                                            AS "preWork"
           ,W.MC_CODE                                                   AS "mcCode"
           ,W.MODEL                                                     AS "model"
           ,SP.PART_NAME                                                AS "partName"
           ,W.PART_CODE                                                 AS "partCode"
           ,W.PROC_CODE                                                 AS "procCode"
           ,A.EMP_CODE                                                  AS "empCode"
           ,E.EMP_NAME                                                  AS "empName"
           ,DATE_FORMAT(A.ACT_START_TIME, '%Y-%m-%d %H:%i:%s')         AS "actStartTime"
           ,DATE_FORMAT(A.ACT_END_TIME, '%Y-%m-%d %H:%i:%s')           AS "actEndTime"
           ,TIMESTAMPDIFF(MINUTE, A.ACT_START_TIME, A.ACT_END_TIME)    AS "actTime"
        FROM TSHP_ACTUAL A
        LEFT JOIN TSHP_WORKORDER W
            ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
        LEFT JOIN TSTD_EMPLOYEE E
            ON A.PLT_CODE = E.PLT_CODE AND A.EMP_CODE = E.EMP_CODE
        LEFT JOIN LSE_STD_PART SP
            ON W.PLT_CODE = SP.PLT_CODE AND W.PART_CODE = SP.PART_CODE
        WHERE A.PLT_CODE = p_plt_code
          AND A.WORK_DATE BETWEEN p_s_work_date AND p_e_work_date
          AND (p_emp_code IS NULL OR p_emp_code = '' OR A.EMP_CODE = p_emp_code)
          AND (p_mc_code IS NULL OR p_mc_code = '' OR A.MC_CODE = p_mc_code)

        UNION ALL

        /* ===== 비가동 파트: TSHP_IDLETIME (DATA_FLAG='0') ===== */
        SELECT
            I.PLT_CODE                                                  AS "pltCode"
           ,'비가동'                                                    AS "actType"
           ,IC.IDLE_NAME                                                AS "actContents"
           ,''                                                          AS "preWork"
           ,I.MC_CODE                                                   AS "mcCode"
           ,''                                                          AS "model"
           ,''                                                          AS "partName"
           ,''                                                          AS "partCode"
           ,''                                                          AS "procCode"
           ,I.EMP_CODE                                                  AS "empCode"
           ,E2.EMP_NAME                                                 AS "empName"
           ,DATE_FORMAT(I.START_TIME, '%Y-%m-%d %H:%i:%s')             AS "actStartTime"
           ,DATE_FORMAT(I.END_TIME, '%Y-%m-%d %H:%i:%s')               AS "actEndTime"
           ,TIMESTAMPDIFF(MINUTE, I.START_TIME, I.END_TIME)            AS "actTime"
        FROM TSHP_IDLETIME I
        LEFT JOIN TSTD_IDLECODE IC
            ON I.PLT_CODE = IC.PLT_CODE AND I.IDLE_CODE = IC.IDLE_CODE
        LEFT JOIN TSTD_EMPLOYEE E2
            ON I.PLT_CODE = E2.PLT_CODE AND I.EMP_CODE = E2.EMP_CODE
        WHERE I.PLT_CODE = p_plt_code
          AND I.DATA_FLAG = '0'
          AND I.WORK_DATE BETWEEN p_s_work_date AND p_e_work_date
          AND (p_emp_code IS NULL OR p_emp_code = '' OR I.EMP_CODE = p_emp_code)
          AND (p_mc_code IS NULL OR p_mc_code = '' OR I.MC_CODE = p_mc_code)
    ) A
    ORDER BY A.actStartTime ASC;
END//


-- ============================================================
-- 6. sp_imes_tshp_actual_query42_2: 최신 실적 상태 (WO별 RANK)
-- 원본: TSHP_ACTUAL_QUERY.TSHP_ACTUAL_QUERY42_2()
-- 용도: POP30B - WO별 최신 실적의 상태 조회 (ROW_NUMBER)
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query42_2//

CREATE PROCEDURE sp_imes_tshp_actual_query42_2(
    IN p_plt_code VARCHAR(10),    /* 공장코드 */
    IN p_wo_no    VARCHAR(20)     /* 작업오더번호 */
)
BEGIN
    SELECT
        actSeq                  AS "actSeq"
       ,pltCode                 AS "pltCode"
       ,empCode                 AS "empCode"
       ,procStat                AS "procStat"
    FROM (
        SELECT
            ROW_NUMBER() OVER(PARTITION BY WO_NO ORDER BY ACT_START_TIME DESC) AS actSeq
           ,PLT_CODE AS pltCode
           ,EMP_CODE AS empCode
           ,PROC_STAT AS procStat
        FROM TSHP_ACTUAL
        WHERE PLT_CODE = p_plt_code
          AND WO_NO = p_wo_no
    ) A
    WHERE actSeq = 1;
END//


DELIMITER ;
