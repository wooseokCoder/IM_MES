# common/board 화면별 테스트 계획서

> 작성일: 2026-01-15
> 대상 모듈: src/main/resources/mappers/com/wsc/common/board/

---

## 목차

1. [게시판 관리 (board.jsp)](#1-게시판-관리-boardjsp)
2. [게시판 관리자 (boardmanagement.jsp)](#2-게시판-관리자-boardmanagementjsp)
3. [공지사항 (bulletin.jsp)](#3-공지사항-bulletinjsp)
4. [알림 (alter.jsp)](#4-알림-alterjsp)
5. [참고자료 (reference.jsp)](#5-참고자료-referencejsp)
6. [QnA 게시판 (qna.jsp)](#6-qna-게시판-qnajsp)
7. [도움말 관리 (help.jsp)](#7-도움말-관리-helpjsp)
8. [네비게이션 도움말 (navhelp.jsp)](#8-네비게이션-도움말-navhelpjsp)
9. [동영상 게시판 (video.jsp)](#9-동영상-게시판-videojsp)
10. [이미지 게시판 (image.jsp)](#10-이미지-게시판-imagejsp)
11. [알림 (notification.jsp)](#11-알림-notificationjsp)
12. [주소록 관리 (address.jsp)](#12-주소록-관리-addressjsp)
13. [딜러 검색 팝업 (dealersearch.jsp)](#13-딜러-검색-팝업-dealersearchjsp)
14. [은행 검색 팝업 (banksearch.jsp)](#14-은행-검색-팝업-banksearchjsp)
15. [LSTA 사용자 검색 (lstasearch.jsp)](#15-lsta-사용자-검색-lstasearchjsp)
16. [마이뷰 설정 (myviewsearch.jsp)](#16-마이뷰-설정-myviewsearchjsp)
17. [프로시저 사용 현황 요약](#프로시저-사용-현황-요약)
18. [테스트 체크리스트](#테스트-체크리스트)

---

## 1. 게시판 관리 (board.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/board.do` |
| JS 파일 | `/resources/js/common/board/board.js` |
| 화면 기능 | 범용 게시판 CRUD 관리 (공지, 알림, 참고자료 등 통합) |

### UI 구성요소
- 검색 폼: 게시판그룹, 제목, 내용, 타입, 기간, 공개유형, 언어
- 그리드: 게시번호, 제목, 작성자, 등록일, 조회수, 게시기간, 타입
- 상세 폼: 에디터(bordText), 파일첨부, 대상자 지정

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/board/search.json` | Board.xml → search | `sp_board_search` |
| 목록 카운트 | - | Board.xml → searchCount | `sp_board_search_count` |
| 상세 조회 | `/common/board/board/select.json` | Board.xml → select | `sp_board_select` |
| 등록 | `/common/board/board/save.json` | Board.xml → insert | `sp_board_insert` |
| 수정 | `/common/board/board/save.json` | Board.xml → update | `sp_board_update` |
| 삭제 | `/common/board/board/delete.json` | Board.xml → delete | `sp_board_delete` |
| 조회수 증가 | - | Board.xml → updateReadCnt | `sp_board_update_read_cnt` |
| 비활성화 | `/common/board/board/disable.json` | Board.xml → updateDisable | `sp_board_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | `/common/board/board/searchTarget.json` | Board.xml → searchTarget | `sp_board_search_target` |
| 대상자 카운트 | - | Board.xml → searchTargetCount | `sp_board_search_target_count` |
| 대상자 상세 | - | Board.xml → selectTarget | `sp_board_select_target` |
| 대상자 등록 | `/common/board/board/insertTarget.json` | Board.xml → insertTarget | `sp_board_insert_target` |
| 대상자 수정 | - | Board.xml → updateTarget | `sp_board_update_target` |
| 대상자 비활성화 | - | Board.xml → updateTargetDisable | `sp_board_update_target_disable` |
| 대상자 일괄삭제 | - | Board.xml → deleteTargetAll | `sp_board_delete_target_all` |
| 대상자 읽음처리 | - | Board.xml → updateTargetRead | `sp_board_update_target_read` |

### 호출 API - 대시보드/인덱스

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 알림 상단 | - | Board.xml → alterTop | `sp_board_alter_top` |
| 알림 하단 | - | Board.xml → alterBottom | `sp_board_alter_bottom` |
| 참고자료 상단 | - | Board.xml → referemceTop | `sp_board_reference_top` |
| 참고자료 하단 | - | Board.xml → referemceBottom | `sp_board_reference_bottom` |
| 공지사항 상단 | - | Board.xml → noticeTop | `sp_board_notice_top` |
| 게시판 상세 | - | Board.xml → searchBordDetail | `sp_board_search_bord_detail` |
| 조회자 목록 | - | Board.xml → searchViewsList | `sp_board_search_views_list` |
| 조회자 카운트 | - | Board.xml → searchViewsListCount | `sp_board_search_views_list_count` |
| B17 인덱스 | - | Board.xml → searchBordIndexB17 | `sp_board_search_bord_index_b17` |
| B99 인덱스 | - | Board.xml → searchBordIndexB99 | `sp_search_index_bord` |
| B19 인덱스 | - | Board.xml → searchBordIndexB19 | `sp_board_search_bord_index_b19` |
| 이미지 조회 | - | Board.xml → searchBordImg | `sp_board_search_bord_img` |

### 호출 API - 매뉴얼/기타

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 매뉴얼 시리즈 | - | Board.xml → getManualSeries | `sp_board_get_manual_series` |
| 매뉴얼 모델 | - | Board.xml → getManualModel | `sp_board_get_manual_model` |
| 등록자 ID | - | Board.xml → getRegiUserId | `sp_board_get_regi_user_id` |
| 딜러 체크 | - | Board.xml → dealerCheck | `sp_board_dealer_check` |
| 수정 권한 체크 | - | Board.xml → editCheck | `sp_board_edit_check` |

### 테스트 항목
- [ ] 게시판그룹별 목록 조회
- [ ] 검색 조건별 필터 (제목, 내용, 기간, 타입)
- [ ] 페이징 동작 확인
- [ ] 신규 게시글 등록 (에디터 내용, 파일첨부)
- [ ] 기존 게시글 수정
- [ ] 게시글 삭제/비활성화
- [ ] 조회수 증가 확인
- [ ] 대상자 지정 및 관리
- [ ] 대상자 읽음 처리
- [ ] 대시보드 인덱스 데이터 조회

---

## 2. 게시판 관리자 (boardmanagement.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/boardmanagement.do` |
| JS 파일 | `/resources/js/common/board/boardmanagement.js` |
| 화면 기능 | 게시판 전체 관리 (관리자 전용) |

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/boardmanagement/search.json` | BoardManagement.xml → search | `sp_board_management_search` |
| 목록 카운트 | - | BoardManagement.xml → searchCount | `sp_board_management_search_count` |
| 상세 조회 | `/common/board/boardmanagement/select.json` | BoardManagement.xml → select | `sp_board_management_select` |
| 수정 | `/common/board/boardmanagement/save.json` | BoardManagement.xml → update | `sp_board_management_update` |
| 삭제 | `/common/board/boardmanagement/delete.json` | BoardManagement.xml → delete | `sp_board_management_delete` |
| 타입 코드 | - | BoardManagement.xml → getBordTypeCode | `sp_board_management_get_bord_type_code` |

### 테스트 항목
- [ ] 전체 게시판 목록 조회
- [ ] 코드그룹별 필터 조회
- [ ] 게시글 순서 변경 (bordSeq)
- [ ] 게시글 삭제
- [ ] 게시판 타입 코드 콤보 로드

---

## 3. 공지사항 (bulletin.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/bulletin.do` |
| JS 파일 | `/resources/js/common/board/bulletin.js` |
| 화면 기능 | 공지사항 게시판 CRUD |

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/bulletin/search.json` | bulletin.xml → search | `sp_bulletin_search` |
| 목록 카운트 | - | bulletin.xml → searchCount | `sp_bulletin_search_count` |
| 상세 조회 | `/common/board/bulletin/select.json` | bulletin.xml → select | `sp_bulletin_select` |
| 등록 | `/common/board/bulletin/save.json` | bulletin.xml → insert | `sp_bulletin_insert` |
| 수정 | `/common/board/bulletin/save.json` | bulletin.xml → update | `sp_bulletin_update` |
| 삭제 | `/common/board/bulletin/delete.json` | bulletin.xml → delete | `sp_bulletin_delete` |
| 조회수 증가 | - | bulletin.xml → updateReadCnt | `sp_bulletin_update_read_cnt` |
| 비활성화 | - | bulletin.xml → updateDisable | `sp_bulletin_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | bulletin.xml → searchTarget | `sp_bulletin_search_target` |
| 대상자 카운트 | - | bulletin.xml → searchTargetCount | `sp_bulletin_search_target_count` |
| 대상자 상세 | - | bulletin.xml → selectTarget | `sp_bulletin_select_target` |
| 대상자 등록 | - | bulletin.xml → insertTarget | `sp_bulletin_insert_target` |
| 대상자 수정 | - | bulletin.xml → updateTarget | `sp_bulletin_update_target` |
| 대상자 비활성화 | - | bulletin.xml → updateTargetDisable | `sp_bulletin_update_target_disable` |
| 대상자 일괄삭제 | - | bulletin.xml → deleteTargetAll | `sp_bulletin_delete_target_all` |
| 대상자 읽음처리 | - | bulletin.xml → updateTargetRead | `sp_bulletin_update_target_read` |

### 테스트 항목
- [ ] 공지사항 목록 조회
- [ ] 신규 공지사항 등록
- [ ] 공지사항 수정/삭제
- [ ] 대상자 지정 (딜러별)
- [ ] 조회수 확인

---

## 4. 알림 (alter.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/alter.do` |
| JS 파일 | `/resources/js/common/board/alter.js` |
| 화면 기능 | 알림/경고 게시판 CRUD |

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/alter/search.json` | Alter.xml → search | `sp_alter_search` |
| 목록 카운트 | - | Alter.xml → searchCount | `sp_alter_search_count` |
| 상세 조회 | `/common/board/alter/select.json` | Alter.xml → select | `sp_alter_select` |
| 등록 | `/common/board/alter/save.json` | Alter.xml → insert | `sp_alter_insert` |
| 수정 | `/common/board/alter/save.json` | Alter.xml → update | `sp_alter_update` |
| 삭제 | `/common/board/alter/delete.json` | Alter.xml → delete | `sp_alter_delete` |
| 조회수 증가 | - | Alter.xml → updateReadCnt | `sp_alter_update_read_cnt` |
| 비활성화 | - | Alter.xml → updateDisable | `sp_alter_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | Alter.xml → searchTarget | `sp_alter_search_target` |
| 대상자 카운트 | - | Alter.xml → searchTargetCount | `sp_alter_search_target_count` |
| 대상자 상세 | - | Alter.xml → selectTarget | `sp_alter_select_target` |
| 대상자 등록 | - | Alter.xml → insertTarget | `sp_alter_insert_target` |
| 대상자 수정 | - | Alter.xml → updateTarget | `sp_alter_update_target` |
| 대상자 비활성화 | - | Alter.xml → updateTargetDisable | `sp_alter_update_target_disable` |
| 대상자 일괄삭제 | - | Alter.xml → deleteTargetAll | `sp_alter_delete_target_all` |
| 대상자 읽음처리 | - | Alter.xml → updateTargetRead | `sp_alter_update_target_read` |

### 테스트 항목
- [ ] 알림 목록 조회
- [ ] 신규 알림 등록
- [ ] 알림 수정/삭제
- [ ] 대상자 지정
- [ ] 조회수 확인

---

## 5. 참고자료 (reference.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/reference.do` |
| JS 파일 | `/resources/js/common/board/reference.js` |
| 화면 기능 | 참고자료/문서 게시판 CRUD |

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/reference/search.json` | reference.xml → search | `sp_reference_search` |
| 목록 카운트 | - | reference.xml → searchCount | `sp_reference_search_count` |
| 상세 조회 | `/common/board/reference/select.json` | reference.xml → select | `sp_reference_select` |
| 등록 | `/common/board/reference/save.json` | reference.xml → insert | `sp_reference_insert` |
| 수정 | `/common/board/reference/save.json` | reference.xml → update | `sp_reference_update` |
| 삭제 | `/common/board/reference/delete.json` | reference.xml → delete | `sp_reference_delete` |
| 조회수 증가 | - | reference.xml → updateReadCnt | `sp_reference_update_read_cnt` |
| 비활성화 | - | reference.xml → updateDisable | `sp_reference_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | reference.xml → searchTarget | `sp_reference_search_target` |
| 대상자 카운트 | - | reference.xml → searchTargetCount | `sp_reference_search_target_count` |
| 대상자 상세 | - | reference.xml → selectTarget | `sp_reference_select_target` |
| 대상자 등록 | - | reference.xml → insertTarget | `sp_reference_insert_target` |
| 대상자 수정 | - | reference.xml → updateTarget | `sp_reference_update_target` |
| 대상자 비활성화 | - | reference.xml → updateTargetDisable | `sp_reference_update_target_disable` |
| 대상자 일괄삭제 | - | reference.xml → deleteTargetAll | `sp_reference_delete_target_all` |
| 대상자 읽음처리 | - | reference.xml → updateTargetRead | `sp_reference_update_target_read` |

### 테스트 항목
- [ ] 참고자료 목록 조회
- [ ] 신규 참고자료 등록 (파일첨부)
- [ ] 참고자료 수정/삭제
- [ ] 대상자 지정
- [ ] 파일 다운로드

---

## 6. QnA 게시판 (qna.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/qna.do` |
| JS 파일 | `/resources/js/common/board/qna.js` |
| 화면 기능 | Q&A 게시판 (질문/답변 계층 구조) |

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/qna/search.json` | Qna.xml → search | `sp_qna_search` |
| 목록 카운트 | - | Qna.xml → searchCount | `sp_qna_search_count` |
| 상세 조회 | `/common/board/qna/select.json` | Qna.xml → select | `sp_qna_select` |
| 등록 | `/common/board/qna/save.json` | Qna.xml → insert | `sp_qna_insert` |
| 수정 | `/common/board/qna/save.json` | Qna.xml → update | `sp_qna_update` |
| 삭제 | `/common/board/qna/delete.json` | Qna.xml → delete | `sp_qna_delete` |
| 조회수 증가 | - | Qna.xml → updateReadCnt | `sp_qna_update_read_cnt` |
| 비활성화 | - | Qna.xml → updateDisable | `sp_qna_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | Qna.xml → searchTarget | `sp_qna_search_target` |
| 대상자 카운트 | - | Qna.xml → searchTargetCount | `sp_qna_search_target_count` |
| 대상자 상세 | - | Qna.xml → selectTarget | `sp_qna_select_target` |
| 대상자 등록 | - | Qna.xml → insertTarget | `sp_qna_insert_target` |
| 대상자 수정 | - | Qna.xml → updateTarget | `sp_qna_update_target` |
| 대상자 비활성화 | - | Qna.xml → updateTargetDisable | `sp_qna_update_target_disable` |
| 대상자 일괄삭제 | - | Qna.xml → deleteTargetAll | `sp_qna_delete_target_all` |
| 대상자 읽음처리 | - | Qna.xml → updateTargetRead | `sp_qna_update_target_read` |

### 호출 API - 답변 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 답변 목록 | `/common/board/qna/selectReplyList.json` | Qna.xml → selectReplyList | `sp_qna_select_reply_list` |
| 답변 상세 | `/common/board/qna/selectReplyView.json` | Qna.xml → selectReplyView | `sp_qna_select_reply_view` |

### 테스트 항목
- [ ] QnA 목록 조회 (질문 목록)
- [ ] 신규 질문 등록
- [ ] 질문에 대한 답변 등록 (bordPno 참조)
- [ ] 질문/답변 수정/삭제
- [ ] 답변 목록 트리 구조 확인
- [ ] 대상자 지정

---

## 7. 도움말 관리 (help.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/help.do` |
| JS 파일 | `/resources/js/common/board/help.js` |
| 화면 기능 | 화면별 도움말 관리 (다국어 지원) |

### 호출 API - 도움말 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/help/search.json` | Help.xml → search | `sp_help_search` |
| 목록 카운트 | - | Help.xml → searchCount | `sp_help_search_count` |
| 상세 조회 | `/common/board/help/select.json` | Help.xml → select | `sp_help_select` |
| 등록 | `/common/board/help/save.json` | Help.xml → insert | `sp_help_insert` |
| 수정 | `/common/board/help/save.json` | Help.xml → update | `sp_help_update` |
| 삭제 | `/common/board/help/delete.json` | Help.xml → delete | `sp_help_delete` |
| 조회수 증가 | - | Help.xml → updateReadCnt | `sp_help_update_read_cnt` |
| 비활성화 | - | Help.xml → updateDisable | `sp_help_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | Help.xml → searchTarget | `sp_help_search_target` |
| 대상자 카운트 | - | Help.xml → searchTargetCount | `sp_help_search_target_count` |
| 대상자 상세 | - | Help.xml → selectTarget | `sp_help_select_target` |
| 대상자 등록 | - | Help.xml → insertTarget | `sp_help_insert_target` |
| 대상자 수정 | - | Help.xml → updateTarget | `sp_help_update_target` |
| 대상자 비활성화 | - | Help.xml → updateTargetDisable | `sp_help_update_target_disable` |
| 대상자 일괄삭제 | - | Help.xml → deleteTargetAll | `sp_help_delete_target_all` |
| 대상자 읽음처리 | - | Help.xml → updateTargetRead | `sp_help_update_target_read` |

### 호출 API - 기타

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 메뉴 목록 | - | Help.xml → getMenuList | `sp_help_get_menu_list` |
| 등록 중복체크 | - | Help.xml → getInsertChk | `sp_help_get_insert_chk` |
| 헬프 목록 | - | Help.xml → getHelpList | `sp_help_get_help_list` |

### 테스트 항목
- [ ] 도움말 목록 조회 (언어별)
- [ ] 신규 도움말 등록
- [ ] 도움말 수정/삭제
- [ ] 메뉴키(bordType) 기반 도움말 조회
- [ ] 다국어(gsLang) 전환 확인
- [ ] 등록 중복 체크

---

## 8. 네비게이션 도움말 (navhelp.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/navhelp.do` |
| JS 파일 | `/resources/js/common/board/navhelp.js` |
| 화면 기능 | 네비게이션(좌측메뉴) 도움말 관리 |

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/navhelp/search.json` | NavHelp.xml → search | `sp_navhelp_search` |
| 목록 카운트 | - | NavHelp.xml → searchCount | `sp_navhelp_search_count` |
| 상세 조회 | `/common/board/navhelp/select.json` | NavHelp.xml → select | `sp_navhelp_select` |
| 등록 | `/common/board/navhelp/save.json` | NavHelp.xml → insert | `sp_navhelp_insert` |
| 수정 | `/common/board/navhelp/save.json` | NavHelp.xml → update | `sp_navhelp_update` |
| 삭제 | `/common/board/navhelp/delete.json` | NavHelp.xml → delete | `sp_navhelp_delete` |
| 조회수 증가 | - | NavHelp.xml → updateReadCnt | `sp_navhelp_update_read_cnt` |
| 비활성화 | - | NavHelp.xml → updateDisable | `sp_navhelp_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | NavHelp.xml → searchTarget | `sp_navhelp_search_target` |
| 대상자 카운트 | - | NavHelp.xml → searchTargetCount | `sp_navhelp_search_target_count` |
| 대상자 상세 | - | NavHelp.xml → selectTarget | `sp_navhelp_select_target` |
| 대상자 등록 | - | NavHelp.xml → insertTarget | `sp_navhelp_insert_target` |
| 대상자 수정 | - | NavHelp.xml → updateTarget | `sp_navhelp_update_target` |
| 대상자 비활성화 | - | NavHelp.xml → updateTargetDisable | `sp_navhelp_update_target_disable` |
| 대상자 일괄삭제 | - | NavHelp.xml → deleteTargetAll | `sp_navhelp_delete_target_all` |
| 대상자 읽음처리 | - | NavHelp.xml → updateTargetRead | `sp_navhelp_update_target_read` |

### 호출 API - 기타

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 조회자 목록 | - | NavHelp.xml → searchViewsList | `sp_navhelp_search_views_list` |
| 조회자 카운트 | - | NavHelp.xml → searchViewsListCount | `sp_navhelp_search_views_list_count` |
| 매뉴얼 시리즈 | - | NavHelp.xml → getManualSeries | `sp_navhelp_get_manual_series` |
| 매뉴얼 모델 | - | NavHelp.xml → getManualModel | `sp_navhelp_get_manual_model` |
| 등록자 ID | - | NavHelp.xml → getRegiUserId | `sp_navhelp_get_regi_user_id` |
| 딜러 체크 | - | NavHelp.xml → dealerCheck | `sp_navhelp_dealer_check` |
| 메뉴키로 조회 | - | NavHelp.xml → selectNavHelpByMenuKey | `sp_navhelp_select_by_menu_key` |

### 테스트 항목
- [ ] 네비게이션 도움말 목록 조회
- [ ] 신규 도움말 등록
- [ ] 도움말 수정/삭제
- [ ] 메뉴키 기반 도움말 조회
- [ ] 조회자 목록 확인

---

## 9. 동영상 게시판 (video.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/video.do` |
| JS 파일 | `/resources/js/common/board/video.js` |
| 화면 기능 | 동영상 게시판 CRUD |

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/video/search.json` | Video.xml → search | `sp_video_search` |
| 목록 카운트 | - | Video.xml → searchCount | `sp_video_search_count` |
| 상세 조회 | `/common/board/video/select.json` | Video.xml → select | `sp_video_select` |
| 등록 | `/common/board/video/save.json` | Video.xml → insert | `sp_video_insert` |
| 수정 | `/common/board/video/save.json` | Video.xml → update | `sp_video_update` |
| 삭제 | `/common/board/video/delete.json` | Video.xml → delete | `sp_video_delete` |
| 조회수 증가 | - | Video.xml → updateReadCnt | `sp_video_update_read_cnt` |
| 비활성화 | - | Video.xml → updateDisable | `sp_video_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | Video.xml → searchTarget | `sp_video_search_target` |
| 대상자 카운트 | - | Video.xml → searchTargetCount | `sp_video_search_target_count` |
| 대상자 상세 | - | Video.xml → selectTarget | `sp_video_select_target` |
| 대상자 등록 | - | Video.xml → insertTarget | `sp_video_insert_target` |
| 대상자 수정 | - | Video.xml → updateTarget | `sp_video_update_target` |
| 대상자 비활성화 | - | Video.xml → updateTargetDisable | `sp_video_update_target_disable` |
| 대상자 일괄삭제 | - | Video.xml → deleteTargetAll | `sp_video_delete_target_all` |
| 대상자 읽음처리 | - | Video.xml → updateTargetRead | `sp_video_update_target_read` |

### 테스트 항목
- [ ] 동영상 목록 조회
- [ ] 신규 동영상 등록 (파일 업로드)
- [ ] 동영상 수정/삭제
- [ ] 동영상 재생 확인
- [ ] 대상자 지정

---

## 10. 이미지 게시판 (image.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/image.do` |
| JS 파일 | `/resources/js/common/board/image.js` |
| 화면 기능 | 이미지 게시판 CRUD |

### 호출 API - 게시글 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/board/image/search.json` | Image.xml → search | `sp_image_search` |
| 목록 카운트 | - | Image.xml → searchCount | `sp_image_search_count` |
| 상세 조회 | `/common/board/image/select.json` | Image.xml → select | `sp_image_select` |
| 등록 | `/common/board/image/save.json` | Image.xml → insert | `sp_image_insert` |
| 수정 | `/common/board/image/save.json` | Image.xml → update | `sp_image_update` |
| 삭제 | `/common/board/image/delete.json` | Image.xml → delete | `sp_image_delete` |
| 조회수 증가 | - | Image.xml → updateReadCnt | `sp_image_update_read_cnt` |
| 비활성화 | - | Image.xml → updateDisable | `sp_image_update_disable` |

### 호출 API - 대상자 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 대상자 목록 | - | Image.xml → searchTarget | `sp_image_search_target` |
| 대상자 카운트 | - | Image.xml → searchTargetCount | `sp_image_search_target_count` |
| 대상자 상세 | - | Image.xml → selectTarget | `sp_image_select_target` |
| 대상자 등록 | - | Image.xml → insertTarget | `sp_image_insert_target` |
| 대상자 수정 | - | Image.xml → updateTarget | `sp_image_update_target` |
| 대상자 비활성화 | - | Image.xml → updateTargetDisable | `sp_image_update_target_disable` |
| 대상자 일괄삭제 | - | Image.xml → deleteTargetAll | `sp_image_delete_target_all` |
| 대상자 읽음처리 | - | Image.xml → updateTargetRead | `sp_image_update_target_read` |

### 테스트 항목
- [ ] 이미지 목록 조회
- [ ] 신규 이미지 등록 (파일 업로드)
- [ ] 이미지 수정/삭제
- [ ] 이미지 미리보기 확인
- [ ] 대상자 지정

---

## 11. 알림 (notification.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/notification.do` |
| JS 파일 | `/resources/js/common/board/notification.js` |
| 화면 기능 | 사용자 알림 목록 조회/읽음 처리 |

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 알림 목록 | `/common/board/notification/selectBordList.json` | Notification.xml → selectBordList | `sp_select_user_noti` |
| 읽음 처리 | `/common/board/notification/updateNotiRead.json` | Notification.xml → updateNotiRead | `sp_board_notification_update_read` |

### 테스트 항목
- [ ] 사용자별 알림 목록 조회
- [ ] 알림 읽음 처리
- [ ] 알림 클릭 시 상세 페이지 이동

---

## 12. 주소록 관리 (address.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/address.do` |
| JS 파일 | `/resources/js/common/board/address.js` |
| 화면 기능 | 개인 주소록 및 그룹 관리 |

### 호출 API - 주소록 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 주소록 목록 | `/common/board/address/search.json` | Address.xml → search | `sp_address_search` |
| 주소록 카운트 | - | Address.xml → searchCount | `sp_address_search_count` |
| 주소록 상세 | `/common/board/address/select.json` | Address.xml → select | `sp_address_select` |
| 주소록 등록 | `/common/board/address/save.json` | Address.xml → insert | `sp_address_insert` |
| 주소록 수정 | `/common/board/address/save.json` | Address.xml → update | `sp_address_update` |
| 주소록 삭제 | `/common/board/address/delete.json` | Address.xml → delete | `sp_address_delete` |

### 호출 API - 그룹 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 그룹 목록 | `/common/board/address/searchGroup.json` | Address.xml → searchGroup | `sp_address_search_group` |
| 그룹 카운트 | - | Address.xml → searchGroupCount | `sp_address_search_group_count` |
| 그룹 상세 | `/common/board/address/selectGroup.json` | Address.xml → selectGroup | `sp_address_select_group` |
| 그룹 등록 | `/common/board/address/saveGroup.json` | Address.xml → insertGroup | `sp_address_insert_group` |
| 그룹 수정 | `/common/board/address/saveGroup.json` | Address.xml → updateGroup | `sp_address_update_group` |
| 그룹 삭제 | `/common/board/address/deleteGroup.json` | Address.xml → deleteGroup | `sp_address_delete_group` |

### 호출 API - 그룹 아이템 관리

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 아이템 목록 | - | Address.xml → searchGroupItem | `sp_address_search_group_item` |
| 아이템 카운트 | - | Address.xml → searchGroupItemCount | `sp_address_search_group_item_count` |
| 아이템 상세 | - | Address.xml → selectGroupItem | `sp_address_select_group_item` |
| 아이템 등록 | - | Address.xml → insertGroupItem | `sp_address_insert_group_item` |
| 아이템 수정 | - | Address.xml → updateGroupItem | `sp_address_update_group_item` |
| 아이템 전체삭제 | - | Address.xml → deleteGroupItemAll | `sp_address_delete_group_item_all` |

### 테스트 항목
- [ ] 개인 주소록 목록 조회
- [ ] 주소록 등록/수정/삭제
- [ ] 주소록 그룹 생성
- [ ] 그룹에 연락처 추가/삭제
- [ ] 그룹 삭제 시 아이템 연동 삭제 확인

---

## 13. 딜러 검색 팝업 (dealersearch.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/dealersearch.do` (팝업) |
| JS 파일 | `/resources/js/common/board/dealersearch.js` |
| 화면 기능 | 딜러 검색 팝업 (대상자 지정용) |

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 딜러 목록 | `/common/board/dealersearch/search.json` | DealerSearch.xml → search | `sp_dealer_search` |
| 딜러 카운트 | - | DealerSearch.xml → searchCount | `sp_dealer_search_count` |

### 테스트 항목
- [ ] 딜러코드/딜러명 검색
- [ ] 지역(ADDR_CNTY) 필터
- [ ] BM/서비스매니저 필터
- [ ] 페이징 동작
- [ ] 딜러 선택 후 부모창 반환

---

## 14. 은행 검색 팝업 (banksearch.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/banksearch.do` (팝업) |
| JS 파일 | `/resources/js/common/board/banksearch.js` |
| 화면 기능 | 은행 검색 팝업 |

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 은행 목록 | `/common/board/banksearch/search.json` | BankSearch.xml → search | `sp_bank_search_search` |
| 은행 카운트 | - | BankSearch.xml → searchCount | `sp_bank_search_search_count` |

### 테스트 항목
- [ ] 딜러코드 기반 은행 검색
- [ ] 페이징 동작
- [ ] 은행 선택 후 부모창 반환

---

## 15. LSTA 사용자 검색 (lstasearch.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/lstasearch.do` (팝업) |
| JS 파일 | `/resources/js/common/board/lstasearch.js` |
| 화면 기능 | LSTA 사용자 검색 팝업 |

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 사용자 목록 | `/common/board/lstasearch/search.json` | LSTASearch.xml → search | `sp_get_lsta_user_search` |
| 사용자 카운트 | - | LSTASearch.xml → searchCount | `sp_get_lsta_user_search_count` |
| LSTA 목록 | - | LSTASearch.xml → selectLstaList | `sp_get_lsta_user_search_list` |

### 테스트 항목
- [ ] LSTA 사용자 검색
- [ ] 사용자 선택 후 부모창 반환

---

## 16. 마이뷰 설정 (myviewsearch.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/board/myviewsearch.do` (팝업) |
| JS 파일 | `/resources/js/common/board/myviewsearch.js` |
| 화면 기능 | 사용자별 그리드 컬럼 커스터마이징 |

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 시스템 컬럼 조회 | - | MyViewSearch.xml → search | `sp_get_sys_win_col` |
| 시스템 컬럼 카운트 | - | MyViewSearch.xml → searchCount | `sp_get_sys_win_col_count` |
| 사용자 컬럼 조회 | - | MyViewSearch.xml → search2 | `sp_get_user_vw_col` |
| 사용자 컬럼 카운트 | - | MyViewSearch.xml → search2Count | `sp_get_user_vw_col_count` |
| 마이뷰 목록 | - | MyViewSearch.xml → getMyViewList | `sp_get_my_view_list` |
| 마이뷰 마스터 저장 | - | MyViewSearch.xml → saveMyViewMast | `sp_save_my_view_mast` |
| 마이뷰 컬럼 저장 | - | MyViewSearch.xml → saveMyViewColList | `sp_save_my_view_col` |
| 마이뷰 컬럼 삭제 | - | MyViewSearch.xml → deleteMyViewColList | `sp_delete_my_view_col` |
| 마이뷰 마스터 조회 | - | MyViewSearch.xml → getMyViewMastInfo | `sp_get_my_view_mast` |
| 마이뷰 삭제 | - | MyViewSearch.xml → deleteMyView | `sp_delete_my_view` |

### 테스트 항목
- [ ] 시스템 기본 컬럼 목록 조회
- [ ] 사용자 커스텀 컬럼 목록 조회
- [ ] 마이뷰 생성/저장
- [ ] 컬럼 순서 변경
- [ ] 컬럼 표시/숨김 설정
- [ ] 마이뷰 삭제

---

## 프로시저 사용 현황 요약

| XML 파일 | 프로시저 사용 | 쿼리 수 | 비고 |
|----------|--------------|---------|------|
| Board.xml | O | 42 | 게시글/대상자/대시보드/매뉴얼 |
| BoardManagement.xml | O | 6 | 관리자용 게시판 관리 |
| Notification.xml | O | 2 | 알림 조회/읽음처리 |
| Qna.xml | O | 20 | QnA + 답변 관리 |
| Help.xml | O | 19 | 도움말 + 메뉴 연동 |
| NavHelp.xml | O | 22 | 네비게이션 도움말 |
| Video.xml | O | 15 | 동영상 게시판 |
| Image.xml | O | 15 | 이미지 게시판 |
| Alter.xml | O | 15 | 알림 게시판 |
| bulletin.xml | O | 15 | 공지사항 게시판 |
| reference.xml | O | 15 | 참고자료 게시판 |
| Address.xml | O | 17 | 주소록/그룹/아이템 |
| DealerSearch.xml | O | 2 | 딜러 검색 팝업 |
| BankSearch.xml | O | 2 | 은행 검색 팝업 |
| LSTASearch.xml | O | 3 | LSTA 사용자 검색 |
| MyViewSearch.xml | O | 10 | 마이뷰 설정 |
| Commdmdp.xml | - | 0 | 빈 파일 |

---

## 테스트 체크리스트

### 1단계: 게시판 기본 화면
- [ ] `/common/board/board.do` - 범용 게시판 CRUD
- [ ] `/common/board/boardmanagement.do` - 게시판 관리자
- [ ] `/common/board/bulletin.do` - 공지사항
- [ ] `/common/board/alter.do` - 알림

### 2단계: 특수 게시판
- [ ] `/common/board/reference.do` - 참고자료
- [ ] `/common/board/qna.do` - QnA (질문/답변)
- [ ] `/common/board/video.do` - 동영상
- [ ] `/common/board/image.do` - 이미지

### 3단계: 도움말 관리
- [ ] `/common/board/help.do` - 화면별 도움말
- [ ] `/common/board/navhelp.do` - 네비게이션 도움말

### 4단계: 알림 및 주소록
- [ ] `/common/board/notification.do` - 사용자 알림
- [ ] `/common/board/address.do` - 개인 주소록

### 5단계: 검색 팝업
- [ ] `/common/board/dealersearch.do` - 딜러 검색
- [ ] `/common/board/banksearch.do` - 은행 검색
- [ ] `/common/board/lstasearch.do` - LSTA 사용자 검색

### 6단계: 기타
- [ ] `/common/board/myviewsearch.do` - 마이뷰 설정

---

## 게시판 공통 필드 설명

### 게시글 필드 (SYS_BORD)
| 필드명 | 설명 |
|--------|------|
| bordNo | 게시번호 (PK) |
| bordGrup | 게시판그룹 (B01:공지, B02:알림 등) |
| bordTitle | 제목 |
| bordText | 내용 (BLOB/LONGVARCHAR) |
| bordType | 게시타입 |
| bordBgn | 게시시작일 |
| bordEnd | 게시종료일 |
| bordPno | 부모게시번호 (답글용) |
| bordSeq | 정렬순서 |
| openType | 공개유형 |
| readCnt | 조회수 |
| useFlag | 사용여부 |

### 대상자 필드 (SYS_BORD_TGT)
| 필드명 | 설명 |
|--------|------|
| bordNo | 게시번호 (FK) |
| bordGrup | 게시판그룹 (FK) |
| tgtUserId | 대상자 ID |
| vndrCode | 딜러코드 |
| vndrName | 딜러명 |
| readYn | 읽음여부 |
| saveIdx | 저장인덱스 |

### 확장 필드
| 필드명 | 설명 |
|--------|------|
| dataGrp1~4 | 데이터 그룹 분류 |
| dataSer1~5 | 시리즈 분류 |
| dataMd01~10 | 모델 분류 |
| searIdx | 검색 인덱스 |
| justOne | 단일 표시 여부 |

---

## 공통 API 패턴

모든 게시판 화면은 다음의 표준 API 패턴을 따릅니다:

| 작업 | API URL 패턴 |
|------|-------------|
| 검색 | `/common/board/{기능}/search.json` |
| 상세 | `/common/board/{기능}/select.json` |
| 저장 | `/common/board/{기능}/save.json` |
| 삭제 | `/common/board/{기능}/delete.json` |
| 대상자 | `/common/board/{기능}/searchTarget.json` |
| 엑셀 | `/common/board/{기능}/download.do` |

---

## 비고

- **Commdmdp.xml**: 현재 빈 파일로, 쿼리가 정의되어 있지 않습니다.
- **게시판 구조**: 모든 게시판은 게시글 관리 + 대상자 관리의 2단계 구조를 가집니다.
- **대상자 관리**: 특정 딜러/사용자에게만 게시글을 노출하는 기능입니다.
- **다국어 지원**: Help.xml은 gsLang 파라미터로 다국어 도움말을 관리합니다.
