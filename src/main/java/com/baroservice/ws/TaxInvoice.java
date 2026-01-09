/**
 * TaxInvoice.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class TaxInvoice  implements java.io.Serializable {
    private java.lang.String invoiceKey;

    private com.baroservice.ws.InvoiceParty invoicerParty;

    private com.baroservice.ws.InvoiceParty invoiceeParty;

    private com.baroservice.ws.InvoiceParty brokerParty;

    private java.lang.String invoiceeASPEmail;

    private int issueDirection;

    private int taxInvoiceType;

    private int taxType;

    private int taxCalcType;

    private int purposeType;

    private java.lang.String modifyCode;

    private java.lang.String kwon;

    private java.lang.String ho;

    private java.lang.String serialNum;

    private java.lang.String cash;

    private java.lang.String chkBill;

    private java.lang.String note;

    private java.lang.String credit;

    private java.lang.String writeDate;

    private java.lang.String amountTotal;

    private java.lang.String taxTotal;

    private java.lang.String totalAmount;

    private java.lang.String remark1;

    private java.lang.String remark2;

    private java.lang.String remark3;

    private com.baroservice.ws.TaxInvoiceTradeLineItem[] taxInvoiceTradeLineItems;

    public TaxInvoice() {
    }

    public TaxInvoice(
           java.lang.String invoiceKey,
           com.baroservice.ws.InvoiceParty invoicerParty,
           com.baroservice.ws.InvoiceParty invoiceeParty,
           com.baroservice.ws.InvoiceParty brokerParty,
           java.lang.String invoiceeASPEmail,
           int issueDirection,
           int taxInvoiceType,
           int taxType,
           int taxCalcType,
           int purposeType,
           java.lang.String modifyCode,
           java.lang.String kwon,
           java.lang.String ho,
           java.lang.String serialNum,
           java.lang.String cash,
           java.lang.String chkBill,
           java.lang.String note,
           java.lang.String credit,
           java.lang.String writeDate,
           java.lang.String amountTotal,
           java.lang.String taxTotal,
           java.lang.String totalAmount,
           java.lang.String remark1,
           java.lang.String remark2,
           java.lang.String remark3,
           com.baroservice.ws.TaxInvoiceTradeLineItem[] taxInvoiceTradeLineItems) {
           this.invoiceKey = invoiceKey;
           this.invoicerParty = invoicerParty;
           this.invoiceeParty = invoiceeParty;
           this.brokerParty = brokerParty;
           this.invoiceeASPEmail = invoiceeASPEmail;
           this.issueDirection = issueDirection;
           this.taxInvoiceType = taxInvoiceType;
           this.taxType = taxType;
           this.taxCalcType = taxCalcType;
           this.purposeType = purposeType;
           this.modifyCode = modifyCode;
           this.kwon = kwon;
           this.ho = ho;
           this.serialNum = serialNum;
           this.cash = cash;
           this.chkBill = chkBill;
           this.note = note;
           this.credit = credit;
           this.writeDate = writeDate;
           this.amountTotal = amountTotal;
           this.taxTotal = taxTotal;
           this.totalAmount = totalAmount;
           this.remark1 = remark1;
           this.remark2 = remark2;
           this.remark3 = remark3;
           this.taxInvoiceTradeLineItems = taxInvoiceTradeLineItems;
    }


    /**
     * Gets the invoiceKey value for this TaxInvoice.
     * 
     * @return invoiceKey
     */
    public java.lang.String getInvoiceKey() {
        return invoiceKey;
    }


    /**
     * Sets the invoiceKey value for this TaxInvoice.
     * 
     * @param invoiceKey
     */
    public void setInvoiceKey(java.lang.String invoiceKey) {
        this.invoiceKey = invoiceKey;
    }


    /**
     * Gets the invoicerParty value for this TaxInvoice.
     * 
     * @return invoicerParty
     */
    public com.baroservice.ws.InvoiceParty getInvoicerParty() {
        return invoicerParty;
    }


    /**
     * Sets the invoicerParty value for this TaxInvoice.
     * 
     * @param invoicerParty
     */
    public void setInvoicerParty(com.baroservice.ws.InvoiceParty invoicerParty) {
        this.invoicerParty = invoicerParty;
    }


    /**
     * Gets the invoiceeParty value for this TaxInvoice.
     * 
     * @return invoiceeParty
     */
    public com.baroservice.ws.InvoiceParty getInvoiceeParty() {
        return invoiceeParty;
    }


    /**
     * Sets the invoiceeParty value for this TaxInvoice.
     * 
     * @param invoiceeParty
     */
    public void setInvoiceeParty(com.baroservice.ws.InvoiceParty invoiceeParty) {
        this.invoiceeParty = invoiceeParty;
    }


    /**
     * Gets the brokerParty value for this TaxInvoice.
     * 
     * @return brokerParty
     */
    public com.baroservice.ws.InvoiceParty getBrokerParty() {
        return brokerParty;
    }


    /**
     * Sets the brokerParty value for this TaxInvoice.
     * 
     * @param brokerParty
     */
    public void setBrokerParty(com.baroservice.ws.InvoiceParty brokerParty) {
        this.brokerParty = brokerParty;
    }


    /**
     * Gets the invoiceeASPEmail value for this TaxInvoice.
     * 
     * @return invoiceeASPEmail
     */
    public java.lang.String getInvoiceeASPEmail() {
        return invoiceeASPEmail;
    }


    /**
     * Sets the invoiceeASPEmail value for this TaxInvoice.
     * 
     * @param invoiceeASPEmail
     */
    public void setInvoiceeASPEmail(java.lang.String invoiceeASPEmail) {
        this.invoiceeASPEmail = invoiceeASPEmail;
    }


    /**
     * Gets the issueDirection value for this TaxInvoice.
     * 
     * @return issueDirection
     */
    public int getIssueDirection() {
        return issueDirection;
    }


    /**
     * Sets the issueDirection value for this TaxInvoice.
     * 
     * @param issueDirection
     */
    public void setIssueDirection(int issueDirection) {
        this.issueDirection = issueDirection;
    }


    /**
     * Gets the taxInvoiceType value for this TaxInvoice.
     * 
     * @return taxInvoiceType
     */
    public int getTaxInvoiceType() {
        return taxInvoiceType;
    }


    /**
     * Sets the taxInvoiceType value for this TaxInvoice.
     * 
     * @param taxInvoiceType
     */
    public void setTaxInvoiceType(int taxInvoiceType) {
        this.taxInvoiceType = taxInvoiceType;
    }


    /**
     * Gets the taxType value for this TaxInvoice.
     * 
     * @return taxType
     */
    public int getTaxType() {
        return taxType;
    }


    /**
     * Sets the taxType value for this TaxInvoice.
     * 
     * @param taxType
     */
    public void setTaxType(int taxType) {
        this.taxType = taxType;
    }


    /**
     * Gets the taxCalcType value for this TaxInvoice.
     * 
     * @return taxCalcType
     */
    public int getTaxCalcType() {
        return taxCalcType;
    }


    /**
     * Sets the taxCalcType value for this TaxInvoice.
     * 
     * @param taxCalcType
     */
    public void setTaxCalcType(int taxCalcType) {
        this.taxCalcType = taxCalcType;
    }


    /**
     * Gets the purposeType value for this TaxInvoice.
     * 
     * @return purposeType
     */
    public int getPurposeType() {
        return purposeType;
    }


    /**
     * Sets the purposeType value for this TaxInvoice.
     * 
     * @param purposeType
     */
    public void setPurposeType(int purposeType) {
        this.purposeType = purposeType;
    }


    /**
     * Gets the modifyCode value for this TaxInvoice.
     * 
     * @return modifyCode
     */
    public java.lang.String getModifyCode() {
        return modifyCode;
    }


    /**
     * Sets the modifyCode value for this TaxInvoice.
     * 
     * @param modifyCode
     */
    public void setModifyCode(java.lang.String modifyCode) {
        this.modifyCode = modifyCode;
    }


    /**
     * Gets the kwon value for this TaxInvoice.
     * 
     * @return kwon
     */
    public java.lang.String getKwon() {
        return kwon;
    }


    /**
     * Sets the kwon value for this TaxInvoice.
     * 
     * @param kwon
     */
    public void setKwon(java.lang.String kwon) {
        this.kwon = kwon;
    }


    /**
     * Gets the ho value for this TaxInvoice.
     * 
     * @return ho
     */
    public java.lang.String getHo() {
        return ho;
    }


    /**
     * Sets the ho value for this TaxInvoice.
     * 
     * @param ho
     */
    public void setHo(java.lang.String ho) {
        this.ho = ho;
    }


    /**
     * Gets the serialNum value for this TaxInvoice.
     * 
     * @return serialNum
     */
    public java.lang.String getSerialNum() {
        return serialNum;
    }


    /**
     * Sets the serialNum value for this TaxInvoice.
     * 
     * @param serialNum
     */
    public void setSerialNum(java.lang.String serialNum) {
        this.serialNum = serialNum;
    }


    /**
     * Gets the cash value for this TaxInvoice.
     * 
     * @return cash
     */
    public java.lang.String getCash() {
        return cash;
    }


    /**
     * Sets the cash value for this TaxInvoice.
     * 
     * @param cash
     */
    public void setCash(java.lang.String cash) {
        this.cash = cash;
    }


    /**
     * Gets the chkBill value for this TaxInvoice.
     * 
     * @return chkBill
     */
    public java.lang.String getChkBill() {
        return chkBill;
    }


    /**
     * Sets the chkBill value for this TaxInvoice.
     * 
     * @param chkBill
     */
    public void setChkBill(java.lang.String chkBill) {
        this.chkBill = chkBill;
    }


    /**
     * Gets the note value for this TaxInvoice.
     * 
     * @return note
     */
    public java.lang.String getNote() {
        return note;
    }


    /**
     * Sets the note value for this TaxInvoice.
     * 
     * @param note
     */
    public void setNote(java.lang.String note) {
        this.note = note;
    }


    /**
     * Gets the credit value for this TaxInvoice.
     * 
     * @return credit
     */
    public java.lang.String getCredit() {
        return credit;
    }


    /**
     * Sets the credit value for this TaxInvoice.
     * 
     * @param credit
     */
    public void setCredit(java.lang.String credit) {
        this.credit = credit;
    }


    /**
     * Gets the writeDate value for this TaxInvoice.
     * 
     * @return writeDate
     */
    public java.lang.String getWriteDate() {
        return writeDate;
    }


    /**
     * Sets the writeDate value for this TaxInvoice.
     * 
     * @param writeDate
     */
    public void setWriteDate(java.lang.String writeDate) {
        this.writeDate = writeDate;
    }


    /**
     * Gets the amountTotal value for this TaxInvoice.
     * 
     * @return amountTotal
     */
    public java.lang.String getAmountTotal() {
        return amountTotal;
    }


    /**
     * Sets the amountTotal value for this TaxInvoice.
     * 
     * @param amountTotal
     */
    public void setAmountTotal(java.lang.String amountTotal) {
        this.amountTotal = amountTotal;
    }


    /**
     * Gets the taxTotal value for this TaxInvoice.
     * 
     * @return taxTotal
     */
    public java.lang.String getTaxTotal() {
        return taxTotal;
    }


    /**
     * Sets the taxTotal value for this TaxInvoice.
     * 
     * @param taxTotal
     */
    public void setTaxTotal(java.lang.String taxTotal) {
        this.taxTotal = taxTotal;
    }


    /**
     * Gets the totalAmount value for this TaxInvoice.
     * 
     * @return totalAmount
     */
    public java.lang.String getTotalAmount() {
        return totalAmount;
    }


    /**
     * Sets the totalAmount value for this TaxInvoice.
     * 
     * @param totalAmount
     */
    public void setTotalAmount(java.lang.String totalAmount) {
        this.totalAmount = totalAmount;
    }


    /**
     * Gets the remark1 value for this TaxInvoice.
     * 
     * @return remark1
     */
    public java.lang.String getRemark1() {
        return remark1;
    }


    /**
     * Sets the remark1 value for this TaxInvoice.
     * 
     * @param remark1
     */
    public void setRemark1(java.lang.String remark1) {
        this.remark1 = remark1;
    }


    /**
     * Gets the remark2 value for this TaxInvoice.
     * 
     * @return remark2
     */
    public java.lang.String getRemark2() {
        return remark2;
    }


    /**
     * Sets the remark2 value for this TaxInvoice.
     * 
     * @param remark2
     */
    public void setRemark2(java.lang.String remark2) {
        this.remark2 = remark2;
    }


    /**
     * Gets the remark3 value for this TaxInvoice.
     * 
     * @return remark3
     */
    public java.lang.String getRemark3() {
        return remark3;
    }


    /**
     * Sets the remark3 value for this TaxInvoice.
     * 
     * @param remark3
     */
    public void setRemark3(java.lang.String remark3) {
        this.remark3 = remark3;
    }


    /**
     * Gets the taxInvoiceTradeLineItems value for this TaxInvoice.
     * 
     * @return taxInvoiceTradeLineItems
     */
    public com.baroservice.ws.TaxInvoiceTradeLineItem[] getTaxInvoiceTradeLineItems() {
        return taxInvoiceTradeLineItems;
    }


    /**
     * Sets the taxInvoiceTradeLineItems value for this TaxInvoice.
     * 
     * @param taxInvoiceTradeLineItems
     */
    public void setTaxInvoiceTradeLineItems(com.baroservice.ws.TaxInvoiceTradeLineItem[] taxInvoiceTradeLineItems) {
        this.taxInvoiceTradeLineItems = taxInvoiceTradeLineItems;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof TaxInvoice)) return false;
        TaxInvoice other = (TaxInvoice) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.invoiceKey==null && other.getInvoiceKey()==null) || 
             (this.invoiceKey!=null &&
              this.invoiceKey.equals(other.getInvoiceKey()))) &&
            ((this.invoicerParty==null && other.getInvoicerParty()==null) || 
             (this.invoicerParty!=null &&
              this.invoicerParty.equals(other.getInvoicerParty()))) &&
            ((this.invoiceeParty==null && other.getInvoiceeParty()==null) || 
             (this.invoiceeParty!=null &&
              this.invoiceeParty.equals(other.getInvoiceeParty()))) &&
            ((this.brokerParty==null && other.getBrokerParty()==null) || 
             (this.brokerParty!=null &&
              this.brokerParty.equals(other.getBrokerParty()))) &&
            ((this.invoiceeASPEmail==null && other.getInvoiceeASPEmail()==null) || 
             (this.invoiceeASPEmail!=null &&
              this.invoiceeASPEmail.equals(other.getInvoiceeASPEmail()))) &&
            this.issueDirection == other.getIssueDirection() &&
            this.taxInvoiceType == other.getTaxInvoiceType() &&
            this.taxType == other.getTaxType() &&
            this.taxCalcType == other.getTaxCalcType() &&
            this.purposeType == other.getPurposeType() &&
            ((this.modifyCode==null && other.getModifyCode()==null) || 
             (this.modifyCode!=null &&
              this.modifyCode.equals(other.getModifyCode()))) &&
            ((this.kwon==null && other.getKwon()==null) || 
             (this.kwon!=null &&
              this.kwon.equals(other.getKwon()))) &&
            ((this.ho==null && other.getHo()==null) || 
             (this.ho!=null &&
              this.ho.equals(other.getHo()))) &&
            ((this.serialNum==null && other.getSerialNum()==null) || 
             (this.serialNum!=null &&
              this.serialNum.equals(other.getSerialNum()))) &&
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
            ((this.writeDate==null && other.getWriteDate()==null) || 
             (this.writeDate!=null &&
              this.writeDate.equals(other.getWriteDate()))) &&
            ((this.amountTotal==null && other.getAmountTotal()==null) || 
             (this.amountTotal!=null &&
              this.amountTotal.equals(other.getAmountTotal()))) &&
            ((this.taxTotal==null && other.getTaxTotal()==null) || 
             (this.taxTotal!=null &&
              this.taxTotal.equals(other.getTaxTotal()))) &&
            ((this.totalAmount==null && other.getTotalAmount()==null) || 
             (this.totalAmount!=null &&
              this.totalAmount.equals(other.getTotalAmount()))) &&
            ((this.remark1==null && other.getRemark1()==null) || 
             (this.remark1!=null &&
              this.remark1.equals(other.getRemark1()))) &&
            ((this.remark2==null && other.getRemark2()==null) || 
             (this.remark2!=null &&
              this.remark2.equals(other.getRemark2()))) &&
            ((this.remark3==null && other.getRemark3()==null) || 
             (this.remark3!=null &&
              this.remark3.equals(other.getRemark3()))) &&
            ((this.taxInvoiceTradeLineItems==null && other.getTaxInvoiceTradeLineItems()==null) || 
             (this.taxInvoiceTradeLineItems!=null &&
              java.util.Arrays.equals(this.taxInvoiceTradeLineItems, other.getTaxInvoiceTradeLineItems())));
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
        if (getInvoiceKey() != null) {
            _hashCode += getInvoiceKey().hashCode();
        }
        if (getInvoicerParty() != null) {
            _hashCode += getInvoicerParty().hashCode();
        }
        if (getInvoiceeParty() != null) {
            _hashCode += getInvoiceeParty().hashCode();
        }
        if (getBrokerParty() != null) {
            _hashCode += getBrokerParty().hashCode();
        }
        if (getInvoiceeASPEmail() != null) {
            _hashCode += getInvoiceeASPEmail().hashCode();
        }
        _hashCode += getIssueDirection();
        _hashCode += getTaxInvoiceType();
        _hashCode += getTaxType();
        _hashCode += getTaxCalcType();
        _hashCode += getPurposeType();
        if (getModifyCode() != null) {
            _hashCode += getModifyCode().hashCode();
        }
        if (getKwon() != null) {
            _hashCode += getKwon().hashCode();
        }
        if (getHo() != null) {
            _hashCode += getHo().hashCode();
        }
        if (getSerialNum() != null) {
            _hashCode += getSerialNum().hashCode();
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
        if (getWriteDate() != null) {
            _hashCode += getWriteDate().hashCode();
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
        if (getRemark1() != null) {
            _hashCode += getRemark1().hashCode();
        }
        if (getRemark2() != null) {
            _hashCode += getRemark2().hashCode();
        }
        if (getRemark3() != null) {
            _hashCode += getRemark3().hashCode();
        }
        if (getTaxInvoiceTradeLineItems() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getTaxInvoiceTradeLineItems());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getTaxInvoiceTradeLineItems(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(TaxInvoice.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoice"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoicerParty");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoicerParty"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceParty"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeParty");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeParty"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceParty"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("brokerParty");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BrokerParty"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceParty"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceeASPEmail");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceeASPEmail"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("issueDirection");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "IssueDirection"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxInvoiceType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoiceType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxCalcType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxCalcType"));
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
        elemField.setFieldName("modifyCode");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ModifyCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("kwon");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Kwon"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ho");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Ho"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("serialNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SerialNum"));
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
        elemField.setFieldName("writeDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "WriteDate"));
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
        elemField.setFieldName("taxInvoiceTradeLineItems");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoiceTradeLineItems"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoiceTradeLineItem"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setItemQName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoiceTradeLineItem"));
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
