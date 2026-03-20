aaa# common/ftk, invoice, rt 테스트 계획서

## 개요
이 문서는 `common/ftk`, `common/invoice`, `common/rt` 모듈의 테스트 계획서입니다.

**작성일**: 2025-01-15
**XML 파일**:
- `src/main/resources/mappers/com/wsc/common/ftk/Token.xml`
- `src/main/resources/mappers/com/wsc/common/invoice/InvoiceAdjustment.xml`
- `src/main/resources/mappers/com/wsc/common/rt/Return.xml`

---



# FTK 모듈 (토큰 및 API 연동)

## 1. 토큰 관리 및 PDI 인터페이스

### 화면 URL
- API 전용 (웹 화면 없음)

### 화면 기능
토큰 기반 인증 및 PDI(Pre-Delivery Inspection) 데이터 연동

### 호출 API

#### 토큰 관리
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /createToken.do | createToken | SP_CREATE_TOKEN | 토큰 생성 |
| /selectToken.do | selectToken | FN_MAKE_TOKEN | 토큰 조회 |
| /validateToken.do | validateToken | SP_VALIDATE_TOKEN | 토큰 유효성 검사 |
| /validateToken2.do | validateToken2 | SP_VALIDATE_TOKEN2 | 토큰 유효성 검사 v2 |
| /getApiKey.do | getApiKey | FN_API_KEY_GET | API 키 조회 |

#### PDI 인터페이스
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /seriNoUpdate.do | seriNoUpdate | SP_IF_PDI (SERI_NO) | 시리얼 번호 업데이트 |
| /outBoundUpdate.do | outBoundUpdate | SP_IF_PDI (OUTBOUND) | 출고 정보 업데이트 |
| /outBoundCancelUpdate.do | outBoundCancelUpdate | SP_IF_PDI (OUTBOUND_CNSL) | 출고 취소 |
| /assyNoUpdate.do | assyNoUpdate | SP_IF_PDI (ASSY_NO) | 조립 번호 업데이트 |
| /ifOrdrUpdate.do | ifOrdrUpdate | SP_IF_PDI | 주문 정보 연동 |
| /outboundBolImgUpdate.do | outboundBolImgUpdate | SP_IF_PDI | BOL 이미지 업데이트 |

#### LSAS 연동
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /ifLsas.do | ifLsas | SP_IF_LSAS | LSAS 시스템 연동 |

#### API 로그 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /TmpLogInsert.do | TmpLogInsert | 인라인 SQL | API 임시 로그 등록 |
| /TmpLogUpdate.do | TmpLogUpdate | 인라인 SQL | API 임시 로그 수정 |

### 테스트 항목

#### 토큰 관리
- [ ] 토큰 생성
  - [ ] 사용자별 토큰 생성
  - [ ] SSO URL 정보 포함 토큰 생성
- [ ] 토큰 유효성 검사
  - [ ] 유효한 토큰 확인
  - [ ] 만료된 토큰 처리
  - [ ] 잘못된 토큰 거부
- [ ] API 키 조회

#### PDI 인터페이스
- [ ] 시리얼 번호 업데이트
  - [ ] 주문번호, 품목코드, 시리얼번호 연동
- [ ] 출고 정보 업데이트
  - [ ] BOL 번호, 실제 출하일 처리
- [ ] 출고 취소 처리
- [ ] 조립 번호 업데이트

#### API 로그
- [ ] 로그 등록
  - [ ] 동적 로그 필드 (LOG_1 ~ LOG_20)
- [ ] 로그 결과 업데이트

---

# Invoice 모듈 (인보이스 조정)

## 2. 인보이스 조정 관리

### 화면 URL
- `/common/invoice/adjustment/list.do`
- `/common/invoice/adjustment/form.do`

### JS 파일
- `resources/js/common/invoice/invoiceadjustment.js`

### 화면 기능
출하 후 인보이스 정보 조정 및 SAP 연동

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 인보이스 목록 그리드 | 조정 대상 인보이스 목록 |
| 검색 필터 | 주문번호, 기간, 주문상태 검색 |
| 상세 정보 영역 | 인보이스 상세 정보 |
| 조정 버튼 | SAP 인보이스 정보 수정 |

