-- ============================================================================
-- TSHP_ACTUAL_QUERY 프로시저 (POP 모듈)
-- 작업자현황 조회: sp_imes_tshp_actual_query17
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-03-16
-- ============================================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //

-- ============================================================================
-- sp_imes_tshp_actual_query17: 작업자현황 메인 그리드 조회
-- 용도: POP41A 메인 그리드 (검색조건 없음, PLT_CODE만 전달)
-- 로직:
--   1. SYS_USER 기준 (ORG_CODE = p_org_code 필터)
--   2. LEFT JOIN 서브쿼리 ACT:
--      - TSHP_ACTUAL (PROC_STAT=2 → '진행')
--      - UNION ALL TSHP_IDLETIME (IDLE_STATE=1 → '중지')
--   3. LEFT JOIN TSYS_OFF_LOG (퇴근 시간)
--   4. LEFT JOIN TORD_PRODUCT + IF_SAP_SHIPINFO (호기, 고객사)
--   5. EMP_STAT: 진행/중지 → 해당 값, NULL+퇴근기록 있음 → '퇴근'
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_actual_query17//

CREATE PROCEDURE sp_imes_tshp_actual_query17(
    IN p_plt_code   VARCHAR(3),
    IN p_org_code   VARCHAR(30)
)
BEGIN
    SELECT
        E.PLT_CODE                                          AS pltCode,
        E.EMP_GUBUN2                                        AS empGubun2,
        E.USER_ID                                           AS empCode,
        E.USER_NAME                                         AS empName,
        CASE
            WHEN ACT.EMP_STAT IS NOT NULL THEN ACT.EMP_STAT
            WHEN ACT.EMP_STAT IS NULL AND O.EMP_CODE IS NOT NULL THEN '퇴근'
        END                                                 AS empStat,
        ACT.SAP_WO_NO                                       AS sapWoNo,
        ACT.WO_SEQ                                          AS woSeq,
        ACT.PROC_CODE                                       AS procCode,
        ACT.PART_CODE                                       AS partCode,
        ACT.PART_NAME                                       AS partName,
        ACT.IDLE_CODE                                       AS idleCode,
        ACT.IDLE_NAME                                       AS idleName,
        DATE_FORMAT(
            CASE
                WHEN ACT.EMP_STAT IS NOT NULL THEN ACT.ACT_START_TIME
                ELSE O.OFF_DATETIME
            END, '%Y-%m-%d %H:%i:%s')                       AS actStartTime,
        SH.CUSTOMER                                         AS customer,
        P.PROD_HOGI                                         AS prodHogi
    FROM SYS_USER E
        LEFT JOIN (
            /* 진행 중 (PROC_STAT = 2) */
            SELECT
                A.PLT_CODE,
                '진행'              AS EMP_STAT,
                A.EMP_CODE,
                A.WO_NO,
                W.SAP_WO_NO,
                W.WO_SEQ,
                W.PROC_CODE,
                W.PART_CODE,
                SP.PART_NAME,
                NULL                AS IDLE_CODE,
                NULL                AS IDLE_NAME,
                A.ACT_START_TIME,
                W.PROD_CODE
            FROM TSHP_ACTUAL A
                LEFT JOIN TSHP_WORKORDER W
                    ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
                LEFT JOIN LSE_STD_PART SP
                    ON W.PLT_CODE = SP.PLT_CODE AND W.PART_CODE = SP.PART_CODE
            WHERE A.PROC_STAT = 2

            UNION ALL

            /* 중지 (IDLE_STATE = 1) */
            SELECT
                I.PLT_CODE,
                '중지'              AS EMP_STAT,
                I.EMP_CODE,
                I.WO_NO,
                W.SAP_WO_NO,
                W.WO_SEQ,
                W.PROC_CODE,
                W.PART_CODE,
                SP.PART_NAME,
                I.IDLE_CODE,
                IC.IDLE_NAME,
                I.START_TIME        AS ACT_START_TIME,
                W.PROD_CODE
            FROM TSHP_IDLETIME I
                LEFT JOIN TSHP_WORKORDER W
                    ON I.PLT_CODE = W.PLT_CODE AND I.WO_NO = W.WO_NO
                LEFT JOIN LSE_STD_PART SP
                    ON W.PLT_CODE = SP.PLT_CODE AND W.PART_CODE = SP.PART_CODE
                LEFT JOIN TSTD_IDLECODE IC
                    ON I.PLT_CODE = IC.PLT_CODE AND I.IDLE_CODE = IC.IDLE_CODE
            WHERE I.IDLE_STATE = 1
        ) ACT
            ON E.PLT_CODE = ACT.PLT_CODE AND E.USER_ID = ACT.EMP_CODE
        LEFT JOIN (
            SELECT PLT_CODE, EMP_CODE, MAX(REG_DATE) AS OFF_DATETIME
            FROM TSYS_OFF_LOG
            GROUP BY PLT_CODE, EMP_CODE
        ) O
            ON E.PLT_CODE = O.PLT_CODE AND E.USER_ID = O.EMP_CODE
        LEFT JOIN TORD_PRODUCT P
            ON ACT.PLT_CODE = P.PLT_CODE AND ACT.PROD_CODE = P.PROD_CODE
        LEFT JOIN IF_SAP_SHIPINFO SH
            ON P.ORDER_NO = SH.ORDER_NO AND P.ORDER_LINE = SH.ORDER_LINE
    WHERE E.SYS_ID = 'IMMES'
      AND E.ORG_CODE = p_org_code
      AND E.USE_FLAG = 'Y'
    ORDER BY E.EMP_GUBUN2, E.USER_NAME;
END//

DELIMITER ;
