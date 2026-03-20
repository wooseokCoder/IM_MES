# common/code 화면별 테스트 계획서

> 작성일: 2026-01-14
> 대상 모듈: src/main/resources/mappers/com/wsc/common/code/

---

## 목차

1. [공통코드 관리 (code.jsp)](#1-공통코드-관리-codejsp)
2. [공통코드 기간 관리 (codeterm.jsp)](#2-공통코드-기간-관리-codetermjsp)
3. [화면용어 관리 (screenterm.jsp)](#3-화면용어-관리-screentermjsp)
4. [서비스코드 관리 (svccode.jsp)](#4-서비스코드-관리-svccodejsp)
5. [서비스코드 기간 관리 (svccodeterm.jsp)](#5-서비스코드-기간-관리-svccodetermjsp)
6. [프로시저 사용 현황 요약](#프로시저-사용-현황-요약)
7. [테스트 체크리스트](#테스트-체크리스트)

---

## 1. 공통코드 관리 (code.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/code/code.do` |
| JS 파일 | `/resources/js/common/code/code.js` |
| 화면 기능 | 시스템 공통코드 CRUD 관리 |

### UI 구성요소
- 검색 폼: 코드그룹, 코드, 코드명, 정렬순서, 사용여부 콤보박스
- 그리드: 시스템ID, 코드그룹, 코드, 코드명(한/영), 설명, 확장필드, 정렬순서, 사용여부
- 팝업 다이얼로그: 상세정보 등록/수정 폼

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/code/code/search.json` | Code.xml → search | `sp_code_search` |
| 목록 카운트 | - | Code.xml → searchCount | `sp_code_search_count` |
| 상세 조회 | `/common/code/code/select.json` | Code.xml → select | `sp_code_select` |
| 등록 | `/common/code/code/save.json` | Code.xml → insert | `sp_code_insert` |
| 수정 | `/common/code/code/save.json` | Code.xml → update | `sp_code_update` |
| 삭제 | `/common/code/code/delete.json` | Code.xml → delete | `sp_code_delete` |
| 전체 조회 | `/common/code/code/searchAll.json` | Code.xml → searchAll | `sp_code_search_all` |
| 그룹 전체 삭제 | `/common/code/code/deleteAll.json` | Code.xml → deleteAll | `sp_code_delete_all` |
| 변경 이력 등록 | - | Code.xml → insertHist | `sp_code_insert_hist` |
| 코드그룹 목록 | `/common/code/code/getSelectCode.json` | Code.xml → getSelectCode | `sp_code_get_select_code` |
| 정렬순서 목록 | - | Code.xml → getSelectCodeSort | `sp_code_get_select_code_sort` |
| 코드그룹별 코드 | `/common/code/code/searchCode.json` | Code.xml → searchCode | `sp_code_search_code` |
| AS코드 조회 | - | Code.xml → searchCodeAs | `sp_code_search_code_as` |
| 고객제품 조회 | - | Code.xml → searchCustProd | `sp_code_search_cust_prod` |
| 전체제품 조회 | - | Code.xml → searchAllProd | `sp_code_search_all_prod` |
| 외부고객창고 조회 | - | Code.xml → searchOutsCustStrg | `sp_code_search_outs_cust_strg` |
| 확장문자 수정 | - | Code.xml → updateExtChr | `sp_code_update_ext_chr` |
| 확장숫자 수정 | - | Code.xml → updateExtNum | `sp_code_update_ext_num` |
| 엑셀 다운로드 | `/common/code/code/download.do` | Code.xml → search | `sp_code_search` |

### 테스트 항목
- [ ] 검색 조건별 조회 (코드그룹, 코드, 코드명, 사용여부)
- [ ] 페이징 동작 확인
- [ ] 신규 코드 등록
- [ ] 기존 코드 정보 수정
- [ ] 코드 삭제
- [ ] 코드그룹 전체 삭제
- [ ] 코드그룹 콤보박스 데이터 로드
- [ ] 확장필드(extChr01~10, extNum01~05) 입력/수정
- [ ] 엑셀 다운로드
- [ ] 변경 이력 자동 등록 확인

---

## 2. 공통코드 기간 관리 (codeterm.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/code/codeterm.do` |
| JS 파일 | `/resources/js/common/code/codeterm.js` |
| 화면 기능 | 기간별 공통코드 CRUD 관리 (유효기간이 있는 코드) |

### UI 구성요소
- 검색 폼: 코드그룹, 코드, 코드명, 기준일자, 사용여부 콤보박스
- 그리드: 시스템ID, 코드그룹, 코드, 코드명, 적용일자, 확장필드, 사용여부
- 팝업 다이얼로그: 상세정보 등록/수정 폼

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/code/codeterm/search.json` | Code.xml → searchTerm | `sp_code_search_term` |
| 목록 카운트 | - | Code.xml → searchTermCount | `sp_code_search_term_count` |
| 상세 조회 | `/common/code/codeterm/select.json` | Code.xml → selectTerm | `sp_code_select_term` |
| 등록 | `/common/code/codeterm/save.json` | Code.xml → insertTerm | `sp_code_insert_term` |
| 삭제 | `/common/code/codeterm/delete.json` | Code.xml → deleteTerm | `sp_code_delete_term` |
| 엑셀 다운로드 | `/common/code/codeterm/download.do` | Code.xml → searchTerm | `sp_code_search_term` |

### 테스트 항목
- [ ] 기준일자 기반 코드 조회
- [ ] 페이징 동작 확인
- [ ] 기간별 코드 등록 (적용일자 포함)
- [ ] 기간별 코드 삭제
- [ ] 날짜 필드(codeDate) 형식 검증
- [ ] 엑셀 다운로드

---

## 3. 화면용어 관리 (screenterm.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/code/screenterm.do` |
| JS 파일 | `/resources/js/common/code/screenterm.js` |
| 화면 기능 | 화면 용어(라벨, 메시지) 다국어 관리 |

### UI 구성요소
- 검색 폼: 프로그램그룹(키), 항목ID, 항목명, 사용여부 콤보박스
- 그리드: 시스템ID, 항목그룹, 항목ID, 항목명(다국어: 한국어/영어/포르투갈어/베트남어/기타), 항목설명, 유형, 길이, 속성1~3, 비고, 사용여부
- 팝업 다이얼로그: 상세정보 등록/수정 폼 (다국어 입력)

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/code/screenterm/search.json` | Screenterm.xml → search | `sp_screenterm_search` |
| 목록 카운트 | - | Screenterm.xml → searchCount | `sp_screenterm_search_count` |
| 상세 조회 | `/common/code/screenterm/select.json` | Screenterm.xml → select | `sp_screenterm_select` |
| 등록 | `/common/code/screenterm/save.json` | Screenterm.xml → insert | `sp_screenterm_insert` |
| 수정 | `/common/code/screenterm/save.json` | Screenterm.xml → update | `sp_screenterm_update` |
| 삭제 | `/common/code/screenterm/delete.json` | Screenterm.xml → delete | `sp_screenterm_delete` |
| 프로그램키 목록 | `/common/code/screenterm/selectProgKeyList.json` | Screenterm.xml → selectProgKeyList | `sp_screenterm_prog_key_list` |
| 다국어 명칭 조회 | `/common/code/screenterm/selectLangNm.json` | Screenterm.xml → selectLangNm | `sp_screenterm_lang_nm` |
| 엑셀 다운로드 | `/common/code/screenterm/download.do` | Screenterm.xml → search | `sp_screenterm_search` |

### 테스트 항목
- [ ] 프로그램그룹별 용어 조회
- [ ] 항목ID/항목명 검색 조회
- [ ] 페이징 동작 확인
- [ ] 신규 용어 등록 (다국어 입력)
- [ ] 용어 정보 수정
- [ ] 용어 삭제
- [ ] 프로그램키 목록 콤보박스 로드
- [ ] 다국어 명칭 조회 (언어별 전환)
- [ ] 항목 유형/길이/속성 필드 입력
- [ ] 엑셀 다운로드

### 다국어 필드
| 필드명 | 설명 |
|--------|------|
| itemNm | 기본 명칭 |
| itemNmKor | 한국어 명칭 |
| itemNmEng | 영어 명칭 |
| itemNmPort | 포르투갈어 명칭 |
| itemNmViet | 베트남어 명칭 |
| itemNmEtc | 기타 언어 명칭 |

---

## 4. 서비스코드 관리 (svccode.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/code/svccode.do` |
| JS 파일 | `/resources/js/common/code/svccode.js` |
| 화면 기능 | 서비스 관련 코드 CRUD 관리 |

### UI 구성요소
- 검색 폼: 코드, 코드설명, 정렬순서, 사용여부 콤보박스
- 그리드: 시스템ID, 코드, 코드그룹, 설명, 확장필드, 정렬순서, 사용여부
- 팝업 다이얼로그: 상세정보 등록/수정 폼

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/code/svccode/search.json` | SvcCode.xml → search | `sp_svccode_search` |
| 목록 카운트 | - | SvcCode.xml → searchCount | `sp_svccode_search_count` |
| 상세 조회 | `/common/code/svccode/select.json` | SvcCode.xml → select | `sp_svccode_select` |
| 등록 | `/common/code/svccode/save.json` | SvcCode.xml → insert | `sp_svccode_insert` |
| 수정 | `/common/code/svccode/save.json` | SvcCode.xml → update | `sp_svccode_update` |
| 삭제 | `/common/code/svccode/delete.json` | SvcCode.xml → delete | `sp_svccode_delete` |
| 전체 조회 | `/common/code/svccode/searchAll.json` | SvcCode.xml → searchAll | `sp_svccode_search_all` |
| 전체 삭제 | `/common/code/svccode/deleteAll.json` | SvcCode.xml → deleteAll | `sp_svccode_delete_all` |
| 이력 등록 | - | SvcCode.xml → insertHist | `sp_svccode_insert_hist` |
| AS코드 조회 | - | SvcCode.xml → searchCodeAs | `sp_svccode_search_code_as` |
| 고객제품 조회 | - | SvcCode.xml → searchCustProd | `sp_svccode_search_cust_prod` |
| 전체제품 조회 | - | SvcCode.xml → searchAllProd | `sp_svccode_search_all_prod` |
| 외주고객창고 조회 | - | SvcCode.xml → searchOutsCustStrg | `sp_svccode_search_outs_cust_strg` |
| 엑셀 다운로드 | `/common/code/svccode/download.do` | SvcCode.xml → search | `sp_svccode_search` |

### 테스트 항목
- [ ] 검색 조건별 조회 (코드, 설명, 사용여부)
- [ ] 페이징 동작 확인
- [ ] 신규 서비스코드 등록
- [ ] 서비스코드 정보 수정
- [ ] 서비스코드 삭제
- [ ] 서비스코드 전체 삭제
- [ ] 확장필드(extChr01~10, extNum01~05, extText) 입력/수정
- [ ] 변경 이력 자동 등록 확인
- [ ] 엑셀 다운로드

---

## 5. 서비스코드 기간 관리 (svccodeterm.jsp)

| 항목 | 내용 |
|------|------|
| 화면 URL | `/common/code/svccodeterm.do` |
| JS 파일 | `/resources/js/common/code/svccodeterm.js` |
| 화면 기능 | 기간별 서비스코드 CRUD 관리 |

### UI 구성요소
- 검색 폼: 코드, 코드그룹, 설명, 기준일자, 사용여부 콤보박스
- 그리드: 시스템ID, 코드, 코드그룹, 설명, 적용일자, 확장필드, 사용여부
- 팝업 다이얼로그: 상세정보 등록/수정 폼

### 호출 API

| 기능 | API URL | XML 쿼리 | 프로시저명 |
|------|---------|----------|-----------|
| 목록 조회 | `/common/code/svccodeterm/search.json` | SvcCode.xml → searchTerm | `sp_svccode_search_term` |
| 목록 카운트 | - | SvcCode.xml → searchTermCount | `sp_svccode_search_term_count` |
| 상세 조회 | `/common/code/svccodeterm/select.json` | SvcCode.xml → selectTerm | `sp_svccode_select_term` |
| 등록 | `/common/code/svccodeterm/save.json` | SvcCode.xml → insertTerm | `sp_svccode_insert_term` |
| 삭제 | `/common/code/svccodeterm/delete.json` | SvcCode.xml → deleteTerm | `sp_svccode_delete_term` |
| 엑셀 다운로드 | `/common/code/svccodeterm/download.do` | SvcCode.xml → searchTerm | `sp_svccode_search_term` |

### 테스트 항목
- [ ] 기준일자 기반 서비스코드 조회
- [ ] 코드그룹별 필터 조회
- [ ] 페이징 동작 확인
- [ ] 기간별 서비스코드 등록 (적용일자 포함)
- [ ] 기간별 서비스코드 삭제
- [ ] 날짜 필드(codeDate) 형식 검증
- [ ] 엑셀 다운로드

---

## 프로시저 사용 현황 요약

| XML 파일 | 프로시저 사용 | 비고 |
|----------|--------------|------|
| Code.xml | O | 모든 쿼리 프로시저 사용 |
| Screenterm.xml | O | 모든 쿼리 프로시저 사용 |
| SvcCode.xml | O | 모든 쿼리 프로시저 사용 |
| Barcode.xml | - | 빈 파일 (쿼리 없음) |

---

## 테스트 체크리스트

### 1단계: 공통코드 관리
- [ ] `/common/code/code.do` - 공통코드 CRUD
- [ ] `/common/code/codeterm.do` - 공통코드 기간 관리

### 2단계: 화면용어 관리
- [ ] `/common/code/screenterm.do` - 화면용어 다국어 CRUD

### 3단계: 서비스코드 관리
- [ ] `/common/code/svccode.do` - 서비스코드 CRUD
- [ ] `/common/code/svccodeterm.do` - 서비스코드 기간 관리

---

## 확장 필드 설명

### 문자형 확장 필드 (extChr01~10)
| 필드명 | 용도 |
|--------|------|
| extChr01 | 확장 문자 필드 1 |
| extChr02 | 확장 문자 필드 2 |
| extChr03 | 확장 문자 필드 3 |
| extChr04 | 확장 문자 필드 4 |
| extChr05 | 확장 문자 필드 5 |
| extChr06 | 확장 문자 필드 6 |
| extChr07 | 확장 문자 필드 7 |
| extChr08 | 확장 문자 필드 8 |
| extChr09 | 확장 문자 필드 9 |
| extChr10 | 확장 문자 필드 10 |

### 숫자형 확장 필드 (extNum01~05)
| 필드명 | 용도 |
|--------|------|
| extNum01 | 확장 숫자 필드 1 |
| extNum02 | 확장 숫자 필드 2 |
| extNum03 | 확장 숫자 필드 3 |
| extNum04 | 확장 숫자 필드 4 |
| extNum05 | 확장 숫자 필드 5 |

### 텍스트 확장 필드
| 필드명 | 용도 |
|--------|------|
| extText | 대용량 텍스트 필드 (LONGVARCHAR) |

---

## 공통 API 패턴

모든 화면은 다음의 표준 API 패턴을 따릅니다:

| 작업 | API URL 패턴 |
|------|-------------|
| 검색 | `/common/code/{기능}/search.json` |
| 저장 | `/common/code/{기능}/save.json` |
| 삭제 | `/common/code/{기능}/delete.json` |
| 엑셀 | `/common/code/{기능}/download.do` |
| 목록 | `/common/code/{기능}/select{기능}List.json` |

---

## 비고

- **Barcode.xml**: 현재 빈 파일로, 쿼리가 정의되어 있지 않습니다. 향후 바코드 관련 기능 추가 시 사용될 예정입니다.
- **Code.xml vs SvcCode.xml**: Code.xml은 코드그룹(codeGrup) 단위로 관리하고, SvcCode.xml은 서비스 관련 단일 코드 체계로 관리합니다.
- **이력 관리**: Code.xml과 SvcCode.xml 모두 insertHist 쿼리를 통해 변경 이력을 별도 테이블에 저장합니다.