### 호출 API
| URL | XML query id | Procedure/Query | 설명 |
|-----|--------------|-----------------|------|
| /search.do | search | sp_search_invoice_adjust | 인보이스 목록 조회 (페이징) |
| /searchCount.do | searchCount | sp_search_invoice_adjust_count | 인보이스 목록 카운트 |
| /selectInfo.do | selectInfo | sp_select_invoice_adjust | 인보이스 상세 조회 |
| /update.do | Invoiceadjustmentupdate | sp_update_invoice_adjust | 인보이스 정보 수정 |
| /updateSapStat.do | updateSapStat | sp_update_invoice_adjust_inv_no | SAP 상태 수정 |
| /updateSapInv.do | updateSapInv | sp_update_invoice_adjust_inv_no | SAP 인보이스 수정 |

### 테스트 항목
- [ ] 인보이스 목록 조회
  - [ ] 페이징 동작 확인
  - [ ] 주문번호(ordrNo) 검색
  - [ ] 기간 검색 (shipDateFr ~ shipDateTo)
  - [ ] 주문상태(ordrStat) 필터링
- [ ] 인보이스 상세 조회
  - [ ] 주문번호, 순번, 상태별 조회
- [ ] 인보이스 조정
  - [ ] SAP 주문번호 수정 (ordrNoSap)
  - [ ] 배송번호 수정 (deliNoSap)
  - [ ] 인보이스 번호 수정 (invNoSap)
  - [ ] 변경 사유 입력 (invChgRemk)
- [ ] SAP 연동
  - [ ] SAP 상태 업데이트
  - [ ] SAP 인보이스 동기화

---

# RT 모듈 (반품/이전 관리)

## 3. 반품/이전 주문 관리 (Return)

### 화면 URL
- `/common/rt/return/list.do`
- `/common/rt/return/form.do`
- `/common/rt/return/check.do` (점검 화면)

### JS 파일
- `resources/js/common/rt/return.js`

### 화면 기능
반품(RO), 이전(TO/TR) 주문 관리 및 점검 처리

### UI 구성요소
| 구성요소 | 설명 |
|----------|------|
| 반품/이전 목록 그리드 | 반품/이전 주문 목록 |
| 검색 필터 | 주문번호, 기간, 딜러, 상태 검색 |
| 등록/수정 폼 | 반품/이전 정보 입력 |
| 아이템 그리드 | 반품/이전 품목 목록 |
| 점검 화면 | 반품 점검 및 등급 평가 |
| 승인 워크플로우 | 승인 프로세스 관리 |

### 호출 API

#### 반품/이전 기본 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /search.do | search | 인라인 SQL | 반품/이전 목록 조회 (페이징) |
| /searchCount.do | searchCount | 인라인 SQL | 반품/이전 카운트 |
| /select.do | select | 인라인 SQL | 반품/이전 상세 조회 |
| /selectItem.do | selectItem | 인라인 SQL | 반품 아이템 조회 |
| /selectTransItem.do | selectTransItem | 인라인 SQL | 이전 아이템 조회 |
| /selectSwapItem.do | selectSwapItem | 인라인 SQL | 교환 아이템 조회 |
| /getRetnOrdrNo.do | getRetnOrdrNo | FN_GET_ORDR_NO | 반품 주문번호 생성 |

#### 마스터/아이템 등록
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /ordrMastInsert.do | ordrMastInsert | 인라인 SQL | 주문 마스터 등록 |
| /retnMastInsert.do | retnMastInsert | 인라인 SQL | 반품 마스터 등록 |
| /ordrItemInsert.do | ordrItemInsert | 인라인 SQL | 주문 아이템 등록 |
| /retnItemInsert.do | retnItemInsert | 인라인 SQL | 반품 아이템 등록 |
| /retnTransInsert.do | retnTransInsert | 인라인 SQL | 이전 아이템 등록 |
| /retnSwapInsert.do | retnSwapInsert | 인라인 SQL | 교환 아이템 등록 |

#### 마스터/아이템 수정
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /ordrInfoUpdate.do | ordrInfoUpdate | 인라인 SQL | 주문 정보 수정 |
| /retnMastUpdate.do | retnMastUpdate | 인라인 SQL | 반품 마스터 수정 |
| /ordrMastUpdateOrg.do | ordrMastUpdateOrg | 인라인 SQL | 원본 주문 정보 수정 |
| /retnMastUpdateOrg.do | retnMastUpdateOrg | 인라인 SQL | 원본 반품 정보 수정 |
| /ordrStatUpdate.do | ordrStatUpdate | 인라인 SQL | 주문 상태 수정 |

