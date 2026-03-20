-- ============================================================================
-- REP09A: 가공 진행현황 저장 프로시저
-- 원본: ProActive REP09A.cs (BREP)
-- 작성일: 2026-03-16
-- DB: immes (MySQL)
-- 테이블 전환: TSTD_EMPLOYEE → SYS_USER (USER_ID, USER_NAME)
-- ============================================================================

-- ============================================================================
-- 1. sp_imes_rep09a_ser : 메인 그리드 조회 (WO 그룹 요약)
--    원본: TSHP_WORKORDER_QUERY6
--    용도: REP09A_SER → RSLTDT (메인 그리드)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_s_pln_date    VARCHAR(8),
    IN p_e_pln_date    VARCHAR(8),
    IN p_sap_wo_like   VARCHAR(50),
    IN p_model_like    VARCHAR(50),
    IN p_part_like     VARCHAR(50)
)
BEGIN
    SELECT
        WO.PLT_CODE,
        MAX(WO.MODEL)       AS MODEL,
        WO.SAP_WO_NO,
        WO.PART_CODE,
        SP.PART_NAME,
        COUNT(WO.WO_NO)     AS PROC_CNT,
        MAX(WO.SCOMMENT)    AS SCOMMENT
    FROM TSHP_WORKORDER WO
    LEFT JOIN LSE_STD_PART SP
        ON WO.PLT_CODE = SP.PLT_CODE
        AND WO.PART_CODE = SP.PART_CODE
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.PLANTS   = p_plants
      AND WO.DATA_FLAG = 0
      AND WO.SAP_WO_NO IN (
            SELECT DISTINCT WWO.SAP_WO_NO
            FROM TSHP_WORKORDER WWO
            WHERE SUBSTRING(WWO.PLN_START_TIME, 1, 8) BETWEEN p_s_pln_date AND p_e_pln_date
              AND WWO.PLANTS = p_plants
          )
      AND (p_sap_wo_like = '' OR WO.SAP_WO_NO LIKE CONCAT('%', p_sap_wo_like, '%'))
      AND (p_model_like  = '' OR WO.MODEL      LIKE CONCAT('%', p_model_like, '%'))
      AND (p_part_like   = '' OR WO.PART_CODE   LIKE CONCAT('%', p_part_like, '%')
                              OR SP.PART_NAME    LIKE CONCAT('%', p_part_like, '%'))
    GROUP BY WO.PLT_CODE, WO.SAP_WO_NO, WO.PART_CODE, SP.PART_NAME
    ORDER BY MAX(WO.MODEL), WO.SAP_WO_NO;
END$$
DELIMITER ;


