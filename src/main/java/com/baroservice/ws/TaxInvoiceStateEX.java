/**
 * TaxInvoiceStateEX.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class TaxInvoiceStateEX  implements java.io.Serializable {
    private java.lang.String mgtKey;

    private java.lang.String invoiceKey;

    private int barobillState;

    private int isOpened;

    private int isConfirmed;

    private java.lang.String registDT;

    private java.lang.String writeDate;

    private java.lang.String preIssueDT;

    private java.lang.String issueDT;

    private java.lang.String remark1;

    private java.lang.String remark2;

    private int NTSSendState;

    private java.lang.String NTSSendKey;

    private java.lang.String NTSSendResult;

    private java.lang.String NTSSendDT;

    private java.lang.String NTSResultDT;

    public TaxInvoiceStateEX() {
    }

    public TaxInvoiceStateEX(
           java.lang.String mgtKey,
           java.lang.String invoiceKey,
           int barobillState,
           int isOpened,
           int isConfirmed,
           java.lang.String registDT,
           java.lang.String writeDate,
           java.lang.String preIssueDT,
           java.lang.String issueDT,
           java.lang.String remark1,
           java.lang.String remark2,
           int NTSSendState,
           java.lang.String NTSSendKey,
           java.lang.String NTSSendResult,
           java.lang.String NTSSendDT,
           java.lang.String NTSResultDT) {
           this.mgtKey = mgtKey;
           this.invoiceKey = invoiceKey;
           this.barobillState = barobillState;
           this.isOpened = isOpened;
           this.isConfirmed = isConfirmed;
           this.registDT = registDT;
           this.writeDate = writeDate;
           this.preIssueDT = preIssueDT;
           this.issueDT = issueDT;
           this.remark1 = remark1;
           this.remark2 = remark2;
           this.NTSSendState = NTSSendState;
           this.NTSSendKey = NTSSendKey;
           this.NTSSendResult = NTSSendResult;
           this.NTSSendDT = NTSSendDT;
           this.NTSResultDT = NTSResultDT;
    }


    /**
     * Gets the mgtKey value for this TaxInvoiceStateEX.
     * 
     * @return mgtKey
     */
    public java.lang.String getMgtKey() {
        return mgtKey;
    }


    /**
     * Sets the mgtKey value for this TaxInvoiceStateEX.
     * 
     * @param mgtKey
     */
    public void setMgtKey(java.lang.String mgtKey) {
        this.mgtKey = mgtKey;
    }


    /**
     * Gets the invoiceKey value for this TaxInvoiceStateEX.
     * 
     * @return invoiceKey
     */
    public java.lang.String getInvoiceKey() {
        return invoiceKey;
    }


    /**
     * Sets the invoiceKey value for this TaxInvoiceStateEX.
     * 
     * @param invoiceKey
     */
    public void setInvoiceKey(java.lang.String invoiceKey) {
        this.invoiceKey = invoiceKey;
    }


    /**
     * Gets the barobillState value for this TaxInvoiceStateEX.
     * 
     * @return barobillState
     */
    public int getBarobillState() {
        return barobillState;
    }


    /**
     * Sets the barobillState value for this TaxInvoiceStateEX.
     * 
     * @param barobillState
     */
    public void setBarobillState(int barobillState) {
        this.barobillState = barobillState;
    }


    /**
     * Gets the isOpened value for this TaxInvoiceStateEX.
     * 
     * @return isOpened
     */
    public int getIsOpened() {
        return isOpened;
    }


    /**
     * Sets the isOpened value for this TaxInvoiceStateEX.
     * 
     * @param isOpened
     */
    public void setIsOpened(int isOpened) {
        this.isOpened = isOpened;
    }


    /**
     * Gets the isConfirmed value for this TaxInvoiceStateEX.
     * 
     * @return isConfirmed
     */
    public int getIsConfirmed() {
        return isConfirmed;
    }


    /**
     * Sets the isConfirmed value for this TaxInvoiceStateEX.
     * 
     * @param isConfirmed
     */
    public void setIsConfirmed(int isConfirmed) {
        this.isConfirmed = isConfirmed;
    }


    /**
     * Gets the registDT value for this TaxInvoiceStateEX.
     * 
     * @return registDT
     */
    public java.lang.String getRegistDT() {
        return registDT;
    }


    /**
     * Sets the registDT value for this TaxInvoiceStateEX.
     * 
     * @param registDT
     */
    public void setRegistDT(java.lang.String registDT) {
        this.registDT = registDT;
    }


    /**
     * Gets the writeDate value for this TaxInvoiceStateEX.
     * 
     * @return writeDate
     */
    public java.lang.String getWriteDate() {
        return writeDate;
    }


    /**
     * Sets the writeDate value for this TaxInvoiceStateEX.
     * 
     * @param writeDate
     */
    public void setWriteDate(java.lang.String writeDate) {
        this.writeDate = writeDate;
    }


    /**
     * Gets the preIssueDT value for this TaxInvoiceStateEX.
     * 
     * @return preIssueDT
     */
    public java.lang.String getPreIssueDT() {
        return preIssueDT;
    }


    /**
     * Sets the preIssueDT value for this TaxInvoiceStateEX.
     * 
     * @param preIssueDT
     */
    public void setPreIssueDT(java.lang.String preIssueDT) {
        this.preIssueDT = preIssueDT;
    }


    /**
     * Gets the issueDT value for this TaxInvoiceStateEX.
     * 
     * @return issueDT
     */
    public java.lang.String getIssueDT() {
        return issueDT;
    }


    /**
     * Sets the issueDT value for this TaxInvoiceStateEX.
     * 
     * @param issueDT
     */
    public void setIssueDT(java.lang.String issueDT) {
        this.issueDT = issueDT;
    }


    /**
     * Gets the remark1 value for this TaxInvoiceStateEX.
     * 
     * @return remark1
     */
    public java.lang.String getRemark1() {
        return remark1;
    }


    /**
     * Sets the remark1 value for this TaxInvoiceStateEX.
     * 
     * @param remark1
     */
    public void setRemark1(java.lang.String remark1) {
        this.remark1 = remark1;
    }


    /**
     * Gets the remark2 value for this TaxInvoiceStateEX.
     * 
     * @return remark2
     */
    public java.lang.String getRemark2() {
        return remark2;
    }


    /**
     * Sets the remark2 value for this TaxInvoiceStateEX.
     * 
     * @param remark2
     */
    public void setRemark2(java.lang.String remark2) {
        this.remark2 = remark2;
    }


    /**
     * Gets the NTSSendState value for this TaxInvoiceStateEX.
     * 
     * @return NTSSendState
     */
    public int getNTSSendState() {
        return NTSSendState;
    }


    /**
     * Sets the NTSSendState value for this TaxInvoiceStateEX.
     * 
     * @param NTSSendState
     */
    public void setNTSSendState(int NTSSendState) {
        this.NTSSendState = NTSSendState;
    }


    /**
     * Gets the NTSSendKey value for this TaxInvoiceStateEX.
     * 
     * @return NTSSendKey
     */
    public java.lang.String getNTSSendKey() {
        return NTSSendKey;
    }


    /**
     * Sets the NTSSendKey value for this TaxInvoiceStateEX.
     * 
     * @param NTSSendKey
     */
    public void setNTSSendKey(java.lang.String NTSSendKey) {
        this.NTSSendKey = NTSSendKey;
    }


    /**
     * Gets the NTSSendResult value for this TaxInvoiceStateEX.
     * 
     * @return NTSSendResult
     */
    public java.lang.String getNTSSendResult() {
        return NTSSendResult;
    }


    /**
     * Sets the NTSSendResult value for this TaxInvoiceStateEX.
     * 
     * @param NTSSendResult
     */
    public void setNTSSendResult(java.lang.String NTSSendResult) {
        this.NTSSendResult = NTSSendResult;
    }


    /**
     * Gets the NTSSendDT value for this TaxInvoiceStateEX.
     * 
     * @return NTSSendDT
     */
    public java.lang.String getNTSSendDT() {
        return NTSSendDT;
    }


    /**
     * Sets the NTSSendDT value for this TaxInvoiceStateEX.
     * 
     * @param NTSSendDT
     */
    public void setNTSSendDT(java.lang.String NTSSendDT) {
        this.NTSSendDT = NTSSendDT;
    }


    /**
     * Gets the NTSResultDT value for this TaxInvoiceStateEX.
     * 
     * @return NTSResultDT
     */
    public java.lang.String getNTSResultDT() {
        return NTSResultDT;
    }


    /**
     * Sets the NTSResultDT value for this TaxInvoiceStateEX.
     * 
     * @param NTSResultDT
     */
    public void setNTSResultDT(java.lang.String NTSResultDT) {
        this.NTSResultDT = NTSResultDT;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof TaxInvoiceStateEX)) return false;
        TaxInvoiceStateEX other = (TaxInvoiceStateEX) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.mgtKey==null && other.getMgtKey()==null) || 
             (this.mgtKey!=null &&
              this.mgtKey.equals(other.getMgtKey()))) &&
            ((this.invoiceKey==null && other.getInvoiceKey()==null) || 
             (this.invoiceKey!=null &&
              this.invoiceKey.equals(other.getInvoiceKey()))) &&
            this.barobillState == other.getBarobillState() &&
            this.isOpened == other.getIsOpened() &&
            this.isConfirmed == other.getIsConfirmed() &&
            ((this.registDT==null && other.getRegistDT()==null) || 
             (this.registDT!=null &&
              this.registDT.equals(other.getRegistDT()))) &&
            ((this.writeDate==null && other.getWriteDate()==null) || 
             (this.writeDate!=null &&
              this.writeDate.equals(other.getWriteDate()))) &&
            ((this.preIssueDT==null && other.getPreIssueDT()==null) || 
             (this.preIssueDT!=null &&
              this.preIssueDT.equals(other.getPreIssueDT()))) &&
            ((this.issueDT==null && other.getIssueDT()==null) || 
             (this.issueDT!=null &&
              this.issueDT.equals(other.getIssueDT()))) &&
            ((this.remark1==null && other.getRemark1()==null) || 
             (this.remark1!=null &&
              this.remark1.equals(other.getRemark1()))) &&
            ((this.remark2==null && other.getRemark2()==null) || 
             (this.remark2!=null &&
              this.remark2.equals(other.getRemark2()))) &&
            this.NTSSendState == other.getNTSSendState() &&
            ((this.NTSSendKey==null && other.getNTSSendKey()==null) || 
             (this.NTSSendKey!=null &&
              this.NTSSendKey.equals(other.getNTSSendKey()))) &&
            ((this.NTSSendResult==null && other.getNTSSendResult()==null) || 
             (this.NTSSendResult!=null &&
              this.NTSSendResult.equals(other.getNTSSendResult()))) &&
            ((this.NTSSendDT==null && other.getNTSSendDT()==null) || 
             (this.NTSSendDT!=null &&
              this.NTSSendDT.equals(other.getNTSSendDT()))) &&
            ((this.NTSResultDT==null && other.getNTSResultDT()==null) || 
             (this.NTSResultDT!=null &&
              this.NTSResultDT.equals(other.getNTSResultDT())));
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
        if (getMgtKey() != null) {
            _hashCode += getMgtKey().hashCode();
        }
        if (getInvoiceKey() != null) {
            _hashCode += getInvoiceKey().hashCode();
        }
        _hashCode += getBarobillState();
        _hashCode += getIsOpened();
        _hashCode += getIsConfirmed();
        if (getRegistDT() != null) {
            _hashCode += getRegistDT().hashCode();
        }
        if (getWriteDate() != null) {
            _hashCode += getWriteDate().hashCode();
        }
        if (getPreIssueDT() != null) {
            _hashCode += getPreIssueDT().hashCode();
        }
        if (getIssueDT() != null) {
            _hashCode += getIssueDT().hashCode();
        }
        if (getRemark1() != null) {
            _hashCode += getRemark1().hashCode();
        }
        if (getRemark2() != null) {
            _hashCode += getRemark2().hashCode();
        }
        _hashCode += getNTSSendState();
        if (getNTSSendKey() != null) {
            _hashCode += getNTSSendKey().hashCode();
        }
        if (getNTSSendResult() != null) {
            _hashCode += getNTSSendResult().hashCode();
        }
        if (getNTSSendDT() != null) {
            _hashCode += getNTSSendDT().hashCode();
        }
        if (getNTSResultDT() != null) {
            _hashCode += getNTSResultDT().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(TaxInvoiceStateEX.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoiceStateEX"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("mgtKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "MgtKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("invoiceKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("barobillState");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BarobillState"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("isOpened");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "IsOpened"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("isConfirmed");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "IsConfirmed"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("registDT");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "RegistDT"));
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
        elemField.setFieldName("preIssueDT");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "PreIssueDT"));
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
        elemField.setFieldName("NTSSendState");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSSendState"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NTSSendKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSSendKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NTSSendResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSSendResult"));
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
        elemField.setFieldName("NTSResultDT");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSResultDT"));
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