#### 마스터/아이템 삭제
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /ordrItemDelete.do | ordrItemDelete | 인라인 SQL | 주문 아이템 삭제 |
| /retnItemDelete.do | retnItemDelete | 인라인 SQL | 반품 아이템 삭제 |
| /ordrMastDelete.do | ordrMastDelete | 인라인 SQL | 주문 마스터 삭제 |
| /retnMastDelete.do | retnMastDelete | 인라인 SQL | 반품 마스터 삭제 |
| /retnSwapDelete.do | retnSwapDelete | 인라인 SQL | 교환 아이템 삭제 |
| /retnTransDelete.do | retnTransDelete | 인라인 SQL | 이전 아이템 삭제 |

#### 주문 검색/조회
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /searchAddr.do | searchAddr | 인라인 SQL | 주소 검색 |
| /searchOrder.do | searchOrder | 인라인 SQL | 주문 검색 |
| /searchOrderHist.do | searchOrderHist | 인라인 SQL | 주문 이력 검색 |
| /searchOrderSeriNo.do | searchOrderSeriNo | 인라인 SQL | 시리얼 번호로 주문 검색 |
| /getOderInfo.do | getOderInfo | 인라인 SQL | 주문 정보 조회 |

#### 점검 관리
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /getCheckItem.do | getCheckItem | 인라인 SQL | 점검 아이템 조회 |
| /getCheckMiss.do | getCheckMiss | 인라인 SQL | 누락 점검 조회 |
| /getGrad.do | getGrad | 인라인 SQL | 등급 조회 |
| /getCheckInfo.do | getCheckInfo | 인라인 SQL | 점검 정보 조회 |
| /getCheckAttLL.do | getCheckAttLL | 인라인 SQL | 점검 첨부 (LL) 조회 |
| /getCheckAttLB.do | getCheckAttLB | 인라인 SQL | 점검 첨부 (LB) 조회 |
| /getCheckAttOTH.do | getCheckAttOTH | 인라인 SQL | 점검 첨부 (기타) 조회 |

#### 점검 등록/수정
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /mastInsert.do | mastInsert | 인라인 SQL | 점검 마스터 등록 |
| /mastUpdate.do | mastUpdate | 인라인 SQL | 점검 마스터 수정 |
| /gradInsert.do | gradInsert | 인라인 SQL | 등급 등록 |
| /gradUpdate.do | gradUpdate | 인라인 SQL | 등급 수정 |
| /checkItemInsert.do | checkItemInsert | 인라인 SQL | 점검 아이템 등록 |
| /checkItemUpdate.do | checkItemUpdate | 인라인 SQL | 점검 아이템 수정 |
| /checkAttaInsert.do | checkAttaInsert | 인라인 SQL | 점검 첨부 등록 |
| /checkAttaUpdate.do | checkAttaUpdate | 인라인 SQL | 점검 첨부 수정 |
| /checkPartInsert.do | checkPartInsert | 인라인 SQL | 점검 부품 등록 |
| /UpdateCheckAppr.do | UpdateCheckAppr | 인라인 SQL | 점검 승인 업데이트 |

#### 점검 삭제
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /chekMastDelete.do | chekMastDelete | 인라인 SQL | 점검 마스터 삭제 |
| /chekAttaDelete.do | chekAttaDelete | 인라인 SQL | 점검 첨부 삭제 |
| /chekGradDelete.do | chekGradDelete | 인라인 SQL | 점검 등급 삭제 |
| /chekItemDelete.do | chekItemDelete | 인라인 SQL | 점검 아이템 삭제 |
| /chekPartDelete.do | chekPartDelete | 인라인 SQL | 점검 부품 삭제 |

#### Wells Fargo 및 TO 생성
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /getWFInfo.do | getWFInfo | 인라인 SQL | Wells Fargo 정보 조회 |
| /setWFInfo.do | setWFInfo | 인라인 SQL | Wells Fargo 정보 설정 |
| /createTO.do | createTO | 인라인 SQL | TO 주문 생성 |

#### 메일 관련
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /getRetnReviewMailInfo.do | getRetnReviewMailInfo | 인라인 SQL | 반품 검토 메일 정보 |
| /getRetnMailMainInfo.do | getRetnMailMainInfo | 인라인 SQL | 반품 메일 기본 정보 |
| /getRetnMailTrInfo.do | getRetnMailTrInfo | 인라인 SQL | 이전 메일 정보 |
| /getRetnMailAttaInfo.do | getRetnMailAttaInfo | 인라인 SQL | 첨부 메일 정보 |

