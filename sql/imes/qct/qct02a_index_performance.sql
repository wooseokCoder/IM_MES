-- ============================================================================
-- QCT02A 조회 성능 개선 인덱스
-- 부적합/결품 현황 (sp_imes_tshp_ng_query3) Full Scan 제거
-- ============================================================================
-- 작성자: 송우석
-- 작성일: 2026-03-10
-- ============================================================================

-- 1. TSHP_IDLETIME: NG JOIN용 (최우선)
--    JOIN 조건: N.PLT_CODE = I.PLT_CODE AND N.NG_ID = I.NG_ID AND I.DATA_FLAG = 0
--    기존 인덱스 6개 중 (PLT_CODE, NG_ID) 조합 없음 → 38만건 Full Scan 발생
CREATE INDEX idx_tshp_idle_plt_ng_df ON TSHP_IDLETIME (PLT_CODE, NG_ID, DATA_FLAG);

-- 2. TSHP_NG: 날짜 범위 필터용
--    WHERE 조건: N.PLT_CODE = ? AND N.NG_DATE >= ? AND N.NG_DATE <= ?
--    PK(PLT_CODE, NG_ID)로 PLT_CODE만 필터 → NG_DATE는 행 단위 비교 중
CREATE INDEX idx_tshp_ng_plt_date ON TSHP_NG (PLT_CODE, NG_DATE);
