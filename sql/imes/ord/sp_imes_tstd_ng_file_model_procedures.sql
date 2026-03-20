-- ============================================================================
-- TSTD_NG_FILE_MODEL: NG파일 모델 매핑 관련 프로시저
-- ============================================================================
-- 용도: ORD32A Grid2 / D0A Grid1 (선택 파일의 적용 모델)
-- 원본: ProActive TSTD_NG_FILE_MODEL.cs, TSTD_NG_FILE_MODEL_QUERY.cs
-- 작성일: 2026-03-10
-- ============================================================================

-- ============================================================
-- sp_imes_tstd_ng_file_model_ser
--   선택 파일의 적용 모델 조회 (Grid2 / D0A Grid1)
--   JOIN: TSTD_MODEL (모델군/시리즈 가져오기, DATA_TYPE='S', DATA_FLAG=0)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_file_model_ser;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_file_model_ser(
    IN p_plt_code   VARCHAR(3),
    IN p_file_id    VARCHAR(30)
)
BEGIN
    SELECT F.PLT_CODE     AS pltCode
          ,M.MODEL_TYPE   AS modelType
          ,M.MODEL_SERISE AS modelSerise
          ,F.MODEL        AS model
          ,M.SCODE        AS scode
      FROM TSTD_NG_FILE_MODEL F
      LEFT JOIN TSTD_MODEL M
        ON F.PLT_CODE = M.PLT_CODE
       AND F.MODEL    = M.MODEL_NO
       AND M.DATA_TYPE = 'S'
       AND M.DATA_FLAG = 0
     WHERE F.PLT_CODE = p_plt_code
       AND F.FILE_ID  = p_file_id;
END$$
DELIMITER ;


-- ============================================================
-- sp_imes_tstd_ng_file_model_del
--   모델 매핑 전체 삭제 (FILE_ID 단위)
--   용도: ORD32A_INS 저장 시 기존 매핑 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_file_model_del;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_file_model_del(
    IN p_plt_code   VARCHAR(3),
    IN p_file_id    VARCHAR(30)
)
BEGIN
    DELETE FROM TSTD_NG_FILE_MODEL
     WHERE PLT_CODE = p_plt_code
       AND FILE_ID  = p_file_id;
END$$
DELIMITER ;


-- ============================================================
-- sp_imes_tstd_ng_file_model_ins
--   모델 매핑 개별 등록
--   용도: ORD32A_INS 저장 시 선택된 모델 행별 INSERT
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_ng_file_model_ins;
DELIMITER $$
CREATE DEFINER=`lstaadm`@`%` PROCEDURE sp_imes_tstd_ng_file_model_ins(
    IN p_plt_code   VARCHAR(3),
    IN p_file_id    VARCHAR(30),
    IN p_model      VARCHAR(50),
    IN p_user_id    VARCHAR(50)
)
BEGIN
    INSERT INTO TSTD_NG_FILE_MODEL (PLT_CODE, FILE_ID, MODEL, REG_DATE, REG_EMP)
    VALUES (p_plt_code, p_file_id, p_model, NOW(), p_user_id);
END$$
DELIMITER ;
