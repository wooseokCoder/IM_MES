-- ============================================================
-- QCT08A 자주검사 현황 조회 성능 개선 인덱스
-- ============================================================
-- 작성자: 송우석
-- 작성일: 2026-03-17
--
-- 문제: 7개 테이블 JOIN에서 DATA_FLAG 필터가 인덱스 없이 풀스캔
--       TSHP_INS_RESULT(364,677건) × TSHP_INS_RESULT_MASTER(12,374건)
--
-- EXPLAIN 결과:
--   A(MASTER): PK만 사용, DATA_FLAG filtered=10%
--   C(RESULT): PK만 사용, DATA_FLAG filtered=10%
-- ============================================================

-- 1. TSHP_INS_RESULT: JOIN(PLT_CODE, INSM_NO) + 필터(DATA_FLAG) 커버링
--    기존: PK(PLT_CODE, INSM_NO, INS_NO)만 있어서 DATA_FLAG 풀스캔
CREATE INDEX idx_tshp_ins_result_qct08a
    ON TSHP_INS_RESULT (PLT_CODE, INSM_NO, DATA_FLAG);

-- 2. TSHP_INS_RESULT_MASTER: WHERE(PLT_CODE, DATA_FLAG) + JOIN(WO_NO) 커버링
--    기존: PK(PLT_CODE, INSM_NO)만 있어서 DATA_FLAG 풀스캔
CREATE INDEX idx_tshp_ins_result_master_qct08a
    ON TSHP_INS_RESULT_MASTER (PLT_CODE, DATA_FLAG, WO_NO);
