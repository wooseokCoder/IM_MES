# PROJECT_MAP.md - IM_MES 프로젝트 구조 맵

> 작성자: 송우석
> 빌드 산출물(`WEB-INF/lib/`, `WEB-INF/classes/`, `target/`) 및 `.git/` 제외

---

## 루트 디렉토리

```
IM_MES/
├── .classpath                        # Eclipse 클래스패스 설정
├── .project                          # Eclipse 프로젝트 설정
├── .claudeignore                     # Claude 탐색 제외 설정
├── .gitignore                        # Git 무시 파일
├── CLAUDE.md                         # 프로젝트 개발 가이드
├── PROJECT_MAP.md                    # 프로젝트 구조 맵 (본 파일)
├── PROGRESS.md                       # 진행상황 추적
├── doc/                              # 문서
├── sql/                              # 저장 프로시저 SQL
├── src/                              # 소스 코드
└── upload/                           # 파일 업로드 디렉토리
    ├── excel/
    └── real/
```

---

## doc/ - 문서

```
doc/
├── database/
│   ├── ERD.md                        # 데이터베이스 ERD
│   ├── install/
│   │   ├── ddl_create.sql            # DDL 생성 스크립트
│   │   ├── ddl_notused.sql           # 미사용 DDL
│   │   └── dml_create.sql            # DML 생성 스크립트
│   ├── scripts/loader/
│   │   ├── data_sample.sql           # 로더 샘플 데이터
│   │   └── table_create.sql          # 로더 테이블 생성
│   ├── work/
│   │   ├── modify.sql
│   │   ├── sample.sql
│   │   ├── system.sql
│   │   ├── tables.sql
│   │   └── view.sql
│   ├── modify.sql
│   ├── sample.sql
│   ├── system.sql
│   ├── tables.sql
│   └── view.sql
├── design/
│   ├── 시공실적.jpg
│   ├── 작성중.jpg
│   ├── 증명발급신청.jpg
│   └── 최종메인.jpg
├── document/
│   ├── WSC_FRAMEWORK_개발가이드.docx
│   ├── WSC_FRAMEWORK_개발가이드_v0.2.docx
│   ├── WSC_FRAMEWORK_개발가이드_v0.3.docx
│   ├── WSC_FRAMEWORK_개발가이드_v0.4.docx
│   ├── WSC_FRAMEWORK_개발가이드_v0.5.docx
│   ├── WSC_FRAMEWORK_개발관리.xlsx
│   ├── WSC_FRAMEWORK_디자인가이드.docx
│   ├── WSC_FRAMEWORK_보완사항.xlsx
│   └── WSC_TableDesign_v0.2.xlsm
├── reference/
│   ├── 개발가이드.pptx
│   ├── 개발가이드.txt
│   ├── 다국어DB언어셋팅.pptx
│   ├── 버튼권한관리.xlsx
│   └── samples/excel_loader/
│       ├── codeLoader_sample.xlsx
│       ├── loader_sample.xlsx
│       └── testLoader_sample.xlsx
├── common_app_drawing_excel_test_plan.md
├── common_board_test_plan.md
├── common_code_test_plan.md
├── common_code2_code3_test_plan.md
├── common_exhbn_test_plan.md
├── common_file_test_plan.md
├── common_ftk_invoice_rt_test_plan.md
├── common_loader_test_plan.md
├── common_mail_test_plan.md
├── common_report_test_plan.md
├── common_sample_test_warranty_test_plan.md
├── common_user_board_code_additional_test_plan.md
├── common_user_test_plan.md
├── common_user2_user3_test_plan.md
├── ord03a_progress.md
└── ord06a_progress.md
```

---

## sql/ - 저장 프로시저

```
sql/
├── menu_procedures.sql
├── procedure_conversion_summary.csv
├── sp_address_procedures.sql
├── sp_alter_procedures.sql
├── sp_autologintest_procedures.sql
├── sp_bank_search_procedures.sql
├── sp_batch_procedures.sql
├── sp_batchstatus_procedures.sql
├── sp_batchwork_procedures.sql
├── sp_batchworkrevise_procedures.sql
├── sp_board_common_procedures.sql
├── sp_board_help_procedures.sql
├── sp_board_management_procedures.sql
├── sp_board_notification_procedures.sql
├── sp_board_procedures_crud.sql
├── sp_board_procedures_dashboard.sql
├── sp_board_procedures_target.sql
├── sp_bulletin_procedures.sql
├── sp_code_procedures.sql
├── sp_code2_procedures.sql
├── sp_code3_procedures.sql
├── sp_data_management_procedures.sql
├── sp_data_search_procedures.sql
├── sp_dealer_search_procedures.sql
├── sp_emailinsert_procedures.sql
├── sp_excelinfo_procedures.sql
├── sp_exhibition_procedures.sql
├── sp_file_procedures.sql
├── sp_group_procedures.sql
├── sp_group2_procedures.sql
├── sp_group3_procedures.sql
├── sp_help_procedures.sql
├── sp_image_procedures.sql
├── sp_jobhist_procedures.sql
├── sp_loader_procedures.sql
├── sp_mail_procedures.sql
├── sp_navhelp_procedures.sql
├── sp_password_procedures.sql
├── sp_program_procedures.sql
├── sp_program2_procedures.sql
├── sp_program3_procedures.sql
├── sp_qna_procedures.sql
├── sp_reference_procedures.sql
├── sp_return_procedures_01.sql
├── sp_return_procedures_02.sql
├── sp_return_procedures_03.sql
├── sp_sampleboard_procedures.sql
├── sp_screenterm_procedures.sql
├── sp_svccode_procedures.sql
├── sp_test_procedures.sql
├── sp_token_procedures.sql
├── sp_user_procedures.sql
├── sp_user2_procedures.sql
├── sp_userlog_procedures.sql
├── sp_userloglist_procedures.sql
├── sp_usersecure_procedures.sql
└── sp_video_procedures.sql
```

