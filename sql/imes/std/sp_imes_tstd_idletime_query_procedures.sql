-- ============================================================
-- TSTD_IDLETIME QUERY 프로시저
-- 생성일: 2026-02-10
-- 대상 테이블: TSTD_IDLETIME, TSTD_IDLECODE (JOIN)
-- 원본: ProActive TSTD_IDLETIME_QUERY.cs
-- ============================================================
-- 명명 규칙: sp_imes_tstd_idletime_query[번호]
-- ============================================================

DELIMITER //

-- ============================================================
-- sp_imes_tstd_idletime_query1: 목록 조회 (JOIN TSTD_IDLECODE)
-- 원본: TSTD_IDLETIME_QUERY.TSTD_IDLETIME_QUERY1()
-- 용도: 메인 그리드 목록 조회
-- JOIN: TSTD_IDLETIME A ↔ TSTD_IDLECODE B (SCODE 기준)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idletime_query1//

CREATE PROCEDURE sp_imes_tstd_idletime_query1(
    IN p_plt_code VARCHAR(10),
    IN p_plants VARCHAR(10),
    IN p_idle_like VARCHAR(100),
    IN p_data_flag INT
)
BEGIN
    SELECT
        A.PLT_CODE AS pltCode,
        A.IDLE_NO AS idleNo,
        A.SCODE AS scode,
        B.IDLE_CODE AS idleCode,
        B.PLANTS AS plants,
        B.SAP_CODE AS sapCode,
        B.IDLE_NAME AS idleName,
        A.IDLE_START_TIME AS idleStartTime,
        A.IDLE_END_TIME AS idleEndTime,
        A.SCOMMENT AS scomment
    FROM TSTD_IDLETIME A
    INNER JOIN TSTD_IDLECODE B ON A.PLT_CODE = B.PLT_CODE AND A.SCODE = B.SCODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.DATA_FLAG = p_data_flag
      AND B.PLANTS = p_plants
      AND (p_idle_like IS NULL OR p_idle_like = ''
           OR B.IDLE_NAME LIKE CONCAT('%', p_idle_like, '%')
           OR B.IDLE_CODE LIKE CONCAT('%', p_idle_like, '%'))
    ORDER BY A.IDLE_START_TIME, B.IDLE_SEQ;
END//

-- ============================================================
-- sp_imes_tstd_idletime_query2: 시간 중복 체크
-- 원본: TSTD_IDLETIME_QUERY.TSTD_IDLETIME_QUERY2()
-- 용도: STD49A_INS에서 시간 겹침 검증
-- 참고: p_not_idle_no로 자기 자신(수정 대상)을 제외
-- ============================================================
DROP PROCEDURE IF EXISTS sp_imes_tstd_idletime_query2//

CREATE PROCEDURE sp_imes_tstd_idletime_query2(
    IN p_plt_code VARCHAR(10),
    IN p_plants VARCHAR(10),
    IN p_not_idle_no VARCHAR(30),
    IN p_data_flag INT
)
BEGIN
    SELECT
        A.PLT_CODE AS pltCode,
        A.IDLE_NO AS idleNo,
        A.SCODE AS scode,
        A.IDLE_START_TIME AS idleStartTime,
        A.IDLE_END_TIME AS idleEndTime
    FROM TSTD_IDLETIME A
    INNER JOIN TSTD_IDLECODE B ON A.PLT_CODE = B.PLT_CODE AND A.SCODE = B.SCODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.DATA_FLAG = p_data_flag
      AND B.PLANTS = p_plants
      AND (p_not_idle_no IS NULL OR p_not_idle_no = '' OR A.IDLE_NO != p_not_idle_no)
    ORDER BY A.IDLE_START_TIME;
END//

DELIMITER ;

-- ============================================================
-- 실행 안내
-- ============================================================
-- 1. sp_imes_tstd_idletime_procedures.sql 먼저 실행
-- 2. MySQL Workbench 또는 CLI에서 이 스크립트 실행
-- 3. 운영 DB에 적용 후 doc/PROCEDURE_SYNC_RULE.md에 기록
-- ============================================================
