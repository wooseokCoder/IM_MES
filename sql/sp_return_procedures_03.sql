-- ============================================================
-- Return.xml -> 프로시저 전환 스크립트 (Part 3)
-- namespace: com.wsc.common.rt.Return
-- 내용: Check 관련 프로시저
-- 생성일: 2026-01-15
-- ============================================================

DELIMITER //

-- ============================================================
-- 32. [getCheckItem] 체크 아이템 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_check_item//
CREATE PROCEDURE sp_return_get_check_item(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT CHEK_AREA
          ,CHEK_ITEM
          ,CHEK_METH
          ,CHEK_STAT
          ,CHEK_DECN
          ,ABNO_CONT
          ,CHEK_REMK
          ,(SELECT COUNT(1) FROM retn_chek_item B WHERE B.CHEK_AREA = A.CHEK_AREA AND B.RETN_NO = A.RETN_NO) AS ROWSPAN
          ,RETN_NO AS formatNo
          ,CHEK_SEQ
      FROM retn_chek_item A
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = (SELECT retn_no FROM retn_chek_item WHERE RETN_NO IN ('20210101', p_retn_no) ORDER BY RETN_NO DESC LIMIT 1)
     ORDER BY CHEK_SEQ;
END//

-- ============================================================
-- 33. [getCheckMiss] 체크 누락 파트 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_check_miss//
CREATE PROCEDURE sp_return_get_check_miss(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT ITEM_CODE
          ,ITEM_NAME
          ,ITEM_QTY
          ,ITEM_CONT
          ,'I' AS oper
      FROM retn_chek_part
     WHERE SYS_ID = 'IMMES'
       AND RETN_NO = p_retn_no
     ORDER BY ITEM_CODE;
END//

-- ============================================================
-- 34. [getGrad] 등급 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_grad//
CREATE PROCEDURE sp_return_get_grad(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT EVAL_TYPE
          ,EVAL_CONT
          ,EVAL_PONT
          ,EVAL_STD
          ,(SELECT COUNT(1) FROM retn_chek_grad B WHERE B.EVAL_TYPE = A.EVAL_TYPE AND B.RETN_NO = A.RETN_NO) AS COLSPAN
          ,RETN_NO AS formatNo
          ,EVAL_SEQ
      FROM retn_chek_grad A
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = (SELECT retn_no FROM retn_chek_grad WHERE RETN_NO IN ('20210101', p_retn_no) ORDER BY RETN_NO DESC LIMIT 1)
     ORDER BY EVAL_TYPE, EVAL_SEQ;
END//

-- ============================================================
-- 35. [getCheckInfo] 체크 정보 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_check_info//
CREATE PROCEDURE sp_return_get_check_info(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT OM.ORDR_NO AS RETN_NO
          ,OM.ORDR_TYPE AS RETN_TYPE
          ,fn_get_code_name('RETURN_TYPE', OM.ORDR_TYPE, 'en') AS RETN_TYPE_NAME
          ,OM.REGI_DATE
          ,OM.REGI_ID
          ,OM.DEAL_CODE
          ,OM.DEAL_NAME
          ,OM.SHIP_TO_ADDRESS1
          ,INSP_DATE
          ,INSP_USER
          ,CASE WHEN IFNULL(RETN_MODL, '') = '' THEN OI.ITEM_MODL ELSE RETN_MODL END AS RETN_MODL
          ,RETN_CHAS_NO
          ,RETN_ENGN_NO
          ,RETN_WORK_HOUR
          ,INSP_TOT_GRAD
          ,INSP_GRAD_A
          ,INSP_GRAD_B
          ,INSP_GRAD_C
          ,APPR_REQR
          ,APPR_MNGR
          ,RETN_REMK
          ,SALED_DATE
          ,CHEK_DATE
      FROM ORDR_MAST OM
           LEFT OUTER JOIN RETN_CHEK_MAST RCM ON RCM.SYS_ID = OM.SYS_ID AND OM.ORDR_NO = RCM.RETN_NO
           LEFT OUTER JOIN ordr_item OI ON OM.SYS_ID = OI.SYS_ID AND OM.ORDR_NO = OI.ORDR_NO AND OI.ITEM_TYPE = 'TR'
     WHERE OM.SYS_ID = p_sys_id
       AND OM.ORDR_NO = p_retn_no;
END//

-- ============================================================
-- 36. [getCheckAttLL] 체크 첨부 LL 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_check_att_ll//
CREATE PROCEDURE sp_return_get_check_att_ll(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT 'LL' AS ITEM_TYPE
          ,ITEM_MODL AS ITEM_MODL
          ,ITEM_SERI_NO AS ITEM_SERI_NO
          ,ITEM_BUCK_IDX AS ITEM_BUCK_IDX
          ,ITEM_REMK AS ITEM_REMK
          ,1 AS seq
      FROM retn_chek_atta
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no
       AND ITEM_TYPE = 'LL'
     UNION
    SELECT ITEM_TYPE AS ITEM_TYPE
          ,ITEM_MODL AS ITEM_MODL
          ,SHIP_SERI_NO AS ITEM_SERI_NO
          ,'' AS ITEM_BUCK_IDX
          ,'' AS ITEM_REMK
          ,2 AS seq
      FROM ordr_item
     WHERE SYS_ID = p_sys_id
       AND ORDR_NO = p_retn_no
       AND ITEM_TYPE = 'LL'
     ORDER BY seq
     LIMIT 1;
END//

-- ============================================================
-- 37. [getCheckAttLB] 체크 첨부 LB 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_check_att_lb//
CREATE PROCEDURE sp_return_get_check_att_lb(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT 'LB' AS ITEM_TYPE
          ,ITEM_MODL AS ITEM_MODL
          ,ITEM_SERI_NO AS ITEM_SERI_NO
          ,ITEM_BUCK_IDX AS ITEM_BUCK_IDX
          ,ITEM_REMK AS ITEM_REMK
          ,1 AS seq
      FROM retn_chek_atta
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no
       AND ITEM_TYPE = 'LB'
     UNION
    SELECT ITEM_TYPE AS ITEM_TYPE
          ,ITEM_MODL AS ITEM_MODL
          ,SHIP_SERI_NO AS ITEM_SERI_NO
          ,'' AS ITEM_BUCK_IDX
          ,'' AS ITEM_REMK
          ,2 AS seq
      FROM ordr_item
     WHERE SYS_ID = p_sys_id
       AND ORDR_NO = p_retn_no
       AND ITEM_TYPE = 'LB'
     ORDER BY seq
     LIMIT 1;
END//

-- ============================================================
-- 38. [getCheckAttOTH] 체크 첨부 OTH 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_get_check_att_oth//
CREATE PROCEDURE sp_return_get_check_att_oth(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT 'OTH' AS ITEM_TYPE
          ,ITEM_MODL AS ITEM_MODL
          ,ITEM_SERI_NO AS ITEM_SERI_NO
          ,ITEM_BUCK_IDX AS ITEM_BUCK_IDX
          ,ITEM_REMK AS ITEM_REMK
          ,1 AS seq
      FROM retn_chek_atta
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no
       AND ITEM_TYPE = 'OTH'
     UNION
    SELECT 'OTH' AS ITEM_TYPE
          ,ITEM_MODL AS ITEM_MODL
          ,SHIP_SERI_NO AS ITEM_SERI_NO
          ,'' AS ITEM_BUCK_IDX
          ,'' AS ITEM_REMK
          ,2 AS seq
      FROM ordr_item
     WHERE SYS_ID = p_sys_id
       AND ORDR_NO = p_retn_no
       AND ITEM_TYPE IN ('LM')
     ORDER BY seq
     LIMIT 1;
END//

-- ============================================================
-- 39. [mastSelectCnt] 마스터 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_mast_select_cnt//
CREATE PROCEDURE sp_return_mast_select_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM RETN_CHEK_MAST
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 40. [mastUpdate] 마스터 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_mast_update//
CREATE PROCEDURE sp_return_mast_update(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_ws_date VARCHAR(20),
    IN p_check_date VARCHAR(20),
    IN p_trmodel VARCHAR(50),
    IN p_chassis VARCHAR(50),
    IN p_engine VARCHAR(50),
    IN p_work_h VARCHAR(20),
    IN p_insp_tot_grad VARCHAR(10),
    IN p_insp_grad_a VARCHAR(10),
    IN p_insp_grad_b VARCHAR(10),
    IN p_insp_grad_c VARCHAR(10),
    IN p_retn_remk VARCHAR(1000),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE RETN_CHEK_MAST
       SET INSP_DATE = NOW()
          ,INSP_USER = p_gs_user_id
          ,SALED_DATE = CASE WHEN p_ws_date IS NOT NULL AND p_ws_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_ws_date)) ELSE SALED_DATE END
          ,CHEK_DATE = CASE WHEN p_check_date IS NOT NULL AND p_check_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_check_date)) ELSE CHEK_DATE END
          ,RETN_MODL = p_trmodel
          ,RETN_CHAS_NO = p_chassis
          ,RETN_ENGN_NO = p_engine
          ,RETN_WORK_HOUR = p_work_h
          ,INSP_TOT_GRAD = p_insp_tot_grad
          ,INSP_GRAD_A = p_insp_grad_a
          ,INSP_GRAD_B = p_insp_grad_b
          ,INSP_GRAD_C = p_insp_grad_c
          ,APPR_REQR = p_gs_user_id
          ,RETN_REMK = p_retn_remk
          ,CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 41. [mastInsert] 마스터 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_mast_insert//
CREATE PROCEDURE sp_return_mast_insert(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_ws_date VARCHAR(20),
    IN p_check_date VARCHAR(20),
    IN p_trmodel VARCHAR(50),
    IN p_chassis VARCHAR(50),
    IN p_engine VARCHAR(50),
    IN p_work_h VARCHAR(20),
    IN p_insp_tot_grad VARCHAR(10),
    IN p_insp_grad_a VARCHAR(10),
    IN p_insp_grad_b VARCHAR(10),
    IN p_insp_grad_c VARCHAR(10),
    IN p_retn_remk VARCHAR(1000),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_CHEK_MAST (
        SYS_ID, RETN_NO, SALED_DATE, CHEK_DATE,
        INSP_DATE, INSP_USER, RETN_MODL, RETN_CHAS_NO, RETN_ENGN_NO, RETN_WORK_HOUR,
        INSP_TOT_GRAD, INSP_GRAD_A, INSP_GRAD_B, INSP_GRAD_C,
        APPR_REQR, RETN_REMK, USE_IDX, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id,
        p_retn_no,
        CASE WHEN p_ws_date IS NOT NULL AND p_ws_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_ws_date)) ELSE NULL END,
        CASE WHEN p_check_date IS NOT NULL AND p_check_date != '' THEN FN_CONV_DATE(fn_null_date_fr(p_check_date)) ELSE NULL END,
        NOW(),
        p_gs_user_id,
        p_trmodel,
        p_chassis,
        p_engine,
        p_work_h,
        p_insp_tot_grad,
        p_insp_grad_a,
        p_insp_grad_b,
        p_insp_grad_c,
        p_gs_user_id,
        p_retn_remk,
        'Y',
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 42. [gradSelectCnt] 등급 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_grad_select_cnt//
CREATE PROCEDURE sp_return_grad_select_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM RETN_CHEK_GRAD
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 43. [gradUpdate] 등급 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_grad_update//
CREATE PROCEDURE sp_return_grad_update(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_grad_eval_type VARCHAR(20),
    IN p_grad_eval_seq INT,
    IN p_grad_eval_pont VARCHAR(20),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE RETN_CHEK_GRAD
       SET EVAL_PONT = p_grad_eval_pont
          ,CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no
       AND EVAL_TYPE = p_grad_eval_type
       AND EVAL_SEQ = p_grad_eval_seq;
END//

-- ============================================================
-- 44. [gradInsert] 등급 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_grad_insert//
CREATE PROCEDURE sp_return_grad_insert(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_grad_eval_type VARCHAR(20),
    IN p_grad_eval_seq INT,
    IN p_grad_format_no VARCHAR(50),
    IN p_grad_eval_pont VARCHAR(20),
    IN p_eval_idx VARCHAR(50),
    IN p_eval_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_CHEK_GRAD (
        SYS_ID, RETN_NO, EVAL_TYPE, EVAL_SEQ, EVAL_CONT, EVAL_PONT, EVAL_IDX, EVAL_STD, EVAL_REMK,
        USE_IDX, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id,
        p_retn_no,
        p_grad_eval_type,
        p_grad_eval_seq,
        (SELECT ST.EVAL_CONT FROM RETN_CHEK_GRAD ST WHERE ST.RETN_NO = p_grad_format_no AND ST.EVAL_TYPE = p_grad_eval_type AND ST.EVAL_SEQ = p_grad_eval_seq),
        p_grad_eval_pont,
        p_eval_idx,
        (SELECT ST.EVAL_STD FROM RETN_CHEK_GRAD ST WHERE ST.RETN_NO = p_grad_format_no AND ST.EVAL_TYPE = p_grad_eval_type AND ST.EVAL_SEQ = p_grad_eval_seq),
        p_eval_remk,
        'Y',
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 45. [checkItemSelectCnt] 체크 아이템 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_item_select_cnt//
CREATE PROCEDURE sp_return_check_item_select_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM RETN_CHEK_ITEM
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 46. [checkItemUpdate] 체크 아이템 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_item_update//
CREATE PROCEDURE sp_return_check_item_update(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_ci_chek_seq INT,
    IN p_ci_chek_stat VARCHAR(20),
    IN p_ci_chek_decn VARCHAR(20),
    IN p_ci_abno_cont VARCHAR(500),
    IN p_ci_chek_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE RETN_CHEK_ITEM
       SET CHEK_STAT = p_ci_chek_stat
          ,CHEK_DECN = p_ci_chek_decn
          ,ABNO_CONT = p_ci_abno_cont
          ,CHEK_REMK = p_ci_chek_remk
          ,CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no
       AND CHEK_SEQ = p_ci_chek_seq;
END//

-- ============================================================
-- 47. [checkItemInsert] 체크 아이템 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_item_insert//
CREATE PROCEDURE sp_return_check_item_insert(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_ci_chek_seq INT,
    IN p_ci_format_no VARCHAR(50),
    IN p_ci_chek_stat VARCHAR(20),
    IN p_ci_chek_decn VARCHAR(20),
    IN p_ci_abno_cont VARCHAR(500),
    IN p_ci_chek_remk VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_CHEK_ITEM (
        SYS_ID, RETN_NO, CHEK_SEQ, CHEK_AREA, CHEK_ITEM, CHEK_METH,
        CHEK_STAT, CHEK_DECN, ABNO_CONT, CHEK_REMK,
        USE_IDX, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id,
        p_retn_no,
        p_ci_chek_seq,
        (SELECT ST.CHEK_AREA FROM RETN_CHEK_ITEM ST WHERE ST.RETN_NO = p_ci_format_no AND ST.CHEK_SEQ = p_ci_chek_seq),
        (SELECT ST.CHEK_ITEM FROM RETN_CHEK_ITEM ST WHERE ST.RETN_NO = p_ci_format_no AND ST.CHEK_SEQ = p_ci_chek_seq),
        (SELECT ST.CHEK_METH FROM RETN_CHEK_ITEM ST WHERE ST.RETN_NO = p_ci_format_no AND ST.CHEK_SEQ = p_ci_chek_seq),
        p_ci_chek_stat,
        p_ci_chek_decn,
        p_ci_abno_cont,
        p_ci_chek_remk,
        'Y',
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 48. [checkAttaSelectCnt] 체크 첨부 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_atta_select_cnt//
CREATE PROCEDURE sp_return_check_atta_select_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM RETN_CHEK_ATTA
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 49. [checkAttaUpdate] 체크 첨부 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_atta_update//
CREATE PROCEDURE sp_return_check_atta_update(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_att_item_type VARCHAR(20),
    IN p_att_model VARCHAR(50),
    IN p_att_seri_no VARCHAR(50),
    IN p_att_bucket VARCHAR(50),
    IN p_att_remark VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE RETN_CHEK_ATTA
       SET ITEM_MODL = p_att_model
          ,ITEM_SERI_NO = p_att_seri_no
          ,ITEM_BUCK_IDX = p_att_bucket
          ,ITEM_REMK = p_att_remark
          ,CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no
       AND ITEM_TYPE = p_att_item_type;
END//

-- ============================================================
-- 50. [checkAttaInsert] 체크 첨부 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_atta_insert//
CREATE PROCEDURE sp_return_check_atta_insert(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_att_item_type VARCHAR(20),
    IN p_att_model VARCHAR(50),
    IN p_att_seri_no VARCHAR(50),
    IN p_att_bucket VARCHAR(50),
    IN p_att_remark VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_CHEK_ATTA (
        SYS_ID, RETN_NO, ITEM_SEQ, ITEM_TYPE, ITEM_MODL, ITEM_SERI_NO, ITEM_BUCK_IDX, ITEM_REMK,
        USE_IDX, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id,
        p_retn_no,
        (SELECT IFNULL(MAX(OI.ITEM_SEQ), 0) + 10 FROM RETN_CHEK_ATTA OI WHERE RETN_NO = p_retn_no),
        p_att_item_type,
        p_att_model,
        p_att_seri_no,
        p_att_bucket,
        p_att_remark,
        'Y',
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 51. [checkPartSelectCnt] 체크 파트 카운트
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_part_select_cnt//
CREATE PROCEDURE sp_return_check_part_select_cnt(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    SELECT COUNT(1) AS cnt
      FROM RETN_CHEK_PART
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 52. [checkPartdelete] 체크 파트 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_part_delete//
CREATE PROCEDURE sp_return_check_part_delete(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_CHEK_PART
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 53. [checkPartInsert] 체크 파트 등록
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_check_part_insert//
CREATE PROCEDURE sp_return_check_part_insert(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_part_item_code VARCHAR(50),
    IN p_part_item_name VARCHAR(200),
    IN p_part_item_qty INT,
    IN p_part_item_cont VARCHAR(500),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    INSERT INTO RETN_CHEK_PART (
        SYS_ID, RETN_NO, ITEM_SEQ, ITEM_CODE, ITEM_NAME, ITEM_QTY, ITEM_CONT,
        USE_IDX, REGI_ID, REGI_DATE
    ) VALUES (
        p_sys_id,
        p_retn_no,
        (SELECT IFNULL(MAX(OI.ITEM_SEQ), 0) + 10 FROM RETN_CHEK_PART OI WHERE RETN_NO = p_retn_no),
        p_part_item_code,
        p_part_item_name,
        CASE WHEN p_part_item_qty IS NOT NULL THEN p_part_item_qty ELSE NULL END,
        p_part_item_cont,
        'Y',
        p_gs_user_id,
        NOW()
    );
END//

-- ============================================================
-- 54. [UpdateCheckAppr] 체크 승인자 수정
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_update_check_appr//
CREATE PROCEDURE sp_return_update_check_appr(
    IN p_sys_id VARCHAR(20),
    IN p_retn_no VARCHAR(50),
    IN p_gs_user_id VARCHAR(50)
)
BEGIN
    UPDATE RETN_CHEK_MAST
       SET APPR_MNGR = p_gs_user_id
          ,CHNG_ID = p_gs_user_id
          ,CHNG_DATE = NOW()
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_retn_no;
END//

-- ============================================================
-- 55. [chekMastDelete] 체크 마스터 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_chek_mast_delete//
CREATE PROCEDURE sp_return_chek_mast_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_CHEK_MAST
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 56. [chekAttaDelete] 체크 첨부 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_chek_atta_delete//
CREATE PROCEDURE sp_return_chek_atta_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_CHEK_ATTA
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 57. [chekGradDelete] 체크 등급 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_chek_grad_delete//
CREATE PROCEDURE sp_return_chek_grad_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_CHEK_GRAD
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 58. [chekItemDelete] 체크 아이템 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_chek_item_delete//
CREATE PROCEDURE sp_return_chek_item_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_CHEK_ITEM
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

-- ============================================================
-- 59. [chekPartDelete] 체크 파트 삭제
-- ============================================================
DROP PROCEDURE IF EXISTS sp_return_chek_part_delete//
CREATE PROCEDURE sp_return_chek_part_delete(
    IN p_sys_id VARCHAR(20),
    IN p_ordr_no VARCHAR(50)
)
BEGIN
    DELETE FROM RETN_CHEK_PART
     WHERE SYS_ID = p_sys_id
       AND RETN_NO = p_ordr_no;
END//

DELIMITER ;
