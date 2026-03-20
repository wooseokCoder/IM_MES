-- ============================================================
-- 개발서버 collation 통일: utf8mb4_general_ci → utf8mb4_unicode_ci
-- 대상: TSHP_INS_RESULT_MASTER, TSHP_INS_RESULT
-- 원인: 개발서버에서 테이블 생성 시 general_ci로 생성됨
--       → 다른 테이블(unicode_ci)과 JOIN 시 collation 충돌 에러
-- 작성자: 송우석
-- 작성일: 2026-03-17
-- ============================================================

ALTER TABLE TSHP_INS_RESULT_MASTER CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE TSHP_INS_RESULT CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