---

## src/main/java/ - Java 소스

### com/baroservice/ws/ - 외부 SOAP 서비스 (FAX, SMS, 세금계산서)

```
com/baroservice/ws/
├── AttachedFile.java
├── AttachedFileEx.java
├── BaroService_FAX.java
├── BaroService_FAXLocator.java
├── BaroService_FAXSoap.java
├── BaroService_FAXSoapProxy.java
├── BaroService_FAXSoapStub.java
├── BaroService_SMS.java
├── BaroService_SMSLocator.java
├── BaroService_SMSSoap.java
├── BaroService_SMSSoapProxy.java
├── BaroService_SMSSoapStub.java
├── BaroService_TI.java
├── BaroService_TILocator.java
├── BaroService_TISoap.java
├── BaroService_TISoapProxy.java
├── BaroService_TISoapStub.java
├── Contact.java
├── EMAILPUBLICKEY.java
├── FaxMessage.java
├── FaxMessageEx.java
├── InvoiceLog.java
├── InvoiceParty.java
├── LinkedDoc.java
├── NTSSendOption.java
├── PagedFaxMessages.java
├── PagedSMSMessages.java
├── PagedTaxInvoice.java
├── PagedTaxInvoiceEx.java
├── SMSMessage.java
├── SimpleTaxInvoice.java
├── SimpleTaxInvoiceEx.java
├── TaxInvoice.java
├── TaxInvoiceState.java
├── TaxInvoiceStateEX.java
├── TaxInvoiceTradeLineItem.java
└── XMSMessage.java
```

### com/lsbas/service/ - LSBAS CXF 웹서비스

```
com/lsbas/service/
├── CxfConfig.java
├── MtronUtil.java
├── IF_SFDC_DEALER_LSTA_038.java
├── IF_SFDC_DEALER_LSTA_038Impl.java
├── IF_SFDC_DEALER_LSTA_040.java
├── IF_SFDC_DEALER_LSTA_040Impl.java
├── IF_SFDC_DEALER_LSTA_041.java
├── IF_SFDC_DEALER_LSTA_041Impl.java
├── IF_SFDC_DEALER_LSTA_044.java
├── IF_SFDC_DEALER_LSTA_044Impl.java
├── IF_SFDC_DEALER_LSTA_046.java
├── IF_SFDC_DEALER_LSTA_046Impl.java
├── if_sfdc_dealer_lsta_038/
│   ├── request/
│   │   ├── IF_SFDC_DEALER_LSTA_038_data.java
│   │   └── IF_SFDC_DEALER_LSTA_038_request.java
│   └── response/
│       └── IF_SFDC_DEALER_LSTA_038_response.java
├── if_sfdc_dealer_lsta_040/
│   ├── request/
│   │   ├── IF_SFDC_DEALER_LSTA_040_data.java
│   │   └── IF_SFDC_DEALER_LSTA_040_request.java
│   └── response/
│       └── IF_SFDC_DEALER_LSTA_040_response.java
├── if_sfdc_dealer_lsta_041/
│   ├── request/
│   │   ├── IF_SFDC_DEALER_LSTA_041_data.java
│   │   └── IF_SFDC_DEALER_LSTA_041_request.java
│   └── response/
│       └── IF_SFDC_DEALER_LSTA_041_response.java
├── if_sfdc_dealer_lsta_044/
│   ├── request/
│   │   ├── IF_SFDC_DEALER_LSTA_044_data.java
│   │   └── IF_SFDC_DEALER_LSTA_044_request.java
│   └── response/
│       └── IF_SFDC_DEALER_LSTA_044_response.java
└── if_sfdc_dealer_lsta_046/
    ├── request/
    │   ├── IF_SFDC_DEALER_LSTA_046_data.java
    │   └── IF_SFDC_DEALER_LSTA_046_request.java
    └── response/
        └── IF_SFDC_DEALER_LSTA_046_response.java
```

### com/wsc/business/ - 비즈니스 로직

```
com/wsc/business/
├── community/
│   ├── CommunityManagementController.java
│   └── CommunityManagementService.java
├── company/
│   ├── AccountManagementController.java
│   ├── AccountManagementService.java
│   ├── CloseManagementController.java
│   ├── CloseManagementService.java
│   ├── CompanyRegistrationController.java
│   ├── CompanyRegistrationService.java
│   ├── SaledailyactivityreportController.java
│   └── SaledailyactivityreportService.java
├── employee/
│   ├── EmployeeController.java
│   ├── EmployeeService.java
│   ├── tmpemployeeController.java
│   └── tmpemployeeService.java
└── item/
    ├── CommodityMaterialCodeController.java
    ├── CommodityMaterialCodeService.java
    ├── ModelManagementController.java
    ├── ModelManagementService.java
    ├── ProductsUploadController.java
    ├── ProductsUploadService.java
    ├── ProductsViewController.java
    ├── ProductsViewService.java
    ├── productsview_newController.java
    ├── productsview_newService.java
    ├── ProjectManagementController.java
    └── ProjectManagementService.java
```

