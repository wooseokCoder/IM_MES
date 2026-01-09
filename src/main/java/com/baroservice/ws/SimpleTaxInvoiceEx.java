/**
 * SimpleTaxInvoiceEx.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class SimpleTaxInvoiceEx  implements java.io.Serializable {
    private java.lang.String NTSSendKey;

    private java.lang.String NTSSendDT;

    private java.lang.String issueDT;

    private java.lang.String writeDate;

    private java.lang.String modifyCode;

    private int taxType;

    private int purposeType;

    private java.lang.String invoicerCorpNum;

    private java.lang.String invoicerTaxRegID;

    private java.lang.String invoicerCorpName;

    private java.lang.String invoicerCEOName;

    private java.lang.String invoicerAddr;

    private java.lang.String invoicerBizType;

    private java.lang.String invoicerBizClass;

    private java.lang.String invoicerContactName;

    private java.lang.String invoicerEmail;

    private java.lang.String invoiceeCorpNum;

    private java.lang.String invoiceeTaxRegID;

    private java.lang.String invoiceeCorpName;

    private java.lang.String invoiceeCEOName;

    private java.lang.String invoiceeAddr;

    private java.lang.String invoiceeBizType;

    private java.lang.String invoiceeBizClass;

    private java.lang.String invoiceeContactName;

    private java.lang.String invoiceeEmail;

    private java.lang.String brokerCorpNum;

    private java.lang.String brokerTaxRegID;

    private java.lang.String brokerCorpName;

    private java.lang.String brokerCEOName;

    private java.lang.String brokerAddr;

    private java.lang.String brokerBizType;

    private java.lang.String brokerBizClass;

    private java.lang.String brokerContactName;

    private java.lang.String brokerEmail;

    private java.lang.String amountTotal;

    private java.lang.String taxTotal;

    private java.lang.String totalAmount;

    private java.lang.String cash;

    private java.lang.String chkBill;

    private java.lang.String note;

    private java.lang.String credit;

    private java.lang.String remark1;

    private java.lang.String remark2;

    private java.lang.String remark3;

    private java.lang.String itemName;

    private java.lang.String corpNum;

    private java.lang.String taxRegID;

    private java.lang.String corpName;

    private java.lang.String CEOName;

    public SimpleTaxInvoiceEx() {
    }

    public SimpleTaxInvoiceEx(
           java.lang.String NTSSendKey,
           java.lang.String NTSSendDT,
           java.lang.String issueDT,
           java.lang.String writeDate,
           java.lang.String modifyCode,
           int taxType,
           int purposeType,
           java.lang.String invoicerCorpNum,
           java.lang.String invoicerTaxRegID,
           java.lang.String invoicerCorpName,
           java.lang.String invoicerCEOName,
           java.lang.String invoicerAddr,
           java.lang.String invoicerBizType,
           java.lang.String invoicerBizClass,
           java.lang.String invoicerContactName,
           java.lang.String invoicerEmail,
           java.lang.String invoiceeCorpNum,
           java.lang.String invoiceeTaxRegID,
           java.lang.String invoiceeCorpName,
           java.lang.String invoiceeCEOName,
           java.lang.String invoiceeAddr,
           java.lang.String invoiceeBizType,
           java.lang.String invoiceeBizClass,
           java.lang.String invoiceeContactName,
           java.lang.String invoiceeEmail,
           java.lang.String brokerCorpNum,
           java.lang.String brokerTaxRegID,
           java.lang.String brokerCorpName,
           java.lang.String brokerCEOName,
           java.lang.String brokerAddr,
           java.lang.String brokerBizType,
           java.lang.String brokerBizClass,
           java.lang.String brokerContactName,
           java.lang.String brokerEmail,
           java.lang.String amountTotal,
           java.lang.String taxTotal,
           java.lang.String totalAmount,
           java.lang.String cash,
           java.lang.String chkBill,
           java.lang.String note,
           java.lang.String credit,
           java.lang.String remark1,
           java.lang.String remark2,
           java.lang.String remark3,
           java.lang.String itemName,
           java.lang.String corpNum,
           java.lang.String taxRegID,
           java.lang.String corpName,
           java.lang.String CEOName) {
           this.NTSSendKey = NTSSendKey;
           this.NTSSendDT = NTSSendDT;
           this.issueDT = issueDT;
           this.writeDate = writeDate;
           this.modifyCode = modifyCode;
           this.taxType = taxType;
           this.purposeType = purposeType;
           this.invoicerCorpNum = invoicerCorpNum;
           this.invoicerTaxRegID = invoicerTaxRegID;
           this.invoicerCorpName = invoicerCorpName;
           this.invoicerCEOName = invoicerCEOName;
           this.invoicerAddr = invoicerAddr;
           this.invoicerBizType = invoicerBizType;
           this.invoicerBizClass = invoicerBizClass;
           this.invoicerContactName = invoicerContactName;
           this.invoicerEmail = invoicerEmail;
           this.invoiceeCorpNum = invoiceeCorpNum;
           this.invoiceeTaxRegID = invoiceeTaxRegID;
           this.invoiceeCorpName = invoiceeCorpName;
           this.invoiceeCEOName = invoiceeCEOName;
           this.invoiceeAddr = invoiceeAddr;
           this.invoiceeBizType = invoiceeBizType;
           this.invoiceeBizClass = invoiceeBizClass;
           this.invoiceeContactName = invoiceeContactName;
           this.invoiceeEmail = invoiceeEmail;
           this.brokerCorpNum = brokerCorpNum;
           this.brokerTaxRegID = brokerTaxRegID;
           this.brokerCorpName = brokerCorpName;
           this.brokerCEOName = brokerCEOName;
           this.brokerAddr = brokerAddr;
           this.brokerBizType = brokerBizType;
           this.brokerBizClass = brokerBizClass;
           this.brokerContactName = brokerContactName;
           this.brokerEmail = brokerEmail;
           this.amountTotal = amountTotal;
           this.taxTotal = taxTotal;
           this.totalAmount = totalAmount;
           this.cash = cash;
           this.chkBill = chkBill;
           this.note = note;
           this.credit = credit;
           this.remark1 = remark1;
           this.remark2 = remark2;
           this.remark3 = remark3;
           this.itemName = itemName;
           this.corpNum = corpNum;
           this.taxRegID = taxRegID;
           this.corpName = corpName;
           this.CEOName = CEOName;
    }


    /**
     * Gets the NTSSendKey value for this SimpleTaxInvoiceEx.
     * 
     * @return NTSSendKey
     */
    public java.lang.String getNTSSendKey() {
        return NTSSendKey;
    }


    /**
     * Sets the NTSSendKey value for this SimpleTaxInvoiceEx.
     * 
     * @param NTSSendKey
     */
    public void setNTSSendKey(java.lang.String NTSSendKey) {
        this.NTSSendKey = NTSSendKey;
    }


    /**
     * Gets the NTSSendDT value for this SimpleTaxInvoiceEx.
     * 
     * @return NTSSendDT
     */
    public java.lang.String getNTSSendDT() {
        return NTSSendDT;
    }


    /**
     * Sets the NTSSendDT value for this SimpleTaxInvoiceEx.
     * 
     * @param NTSSendDT
     */
    public void setNTSSendDT(java.lang.String NTSSendDT) {
        this.NTSSendDT = NTSSendDT;
    }


    /**
     * Gets the issueDT value for this SimpleTaxInvoiceEx.
     * 
     * @return issueDT
     */
    public java.lang.String getIssueDT() {
        return issueDT;
    }


    /**
     * Sets the issueDT value for this SimpleTaxInvoiceEx.
     * 
     * @param issueDT
     */
    public void setIssueDT(java.lang.String issueDT) {
        this.issueDT = issueDT;
    }


    /**
     * Gets the writeDate value for this SimpleTaxInvoiceEx.
     * 
     * @return writeDate
     */
    public java.lang.String getWriteDate() {
        return writeDate;
    }


    /**
     * Sets the writeDate value for this SimpleTaxInvoiceEx.
     * 
     * @param writeDate
     */
    public void setWriteDate(java.lang.String writeDate) {
        this.writeDate = writeDate;
    }


    /**
     * Gets the modifyCode value for this SimpleTaxInvoiceEx.
     * 
     * @return modifyCode
     */
    public java.lang.String getModifyCode() {
        return modifyCode;
    }


    /**
     * Sets the modifyCode value for this SimpleTaxInvoiceEx.
     * 
     * @param modifyCode
     */
    public void setModifyCode(java.lang.String modifyCode) {
        this.modifyCode = modifyCode;
    }


    /**
     * Gets the taxType value for this SimpleTaxInvoiceEx.
     * 
     * @return taxType
     */
    public int getTaxType() {
        return taxType;
    }


    /**
     * Sets the taxType value for this SimpleTaxInvoiceEx.
     * 
     * @param taxType
     */
    public void setTaxType(int taxType) {
        this.taxType = taxType;
    }


    /**
     * Gets the purposeType value for this SimpleTaxInvoiceEx.
     * 
     * @return purposeType
     */
    public int getPurposeType() {
        return purposeType;
    }


    /**
     * Sets the purposeType value for this SimpleTaxInvoiceEx.
     * 
     * @param purposeType
     */
    public void setPurposeType(int purposeType) {
        this.purposeType = purposeType;
    }


    /**
     * Gets the invoicerCorpNum value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerCorpNum
     */
    public java.lang.String getInvoicerCorpNum() {
        return invoicerCorpNum;
    }


    /**
     * Sets the invoicerCorpNum value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerCorpNum
     */
    public void setInvoicerCorpNum(java.lang.String invoicerCorpNum) {
        this.invoicerCorpNum = invoicerCorpNum;
    }


    /**
     * Gets the invoicerTaxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerTaxRegID
     */
    public java.lang.String getInvoicerTaxRegID() {
        return invoicerTaxRegID;
    }


    /**
     * Sets the invoicerTaxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerTaxRegID
     */
    public void setInvoicerTaxRegID(java.lang.String invoicerTaxRegID) {
        this.invoicerTaxRegID = invoicerTaxRegID;
    }


    /**
     * Gets the invoicerCorpName value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerCorpName
     */
    public java.lang.String getInvoicerCorpName() {
        return invoicerCorpName;
    }


    /**
     * Sets the invoicerCorpName value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerCorpName
     */
    public void setInvoicerCorpName(java.lang.String invoicerCorpName) {
        this.invoicerCorpName = invoicerCorpName;
    }


    /**
     * Gets the invoicerCEOName value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerCEOName
     */
    public java.lang.String getInvoicerCEOName() {
        return invoicerCEOName;
    }


    /**
     * Sets the invoicerCEOName value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerCEOName
     */
    public void setInvoicerCEOName(java.lang.String invoicerCEOName) {
        this.invoicerCEOName = invoicerCEOName;
    }


    /**
     * Gets the invoicerAddr value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerAddr
     */
    public java.lang.String getInvoicerAddr() {
        return invoicerAddr;
    }


    /**
     * Sets the invoicerAddr value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerAddr
     */
    public void setInvoicerAddr(java.lang.String invoicerAddr) {
        this.invoicerAddr = invoicerAddr;
    }


    /**
     * Gets the invoicerBizType value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerBizType
     */
    public java.lang.String getInvoicerBizType() {
        return invoicerBizType;
    }


    /**
     * Sets the invoicerBizType value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerBizType
     */
    public void setInvoicerBizType(java.lang.String invoicerBizType) {
        this.invoicerBizType = invoicerBizType;
    }


    /**
     * Gets the invoicerBizClass value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerBizClass
     */
    public java.lang.String getInvoicerBizClass() {
        return invoicerBizClass;
    }


    /**
     * Sets the invoicerBizClass value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerBizClass
     */
    public void setInvoicerBizClass(java.lang.String invoicerBizClass) {
        this.invoicerBizClass = invoicerBizClass;
    }


    /**
     * Gets the invoicerContactName value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerContactName
     */
    public java.lang.String getInvoicerContactName() {
        return invoicerContactName;
    }


    /**
     * Sets the invoicerContactName value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerContactName
     */
    public void setInvoicerContactName(java.lang.String invoicerContactName) {
        this.invoicerContactName = invoicerContactName;
    }


    /**
     * Gets the invoicerEmail value for this SimpleTaxInvoiceEx.
     * 
     * @return invoicerEmail
     */
    public java.lang.String getInvoicerEmail() {
        return invoicerEmail;
    }


    /**
     * Sets the invoicerEmail value for this SimpleTaxInvoiceEx.
     * 
     * @param invoicerEmail
     */
    public void setInvoicerEmail(java.lang.String invoicerEmail) {
        this.invoicerEmail = invoicerEmail;
    }


    /**
     * Gets the invoiceeCorpNum value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeCorpNum
     */
    public java.lang.String getInvoiceeCorpNum() {
        return invoiceeCorpNum;
    }


    /**
     * Sets the invoiceeCorpNum value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeCorpNum
     */
    public void setInvoiceeCorpNum(java.lang.String invoiceeCorpNum) {
        this.invoiceeCorpNum = invoiceeCorpNum;
    }


    /**
     * Gets the invoiceeTaxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeTaxRegID
     */
    public java.lang.String getInvoiceeTaxRegID() {
        return invoiceeTaxRegID;
    }


    /**
     * Sets the invoiceeTaxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeTaxRegID
     */
    public void setInvoiceeTaxRegID(java.lang.String invoiceeTaxRegID) {
        this.invoiceeTaxRegID = invoiceeTaxRegID;
    }


    /**
     * Gets the invoiceeCorpName value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeCorpName
     */
    public java.lang.String getInvoiceeCorpName() {
        return invoiceeCorpName;
    }


    /**
     * Sets the invoiceeCorpName value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeCorpName
     */
    public void setInvoiceeCorpName(java.lang.String invoiceeCorpName) {
        this.invoiceeCorpName = invoiceeCorpName;
    }


    /**
     * Gets the invoiceeCEOName value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeCEOName
     */
    public java.lang.String getInvoiceeCEOName() {
        return invoiceeCEOName;
    }


    /**
     * Sets the invoiceeCEOName value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeCEOName
     */
    public void setInvoiceeCEOName(java.lang.String invoiceeCEOName) {
        this.invoiceeCEOName = invoiceeCEOName;
    }


    /**
     * Gets the invoiceeAddr value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeAddr
     */
    public java.lang.String getInvoiceeAddr() {
        return invoiceeAddr;
    }


    /**
     * Sets the invoiceeAddr value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeAddr
     */
    public void setInvoiceeAddr(java.lang.String invoiceeAddr) {
        this.invoiceeAddr = invoiceeAddr;
    }


    /**
     * Gets the invoiceeBizType value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeBizType
     */
    public java.lang.String getInvoiceeBizType() {
        return invoiceeBizType;
    }


    /**
     * Sets the invoiceeBizType value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeBizType
     */
    public void setInvoiceeBizType(java.lang.String invoiceeBizType) {
        this.invoiceeBizType = invoiceeBizType;
    }


    /**
     * Gets the invoiceeBizClass value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeBizClass
     */
    public java.lang.String getInvoiceeBizClass() {
        return invoiceeBizClass;
    }


    /**
     * Sets the invoiceeBizClass value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeBizClass
     */
    public void setInvoiceeBizClass(java.lang.String invoiceeBizClass) {
        this.invoiceeBizClass = invoiceeBizClass;
    }


    /**
     * Gets the invoiceeContactName value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeContactName
     */
    public java.lang.String getInvoiceeContactName() {
        return invoiceeContactName;
    }


    /**
     * Sets the invoiceeContactName value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeContactName
     */
    public void setInvoiceeContactName(java.lang.String invoiceeContactName) {
        this.invoiceeContactName = invoiceeContactName;
    }


    /**
     * Gets the invoiceeEmail value for this SimpleTaxInvoiceEx.
     * 
     * @return invoiceeEmail
     */
    public java.lang.String getInvoiceeEmail() {
        return invoiceeEmail;
    }


    /**
     * Sets the invoiceeEmail value for this SimpleTaxInvoiceEx.
     * 
     * @param invoiceeEmail
     */
    public void setInvoiceeEmail(java.lang.String invoiceeEmail) {
        this.invoiceeEmail = invoiceeEmail;
    }


    /**
     * Gets the brokerCorpNum value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerCorpNum
     */
    public java.lang.String getBrokerCorpNum() {
        return brokerCorpNum;
    }


    /**
     * Sets the brokerCorpNum value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerCorpNum
     */
    public void setBrokerCorpNum(java.lang.String brokerCorpNum) {
        this.brokerCorpNum = brokerCorpNum;
    }


    /**
     * Gets the brokerTaxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerTaxRegID
     */
    public java.lang.String getBrokerTaxRegID() {
        return brokerTaxRegID;
    }


    /**
     * Sets the brokerTaxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerTaxRegID
     */
    public void setBrokerTaxRegID(java.lang.String brokerTaxRegID) {
        this.brokerTaxRegID = brokerTaxRegID;
    }


    /**
     * Gets the brokerCorpName value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerCorpName
     */
    public java.lang.String getBrokerCorpName() {
        return brokerCorpName;
    }


    /**
     * Sets the brokerCorpName value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerCorpName
     */
    public void setBrokerCorpName(java.lang.String brokerCorpName) {
        this.brokerCorpName = brokerCorpName;
    }


    /**
     * Gets the brokerCEOName value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerCEOName
     */
    public java.lang.String getBrokerCEOName() {
        return brokerCEOName;
    }


    /**
     * Sets the brokerCEOName value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerCEOName
     */
    public void setBrokerCEOName(java.lang.String brokerCEOName) {
        this.brokerCEOName = brokerCEOName;
    }


    /**
     * Gets the brokerAddr value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerAddr
     */
    public java.lang.String getBrokerAddr() {
        return brokerAddr;
    }


    /**
     * Sets the brokerAddr value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerAddr
     */
    public void setBrokerAddr(java.lang.String brokerAddr) {
        this.brokerAddr = brokerAddr;
    }


    /**
     * Gets the brokerBizType value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerBizType
     */
    public java.lang.String getBrokerBizType() {
        return brokerBizType;
    }


    /**
     * Sets the brokerBizType value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerBizType
     */
    public void setBrokerBizType(java.lang.String brokerBizType) {
        this.brokerBizType = brokerBizType;
    }


    /**
     * Gets the brokerBizClass value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerBizClass
     */
    public java.lang.String getBrokerBizClass() {
        return brokerBizClass;
    }


    /**
     * Sets the brokerBizClass value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerBizClass
     */
    public void setBrokerBizClass(java.lang.String brokerBizClass) {
        this.brokerBizClass = brokerBizClass;
    }


    /**
     * Gets the brokerContactName value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerContactName
     */
    public java.lang.String getBrokerContactName() {
        return brokerContactName;
    }


    /**
     * Sets the brokerContactName value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerContactName
     */
    public void setBrokerContactName(java.lang.String brokerContactName) {
        this.brokerContactName = brokerContactName;
    }


    /**
     * Gets the brokerEmail value for this SimpleTaxInvoiceEx.
     * 
     * @return brokerEmail
     */
    public java.lang.String getBrokerEmail() {
        return brokerEmail;
    }


    /**
     * Sets the brokerEmail value for this SimpleTaxInvoiceEx.
     * 
     * @param brokerEmail
     */
    public void setBrokerEmail(java.lang.String brokerEmail) {
        this.brokerEmail = brokerEmail;
    }


    /**
     * Gets the amountTotal value for this SimpleTaxInvoiceEx.
     * 
     * @return amountTotal
     */
    public java.lang.String getAmountTotal() {
        return amountTotal;
    }


    /**
     * Sets the amountTotal value for this SimpleTaxInvoiceEx.
     * 
     * @param amountTotal
     */
    public void setAmountTotal(java.lang.String amountTotal) {
        this.amountTotal = amountTotal;
    }


    /**
     * Gets the taxTotal value for this SimpleTaxInvoiceEx.
     * 
     * @return taxTotal
     */
    public java.lang.String getTaxTotal() {
        return taxTotal;
    }


    /**
     * Sets the taxTotal value for this SimpleTaxInvoiceEx.
     * 
     * @param taxTotal
     */
    public void setTaxTotal(java.lang.String taxTotal) {
        this.taxTotal = taxTotal;
    }


    /**
     * Gets the totalAmount value for this SimpleTaxInvoiceEx.
     * 
     * @return totalAmount
     */
    public java.lang.String getTotalAmount() {
        return totalAmount;
    }


    /**
     * Sets the totalAmount value for this SimpleTaxInvoiceEx.
     * 
     * @param totalAmount
     */
    public void setTotalAmount(java.lang.String totalAmount) {
        this.totalAmount = totalAmount;
    }


    /**
     * Gets the cash value for this SimpleTaxInvoiceEx.
     * 
     * @return cash
     */
    public java.lang.String getCash() {
        return cash;
    }


    /**
     * Sets the cash value for this SimpleTaxInvoiceEx.
     * 
     * @param cash
     */
    public void setCash(java.lang.String cash) {
        this.cash = cash;
    }


    /**
     * Gets the chkBill value for this SimpleTaxInvoiceEx.
     * 
     * @return chkBill
     */
    public java.lang.String getChkBill() {
        return chkBill;
    }


    /**
     * Sets the chkBill value for this SimpleTaxInvoiceEx.
     * 
     * @param chkBill
     */
    public void setChkBill(java.lang.String chkBill) {
        this.chkBill = chkBill;
    }


    /**
     * Gets the note value for this SimpleTaxInvoiceEx.
     * 
     * @return note
     */
    public java.lang.String getNote() {
        return note;
    }


    /**
     * Sets the note value for this SimpleTaxInvoiceEx.
     * 
     * @param note
     */
    public void setNote(java.lang.String note) {
        this.note = note;
    }


    /**
     * Gets the credit value for this SimpleTaxInvoiceEx.
     * 
     * @return credit
     */
    public java.lang.String getCredit() {
        return credit;
    }


    /**
     * Sets the credit value for this SimpleTaxInvoiceEx.
     * 
     * @param credit
     */
    public void setCredit(java.lang.String credit) {
        this.credit = credit;
    }


    /**
     * Gets the remark1 value for this SimpleTaxInvoiceEx.
     * 
     * @return remark1
     */
    public java.lang.String getRemark1() {
        return remark1;
    }


    /**
     * Sets the remark1 value for this SimpleTaxInvoiceEx.
     * 
     * @param remark1
     */
    public void setRemark1(java.lang.String remark1) {
        this.remark1 = remark1;
    }


    /**
     * Gets the remark2 value for this SimpleTaxInvoiceEx.
     * 
     * @return remark2
     */
    public java.lang.String getRemark2() {
        return remark2;
    }


    /**
     * Sets the remark2 value for this SimpleTaxInvoiceEx.
     * 
     * @param remark2
     */
    public void setRemark2(java.lang.String remark2) {
        this.remark2 = remark2;
    }


    /**
     * Gets the remark3 value for this SimpleTaxInvoiceEx.
     * 
     * @return remark3
     */
    public java.lang.String getRemark3() {
        return remark3;
    }


    /**
     * Sets the remark3 value for this SimpleTaxInvoiceEx.
     * 
     * @param remark3
     */
    public void setRemark3(java.lang.String remark3) {
        this.remark3 = remark3;
    }


    /**
     * Gets the itemName value for this SimpleTaxInvoiceEx.
     * 
     * @return itemName
     */
    public java.lang.String getItemName() {
        return itemName;
    }


    /**
     * Sets the itemName value for this SimpleTaxInvoiceEx.
     * 
     * @param itemName
     */
    public void setItemName(java.lang.String itemName) {
        this.itemName = itemName;
    }


    /**
     * Gets the corpNum value for this SimpleTaxInvoiceEx.
     * 
     * @return corpNum
     */
    public java.lang.String getCorpNum() {
        return corpNum;
    }


    /**
     * Sets the corpNum value for this SimpleTaxInvoiceEx.
     * 
     * @param corpNum
     */
    public void setCorpNum(java.lang.String corpNum) {
        this.corpNum = corpNum;
    }


    /**
     * Gets the taxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @return taxRegID
     */
    public java.lang.String getTaxRegID() {
        return taxRegID;
    }


    /**
     * Sets the taxRegID value for this SimpleTaxInvoiceEx.
     * 
     * @param taxRegID
     */
    public void setTaxRegID(java.lang.String taxRegID) {
        this.taxRegID = taxRegID;
    }


    /**
     * Gets the corpName value for this SimpleTaxInvoiceEx.
     * 
     * @return corpName
     */
    public java.lang.String getCorpName() {
        return corpName;
    }


    /**
     * Sets the corpName value for this SimpleTaxInvoiceEx.
     * 
     * @param corpName
     */
    public void setCorpName(java.lang.String corpName) {
        this.corpName = corpName;
    }


    /**
     * Gets the CEOName value for this SimpleTaxInvoiceEx.
     * 
     * @return CEOName
     */
    public java.lang.String getCEOName() {
        return CEOName;
    }


    /**
     * Sets the CEOName value for this SimpleTaxInvoiceEx.
     * 
     * @param CEOName
     */
    public void setCEOName(java.lang.String CEOName) {
        this.CEOName = CEOName;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SimpleTaxInvoiceEx)) return false;
        SimpleTaxInvoiceEx other = (SimpleTaxInvoiceEx) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.NTSSendKey==null && other.getNTSSendKey()==null) || 
             (this.NTSSendKey!=null &&
              this.NTSSendKey.equals(other.getNTSSendKey()))) &&
            ((this.NTSSendDT==null && other.getNTSSendDT()==null) || 
             (this.NTSSendDT!=null &&
              this.NTSSendDT.equals(other.getNTSSendDT()))) &&
            ((this.issueDT==null && other.getIssueDT()==null) || 
             (this.issueDT!=null &&
              this.issueDT.equals(other.getIssueDT()))) &&
            ((this.writeDate==null && other.getWriteDate()==null) || 
             (this.writeDate!=null &&
              this.writeDate.equals(other.getWriteDate()))) &&
            ((this.modifyCode==null && other.getModifyCode()==null) || 
             (this.modifyCode!=null &&
              this.modifyCode.equals(other.getModifyCode()))) &&
            this.taxType == other.getTaxType() &&
            this.purposeType == other.getPurposeType() &&
            ((this.invoicerCorpNum==null && other.getInvoicerCorpNum()==null) || 
             (this.invoicerCorpNum!=null &&
              this.invoicerCorpNum.equals(other.getInvoicerCorpNum()))) &&
            ((this.invoicerTaxRegID==null && other.getInvoicerTaxRegID()==null) || 
             (this.invoicerTaxRegID!=null &&
              this.invoicerTaxRegID.equals(other.getInvoicerTaxRegID()))) &&
            ((this.invoicerCorpName==null && other.getInvoicerCorpName()==null) || 
             (this.invoicerCorpName!=null &&
              this.invoicerCorpName.equals(other.getInvoicerCorpName()))) &&
            ((this.invoicerCEOName==null && other.getInvoicerCEOName()==null) || 
             (this.invoicerCEOName!=null &&
              this.invoicerCEOName.equals(other.getInvoicerCEOName()))) &&
            ((this.invoicerAddr==null && other.getInvoicerAddr()==null) || 
             (this.invoicerAddr!=null &&
              this.invoicerAddr.equals(other.getInvoicerAddr()))) &&
            ((this.invoicerBizType==null && other.getInvoicerBizType()==null) || 
             (this.invoicerBizType!=null &&
              this.invoicerBizType.equals(other.getInvoicerBizType()))) &&
            ((this.invoicerBizClass==null && other.getInvoicerBizClass()==null) || 
             (this.invoicerBizClass!=null &&
              this.invoicerBizClass.equals(other.getInvoicerBizClass()))) &&
            ((this.invoicerContactName==null && other.getInvoicerContactName()==null) || 
             (this.invoicerContactName!=null &&
              this.invoicerContactName.equals(other.getInvoicerContactName()))) &&
            ((this.invoicerEmail==null && other.getInvoicerEmail()==null) || 
             (this.invoicerEmail!=null &&
              this.invoicerEmail.equals(other.getInvoicerEmail()))) &&
            ((this.invoiceeCorpNum==null && other.getInvoiceeCorpNum()==null) || 
             (this.invoiceeCorpNum!=null &&
              this.invoiceeCorpNum.equals(other.getInvoiceeCorpNum()))) &&
            ((this.invoiceeTaxRegID==null && other.getInvoiceeTaxRegID()==null) || 
             (this.invoiceeTaxRegID!=null &&
              this.invoiceeTaxRegID.equals(other.getInvoiceeTaxRegID()))) &&
            ((this.invoiceeCorpName==null && other.getInvoiceeCorpName()==null) || 
             (this.invoiceeCorpName!=null &&
              this.invoiceeCorpName.equals(other.getInvoiceeCorpName()))) &&
            ((this.invoiceeCEOName==null && other.getInvoiceeCEOName()==null) || 
             (this.invoiceeCEOName!=null &&
              this.invoiceeCEOName.equals(other.getInvoiceeCEOName()))) &&
            ((this.invoiceeAddr==null && other.getInvoiceeAddr()==null) || 
             (this.invoiceeAddr!=null &&
              this.invoiceeAddr.equals(other.getInvoiceeAddr()))) &&
            ((this.invoiceeBizType==null && other.getInvoiceeBizType()==null) || 
             (this.invoiceeBizType!=null &&
              this.invoiceeBizType.equals(other.getInvoiceeBizType()))) &&
            ((this.invoiceeBizClass==null && other.getInvoiceeBizClass()==null) || 
             (this.invoiceeBizClass!=null &&
              this.invoiceeBizClass.equals(other.getInvoiceeBizClass()))) &&
            ((this.invoiceeContactName==null && other.getInvoiceeContactName()==null) || 
             (this.invoiceeContactName!=null &&
              this.invoiceeContactName.equals(other.getInvoiceeContactName()))) &&
            ((this.invoiceeEmail==null && other.getInvoiceeEmail()==null) || 
             (this.invoiceeEmail!=null &&
              this.invoiceeEmail.equals(other.getInvoiceeEmail()))) &&
            ((this.brokerCorpNum==null && other.getBrokerCorpNum()==null) || 
             (this.brokerCorpNum!=null &&
              this.brokerCorpNum.equals(other.getBrokerCorpNum()))) &&
            ((this.brokerTaxRegID==null && other.getBrokerTaxRegID()==null) || 
             (this.brokerTaxRegID!=null &&
              this.brokerTaxRegID.equals(other.getBrokerTaxRegID()))) &&
            ((this.brokerCorpName==null && other.getBrokerCorpName()==null) || 
             (this.brokerCorpName!=null &&
              this.brokerCorpName.equals(other.getBrokerCorpName()))) &&
            ((this.brokerCEOName==null && other.getBrokerCEOName()==null) || 
             (this.brokerCEOName!=null &&
              this.brokerCEOName.equals(other.getBrokerCEOName()))) &&
            ((this.brokerAddr==null && other.getBrokerAddr()==null) || 
             (this.brokerAddr!=null &&
              this.brokerAddr.equals(other.getBrokerAddr()))) &&
            ((this.brokerBizType==null && other.getBrokerBizType()==null) || 
             (this.brokerBizType!=null &&
              this.brokerBizType.equals(other.getBrokerBizType()))) &&
            ((this.brokerBizClass==null && other.getBrokerBizClass()==null) || 
             (this.brokerBizClass!=null &&
              this.brokerBizClass.equals(other.getBrokerBizClass()))) &&
            ((this.brokerContactName==null && other.getBrokerContactName()==null) || 
             (this.brokerContactName!=null &&
              this.brokerContactName.equals(other.getBrokerContactName()))) &&
            ((this.brokerEmail==null && other.getBrokerEmail()==null) || 
             (this.brokerEmail!=null &&
              this.brokerEmail.equals(other.getBrokerEmail()))) &&
            ((this.amountTotal==null && other.getAmountTotal()==null) || 
             (this.amountTotal!=null &&
              this.amountTotal.equals(other.getAmountTotal()))) &&
            ((this.taxTotal==null && other.getTaxTotal()==null) || 
             (this.taxTotal!=null &&
              this.taxTotal.equals(other.getTaxTotal()))) &&
            ((this.totalAmount==null && other.getTotalAmount()==null) || 
             (this.totalAmount!=null &&
              this.totalAmount.equals(other.getTotalAmount()))) &&
            ((this.cash==null && other.getCash()==null) || 
             (this.cash!=null &&
              this.cash.equals(other.getCash()))) &&
            ((this.chkBill==null && other.getChkBill()==null) || 
             (this.chkBill!=null &&
              this.chkBill.equals(other.getChkBill()))) &&
            ((this.note==null && other.getNote()==null) || 
             (this.note!=null &&
              this.note.equals(other.getNote()))) &&
            ((this.credit==null && other.getCredit()==null) || 
             (this.credit!=null &&
              this.credit.equals(other.getCredit()))) &&
            ((this.remark1==null && other.getRemark1()==null) || 
             (this.remark1!=null &&
              this.remark1.equals(other.getRemark1()))) &&
            ((this.remark2==null && other.getRemark2()==null) || 
             (this.remark2!=null &&
              this.remark2.equals(other.getRemark2()))) &&
            ((this.remark3==null && other.getRemark3()==null) || 
             (this.remark3!=null &&
              this.remark3.equals(other.getRemark3()))) &&
            ((this.itemName==null && other.getItemName()==null) || 
             (this.itemName!=null &&
              this.itemName.equals(other.getItemName()))) &&
            ((this.corpNum==null && other.getCorpNum()==null) || 
             (this.corpNum!=null &&
              this.corpNum.equals(other.getCorpNum()))) &&
            ((this.taxRegID==null && other.getTaxRegID()==null) || 
             (this.taxRegID!=null &&
              this.taxRegID.equals(other.getTaxRegID()))) &&
            ((this.corpName==null && other.getCorpName()==null) || 
             (this.corpName!=null &&
              this.corpName.equals(other.getCorpName()))) &&
            ((this.CEOName==null && other.getCEOName()==null) || 
             (this.CEOName!=null &&
              this.CEOName.equals(other.getCEOName())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getNTSSendKey() != null) {
            _hashCode += getNTSSendKey().hashCode();
        }
        if (getNTSSendDT() != null) {
            _hashCode += getNTSSendDT().hashCode();
        }
        if (getIssueDT() != null) {
            _hashCode += getIssueDT().hashCode();
        }
        if (getWriteDate() != null) {
            _hashCode += getWriteDate().hashCode();
        }
        if (getModifyCode() != null) {
            _hashCode += getModifyCode().hashCode();
        }
        _hashCode += getTaxType();
        _hashCode += getPurposeType();
        if (getInvoicerCorpNum() != null) {
            _hashCode += getInvoicerCorpNum().hashCode();
        }
        if (getInvoicerTaxRegID() != null) {
            _hashCode += getInvoicerTaxRegID().hashCode();
        }
        if (getInvoicerCorpName() != null) {
            _hashCode += getInvoicerCorpName().hashCode();
        }
        if (getInvoicerCEOName() != null) {
            _hashCode += getInvoicerCEOName().hashCode();
        }
        if (getInvoicerAddr() != null) {
            _hashCode += getInvoicerAddr().hashCode();
        }
        if (getInvoicerBizType() != null) {
            _hashCode += getInvoicerBizType().hashCode();
        }
        if (getInvoicerBizClass() != null) {
            _hashCode += getInvoicerBizClass().hashCode();
        }
        if (getInvoicerContactName() != null) {
            _hashCode += getInvoicerContactName().hashCode();
        }
        if (getInvoicerEmail() != null) {
            _hashCode += getInvoicerEmail().hashCode();
        }
        if (getInvoiceeCorpNum() != null) {
            _hashCode += getInvoiceeCorpNum().hashCode();
        }
        if (getInvoiceeTaxRegID() != null) {
            _hashCode += getInvoiceeTaxRegID().hashCode();
        }
        if (getInvoiceeCorpName() != null) {
            _hashCode += getInvoiceeCorpName().hashCode();
        }
        if (getInvoiceeCEOName() != null) {
            _hashCode += getInvoiceeCEOName().hashCode();
        }
        if (getInvoiceeAddr() != null) {
            _hashCode += getInvoiceeAddr().hashCode();
        }
        if (getInvoiceeBizType() != null) {
            _hashCode += getInvoiceeBizType().hashCode();
        }
        if (getInvoiceeBizClass() != null) {
            _hashCode += getInvoiceeBizClass().hashCode();
        }
        if (getInvoiceeContactName() != null) {
            _hashCode += getInvoiceeContactName().hashCode();
        }
        if (getInvoiceeEmail() != null) {
            _hashCode += getInvoiceeEmail().hashCode();
        }
        if (getBrokerCorpNum() != null) {
            _hashCode += getBrokerCorpNum().hashCode();
        }
        if (getBrokerTaxRegID() != null) {
            _hashCode += getBrokerTaxRegID().hashCode();
        }
        if (getBrokerCorpName() != null) {
            _hashCode += getBrokerCorpName().hashCode();
        }
        if (getBrokerCEOName() != null) {
            _hashCode += getBrokerCEOName().hashCode();
        }
        if (getBrokerAddr() != null) {
            _hashCode += getBrokerAddr().hashCode();
        }
        if (getBrokerBizType() != null) {
            _hashCode += getBrokerBizType().hashCode();
        }
        if (getBrokerBizClass() != null) {
            _hashCode += getBrokerBizClass().hashCode();
        }
        if (getBrokerContactName() != null) {
            _hashCode += getBrokerContactName().hashCode();
        }
        if (getBrokerEmail() != null) {
            _hashCode += getBrokerEmail().hashCode();
        }
        if (getAmountTotal() != null) {
            _hashCode += getAmountTotal().hashCode();
        }
        if (getTaxTotal() != null) {
            _hashCode += getTaxTotal().hashCode();
        }
        if (getTotalAmount() != null) {
            _hashCode += getTotalAmount().hashCode();
        }
        if (getCash() != null) {
            _hashCode += getCash().hashCode();
        }
        if (getChkBill() != null) {
            _hashCode += getChkBill().hashCode();
        }
        if (getNote() != null) {
            _hashCode += getNote().hashCode();
        }
        if (getCredit() != null) {
            _hashCode += getCredit().hashCode();
        }
        if (getRemark1() != null) {
            _hashCode += getRemark1().hashCode();
        }
        if (getRemark2() != null) {
            _hashCode += getRemark2().hashCode();
        }
        if (getRemark3() != null) {
            _hashCode += getRemark3().hashCode();
        }
        if (getItemName() != null) {
            _hashCode += getItemName().hashCode();
        }
        if (getCorpNum() != null) {
            _hashCode += getCorpNum().hashCode();
        }
        if (getTaxRegID() != null) {
            _hashCode += getTaxRegID().hashCode();
        }
        if (getCorpName() != null) {
            _hashCode += getCorpName().hashCode();
        }
        if (getCEOName() != null) {
            _hashCode += getCEOName().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(SimpleTaxInvoiceEx.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SimpleTaxInvoiceEx"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NTSSendKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSSendKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NTSSendDT");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSSendDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("issueDT");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "IssueDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("writeDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "WriteDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modifyCode");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ModifyCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("purposeType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "PurposeType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerCorpNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerCorpNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerTaxRegID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerTaxRegID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerCorpName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerCorpName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerCEOName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerCEOName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerAddr");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerAddr"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerBizType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerBizType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerBizClass");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerBizClass"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerContactName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerContactName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerEmail");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerEmail"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeCorpNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeCorpNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeTaxRegID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeTaxRegID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeCorpName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeCorpName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeCEOName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeCEOName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeAddr");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeAddr"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeBizType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeBizType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeBizClass");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeBizClass"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeContactName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeContactName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeEmail");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeEmail"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerCorpNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerCorpNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerTaxRegID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerTaxRegID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerCorpName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerCorpName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerCEOName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerCEOName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerAddr");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerAddr"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerBizType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerBizType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerBizClass");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerBizClass"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerContactName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerContactName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerEmail");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerEmail"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("amountTotal");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "AmountTotal"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxTotal");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxTotal"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("totalAmount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TotalAmount"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("cash");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Cash"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("chkBill");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ChkBill"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("note");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Note"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("credit");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Credit"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("remark1");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Remark1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("remark2");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Remark2"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("remark3");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Remark3"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("itemName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ItemName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("corpNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "CorpNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxRegID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxRegID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("corpName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "CorpName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CEOName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "CEOName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
