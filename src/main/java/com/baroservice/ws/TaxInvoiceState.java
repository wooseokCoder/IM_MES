/**
 * TaxInvoiceState.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class TaxInvoiceState  implements java.io.Serializable {
    private java.lang.String mgtKey;

    private java.lang.String remark1;

    private java.lang.String remark2;

    private int barobillState;

    private java.lang.String invoiceKey;

    private int isOpened;

    private int NTSSendState;

    private java.lang.String NTSSendKey;

    private java.lang.String NTSSendResult;

    private java.lang.String NTSSendDT;

    private java.lang.String NTSResultDT;

    public TaxInvoiceState() {
    }

    public TaxInvoiceState(
           java.lang.String mgtKey,
           java.lang.String remark1,
           java.lang.String remark2,
           int barobillState,
           java.lang.String invoiceKey,
           int isOpened,
           int NTSSendState,
           java.lang.String NTSSendKey,
           java.lang.String NTSSendResult,
           java.lang.String NTSSendDT,
           java.lang.String NTSResultDT) {
           this.mgtKey = mgtKey;
           this.remark1 = remark1;
           this.remark2 = remark2;
           this.barobillState = barobillState;
           this.invoiceKey = invoiceKey;
           this.isOpened = isOpened;
           this.NTSSendState = NTSSendState;
           this.NTSSendKey = NTSSendKey;
           this.NTSSendResult = NTSSendResult;
           this.NTSSendDT = NTSSendDT;
           this.NTSResultDT = NTSResultDT;
    }


    /**
     * Gets the mgtKey value for this TaxInvoiceState.
     * 
     * @return mgtKey
     */
    public java.lang.String getMgtKey() {
        return mgtKey;
    }


    /**
     * Sets the mgtKey value for this TaxInvoiceState.
     * 
     * @param mgtKey
     */
    public void setMgtKey(java.lang.String mgtKey) {
        this.mgtKey = mgtKey;
    }


    /**
     * Gets the remark1 value for this TaxInvoiceState.
     * 
     * @return remark1
     */
    public java.lang.String getRemark1() {
        return remark1;
    }


    /**
     * Sets the remark1 value for this TaxInvoiceState.
     * 
     * @param remark1
     */
    public void setRemark1(java.lang.String remark1) {
        this.remark1 = remark1;
    }


    /**
     * Gets the remark2 value for this TaxInvoiceState.
     * 
     * @return remark2
     */
    public java.lang.String getRemark2() {
        return remark2;
    }


    /**
     * Sets the remark2 value for this TaxInvoiceState.
     * 
     * @param remark2
     */
    public void setRemark2(java.lang.String remark2) {
        this.remark2 = remark2;
    }


    /**
     * Gets the barobillState value for this TaxInvoiceState.
     * 
     * @return barobillState
     */
    public int getBarobillState() {
        return barobillState;
    }


    /**
     * Sets the barobillState value for this TaxInvoiceState.
     * 
     * @param barobillState
     */
    public void setBarobillState(int barobillState) {
        this.barobillState = barobillState;
    }


    /**
     * Gets the invoiceKey value for this TaxInvoiceState.
     * 
     * @return invoiceKey
     */
    public java.lang.String getInvoiceKey() {
        return invoiceKey;
    }


    /**
     * Sets the invoiceKey value for this TaxInvoiceState.
     * 
     * @param invoiceKey
     */
    public void setInvoiceKey(java.lang.String invoiceKey) {
        this.invoiceKey = invoiceKey;
    }


    /**
     * Gets the isOpened value for this TaxInvoiceState.
     * 
     * @return isOpened
     */
    public int getIsOpened() {
        return isOpened;
    }


    /**
     * Sets the isOpened value for this TaxInvoiceState.
     * 
     * @param isOpened
     */
    public void setIsOpened(int isOpened) {
        this.isOpened = isOpened;
    }


    /**
     * Gets the NTSSendState value for this TaxInvoiceState.
     * 
     * @return NTSSendState
     */
    public int getNTSSendState() {
        return NTSSendState;
    }


    /**
     * Sets the NTSSendState value for this TaxInvoiceState.
     * 
     * @param NTSSendState
     */
    public void setNTSSendState(int NTSSendState) {
        this.NTSSendState = NTSSendState;
    }


    /**
     * Gets the NTSSendKey value for this TaxInvoiceState.
     * 
     * @return NTSSendKey
     */
    public java.lang.String getNTSSendKey() {
        return NTSSendKey;
    }


    /**
     * Sets the NTSSendKey value for this TaxInvoiceState.
     * 
     * @param NTSSendKey
     */
    public void setNTSSendKey(java.lang.String NTSSendKey) {
        this.NTSSendKey = NTSSendKey;
    }


    /**
     * Gets the NTSSendResult value for this TaxInvoiceState.
     * 
     * @return NTSSendResult
     */
    public java.lang.String getNTSSendResult() {
        return NTSSendResult;
    }


    /**
     * Sets the NTSSendResult value for this TaxInvoiceState.
     * 
     * @param NTSSendResult
     */
    public void setNTSSendResult(java.lang.String NTSSendResult) {
        this.NTSSendResult = NTSSendResult;
    }


    /**
     * Gets the NTSSendDT value for this TaxInvoiceState.
     * 
     * @return NTSSendDT
     */
    public java.lang.String getNTSSendDT() {
        return NTSSendDT;
    }


    /**
     * Sets the NTSSendDT value for this TaxInvoiceState.
     * 
     * @param NTSSendDT
     */
    public void setNTSSendDT(java.lang.String NTSSendDT) {
        this.NTSSendDT = NTSSendDT;
    }


    /**
     * Gets the NTSResultDT value for this TaxInvoiceState.
     * 
     * @return NTSResultDT
     */
    public java.lang.String getNTSResultDT() {
        return NTSResultDT;
    }


    /**
     * Sets the NTSResultDT value for this TaxInvoiceState.
     * 
     * @param NTSResultDT
     */
    public void setNTSResultDT(java.lang.String NTSResultDT) {
        this.NTSResultDT = NTSResultDT;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof TaxInvoiceState)) return false;
        TaxInvoiceState other = (TaxInvoiceState) obj;
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
            ((this.remark1==null && other.getRemark1()==null) || 
             (this.remark1!=null &&
              this.remark1.equals(other.getRemark1()))) &&
            ((this.remark2==null && other.getRemark2()==null) || 
             (this.remark2!=null &&
              this.remark2.equals(other.getRemark2()))) &&
            this.barobillState == other.getBarobillState() &&
            ((this.invoiceKey==null && other.getInvoiceKey()==null) || 
             (this.invoiceKey!=null &&
              this.invoiceKey.equals(other.getInvoiceKey()))) &&
            this.isOpened == other.getIsOpened() &&
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
        if (getRemark1() != null) {
            _hashCode += getRemark1().hashCode();
        }
        if (getRemark2() != null) {
            _hashCode += getRemark2().hashCode();
        }
        _hashCode += getBarobillState();
        if (getInvoiceKey() != null) {
            _hashCode += getInvoiceKey().hashCode();
        }
        _hashCode += getIsOpened();
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
        new org.apache.axis.description.TypeDesc(TaxInvoiceState.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoiceState"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("mgtKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "MgtKey"));
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
        elemField.setFieldName("barobillState");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "BarobillState"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
        elemField.setFieldName("isOpened");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "IsOpened"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