#### 주소 조회
| URL | XML query id | Query Type | 설명 |
|-----|--------------|------------|------|
| /getRetnDealAddr.do | getRetnDealAddr | 인라인 SQL | 딜러 주소 조회 |
| /getRetnWHAddr.do | getRetnWHAddr | 인라인 SQL | 창고 주소 조회 |

### 테스트 항목

#### 반품/이전 목록 조회
- [ ] 페이징 동작 확인
- [ ] 반품 유형 필터링 (RO, TO, TR)
- [ ] 기간 검색 (주문일, 등록일, 확정일 등)
- [ ] 딜러 코드 검색
- [ ] 시리얼 번호 검색
- [ ] 주문 상태 필터링
- [ ] 주문 약어(ORDR_ABBR) 검색

#### 반품/이전 등록
- [ ] 주문번호 자동 생성
- [ ] 출발 딜러(From Dealer) 정보 입력
- [ ] 도착 딜러(To Dealer) 정보 입력 (이전 시)
- [ ] 반품 사유 선택/입력
- [ ] 반품 위치 설정 (딜러/창고)
- [ ] 아이템 추가
  - [ ] 시리얼 번호 입력
  - [ ] 사용 시간 입력
  - [ ] 크레딧 금액 입력
- [ ] 교환(Swap) 정보 입력
- [ ] 이전(Transfer) 정보 입력

#### 반품/이전 수정
- [ ] 반품 정보 변경
- [ ] 아이템 정보 변경
- [ ] 상태 변경

#### 점검 관리
- [ ] 점검 정보 등록
  - [ ] 점검 아이템 등록
  - [ ] 등급 평가 (A, B, C)
  - [ ] 첨부 파일 등록
  - [ ] 부품 정보 등록
- [ ] 점검 승인 처리
- [ ] 점검 정보 수정/삭제

#### Wells Fargo 연동
- [ ] Wells Fargo 정보 조회
- [ ] Wells Fargo 정보 설정

#### TO 주문 생성
- [ ] RO에서 TO 주문 자동 생성

---

## API 파라미터 상세

### Token createToken (토큰 생성)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| userId | VARCHAR | Y | 사용자 ID |
| issuUrl | VARCHAR | N | SSO 발급 URL |
| rqstUrl | VARCHAR | N | SSO 요청 URL |

### InvoiceAdjustment search (인보이스 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| ordrNo | VARCHAR | N | 주문번호 |
| selectDate | VARCHAR | N | 날짜 유형 |
| shipDateFr | VARCHAR | N | 출하일 시작 |
| shipDateTo | VARCHAR | N | 출하일 종료 |
| ordrStat | VARCHAR | N | 주문 상태 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |

### Return search (반품/이전 목록 조회)
| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| sysId | VARCHAR | Y | 시스템 ID |
| roType | VARCHAR | Y | 반품 유형 (RO, TO, TR) |
| ORDR_DATE_FR | VARCHAR | N | 주문일 시작 |
| ORDR_DATE_TO | VARCHAR | N | 주문일 종료 |
| selectDate | VARCHAR | N | 날짜 유형 (100:주문일, 200:등록일, 300:검토일, 400:확정일) |
| ORDR_NO | VARCHAR | N | 주문번호 |
| ORDR_NO_SAP | VARCHAR | N | SAP 주문번호 |
| dealCode | VARCHAR | N | 딜러 코드 |
| SHIP_SERI_NO | VARCHAR | N | 시리얼 번호 |
| Statkey | VARCHAR | N | 상태 키워드 |
| SHIP_LOC | VARCHAR | N | 출하 위치 |
| CHAR_BM | VARCHAR | N | BM 담당자 |
| Mainkey | VARCHAR | N | 주문 약어 검색 |
| TYPE_ORDR | VARCHAR | N | 검색 유형 (Include, Only) |
| TYPE_ORDR_OP | VARCHAR | N | 검색 연산자 (AND, OR) |
| ITEM_MODL | VARCHAR | N | 품목 모델 |
| CH_YN | VARCHAR | N | 점검 여부 (Y, N) |
| REF_NO | VARCHAR | N | 참조 번호 |
| gsLang | VARCHAR | N | 언어 |
| start | VARCHAR | N | 페이징 시작 |
| end | VARCHAR | N | 페이징 종료 |
