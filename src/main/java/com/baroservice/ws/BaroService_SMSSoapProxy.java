package com.baroservice.ws;

public class BaroService_SMSSoapProxy implements com.baroservice.ws.BaroService_SMSSoap {
  private String _endpoint = null;
  private com.baroservice.ws.BaroService_SMSSoap baroService_SMSSoap = null;
  
  public BaroService_SMSSoapProxy() {
    _initBaroService_SMSSoapProxy();
  }
  
  public BaroService_SMSSoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initBaroService_SMSSoapProxy();
  }
  
  private void _initBaroService_SMSSoapProxy() {
    try {
      baroService_SMSSoap = (new com.baroservice.ws.BaroService_SMSLocator()).getBaroService_SMSSoap();
      if (baroService_SMSSoap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)baroService_SMSSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)baroService_SMSSoap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (baroService_SMSSoap != null)
      ((javax.xml.rpc.Stub)baroService_SMSSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.baroservice.ws.BaroService_SMSSoap getBaroService_SMSSoap() {
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap;
  }
  
  public java.lang.String sendSMSMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fromNumber, java.lang.String toName, java.lang.String toNumber, java.lang.String contents, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.sendSMSMessage(CERTKEY, corpNum, senderID, fromNumber, toName, toNumber, contents, sendDT, refKey);
  }
  
  public java.lang.String sendMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fromNumber, java.lang.String toName, java.lang.String toNumber, java.lang.String contents, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.sendMessage(CERTKEY, corpNum, senderID, fromNumber, toName, toNumber, contents, sendDT, refKey);
  }
  
  public java.lang.String sendMessages(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, int sendCount, boolean cutToSMS, com.baroservice.ws.XMSMessage[] messages, java.lang.String sendDT) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.sendMessages(CERTKEY, corpNum, senderID, sendCount, cutToSMS, messages, sendDT);
  }
  
  public java.lang.String sendLMSMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fromNumber, java.lang.String toName, java.lang.String toNumber, java.lang.String subject, java.lang.String contents, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.sendLMSMessage(CERTKEY, corpNum, senderID, fromNumber, toName, toNumber, subject, contents, sendDT, refKey);
  }
  
  public java.lang.String sendMMSMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fromNumber, java.lang.String toName, java.lang.String toNumber, java.lang.String TXTSubject, java.lang.String TXTMESSAGE, byte[] imageFile, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.sendMMSMessage(CERTKEY, corpNum, senderID, fromNumber, toName, toNumber, TXTSubject, TXTMESSAGE, imageFile, sendDT, refKey);
  }
  
  public java.lang.String sendMMSMessageFromFTP(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fromNumber, java.lang.String toName, java.lang.String toNumber, java.lang.String TXTSubject, java.lang.String TXTMESSAGE, java.lang.String imageFileName, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.sendMMSMessageFromFTP(CERTKEY, corpNum, senderID, fromNumber, toName, toNumber, TXTSubject, TXTMESSAGE, imageFileName, sendDT, refKey);
  }
  
  public int cancelReservedSMSMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.cancelReservedSMSMessage(CERTKEY, corpNum, sendKey);
  }
  
  public int cancelReservedSMSMessageByReceiptNum(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String receiptNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.cancelReservedSMSMessageByReceiptNum(CERTKEY, corpNum, receiptNum);
  }
  
  public int getSMSSendState(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getSMSSendState(CERTKEY, corpNum, sendKey);
  }
  
  public com.baroservice.ws.SMSMessage getSMSSendMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getSMSSendMessage(CERTKEY, corpNum, sendKey);
  }
  
  public com.baroservice.ws.SMSMessage[] getSMSSendMessages(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] sendKeyList) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getSMSSendMessages(CERTKEY, corpNum, sendKeyList);
  }
  
  public com.baroservice.ws.SMSMessage[] getMessagesByReceiptNum(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String receiptNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getMessagesByReceiptNum(CERTKEY, corpNum, receiptNum);
  }
  
  public com.baroservice.ws.SMSMessage[] getSMSSendMessagesByRefKey(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getSMSSendMessagesByRefKey(CERTKEY, corpNum, refKey);
  }
  
  public com.baroservice.ws.PagedSMSMessages getSMSSendMessagesByPaging(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromDate, java.lang.String toDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getSMSSendMessagesByPaging(CERTKEY, corpNum, fromDate, toDate, countPerPage, currentPage);
  }
  
  public java.lang.String getSMSHistoryURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getSMSHistoryURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public int checkCorpIsMember(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.checkCorpIsMember(CERTKEY, corpNum, checkCorpNum);
  }
  
  public int registCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.registCorp(CERTKEY, corpNum, corpName, CEOName, bizType, bizClass, postNum, addr1, addr2, memberName, juminNum, ID, PWD, grade, TEL, HP, email);
  }
  
  public int addUserToCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.addUserToCorp(CERTKEY, corpNum, memberName, juminNum, ID, PWD, grade, TEL, HP, email);
  }
  
  public int updateCorpInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.updateCorpInfo(CERTKEY, corpNum, corpName, CEOName, bizType, bizClass, postNum, addr1, addr2);
  }
  
  public int updateUserInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String memberName, java.lang.String juminNum, java.lang.String TEL, java.lang.String HP, java.lang.String email, java.lang.String grade) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.updateUserInfo(CERTKEY, corpNum, ID, memberName, juminNum, TEL, HP, email, grade);
  }
  
  public int updateUserPWD(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String newPWD) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.updateUserPWD(CERTKEY, corpNum, ID, newPWD);
  }
  
  public int changeCorpManager(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String newManagerID) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.changeCorpManager(CERTKEY, corpNum, newManagerID);
  }
  
  public com.baroservice.ws.Contact[] getCorpMemberContacts(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getCorpMemberContacts(CERTKEY, corpNum, checkCorpNum);
  }
  
  public long getBalanceCostAmount(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getBalanceCostAmount(CERTKEY, corpNum);
  }
  
  public long getBalanceCostAmountOfInterOP(java.lang.String CERTKEY) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getBalanceCostAmountOfInterOP(CERTKEY);
  }
  
  public int checkChargeable(java.lang.String CERTKEY, java.lang.String corpNum, int CType, int docType) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.checkChargeable(CERTKEY, corpNum, CType, docType);
  }
  
  public int getChargeUnitCost(java.lang.String CERTKEY, java.lang.String corpNum, int chargeCode) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getChargeUnitCost(CERTKEY, corpNum, chargeCode);
  }
  
  public java.lang.String getCertificateRegistDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getCertificateRegistDate(CERTKEY, corpNum);
  }
  
  public java.lang.String getCertificateExpireDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getCertificateExpireDate(CERTKEY, corpNum);
  }
  
  public int checkCERTIsValid(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.checkCERTIsValid(CERTKEY, corpNum);
  }
  
  public java.lang.String getCertificateRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getCertificateRegistURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getBaroBillURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD, java.lang.String TOGO) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getBaroBillURL(CERTKEY, corpNum, ID, PWD, TOGO);
  }
  
  public java.lang.String getLoginURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getLoginURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getCashChargeURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getCashChargeURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getSMSFromNumberURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getSMSFromNumberURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public int registSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.registSMSFromNumber(CERTKEY, corpNum, fromNumber);
  }
  
  public int checkSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.checkSMSFromNumber(CERTKEY, corpNum, fromNumber);
  }
  
  public java.lang.String getErrString(java.lang.String CERTKEY, int errCode) throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    return baroService_SMSSoap.getErrString(CERTKEY, errCode);
  }
  
  public void ping() throws java.rmi.RemoteException{
    if (baroService_SMSSoap == null)
      _initBaroService_SMSSoapProxy();
    baroService_SMSSoap.ping();
  }
  
  
}