-- ============================================================================
-- 2. sp_imes_rep09a_ser_wo : WO 공정별 상태 목록
--    원본: TSHP_WORKORDER_QUERY5_1
--    용도: REP09A_SER → RSLTDT_WO (동적 컬럼 데이터)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser_wo;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser_wo(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_s_pln_date    VARCHAR(8),
    IN p_e_pln_date    VARCHAR(8),
    IN p_sap_wo_like   VARCHAR(50),
    IN p_model_like    VARCHAR(50),
    IN p_part_like     VARCHAR(50)
)
BEGIN
    SELECT
        WO.PLT_CODE,
        WO.MODEL,
        WO.WO_NO,
        WO.SAP_WO_NO,
        WO.WO_SEQ,
        WO.PART_CODE,
        SP.PART_NAME,
        WO.MPROC_CODE,
        WO.PROC_CODE,
        WO.MC_CODE,
        MC.MC_NAME,
        DATE_FORMAT(WO.ACT_START_TIME, '%Y%m%d%H%i%s') AS ACT_START_TIME,
        DATE_FORMAT(WO.ACT_END_TIME, '%Y%m%d%H%i%s')   AS ACT_END_TIME,
        WO.PLN_START_TIME,
        WO.PLN_END_TIME,
        WO.PLN_PROC_TIME,
        WO.WO_FLAG,
        WO.WORK_CONTENTS,
        WO.SCOMMENT,
        WO.ACT_EMP_CODE,
        U.USER_NAME AS EMP_NAME
    FROM TSHP_WORKORDER WO
    LEFT JOIN LSE_MACHINE MC
        ON WO.PLT_CODE = MC.PLT_CODE AND WO.MC_CODE = MC.MC_CODE
    LEFT JOIN LSE_STD_PART SP
        ON WO.PLT_CODE = SP.PLT_CODE AND WO.PART_CODE = SP.PART_CODE
    LEFT JOIN SYS_USER U
        ON WO.PLT_CODE = U.PLT_CODE AND WO.ACT_EMP_CODE = U.USER_ID
        AND U.SYS_ID = 'IMMES'
    WHERE WO.PLT_CODE = p_plt_code
      AND WO.PLANTS   = p_plants
      AND WO.DATA_FLAG = 0
      AND IFNULL(WO.PLN_PROC_TIME, 0) > 0
      AND WO.SAP_WO_NO IN (
            SELECT DISTINCT WWO.SAP_WO_NO
            FROM TSHP_WORKORDER WWO
            WHERE SUBSTRING(WWO.PLN_START_TIME, 1, 8) BETWEEN p_s_pln_date AND p_e_pln_date
              AND WWO.PLANTS = p_plants
          )
      AND (p_sap_wo_like = '' OR WO.SAP_WO_NO LIKE CONCAT('%', p_sap_wo_like, '%'))
      AND (p_model_like  = '' OR WO.MODEL      LIKE CONCAT('%', p_model_like, '%'))
      AND (p_part_like   = '' OR WO.PART_CODE   LIKE CONCAT('%', p_part_like, '%')
                              OR SP.PART_NAME    LIKE CONCAT('%', p_part_like, '%'))
    ORDER BY WO.MODEL, WO.SAP_WO_NO, WO.WO_SEQ;
END$$
DELIMITER ;


-- ============================================================================
-- 3. sp_imes_rep09a_ser_emp : WO별 작업자 목록
--    원본: TSHP_ACTUAL_QUERY16
--    용도: REP09A_SER → RSLTDT_EMP (동적 컬럼 작업자 데이터)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser_emp;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser_emp(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_s_pln_date    VARCHAR(8),
    IN p_e_pln_date    VARCHAR(8),
    IN p_sap_wo_like   VARCHAR(50),
    IN p_model_like    VARCHAR(50),
    IN p_part_like     VARCHAR(50)
)
BEGIN
    SELECT
        A.PLT_CODE,
        A.WO_NO,
        W.SAP_WO_NO,
        W.WO_SEQ,
        A.EMP_CODE,
        CASE WHEN U.USER_NAME = 'active' THEN 'SYSTEM' ELSE U.USER_NAME END AS EMP_NAME,
        DATE_FORMAT(MAX(A.ACT_START_TIME), '%Y%m%d%H%i%s') AS ACT_START_TIME
    FROM TSHP_ACTUAL A
    LEFT JOIN TSHP_WORKORDER W
        ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
    LEFT JOIN SYS_USER U
        ON A.PLT_CODE = U.PLT_CODE AND A.EMP_CODE = U.USER_ID
        AND U.SYS_ID = 'IMMES'
    WHERE A.PLT_CODE = p_plt_code
      AND W.PLANTS   = p_plants
      AND W.SAP_WO_NO IN (
            SELECT DISTINCT WWO.SAP_WO_NO
            FROM TSHP_WORKORDER WWO
            WHERE SUBSTRING(WWO.PLN_START_TIME, 1, 8) BETWEEN p_s_pln_date AND p_e_pln_date
              AND WWO.PLANTS = p_plants
          )
      AND (p_sap_wo_like = '' OR W.SAP_WO_NO LIKE CONCAT('%', p_sap_wo_like, '%'))
      AND (p_model_like  = '' OR W.MODEL      LIKE CONCAT('%', p_model_like, '%'))
      AND (p_part_like   = '' OR W.PART_CODE   LIKE CONCAT('%', p_part_like, '%'))
    GROUP BY A.PLT_CODE, A.WO_NO, W.SAP_WO_NO, W.WO_SEQ, A.EMP_CODE, U.USER_NAME;
