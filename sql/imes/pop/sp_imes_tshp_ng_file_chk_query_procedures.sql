-- ============================================================
-- TSHP_NG_FILE_CHK 조회 프로시저 (POP55A 화면)
-- 생성일: 2026-03-07
-- 수정일: 2026-03-09 (SP 이름 변경 + DEFINER 추가)
-- 대상 테이블: TSHP_NG_FILE_CHK (주), TSHP_WORKORDER, TORD_PRODUCT 등
-- 원본: ProActive POP55A.cs (QUERY22, QUERY23)
-- 화면: POP55A (오조립 확인)
-- ============================================================
-- 포함 프로시저 (2개):
--   1. sp_imes_tshp_ng_file_chk_query22  - 메인 조회 (NG파일배포 제품 목록 + 확인 상태)
--   2. sp_imes_tshp_ng_file_chk_query23  - 상세 조회 (선택 제품의 파일 목록)
-- ============================================================

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DELIMITER //


-- ============================================================
-- 1. sp_imes_tshp_ng_file_chk_query22: 메인 조회 (NG파일배포 제품 목록)
-- 원본: POP55A.POP55A_SER() → QUERY22
-- 용도: POP55A Grid1 제품 목록 + 확인 상태 조회
-- 동적 조건: 납기일, 호기, 오더, 고객, 제품코드, 제품유형, MC번호
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_chk_query22//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_chk_query22(
    IN p_plt_code      VARCHAR(10),     /* 공장코드 */
    IN p_s_indue_date  VARCHAR(10),     /* 납기일 시작 (YYYY-MM-DD) */
    IN p_e_indue_date  VARCHAR(10),     /* 납기일 종료 (YYYY-MM-DD) */
    IN p_hogi_like     VARCHAR(50),     /* 호기 LIKE 검색 */
    IN p_order_like    VARCHAR(50),     /* 오더번호 LIKE 검색 */
    IN p_customer_like VARCHAR(100),    /* 고객명 LIKE 검색 */
    IN p_prod_code     VARCHAR(50),     /* 제품코드 (정확 일치) */
    IN p_prod_type     VARCHAR(20),     /* 제품유형 (정확 일치) */
    IN p_mc_no_like    VARCHAR(50)      /* MC번호 LIKE 검색 */
)
BEGIN
    SELECT
        FC.PLT_CODE                                         AS "pltCode"
       ,M.PROD_TYPE                                         AS "prodType"
       ,P.PROD_CODE                                         AS "prodCode"
       ,P.ORDER_NO                                          AS "orderNo"
       ,P.ORDER_LINE                                        AS "orderLine"
       ,P.PROD_HOGI                                         AS "prodHogi"
       ,P.MODEL_NO                                          AS "modelNo"
       ,P.INDUE_DATE                                        AS "indueDate"
       ,SH.CUSTOMER                                         AS "customer"
       ,IFNULL(WM.WORK_FLAG, '0')                           AS "workFlag"
       ,WM.SCOMMENT                                         AS "scomment"
       ,IFNULL(WM.MDFY_EMP, WM.REG_EMP)                    AS "chkEmp"
       ,IFNULL(DATE_FORMAT(WM.MDFY_DATE, '%Y-%m-%d %H:%i:%s'),
               DATE_FORMAT(WM.REG_DATE, '%Y-%m-%d %H:%i:%s')) AS "chkDate"
       ,E.EMP_NAME                                          AS "chkEmpName"
       ,CASE WHEN NAM.PROD_CODE IS NOT NULL THEN '1' ELSE '0' END AS "isNam"
       ,MC.MC_NO                                            AS "mcNo"
    FROM TSHP_NG_FILE_CHK FC
    LEFT JOIN TSHP_WORKORDER W
        ON FC.PLT_CODE = W.PLT_CODE AND FC.WO_NO = W.WO_NO
    LEFT JOIN TORD_PRODUCT P
        ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
    LEFT JOIN IF_SAP_SHIPINFO SH
        ON P.ORDER_NO = SH.ORDER_NO AND P.ORDER_LINE = SH.ORDER_LINE
    LEFT JOIN TSHP_NG_FILE_WORK_MASTER WM
        ON P.PLT_CODE = WM.PLT_CODE AND P.PROD_CODE = WM.PROD_CODE
    LEFT JOIN TSTD_EMPLOYEE E
        ON WM.PLT_CODE = E.PLT_CODE
       AND IFNULL(WM.MDFY_EMP, WM.REG_EMP) = E.EMP_CODE
    LEFT JOIN TSTD_MODEL M
        ON P.PLT_CODE = M.PLT_CODE
       AND P.MODEL_TYPE = M.MODEL_TYPE
       AND P.MODEL_SERISE = M.MODEL_SERISE
       AND P.MODEL_NO = M.MODEL_NO
    /* NAM 공정 존재 여부 서브쿼리 */
    LEFT JOIN (
        SELECT PLT_CODE, PROD_CODE
        FROM TSHP_WORKORDER
        WHERE WO_FLAG = '4'
          AND PROC_CODE = 'NAM-10'
          AND DATA_FLAG = '0'
          AND PLANTS = '3603'
        GROUP BY PLT_CODE, PROD_CODE
    ) NAM ON W.PLT_CODE = NAM.PLT_CODE AND W.PROD_CODE = NAM.PROD_CODE
    /* 최신 MC_NO 서브쿼리 (NAM 공정, REG_DATE DESC 기준 1건) */
    LEFT JOIN (
        SELECT MCN.PLT_CODE, MCN.PROD_CODE, MCN.MC_NO
        FROM (
            SELECT PLT_CODE, PROD_CODE, MC_NO, REG_DATE,
                   ROW_NUMBER() OVER(PARTITION BY PROD_CODE ORDER BY REG_DATE DESC) AS WO_SEQ
            FROM TSHP_WORKORDER
            WHERE MPROC_CODE = 'NAM'
              AND DATA_FLAG = '0'
              AND PLANTS = '3603'
              AND MC_NO IS NOT NULL
        ) MCN WHERE MCN.WO_SEQ = 1
    ) MC ON W.PLT_CODE = MC.PLT_CODE AND W.PROD_CODE = MC.PROD_CODE
    WHERE FC.PLT_CODE = p_plt_code
      /* 동적 조건: 납기일 범위 */
      AND (p_s_indue_date IS NULL OR p_s_indue_date = '' OR P.INDUE_DATE >= p_s_indue_date)
      AND (p_e_indue_date IS NULL OR p_e_indue_date = '' OR P.INDUE_DATE <= p_e_indue_date)
      /* 동적 조건: 호기 LIKE */
      AND (p_hogi_like IS NULL OR p_hogi_like = '' OR P.PROD_HOGI LIKE CONCAT('%', p_hogi_like, '%'))
      /* 동적 조건: 오더번호 LIKE */
      AND (p_order_like IS NULL OR p_order_like = '' OR P.ORDER_NO LIKE CONCAT('%', p_order_like, '%'))
      /* 동적 조건: 고객명 LIKE */
      AND (p_customer_like IS NULL OR p_customer_like = '' OR SH.CUSTOMER LIKE CONCAT('%', p_customer_like, '%'))
      /* 동적 조건: 제품코드 (정확 일치) */
      AND (p_prod_code IS NULL OR p_prod_code = '' OR P.PROD_CODE = p_prod_code)
      /* 동적 조건: 제품유형 (정확 일치) */
      AND (p_prod_type IS NULL OR p_prod_type = '' OR M.PROD_TYPE = p_prod_type)
      /* 동적 조건: MC번호 LIKE */
      AND (p_mc_no_like IS NULL OR p_mc_no_like = '' OR MC.MC_NO LIKE CONCAT('%', p_mc_no_like, '%'))
    GROUP BY FC.PLT_CODE, P.INDUE_DATE, P.PROD_CODE, P.ORDER_NO, P.ORDER_LINE,
             P.PROD_HOGI, P.MODEL_NO, SH.CUSTOMER, WM.WORK_FLAG, WM.SCOMMENT,
             IFNULL(WM.MDFY_EMP, WM.REG_EMP), E.EMP_NAME, M.PROD_TYPE,
             CASE WHEN NAM.PROD_CODE IS NOT NULL THEN '1' ELSE '0' END,
             MC.MC_NO,
             IFNULL(DATE_FORMAT(WM.MDFY_DATE, '%Y-%m-%d %H:%i:%s'),
                    DATE_FORMAT(WM.REG_DATE, '%Y-%m-%d %H:%i:%s'))
    ORDER BY P.INDUE_DATE;
