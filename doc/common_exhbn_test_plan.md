# common/exhbn 테스트 계획서

## 개요
이 문서는 `common/exhbn` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**: `src/main/resources/mappers/com/wsc/common/exhbn/Exhibition.xml`

---

## 1. 전시회 관리

### 화면 URL
- `/common/exhbn/list.do`
- `/common/exhbn/form.do`

### JS 파일
- `resources/js/common/exhbn/exhibition.js`

### 화면 기능
전시회 정보 등록, 수정, 삭제 및 이미지 관리 기능

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 전시회 목록 그리드 | 등록된 전시회 목록 |
| 검색 필터 | 전시회 코드, 연도, 활성화 상태 검색 |
| 등록/수정 폼 | 전시회 정보 입력 |
| 이미지 업로드 | 전시회 이미지 관리 |
| 삭제 버튼 | 전시회 삭제 |

### 호출 API

#### 전시회 기본 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_exhibition_search | 전시회 목록 조회 (페이징) |
| /searchCount.do | searchCount | sp_exhibition_search_count | 전시회 카운트 |
| /select.do | select | sp_exhibition_select | 전시회 단건 조회 |
| /insert.do | insert | sp_insert_exhbn | 전시회 등록 |
| /update.do | update | sp_update_exhbn | 전시회 수정 |
| /delete.do | delete | sp_exhibition_delete | 전시회 삭제 |

#### 전시회 코드 조회
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /getSelectCodeExhbn.do | getSelectCodeExhbn | sp_exhibition_get_select_code | 전시회 코드 콤보 조회 |
| /getSelectCodeSortExhbn.do | getSelectCodeSortExhbn | sp_exhibition_get_select_code_sort | 전시회 정렬 코드 조회 |
| /searchCodeExhbn.do | searchCodeExhbn | sp_exhibition_search_code | 전시회 코드 검색 |

#### 전시회 이미지 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /exhibitionSearchImage.do | exhibitionSearchImage | sp_select_exhbn_image | 전시회 이미지 조회 |
| /saveExhbnImage.do | saveExhbnImage | sp_save_exhbn_image | 전시회 이미지 저장 |

### 테스트 항목

#### 전시회 목록 조회
- [ ] 페이징 동작 확인
- [ ] 검색 필터 동작 확인
  - [ ] 전시회 코드로 검색
  - [ ] 연도로 검색
  - [ ] 활성화 상태로 필터링
- [ ] 정렬 기능 확인

#### 전시회 등록
- [ ] 필수 필드 검증
  - [ ] 전시회 연도 (exhbnYear)
  - [ ] 전시회명 (exhbnName)
- [ ] 시작일/종료일 설정 (exhbnBgnDate, exhbnEndDate)
- [ ] 전시회 장소 입력 (exhbnLoc)
- [ ] 최대 인원 설정 (maxNum)
- [ ] 사용 여부 설정 (useFlag)
- [ ] 활성화 여부 설정 (activeYn)
- [ ] 순서 설정 (seq)

#### 전시회 수정
- [ ] 전시회 정보 변경
- [ ] 활성화 상태 변경
- [ ] 사용 여부 변경

#### 전시회 삭제
- [ ] 삭제 확인 메시지 표시
- [ ] 연관 데이터 처리 확인

#### 전시회 이미지 관리
- [ ] 이미지 조회
- [ ] 이미지 업로드/저장
- [ ] 이미지 미리보기

---

## API 파라미터 상세

### search (전시회 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| exhbnCode | VARCHAR | N | 전시회 코드 |
| exhbnYear | VARCHAR | N | 전시회 연도 |
| exhbnActive | VARCHAR | N | 활성화 상태 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### insert (전시회 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| gsUserId | VARCHAR | Y | 사용자 ID |
| exhbnYear | VARCHAR | Y | 전시회 연도 |
| exhbnName | VARCHAR | Y | 전시회명 |
| exhbnBgnDate | VARCHAR | N | 시작일 |
| exhbnEndDate | VARCHAR | N | 종료일 |
| exhbnLoc | VARCHAR | N | 전시회 장소 |
| maxNum | VARCHAR | N | 최대 인원 |
| useFlag | VARCHAR | N | 사용 여부 |
| activeYn | VARCHAR | N | 활성화 여부 |
| seq | VARCHAR | N | 순서 |
| exhbnCode | VARCHAR | N | 전시회 코드 |

### saveExhbnImage (전시회 이미지 저장)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| gsUserId | VARCHAR | Y | 사용자 ID |
| atchGrup | VARCHAR | Y | 첨부 그룹 |
| atchNo | VARCHAR | Y | 첨부 번호 |
| atchSeq | VARCHAR | N | 첨부 순번 |
| atchImg | VARCHAR | N | 이미지 데이터 |