### com/wsc/canvas/ - 캔버스

```
com/wsc/canvas/
├── CanvasService.java
└── CanvasTestController.java
```

### com/wsc/common/ - 공통 모듈

```
com/wsc/common/
├── Consts.java
├── app/
│   ├── AppController.java
│   └── AppService.java
├── board/
│   ├── AlterController.java
│   ├── AlterService.java
│   ├── BoardController.java
│   ├── BoardGroup.java
│   ├── BoardManagementController.java
│   ├── BoardManagementService.java
│   ├── BoardService.java
│   ├── EmailController.java
│   ├── FormsController.java
│   ├── HelpController.java
│   ├── HelpService.java
│   ├── ImageController.java
│   ├── ImageService.java
│   ├── LsqnaController.java
│   ├── MyViewSearchController.java
│   ├── MyViewSearchService.java
│   ├── NavHelpController.java
│   ├── NavHelpService.java
│   ├── NoticeController.java
│   ├── NotificationController.java
│   ├── NotificationService.java
│   ├── PopupController.java
│   ├── QnaController.java
│   ├── QnaService.java
│   ├── ReferenceController.java
│   ├── ReferenceService.java
│   ├── ReplyController.java
│   ├── VideoController.java
│   └── VideoService.java
├── code/
│   ├── BarcodeController.java
│   ├── BarcodeService.java
│   ├── CacheComponent.java
│   ├── CodeController.java
│   ├── CodeService.java
│   ├── ScreentermController.java
│   ├── ScreentermService.java
│   ├── SvcCodeController.java
│   └── SvcCodeService.java
├── code2/
│   ├── CacheComponent2.java
│   ├── Code2Controller.java
│   └── Code2Service.java
├── code3/
│   ├── CacheComponent3.java
│   ├── Code3Controller.java
│   └── Code3Service.java
├── dao/
│   └── CommonDao.java
├── drawing/
│   ├── DrawingInformationController.java
│   ├── DrawingInformationDetailController.java
│   ├── DrawingInformationDetailService.java
│   └── DrawingInformationService.java
├── excel/
│   ├── ExcelDownloadMgtController.java
│   └── ExcelDownloadMgtService.java
├── file/
│   ├── FileController.java
│   ├── FileDirectory.java
│   ├── FileManager.java
│   └── FileService.java
├── ftk/
│   ├── TokenController.java
│   └── TokenService.java
├── loader/
│   ├── LoaderComponent.java
│   ├── LoaderController.java
│   ├── LoaderForm.java
│   ├── LoaderItem.java
│   └── LoaderService.java
├── mail/
│   ├── MailController.java
│   ├── MailService.java
│   └── SMTPAuthenticatior.java
├── model/
│   ├── Code.java
│   ├── Exhbn.java
│   ├── FileInfo.java
│   ├── Group.java
│   ├── Menu.java
│   ├── PhoneBook.java
│   ├── Program.java
│   ├── SerialManagement.java
│   └── User.java
├── report/
│   ├── DataManagementController.java
│   ├── DataManagementService.java
│   ├── DataSearchController.java
│   ├── DataSearchService.java
│   └── ReportController.java
├── sample/
│   ├── AutologintestController.java
│   ├── AutologintestService.java
│   ├── LocManagerController.java
│   ├── LocManagerService.java
│   ├── SampleboardController.java
│   ├── SampleboardService.java
│   ├── WsdlTestController.java
│   └── WsdlTestService.java
├── security/
│   ├── CommonController.java
│   ├── SecurityInterceptor.java
│   └── SessionComponent.java
├── tbd/
│   ├── TbdController.java
│   └── TbdCSController.java
├── test/
│   ├── TestBoardController.java
│   ├── TestBoardService.java
│   ├── TestController.java
│   └── TestService.java
├── user/
│   ├── BatchStatusController.java
│   ├── BatchStatusService.java
│   ├── BatchWorkController.java
│   ├── BatchWorkReviseController.java
│   ├── BatchWorkReviseService.java
│   ├── BatchWorkService.java
│   ├── EmailInsertController.java
│   ├── EmailInsertService.java
│   ├── ExcelInfoController.java
│   ├── ExcelInfoService.java
│   ├── GoPdiController.java
│   ├── GoPdiService.java
│   ├── GroupController.java
│   ├── GroupService.java
│   ├── JobHistController.java
│   ├── JobHistService.java
│   ├── MenuController.java
│   ├── MenuService.java
│   ├── PasswordController.java
│   ├── PasswordService.java
│   ├── PersonalExcelInfoController.java
│   ├── PersonalExcelInfoService.java
│   ├── ProgramController.java
│   ├── ProgramService.java
│   ├── SapInterfaceController.java
│   ├── SapInterfaceService.java
│   ├── UserController.java
│   ├── UserLogController.java
│   ├── UserLogListController.java
│   ├── UserLogListService.java
│   ├── UserLogService.java
│   ├── UserSecureService.java
│   └── UserService.java
├── user2/
│   ├── Group2Controller.java
│   ├── Group2Service.java
│   ├── Program2Controller.java
│   ├── Program2Service.java
│   ├── User2Controller.java
│   ├── User2SecureService.java
│   └── User2Service.java
└── user3/
    ├── Group3Controller.java
    ├── Group3Service.java
    ├── Program3Controller.java
    └── Program3Service.java
```

