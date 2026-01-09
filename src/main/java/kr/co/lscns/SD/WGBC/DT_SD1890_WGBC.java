/**
 * DT_SD1890_WGBC.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package kr.co.lscns.SD.WGBC;

public class DT_SD1890_WGBC  implements java.io.Serializable {
    private kr.co.lscns.SD.WGBC.DT_SD1890_WGBCPDI_MAST PDI_MAST;

    public DT_SD1890_WGBC() {
    }

    public DT_SD1890_WGBC(
           kr.co.lscns.SD.WGBC.DT_SD1890_WGBCPDI_MAST PDI_MAST) {
           this.PDI_MAST = PDI_MAST;
    }


    /**
     * Gets the PDI_MAST value for this DT_SD1890_WGBC.
     * 
     * @return PDI_MAST
     */
    public kr.co.lscns.SD.WGBC.DT_SD1890_WGBCPDI_MAST getPDI_MAST() {
        return PDI_MAST;
    }


    /**
     * Sets the PDI_MAST value for this DT_SD1890_WGBC.
     * 
     * @param PDI_MAST
     */
    public void setPDI_MAST(kr.co.lscns.SD.WGBC.DT_SD1890_WGBCPDI_MAST PDI_MAST) {
        this.PDI_MAST = PDI_MAST;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_SD1890_WGBC)) return false;
        DT_SD1890_WGBC other = (DT_SD1890_WGBC) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.PDI_MAST==null && other.getPDI_MAST()==null) || 
             (this.PDI_MAST!=null &&
              this.PDI_MAST.equals(other.getPDI_MAST())));
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
        if (getPDI_MAST() != null) {
            _hashCode += getPDI_MAST().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_SD1890_WGBC.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://lscns.co.kr/SD/WGBC", "DT_SD1890_WGBC"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PDI_MAST");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PDI_MAST"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://lscns.co.kr/SD/WGBC", ">DT_SD1890_WGBC>PDI_MAST"));
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
