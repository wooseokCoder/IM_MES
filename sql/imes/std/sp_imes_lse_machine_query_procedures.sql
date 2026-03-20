-- ============================================================================
-- LSE_MACHINE QUERY 프로시저 (2개)
-- 설비 마스터 조회: QUERY3, QUERY7
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-11
-- 수정일: 2026-02-23 (STD04A용 QUERY3 추가)
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_lse_machine_query3
-- 설비 목록 조회 (STD04A 메인 그리드용)
-- JOIN: SYS_USER(담당자,등록자,수정자), TCST_UNIT_COST_MASTER(공정), TSTD_VENDOR(업체)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_query3//

CREATE PROCEDURE sp_imes_lse_machine_query3(
    IN p_plt_code       VARCHAR(3),
    IN p_mc_like        VARCHAR(50),
    IN p_mc_model_like  VARCHAR(50)
)
BEGIN
    SELECT
        A.PLT_CODE          AS pltCode,
        A.MC_CODE           AS mcCode,
        A.MC_NAME           AS mcName,
        A.MC_MODEL          AS mcModel,
        A.MC_GROUP          AS mcGroup,
        A.MC_AUTOMATED      AS mcAutomated,
        A.MC_OS             AS mcOs,
        A.MC_MGT_FLAG       AS mcMgtFlag,
        A.MC_OPEN_DATE      AS mcOpenDate,
        A.MC_CLOSE_DATE     AS mcCloseDate,
        A.MC_SEQ            AS mcSeq,
        A.CTRL_SYS          AS ctrlSys,
        A.SPEC_X            AS specX,
        A.SPEC_Y            AS specY,
        A.SPEC_Z            AS specZ,
        A.RPM               AS rpm,
        A.BUY_DATE          AS buyDate,
        A.MC_LOCATION       AS mcLocation,
        A.GRADE             AS grade,
        A.MAIN_EMP          AS mainEmp,
        B.USER_NAME         AS mainEmpName,
        A.VEN_CODE          AS venCode,
        V.VEN_NAME          AS venName,
        A.CPROC_CODE        AS cprocCode,
        UM.UTC_NAME         AS cprocName,
        A.SCOMMENT          AS scomment,
        DATE_FORMAT(A.REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        A.REG_EMP           AS regEmp,
        REG.USER_NAME       AS regEmpName,
        DATE_FORMAT(A.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        A.MDFY_EMP          AS mdfyEmp,
        MDFY.USER_NAME      AS mdfyEmpName,
        A.MC_SHIFT          AS mcShift,
        A.IS_SIGNAL         AS isSignal,
        A.MC_IP             AS mcIp,
        A.PLC_IP            AS plcIp,
        A.MC_MAKER          AS mcMaker,
        A.ASSET_NO          AS assetNo,
        A.AS_TEL            AS asTel,
        A.PLC_PORT          AS plcPort,
        A.IS_OPERATE_STATE  AS isOperateState,
        A.FTP_PORT          AS ftpPort,
        A.FTP_USER          AS ftpUser,
        A.FTP_USER_PW       AS ftpUserPw,
        A.FTP_DIR           AS ftpDir,
        A.IS_MULTI_START    AS isMultiStart,
        A.MULTI_START_DIV   AS multiStartDiv,
        A.SIGNAL_TYPE       AS signalType,
        A.IF_MC_CODE        AS ifMcCode,
        A.MC_IMAGE          AS mcImage,
        A.MC_FLAG           AS mcFlag,
        A.IS_SAP            AS isSap,
        A.IS_POP            AS isPop,
        A.IS_SIM_GANTT      AS isSimGantt,
        A.PROC_CODE         AS procCode
    FROM LSE_MACHINE A
        LEFT JOIN SYS_USER B
            ON B.SYS_ID = 'IMMES' AND A.PLT_CODE = B.PLT_CODE AND A.MAIN_EMP = B.USER_ID
        LEFT JOIN TCST_UNIT_COST_MASTER UM
            ON A.PLT_CODE = UM.PLT_CODE AND A.CPROC_CODE = UM.UTC_CODE
        LEFT JOIN SYS_USER REG
            ON REG.SYS_ID = 'IMMES' AND A.PLT_CODE = REG.PLT_CODE AND A.REG_EMP = REG.USER_ID
        LEFT JOIN SYS_USER MDFY
            ON MDFY.SYS_ID = 'IMMES' AND A.PLT_CODE = MDFY.PLT_CODE AND A.MDFY_EMP = MDFY.USER_ID
        LEFT JOIN TSTD_VENDOR V
            ON A.PLT_CODE = V.PLT_CODE AND A.VEN_CODE = V.VEN_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.DATA_FLAG = 0
      AND (p_mc_like IS NULL OR p_mc_like = ''
           OR A.MC_CODE LIKE CONCAT('%', p_mc_like, '%')
           OR A.MC_NAME LIKE CONCAT('%', p_mc_like, '%'))
      AND (p_mc_model_like IS NULL OR p_mc_model_like = ''
           OR A.MC_MODEL LIKE CONCAT('%', p_mc_model_like, '%'))
    ORDER BY A.MC_SEQ;
END//

-- ============================================================================
-- sp_imes_lse_machine_query7
-- 설비 목록 조회 (조건부 필터, STD23A D0B/D3B 설비 목록용)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_query7//

CREATE PROCEDURE sp_imes_lse_machine_query7(
    IN p_plt_code       VARCHAR(3),
    IN p_mc_code        VARCHAR(10),
    IN p_mc_group       VARCHAR(20),
    IN p_mc_os          VARCHAR(3),
    IN p_mc_mgt_flag    VARCHAR(3),
    IN p_data_flag      VARCHAR(3)
)
BEGIN
    SELECT
        M.PLT_CODE          AS pltCode,
        M.MC_CODE           AS mcCode,
        M.MC_NAME           AS mcName,
        M.MC_GROUP          AS mcGroup,
        M.CTRL_SYS          AS ctrlSys,
        M.SPEC_X            AS specX,
        M.SPEC_Y            AS specY,
        M.SPEC_Z            AS specZ,
        M.RPM               AS rpm,
        M.BUY_DATE          AS buyDate,
        M.MC_LOCATION       AS mcLocation,
        M.GRADE             AS grade,
        M.MC_AUTOMATED      AS mcAutomated,
        M.MC_OS             AS mcOs,
        M.MC_SHIFT          AS mcShift,
        M.MC_MGT_FLAG       AS mcMgtFlag,
        M.MC_OPEN_DATE      AS mcOpenDate,
        M.MC_CLOSE_DATE     AS mcCloseDate,
        M.MC_MODEL          AS mcModel,
        M.MC_EFFICIENCY     AS mcEfficiency,
        M.CPROC_CODE        AS cprocCode,
        M.MC_TYPE           AS mcType,
        M.MC_SEQ            AS mcSeq,
        M.MAIN_EMP          AS mainEmp,
        M.SCOMMENT          AS scomment,
        DATE_FORMAT(M.REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        M.REG_EMP           AS regEmp,
        DATE_FORMAT(M.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        M.MDFY_EMP          AS mdfyEmp,
        M.DATA_FLAG         AS dataFlag,
        DATE_FORMAT(M.DEL_DATE, '%Y-%m-%d %H:%i:%s') AS delDate,
        M.DEL_EMP           AS delEmp,
        M.MC_IP             AS mcIp,
        M.PLC_IP            AS plcIp,
        M.MC_MAKER          AS mcMaker,
        M.ASSET_NO          AS assetNo,
        M.AS_TEL            AS asTel,
        M.IS_SIGNAL         AS isSignal,
        M.IS_OPERATE_STATE  AS isOperateState,
        M.FTP_PORT          AS ftpPort,
        M.FTP_USER          AS ftpUser,
        M.FTP_USER_PW       AS ftpUserPw,
        M.FTP_DIR           AS ftpDir
    FROM LSE_MACHINE M
        LEFT JOIN LSE_MC_WORKTIME W
            ON M.PLT_CODE = W.PLT_CODE AND M.MC_CODE = W.MC_CODE
    WHERE M.PLT_CODE = p_plt_code
      AND (p_mc_code IS NULL OR p_mc_code = '' OR M.MC_CODE = p_mc_code)
      AND (p_mc_group IS NULL OR p_mc_group = '' OR M.MC_GROUP = p_mc_group)
      AND (p_mc_os IS NULL OR p_mc_os = '' OR M.MC_OS = p_mc_os)
      AND (p_mc_mgt_flag IS NULL OR p_mc_mgt_flag = '' OR M.MC_MGT_FLAG = p_mc_mgt_flag)
      AND (p_data_flag IS NULL OR p_data_flag = '' OR M.DATA_FLAG = p_data_flag)
    GROUP BY M.PLT_CODE, M.MC_CODE
    ORDER BY M.MC_SEQ ASC;
END//

-- ============================================================================
-- sp_imes_lse_machine_query1
-- 설비 목록 조회 (ORD06A 자원 콤보용, 최소 컬럼)
-- 원본: LSE_MACHINE_QUERY.LSE_MACHINE_QUERY1()
-- 용도: MC_CODE, MC_NAME, MC_DISP 반환 (그리드 콤보 에디터)
-- 사용화면: ORD06A
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_query1//

CREATE PROCEDURE sp_imes_lse_machine_query1(
    IN p_plt_code    VARCHAR(3),
    IN p_mc_group    VARCHAR(20),
    IN p_data_flag   VARCHAR(3)
)
BEGIN
    SELECT
        M.MC_CODE                                    AS mcCode,
        M.MC_NAME                                    AS mcName,
        CONCAT(M.MC_NAME, ' (', M.MC_CODE, ')')     AS mcDisp,
        M.MC_FLAG                                    AS mcFlag
    FROM LSE_MACHINE M
    WHERE M.PLT_CODE = p_plt_code
      AND (p_mc_group IS NULL OR p_mc_group = '' OR M.MC_GROUP = p_mc_group)
      AND (p_data_flag IS NULL OR p_data_flag = '' OR M.DATA_FLAG = p_data_flag)
    ORDER BY M.MC_FLAG, M.MC_SEQ ASC;
END//


-- ============================================================
-- sp_imes_lse_machine_query2: 설비 검색 (팝업용)
-- 원본: LSE_MACHINE_QUERY.LSE_MACHINE_QUERY2()
-- 용도: ChangeCellMc (POP30B 작업장 선택 팝업)
-- 추가일: 2026-03-18
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_lse_machine_query2//

CREATE PROCEDURE sp_imes_lse_machine_query2(
    IN p_plt_code    VARCHAR(10),
    IN p_mc_group    VARCHAR(20),
    IN p_mc_like     VARCHAR(100),
    IN p_is_sap      VARCHAR(5)
)
BEGIN
    SELECT
         A.PLT_CODE      AS "pltCode"
        ,A.MC_CODE       AS "mcCode"
        ,A.MC_NAME       AS "mcName"
        ,A.MC_MODEL      AS "mcModel"
        ,A.MC_GROUP      AS "mcGroup"
        ,A.MC_SEQ        AS "mcSeq"
        ,A.MC_FLAG       AS "mcFlag"
        ,A.IS_SAP        AS "isSap"
        ,A.MAIN_EMP      AS "mainEmp"
        ,B.EMP_NAME      AS "mainEmpName"
        ,A.CPROC_CODE    AS "cprocCode"
        ,A.SCOMMENT      AS "scomment"
    FROM LSE_MACHINE A
        LEFT JOIN TSTD_EMPLOYEE B
            ON A.PLT_CODE = B.PLT_CODE AND A.MAIN_EMP = B.EMP_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.DATA_FLAG = 0
      AND (p_mc_group IS NULL OR p_mc_group = '' OR A.MC_GROUP = p_mc_group)
      AND (p_mc_like IS NULL OR p_mc_like = ''
           OR A.MC_CODE LIKE CONCAT('%', p_mc_like, '%')
           OR A.MC_NAME LIKE CONCAT('%', p_mc_like, '%'))
      AND (p_is_sap IS NULL OR p_is_sap = '' OR A.IS_SAP = p_is_sap)
    ORDER BY A.MC_SEQ;
END//


DELIMITER ;
