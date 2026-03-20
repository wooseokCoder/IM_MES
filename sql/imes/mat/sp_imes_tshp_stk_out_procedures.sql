-- ============================================================
-- TSHP_STK_OUT CRUD 프로시저
-- 생성일: 2026-03-04
-- 대상 테이블: TSHP_STK_OUT
-- 원본: ProActive TSHP_STK_OUT.cs
-- 사용화면: MAT05A
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_stk_out_ser3: 출고건 목록 조회 (D1A용)
-- 원본: TSHP_STK_OUT.TSHP_STK_OUT_SER3()
-- 용도: MAT05A_SER6 - D1A 불출취소 다이얼로그 출고건 그리드
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_ser3//

CREATE PROCEDURE sp_imes_tshp_stk_out_ser3(
    IN p_plt_code    VARCHAR(3),
    IN p_sap_wo_no   VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE      AS pltCode,
        STK_OUT_NO    AS stkOutNo,
        PROD_CODE     AS prodCode,
        WO_NO         AS woNo,
        PROC_CODE     AS procCode,
        SAP_WO_NO     AS sapWoNo,
        MRP_EMP       AS mrpEmp,
        DATE_FORMAT(REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        REG_EMP       AS regEmp
    FROM TSHP_STK_OUT
    WHERE PLT_CODE = p_plt_code
      AND SAP_WO_NO = p_sap_wo_no
    ORDER BY MRP_EMP;
END//

-- ============================================================
-- sp_imes_tshp_stk_out_ser: 출고건 단건 조회 (존재 확인용)
-- 원본: TSHP_STK_OUT.TSHP_STK_OUT_SER()
-- 용도: MAT05A_INS - 기존 출고건 존재 여부 확인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_ser//

CREATE PROCEDURE sp_imes_tshp_stk_out_ser(
    IN p_plt_code    VARCHAR(3),
    IN p_stk_out_no  VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE      AS pltCode,
        STK_OUT_NO    AS stkOutNo,
        PROD_CODE     AS prodCode,
        WO_NO         AS woNo,
        PROC_CODE     AS procCode,
        SAP_WO_NO     AS sapWoNo,
        MRP_EMP       AS mrpEmp,
        REG_DATE      AS regDate,
        REG_EMP       AS regEmp
    FROM TSHP_STK_OUT
    WHERE PLT_CODE = p_plt_code
      AND STK_OUT_NO = p_stk_out_no;
END//

-- ============================================================
-- sp_imes_tshp_stk_out_ins: 출고건 등록
-- 원본: TSHP_STK_OUT.TSHP_STK_OUT_INS()
-- 용도: MAT05A_INS - 현장불출 시 출고 헤더 생성
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_ins//

CREATE PROCEDURE sp_imes_tshp_stk_out_ins(
    IN p_plt_code    VARCHAR(3),
    IN p_stk_out_no  VARCHAR(50),
    IN p_prod_code   VARCHAR(50),
    IN p_wo_no       VARCHAR(50),
    IN p_proc_code   VARCHAR(50),
    IN p_sap_wo_no   VARCHAR(50),
    IN p_mrp_emp     VARCHAR(50),
    IN p_reg_emp     VARCHAR(20)
)
BEGIN
    INSERT INTO TSHP_STK_OUT (
        PLT_CODE, STK_OUT_NO, PROD_CODE, WO_NO,
        PROC_CODE, SAP_WO_NO, MRP_EMP,
        REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_stk_out_no, p_prod_code, p_wo_no,
        p_proc_code, p_sap_wo_no, p_mrp_emp,
        NOW(), p_reg_emp
    );
END//

-- ============================================================
-- sp_imes_tshp_stk_out_upd: 출고건 불출율 업데이트
-- 원본: TSHP_STK_OUT.TSHP_STK_OUT_UPD()
-- 용도: MAT05A_INS - 불출율 갱신
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_upd//

CREATE PROCEDURE sp_imes_tshp_stk_out_upd(
    IN p_plt_code    VARCHAR(3),
    IN p_stk_out_no  VARCHAR(50),
    IN p_out_rate    DECIMAL(10,2)
)
BEGIN
    UPDATE TSHP_STK_OUT
       SET OUT_RATE = p_out_rate
     WHERE PLT_CODE = p_plt_code
       AND STK_OUT_NO = p_stk_out_no;
END//

-- ============================================================
-- sp_imes_tshp_stk_out_ser2: 출고건 목록 조회 (WO_NO 기준)
-- 원본: TSHP_STK_OUT.TSHP_STK_OUT_SER2()
-- 용도: MAT05A_INS/DEL - 불출율 계산 시 해당 WO의 모든 STK_OUT 조회
-- 추가일: 2026-03-05
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_ser2//

CREATE PROCEDURE sp_imes_tshp_stk_out_ser2(
    IN p_plt_code  VARCHAR(3),
    IN p_wo_no     VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE      AS pltCode,
        STK_OUT_NO    AS stkOutNo,
        PROD_CODE     AS prodCode,
        WO_NO         AS woNo,
        PROC_CODE     AS procCode,
        SAP_WO_NO     AS sapWoNo,
        MRP_EMP       AS mrpEmp,
        REG_DATE      AS regDate,
        REG_EMP       AS regEmp
    FROM TSHP_STK_OUT
    WHERE PLT_CODE = p_plt_code
      AND WO_NO = p_wo_no;
END//

DELIMITER ;
