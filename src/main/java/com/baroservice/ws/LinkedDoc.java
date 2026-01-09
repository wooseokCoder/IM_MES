/**
 * LinkedDoc.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class LinkedDoc  implements java.io.Serializable {
    private int docType;

    private java.lang.String invoiceKey;

    private java.lang.String mgtKey;

    public LinkedDoc() {
    }

    public LinkedDoc(
           int docType,
           java.lang.String invoiceKey,
           java.lang.String mgtKey) {
           this.docType = docType;
           this.invoiceKey = invoiceKey;
           this.mgtKey = mgtKey;
    }


    /**
     * Gets the docType value for this LinkedDoc.
     * 
     * @return docType
     */
    public int getDocType() {
        return docType;
    }


    /**
     * Sets the docType value for this LinkedDoc.
     * 
     * @param docType
     */
    public void setDocType(int docType) {
        this.docType = docType;
    }


    /**
     * Gets the invoiceKey value for this LinkedDoc.
     * 
     * @return invoiceKey
     */
    public java.lang.String getInvoiceKey() {
        return invoiceKey;
    }


    /**
     * Sets the invoiceKey value for this LinkedDoc.
     * 
     * @param invoiceKey
     */
    public void setInvoiceKey(java.lang.String invoiceKey) {
        this.invoiceKey = invoiceKey;
    }


    /**
     * Gets the mgtKey value for this LinkedDoc.
     * 
     * @return mgtKey
     */
    public java.lang.String getMgtKey() {
        return mgtKey;
    }


    /**
     * Sets the mgtKey value for this LinkedDoc.
     * 
     * @param mgtKey
     */
    public void setMgtKey(java.lang.String mgtKey) {
        this.mgtKey = mgtKey;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof LinkedDoc)) return false;
        LinkedDoc other = (LinkedDoc) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.docType == other.getDocType() &&
            ((this.invoiceKey==null && other.getInvoiceKey()==null) || 
             (this.invoiceKey!=null &&
              this.invoiceKey.equals(other.getInvoiceKey()))) &&
            ((this.mgtKey==null && other.getMgtKey()==null) || 
             (this.mgtKey!=null &&
              this.mgtKey.equals(other.getMgtKey())));
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
        _hashCode += getDocType();
        if (getInvoiceKey() != null) {
            _hashCode += getInvoiceKey().hashCode();
        }
        if (getMgtKey() != null) {
            _hashCode += getMgtKey().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(LinkedDoc.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "LinkedDoc"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("docType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "DocType"));
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
        elemField.setFieldName("mgtKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "MgtKey"));
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
