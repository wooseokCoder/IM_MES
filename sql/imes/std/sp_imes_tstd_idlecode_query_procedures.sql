-- ============================================================
-- TSTD_IDLECODE 조회 프로시저
-- 생성일: 2026-02-05
-- 대상 테이블: TSTD_IDLECODE, TSTD_ORG
-- 원본: ProActive TSTD_IDLECODE_QUERY.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_idlecode_[액션]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_idlecode_query1: 비가동코드 목록 조회 (JOIN)
-- 원본: TSTD_IDLECODE_QUERY.TSTD_IDLECODE_QUERY1()
-- 용도: 메인 그리드 목록 조회
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idlecode_query1//

CREATE PROCEDURE sp_imes_tstd_idlecode_query1(
    IN p_plt_code VARCHAR(10),
    IN p_plants VARCHAR(10),
    IN p_idle_like VARCHAR(100),
    IN p_data_flag INT
)
BEGIN
    SELECT
        I.PLT_CODE AS pltCode,
        I.SCODE AS scode,
        I.PLANTS AS plants,
        I.IDLE_CODE AS idleCode,
        I.SAP_CODE AS sapCode,
        I.IDLE_NAME AS idleName,
        I.MG_TYPE1 AS mgType1,
        I.MG_TYPE2 AS mgType2,
        I.MG_ORG AS mgOrg,
        O.ORG_NAME AS mgOrgName,
        I.IDLE_SEQ AS idleSeq,
        I.SCOMMENT AS scomment,
        I.USE_FLAG AS useFlag,
        I.IS_NG AS isNg,
        I.ALARM_TYPE AS alarmType,
        I.IS_SAP AS isSap,
        I.IS_RPT AS isRpt,
        I.IS_MCT_SCOMMENT AS isMctScomment,
        DATE_FORMAT(I.REG_DATE, '%Y-%m-%d %H:%i:%s') AS regDate,
        I.REG_EMP AS regEmp,
        DATE_FORMAT(I.MDFY_DATE, '%Y-%m-%d %H:%i:%s') AS mdfyDate,
        I.MDFY_EMP AS mdfyEmp
    FROM TSTD_IDLECODE I
    LEFT JOIN TSTD_ORG O ON I.PLT_CODE = O.PLT_CODE AND I.MG_ORG = O.ORG_CODE
    WHERE I.PLT_CODE = p_plt_code
      AND (p_plants IS NULL OR p_plants = '' OR I.PLANTS = p_plants)
      AND (p_idle_like IS NULL OR p_idle_like = ''
           OR I.IDLE_CODE LIKE CONCAT('%', p_idle_like, '%')
           OR I.IDLE_NAME LIKE CONCAT('%', p_idle_like, '%'))
      AND I.DATA_FLAG = IFNULL(p_data_flag, 0)
    ORDER BY I.IDLE_SEQ, I.IDLE_CODE;
END//

DELIMITER ;

-- ============================================================
-- 실행 안내
-- ============================================================
-- 1. MySQL Workbench 또는 CLI에서 이 스크립트 실행
-- 2. 운영 DB에 적용 후 doc/PROCEDURE_SYNC_RULE.md에 기록
-- ============================================================
