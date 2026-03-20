-- ============================================================
-- TSHP_STK_OUT_PART CRUD 프로시저
-- 생성일: 2026-03-04
-- 대상 테이블: TSHP_STK_OUT_PART
-- 원본: ProActive TSHP_STK_OUT_PART.cs
-- 사용화면: MAT05A
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tshp_stk_out_part_ser: 불출자재 단건 조회 (존재 확인용)
-- 원본: TSHP_STK_OUT_PART.TSHP_STK_OUT_PART_SER()
-- 용도: MAT05A_INS/DEL - 기존 불출자재 존재 여부 확인
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_part_ser//

CREATE PROCEDURE sp_imes_tshp_stk_out_part_ser(
    IN p_plt_code         VARCHAR(3),
    IN p_stk_out_no       VARCHAR(50),
    IN p_stk_out_part_no  VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE          AS pltCode,
        STK_OUT_NO        AS stkOutNo,
        STK_OUT_PART_NO   AS stkOutPartNo,
        PART_CODE         AS partCode,
        OUT_FLAG          AS outFlag,
        REG_DATE          AS regDate,
        REG_EMP           AS regEmp
    FROM TSHP_STK_OUT_PART
    WHERE PLT_CODE = p_plt_code
      AND STK_OUT_NO = p_stk_out_no
      AND STK_OUT_PART_NO = p_stk_out_part_no;
END//

-- ============================================================
-- sp_imes_tshp_stk_out_part_ins: 불출자재 등록
-- 원본: TSHP_STK_OUT_PART.TSHP_STK_OUT_PART_INS()
-- 용도: MAT05A_INS - 현장불출 시 자재 상세 생성
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_part_ins//

CREATE PROCEDURE sp_imes_tshp_stk_out_part_ins(
    IN p_plt_code         VARCHAR(3),
    IN p_stk_out_no       VARCHAR(50),
    IN p_stk_out_part_no  VARCHAR(50),
    IN p_part_code        VARCHAR(50),
    IN p_out_flag         VARCHAR(1),
    IN p_reg_emp          VARCHAR(20)
)
BEGIN
    INSERT INTO TSHP_STK_OUT_PART (
        PLT_CODE, STK_OUT_NO, STK_OUT_PART_NO,
        PART_CODE, OUT_FLAG,
        REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_stk_out_no, p_stk_out_part_no,
        p_part_code, p_out_flag,
        NOW(), p_reg_emp
    );
END//

-- ============================================================
-- sp_imes_tshp_stk_out_part_upd: 불출자재 상태 업데이트
-- 원본: TSHP_STK_OUT_PART.TSHP_STK_OUT_PART_UPD()
-- 용도: MAT05A_INS/DEL - OUT_FLAG 변경 (불출/취소)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_part_upd//

CREATE PROCEDURE sp_imes_tshp_stk_out_part_upd(
    IN p_plt_code         VARCHAR(3),
    IN p_stk_out_no       VARCHAR(50),
    IN p_stk_out_part_no  VARCHAR(50),
    IN p_part_code        VARCHAR(50),
    IN p_out_flag         VARCHAR(1)
)
BEGIN
    UPDATE TSHP_STK_OUT_PART
       SET PART_CODE = p_part_code,
           OUT_FLAG  = p_out_flag
     WHERE PLT_CODE = p_plt_code
       AND STK_OUT_NO = p_stk_out_no
       AND STK_OUT_PART_NO = p_stk_out_part_no;
END//

-- ============================================================
-- sp_imes_tshp_stk_out_part_ser2: 불출자재 목록 조회 (STK_OUT_NO 기준)
-- 원본: TSHP_STK_OUT_PART.TSHP_STK_OUT_PART_SER2()
-- 용도: MAT05A_INS/DEL - MAT_OUT_RATE_MES 분자 계산 시
--       해당 STK_OUT_NO의 모든 PART 조회
-- 추가일: 2026-03-05
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tshp_stk_out_part_ser2//

CREATE PROCEDURE sp_imes_tshp_stk_out_part_ser2(
    IN p_plt_code    VARCHAR(3),
    IN p_stk_out_no  VARCHAR(50)
)
BEGIN
    SELECT
        PLT_CODE          AS pltCode,
        STK_OUT_NO        AS stkOutNo,
        STK_OUT_PART_NO   AS stkOutPartNo,
        PART_CODE         AS partCode,
        OUT_FLAG          AS outFlag,
        REG_DATE          AS regDate,
        REG_EMP           AS regEmp
    FROM TSHP_STK_OUT_PART
    WHERE PLT_CODE = p_plt_code
      AND STK_OUT_NO = p_stk_out_no;
END//

DELIMITER ;
