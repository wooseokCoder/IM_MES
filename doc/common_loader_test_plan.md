# common/loader 테스트 계획서

## 개요
이 문서는 `common/loader` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**: `src/main/resources/mappers/com/wsc/common/loader/Loader.xml`

---

## 1. 엑셀 로더 폼 관리

### 화면 URL
- `/common/loader/list.do`
- `/common/loader/form.do`

### JS 파일
- `resources/js/common/loader/loader.js`

### 화면 기능
엑셀 업로드/다운로드를 위한 폼 정의 및 필드 매핑 관리

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 로더 폼 목록 그리드 | 등록된 엑셀 로더 폼 목록 |
| 검색 필터 | 폼 코드, 폼명, 사용 여부 검색 |
| 등록/수정 버튼 | 로더 폼 등록 및 수정 |
| 삭제 버튼 | 로더 폼 삭제 |
| 상세 정보 영역 | 선택된 폼의 상세 정보 |

### 호출 API

#### 로더 폼 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_loader_search | 로더 폼 목록 조회 (페이징) |
| /searchCount.do | searchCount | sp_loader_search_count | 로더 폼 카운트 |
| /select.do | select | sp_loader_select | 로더 폼 단건 조회 |
| /insert.do | insert | sp_loader_insert | 로더 폼 등록 |
| /update.do | update | sp_loader_update | 로더 폼 수정 |
| /delete.do | delete | sp_loader_delete | 로더 폼 삭제 |

### 테스트 항목
- [ ] 로더 폼 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 검색 필터 동작 (폼 코드, 폼명, 사용 여부)
  - [ ] 정렬 기능 확인
- [ ] 로더 폼 등록
  - [ ] 필수 필드 검증 (폼 코드, 폼명)
  - [ ] 중복 코드 체크
  - [ ] 피벗 여부 설정 (pivotYn)
  - [ ] 타이틀 행 번호 설정 (titleNo)
  - [ ] 시작 행 번호 설정 (startNo)
- [ ] 로더 폼 수정
  - [ ] 폼 정보 변경
  - [ ] 사용 여부 변경
- [ ] 로더 폼 삭제
  - [ ] 삭제 확인 메시지
  - [ ] 연관 아이템 함께 삭제 확인

---

## 2. 엑셀 필드 아이템 관리

### 화면 URL
- `/common/loader/itemlist.do`
- `/common/loader/itemform.do`

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 아이템 목록 그리드 | 폼에 포함된 필드 목록 |
| 아이템 등록 폼 | 필드 정보 입력 |
| 순서 조정 | 필드 순서 변경 |

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchItem.do | searchItem | sp_loader_search_item | 로더 아이템 목록 조회 |
| /searchItemCount.do | searchItemCount | sp_loader_search_item_count | 로더 아이템 카운트 |
| /selectItem.do | selectItem | sp_loader_select_item | 로더 아이템 단건 조회 |
| /insertItem.do | insertItem | sp_loader_insert_item | 로더 아이템 등록 |
| /updateItem.do | updateItem | sp_loader_update_item | 로더 아이템 수정 |
| /deleteItem.do | deleteItem | sp_loader_delete_item | 로더 아이템 삭제 |
| /deleteItemAll.do | deleteItemAll | sp_loader_delete_item_all | 로더 아이템 전체 삭제 |

### 테스트 항목
- [ ] 아이템 목록 조회
  - [ ] 특정 폼에 속한 아이템 조회
  - [ ] 페이징 동작 확인
- [ ] 아이템 등록
  - [ ] 필수 필드 검증 (아이템 코드, 아이템명)
  - [ ] 아이템 유형 선택 (itemType)
  - [ ] 아이템 순서 설정 (itemSeq)
  - [ ] 기본값 설정 (itemDef)
  - [ ] 엑셀 컬럼 코드 매핑 (exclCode)
- [ ] 아이템 수정
  - [ ] 필드 정보 변경
  - [ ] 순서 변경
  - [ ] 사용 여부 변경
- [ ] 아이템 삭제
  - [ ] 단일 아이템 삭제
  - [ ] 전체 아이템 삭제

---

## 3. 콤보 데이터 조회

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /searchCombo.do | searchCombo | sp_loader_search_combo | 콤보형 데이터 검색 |

### 테스트 항목
- [ ] 코드 그룹별 콤보 데이터 조회
- [ ] 콤보 데이터 표시 확인

---

## API 파라미터 상세

### search (로더 폼 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| exclGrup | VARCHAR | N | 엑셀 그룹 |
| formCode | VARCHAR | N | 폼 코드 |
| formName | VARCHAR | N | 폼명 |
| formDesc | VARCHAR | N | 폼 설명 |
| titleNo | VARCHAR | N | 타이틀 행 번호 |
| startNo | VARCHAR | N | 시작 행 번호 |
| pivotYn | VARCHAR | N | 피벗 여부 |
| useFlag | VARCHAR | N | 사용 여부 |
| sortStr | VARCHAR | N | 정렬 문자열 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### insertItem (로더 아이템 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| exclGrup | VARCHAR | Y | 엑셀 그룹 |
| formCode | VARCHAR | Y | 폼 코드 |
| itemCode | VARCHAR | Y | 아이템 코드 |
| itemName | VARCHAR | Y | 아이템명 |
| itemType | VARCHAR | N | 아이템 유형 |
| itemDesc | VARCHAR | N | 아이템 설명 |
| itemDef | VARCHAR | N | 기본값 |
| itemSeq | VARCHAR | N | 순서 |
| exclCode | VARCHAR | N | 엑셀 컬럼 코드 |
| gsUserId | VARCHAR | Y | 사용자 ID |
