# common/app, drawing, excel 테스트 계획서

## 개요
이 문서는 `common/app`, `common/drawing`, `common/excel` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**:
- `src/main/resources/mappers/com/wsc/common/app/App.xml`
- `src/main/resources/mappers/com/wsc/common/drawing/DrawingInformation.xml`
- `src/main/resources/mappers/com/wsc/common/drawing/DrawingInformationDetail.xml`
- `src/main/resources/mappers/com/wsc/common/excel/ExcelDownloadMgt.xml`

---

# App 모듈 (모바일 앱 API)

## 1. 모바일 앱 인증 및 정보 조회

### 화면 URL
- 모바일 앱 전용 API (웹 화면 없음)

### 화면 기능
모바일 앱의 토큰 인증, 버전 체크, 사용자 정보 조회 기능

### 호출 API

#### 토큰 및 인증
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /mTokenCheck.do | mTokenCheck | SP_VALIDATE_TOKEN2 | 모바일 토큰 유효성 검사 |
| /versionCheck.do | versionCheck | sp_version_check | 앱 버전 체크 |
| /userInfo.do | userInfo | sp_get_user_info | 사용자 정보 조회 |
| /menuCheck.do | menuCheck | sp_get_user_menu_check | 메뉴 권한 체크 |

#### DAR (Dealer Audit Review) 관련
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /darEvalList.do | darEvalList | 인라인 SQL | DAR 평가 목록 조회 |
| /darEvalInfoUpdate.do | darEvalInfoUpdate | 인라인 SQL | DAR 평가 정보 수정 |
| /darStatusUpdate.do | darStatusUpdate | 인라인 SQL | DAR 상태 수정 |

#### SFDC (Salesforce) 연동
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /sfdcInfoUpdate.do | sfdcInfoUpdate | 인라인 SQL | SFDC 정보 수정 |
| /sfdcAmountUpdate.do | sfdcAmountUpdate | 인라인 SQL | SFDC 금액 수정 |
| /sfdcStatusUpdate.do | sfdcStatusUpdate | 인라인 SQL | SFDC 상태 수정 |
| /sfdcStatusSelect.do | sfdcStatusSelect | 인라인 SQL | SFDC 상태 조회 |

### 테스트 항목

#### 토큰 인증
- [ ] 토큰 유효성 검사
  - [ ] 유효한 토큰 검증
  - [ ] 만료된 토큰 처리
  - [ ] 잘못된 토큰 처리
- [ ] 버전 체크
  - [ ] Android 버전 체크
  - [ ] iOS 버전 체크
  - [ ] 강제 업데이트 필요 시 응답 확인

#### 사용자 정보
- [ ] 사용자 정보 조회
  - [ ] 로그인 정보 기반 조회
  - [ ] SSO URL 처리 (issuUrl, rqstUrl)
- [ ] 메뉴 권한 체크
  - [ ] 권한 있는 메뉴 접근
  - [ ] 권한 없는 메뉴 차단

#### DAR 평가
- [ ] DAR 평가 목록 조회
- [ ] DAR 평가 정보 수정
- [ ] DAR 상태 업데이트

#### SFDC 연동
- [ ] SFDC 정보 동기화
- [ ] SFDC 금액 업데이트
- [ ] SFDC 상태 조회/수정

---

# Drawing 모듈 (도면 관리)

## 2. 도면 목록 관리 (DrawingInformation)

### 화면 URL
- `/common/drawing/list.do`
- `/common/drawing/form.do`

### JS 파일
- `resources/js/common/drawing/drawinginformation.js`

### 화면 기능
도면 목록 관리 및 검색 기능

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 도면 목록 그리드 | 등록된 도면 목록 |
| 검색 필터 | 목록코드, 목록명, 목록유형 검색 |
| 등록/수정 버튼 | 도면 정보 관리 |
| 삭제 버튼 | 도면 삭제 |

### 호출 API

#### 도면 목록 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | SP_GET_DRAWING_LIST | 도면 목록 조회 (페이징) |
| /searchCount.do | searchCount | SP_GET_DRAWING_LIST_CNT | 도면 목록 카운트 |
| /select.do | select | sp_select_drawlist | 도면 단건 조회 |
| /delete.do | delete | sp_delete_drawing | 도면 삭제 |

### 테스트 항목
- [ ] 도면 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 목록코드(listCode) 검색
  - [ ] 목록명(listName) 검색
  - [ ] 목록유형(listType) 필터링
- [ ] 도면 상세 조회
  - [ ] 목록번호(listNo)로 단건 조회
- [ ] 도면 삭제
  - [ ] 삭제 확인 메시지
  - [ ] 연관 아이템 삭제 확인

---

