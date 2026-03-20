-- ============================================================
-- LSE_STD_PARTINS 테이블 CRUD 프로시저
-- 부품-검사그룹 연계 관리 (QCT06A)
-- 작성자: 송우석
-- ============================================================

DELIMITER //

-- 중복 체크 (연계 존재 여부)
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_ser//
CREATE PROCEDURE sp_imes_lse_std_partins_ser(
    IN p_pltCode      VARCHAR(3),
    IN p_partCode     VARCHAR(30),
    IN p_insGrpCode   VARCHAR(20)
)
BEGIN
    SELECT PLT_CODE   AS pltCode
         , PART_CODE  AS partCode
         , INS_GRP_CODE AS insGrpCode
         , INS_GRP_SEQ  AS insGrpSeq
      FROM LSE_STD_PARTINS
     WHERE PLT_CODE     = p_pltCode
       AND PART_CODE    = p_partCode
       AND INS_GRP_CODE = p_insGrpCode;
END//

-- MAX 순번 조회
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_ser3//
CREATE PROCEDURE sp_imes_lse_std_partins_ser3(
    IN p_pltCode  VARCHAR(3),
    IN p_partCode VARCHAR(30)
)
BEGIN
    SELECT IFNULL(MAX(INS_GRP_SEQ), 0) AS insGrpMax
      FROM LSE_STD_PARTINS
     WHERE PLT_CODE  = p_pltCode
       AND PART_CODE = p_partCode;
END//

-- 연계 등록
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_ins//
CREATE PROCEDURE sp_imes_lse_std_partins_ins(
    IN p_pltCode    VARCHAR(3),
    IN p_partCode   VARCHAR(30),
    IN p_insGrpCode VARCHAR(20),
    IN p_insGrpSeq  INT,
    IN p_regEmp     VARCHAR(30)
)
BEGIN
    INSERT INTO LSE_STD_PARTINS (
        PLT_CODE, PART_CODE, INS_GRP_CODE, INS_GRP_SEQ, REG_DATE, REG_EMP
    ) VALUES (
        p_pltCode, p_partCode, p_insGrpCode, p_insGrpSeq, NOW(), p_regEmp
    );
END//

-- 순번 수정
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_upd//
CREATE PROCEDURE sp_imes_lse_std_partins_upd(
    IN p_pltCode    VARCHAR(3),
    IN p_partCode   VARCHAR(30),
    IN p_insGrpCode VARCHAR(20),
    IN p_insGrpSeq  INT
)
BEGIN
    UPDATE LSE_STD_PARTINS
       SET INS_GRP_SEQ = p_insGrpSeq
     WHERE PLT_CODE     = p_pltCode
       AND PART_CODE    = p_partCode
       AND INS_GRP_CODE = p_insGrpCode;
END//

-- 연계 삭제
DROP PROCEDURE IF EXISTS sp_imes_lse_std_partins_del//
CREATE PROCEDURE sp_imes_lse_std_partins_del(
    IN p_pltCode    VARCHAR(3),
    IN p_partCode   VARCHAR(30),
    IN p_insGrpCode VARCHAR(20)
)
BEGIN
    DELETE FROM LSE_STD_PARTINS
     WHERE PLT_CODE     = p_pltCode
       AND PART_CODE    = p_partCode
       AND INS_GRP_CODE = p_insGrpCode;
END//

DELIMITER ;
