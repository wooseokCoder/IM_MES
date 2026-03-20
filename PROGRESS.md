# 전환 작업 진행 현황

## 개요

| 항목             | 내용                                                  |
|------------------|-------------------------------------------------------|
| **원본 시스템**  | C:\proActive (C# Windows Forms + DevExpress)          |
| **대상 시스템**  | C:\mes\workspace\IM_MES (Java Web + Spring MVC)       |
| **시작일**       | 2025-01-27                                            |
| **최종 수정일**  | 2026-03-03                                            |

---

## 전환 요약

| 모듈     | 설명           | 전체    | 완료  | 진행중 | 대기    |
|----------|----------------|---------|-------|--------|---------|
| ORD      | 주문           | 26      | 2     | 0      | 24      |
| POP      | 생산           | 30      | 0     | 0      | 30      |
| STD      | 기준정보       | 33      | 7     | 0      | 26      |
| PLN      | 계획           | 22      | 0     | 0      | 22      |
| QCT      | 품질           | 12      | 2     | 1      | 9       |
| PUR      | 구매           | 29      | 0     | 0      | 29      |
| REP      | 리포트         | 23      | 1     | 0      | 22      |
| MAT      | 자재           | 5       | 0     | 0      | 5       |
| HIS      | 이력           | 5       | 0     | 0      | 5       |
| MNT      | 설비/유지보수  | 4       | 0     | 0      | 4       |
| TOL      | 금형/공구      | 5       | 0     | 0      | 5       |
| SYS      | 시스템         | 19      | 0     | 0      | 19      |
| **합계** |                | **213** | **12** | **1** | **200** |

---

## 상태 정의

| 상태        | 설명                   |
|-------------|------------------------|
| ⬜ 대기     | 아직 시작 안함         |
| 🔄 진행중   | 작업 중                |
| ✅ 완료     | 전환 완료              |
| ⚠️ 검토필요 | 전환했으나 확인 필요   |
| ❌ 보류     | 이슈로 인해 보류       |

---

## 현재 작업

> ORD15A (실적/비가동 현황) 개발 준비 완료 — SP 적용 후 테스트 필요

---

## 모듈별 상세 현황

### ORD (주문) - 2/26

| 화면ID  | 화면명                 | 상태 | Controller | Service | Mapper | JSP | JS | 비고                              |
|---------|------------------------|------|------------|---------|--------|-----|----|-----------------------------------|
| ORD01A  |                        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                   |
| ORD02A  | 이메일수신자그룹관리   | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 좌우분할 마스터-디테일 + D0A 팝업 |
| ORD03A  | 월별생산계획           | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                   |
| ORD04A  |                        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                   |
| ORD05A  |                        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                   |
| ORD06A  |                        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                   |
| ORD07A  | 일련번호관리           | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 단일 그리드 + D0A 팝업            |
| ORD08A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD09A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD10A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD11A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD12A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD13A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD14A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD15A  | 실적/비가동 현황 | 🔄   | ✅         | ✅      | ✅     | ✅  | ✅ | SP 미적용 |
| ORD16A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD17A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD18A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD26A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD27A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD28A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD29A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD30A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD30B  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD31A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| ORD32A  |              | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### POP (생산) - 1/30

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| POP01A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP01B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP02A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP07A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP08A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP09A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP10A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP11A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP13A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP20A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP20B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP20C  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP20D  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP21A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP30A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP30B_D4A | 자주검사입력(가공) | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ | 내 담당, POP30B 자주검사 팝업 |
| POP30C  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP30D  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP31A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP31B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP32A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP32B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP33A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP40A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP40B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP41A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP42A  | 일일점검이력조회 | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 좌우분할 마스터-디테일 (조회전용) |
| POP43A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP54A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| POP55A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### STD (기준정보) - 7/33

| 화면ID  | 화면명           | 상태 | Controller | Service | Mapper | JSP | JS | 비고                                      |
|---------|------------------|------|------------|---------|--------|-----|----|-------------------------------------------|
| STD01A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD02A  | 완제품코드관리   | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD02B  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD03A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD04A  | 표준자원관리     | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 상하분할(자원+가용사원) + D0A/D1A 팝업             |
| STD05A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD06A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD07A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD07B  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD08A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD09A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD10A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD13A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD14A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD20A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                           |
| STD23A  | 생산능력관리     | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 달력+CAPA 그리드 + D0B/D1B/D2B 팝업      |
| STD23B  | 휴일관리         | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 달력+휴일그리드 + D1B 팝업 (STD23A 공유)  |
| STD26A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                     |
| STD27A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                     |
| STD28A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                     |
| STD31A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                     |
| STD41A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                     |
| STD42A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                     |
| STD43A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                     |
| STD44A  | 모델군관리       | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 3단 수평분할 (구분→시리즈→모델)     |
| STD45A  | 비가동코드관리   | -    | -          | -       | -      | -   | -  | Golden Sample (참조 전용, 수정 금지) |
| STD46A  | ST그룹관리       | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                      |
| STD47A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                      |
| STD48A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                      |
| STD49A  | 정례비가동관리   | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 타 담당 (수정 금지)                  |
| STD50A  | 작업자그룹관리   | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 타 담당 (수정 금지)                  |
| STD51A  |                  | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |                                      |
| STD52A  | 일일설비점검관리 | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 단일 그리드 + 등록/수정 다이얼로그   |

---

### PLN (계획) - 0/22

| 화면ID      | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|-------------|--------|------|------------|---------|--------|-----|----|------|
| DEFAULT00A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN01A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN01B      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN01C      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN02A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN03A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN04A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN05A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN06A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN07A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN08A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN10A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN10B      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN10C      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN10D      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN11A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN11B      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN11C      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN12A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN14A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN15A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PLN17A      |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### QCT (품질) - 1/12

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| QCT01A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| QCT01B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| QCT02A  | 부적합/결품 현황 | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 조회전용, 내부 탭(조립/가공) + D0A 사진보기 팝업 |
| QCT03A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| QCT04A  | 자주검사항목관리 | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 공용 JSP + D1A 검사그룹 + 이미지 URL방식                       |
| QCT05A  | 자주검사그룹관리 | ⚠️   | ✅         | ✅      | ✅     | ✅  | ✅ | 공용 JSP + D0A 검사항목매핑 + 이미지 (화면 확인 필요)          |
| QCT06A  | 자주검사연계관리 | 🔄   | ✅         | ✅      | ✅     | ✅  | ✅ | 2탭(조립/그룹연계리스트), 조립탭 가로3분할(모델/검사그룹/검사항목), D0A 팝업, 컨텍스트메뉴 삭제 — UI 조정 중 |
| QCT07A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| QCT08A  | 자주검사현황     | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 내 담당 |
| QCT09A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| QCT10A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| QCT11A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### PUR (구매) - 0/29

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| PUR01B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR03B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR03C  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR05B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR05C  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR06B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR07A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR09A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR11B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR13B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR13C  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR14A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR15A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR16A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR17A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR30A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR31A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR32A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR33A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR41A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR41B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR54A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR55B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR56A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR57A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR58A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR59A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR60A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| PUR60B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### REP (리포트) - 0/23

| 화면ID  | 화면명         | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|----------------|------|------------|---------|--------|-----|----|------|
| REP01A  | 설비효율리포트   | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP02A  | 자재불출현황     | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP03A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP04A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP05A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP06A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP07A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP08A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP09A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP10A  | 작업자현황     | ✅   | ✅         | ✅      | ✅     | ✅  | ✅ | 조회전용, 단일 그리드 |
| REP11A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP12A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP13A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP14A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP15A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP16A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP17A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP18A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP19A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP20A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP21A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP22A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| REP23A  |                | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### MAT (자재) - 0/5

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| MAT01A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| MAT02A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| MAT03A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| MAT04A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| MAT05A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### HIS (이력) - 0/5

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| HIS01A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| HIS02A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| HIS03A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| HIS04A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| HIS04B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### MNT (설비/유지보수) - 0/4

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| MNT01A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| MNT02A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| MNT03A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| MNT10A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### TOL (금형/공구) - 0/5

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| TOL01A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| TOL02A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| TOL03A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| TOL04A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| TOL05A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

### SYS (시스템) - 0/19

| 화면ID  | 화면명 | 상태 | Controller | Service | Mapper | JSP | JS | 비고 |
|---------|--------|------|------------|---------|--------|-----|----|------|
| SYS01A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS02A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS03A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS04A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS04B  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS04D  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS05A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS06A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS07A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS08A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS09A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS10A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS11A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS12A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS13A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS32A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS41A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS77A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |
| SYS78A  |        | ⬜   | ❌         | ❌      | ❌     | ❌  | ❌ |      |

---

## 완료 이력

| 날짜       | 화면ID | 작업 내용                                                              | 작업자 |
|------------|--------|------------------------------------------------------------------------|--------|
| 2026-01-27 | STD52A | 일일설비점검관리 개발, 단일 그리드 + 등록/수정 다이얼로그              | 송우석 |
| 2026-02-10 | ORD02A | 이메일수신자그룹관리 신규 개발, 좌우분할 마스터-디테일 + D0A 엑셀업로드 | 송우석 |
| 2026-02-10 | ORD07A | 일련번호관리 신규 개발, 단일 그리드 + D0A 팝업 (호기 순번 수정)        | 송우석 |
| 2026-02-10 | STD49A | 정례비가동관리 신규 개발, ASSY/MACH 탭 분리 + 편집 다이얼로그          | 송우석 |
| 2026-02-10 | STD50A | 작업자그룹관리 신규 개발, 상하 분할 (그룹+작업장/작업자)               | 송우석 |
| 2026-02-11 | STD23A | 생산능력관리 신규 개발, 달력+CAPA 그리드 + D0B/D1B/D2B 팝업            | 송우석 |
| 2026-02-11 | STD23B | 휴일관리 신규 개발, 연간 달력+휴일 그리드 + D1B 팝업                   | 송우석 |
| 2026-02-12 | 공통   | acEmpForm (사원 검색 공통 팝업) 신규 개발, acORGForm 패턴 준수          | 송우석 |
| 2026-02-23 | STD04A | 표준자원관리 개발 진행중 — 전체 코드 작성 완료, UI 미세조정 중         | 송우석 |
| 2026-02-24 | STD44A | 모델군관리 신규 개발, 3단 수평분할 (구분→시리즈→모델)                  | 송우석 |
| 2026-02-26 | STD04A | 표준자원관리 완료, 상하분할(자원+가용사원) + D0A/D1A 팝업              | 송우석 |
| 2026-02-27 | QCT04A | 자주검사항목관리 코드 생성, ASSY/PROC 탭 + D1A 검사그룹 팝업           | 송우석 |
| 2026-03-03 | QCT04A | 이미지 URL방식 변환 (base64→hasImg+URL), DELIMITER 패턴 통일           | 송우석 |
| 2026-03-04 | QCT05A | 자주검사그룹관리 신규 개발, ASSY/MACH 탭 분리 + D0A 검사항목매핑 + 이미지 | 송우석 |
| 2026-03-04 | QCT04A | 가공 탭 ID 변경 (_proc → _mach), SP DB 적용 완료                         | 송우석 |
| 2026-03-04 | QCT05A | 가공 탭 ID 변경 (_proc → _mach), SP DB 적용 완료                         | 송우석 |
| 2026-03-09 | QCT02A | 부적합/결품 현황 신규 개발, 조회전용 내부 탭(조립/가공) + D0A 사진보기 팝업 | 송우석 |

### 참고: Golden Sample

| 날짜       | 화면ID | 작업 내용                                                | 비고             |
|------------|--------|----------------------------------------------------------|------------------|
| 2026-01-27 | STD45A | 비가동코드관리, ASSY/MACH 탭 분리                        | 참조 전용, 수정 금지 |

---

## 완료 화면 상세

### STD52A - 일일설비점검관리

| 항목       | 내용                                                            |
|------------|-----------------------------------------------------------------|
| 화면유형   | 단일 그리드 + 등록/수정 다이얼로그                              |
| 테이블     | TSTD_MC_DAILY_CHECK                                             |
| 파일 수    | Controller 1, Service 1, Mapper 2, JSP 2 (메인/dialog), JS 1 = 총 7개 |
| 비고       | include 방식 다이얼로그                                         |

### ORD02A - 이메일수신자그룹관리

| 항목       | 내용                                                                                  |
|------------|---------------------------------------------------------------------------------------|
| 화면유형   | 좌우 분할 마스터(그룹)-디테일(사원) + D0A 엑셀업로드 팝업                             |
| 테이블     | TORD_EMAIL_GROUP, TORD_EMAIL_GROUP_EMP                                                |
| 파일 수    | Controller 1, Service 1, Mapper 4, JSP 3 (메인/d0a/dialog), JS 1 = 총 10개           |
| 주요 기능  | 그룹 CRUD, 사원 CRUD, 엑셀업로드 (SheetJS 클라이언트 파싱), overwrite 덮어쓰기 처리  |
| 미해결     | 사원검색 API (doEmpSearchQuery) 연동 대기                                             |

### ORD07A - 일련번호관리

| 항목       | 내용                                                       |
|------------|------------------------------------------------------------|
| 화면유형   | 단일 그리드 + D0A 팝업 (호기 순번 수정)                    |
| 테이블     | TSYS_SERIAL                                                |
| 파일 수    | Controller 1, Service 1, Mapper 2, JSP 2 (메인/d0a), JS 1 = 총 7개 |
| 주요 기능  | 일련번호 조회, 호기 순번 수정 (D0A href 팝업)              |

### STD23A - 생산능력관리

| 항목       | 내용                                                                              |
|------------|-----------------------------------------------------------------------------------|
| 화면유형   | 좌우 분할 (달력+CAPA 그리드) + D0B/D1B/D2B 팝업                                  |
| 테이블     | TSTD_MC_DAILYCAPA, LSE_HOLIDAY, LSE_MACHINE, LSE_MC_WORKTIME, LSE_MC_CAPAPLAN    |
| 파일 수    | Controller 1, Service 1, Mapper 8, JSP 4 (메인/d0b/d1b/d2b), JS 1 = 총 15개     |
| 주요 기능  | 연간 달력(12개월), CAPA 생성/변경, 휴일설정/해제, 달력 우클릭 컨텍스트 메뉴       |

### STD23B - 휴일관리

| 항목       | 내용                                                                           |
|------------|--------------------------------------------------------------------------------|
| 화면유형   | 좌우 분할 (연간 달력+휴일 그리드) + D1B 팝업 (STD23A 공유)                     |
| 테이블     | LSE_HOLIDAY (STD23A 매퍼 공유)                                                 |
| 파일 수    | Controller 1, Service 1, Mapper 공유, JSP 1, JS 1 = 총 4개 (공유 제외)         |
| 주요 기능  | 연간 달력, 휴일설정/해제 (컨텍스트 메뉴), 날짜 선택 유지, 그리드 컬럼 동적 리사이즈 |

### STD49A - 정례비가동관리

| 항목       | 내용                                                                     |
|------------|--------------------------------------------------------------------------|
| 화면유형   | ASSY/MACH 탭 분리 + 편집 다이얼로그 (STD45A 패턴)                        |
| 테이블     | TSTD_IDLETIME                                                            |
| 파일 수    | Controller 1, Service 1, Mapper 2, JSP 3 (assy/mach/dialog), JS 1 = 총 8개 |
| 주요 기능  | 비가동 시간 조회/등록/수정/삭제, ASSY/MACH 공장별 분리                    |

### STD04A - 표준자원관리

| 항목       | 내용                                                                                       |
|------------|--------------------------------------------------------------------------------------------|
| 화면유형   | 상하 분할 (상: 자원 목록 그리드, 하: 가용사원 그리드) + D0A 편집 팝업 + D1A 엑셀업로드 팝업 |
| 테이블     | LSE_MACHINE, LSE_MC_WORKTIME, TSTD_MC_AVAILEMP                                            |
| 파일 수    | Controller 1, Service 1, Mapper 5, JSP 3 (메인/d0a/d1a), JS 1, SQL 2 = 총 13개            |
| 주요 기능  | 자원(설비) CRUD, 가용사원 배정, 엑셀 일괄 업로드 (SheetJS), OVERWRITE 처리                  |
| 현재 상태  | 완료                                                                                        |

**파일 목록**:

| 레이어     | 파일                                                                       |
|------------|----------------------------------------------------------------------------|
| Controller | `com/wsc/imes/std/Std04aController.java`                                   |
| Service    | `com/wsc/imes/std/Std04aService.java`                                      |
| Mapper     | `mappers/imes/std/LSE_MACHINE.xml`                                         |
| Mapper     | `mappers/imes/std/LSE_MACHINE_QUERY.xml`                                   |
| Mapper     | `mappers/imes/std/LSE_MC_WORKTIME.xml`                                     |
| Mapper     | `mappers/imes/std/TSTD_MC_AVAILEMP.xml`                                   |
| Mapper     | `mappers/imes/std/TSTD_MC_AVAILEMP_QUERY.xml`                             |
| JSP        | `views/imes/std/std04a.jsp` (메인)                                         |
| JSP        | `views/imes/std/std04a_d0a.jsp` (D0A 편집 팝업)                           |
| JSP        | `views/imes/std/std04a_d1a.jsp` (D1A 엑셀업로드 팝업)                     |
| JS         | `js/imes/std/std04a.js`                                                    |
| SQL        | `sql/imes/std/sp_imes_lse_machine_procedures.sql`                          |
| SQL        | `sql/imes/std/sp_imes_lse_machine_query_procedures.sql`                    |

---

### STD44A - 모델군관리

| 항목       | 내용                                                                              |
|------------|-----------------------------------------------------------------------------------|
| 화면유형   | 3단 수평 분할 (구분(B) → 시리즈(M) → 모델(S))                                    |
| 테이블     | TSTD_MODEL                                                                        |
| 파일 수    | Controller 1, Service 1, Mapper 2, JSP 1, JS 1, SQL 2 = 총 8개                   |
| 주요 기능  | 모델군 목록 조회, 등록, 수정, 삭제                                                |

**파일 목록**:

| 레이어     | 파일                                                                       |
|------------|----------------------------------------------------------------------------|
| Controller | `com/wsc/imes/std/Std44aController.java`                                   |
| Service    | `com/wsc/imes/std/Std44aService.java`                                      |
| Mapper     | `mappers/imes/std/TSTD_MODEL.xml`                                          |
| Mapper     | `mappers/imes/std/TSTD_MODEL_QUERY.xml`                                    |
| JSP        | `views/imes/std/std44a.jsp` (메인)                                         |
| JS         | `js/imes/std/std44a.js`                                                    |
| SQL        | `sql/imes/std/sp_imes_tstd_model_procedures.sql`                           |
| SQL        | `sql/imes/std/sp_imes_tstd_model_query_procedures.sql`                     |

---

### QCT04A - 자주검사항목관리

| 항목       | 내용                                                                                                 |
|------------|------------------------------------------------------------------------------------------------------|
| 화면유형   | 공용 JSP + D1A 검사그룹 팝업 + 이미지 관리 (URL 방식)                                               |
| 테이블     | TSTD_PROC_INS, TSTD_INS_GRP_LIST, LSE_STD_PROC                                                     |
| 파일 수    | Controller 1, Service 1, Mapper 4, JSP 2 (공용/d1a), JS 1, SQL 5 = 총 14개                          |
| 주요 기능  | 검사항목 CRUD, 이미지 첨부/클립보드(복사/잘라내기/붙여넣기/삭제), 검사그룹 배정(D1A)                   |
| 특이사항   | 이미지를 base64 JSON 대신 URL 방식으로 제공 (hasImg 플래그 + QCT04A_IMG.do 엔드포인트)                |
| 현재 상태  | ✅ 완료 (SP DB 적용 완료)                                                                            |

**파일 목록**:

| 레이어     | 파일                                                                       |
|------------|----------------------------------------------------------------------------|
| Controller | `com/wsc/imes/qct/Qct04aController.java`                                  |
| Service    | `com/wsc/imes/qct/Qct04aService.java`                                     |
| Mapper     | `mappers/imes/qct/TSTD_PROC_INS.xml`                                      |
| Mapper     | `mappers/imes/qct/TSTD_PROC_INS_QUERY.xml`                                |
| Mapper     | `mappers/imes/qct/TSTD_INS_GRP_LIST.xml`                                  |
| Mapper     | `mappers/imes/qct/TSTD_INS_GRP_LIST_QUERY.xml`                            |
| JSP        | `views/imes/qct/qct04a.jsp` (ASSY/MACH 공용)                              |
| JSP        | `views/imes/qct/qct04a_d1a.jsp` (D1A 검사그룹 팝업)                       |
| JS         | `js/imes/qct/qct04a.js`                                                    |
| SQL        | `sql/imes/qct/sp_imes_tstd_proc_ins_procedures.sql`                        |
| SQL        | `sql/imes/qct/sp_imes_tstd_proc_ins_query_procedures.sql`                  |
| SQL        | `sql/imes/qct/sp_imes_lse_std_proc_ser2.sql`                               |
| SQL        | `sql/imes/qct/sp_imes_tstd_ins_grp_list_procedures.sql`                    |
| SQL        | `sql/imes/qct/sp_imes_tstd_ins_grp_list_query_procedures.sql`              |

---

### QCT05A - 자주검사그룹관리

| 항목       | 내용                                                                                               |
|------------|----------------------------------------------------------------------------------------------------|
| 화면유형   | 공용 JSP + D0A 검사항목 매핑 팝업 (좌우 이동) + 이미지 관리 (MACH만)                              |
| 테이블     | TSTD_INS_GRP, TSTD_INS_GRP_LIST, TSTD_PROC_INS                                                   |
| 파일 수    | Controller 1, Service 1, Mapper 2, JSP 2 (공용/d0a), JS 1, SQL 2 = 총 9개                         |
| 주요 기능  | 검사그룹 CRUD(UPSERT), 검사항목 매핑(D0A), 이미지 첨부/조회(MACH), D0A Delete-Insert 저장          |
| 현재 상태  | ⚠️ 코드 완료, SP DB 적용 완료, 화면 확인 필요                                                     |

**파일 목록**:

| 레이어     | 파일                                                                       |
|------------|----------------------------------------------------------------------------|
| Controller | `com/wsc/imes/qct/Qct05aController.java`                                  |
| Service    | `com/wsc/imes/qct/Qct05aService.java`                                     |
| Mapper     | `mappers/imes/qct/TSTD_INS_GRP.xml`                                       |
| Mapper     | `mappers/imes/qct/TSTD_INS_GRP_QUERY.xml`                                 |
| JSP        | `views/imes/qct/qct05a.jsp` (ASSY/MACH 공용)                              |
| JSP        | `views/imes/qct/qct05a_d0a.jsp` (D0A 검사항목 매핑 팝업)                  |
| JS         | `js/imes/qct/qct05a.js`                                                    |
| SQL        | `sql/imes/qct/sp_imes_tstd_ins_grp_procedures.sql`                         |
| SQL        | `sql/imes/qct/sp_imes_tstd_ins_grp_query_procedures.sql`                   |

---

### QCT02A - 부적합/결품 현황

| 항목       | 내용                                                                                    |
|------------|-----------------------------------------------------------------------------------------|
| 화면유형   | 조회 전용, 내부 탭(조립/가공) + D0A 사진보기 팝업                                       |
| 테이블     | TSHP_NG (주), TSHP_WORKORDER, TORD_PRODUCT, TSTD_MODEL, LSE_STD_PART 등 9개 테이블 JOIN |
| 파일 수    | Controller 1, Service 1, Mapper 1, JSP 2 (메인/d0a), JS 1, SQL 1 = 총 7개             |
| 주요 기능  | 부적합/결품 목록 조회, 사진보기 (이미지 4개 바이너리 서빙)                               |
| 특이사항   | CRUD 없음 (조회 버튼만), 39개 컬럼 그리드, QMS 인터페이스 데이터 포함                    |

**파일 목록**:

| 레이어     | 파일                                                                       |
|------------|----------------------------------------------------------------------------|
| Controller | `com/wsc/imes/qct/Qct02aController.java`                                  |
| Service    | `com/wsc/imes/qct/Qct02aService.java`                                     |
| Mapper     | `mappers/imes/qct/TSHP_NG_QUERY.xml`                                      |
| JSP        | `views/imes/qct/qct02a.jsp` (메인 - 내부 탭: 조립/가공)                   |
| JSP        | `views/imes/qct/qct02a_d0a.jsp` (D0A 사진보기 팝업)                       |
| JS         | `js/imes/qct/qct02a.js`                                                    |
| SQL        | `sql/imes/qct/sp_imes_tshp_ng_query_procedures.sql`                        |

---

### STD50A - 작업자그룹관리

| 항목       | 내용                                                                     |
|------------|--------------------------------------------------------------------------|
| 화면유형   | 상하 분할 (상: 그룹 목록, 하: 소속 작업장+작업자)                        |
| 테이블     | TSTD_WORKGROUP                                                           |
| 파일 수    | Controller 1, Service 1, Mapper 2, JSP 2 (메인/dialog), JS 1 = 총 7개   |
| 주요 기능  | 작업자 그룹 CRUD, 소속 작업장/작업자 조회                                |

---

## 공통 산출물

| 파일                                                  | 용도                                          |
|-------------------------------------------------------|-----------------------------------------------|
| `java/imes/common/UtilityService.java`                | 공통 채번 서비스                               |
| `mappers/imes/common/Utility.xml`                     | 공통 채번 (sp_imes_utility_get_serialno)       |
| `mappers/imes/std/TSTD_EMPLOYEE.xml`                  | 공통 사원 조회 (SER)                           |
| `framework/exception/GlobalExceptionHandler.java`     | 전역 예외 처리                                 |
| `views/imes/com/acORGForm.jsp` + `js/imes/com/acORGForm.js` | 공통 부서 검색 팝업 (acORGForm) ✅      |
| `mappers/common/board/OrgSearch.xml`                  | 조직 계층형 검색 (TreeGrid용) ✅               |

### 공통 팝업 (acForm 시리즈) — `imes/com/` 경로

| acForm           | AS-IS                                  | 상태   | JSP                      | JS                      | Mapper                  |
|------------------|----------------------------------------|--------|--------------------------|-------------------------|-------------------------|
| acORGForm        | `CodeHelperManager.acORGForm` (부서)   | ✅     | `views/imes/com/acORGForm.jsp` | `js/imes/com/acORGForm.js` | `OrgSearch.xml`     |
| acEmpForm        | `CodeHelperManager.acEmpForm` (사원)   | ✅     | `views/imes/com/acEmpForm.jsp` | `js/imes/com/acEmpForm.js` | `EmpSearch.xml`     |
| acMachineForm    | `CodeHelperManager.acMachineForm` (설비)| ✅    | `views/imes/com/acMachineForm.jsp` | `js/imes/com/acMachineForm.js` | `MachineSearch.xml` | 내 담당 |

> 상세 규칙: [`docs/popup_standard.md`](docs/popup_standard.md)

---

## 전환 규칙 참조

### 파일 매핑

```
원본 (C:\proActive\DecompiledSrc)                   대상 (IM_MES)
─────────────────────────────────────────────────────────────────────────
{MOD}/{MOD}/{MOD}##A_M0A.cs (화면)             →    views/{mod}/{mod}##a.jsp
                                                    js/{mod}/{mod}##a.js
CUBIZ_BR/B{MOD}/{MOD}##A.cs (비즈니스)         →    com.wsc.{mod}.{Mod}##aService.java
CUBIZ_DA/D{MOD}/T{MOD}_*.cs (데이터접근)       →    mappers/{mod}/{Mod}##a.xml
```

### 네이밍 변환

| 원본 (C#)                 | 대상 (Java)                |
|---------------------------|----------------------------|
| ORD03A_M0A.cs             | ord03a.jsp, ord03a.js      |
| ORD03A.cs (BR)            | Ord03aService.java         |
| TORD_PRODUCT_QUERY.cs     | Ord03a.xml                 |

---

## 참고 문서

- 원본 프로젝트 가이드: `C:\proActive\CLAUDE.md`
- 대상 프로젝트 가이드: `C:\mes\workspace\IM_MES\CLAUDE.md`
- JSP 규칙: `C:\mes\workspace\IM_MES\src\main\webapp\WEB-INF\views\CLAUDE.md`
- JS 규칙: `C:\mes\workspace\IM_MES\src\main\webapp\resources\js\CLAUDE.md`