### com/wsc/framework/ - 프레임워크 기본 클래스

```
com/wsc/framework/
├── base/
│   ├── BaseComponent.java
│   ├── BaseConstants.java
│   ├── BaseController.java
│   ├── BaseDao.java
│   ├── BaseException.java
│   ├── BaseInterceptor.java
│   ├── BaseMap.java
│   ├── BaseModel.java
│   ├── BaseResultHandler.java
│   ├── BaseService.java
│   └── BaseView.java
├── excel/
│   └── ExcelLoader.java
├── exception/
│   ├── AuthorityException.java
│   ├── GlobalExceptionHandler.java
│   ├── ServiceException.java
│   ├── SessionException.java
│   └── SystemException.java
├── model/
│   ├── PagingMap.java
│   ├── ParamsMap.java
│   ├── RecordMap.java
│   └── ResultMap.java
├── utils/
│   ├── BaseUtils.java
│   ├── DateUtils.java
│   ├── EaiUtils.java
│   ├── FileUtils.java
│   ├── LocaleUtil.java
│   ├── MailUtils.java
│   ├── MybatisUtils.java
│   ├── NamedParameterStatement.java
│   ├── RandomUtils.java
│   ├── RefreshableSqlSessionFactoryBean.java
│   └── SoapUtils.java
└── view/
    ├── DownloadView.java
    ├── FileView.java
    └── JxlsView.java
```

### com/wsc/ord/ - 주문 관리 모듈

```
com/wsc/ord/
├── ord03a/
│   ├── Ord03aController.java
│   └── Ord03aService.java
└── ord06a/
    ├── Ord06aController.java
    └── Ord06aService.java
```

### com/wsc/saml/ - SAML 인증

```
com/wsc/saml/
├── KeyLoader.java
├── SamlInitializer.java
├── SamlResponseGenerator.java
├── SamlSsoController.java
└── SamlSsoService.java
```

### kr/co/lscns/SD/ - EAI SOAP 클라이언트

```
kr/co/lscns/SD/
├── WGBC/
│   ├── DT_SD1890_WGBC.java
│   ├── DT_SD1890_WGBC_response.java
│   ├── DT_SD1890_WGBCPDI_MAST.java
│   ├── SD1890_WGBC_SO.java
│   ├── SD1890_WGBC_SOBindingStub.java
│   ├── SD1890_WGBC_SOProxy.java
│   ├── SD1890_WGBC_SOService.java
│   └── SD1890_WGBC_SOServiceLocator.java
└── WPCS/
    ├── DT_SD0980_WPCS.java
    ├── DT_SD0980_WPCS_responseGT_ORDER_INFO.java
    ├── SD0980_WPCS_SO.java
    ├── SD0980_WPCS_SOBindingStub.java
    ├── SD0980_WPCS_SOProxy.java
    ├── SD0980_WPCS_SOService.java
    └── SD0980_WPCS_SOServiceLocator.java
```

---

## src/main/resources/ - 리소스 및 설정

```
src/main/resources/
├── app.properties                    # 응용 설정 (DB, 파일경로, URL)
├── ehcache.xml                       # EHCache 캐시 설정
├── log4j2.xml                        # Log4j2 로깅 설정
├── mybatis.xml                       # MyBatis 글로벌 설정
├── messages/
│   ├── message_en.properties         # 영어
│   ├── message_ko.properties         # 한국어
│   ├── message_pt.properties         # 포르투갈어
│   └── message_zh.properties         # 중국어
└── xlsloaders/
    ├── jxls-code.xml
    ├── jxls-product.xml
    └── jxls-sampleboard.xml
```

### MyBatis Mapper XML

