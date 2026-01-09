/**
 * DT_SD1890_WGBC_response.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package kr.co.lscns.SD.WGBC;

public class DT_SD1890_WGBC_response  implements java.io.Serializable {
    private java.lang.String DELI_NO_SAP;

    private java.lang.String o_RESULT;

    private java.lang.String o_MESSAGE;

    public DT_SD1890_WGBC_response() {
    }

    public DT_SD1890_WGBC_response(
           java.lang.String DELI_NO_SAP,
           java.lang.String o_RESULT,
           java.lang.String o_MESSAGE) {
           this.DELI_NO_SAP = DELI_NO_SAP;
           this.o_RESULT = o_RESULT;
           this.o_MESSAGE = o_MESSAGE;
    }


    /**
     * Gets the DELI_NO_SAP value for this DT_SD1890_WGBC_response.
     * 
     * @return DELI_NO_SAP
     */
    public java.lang.String getDELI_NO_SAP() {
        return DELI_NO_SAP;
    }


    /**
     * Sets the DELI_NO_SAP value for this DT_SD1890_WGBC_response.
     * 
     * @param DELI_NO_SAP
     */
    public void setDELI_NO_SAP(java.lang.String DELI_NO_SAP) {
        this.DELI_NO_SAP = DELI_NO_SAP;
    }


    /**
     * Gets the o_RESULT value for this DT_SD1890_WGBC_response.
     * 
     * @return o_RESULT
     */
    public java.lang.String getO_RESULT() {
        return o_RESULT;
    }


    /**
     * Sets the o_RESULT value for this DT_SD1890_WGBC_response.
     * 
     * @param o_RESULT
     */
    public void setO_RESULT(java.lang.String o_RESULT) {
        this.o_RESULT = o_RESULT;
    }


    /**
     * Gets the o_MESSAGE value for this DT_SD1890_WGBC_response.
     * 
     * @return o_MESSAGE
     */
    public java.lang.String getO_MESSAGE() {
        return o_MESSAGE;
    }


    /**
     * Sets the o_MESSAGE value for this DT_SD1890_WGBC_response.
     * 
     * @param o_MESSAGE
     */
    public void setO_MESSAGE(java.lang.String o_MESSAGE) {
        this.o_MESSAGE = o_MESSAGE;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_SD1890_WGBC_response)) return false;
        DT_SD1890_WGBC_response other = (DT_SD1890_WGBC_response) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.DELI_NO_SAP==null && other.getDELI_NO_SAP()==null) || 
             (this.DELI_NO_SAP!=null &&
              this.DELI_NO_SAP.equals(other.getDELI_NO_SAP()))) &&
            ((this.o_RESULT==null && other.getO_RESULT()==null) || 
             (this.o_RESULT!=null &&
              this.o_RESULT.equals(other.getO_RESULT()))) &&
            ((this.o_MESSAGE==null && other.getO_MESSAGE()==null) || 
             (this.o_MESSAGE!=null &&
              this.o_MESSAGE.equals(other.getO_MESSAGE())));
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
        if (getDELI_NO_SAP() != null) {
            _hashCode += getDELI_NO_SAP().hashCode();
        }
        if (getO_RESULT() != null) {
            _hashCode += getO_RESULT().hashCode();
        }
        if (getO_MESSAGE() != null) {
            _hashCode += getO_MESSAGE().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_SD1890_WGBC_response.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://lscns.co.kr/SD/WGBC", "DT_SD1890_WGBC_response"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DELI_NO_SAP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DELI_NO_SAP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("o_RESULT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "O_RESULT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("o_MESSAGE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "O_MESSAGE"));
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