END//


-- ============================================================
-- 2. sp_imes_tshp_ng_file_chk_query23: 상세 조회 (파일 목록)
-- 원본: POP55A.POP55A_SER2() → QUERY23
-- 용도: POP55A Grid2 선택 제품의 NG 파일 목록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_ng_file_chk_query23//

CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tshp_ng_file_chk_query23(
    IN p_plt_code  VARCHAR(10),     /* 공장코드 */
    IN p_prod_code VARCHAR(50),     /* 제품코드 */
    IN p_model     VARCHAR(100)     /* 모델번호 */
)
BEGIN
    SELECT
        FC.PLT_CODE                                          AS "pltCode"
       ,FC.FILE_ID                                           AS "fileId"
       ,FM.FILE_NAME                                         AS "fileName"
       ,FC.PROC_CODE                                         AS "procCode"
       ,FC.WO_NO                                             AS "woNo"
       ,FC.EMP_CODE                                          AS "empCode"
       ,WE.EMP_NAME                                          AS "empName"
       ,DATE_FORMAT(FC.REG_DATE, '%Y-%m-%d %H:%i:%s')       AS "chkRegDate"
       ,DATE_FORMAT(FM.REG_DATE, '%Y-%m-%d %H:%i:%s')       AS "regDate"
       ,FM.REG_EMP                                           AS "regEmp"
       ,E.EMP_NAME                                           AS "regEmpName"
       ,FM.DATA_FLAG                                         AS "dataFlag"
    FROM TSHP_NG_FILE_CHK FC
    LEFT JOIN TSHP_WORKORDER W
        ON FC.PLT_CODE = W.PLT_CODE AND FC.WO_NO = W.WO_NO
    LEFT JOIN TORD_PRODUCT P
        ON W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE
    LEFT JOIN IF_SAP_SHIPINFO SH
        ON P.ORDER_NO = SH.ORDER_NO AND P.ORDER_LINE = SH.ORDER_LINE
    LEFT JOIN TSYS_FILELIST_MASTER FM
        ON FC.PLT_CODE = FM.PLT_CODE AND FC.FILE_ID = FM.FILE_ID
    LEFT JOIN TSTD_EMPLOYEE E
        ON FM.PLT_CODE = E.PLT_CODE AND FM.REG_EMP = E.EMP_CODE
    LEFT JOIN TSTD_EMPLOYEE WE
        ON FC.PLT_CODE = WE.PLT_CODE AND FC.EMP_CODE = WE.EMP_CODE
    WHERE FC.PLT_CODE = p_plt_code
      AND P.PROD_CODE = p_prod_code
      AND FC.MODEL = p_model;
END//


DELIMITER ;
