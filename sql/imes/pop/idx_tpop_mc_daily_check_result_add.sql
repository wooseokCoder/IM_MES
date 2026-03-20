-- ============================================================
-- TPOP_MC_DAILY_CHECK_RESULT 테이블 성능 개선 인덱스 추가
-- 대상 화면: POP42A (설비 일상점검 결과)
-- 작성자: 송우석
-- 작성일: 2026-03-12
--
-- 목적: sp_imes_tpop_mc_daily_check_result_query1 조회 성능 개선
--       WHERE PLT_CODE AND MDCR_DATE BETWEEN ... AND MDCR_MC_CODE JOIN
--       63,728건 풀스캔 → 인덱스 스캔으로 개선
-- ============================================================

CREATE INDEX IDX_TPOP_MDCR_DATE_MC ON TPOP_MC_DAILY_CHECK_RESULT (PLT_CODE, MDCR_DATE, MDCR_MC_CODE);
