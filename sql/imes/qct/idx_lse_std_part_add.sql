-- ============================================================
-- LSE_STD_PART 테이블 성능 개선 인덱스 추가
-- 대상 화면: QCT06A (부품별 검사항목 관리)
-- 작성자: 송우석
-- 작성일: 2026-03-12
--
-- 목적: sp_imes_lse_std_partins_query1 조회 성능 개선
--       WHERE PLT_CODE='100' AND DATA_FLAG=0 AND MAT_TYPE='1'
--       150,941건 풀스캔 → 인덱스 스캔으로 개선
-- ============================================================

CREATE INDEX IDX_LSE_STD_PART_TYPE ON LSE_STD_PART (PLT_CODE, MAT_TYPE, DATA_FLAG);
