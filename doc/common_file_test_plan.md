# common/file 테스트 계획서

## 개요
이 문서는 `common/file` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**: `src/main/resources/mappers/com/wsc/common/file/File.xml`

---

## 1. 파일 관리

### 화면 URL
- `/common/file/*.do`

### JS 파일
- `resources/js/common/file/file.js`

### 화면 기능
파일 업로드/다운로드/삭제 및 썸네일 관리 기능

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 파일 목록 그리드 | 업로드된 파일 목록 표시 |
| 파일 업로드 버튼 | 파일 업로드 기능 |
| 파일 다운로드 버튼 | 파일 다운로드 기능 |
| 삭제 버튼 | 파일 삭제 기능 |
| 썸네일 설정 버튼 | 대표 이미지 지정 |

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_file_search | 파일 목록 조회 (페이징 없음) |
| /searchCount.do | searchCount | sp_file_search_count | 파일 카운트 |
| /select.do | select | sp_file_select | 파일 단건 조회 |
| /insert.do | insert | sp_file_insert | 파일 등록 |
| /delete.do | delete | sp_file_delete | 파일 삭제 |
| /deleteAll.do | deleteAll | sp_file_delete_all | 파일 전체 삭제 |
| /updateThumbNail.do | updateThumbNail | sp_file_update_thumbnail | 썸네일 설정 |
| /updateThumbNailNull.do | updateThumbNailNull | sp_file_update_thumbnail_null | 썸네일 초기화 |
| /getNdaFileInfo.do | getNdaFileInfo | sp_search_nda_file_info | NDA 파일 정보 조회 |
| /updateFileComment.do | updateFileComment | sp_update_file_comment | 파일 코멘트 수정 |
| /insertFileChngHist.do | insertFileChngHist | sp_insert_file_chng_hist | 파일 변경 이력 등록 |

### 테스트 항목
- [ ] 파일 업로드 기능 테스트
  - [ ] 단일 파일 업로드
  - [ ] 다중 파일 업로드
  - [ ] 파일 크기 제한 확인 (500MB)
  - [ ] 허용된 파일 형식 확인
- [ ] 파일 목록 조회 기능 테스트
  - [ ] 파일명 검색 기능
  - [ ] 파일 유형별 필터링
  - [ ] 정렬 기능
- [ ] 파일 다운로드 기능 테스트
  - [ ] 단일 파일 다운로드
  - [ ] 다중 파일 압축 다운로드 (지원 시)
- [ ] 파일 삭제 기능 테스트
  - [ ] 단일 파일 삭제
  - [ ] 전체 파일 삭제
  - [ ] 삭제 확인 메시지 표시
- [ ] 썸네일 관리 기능 테스트
  - [ ] 썸네일 설정
  - [ ] 썸네일 초기화
  - [ ] 썸네일 미리보기
- [ ] 파일 코멘트 기능 테스트
  - [ ] 코멘트 등록
  - [ ] 코멘트 수정
- [ ] 파일 변경 이력 기능 테스트
  - [ ] 변경 이력 등록
  - [ ] 변경 이력 조회
- [ ] NDA 파일 관리 테스트
  - [ ] NDA 파일 정보 조회

---

## API 파라미터 상세

### search (파일 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| atchGrup | VARCHAR | N | 첨부그룹 |
| atchNo | VARCHAR | N | 첨부번호 |
| fileNo | VARCHAR | N | 파일번호 |
| fileName | VARCHAR | N | 파일명 |
| saveName | VARCHAR | N | 저장명 |
| filePath | VARCHAR | N | 파일경로 |
| fileType | VARCHAR | N | 파일유형 |
| fileSize | VARCHAR | N | 파일크기 |
| sortStr | VARCHAR | N | 정렬 문자열 |

### insert (파일 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| atchGrup | VARCHAR | Y | 첨부그룹 |
| atchNo | VARCHAR | Y | 첨부번호 |
| fileName | VARCHAR | Y | 파일명 |
| saveName | VARCHAR | Y | 저장명 |
| filePath | VARCHAR | Y | 파일경로 |
| fileType | VARCHAR | N | 파일유형 |
| fileSize | VARCHAR | N | 파일크기 |
| comment | VARCHAR | N | 코멘트 |
| gsUserId | VARCHAR | Y | 사용자 ID |

### delete (파일 삭제)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| atchGrup | VARCHAR | Y | 첨부그룹 |
| atchNo | VARCHAR | Y | 첨부번호 |
| fileNo | VARCHAR | Y | 파일번호 |
