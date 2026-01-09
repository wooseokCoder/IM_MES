/**
 * BaroService_FAXSoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public interface BaroService_FAXSoap extends java.rmi.Remote {

    /**
     * FAX 전송 (단일파일) [FTP 업로드가 선행되어야 합니다.]
     */
    public java.lang.String sendFaxFromFTP(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fileName, java.lang.String fromNumber, java.lang.String toNumber, java.lang.String receiveCorp, java.lang.String receiveName, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException;

    /**
     * FAX 대량전송 (단일파일) [FTP 업로드가 선행되어야 합니다.]
     */
    public java.lang.String[] sendFaxesFromFTP(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fileName, int sendCount, com.baroservice.ws.FaxMessage[] messages, java.lang.String sendDT) throws java.rmi.RemoteException;

    /**
     * FAX 전송 (다량파일) [FTP 업로드가 선행되어야 합니다.]
     */
    public java.lang.String sendFaxFromFTPEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, int fileCount, java.lang.String[] fileNames, java.lang.String fromNumber, java.lang.String toNumber, java.lang.String receiveCorp, java.lang.String receiveName, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException;

    /**
     * FAX 대량전송 (다량파일) [FTP 업로드가 선행되어야 합니다.]
     */
    public java.lang.String[] sendFaxesFromFTPEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, int fileCount, java.lang.String[] fileNames, int sendCount, com.baroservice.ws.FaxMessage[] messages, java.lang.String sendDT) throws java.rmi.RemoteException;

    /**
     * FAX 재전송
     */
    public java.lang.String reSendFax(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String sendKey, java.lang.String refKey) throws java.rmi.RemoteException;

    /**
     * FAX 재전송
     */
    public java.lang.String reSendFaxEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String sendKey, java.lang.String refKey, java.lang.String toNumber) throws java.rmi.RemoteException;

    /**
     * 예약 전송 팩스 취소
     */
    public int cancelReservedFaxMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException;

    /**
     * FAX 전송 상태 확인
     */
    public int getFaxSendState(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException;

    /**
     * FAX 전송 메시지 확인
     */
    public com.baroservice.ws.FaxMessage getFaxMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException;

    /**
     * FAX 전송 메시지 확인 (팩스파일 다운로드 URL 추가)
     */
    public com.baroservice.ws.FaxMessageEx getFaxMessageEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException;

    /**
     * FAX 전송 메시지 대량 확인[100건]
     */
    public com.baroservice.ws.FaxMessage[] getFaxSendMessages(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] sendKeyList) throws java.rmi.RemoteException;

    /**
     * FAX 전송 메시지 대량 확인[100건] (팩스파일 다운로드 URL 추가)
     */
    public com.baroservice.ws.FaxMessageEx[] getFaxSendMessagesEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] sendKeyList) throws java.rmi.RemoteException;

    /**
     * 연동참조번호 관련 FAX 메시지 확인
     */
    public com.baroservice.ws.FaxMessage[] getFaxSendMessagesByRefKey(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String refKey) throws java.rmi.RemoteException;

    /**
     * 연동참조번호 관련 FAX 메시지 확인 (팩스파일 다운로드 URL 추가)
     */
    public com.baroservice.ws.FaxMessageEx[] getFaxSendMessagesByRefKeyEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String refKey) throws java.rmi.RemoteException;

    /**
     * 페이징에 의한 관련 메시지 확인
     */
    public com.baroservice.ws.PagedFaxMessages getFaxSendMessagesByPaging(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromDate, java.lang.String toDate, int countPerPage, int currentPage) throws java.rmi.RemoteException;

    /**
     * FAX 전송 내역 조회 팝업
     */
    public java.lang.String getFaxHistoryURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException;

    /**
     * FAX 파일 다운로드 URL
     */
    public java.lang.String[] getFaxFileURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey, int fileType) throws java.rmi.RemoteException;

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
     * 바로빌 링크 연결 URL확인
     */
    public java.lang.String getBaroBillURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD, java.lang.String TOGO) throws java.rmi.RemoteException;

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
