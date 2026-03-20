-- ============================================================
-- 프로시저명: sp_imes_tshp_ins_result_master_query1
--             sp_imes_tshp_ins_result_master_query1_count
-- 화면: QCT08A - 자주검사 현황
-- 설명: 자주검사 결과 메인 조회 (조립/가공 공용)
--       서버사이드 페이징 지원 (LIMIT/OFFSET)
--       TSHP_INS_RESULT_MASTER + TSHP_WORKORDER + TSHP_INS_RESULT
--       + TORD_PRODUCT + IF_SAP_SHIPINFO + SYS_USER + LSE_STD_PROC
-- 작성자: 송우석
-- 작성일: 2026-03-17
-- 수정일: 2026-03-17 서버사이드 페이징 추가 (p_offset, p_limit)
-- 수정일: 2026-03-17 개발서버 collation 통일 (ALTER TABLE로 unicode_ci 적용)
-- ============================================================

DELIMITER //

-- ============================================================
-- 카운트 조회 (페이징용)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_query1_count//

CREATE PROCEDURE sp_imes_tshp_ins_result_master_query1_count(
    IN p_plt_code     VARCHAR(10),
    IN p_plants       VARCHAR(10),
    IN p_order_like   VARCHAR(50),
    IN p_hogi_like    VARCHAR(50),
    IN p_model_like   VARCHAR(50),
    IN p_proc_code    VARCHAR(20)
)
BEGIN
    SELECT COUNT(*) AS total
    FROM TSHP_INS_RESULT_MASTER A
        LEFT JOIN TSHP_WORKORDER B
            ON A.PLT_CODE = B.PLT_CODE AND A.WO_NO = B.WO_NO
        INNER JOIN TSHP_INS_RESULT C
            ON A.PLT_CODE = C.PLT_CODE AND A.INSM_NO = C.INSM_NO AND C.DATA_FLAG = 0
        LEFT JOIN TORD_PRODUCT D
            ON B.PLT_CODE = D.PLT_CODE AND B.PROD_CODE = D.PROD_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.DATA_FLAG = 0
      AND (p_plants IS NULL OR p_plants = '' OR B.PLANTS = p_plants)
      AND (p_order_like IS NULL OR p_order_like = '' OR D.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
      AND (p_hogi_like IS NULL OR p_hogi_like = '' OR D.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
      AND (p_model_like IS NULL OR p_model_like = '' OR B.MODEL LIKE CONCAT('%', p_model_like, '%'))
      AND (p_proc_code IS NULL OR p_proc_code = '' OR C.PROC_CODE = p_proc_code);
END//

-- ============================================================
-- 데이터 조회 (페이징 적용)
-- 2단계 전략: 핵심 4테이블로 페이징 → 100건에만 비싼 JOIN 적용
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ins_result_master_query1//

CREATE PROCEDURE sp_imes_tshp_ins_result_master_query1(
    IN p_plt_code     VARCHAR(10),
    IN p_plants       VARCHAR(10),
    IN p_order_like   VARCHAR(50),
    IN p_hogi_like    VARCHAR(50),
    IN p_model_like   VARCHAR(50),
    IN p_proc_code    VARCHAR(20),
    IN p_offset       INT,
    IN p_limit        INT
)
BEGIN
    -- 1단계: 핵심 4테이블로 필터+정렬+페이징 (빠름, ~2초)
    -- 2단계: 결과 100건에만 SYS_USER, IF_SAP_SHIPINFO, LSE_STD_PROC JOIN
    SELECT
        P.pltCode,
        P.insmNo,
        P.orderNo,
        P.orderLine,
        P.prodOrder,
        P.prodWeek,
        P.prodHogi,
        P.indueDate,
        E.CUSTOMER                                                         AS customer,
        P.modelType,
        P.model,
        P.qmsState,
        P.empCode,
        F.USER_NAME                                                        AS empName,
        P.insDate,
        P.insNo,
        P.procCode,
        G.PROC_NAME                                                        AS procName,
        P.insType,
        P.insUnit,
        P.insName,
        P.insDesc,
        P.avgVal,
        P.minVal,
        P.maxVal,
        P.insResult,
        P.imgCnt,
        P.insSeq,
        P.sapWoNo
    FROM (
        SELECT
            A.PLT_CODE                                                     AS pltCode,
            A.INSM_NO                                                      AS insmNo,
            D.ORDER_NO                                                     AS orderNo,
            D.ORDER_LINE                                                   AS orderLine,
            CONCAT(IFNULL(D.ORDER_NO, ''), '/', IFNULL(CAST(D.ORDER_LINE AS CHAR), ''))
                                                                           AS prodOrder,
            D.PROD_WEEK                                                    AS prodWeek,
            D.PROD_HOGI                                                    AS prodHogi,
            D.INDUE_DATE                                                   AS indueDate,
            D.MODEL_TYPE                                                   AS modelType,
            B.MODEL                                                        AS model,
            CASE WHEN A.QMS_STATE = '1' THEN '전송' ELSE '미전송' END     AS qmsState,
            A.EMP_CODE                                                     AS empCode,
            DATE_FORMAT(A.REG_DATE, '%Y-%m-%d')                            AS insDate,
            C.INS_NO                                                       AS insNo,
            C.PROC_CODE                                                    AS procCode,
            C.INS_TYPE                                                     AS insType,
            C.INS_UNIT                                                     AS insUnit,
            C.INS_NAME                                                     AS insName,
            C.INS_DESC                                                     AS insDesc,
            C.AVG_VAL                                                      AS avgVal,
            C.MIN_VAL                                                      AS minVal,
            C.MAX_VAL                                                      AS maxVal,
            C.INS_RESULT                                                   AS insResult,
            CASE WHEN C.INS_RESULT_IMG IS NOT NULL THEN 1 ELSE 0 END      AS imgCnt,
            C.INS_SEQ                                                      AS insSeq,
            B.SAP_WO_NO                                                    AS sapWoNo
        FROM TSHP_INS_RESULT_MASTER A
            LEFT JOIN TSHP_WORKORDER B
                ON A.PLT_CODE = B.PLT_CODE AND A.WO_NO = B.WO_NO
            INNER JOIN TSHP_INS_RESULT C
                ON A.PLT_CODE = C.PLT_CODE AND A.INSM_NO = C.INSM_NO AND C.DATA_FLAG = 0
            LEFT JOIN TORD_PRODUCT D
                ON B.PLT_CODE = D.PLT_CODE AND B.PROD_CODE = D.PROD_CODE
        WHERE A.PLT_CODE = p_plt_code
          AND A.DATA_FLAG = 0
          AND (p_plants IS NULL OR p_plants = '' OR B.PLANTS = p_plants)
          AND (p_order_like IS NULL OR p_order_like = '' OR D.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
          AND (p_hogi_like IS NULL OR p_hogi_like = '' OR D.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
          AND (p_model_like IS NULL OR p_model_like = '' OR B.MODEL LIKE CONCAT('%', p_model_like, '%'))
          AND (p_proc_code IS NULL OR p_proc_code = '' OR C.PROC_CODE = p_proc_code)
        ORDER BY D.ORDER_NO, D.ORDER_LINE, A.INSM_NO, C.INS_SEQ
        LIMIT p_limit OFFSET p_offset
    ) P
    LEFT JOIN IF_SAP_SHIPINFO E
        ON P.orderNo = E.ORDER_NO
        AND CAST(P.orderLine AS CHAR) COLLATE utf8mb4_unicode_ci = E.ORDER_LINE
    LEFT JOIN SYS_USER F
        ON F.SYS_ID = 'IMMES'
        AND P.empCode = CONVERT(F.USER_ID USING utf8mb4) COLLATE utf8mb4_unicode_ci
        AND F.USE_FLAG = 'Y'
    LEFT JOIN LSE_STD_PROC G
        ON P.pltCode = G.PLT_CODE AND P.procCode = G.PROC_CODE;
END//

DELIMITER ;
