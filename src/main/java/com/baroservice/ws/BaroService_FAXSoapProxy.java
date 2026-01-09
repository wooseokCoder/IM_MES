package com.baroservice.ws;

public class BaroService_FAXSoapProxy implements com.baroservice.ws.BaroService_FAXSoap {
  private String _endpoint = null;
  private com.baroservice.ws.BaroService_FAXSoap baroService_FAXSoap = null;
  
  public BaroService_FAXSoapProxy() {
    _initBaroService_FAXSoapProxy();
  }
  
  public BaroService_FAXSoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initBaroService_FAXSoapProxy();
  }
  
  private void _initBaroService_FAXSoapProxy() {
    try {
      baroService_FAXSoap = (new com.baroservice.ws.BaroService_FAXLocator()).getBaroService_FAXSoap();
      if (baroService_FAXSoap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)baroService_FAXSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)baroService_FAXSoap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (baroService_FAXSoap != null)
      ((javax.xml.rpc.Stub)baroService_FAXSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.baroservice.ws.BaroService_FAXSoap getBaroService_FAXSoap() {
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap;
  }
  
  public java.lang.String sendFaxFromFTP(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fileName, java.lang.String fromNumber, java.lang.String toNumber, java.lang.String receiveCorp, java.lang.String receiveName, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.sendFaxFromFTP(CERTKEY, corpNum, senderID, fileName, fromNumber, toNumber, receiveCorp, receiveName, sendDT, refKey);
  }
  
  public java.lang.String[] sendFaxesFromFTP(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fileName, int sendCount, com.baroservice.ws.FaxMessage[] messages, java.lang.String sendDT) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.sendFaxesFromFTP(CERTKEY, corpNum, senderID, fileName, sendCount, messages, sendDT);
  }
  
  public java.lang.String sendFaxFromFTPEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, int fileCount, java.lang.String[] fileNames, java.lang.String fromNumber, java.lang.String toNumber, java.lang.String receiveCorp, java.lang.String receiveName, java.lang.String sendDT, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.sendFaxFromFTPEx(CERTKEY, corpNum, senderID, fileCount, fileNames, fromNumber, toNumber, receiveCorp, receiveName, sendDT, refKey);
  }
  
  public java.lang.String[] sendFaxesFromFTPEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, int fileCount, java.lang.String[] fileNames, int sendCount, com.baroservice.ws.FaxMessage[] messages, java.lang.String sendDT) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.sendFaxesFromFTPEx(CERTKEY, corpNum, senderID, fileCount, fileNames, sendCount, messages, sendDT);
  }
  
  public java.lang.String reSendFax(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String sendKey, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.reSendFax(CERTKEY, corpNum, senderID, sendKey, refKey);
  }
  
  public java.lang.String reSendFaxEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String sendKey, java.lang.String refKey, java.lang.String toNumber) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.reSendFaxEx(CERTKEY, corpNum, senderID, sendKey, refKey, toNumber);
  }
  
  public int cancelReservedFaxMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.cancelReservedFaxMessage(CERTKEY, corpNum, sendKey);
  }
  
  public int getFaxSendState(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxSendState(CERTKEY, corpNum, sendKey);
  }
  
  public com.baroservice.ws.FaxMessage getFaxMessage(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxMessage(CERTKEY, corpNum, sendKey);
  }
  
  public com.baroservice.ws.FaxMessageEx getFaxMessageEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxMessageEx(CERTKEY, corpNum, sendKey);
  }
  
  public com.baroservice.ws.FaxMessage[] getFaxSendMessages(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] sendKeyList) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxSendMessages(CERTKEY, corpNum, sendKeyList);
  }
  
  public com.baroservice.ws.FaxMessageEx[] getFaxSendMessagesEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] sendKeyList) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxSendMessagesEx(CERTKEY, corpNum, sendKeyList);
  }
  
  public com.baroservice.ws.FaxMessage[] getFaxSendMessagesByRefKey(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxSendMessagesByRefKey(CERTKEY, corpNum, refKey);
  }
  
  public com.baroservice.ws.FaxMessageEx[] getFaxSendMessagesByRefKeyEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String refKey) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxSendMessagesByRefKeyEx(CERTKEY, corpNum, refKey);
  }
  
  public com.baroservice.ws.PagedFaxMessages getFaxSendMessagesByPaging(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromDate, java.lang.String toDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxSendMessagesByPaging(CERTKEY, corpNum, fromDate, toDate, countPerPage, currentPage);
  }
  
  public java.lang.String getFaxHistoryURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxHistoryURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String[] getFaxFileURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String sendKey, int fileType) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getFaxFileURL(CERTKEY, corpNum, sendKey, fileType);
  }
  
  public int checkCorpIsMember(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.checkCorpIsMember(CERTKEY, corpNum, checkCorpNum);
  }
  
  public int registCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.registCorp(CERTKEY, corpNum, corpName, CEOName, bizType, bizClass, postNum, addr1, addr2, memberName, juminNum, ID, PWD, grade, TEL, HP, email);
  }
  
  public int addUserToCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.addUserToCorp(CERTKEY, corpNum, memberName, juminNum, ID, PWD, grade, TEL, HP, email);
  }
  
  public int updateCorpInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.updateCorpInfo(CERTKEY, corpNum, corpName, CEOName, bizType, bizClass, postNum, addr1, addr2);
  }
  
  public int updateUserInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String memberName, java.lang.String juminNum, java.lang.String TEL, java.lang.String HP, java.lang.String email, java.lang.String grade) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.updateUserInfo(CERTKEY, corpNum, ID, memberName, juminNum, TEL, HP, email, grade);
  }
  
  public int updateUserPWD(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String newPWD) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.updateUserPWD(CERTKEY, corpNum, ID, newPWD);
  }
  
  public int changeCorpManager(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String newManagerID) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.changeCorpManager(CERTKEY, corpNum, newManagerID);
  }
  
  public com.baroservice.ws.Contact[] getCorpMemberContacts(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getCorpMemberContacts(CERTKEY, corpNum, checkCorpNum);
  }
  
  public long getBalanceCostAmount(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getBalanceCostAmount(CERTKEY, corpNum);
  }
  
  public long getBalanceCostAmountOfInterOP(java.lang.String CERTKEY) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getBalanceCostAmountOfInterOP(CERTKEY);
  }
  
  public int checkChargeable(java.lang.String CERTKEY, java.lang.String corpNum, int CType, int docType) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.checkChargeable(CERTKEY, corpNum, CType, docType);
  }
  
  public int getChargeUnitCost(java.lang.String CERTKEY, java.lang.String corpNum, int chargeCode) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getChargeUnitCost(CERTKEY, corpNum, chargeCode);
  }
  
  public java.lang.String getCertificateRegistDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getCertificateRegistDate(CERTKEY, corpNum);
  }
  
  public java.lang.String getCertificateExpireDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getCertificateExpireDate(CERTKEY, corpNum);
  }
  
  public int checkCERTIsValid(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.checkCERTIsValid(CERTKEY, corpNum);
  }
  
  public java.lang.String getCertificateRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getCertificateRegistURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getBaroBillURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD, java.lang.String TOGO) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getBaroBillURL(CERTKEY, corpNum, ID, PWD, TOGO);
  }
  
  public java.lang.String getLoginURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getLoginURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getCashChargeURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getCashChargeURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getSMSFromNumberURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getSMSFromNumberURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public int registSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.registSMSFromNumber(CERTKEY, corpNum, fromNumber);
  }
  
  public int checkSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.checkSMSFromNumber(CERTKEY, corpNum, fromNumber);
  }
  
  public java.lang.String getErrString(java.lang.String CERTKEY, int errCode) throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    return baroService_FAXSoap.getErrString(CERTKEY, errCode);
  }
  
  public void ping() throws java.rmi.RemoteException{
    if (baroService_FAXSoap == null)
      _initBaroService_FAXSoapProxy();
    baroService_FAXSoap.ping();
  }
  
  
}