```
mappers/com/wsc/
├── business/
│   ├── community/CommunityManagement.xml
│   ├── company/
│   │   ├── AccountManagement.xml
│   │   ├── CloseManagement.xml
│   │   ├── CompanyRegistration.xml
│   │   └── Saledailyactivityreport.xml
│   ├── employee/
│   │   ├── Employee.xml
│   │   └── tmpemployee.xml
│   └── item/
│       ├── CommodityMaterialCode.xml
│       ├── ModelManagement.xml
│       ├── ProductsUpload.xml
│       ├── ProductsView.xml
│       ├── productsview_new.xml
│       └── ProjectManagement.xml
├── common/
│   ├── app/App.xml
│   ├── board/
│   │   ├── Address.xml
│   │   ├── Alter.xml
│   │   ├── BankSearch.xml
│   │   ├── Board.xml
│   │   ├── BoardManagement.xml
│   │   ├── bulletin.xml
│   │   ├── DealerSearch.xml
│   │   ├── Help.xml
│   │   ├── Image.xml
│   │   ├── LSTASearch.xml
│   │   ├── MyViewSearch.xml
│   │   ├── NavHelp.xml
│   │   ├── Notification.xml
│   │   ├── Qna.xml
│   │   ├── reference.xml
│   │   └── Video.xml
│   ├── code/
│   │   ├── Barcode.xml
│   │   ├── Code.xml
│   │   ├── Screenterm.xml
│   │   └── SvcCode.xml
│   ├── code2/Code2.xml
│   ├── code3/Code3.xml
│   ├── drawing/
│   │   ├── DrawingInformation.xml
│   │   └── DrawingInformationDetail.xml
│   ├── excel/ExcelDownloadMgt.xml
│   ├── file/File.xml
│   ├── ftk/Token.xml
│   ├── loader/Loader.xml
│   ├── mail/Mail.xml
│   ├── report/
│   │   ├── DataManagement.xml
│   │   └── DataSearch.xml
│   ├── rt/Return.xml
│   ├── sample/
│   │   ├── Autologintest.xml
│   │   ├── LocManager.xml
│   │   ├── Sampleboard.xml
│   │   └── Wsdltest.xml
│   ├── test/
│   │   ├── Test.xml
│   │   └── TestBoard.xml
│   ├── user/
│   │   ├── BatchStatus.xml
│   │   ├── BatchWork.xml
│   │   ├── BatchWorkRevise.xml
│   │   ├── EmailInsert.xml
│   │   ├── ExcelInfo.xml
│   │   ├── Group.xml
│   │   ├── JobHist.xml
│   │   ├── Menu.xml
│   │   ├── Password.xml
│   │   ├── PersonalExcelInfo.xml
│   │   ├── Program.xml
│   │   ├── SapInterface.xml
│   │   ├── User.xml
│   │   ├── UserLog.xml
│   │   ├── UserLogList.xml
│   │   └── UserSecure.xml
│   ├── user2/
│   │   ├── Group2.xml
│   │   ├── Program2.xml
│   │   └── User2.xml
│   └── user3/
│       ├── Group3.xml
│       └── Program3.xml
├── framework/base/Base.xml
├── ord/
│   ├── ord03a/Ord03a.xml
│   └── ord06a/Ord06a.xml
└── saml/SamlSso.xml
```

---

## src/main/webapp/ - 웹 애플리케이션

### WEB-INF/spring/ - Spring 설정

```
WEB-INF/spring/
├── cxf-servlet.xml                   # Apache CXF 웹서비스
├── wsc-context.xml                   # Spring MVC 설정
├── wsc-jasper.xml                    # JasperReports 설정
└── wsc-mybatis.xml                   # MyBatis + DataSource + TX
```

### WEB-INF/web.xml - 서블릿 설정

```
WEB-INF/
└── web.xml                           # DispatcherServlet, 필터, 리스너
```

### WEB-INF/reports/ - JasperReports

```
WEB-INF/reports/
├── report5.jasper
├── report5.jrxml
├── reportChart.jasper
├── reportChart.jrxml
├── reportIndex.jasper
├── reportIndex.jrxml
├── reportView.jasper
└── reportView.jrxml
```

### WEB-INF/templates/ - Excel 템플릿

```
WEB-INF/templates/
└── (약 300+ 엑셀 템플릿 파일 - *_Template.xlsx)
```

---

### WEB-INF/views/ - JSP 뷰

#### include/ - 공통 포함 파일

```
views/include/
├── common.jsp                        # CSS/JS 로더, 전역변수 (필수)
├── body.head.jsp                     # 본문 시작 (목록 페이지 필수)
├── body.foot.jsp                     # 본문 종료 (목록 페이지 필수)
├── head.jsp                          # 전체 레이아웃 head
├── foot.jsp                          # 전체 레이아웃 foot
├── north.jsp                         # 상단 네비게이션
├── south.jsp                         # 하단 영역
├── topnav.jsp                        # 상단 탭 네비
├── topnav2.jsp                       # 상단 탭 네비 v2
├── west.jsp                          # 좌측 메뉴
├── west_bk.jsp                       # 좌측 메뉴 백업
└── popup/
    ├── ndm_common.jsp                # NDM 팝업 공통
    ├── pop_foot.jsp                  # 팝업 하단
    ├── pop_head.jsp                  # 팝업 상단
    ├── pop_head2.jsp                 # 팝업 상단 v2
    └── promo_common.jsp              # 프로모션 팝업 공통
```

#### error/ - 에러 페이지

```
views/error/
├── authority.jsp
├── denied.jsp
├── error.jsp
├── service.jsp
├── session.jsp
└── system.jsp
```

#### business/ - 비즈니스 모듈

```
views/business/
├── community/
│   └── communityManagement.jsp
├── company/
│   ├── accountManagement.jsp
│   ├── closemanagement.jsp
│   ├── companyRegistration.jsp
│   └── saledailyactivityreport.jsp
├── employee/
│   ├── employee.jsp
│   └── tmpemployee.jsp
└── item/
    ├── commodityMaterialCode.jsp
    ├── modelmanagement.jsp
    ├── productsupload.jsp
    ├── productsview.jsp
    ├── productsview_new.jsp
    └── projectmanagement.jsp
```

#### common/ - 공통 모듈