END$$
DELIMITER ;


-- ============================================================================
-- 4. sp_imes_rep09a_ser2_proc : D0A 공정별 상태
--    원본: TSHP_WORKORDER_QUERY19_1
--    용도: REP09A_SER2 → RSLTDT_PROC
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser2_proc;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser2_proc(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_sap_wo_no     VARCHAR(50)
)
BEGIN
    SELECT
        W.PLT_CODE,
        W.SAP_WO_NO,
        W.WO_SEQ,
        W.PROC_CODE,
        W.WO_FLAG
    FROM TSHP_WORKORDER W
    WHERE W.PLT_CODE  = p_plt_code
      AND W.PLANTS    = p_plants
      AND W.SAP_WO_NO = p_sap_wo_no
      AND W.DATA_FLAG  = '0'
    ORDER BY W.WO_SEQ;
END$$
DELIMITER ;


-- ============================================================================
-- 5. sp_imes_rep09a_ser2_act : D0A 실적/비가동 내역
--    원본: TSHP_ACTUAL_QUERY9_1
--    용도: REP09A_SER2 → RSLTDT_ACT
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser2_act;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser2_act(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_sap_wo_no     VARCHAR(50)
)
BEGIN
    SELECT
        A.PLT_CODE,
        '실적' AS ACT_TYPE,
        A.EMP_CODE,
        U.USER_NAME AS EMP_NAME,
        W.WO_SEQ,
        W.PROC_CODE,
        A.MC_CODE,
        M.MC_NAME,
        CASE WHEN IFNULL(A.IS_PRE_WORK, '0') = '1' THEN '준비작업' ELSE NULL END AS PRE_WORK,
        NULL AS IDLE_CODE,
        NULL AS IDLE_NAME,
        DATE_FORMAT(A.ACT_START_TIME, '%Y%m%d%H%i%s') AS ACT_START_TIME,
        DATE_FORMAT(A.ACT_END_TIME, '%Y%m%d%H%i%s')   AS ACT_END_TIME,
        TIMESTAMPDIFF(MINUTE, A.ACT_START_TIME, A.ACT_END_TIME) AS ACT_TIME
    FROM TSHP_ACTUAL A
    LEFT JOIN SYS_USER U
        ON A.PLT_CODE = U.PLT_CODE AND A.EMP_CODE = U.USER_ID AND U.SYS_ID = 'IMMES'
    LEFT JOIN TSHP_WORKORDER W
        ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
    LEFT JOIN LSE_MACHINE M
        ON A.PLT_CODE = M.PLT_CODE AND A.MC_CODE = M.MC_CODE
    WHERE A.PLT_CODE   = p_plt_code
      AND W.PLANTS     = p_plants
      AND W.SAP_WO_NO  = p_sap_wo_no
      AND A.ACT_START_TIME != IFNULL(A.ACT_END_TIME, NOW())

    UNION ALL

    SELECT
        I.PLT_CODE,
        '비가동' AS ACT_TYPE,
        I.EMP_CODE,
        U.USER_NAME AS EMP_NAME,
        W.WO_SEQ,
        W.PROC_CODE,
        I.MC_CODE,
        M.MC_NAME,
        NULL AS PRE_WORK,
        I.IDLE_CODE,
        IC.IDLE_NAME,
        DATE_FORMAT(I.START_TIME, '%Y%m%d%H%i%s')  AS ACT_START_TIME,
        DATE_FORMAT(I.END_TIME, '%Y%m%d%H%i%s')    AS ACT_END_TIME,
        I.IDLE_TIME   AS ACT_TIME
    FROM TSHP_IDLETIME I
    LEFT JOIN SYS_USER U
        ON I.PLT_CODE = U.PLT_CODE AND I.EMP_CODE = U.USER_ID AND U.SYS_ID = 'IMMES'
    LEFT JOIN TSHP_WORKORDER W
        ON I.PLT_CODE = W.PLT_CODE AND I.WO_NO = W.WO_NO
    LEFT JOIN TSTD_IDLECODE IC
        ON I.PLT_CODE = IC.PLT_CODE AND I.IDLE_CODE = IC.IDLE_CODE
    LEFT JOIN LSE_MACHINE M
        ON I.PLT_CODE = M.PLT_CODE AND I.MC_CODE = M.MC_CODE
    WHERE I.PLT_CODE   = p_plt_code
      AND W.PLANTS     = p_plants
      AND W.SAP_WO_NO  = p_sap_wo_no
      AND I.START_TIME != IFNULL(I.END_TIME, NOW())

    ORDER BY WO_SEQ, ACT_START_TIME DESC;
