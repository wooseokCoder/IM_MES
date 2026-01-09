/**
 * EMAILPUBLICKEY.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class EMAILPUBLICKEY  implements java.io.Serializable {
    private java.lang.String PK;

    private java.lang.String email;

    private java.lang.String NTSCertNum;

    public EMAILPUBLICKEY() {
    }

    public EMAILPUBLICKEY(
           java.lang.String PK,
           java.lang.String email,
           java.lang.String NTSCertNum) {
           this.PK = PK;
           this.email = email;
           this.NTSCertNum = NTSCertNum;
    }


    /**
     * Gets the PK value for this EMAILPUBLICKEY.
     * 
     * @return PK
     */
    public java.lang.String getPK() {
        return PK;
    }


    /**
     * Sets the PK value for this EMAILPUBLICKEY.
     * 
     * @param PK
     */
    public void setPK(java.lang.String PK) {
        this.PK = PK;
    }


    /**
     * Gets the email value for this EMAILPUBLICKEY.
     * 
     * @return email
     */
    public java.lang.String getEmail() {
        return email;
    }


    /**
     * Sets the email value for this EMAILPUBLICKEY.
     * 
     * @param email
     */
    public void setEmail(java.lang.String email) {
        this.email = email;
    }


    /**
     * Gets the NTSCertNum value for this EMAILPUBLICKEY.
     * 
     * @return NTSCertNum
     */
    public java.lang.String getNTSCertNum() {
        return NTSCertNum;
    }


    /**
     * Sets the NTSCertNum value for this EMAILPUBLICKEY.
     * 
     * @param NTSCertNum
     */
    public void setNTSCertNum(java.lang.String NTSCertNum) {
        this.NTSCertNum = NTSCertNum;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof EMAILPUBLICKEY)) return false;
        EMAILPUBLICKEY other = (EMAILPUBLICKEY) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.PK==null && other.getPK()==null) || 
             (this.PK!=null &&
              this.PK.equals(other.getPK()))) &&
            ((this.email==null && other.getEmail()==null) || 
             (this.email!=null &&
              this.email.equals(other.getEmail()))) &&
            ((this.NTSCertNum==null && other.getNTSCertNum()==null) || 
             (this.NTSCertNum!=null &&
              this.NTSCertNum.equals(other.getNTSCertNum())));
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
        if (getPK() != null) {
            _hashCode += getPK().hashCode();
        }
        if (getEmail() != null) {
            _hashCode += getEmail().hashCode();
        }
        if (getNTSCertNum() != null) {
            _hashCode += getNTSCertNum().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(EMAILPUBLICKEY.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "EMAILPUBLICKEY"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PK");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "PK"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("email");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Email"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NTSCertNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSCertNum"));
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
