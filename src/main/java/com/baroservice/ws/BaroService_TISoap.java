/**
 * BaroService_TISoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public interface BaroService_TISoap extends java.rmi.Remote {

    /**
     * 발행자관리번호로 세금계산서 유무 확인
     */
    public int checkMgtNumIsExists(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 등록전 유효성체크
     */
    public int checkIsValidTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException;

    /**
     * 일반세금계산서 등록
     */
    public int registTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException;

    /**
     * 일반세금계산서 등록EX (승인 시 자동발행 옵션 추가)
     */
    public int registTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException;

    /**
     * 수정세금계산서 등록
     */
    public int registModifyTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey) throws java.rmi.RemoteException;

    /**
     * 수정세금계산서 등록EX (승인 시 자동발행 옵션 추가)
     */
    public int registModifyTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey, int issueTiming) throws java.rmi.RemoteException;

    /**
     * 일반세금계산서 역발행 등록 (공급받는자 과금)
     */
    public int registTaxInvoiceReverse(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException;

    /**
     * 일반세금계산서 역발행 등록 (과금 주체 선택옵션 추가)
     */
    public int registTaxInvoiceReverseEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int chargeDirection) throws java.rmi.RemoteException;

    /**
     * 위수탁세금계산서 등록
     */
    public int registBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException;

    /**
     * 위수탁세금계산서 등록EX (승인 시 자동발행 옵션 추가
     */
    public int registBrokerTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException;

    /**
     * 수정 위수탁세금계산서 등록
     */
    public int registModifyBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey) throws java.rmi.RemoteException;

    /**
     * 수정 위수탁세금계산서 등록EX (승인 시 자동발행 옵션 추가)
     */
    public int registModifyBrokerTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey, int issueTiming) throws java.rmi.RemoteException;

    /**
     * 세금계산서 하단문자열 등록/수정
     */
    public int updateTaxInvoiceFooterString(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String footerString) throws java.rmi.RemoteException;

    /**
     * 일반세금계산서 수정 [임시저장상태만 가능]
     */
    public int updateTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException;

    /**
     * 일반세금계산서 수정EX (승인 시 자동발행 옵션 추가) [임시저장상태만 가능]
     */
    public int updateTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException;

    /**
     * 위수탁세금계산서 수정 [임시저장상태만 가능]
     */
    public int updateBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException;

    /**
     * 위수탁세금계산서 수정EX (승인 시 자동발행 옵션 추가) [임시저장상태만 가능]
     */
    public int updateBrokerTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException;

    /**
     * 세금계산서 삭제 [자체관리번호][임시저장상태와, 승인/발행 거부, 취소완료상태에서만 가능]
     */
    public int deleteTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 삭제 [바로빌관리번호][임시저장상태와, 승인/발행 거부, 취소완료상태에서만 가능]
     */
    public int deleteTaxInvoiceIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 발행
     */
    public int issueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, int NTSSendOption, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 세금계산서 발행 (문자메세지 내용, 사업자등록증사본, 통장사본 첨부 기능 추가)
     */
    public int issueTaxInvoiceEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String SMSMessage, boolean forceIssue, java.lang.String mailTitle, boolean businessLicenseYN, boolean bankBookYN) throws java.rmi.RemoteException;

    /**
     * 세금계산서 역발행요청
     */
    public int reverseIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 세금계산서 역발행요청 (문자메세지 내용 설정 기능 추가)
     */
    public int reverseIssueTaxInvoiceEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String SMSMessage, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 세금계산서 발행예정_승인요청
     */
    public int preIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 세금계산서 발행예정_승인요청 (문자메세지 내용, 사업자등록증사본, 통장사본 첨부 기능 추가)
     */
    public int preIssueTaxInvoiceEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String SMSMessage, java.lang.String mailTitle, boolean businessLicenseYN, boolean bankBookYN) throws java.rmi.RemoteException;

    /**
     * 세금계산서 프로세스 처리
     */
    public int procTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String procType, java.lang.String memo) throws java.rmi.RemoteException;

    /**
     * 일반(수정)세금계산서 '등록' 과 '발행' 을 한번에 처리
     */
    public int registAndIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 일반(수정)세금계산서 '등록' 과 '발행예정' 을 한번에 처리
     */
    public int registAndPreIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, int issueTiming, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 위수탁 일반(수정)세금계산서 '등록' 과 '발행' 을 한번에 처리
     */
    public int registAndIssueBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 위수탁 일반(수정)세금계산서 '등록' 과 '발행예정' 을 한번에 처리
     */
    public int registAndPreIssueBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, int issueTiming, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 역발행 세금계산서 '등록' 과 '역발행' 을 한번에 처리
     */
    public int registAndReverseIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException;

    /**
     * 세금계산서 내용 확인 [자체관리번호]
     */
    public com.baroservice.ws.TaxInvoice getTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 내용 확인 [바로빌관리번호]
     */
    public com.baroservice.ws.TaxInvoice getTaxInvoiceIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 내용 확인 [국세청승인번호]
     */
    public com.baroservice.ws.TaxInvoice getTaxInvoiceNK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String NTSConfirmNum) throws java.rmi.RemoteException;

    /**
     * 세금계산서 상태 확인 [자체관리번호]
     */
    public com.baroservice.ws.TaxInvoiceState getTaxInvoiceState(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 상태 확인 [자체관리번호][대량, 최대100건까지만 처리]
     */
    public com.baroservice.ws.TaxInvoiceState[] getTaxInvoiceStates(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] mgtKeyList) throws java.rmi.RemoteException;

    /**
     * 세금계산서 상태 확인EX (반환값 확장) [자체관리번호]
     */
    public com.baroservice.ws.TaxInvoiceStateEX getTaxInvoiceStateEX(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 상태 확인EX (반환값 확장) [자체관리번호][대량, 최대100건까지만 처리]
     */
    public com.baroservice.ws.TaxInvoiceStateEX[] getTaxInvoiceStatesEX(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] mgtKeyList) throws java.rmi.RemoteException;

    /**
     * 세금계산서 상태 확인 [바로빌관리번호][대량, 최대100건까지만 처리]
     */
    public com.baroservice.ws.TaxInvoiceState[] getTaxInvoiceStatesIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] invoiceKeyList) throws java.rmi.RemoteException;

    /**
     * 세금계산서에 대한 문서이력을 조회.
     */
    public com.baroservice.ws.InvoiceLog[] getTaxInvoiceLog(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서에 대한 문서이력을 조회.
     */
    public com.baroservice.ws.InvoiceLog[] getTaxInvoiceLogIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey) throws java.rmi.RemoteException;

    /**
     * FTP를 사용하여 계산서에 파일첨부,표시명추가[FTP 전송된 화일을 첨부합니다]
     */
    public int attachFileByFTP(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String fileName, java.lang.String displayFileName) throws java.rmi.RemoteException;

    /**
     * 첨부된 파일 모두삭제[첨부된 모든파일을 삭제합니다.]
     */
    public int deleteAttachFile(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 첨부된 파일 한개삭제[GetAttachedFileList로 확인된 FileIndex로 특정화일만 삭제합니다.]
     */
    public int deleteAttachFileWithFileIndex(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, int fileIndex) throws java.rmi.RemoteException;

    /**
     * 첨부된 파일리스트를 확인합니다.
     */
    public com.baroservice.ws.AttachedFile[] getAttachedFileList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 첨부된 파일리스트를 확인합니다. (파일 다운로드 URL 추가)
     */
    public com.baroservice.ws.AttachedFileEx[] getAttachedFileListEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 세금계산서 상태에 따른 관련 Email 재전송[취소,거부는 전송불가능]
     */
    public int reSendEmail(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String toEmailAddress) throws java.rmi.RemoteException;

    /**
     * SMS문자를 발송합니다. [충전잔액에서 차감]
     */
    public int reSendSMS(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fromNumber, java.lang.String toCorpNum, java.lang.String toName, java.lang.String toNumber, java.lang.String contents) throws java.rmi.RemoteException;

    /**
     * 세금계산서 문자전송 [충전금액에서 차감]
     */
    public int sendInvoiceSMS(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String mgtKey, java.lang.String fromNumber, java.lang.String toNumber, java.lang.String contents) throws java.rmi.RemoteException;

    /**
     * 세금계산서 팩스전송 [충전금액에서 차감]
     */
    public int sendInvoiceFax(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String senderID, java.lang.String fromFaxNumber, java.lang.String toFaxNumber) throws java.rmi.RemoteException;

    /**
     * 바로빌 링크 연결 URL확인
     */
    public java.lang.String getBaroBillURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD, java.lang.String TOGO) throws java.rmi.RemoteException;

    /**
     * 세금계산서 팝업으로 보기위한 URL제공 [자체관리번호]
     */
    public java.lang.String getTaxInvoicePopUpURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 세금계산서 팝업으로 보기위한 URL제공 [바로빌관리번호]
     */
    public java.lang.String getTaxInvoicePopUpURLIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 세금계산서 팝업으로 보기위한 URL제공 [국세청승인번호]
     */
    public java.lang.String getTaxInvoicePopUpURLNK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String NTSConfirmNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 인쇄용 팝업 URL 확인
     */
    public java.lang.String getTaxInvoicePrintURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 인쇄용 팝업 URL 확인
     */
    public java.lang.String getTaxInvoicePrintURLIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 다중인쇄용 팝업 URL 확인
     */
    public java.lang.String getTaxInvoicesPrintURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] mgtKeyList, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 메일 팝업 URL제공
     */
    public java.lang.String getTaxinvoiceMailURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 국세청 세금계산서 조회서비스 신청 URL
     */
    public java.lang.String getTaxInvoiceScrapRequestURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 월간 세금계산서 발행량 확인
     */
    public int getMonthlyCountTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, int year, int month, int periodSearchType, boolean hasCanceled) throws java.rmi.RemoteException;

    /**
     * 설정된 기간 내 취소된 건의 MgtKey 를 반환
     */
    public java.lang.String[] getCanceledTaxInvoiceMgtKey(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String startDate, java.lang.String endDate) throws java.rmi.RemoteException;

    /**
     * 일별 매출 세금계산서 조회(발행일자 기준) [국세청 전송완료 건만]
     */
    public com.baroservice.ws.PagedTaxInvoice getTaxInvoiceSalesList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매입 세금계산서 조회(발행일자 기준) [국세청 전송완료 건만]
     */
    public com.baroservice.ws.PagedTaxInvoice getTaxInvoicePurchaseList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매출 세금계산서 조회(발행일자 기준) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoiceSalesListEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매입 세금계산서 조회(발행일자 기준) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoicePurchaseListEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매출 세금계산서 조회(발행일자 기준, 아이디에 해당하는 건만) [국세청 전송완료 건만]
     */
    public com.baroservice.ws.PagedTaxInvoice getTaxInvoiceSalesListByID(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매입 세금계산서 조회(발행일자 기준, 아이디에 해당하는 건만) [국세청 전송완료 건만]
     */
    public com.baroservice.ws.PagedTaxInvoice getTaxInvoicePurchaseListByID(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매출 세금계산서 조회(발행일자 기준, 아이디에 해당하는 건만) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoiceSalesListByIDEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매입 세금계산서 조회(발행일자 기준, 아이디에 해당하는 건만) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoicePurchaseListByIDEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매출 세금계산서 조회(작성일자/발행일자 선택) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getDailyTaxInvoiceSalesList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 일별 매입 세금계산서 조회(작성일자/발행일자 선택) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getDailyTaxInvoicePurchaseList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * 월별 매출 세금계산서 조회(작성일자/발행일자 선택, 정렬순서 선택) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getMonthlyTaxInvoiceSalesList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseMonth, int countPerPage, int currentPage, int orderDirection) throws java.rmi.RemoteException;

    /**
     * 월별 매입 세금계산서 조회(작성일자/발행일자 선택, 정렬순서 선택) [국세청 전송완료 건만] (대표품목 포함)
     */
    public com.baroservice.ws.PagedTaxInvoiceEx getMonthlyTaxInvoicePurchaseList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseMonth, int countPerPage, int currentPage, int orderDirection) throws java.rmi.RemoteException;

    /**
     * 즉시전송하지 않은 세금계산서 수동전송
     */
    public int sendToNTS(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 국세청 대량전송설정 확인
     */
    public com.baroservice.ws.NTSSendOption getNTSSendOption(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException;

    /**
     * 국세청 대량전송설정 변경
     */
    public int changeNTSSendOption(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, com.baroservice.ws.NTSSendOption NTSSendOption) throws java.rmi.RemoteException;

    /**
     * ASP업체 Email 목록확인
     */
    public com.baroservice.ws.EMAILPUBLICKEY[] getEmailPublicKeys(java.lang.String CERTKEY) throws java.rmi.RemoteException;

    /**
     * 문서간 연결 설정
     */
    public int makeDocLinkage(java.lang.String CERTKEY, java.lang.String corpNum, int fromDocType, java.lang.String fromMgtKey, int toDocType, java.lang.String toMgtKey) throws java.rmi.RemoteException;

    /**
     * 문서간 연결 해제
     */
    public int removeDocLinkage(java.lang.String CERTKEY, java.lang.String corpNum, int fromDocType, java.lang.String fromMgtKey, int toDocType, java.lang.String toMgtKey) throws java.rmi.RemoteException;

    /**
     * 연결된 문서 목록 반환
     */
    public com.baroservice.ws.LinkedDoc[] getLinkedDocs(java.lang.String CERTKEY, java.lang.String corpNum, int docType, java.lang.String mgtKey) throws java.rmi.RemoteException;

    /**
     * 직인 등록 URL 반환
     */
    public java.lang.String getJicInRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 사업자등록증 사본 등록 URL 반환
     */
    public java.lang.String getBusinessLicenseRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 통장 사본 등록 URL 반환
     */
    public java.lang.String getBankBookRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 회원사 가입여부 확인
     */
    public int checkCorpIsMember(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException;

    /**
     * 회원사 가입
     */
    public int registCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException;

    /**
     * 회원사 사용자 추가
     */
    public int addUserToCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException;

    /**
     * 회원사 수정
     */
    public int updateCorpInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2) throws java.rmi.RemoteException;

    /**
     * 회원사 사용자 수정
     */
    public int updateUserInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String memberName, java.lang.String juminNum, java.lang.String TEL, java.lang.String HP, java.lang.String email, java.lang.String grade) throws java.rmi.RemoteException;

    /**
     * 회원사 사용자 비밀번호 변경
     */
    public int updateUserPWD(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String newPWD) throws java.rmi.RemoteException;

    /**
     * 회원사 관리자 변경
     */
    public int changeCorpManager(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String newManagerID) throws java.rmi.RemoteException;

    /**
     * 회원사 담당자 목록확인
     */
    public com.baroservice.ws.Contact[] getCorpMemberContacts(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException;

    /**
     * 회원사 충전잔액 확인
     */
    public long getBalanceCostAmount(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException;

    /**
     * 연동사 충전잔액 확인
     */
    public long getBalanceCostAmountOfInterOP(java.lang.String CERTKEY) throws java.rmi.RemoteException;

    /**
     * 과금가능 여부 확인
     */
    public int checkChargeable(java.lang.String CERTKEY, java.lang.String corpNum, int CType, int docType) throws java.rmi.RemoteException;

    /**
     * 단가 확인
     */
    public int getChargeUnitCost(java.lang.String CERTKEY, java.lang.String corpNum, int chargeCode) throws java.rmi.RemoteException;

    /**
     * 등록한 공인인증서 등록일시 확인
     */
    public java.lang.String getCertificateRegistDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException;

    /**
     * 등록한 공인인증서 만료일 확인
     */
    public java.lang.String getCertificateExpireDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException;

    /**
     * 등록한 공인인증서 상태 확인
     */
    public int checkCERTIsValid(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException;

    /**
     * 공인인증서 등록 URL 확인
     */
    public java.lang.String getCertificateRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 바로빌 메인화면 URL 반환
     */
    public java.lang.String getLoginURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 포인트 충전 URL 반환
     */
    public java.lang.String getCashChargeURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 문자 발신번호 관리 URL 반환
     */
    public java.lang.String getSMSFromNumberURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * 문자 발신번호 추가
     */
    public int registSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException;

    /**
     * 문자 발신번호 등록여부 확인
     */
    public int checkSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException;

    /**
     * 오류코드의 상세내용 반환
     */
    public java.lang.String getErrString(java.lang.String CERTKEY, int errCode) throws java.rmi.RemoteException;

    /**
     * Ping
     */
    public void ping() throws java.rmi.RemoteException;
}