END$$
DELIMITER ;


-- ============================================================================
-- 6. sp_imes_rep09a_ser2_ng : D0A/D1A 부적합 내역
--    원본: TSHP_NG_QUERY7_1
--    용도: REP09A_SER2 → RSLTDT_NG, REP09A_SER4 → RSLTDT_NG
--    p_wo_seq: 전체 조회 시 '' 전달
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser2_ng;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser2_ng(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_sap_wo_no     VARCHAR(50),
    IN p_wo_seq        VARCHAR(10)
)
BEGIN
    SELECT
        N.PLT_CODE,
        DATE_FORMAT(N.NG_DATE, '%Y%m%d') AS NG_DATE,
        N.EMP_CODE,
        U.USER_NAME AS EMP_NAME,
        W.WO_SEQ,
        W.PROC_CODE,
        N.MASTER_CAUSE,
        N.DETAIL_CAUSE,
        N.QUANTITY,
        N.NG_CONTENTS
    FROM TSHP_NG N
    LEFT JOIN TSHP_WORKORDER W
        ON N.PLT_CODE = W.PLT_CODE AND N.LINK_KEY = W.WO_NO
    LEFT JOIN SYS_USER U
        ON N.PLT_CODE = U.PLT_CODE AND N.EMP_CODE = U.USER_ID AND U.SYS_ID = 'IMMES'
    WHERE N.PLT_CODE   = p_plt_code
      AND W.SAP_WO_NO  = p_sap_wo_no
      AND W.PLANTS     = p_plants
      AND (p_wo_seq = '' OR W.WO_SEQ = p_wo_seq)
    ORDER BY W.WO_SEQ, NG_DATE DESC, U.USER_NAME;
END$$
DELIMITER ;


