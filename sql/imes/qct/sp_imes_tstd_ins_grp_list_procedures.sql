-- ============================================================================
-- TSTD_INS_GRP_LIST CRUD 프로시저 (2개)
-- 검사그룹-항목 연결: INS, DEL3
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-27
-- ============================================================================

DELIMITER //

-- ============================================================================
-- sp_imes_tstd_ins_grp_list_ins
-- D1A: 검사그룹 연결 등록 (단건)
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_list_ins//

CREATE PROCEDURE sp_imes_tstd_ins_grp_list_ins(
    IN p_plt_code       VARCHAR(3),
    IN p_ins_grp_code   VARCHAR(20),
    IN p_ins_code       VARCHAR(20),
    IN p_ins_seq        INT,
    IN p_user_id        VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_INS_GRP_LIST (
        PLT_CODE, INS_GRP_CODE, INS_CODE, INS_SEQ, REG_DATE, REG_EMP
    ) VALUES (
        p_plt_code, p_ins_grp_code, p_ins_code, p_ins_seq, NOW(), p_user_id
    );
END//


-- ============================================================================
-- sp_imes_tstd_ins_grp_list_del3
-- D1A: 특정 검사항목의 그룹 연결 전체 삭제
-- ============================================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ins_grp_list_del3//

CREATE PROCEDURE sp_imes_tstd_ins_grp_list_del3(
    IN p_plt_code   VARCHAR(3),
    IN p_ins_code   VARCHAR(20)
)
BEGIN
    DELETE FROM TSTD_INS_GRP_LIST
    WHERE PLT_CODE = p_plt_code
      AND INS_CODE = p_ins_code;
END//

DELIMITER ;