```
views/common/
├── board/
│   ├── alter.jsp, alterForm.jsp, alterView.jsp
│   ├── board.jsp, boardForm.jsp, boardView.jsp
│   ├── boardmanagement.jsp
│   ├── email.jsp, emailForm.jsp, emailTarget.jsp, emailView.jsp
│   ├── forms.jsp, formsForm.jsp, formsView.jsp
│   ├── help.jsp, helpForm.jsp, helpCForm.jsp, helpCView.jsp, helpView.jsp
│   ├── image.jsp, imageForm.jsp, imageView.jsp
│   ├── lsqna.jsp, lsqnaForm.jsp, lsqnaView.jsp
│   ├── lstaSelect.jsp
│   ├── myViewSelect.jsp
│   ├── navHelp.jsp, navHelpForm.jsp, navHelpView.jsp
│   ├── notice.jsp, noticeForm.jsp, noticeView.jsp
│   ├── popup.jsp, popupForm.jsp, popupView.jsp
│   ├── qna.jsp, qnaForm.jsp, qnaView.jsp
│   ├── reference.jsp
│   ├── reply.jsp, replyForm.jsp, replyView.jsp
│   ├── video.jsp, videoForm.jsp, videoView.jsp
│   └── views.jsp
├── code/
│   ├── barcode.jsp
│   ├── code.jsp
│   ├── codeLoader.jsp
│   ├── screenterm.jsp
│   └── svccode.jsp
├── code2/
│   ├── code2.jsp
│   └── codeLoader2.jsp
├── code3/
│   ├── code3.jsp
│   └── codeLoader3.jsp
├── drawing/
│   ├── drawinginformation.jsp
│   └── drawinginformationdetail.jsp
├── excel/
│   └── exceldownloadmgt.jsp
├── loader/
│   ├── loaderCode.jsp
│   └── loaderForm.jsp
├── mail/
│   ├── address.jsp
│   ├── internalList.jsp
│   ├── internalMail.jsp
│   ├── mail.jsp, mailForm.jsp, mailView.jsp, mailView2.jsp
│   ├── userList.jsp
│   └── views.jsp
├── report/
│   ├── datamanagement.jsp
│   ├── datasearch.jsp
│   ├── reportChart.jsp
│   └── reportView.jsp
├── sample/
│   ├── autologintest.jsp
│   ├── autologintestresult.jsp
│   ├── locmanager.jsp
│   ├── sampleboard.jsp
│   └── wsdltest.jsp
├── tbd/
│   ├── tbd.jsp
│   └── tbdcs.jsp
├── test/
│   ├── test.jsp
│   ├── testboard.jsp, testboardform.jsp, testboardview.jsp
├── user/
│   ├── batchstatus.jsp
│   ├── batchwork.jsp
│   ├── batchworkrevise.jsp
│   ├── emailinsert.jsp
│   ├── excelinfo.jsp
│   ├── gopdi.jsp
│   ├── group.jsp
│   ├── groupprogram.jsp
│   ├── jobhist.jsp
│   ├── menu.jsp
│   ├── password.jsp
│   ├── personalexcelinfo.jsp
│   ├── program.jsp
│   ├── programlistuser.jsp
│   ├── sapinterface.jsp
│   ├── user.jsp
│   ├── usergroup.jsp
│   ├── userloglist.jsp
│   ├── userPassword.jsp
│   ├── userprogram.jsp
│   └── userprogramlist.jsp
├── user2/
│   ├── groupprogram2.jsp
│   ├── user2.jsp
│   ├── usergroup2.jsp
│   └── userprogram2.jsp
└── user3/
    ├── groupprogram3.jsp
    ├── usergroup3.jsp
    └── userprogram3.jsp
```

#### ord/ - 주문 관리 모듈

```
views/ord/
├── ord03a/
│   ├── ord03a.jsp                    # 월별생산계획 메인
│   ├── ord03a_d6a.jsp                # Excel 임포트 팝업
│   └── ord03a_d8a.jsp                # 생산완료일 편집 팝업
└── ord06a/
    └── ord06a.jsp                    # 일일생산계획
```

#### 루트 레벨 페이지

```
views/
├── index.jsp                         # 메인 대시보드
├── index02.jsp                       # 대시보드 v2
├── login.jsp                         # 로그인
├── login_bk.jsp                      # 로그인 백업
├── loginhelp.jsp                     # 로그인 도움말
├── loginsso.jsp                      # SSO 로그인
├── loginTableau.jsp                  # Tableau 로그인
├── logout.jsp                        # 로그아웃
├── mobileLogin.jsp                   # 모바일 로그인
├── frame.jsp                         # 프레임 레이아웃
├── canvastest.jsp                    # 캔버스 테스트
├── changeoldid.jsp                   # 구ID 변경
├── changePassword.jsp                # 비밀번호 변경
├── ehelp.jsp                         # 전자 도움말
├── ehelpmanu.jsp                     # 도움말 매뉴얼
├── ehelpmemo.jsp                     # 도움말 메모
├── menuOverEvent.jsp                 # 메뉴 이벤트
├── rejectEmail.jsp                   # 이메일 거부
├── ReportView.jsp                    # 리포트 뷰
├── sitemap.jsp                       # 사이트맵
├── smsreturn.jsp                     # SMS 반환
├── unsubscribeMail.jsp               # 메일 수신거부
└── saml/
    ├── samlsso.jsp                   # SAML SSO
    ├── sso.jsp                       # SSO
    └── ssoservice.jsp                # SSO 서비스
```

---

### resources/ - 정적 리소스

#### resources/js/ - JavaScript