-- ============================================================================
-- 7. sp_imes_rep09a_ser2_ins : D0A/D1A 자주검사 내역
--    원본: TSHP_INS_RESULT_QUERY4_1
--    용도: REP09A_SER2 → RSLTDT_INS, REP09A_SER4 → RSLTDT_INS
--    p_wo_seq: 전체 조회 시 '' 전달
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser2_ins;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser2_ins(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_sap_wo_no     VARCHAR(50),
    IN p_wo_seq        VARCHAR(10)
)
BEGIN
    SELECT
        IM.PLT_CODE,
        IM.EMP_CODE,
        U.USER_NAME AS EMP_NAME,
        DATE_FORMAT(IM.REG_DATE, '%Y%m%d') AS REG_DATE,
        W.WO_SEQ,
        W.PROC_CODE,
        IR.INS_NAME,
        IR.INS_DESC,
        IR.AVG_VAL,
        IR.MIN_VAL,
        IR.MAX_VAL,
        IR.INS_RESULT
    FROM TSHP_INS_RESULT_MASTER IM
    LEFT JOIN TSHP_INS_RESULT IR
        ON IM.PLT_CODE = IR.PLT_CODE AND IM.INSM_NO = IR.INSM_NO
    LEFT JOIN TSHP_WORKORDER W
        ON W.PLT_CODE = IM.PLT_CODE AND W.WO_NO = IM.WO_NO
    LEFT JOIN TSTD_PROCGRP PG
        ON W.PLT_CODE = PG.PLT_CODE AND W.MPROC_CODE = PG.PRG_CODE
    LEFT JOIN SYS_USER U
        ON U.PLT_CODE = IM.PLT_CODE AND U.USER_ID = IM.EMP_CODE AND U.SYS_ID = 'IMMES'
    WHERE IM.PLT_CODE  = p_plt_code
      AND W.PLANTS     = p_plants
      AND W.SAP_WO_NO  = p_sap_wo_no
      AND (p_wo_seq = '' OR W.WO_SEQ = p_wo_seq)
      AND PG.IS_MNT    = '1'
      AND IM.DATA_FLAG  = '0'
      AND IR.DATA_FLAG  = '0'
    ORDER BY PG.PRG_SEQ, IR.INS_SEQ, REG_DATE DESC;
END$$
DELIMITER ;


-- ============================================================================
-- 8. sp_imes_rep09a_ser3 : D1A 완료공정 목록
--    원본: TSHP_WORKORDER_QUERY20_1
--    용도: REP09A_SER3 → RSLTDT
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser3;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser3(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_s_pln_date    VARCHAR(8),
    IN p_e_pln_date    VARCHAR(8),
    IN p_sap_wo_like   VARCHAR(50),
    IN p_model_like    VARCHAR(50),
    IN p_part_like     VARCHAR(50)
)
BEGIN
    SELECT
        WO.PLT_CODE,
        WO.PROD_CODE,
        WO.SAP_WO_NO,
        WO.WO_SEQ,
        WO.PROC_CODE,
        WO.WO_FLAG,
        WO.MODEL,
        WO.PART_CODE,
        PT.PART_NAME
    FROM TSHP_WORKORDER WO
    LEFT JOIN LSE_STD_PART PT
        ON WO.PLT_CODE = PT.PLT_CODE AND WO.PART_CODE = PT.PART_CODE
    WHERE WO.PLT_CODE  = p_plt_code
      AND WO.PLANTS    = p_plants
      AND WO.DATA_FLAG = '0'
      AND WO.WO_FLAG   = '4'
      AND WO.SAP_WO_NO IN (
            SELECT DISTINCT WWO.SAP_WO_NO
            FROM TSHP_WORKORDER WWO
            WHERE SUBSTRING(WWO.PLN_START_TIME, 1, 8) BETWEEN p_s_pln_date AND p_e_pln_date
              AND WWO.PLANTS = p_plants
          )
      AND (p_sap_wo_like = '' OR WO.SAP_WO_NO LIKE CONCAT('%', p_sap_wo_like, '%'))
      AND (p_model_like  = '' OR WO.MODEL      LIKE CONCAT('%', p_model_like, '%'))
      AND (p_part_like   = '' OR WO.PART_CODE   LIKE CONCAT('%', p_part_like, '%')
                              OR PT.PART_NAME    LIKE CONCAT('%', p_part_like, '%'))
    ORDER BY WO.WO_SEQ;
END$$
DELIMITER ;


