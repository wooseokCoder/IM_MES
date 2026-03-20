-- ============================================================
-- TSHP_WORKORDER_HIS 프로시저
-- 생성일: 2026-02-24
-- 대상 테이블: TSHP_WORKORDER_HIS, TSTD_PROCGRP, LSE_STD_PROC
-- 원본: ProActive TSHP_WORKORDER_HIS.cs
-- ============================================================
-- 명명 규칙: sp_imes_tshp_workorder_his_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_workorder_his_ins: 확정/취소 이력 등록
-- 원본: TSHP_WORKORDER_HIS.TSHP_WORKORDER_HIS_INS()
-- 용도: 확정 또는 확정취소 시 이력 INSERT
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_his_ins//

CREATE PROCEDURE sp_imes_tshp_workorder_his_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_wo_no      VARCHAR(50),
    IN p_proc_code  VARCHAR(20),
    IN p_prod_hogi  VARCHAR(50),
    IN p_wo_flag    VARCHAR(1),
    IN p_mdfy_emp   VARCHAR(20)
)
BEGIN
    INSERT INTO TSHP_WORKORDER_HIS (
        PLT_CODE, WO_NO, PROC_CODE, PROD_HOGI, WO_FLAG, MDFY_DATE, MDFY_EMP
    ) VALUES (
        p_plt_code, p_wo_no, p_proc_code, p_prod_hogi, p_wo_flag, NOW(), p_mdfy_emp
    );
END//

-- ============================================================
-- sp_imes_tshp_workorder_his_ser: WO_NO별 확정이력 조회
-- 원본: TSHP_WORKORDER_HIS.TSHP_WORKORDER_HIS_SER()
-- 용도: 확정 이력 보기 팝업
-- 사용화면: ORD06A
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_workorder_his_ser//

CREATE PROCEDURE sp_imes_tshp_workorder_his_ser(
    IN p_plt_code  VARCHAR(3),
    IN p_wo_no     VARCHAR(50)
)
BEGIN
    SELECT
        HIS.PLT_CODE    AS pltCode,
        HIS.WO_NO       AS woNo,
        HIS.PROC_CODE   AS procCode,
        IFNULL(PG.PRG_NAME, SP.PROC_NAME) AS procName,
        HIS.PROD_HOGI   AS prodHogi,
        HIS.WO_FLAG     AS woFlag,
        DATE_FORMAT(HIS.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        HIS.MDFY_EMP    AS mdfyEmp
    FROM TSHP_WORKORDER_HIS HIS
    LEFT JOIN TSTD_PROCGRP PG
        ON HIS.PROC_CODE = PG.PRG_CODE
    LEFT JOIN LSE_STD_PROC SP
        ON HIS.PROC_CODE = SP.PROC_CODE
    WHERE HIS.PLT_CODE = p_plt_code
      AND HIS.WO_NO = p_wo_no
    ORDER BY HIS.MDFY_DATE;
END//

DELIMITER ;
