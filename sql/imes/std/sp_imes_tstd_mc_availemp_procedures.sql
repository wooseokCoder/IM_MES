-- ============================================================================
-- TSTD_MC_AVAILEMP CRUD 프로시저 (2개)
-- 설비 가용사원: DEL, INS
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-23
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_mc_availemp_del
-- 설비별 가용사원 전체 삭제 (PLT_CODE + MC_CODE)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_availemp_del//

CREATE PROCEDURE sp_imes_tstd_mc_availemp_del(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10)
)
BEGIN
    DELETE FROM TSTD_MC_AVAILEMP
    WHERE PLT_CODE = p_plt_code
      AND MC_CODE = p_mc_code;
END//

-- ============================================================================
-- sp_imes_tstd_mc_availemp_ins
-- 설비 가용사원 등록
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_mc_availemp_ins//

CREATE PROCEDURE sp_imes_tstd_mc_availemp_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_mc_code    VARCHAR(10),
    IN p_emp_code   VARCHAR(10),
    IN p_emp_seq    INT
)
BEGIN
    INSERT INTO TSTD_MC_AVAILEMP (
        PLT_CODE, MC_CODE, EMP_CODE, EMP_SEQ
    ) VALUES (
        p_plt_code, p_mc_code, p_emp_code, p_emp_seq
    );
END//

DELIMITER ;