-- ============================================================================
-- 9. sp_imes_rep09a_ser4_act : D1A 실적/비가동 내역 (WO_SEQ 지정)
--    원본: TSHP_ACTUAL_QUERY9_2
--    용도: REP09A_SER4 → RSLTDT_ACT
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_rep09a_ser4_act;
DELIMITER $$
CREATE PROCEDURE sp_imes_rep09a_ser4_act(
    IN p_plt_code      VARCHAR(10),
    IN p_plants        VARCHAR(10),
    IN p_sap_wo_no     VARCHAR(50),
    IN p_wo_seq        VARCHAR(10)
)
BEGIN
    SELECT
        A.PLT_CODE,
        '실적' AS ACT_TYPE,
        A.EMP_CODE,
        U.USER_NAME AS EMP_NAME,
        W.WO_SEQ,
        W.PROC_CODE,
        A.MC_CODE,
        M.MC_NAME,
        CASE WHEN IFNULL(A.IS_PRE_WORK, '0') = '1' THEN '준비작업' ELSE NULL END AS PRE_WORK,
        NULL AS IDLE_CODE,
        NULL AS IDLE_NAME,
        DATE_FORMAT(A.ACT_START_TIME, '%Y%m%d%H%i%s') AS ACT_START_TIME,
        DATE_FORMAT(A.ACT_END_TIME, '%Y%m%d%H%i%s')   AS ACT_END_TIME,
        TIMESTAMPDIFF(MINUTE, A.ACT_START_TIME, A.ACT_END_TIME) AS ACT_TIME
    FROM TSHP_ACTUAL A
    LEFT JOIN SYS_USER U
        ON A.PLT_CODE = U.PLT_CODE AND A.EMP_CODE = U.USER_ID AND U.SYS_ID = 'IMMES'
    LEFT JOIN TSHP_WORKORDER W
        ON A.PLT_CODE = W.PLT_CODE AND A.WO_NO = W.WO_NO
    LEFT JOIN LSE_MACHINE M
        ON A.PLT_CODE = M.PLT_CODE AND A.MC_CODE = M.MC_CODE
    WHERE A.PLT_CODE   = p_plt_code
      AND W.PLANTS     = p_plants
      AND W.SAP_WO_NO  = p_sap_wo_no
      AND W.WO_SEQ     = p_wo_seq
      AND A.ACT_START_TIME != IFNULL(A.ACT_END_TIME, NOW())

    UNION ALL

    SELECT
        I.PLT_CODE,
        '비가동' AS ACT_TYPE,
        I.EMP_CODE,
        U.USER_NAME AS EMP_NAME,
        W.WO_SEQ,
        W.PROC_CODE,
        I.MC_CODE,
        M.MC_NAME,
        NULL AS PRE_WORK,
        I.IDLE_CODE,
        IC.IDLE_NAME,
        DATE_FORMAT(I.START_TIME, '%Y%m%d%H%i%s')  AS ACT_START_TIME,
        DATE_FORMAT(I.END_TIME, '%Y%m%d%H%i%s')    AS ACT_END_TIME,
        I.IDLE_TIME   AS ACT_TIME
    FROM TSHP_IDLETIME I
    LEFT JOIN SYS_USER U
        ON I.PLT_CODE = U.PLT_CODE AND I.EMP_CODE = U.USER_ID AND U.SYS_ID = 'IMMES'
    LEFT JOIN TSHP_WORKORDER W
        ON I.PLT_CODE = W.PLT_CODE AND I.WO_NO = W.WO_NO
    LEFT JOIN TSTD_IDLECODE IC
        ON I.PLT_CODE = IC.PLT_CODE AND I.IDLE_CODE = IC.IDLE_CODE
    LEFT JOIN LSE_MACHINE M
        ON I.PLT_CODE = M.PLT_CODE AND I.MC_CODE = M.MC_CODE
    WHERE I.PLT_CODE   = p_plt_code
      AND W.PLANTS     = p_plants
      AND W.SAP_WO_NO  = p_sap_wo_no
      AND W.WO_SEQ     = p_wo_seq
      AND I.START_TIME != IFNULL(I.END_TIME, NOW())

    ORDER BY WO_SEQ, ACT_START_TIME DESC;
END$$
DELIMITER ;
