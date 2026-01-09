package com.baroservice.ws;

public class BaroService_TISoapProxy implements com.baroservice.ws.BaroService_TISoap {
  private String _endpoint = null;
  private com.baroservice.ws.BaroService_TISoap baroService_TISoap = null;
  
  public BaroService_TISoapProxy() {
    _initBaroService_TISoapProxy();
  }
  
  public BaroService_TISoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initBaroService_TISoapProxy();
  }
  
  private void _initBaroService_TISoapProxy() {
    try {
      baroService_TISoap = (new com.baroservice.ws.BaroService_TILocator()).getBaroService_TISoap();
      if (baroService_TISoap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)baroService_TISoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)baroService_TISoap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (baroService_TISoap != null)
      ((javax.xml.rpc.Stub)baroService_TISoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.baroservice.ws.BaroService_TISoap getBaroService_TISoap() {
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap;
  }
  
  public int checkMgtNumIsExists(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.checkMgtNumIsExists(CERTKEY, corpNum, mgtKey);
  }
  
  public int checkIsValidTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.checkIsValidTaxInvoice(CERTKEY, corpNum, invoice);
  }
  
  public int registTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registTaxInvoice(CERTKEY, corpNum, invoice);
  }
  
  public int registTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registTaxInvoiceEX(CERTKEY, corpNum, invoice, issueTiming);
  }
  
  public int registModifyTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registModifyTaxInvoice(CERTKEY, corpNum, invoice, originalNTSSendKey);
  }
  
  public int registModifyTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey, int issueTiming) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registModifyTaxInvoiceEX(CERTKEY, corpNum, invoice, originalNTSSendKey, issueTiming);
  }
  
  public int registTaxInvoiceReverse(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registTaxInvoiceReverse(CERTKEY, corpNum, invoice);
  }
  
  public int registTaxInvoiceReverseEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int chargeDirection) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registTaxInvoiceReverseEX(CERTKEY, corpNum, invoice, chargeDirection);
  }
  
  public int registBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registBrokerTaxInvoice(CERTKEY, corpNum, invoice);
  }
  
  public int registBrokerTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registBrokerTaxInvoiceEX(CERTKEY, corpNum, invoice, issueTiming);
  }
  
  public int registModifyBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registModifyBrokerTaxInvoice(CERTKEY, corpNum, invoice, originalNTSSendKey);
  }
  
  public int registModifyBrokerTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, java.lang.String originalNTSSendKey, int issueTiming) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registModifyBrokerTaxInvoiceEX(CERTKEY, corpNum, invoice, originalNTSSendKey, issueTiming);
  }
  
  public int updateTaxInvoiceFooterString(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String footerString) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateTaxInvoiceFooterString(CERTKEY, corpNum, mgtKey, footerString);
  }
  
  public int updateTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateTaxInvoice(CERTKEY, corpNum, invoice);
  }
  
  public int updateTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateTaxInvoiceEX(CERTKEY, corpNum, invoice, issueTiming);
  }
  
  public int updateBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateBrokerTaxInvoice(CERTKEY, corpNum, invoice);
  }
  
  public int updateBrokerTaxInvoiceEX(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, int issueTiming) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateBrokerTaxInvoiceEX(CERTKEY, corpNum, invoice, issueTiming);
  }
  
  public int deleteTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.deleteTaxInvoice(CERTKEY, corpNum, mgtKey);
  }
  
  public int deleteTaxInvoiceIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.deleteTaxInvoiceIK(CERTKEY, corpNum, invoiceKey);
  }
  
  public int issueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, int NTSSendOption, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.issueTaxInvoice(CERTKEY, corpNum, mgtKey, sendSMS, NTSSendOption, forceIssue, mailTitle);
  }
  
  public int issueTaxInvoiceEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String SMSMessage, boolean forceIssue, java.lang.String mailTitle, boolean businessLicenseYN, boolean bankBookYN) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.issueTaxInvoiceEx(CERTKEY, corpNum, mgtKey, sendSMS, SMSMessage, forceIssue, mailTitle, businessLicenseYN, bankBookYN);
  }
  
  public int reverseIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.reverseIssueTaxInvoice(CERTKEY, corpNum, mgtKey, sendSMS, forceIssue, mailTitle);
  }
  
  public int reverseIssueTaxInvoiceEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String SMSMessage, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.reverseIssueTaxInvoiceEx(CERTKEY, corpNum, mgtKey, sendSMS, SMSMessage, forceIssue, mailTitle);
  }
  
  public int preIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.preIssueTaxInvoice(CERTKEY, corpNum, mgtKey, sendSMS, mailTitle);
  }
  
  public int preIssueTaxInvoiceEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, boolean sendSMS, java.lang.String SMSMessage, java.lang.String mailTitle, boolean businessLicenseYN, boolean bankBookYN) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.preIssueTaxInvoiceEx(CERTKEY, corpNum, mgtKey, sendSMS, SMSMessage, mailTitle, businessLicenseYN, bankBookYN);
  }
  
  public int procTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String procType, java.lang.String memo) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.procTaxInvoice(CERTKEY, corpNum, mgtKey, procType, memo);
  }
  
  public int registAndIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registAndIssueTaxInvoice(CERTKEY, corpNum, invoice, sendSMS, forceIssue, mailTitle);
  }
  
  public int registAndPreIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, int issueTiming, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registAndPreIssueTaxInvoice(CERTKEY, corpNum, invoice, sendSMS, issueTiming, mailTitle);
  }
  
  public int registAndIssueBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registAndIssueBrokerTaxInvoice(CERTKEY, corpNum, invoice, sendSMS, forceIssue, mailTitle);
  }
  
  public int registAndPreIssueBrokerTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, int issueTiming, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registAndPreIssueBrokerTaxInvoice(CERTKEY, corpNum, invoice, sendSMS, issueTiming, mailTitle);
  }
  
  public int registAndReverseIssueTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, com.baroservice.ws.TaxInvoice invoice, boolean sendSMS, boolean forceIssue, java.lang.String mailTitle) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registAndReverseIssueTaxInvoice(CERTKEY, corpNum, invoice, sendSMS, forceIssue, mailTitle);
  }
  
  public com.baroservice.ws.TaxInvoice getTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoice(CERTKEY, corpNum, mgtKey);
  }
  
  public com.baroservice.ws.TaxInvoice getTaxInvoiceIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceIK(CERTKEY, corpNum, invoiceKey);
  }
  
  public com.baroservice.ws.TaxInvoice getTaxInvoiceNK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String NTSConfirmNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceNK(CERTKEY, corpNum, NTSConfirmNum);
  }
  
  public com.baroservice.ws.TaxInvoiceState getTaxInvoiceState(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceState(CERTKEY, corpNum, mgtKey);
  }
  
  public com.baroservice.ws.TaxInvoiceState[] getTaxInvoiceStates(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] mgtKeyList) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceStates(CERTKEY, corpNum, mgtKeyList);
  }
  
  public com.baroservice.ws.TaxInvoiceStateEX getTaxInvoiceStateEX(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceStateEX(CERTKEY, corpNum, mgtKey);
  }
  
  public com.baroservice.ws.TaxInvoiceStateEX[] getTaxInvoiceStatesEX(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] mgtKeyList) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceStatesEX(CERTKEY, corpNum, mgtKeyList);
  }
  
  public com.baroservice.ws.TaxInvoiceState[] getTaxInvoiceStatesIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] invoiceKeyList) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceStatesIK(CERTKEY, corpNum, invoiceKeyList);
  }
  
  public com.baroservice.ws.InvoiceLog[] getTaxInvoiceLog(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceLog(CERTKEY, corpNum, mgtKey);
  }
  
  public com.baroservice.ws.InvoiceLog[] getTaxInvoiceLogIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceLogIK(CERTKEY, corpNum, invoiceKey);
  }
  
  public int attachFileByFTP(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String fileName, java.lang.String displayFileName) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.attachFileByFTP(CERTKEY, corpNum, mgtKey, fileName, displayFileName);
  }
  
  public int deleteAttachFile(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.deleteAttachFile(CERTKEY, corpNum, mgtKey);
  }
  
  public int deleteAttachFileWithFileIndex(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, int fileIndex) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.deleteAttachFileWithFileIndex(CERTKEY, corpNum, mgtKey, fileIndex);
  }
  
  public com.baroservice.ws.AttachedFile[] getAttachedFileList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getAttachedFileList(CERTKEY, corpNum, mgtKey);
  }
  
  public com.baroservice.ws.AttachedFileEx[] getAttachedFileListEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getAttachedFileListEx(CERTKEY, corpNum, mgtKey);
  }
  
  public int reSendEmail(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String toEmailAddress) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.reSendEmail(CERTKEY, corpNum, mgtKey, toEmailAddress);
  }
  
  public int reSendSMS(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String fromNumber, java.lang.String toCorpNum, java.lang.String toName, java.lang.String toNumber, java.lang.String contents) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.reSendSMS(CERTKEY, corpNum, senderID, fromNumber, toCorpNum, toName, toNumber, contents);
  }
  
  public int sendInvoiceSMS(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String senderID, java.lang.String mgtKey, java.lang.String fromNumber, java.lang.String toNumber, java.lang.String contents) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.sendInvoiceSMS(CERTKEY, corpNum, senderID, mgtKey, fromNumber, toNumber, contents);
  }
  
  public int sendInvoiceFax(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String senderID, java.lang.String fromFaxNumber, java.lang.String toFaxNumber) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.sendInvoiceFax(CERTKEY, corpNum, mgtKey, senderID, fromFaxNumber, toFaxNumber);
  }
  
  public java.lang.String getBaroBillURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD, java.lang.String TOGO) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getBaroBillURL(CERTKEY, corpNum, ID, PWD, TOGO);
  }
  
  public java.lang.String getTaxInvoicePopUpURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePopUpURL(CERTKEY, corpNum, mgtKey, ID, PWD);
  }
  
  public java.lang.String getTaxInvoicePopUpURLIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePopUpURLIK(CERTKEY, corpNum, invoiceKey, ID, PWD);
  }
  
  public java.lang.String getTaxInvoicePopUpURLNK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String NTSConfirmNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePopUpURLNK(CERTKEY, corpNum, NTSConfirmNum, ID, PWD);
  }
  
  public java.lang.String getTaxInvoicePrintURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePrintURL(CERTKEY, corpNum, mgtKey, ID, PWD);
  }
  
  public java.lang.String getTaxInvoicePrintURLIK(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String invoiceKey, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePrintURLIK(CERTKEY, corpNum, invoiceKey, ID, PWD);
  }
  
  public java.lang.String getTaxInvoicesPrintURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String[] mgtKeyList, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicesPrintURL(CERTKEY, corpNum, mgtKeyList, ID, PWD);
  }
  
  public java.lang.String getTaxinvoiceMailURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxinvoiceMailURL(CERTKEY, corpNum, mgtKey);
  }
  
  public java.lang.String getTaxInvoiceScrapRequestURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceScrapRequestURL(CERTKEY, corpNum, userID, PWD);
  }
  
  public int getMonthlyCountTaxInvoice(java.lang.String CERTKEY, java.lang.String corpNum, int year, int month, int periodSearchType, boolean hasCanceled) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getMonthlyCountTaxInvoice(CERTKEY, corpNum, year, month, periodSearchType, hasCanceled);
  }
  
  public java.lang.String[] getCanceledTaxInvoiceMgtKey(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String startDate, java.lang.String endDate) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getCanceledTaxInvoiceMgtKey(CERTKEY, corpNum, startDate, endDate);
  }
  
  public com.baroservice.ws.PagedTaxInvoice getTaxInvoiceSalesList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceSalesList(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoice getTaxInvoicePurchaseList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePurchaseList(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoiceSalesListEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceSalesListEx(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoicePurchaseListEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePurchaseListEx(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoice getTaxInvoiceSalesListByID(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceSalesListByID(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoice getTaxInvoicePurchaseListByID(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePurchaseListByID(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoiceSalesListByIDEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoiceSalesListByIDEx(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getTaxInvoicePurchaseListByIDEx(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getTaxInvoicePurchaseListByIDEx(CERTKEY, corpNum, userID, taxType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getDailyTaxInvoiceSalesList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getDailyTaxInvoiceSalesList(CERTKEY, corpNum, userID, taxType, dateType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getDailyTaxInvoicePurchaseList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseDate, int countPerPage, int currentPage) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getDailyTaxInvoicePurchaseList(CERTKEY, corpNum, userID, taxType, dateType, baseDate, countPerPage, currentPage);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getMonthlyTaxInvoiceSalesList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseMonth, int countPerPage, int currentPage, int orderDirection) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getMonthlyTaxInvoiceSalesList(CERTKEY, corpNum, userID, taxType, dateType, baseMonth, countPerPage, currentPage, orderDirection);
  }
  
  public com.baroservice.ws.PagedTaxInvoiceEx getMonthlyTaxInvoicePurchaseList(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, int taxType, int dateType, java.lang.String baseMonth, int countPerPage, int currentPage, int orderDirection) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getMonthlyTaxInvoicePurchaseList(CERTKEY, corpNum, userID, taxType, dateType, baseMonth, countPerPage, currentPage, orderDirection);
  }
  
  public int sendToNTS(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.sendToNTS(CERTKEY, corpNum, mgtKey);
  }
  
  public com.baroservice.ws.NTSSendOption getNTSSendOption(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getNTSSendOption(CERTKEY, corpNum);
  }
  
  public int changeNTSSendOption(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, com.baroservice.ws.NTSSendOption NTSSendOption) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.changeNTSSendOption(CERTKEY, corpNum, ID, NTSSendOption);
  }
  
  public com.baroservice.ws.EMAILPUBLICKEY[] getEmailPublicKeys(java.lang.String CERTKEY) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getEmailPublicKeys(CERTKEY);
  }
  
  public int makeDocLinkage(java.lang.String CERTKEY, java.lang.String corpNum, int fromDocType, java.lang.String fromMgtKey, int toDocType, java.lang.String toMgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.makeDocLinkage(CERTKEY, corpNum, fromDocType, fromMgtKey, toDocType, toMgtKey);
  }
  
  public int removeDocLinkage(java.lang.String CERTKEY, java.lang.String corpNum, int fromDocType, java.lang.String fromMgtKey, int toDocType, java.lang.String toMgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.removeDocLinkage(CERTKEY, corpNum, fromDocType, fromMgtKey, toDocType, toMgtKey);
  }
  
  public com.baroservice.ws.LinkedDoc[] getLinkedDocs(java.lang.String CERTKEY, java.lang.String corpNum, int docType, java.lang.String mgtKey) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getLinkedDocs(CERTKEY, corpNum, docType, mgtKey);
  }
  
  public java.lang.String getJicInRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getJicInRegistURL(CERTKEY, corpNum, userID, PWD);
  }
  
  public java.lang.String getBusinessLicenseRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getBusinessLicenseRegistURL(CERTKEY, corpNum, userID, PWD);
  }
  
  public java.lang.String getBankBookRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String userID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getBankBookRegistURL(CERTKEY, corpNum, userID, PWD);
  }
  
  public int checkCorpIsMember(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.checkCorpIsMember(CERTKEY, corpNum, checkCorpNum);
  }
  
  public int registCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registCorp(CERTKEY, corpNum, corpName, CEOName, bizType, bizClass, postNum, addr1, addr2, memberName, juminNum, ID, PWD, grade, TEL, HP, email);
  }
  
  public int addUserToCorp(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String memberName, java.lang.String juminNum, java.lang.String ID, java.lang.String PWD, java.lang.String grade, java.lang.String TEL, java.lang.String HP, java.lang.String email) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.addUserToCorp(CERTKEY, corpNum, memberName, juminNum, ID, PWD, grade, TEL, HP, email);
  }
  
  public int updateCorpInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String corpName, java.lang.String CEOName, java.lang.String bizType, java.lang.String bizClass, java.lang.String postNum, java.lang.String addr1, java.lang.String addr2) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateCorpInfo(CERTKEY, corpNum, corpName, CEOName, bizType, bizClass, postNum, addr1, addr2);
  }
  
  public int updateUserInfo(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String memberName, java.lang.String juminNum, java.lang.String TEL, java.lang.String HP, java.lang.String email, java.lang.String grade) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateUserInfo(CERTKEY, corpNum, ID, memberName, juminNum, TEL, HP, email, grade);
  }
  
  public int updateUserPWD(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String newPWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.updateUserPWD(CERTKEY, corpNum, ID, newPWD);
  }
  
  public int changeCorpManager(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String newManagerID) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.changeCorpManager(CERTKEY, corpNum, newManagerID);
  }
  
  public com.baroservice.ws.Contact[] getCorpMemberContacts(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String checkCorpNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getCorpMemberContacts(CERTKEY, corpNum, checkCorpNum);
  }
  
  public long getBalanceCostAmount(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getBalanceCostAmount(CERTKEY, corpNum);
  }
  
  public long getBalanceCostAmountOfInterOP(java.lang.String CERTKEY) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getBalanceCostAmountOfInterOP(CERTKEY);
  }
  
  public int checkChargeable(java.lang.String CERTKEY, java.lang.String corpNum, int CType, int docType) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.checkChargeable(CERTKEY, corpNum, CType, docType);
  }
  
  public int getChargeUnitCost(java.lang.String CERTKEY, java.lang.String corpNum, int chargeCode) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getChargeUnitCost(CERTKEY, corpNum, chargeCode);
  }
  
  public java.lang.String getCertificateRegistDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getCertificateRegistDate(CERTKEY, corpNum);
  }
  
  public java.lang.String getCertificateExpireDate(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getCertificateExpireDate(CERTKEY, corpNum);
  }
  
  public int checkCERTIsValid(java.lang.String CERTKEY, java.lang.String corpNum) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.checkCERTIsValid(CERTKEY, corpNum);
  }
  
  public java.lang.String getCertificateRegistURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getCertificateRegistURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getLoginURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getLoginURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getCashChargeURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getCashChargeURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public java.lang.String getSMSFromNumberURL(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String ID, java.lang.String PWD) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getSMSFromNumberURL(CERTKEY, corpNum, ID, PWD);
  }
  
  public int registSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.registSMSFromNumber(CERTKEY, corpNum, fromNumber);
  }
  
  public int checkSMSFromNumber(java.lang.String CERTKEY, java.lang.String corpNum, java.lang.String fromNumber) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.checkSMSFromNumber(CERTKEY, corpNum, fromNumber);
  }
  
  public java.lang.String getErrString(java.lang.String CERTKEY, int errCode) throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    return baroService_TISoap.getErrString(CERTKEY, errCode);
  }
  
  public void ping() throws java.rmi.RemoteException{
    if (baroService_TISoap == null)
      _initBaroService_TISoapProxy();
    baroService_TISoap.ping();
  }
  
  
}