```
js/
├── include/                          # 공통 라이브러리 (수정 금지)
│   ├── common.js                     # jcommon, jcombo, jutils
│   ├── business.js                   # jeasygrid 등
│   ├── widget.js                     # UI 위젯 유틸
│   ├── system.js                     # 시스템 유틸
│   ├── extension.js                  # 확장 함수
│   ├── utilities.js                  # 유틸리티 함수
│   ├── Blob.js                       # Blob 처리
│   ├── FileSaver.js                  # 파일 저장
│   ├── jquery.min.js                 # jQuery
│   ├── jquery.number.min.js          # 숫자 포맷
│   ├── jquery-ui.min.js              # jQuery UI
│   ├── tableexport.js                # 테이블 익스포트
│   ├── xlsx.core.js                  # XLSX 처리
│   └── lang/                         # i18n 메시지
│       ├── message_en.js
│       ├── message_ko.js
│       ├── message_pt.js
│       ├── message_vi.js
│       └── message_zh.js
├── module/                           # 재사용 컴포넌트
│   ├── jboard.js                     # 게시판 공통
│   ├── jeditor.js                    # 에디터
│   ├── jsort.js                      # 정렬
│   ├── jupload.js                    # 파일 업로드
│   ├── jupload2.js                   # 파일 업로드 v2
│   ├── jupload3.js                   # 파일 업로드 v3
│   └── jupload4.js                   # 파일 업로드 v4
├── chartjs/                          # Chart.js 라이브러리
│   ├── Chart.bundle.js
│   ├── Chart.bundle.min.js
│   ├── Chart.js
│   ├── Chart.min.js
│   ├── Chart.css
│   └── utils.js
├── echart/                           # ECharts 라이브러리
│   ├── ctprvn.json
│   └── echarts.min.js
├── business/
│   ├── community/communitymanagement.js
│   ├── company/
│   │   ├── accountmanagement.js
│   │   ├── closemanagement.js
│   │   ├── companyregistration.js
│   │   ├── phonebook.js
│   │   └── saledailyactivityreport.js
│   ├── employee/
│   │   ├── employee.js
│   │   └── tmpemployee.js
│   └── item/
│       ├── commoditymaterialcode.js
│       ├── modelmanagement.js
│       ├── productsupload.js
│       ├── productsview.js
│       ├── productsview_new.js
│       └── projectmanagement.js
├── common/
│   ├── board/
│   │   ├── alter.js
│   │   ├── board.js
│   │   ├── boardmanagement.js
│   │   ├── bulletin.js
│   │   ├── dealerSelect.js
│   │   ├── email.js
│   │   ├── forms.js, formsForm.js, formsView.js
│   │   ├── help.js
│   │   ├── image.js
│   │   ├── lsqna.js, lsqnaForm.js, lsqnaView.js
│   │   ├── lstaSelect.js
│   │   ├── myViewSelect.js
│   │   ├── navHelp.js, navHelpForm.js, navHelpView.js
│   │   ├── notice.js, noticeForm.js, noticeView.js
│   │   ├── popup.js, popupForm.js, popupView.js
│   │   ├── qna.js
│   │   ├── reference.js
│   │   ├── reply.js
│   │   ├── video.js
│   │   └── views.js
│   ├── code/
│   │   ├── barcode.js, barcodeReader.js
│   │   ├── code.js, codeLoader.js
│   │   ├── screenterm.js
│   │   └── svccode.js
│   ├── code2/
│   │   ├── code2.js
│   │   └── codeLoader2.js
│   ├── code3/
│   │   ├── code3.js
│   │   └── codeLoader3.js
│   ├── coop/
│   │   ├── coopUpload.js
│   │   └── coopUploadfile.js
│   ├── drawing/
│   │   ├── drawinginformation.js
│   │   └── drawinginformationdetail.js
│   ├── excel/
│   │   └── exceldownloadmgt.js
│   ├── loader/
│   │   ├── loaderCode.js
│   │   └── loaderForm.js
│   ├── mail/
│   │   ├── address.js
│   │   ├── internallist.js
│   │   ├── internalmail.js
│   │   ├── mail.js
│   │   ├── userlist.js
│   │   └── views.js
│   ├── report/
│   │   ├── datamanagement.js
│   │   ├── datasearch.js
│   │   ├── reportchart.js
│   │   └── reportview.js
│   ├── sample/
│   │   ├── autologintest.js
│   │   ├── locmanager.js
│   │   ├── sample.js
│   │   ├── sampleboard.js
│   │   └── wsdltest.js
│   ├── tbd/
│   │   ├── tbd.js
│   │   └── tbdcs.js
│   ├── test/
│   │   ├── test.js
│   │   └── testboard.js
│   ├── user/
│   │   ├── batchstatus.js
│   │   ├── batchwork.js
│   │   ├── batchworkrevise.js
│   │   ├── emailinsert.js
│   │   ├── excelinfo.js
│   │   ├── gopdi.js
│   │   ├── group.js
│   │   ├── groupprogram.js
│   │   ├── jobhist.js
│   │   ├── menu.js
│   │   ├── password.js
│   │   ├── pdiupdate.js
│   │   ├── personalexcelinfo.js
│   │   ├── program.js
│   │   ├── programlistuser.js
│   │   ├── sapinterface.js
│   │   ├── user.js
│   │   ├── usergroup.js
│   │   ├── userloglist.js
│   │   ├── userpassword.js
│   │   ├── userprogram.js
│   │   └── userprogramlist.js
│   ├── user2/
│   │   ├── groupprogram2.js
│   │   ├── user2.js
│   │   ├── usergroup2.js
│   │   └── userprogram2.js
│   └── user3/
│       ├── groupprogram3.js
│       ├── usergroup3.js
│       └── userprogram3.js
├── ord/
│   ├── ord03a/
│   │   ├── ord03a.js
│   │   ├── ord03a_d6a.js
│   │   └── ord03a_d8a.js
│   └── ord06a/
│       └── ord06a.js
├── saml/
│   └── ssoservice.js
├── Chart.js
├── changeoldid.js
├── changePassword.js
├── ehelp.js
├── ehelpmanu.js
├── ehelpmemo.js
├── frame.js
├── index.js
├── index02.js
├── index_dash1.js
├── login.js
├── loginsso.js
├── lsCommon.js
├── rejectEmail.js
└── smsreturn.js
```

