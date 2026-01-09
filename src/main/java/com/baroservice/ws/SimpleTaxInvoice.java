/**
 * SimpleTaxInvoice.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class SimpleTaxInvoice  implements java.io.Serializable {
    private java.lang.String NTSSendKey;

    private java.lang.String writeDate;

    private int taxType;

    private java.lang.String modifyCode;

    private java.lang.String corpNum;

    private java.lang.String taxRegID;

    private java.lang.String corpName;

    private java.lang.String CEOName;

    private java.lang.String amountTotal;

    private java.lang.String taxTotal;

    private java.lang.String totalAmount;

    public SimpleTaxInvoice() {
    }

    public SimpleTaxInvoice(
           java.lang.String NTSSendKey,
           java.lang.String writeDate,
           int taxType,
           java.lang.String modifyCode,
           java.lang.String corpNum,
           java.lang.String taxRegID,
           java.lang.String corpName,
           java.lang.String CEOName,
           java.lang.String amountTotal,
           java.lang.String taxTotal,
           java.lang.String totalAmount) {
           this.NTSSendKey = NTSSendKey;
           this.writeDate = writeDate;
           this.taxType = taxType;
           this.modifyCode = modifyCode;
           this.corpNum = corpNum;
           this.taxRegID = taxRegID;
           this.corpName = corpName;
           this.CEOName = CEOName;
           this.amountTotal = amountTotal;
           this.taxTotal = taxTotal;
           this.totalAmount = totalAmount;
    }


    /**
     * Gets the NTSSendKey value for this SimpleTaxInvoice.
     * 
     * @return NTSSendKey
     */
    public java.lang.String getNTSSendKey() {
        return NTSSendKey;
    }


    /**
     * Sets the NTSSendKey value for this SimpleTaxInvoice.
     * 
     * @param NTSSendKey
     */
    public void setNTSSendKey(java.lang.String NTSSendKey) {
        this.NTSSendKey = NTSSendKey;
    }


    /**
     * Gets the writeDate value for this SimpleTaxInvoice.
     * 
     * @return writeDate
     */
    public java.lang.String getWriteDate() {
        return writeDate;
    }


    /**
     * Sets the writeDate value for this SimpleTaxInvoice.
     * 
     * @param writeDate
     */
    public void setWriteDate(java.lang.String writeDate) {
        this.writeDate = writeDate;
    }


    /**
     * Gets the taxType value for this SimpleTaxInvoice.
     * 
     * @return taxType
     */
    public int getTaxType() {
        return taxType;
    }


    /**
     * Sets the taxType value for this SimpleTaxInvoice.
     * 
     * @param taxType
     */
    public void setTaxType(int taxType) {
        this.taxType = taxType;
    }


    /**
     * Gets the modifyCode value for this SimpleTaxInvoice.
     * 
     * @return modifyCode
     */
    public java.lang.String getModifyCode() {
        return modifyCode;
    }


    /**
     * Sets the modifyCode value for this SimpleTaxInvoice.
     * 
     * @param modifyCode
     */
    public void setModifyCode(java.lang.String modifyCode) {
        this.modifyCode = modifyCode;
    }


    /**
     * Gets the corpNum value for this SimpleTaxInvoice.
     * 
     * @return corpNum
     */
    public java.lang.String getCorpNum() {
        return corpNum;
    }


    /**
     * Sets the corpNum value for this SimpleTaxInvoice.
     * 
     * @param corpNum
     */
    public void setCorpNum(java.lang.String corpNum) {
        this.corpNum = corpNum;
    }


    /**
     * Gets the taxRegID value for this SimpleTaxInvoice.
     * 
     * @return taxRegID
     */
    public java.lang.String getTaxRegID() {
        return taxRegID;
    }


    /**
     * Sets the taxRegID value for this SimpleTaxInvoice.
     * 
     * @param taxRegID
     */
    public void setTaxRegID(java.lang.String taxRegID) {
        this.taxRegID = taxRegID;
    }


    /**
     * Gets the corpName value for this SimpleTaxInvoice.
     * 
     * @return corpName
     */
    public java.lang.String getCorpName() {
        return corpName;
    }


    /**
     * Sets the corpName value for this SimpleTaxInvoice.
     * 
     * @param corpName
     */
    public void setCorpName(java.lang.String corpName) {
        this.corpName = corpName;
    }


    /**
     * Gets the CEOName value for this SimpleTaxInvoice.
     * 
     * @return CEOName
     */
    public java.lang.String getCEOName() {
        return CEOName;
    }


    /**
     * Sets the CEOName value for this SimpleTaxInvoice.
     * 
     * @param CEOName
     */
    public void setCEOName(java.lang.String CEOName) {
        this.CEOName = CEOName;
    }


    /**
     * Gets the amountTotal value for this SimpleTaxInvoice.
     * 
     * @return amountTotal
     */
    public java.lang.String getAmountTotal() {
        return amountTotal;
    }


    /**
     * Sets the amountTotal value for this SimpleTaxInvoice.
     * 
     * @param amountTotal
     */
    public void setAmountTotal(java.lang.String amountTotal) {
        this.amountTotal = amountTotal;
    }


    /**
     * Gets the taxTotal value for this SimpleTaxInvoice.
     * 
     * @return taxTotal
     */
    public java.lang.String getTaxTotal() {
        return taxTotal;
    }


    /**
     * Sets the taxTotal value for this SimpleTaxInvoice.
     * 
     * @param taxTotal
     */
    public void setTaxTotal(java.lang.String taxTotal) {
        this.taxTotal = taxTotal;
    }


    /**
     * Gets the totalAmount value for this SimpleTaxInvoice.
     * 
     * @return totalAmount
     */
    public java.lang.String getTotalAmount() {
        return totalAmount;
    }


    /**
     * Sets the totalAmount value for this SimpleTaxInvoice.
     * 
     * @param totalAmount
     */
    public void setTotalAmount(java.lang.String totalAmount) {
        this.totalAmount = totalAmount;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SimpleTaxInvoice)) return false;
        SimpleTaxInvoice other = (SimpleTaxInvoice) obj;
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
            ((this.writeDate==null && other.getWriteDate()==null) || 
             (this.writeDate!=null &&
              this.writeDate.equals(other.getWriteDate()))) &&
            this.taxType == other.getTaxType() &&
            ((this.modifyCode==null && other.getModifyCode()==null) || 
             (this.modifyCode!=null &&
              this.modifyCode.equals(other.getModifyCode()))) &&
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
              this.CEOName.equals(other.getCEOName()))) &&
            ((this.amountTotal==null && other.getAmountTotal()==null) || 
             (this.amountTotal!=null &&
              this.amountTotal.equals(other.getAmountTotal()))) &&
            ((this.taxTotal==null && other.getTaxTotal()==null) || 
             (this.taxTotal!=null &&
              this.taxTotal.equals(other.getTaxTotal()))) &&
            ((this.totalAmount==null && other.getTotalAmount()==null) || 
             (this.totalAmount!=null &&
              this.totalAmount.equals(other.getTotalAmount())));
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
        if (getWriteDate() != null) {
            _hashCode += getWriteDate().hashCode();
        }
        _hashCode += getTaxType();
        if (getModifyCode() != null) {
            _hashCode += getModifyCode().hashCode();
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
        if (getAmountTotal() != null) {
            _hashCode += getAmountTotal().hashCode();
        }
        if (getTaxTotal() != null) {
            _hashCode += getTaxTotal().hashCode();
        }
        if (getTotalAmount() != null) {
            _hashCode += getTotalAmount().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(SimpleTaxInvoice.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SimpleTaxInvoice"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NTSSendKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSSendKey"));
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
        elemField.setFieldName("taxType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxType"));
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