## 3. 도면 상세 관리 (DrawingInformationDetail)

### 화면 URL
- `/common/drawing/detail/list.do`
- `/common/drawing/detail/form.do`

### 화면 기능
도면 목록 및 아이템 CRUD 관리

### 호출 API

#### 도면 목록 CRUD
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /drawListInsert.do | drawListInsert | sp_insert_drawList | 도면 목록 등록 |
| /drawListUpdate.do | drawListUpdate | sp_update_drawList | 도면 목록 수정 |
| /drawListDelete.do | drawListDelete | sp_delete_drawList | 도면 목록 삭제 |

#### 도면 아이템 CRUD
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /drawItemSearch.do | drawItemSearch | sp_select_drawItem | 도면 아이템 목록 조회 |
| /drawItemSearchCount.do | drawItemSearchCount | sp_select_drawItem_count | 도면 아이템 카운트 |
| /drawItemInsert.do | drawItemInsert | sp_insert_drawItem | 도면 아이템 등록 |
| /drawItemUpdate.do | drawItemUpdate | sp_update_drawItem | 도면 아이템 수정 |
| /drawItemDelete.do | drawItemDelete | sp_delete_drawItem | 도면 아이템 삭제 |

### 테스트 항목

#### 도면 목록 관리
- [ ] 도면 목록 등록
  - [ ] 목록 유형 설정 (listType)
  - [ ] 목록 코드 설정 (listCode)
  - [ ] 목록명 입력 (listName)
  - [ ] 게시판 번호 연결 (bordNo)
- [ ] 도면 목록 수정
- [ ] 도면 목록 삭제

#### 도면 아이템 관리
- [ ] 아이템 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 특정 목록의 아이템 조회
- [ ] 아이템 등록
  - [ ] 아이템 유형 설정 (itemType)
  - [ ] 아이템 코드/명 입력
  - [ ] 순서 설정 (num)
  - [ ] 확장 필드 입력 (numVal01~05, chrVal01~10, txtVal)
- [ ] 아이템 수정
- [ ] 아이템 삭제

---

# Excel 모듈 (엑셀 다운로드 관리)

## 4. 엑셀 다운로드 관리 (ExcelDownloadMgt)

### 화면 URL
- `/common/excel/downloadmgt/list.do`

### JS 파일
- `resources/js/common/excel/exceldownloadmgt.js`

### 화면 기능
대용량 엑셀 다운로드 요청 관리 및 이력 조회

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 다운로드 목록 그리드 | 엑셀 다운로드 요청 목록 |
| 검색 필터 | 사용자ID, 화면ID, 요청일자 검색 |
| 다운로드 버튼 | 생성된 엑셀 파일 다운로드 |

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_select_excel_download_mgt | 다운로드 목록 조회 (페이징) |
| /searchCount.do | searchCount | sp_select_excel_download_mgt_count | 다운로드 목록 카운트 |

### 테스트 항목
- [ ] 다운로드 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 사용자ID(userId) 필터링
  - [ ] 화면ID(windId) 필터링
  - [ ] 요청일자 범위 검색 (rqstDateFr, rqstDateTo)
- [ ] 다운로드 상태 확인
  - [ ] 대기 상태
  - [ ] 처리 중 상태
  - [ ] 완료 상태
  - [ ] 오류 상태
- [ ] 파일 다운로드
  - [ ] 완료된 파일 다운로드

---

## API 파라미터 상세

### App userInfo (사용자 정보 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| userId | VARCHAR | Y | 사용자 ID |
| userPwd | VARCHAR | Y | 사용자 비밀번호 |
| issuUrl | VARCHAR | N | SSO 발급 URL |
| rqstUrl | VARCHAR | N | SSO 요청 URL |

### DrawingInformationDetail drawItemInsert (도면 아이템 등록)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| listNo | VARCHAR | Y | 목록 번호 |
| num | VARCHAR | Y | 순서 |
| itemType | VARCHAR | N | 아이템 유형 |
| itemCode | VARCHAR | Y | 아이템 코드 |
| itemName | VARCHAR | N | 아이템명 |
| numVal01~05 | VARCHAR | N | 숫자 확장 필드 |
| chrVal01~10 | VARCHAR | N | 문자 확장 필드 |
| txtVal | VARCHAR | N | 텍스트 확장 필드 |
| gsUserId | VARCHAR | Y | 사용자 ID |

### ExcelDownloadMgt search (다운로드 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| userId | VARCHAR | N | 사용자 ID |
| windId | VARCHAR | N | 화면 ID |
| rqstDateFr | VARCHAR | N | 요청일자 시작 |
| rqstDateTo | VARCHAR | N | 요청일자 종료 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |
