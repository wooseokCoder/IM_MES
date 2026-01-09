/**
 * DT_SD0980_WPCS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package kr.co.lscns.SD.WPCS;

public class DT_SD0980_WPCS  implements java.io.Serializable {
    private java.lang.String SITECD;

    private java.lang.String FROM_DATE;

    private java.lang.String TO_DATE;

    private java.lang.String WPC_PO_NO;

    private java.lang.String MATNR;

    public DT_SD0980_WPCS() {
    }

    public DT_SD0980_WPCS(
           java.lang.String SITECD,
           java.lang.String FROM_DATE,
           java.lang.String TO_DATE,
           java.lang.String WPC_PO_NO,
           java.lang.String MATNR) {
           this.SITECD = SITECD;
           this.FROM_DATE = FROM_DATE;
           this.TO_DATE = TO_DATE;
           this.WPC_PO_NO = WPC_PO_NO;
           this.MATNR = MATNR;
    }


    /**
     * Gets the SITECD value for this DT_SD0980_WPCS.
     * 
     * @return SITECD
     */
    public java.lang.String getSITECD() {
        return SITECD;
    }


    /**
     * Sets the SITECD value for this DT_SD0980_WPCS.
     * 
     * @param SITECD
     */
    public void setSITECD(java.lang.String SITECD) {
        this.SITECD = SITECD;
    }


    /**
     * Gets the FROM_DATE value for this DT_SD0980_WPCS.
     * 
     * @return FROM_DATE
     */
    public java.lang.String getFROM_DATE() {
        return FROM_DATE;
    }


    /**
     * Sets the FROM_DATE value for this DT_SD0980_WPCS.
     * 
     * @param FROM_DATE
     */
    public void setFROM_DATE(java.lang.String FROM_DATE) {
        this.FROM_DATE = FROM_DATE;
    }


    /**
     * Gets the TO_DATE value for this DT_SD0980_WPCS.
     * 
     * @return TO_DATE
     */
    public java.lang.String getTO_DATE() {
        return TO_DATE;
    }


    /**
     * Sets the TO_DATE value for this DT_SD0980_WPCS.
     * 
     * @param TO_DATE
     */
    public void setTO_DATE(java.lang.String TO_DATE) {
        this.TO_DATE = TO_DATE;
    }


    /**
     * Gets the WPC_PO_NO value for this DT_SD0980_WPCS.
     * 
     * @return WPC_PO_NO
     */
    public java.lang.String getWPC_PO_NO() {
        return WPC_PO_NO;
    }


    /**
     * Sets the WPC_PO_NO value for this DT_SD0980_WPCS.
     * 
     * @param WPC_PO_NO
     */
    public void setWPC_PO_NO(java.lang.String WPC_PO_NO) {
        this.WPC_PO_NO = WPC_PO_NO;
    }


    /**
     * Gets the MATNR value for this DT_SD0980_WPCS.
     * 
     * @return MATNR
     */
    public java.lang.String getMATNR() {
        return MATNR;
    }


    /**
     * Sets the MATNR value for this DT_SD0980_WPCS.
     * 
     * @param MATNR
     */
    public void setMATNR(java.lang.String MATNR) {
        this.MATNR = MATNR;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_SD0980_WPCS)) return false;
        DT_SD0980_WPCS other = (DT_SD0980_WPCS) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.SITECD==null && other.getSITECD()==null) || 
             (this.SITECD!=null &&
              this.SITECD.equals(other.getSITECD()))) &&
            ((this.FROM_DATE==null && other.getFROM_DATE()==null) || 
             (this.FROM_DATE!=null &&
              this.FROM_DATE.equals(other.getFROM_DATE()))) &&
            ((this.TO_DATE==null && other.getTO_DATE()==null) || 
             (this.TO_DATE!=null &&
              this.TO_DATE.equals(other.getTO_DATE()))) &&
            ((this.WPC_PO_NO==null && other.getWPC_PO_NO()==null) || 
             (this.WPC_PO_NO!=null &&
              this.WPC_PO_NO.equals(other.getWPC_PO_NO()))) &&
            ((this.MATNR==null && other.getMATNR()==null) || 
             (this.MATNR!=null &&
              this.MATNR.equals(other.getMATNR())));
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
        if (getSITECD() != null) {
            _hashCode += getSITECD().hashCode();
        }
        if (getFROM_DATE() != null) {
            _hashCode += getFROM_DATE().hashCode();
        }
        if (getTO_DATE() != null) {
            _hashCode += getTO_DATE().hashCode();
        }
        if (getWPC_PO_NO() != null) {
            _hashCode += getWPC_PO_NO().hashCode();
        }
        if (getMATNR() != null) {
            _hashCode += getMATNR().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_SD0980_WPCS.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://lscns.co.kr/SD/WPCS", "DT_SD0980_WPCS"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SITECD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SITECD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("FROM_DATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "FROM_DATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("TO_DATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "TO_DATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WPC_PO_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "WPC_PO_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MATNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MATNR"));
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