#### resources/css/ - 스타일시트

```
css/
├── anke-calligraphic-fg/             # 폰트
├── Nanum_Myeongjo/                   # 폰트
└── Nimbus-Roman/                     # 폰트
```

#### resources/images/ - 이미지

```
images/
├── icon_new/                         # 새 아이콘
├── login/                            # 로그인 이미지
├── login_new/                        # 새 로그인 이미지
├── main/                             # 메인 이미지
├── nav_icons/                        # 네비게이션 아이콘
├── report/                           # 리포트 이미지
├── tit_icons/                        # 타이틀 아이콘
├── tree/                             # 트리 아이콘
├── mes_logo.png                      # MES 로고
├── mes_logo_S.png                    # MES 로고 (소)
└── logo_img.png                      # 로고 이미지
```

#### resources/jquery/ - jQuery 플러그인

```
jquery/
├── ckeditor-4.4.7/                   # 리치 텍스트 에디터
├── daumeditor-7.5.9/                 # 다음 에디터
├── easyui-1.4/                       # EasyUI 프레임워크
├── font-awesome-4.7.0/               # 아이콘 폰트
├── fullcalendar-2.1.1/               # 달력
├── jquery-ui-1.11.4/                 # jQuery UI
├── lightslider/                      # 이미지 슬라이더
├── summernote-master/                # 리치 텍스트 에디터
└── uploader-3.1/                     # 파일 업로드
```

---

## 모듈 요약

| 모듈                        | 용도                     | Java 클래스 | Mapper | JSP  | JS   |
|-----------------------------|--------------------------|-------------|--------|------|------|
| `com.wsc.framework`         | 프레임워크 기본 클래스   | 22          | 1      | -    | -    |
| `com.wsc.common.user`       | 사용자/권한 관리         | 30+         | 16     | 20+  | 20+  |
| `com.wsc.common.board`      | 게시판                   | 28          | 16     | 30+  | 30+  |
| `com.wsc.common.code`       | 코드 관리/캐싱           | 9           | 4      | 5    | 6    |
| `com.wsc.common.file`       | 파일 관리                | 4           | 1      | -    | -    |
| `com.wsc.common.mail`       | 이메일                   | 3           | 1      | 6    | 6    |
| `com.wsc.common.report`     | 리포트/데이터 검색       | 5           | 2      | 4    | 4    |
| `com.wsc.common.loader`     | 엑셀 로더                | 5           | 1      | 2    | 2    |
| `com.wsc.business.company`  | 회사/딜러 관리           | 8           | 4      | 4    | 5    |
| `com.wsc.business.item`     | 아이템 관리              | 12          | 6      | 6    | 6    |
| `com.wsc.business.employee` | 직원 관리                | 4           | 2      | 2    | 2    |
| `com.wsc.ord`               | 주문 관리 (신규)         | 4           | 2      | 4    | 4    |
| `com.wsc.saml`              | SAML SSO 인증            | 5           | 1      | 3    | 1    |
| `com.lsbas.service`         | CXF 웹서비스             | 22          | -      | -    | -    |
| `com.baroservice.ws`        | 외부 SOAP (FAX/SMS)      | 36          | -      | -    | -    |
| `kr.co.lscns.SD`            | EAI SOAP 클라이언트      | 15          | -      | -    | -    |

---

## 아키텍처 흐름

```
클라이언트 요청
      ↓
DispatcherServlet (wscServlet, URL: /)
      ↓
SecurityInterceptor → BaseInterceptor
      ↓
Controller (extends BaseController)
      ↓
Service (extends BaseService)
      ↓
DAO (extends BaseDao) → CommonDao
      ↓
MyBatis Mapper XML
      ↓
MySQL Database
```

---

## 핵심 설정 파일

| 파일                            | 용도                            |
|---------------------------------|---------------------------------|
| `WEB-INF/web.xml`              | 서블릿, 필터, 리스너 설정       |
| `WEB-INF/spring/wsc-context.xml`| Spring MVC, 컴포넌트 스캔      |
| `WEB-INF/spring/wsc-mybatis.xml`| DataSource, SqlSession, TX     |
| `WEB-INF/spring/wsc-jasper.xml` | JasperReports 설정             |
| `WEB-INF/spring/cxf-servlet.xml`| Apache CXF 웹서비스            |
| `resources/app.properties`      | DB 연결, 파일 경로, URL        |
| `resources/mybatis.xml`         | MyBatis 타입 별칭, 설정        |
| `resources/log4j2.xml`          | 로그 레벨, 파일 출력           |
| `resources/ehcache.xml`         | 캐시 설정                      |
