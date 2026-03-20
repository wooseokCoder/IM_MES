-- ============================================================================
-- TSTD_PROC_INS QUERY 프로시저 (1개)
-- 자주검사 항목 조회: QUERY1
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-02-27
-- 수정일: 2026-03-03 - 이미지 base64 제거 → hasImg 플래그 (성능 개선)
-- 수정일: 2026-03-05 - AS-IS 원복: TO_BASE64(INS_IMG) 메인 쿼리에 포함 (그리드 1회 렌더링)
-- 수정일: 2026-03-06 - TO_BASE64(INS_IMG) 제거 (서버 OOM 원인) → hasImg 플래그만 유지, 이미지는 개별 URL 로딩
-- 수정일: 2026-03-11 - insGrp 상관 서브쿼리 → LEFT JOIN 변환 (2.6초 → 0.2초 성능 개선)
-- ============================================================================

-- ============================================================================
-- sp_imes_tstd_proc_ins_query1
-- 검사항목 목록 조회 (메인 그리드)
-- AS-IS: QCT04A_SER → TSTD_PROC_INS_QUERY.TSTD_PROC_INS_QUERY1()
-- ============================================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_imes_tstd_proc_ins_query1//

CREATE PROCEDURE sp_imes_tstd_proc_ins_query1(
    IN p_plt_code   VARCHAR(3),
    IN p_plants     VARCHAR(10)
)
BEGIN
    SELECT
        A.PLT_CODE                      AS pltCode,
        A.PLANTS                        AS plants,
        A.INS_CODE                      AS insCode,
        A.PROC_CODE                     AS procCode,
        A.PROC_NAME                     AS procName,
        A.INS_NAME                      AS insName,
        A.INS_DESC                      AS insDesc,
        A.INS_TYPE                      AS insType,
        A.INS_UNIT                      AS insUnit,
        A.AVG_VAL                       AS avgVal,
        A.MIN_VAL                       AS minVal,
        A.MAX_VAL                       AS maxVal,
        A.INS_SEQ                       AS insSeq,
        CASE WHEN A.INS_IMG IS NOT NULL THEN 1 ELSE 0 END AS hasImg,
        -- 성능 개선: 상관 서브쿼리 → LEFT JOIN 변환 (1,884건 기준 2.6초 → 0.2초)
        -- 변경 전: 매 행마다 GROUP_CONCAT 서브쿼리 반복 실행 → 행 수만큼 서브쿼리 호출
        -- 변경 후: GROUP BY로 1회 집계 후 LEFT JOIN → 서브쿼리 반복 제거
        T.insGrp
    FROM TSTD_PROC_INS A
    LEFT JOIN (
        SELECT GL.PLT_CODE, GL.INS_CODE,
               GROUP_CONCAT(G.INS_GRP_NAME SEPARATOR ', ') AS insGrp
        FROM TSTD_INS_GRP_LIST GL
        INNER JOIN TSTD_INS_GRP G
            ON GL.PLT_CODE = G.PLT_CODE
           AND GL.INS_GRP_CODE = G.INS_GRP_CODE
           AND G.DATA_FLAG = 0
        GROUP BY GL.PLT_CODE, GL.INS_CODE
    ) T ON A.PLT_CODE = T.PLT_CODE AND A.INS_CODE = T.INS_CODE
    WHERE A.PLT_CODE = p_plt_code
      AND A.PLANTS = p_plants
      AND A.DATA_FLAG = 0
    ORDER BY A.INS_SEQ, A.INS_CODE;
END//
DELIMITER ;
