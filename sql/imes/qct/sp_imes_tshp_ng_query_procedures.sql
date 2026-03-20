-- ============================================================================
-- TSHP_NG QUERY 프로시저 (2개)
-- 부적합/결품 현황: 목록 조회, 이미지 조회
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-03-09
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tshp_ng_query3
-- 부적합/결품 목록 조회 (메인 그리드)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_query3//

CREATE PROCEDURE sp_imes_tshp_ng_query3(
    IN p_plt_code    VARCHAR(3),
    IN p_proc_code   VARCHAR(10),
    IN p_ng_state    VARCHAR(1),
    IN p_s_ng_date   VARCHAR(8),
    IN p_e_ng_date   VARCHAR(8),
    IN p_plants      VARCHAR(10)
)
BEGIN
    SELECT
        N.PLT_CODE,
        N.NG_ID,
        N.NG_STATE,
        DATE_FORMAT(N.QMS_SEND_DATE, '%Y-%m-%d') AS QMS_SEND_DATE,
        DATE_FORMAT(N.QMS_DATE, '%Y-%m-%d') AS QMS_DATE,
        N.NG_CLASS,
        W.SAP_WO_NO,
        W.WO_NO,
        N.NG_DATE,
        N.EMP_CODE,
        E.USER_NAME AS EMP_NAME,
        CONCAT(IFNULL(P.ORDER_NO, ''), '/', IFNULL(P.ORDER_LINE, '')) AS ORDER_NO_LINE,
        W.PROC_CODE,
        M.MODEL_CODE,
        M.PROD_TYPE,
        N.QUANTITY,
        W.PART_CODE,
        LSP.PART_NAME,
        SAP.CVND_CODE AS VEN_CODE,
        SAP.CVND_NAME AS VEN_NAME,
        I.IDLE_CODE,
        TI.IDLE_NAME,
        N.MASTER_CAUSE,
        N.DETAIL_CAUSE,
        N.NG_CONTENTS,
        N.NG_MEASURE,
        N.NG_PART_CODE,
        W.MODEL,
        (CASE WHEN N.NG_IMG1 IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN N.NG_IMG2 IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN N.NG_IMG3 IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN N.NG_IMG4 IS NOT NULL THEN 1 ELSE 0 END) AS IMG_CNT,
        QP.STATUS_CD,
        QP.SCND_CHRGR_DEPT_NM,
        QP.SCND_CHRGR_NM,
        QP.FRST_IMPT_CD,
        QP.MANAGT_CD,
        QP.MTRIL_NOC,
        QP.FRST_BADN_TYPE_CD1,
        QP.FRST_BADN_TYPE_CD2,
        QP.CAUSE_ANAY_CN,
        QP.IMPT_ACC_NM,
        QP.IMPT_COMPT_DATE,
        QP.IMPT_MANAGT_CN,
        QP.CAUSES,
        QP.RELAPSE_PREVENTION,
        SUM(IFNULL(I.IDLE_TIME, 0)) AS IDLE_TIME,
        DATE_FORMAT(N.REG_DATE, '%Y-%m-%d') AS REG_DATE
    FROM TSHP_NG N
    LEFT JOIN TSHP_WORKORDER W
        ON N.PLT_CODE = W.PLT_CODE
        AND N.LINK_KEY = W.WO_NO
    LEFT JOIN TORD_PRODUCT P
        ON W.PLT_CODE = P.PLT_CODE
        AND W.PROD_CODE = P.PROD_CODE
    LEFT JOIN IF_SAP_WORKORDER_PROD SAP
        ON W.SAP_WO_NO = SAP.SAP_WO_NO
    LEFT JOIN LSE_STD_PART LSP
        ON W.PLT_CODE = LSP.PLT_CODE
        AND W.PART_CODE = LSP.PART_CODE
    LEFT JOIN TSTD_MODEL M
        ON P.PLT_CODE = M.PLT_CODE
        AND P.MODEL_TYPE = M.MODEL_TYPE
        AND P.MODEL_SERISE = M.MODEL_SERISE
        AND P.MODEL_NO = M.MODEL_NO
    LEFT JOIN SYS_USER E
        ON N.EMP_CODE = E.USER_ID
        AND E.SYS_ID = 'IMMES'
    LEFT JOIN IF_QMS_PROC_RSLT QP
        ON N.NG_ID = QP.MES_NO
    LEFT JOIN TSHP_IDLETIME I
        ON N.PLT_CODE = I.PLT_CODE
        AND N.NG_ID = I.NG_ID
        AND I.DATA_FLAG = 0
    LEFT JOIN TSTD_IDLECODE TI
        ON I.PLT_CODE = TI.PLT_CODE
        AND I.IDLE_CODE = TI.IDLE_CODE
    WHERE N.PLT_CODE = p_plt_code
        AND (p_proc_code IS NULL OR p_proc_code = '' OR W.PROC_CODE = p_proc_code)
        AND (p_ng_state IS NULL OR p_ng_state = '' OR N.NG_STATE = p_ng_state)
        AND (p_s_ng_date IS NULL OR p_s_ng_date = '' OR N.NG_DATE >= p_s_ng_date)
        AND (p_e_ng_date IS NULL OR p_e_ng_date = '' OR N.NG_DATE <= p_e_ng_date)
        AND (p_plants IS NULL OR p_plants = '' OR W.PLANTS = p_plants)
    GROUP BY
        N.PLT_CODE, N.NG_ID, N.NG_STATE,
        N.QMS_SEND_DATE, N.QMS_DATE, N.NG_CLASS,
        W.SAP_WO_NO, W.WO_NO, N.NG_DATE,
        N.EMP_CODE, E.USER_NAME,
        P.ORDER_NO, P.ORDER_LINE,
        W.PROC_CODE, M.MODEL_CODE, M.PROD_TYPE,
        N.QUANTITY, W.PART_CODE, LSP.PART_NAME,
        SAP.CVND_CODE, SAP.CVND_NAME,
        I.IDLE_CODE, TI.IDLE_NAME,
        N.MASTER_CAUSE, N.DETAIL_CAUSE,
        N.NG_CONTENTS, N.NG_MEASURE,
        N.NG_PART_CODE, W.MODEL,
        N.NG_IMG1, N.NG_IMG2, N.NG_IMG3, N.NG_IMG4,
        QP.STATUS_CD, QP.SCND_CHRGR_DEPT_NM, QP.SCND_CHRGR_NM,
        QP.FRST_IMPT_CD, QP.MANAGT_CD, QP.MTRIL_NOC,
        QP.FRST_BADN_TYPE_CD1, QP.FRST_BADN_TYPE_CD2,
        QP.CAUSE_ANAY_CN, QP.IMPT_ACC_NM, QP.IMPT_COMPT_DATE,
        QP.IMPT_MANAGT_CN, QP.CAUSES, QP.RELAPSE_PREVENTION,
        N.REG_DATE
    ORDER BY N.NG_DATE DESC, N.NG_ID DESC;
END//

-- ============================================================================
-- sp_imes_tshp_ng_img
-- 부적합 사진 단건 조회 (이미지 base64)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_img//

CREATE PROCEDURE sp_imes_tshp_ng_img(
    IN p_plt_code  VARCHAR(3),
    IN p_ng_id     VARCHAR(20),
    IN p_img_no    INT
)
BEGIN
    SELECT
        CASE p_img_no
            WHEN 1 THEN TO_BASE64(NG_IMG1)
            WHEN 2 THEN TO_BASE64(NG_IMG2)
            WHEN 3 THEN TO_BASE64(NG_IMG3)
            WHEN 4 THEN TO_BASE64(NG_IMG4)
            ELSE NULL
        END AS imgBase64
    FROM TSHP_NG
    WHERE PLT_CODE = p_plt_code
        AND NG_ID = p_ng_id;
END//

DELIMITER ;
