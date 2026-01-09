/**
 * NTSSendOption.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class NTSSendOption  implements java.io.Serializable {
    private int taxationOption;

    private int taxationAddTaxAllowYN;

    private int taxExemptionOption;

    private int taxExemptionAddTaxAllowYN;

    public NTSSendOption() {
    }

    public NTSSendOption(
           int taxationOption,
           int taxationAddTaxAllowYN,
           int taxExemptionOption,
           int taxExemptionAddTaxAllowYN) {
           this.taxationOption = taxationOption;
           this.taxationAddTaxAllowYN = taxationAddTaxAllowYN;
           this.taxExemptionOption = taxExemptionOption;
           this.taxExemptionAddTaxAllowYN = taxExemptionAddTaxAllowYN;
    }


    /**
     * Gets the taxationOption value for this NTSSendOption.
     * 
     * @return taxationOption
     */
    public int getTaxationOption() {
        return taxationOption;
    }


    /**
     * Sets the taxationOption value for this NTSSendOption.
     * 
     * @param taxationOption
     */
    public void setTaxationOption(int taxationOption) {
        this.taxationOption = taxationOption;
    }


    /**
     * Gets the taxationAddTaxAllowYN value for this NTSSendOption.
     * 
     * @return taxationAddTaxAllowYN
     */
    public int getTaxationAddTaxAllowYN() {
        return taxationAddTaxAllowYN;
    }


    /**
     * Sets the taxationAddTaxAllowYN value for this NTSSendOption.
     * 
     * @param taxationAddTaxAllowYN
     */
    public void setTaxationAddTaxAllowYN(int taxationAddTaxAllowYN) {
        this.taxationAddTaxAllowYN = taxationAddTaxAllowYN;
    }


    /**
     * Gets the taxExemptionOption value for this NTSSendOption.
     * 
     * @return taxExemptionOption
     */
    public int getTaxExemptionOption() {
        return taxExemptionOption;
    }


    /**
     * Sets the taxExemptionOption value for this NTSSendOption.
     * 
     * @param taxExemptionOption
     */
    public void setTaxExemptionOption(int taxExemptionOption) {
        this.taxExemptionOption = taxExemptionOption;
    }


    /**
     * Gets the taxExemptionAddTaxAllowYN value for this NTSSendOption.
     * 
     * @return taxExemptionAddTaxAllowYN
     */
    public int getTaxExemptionAddTaxAllowYN() {
        return taxExemptionAddTaxAllowYN;
    }


    /**
     * Sets the taxExemptionAddTaxAllowYN value for this NTSSendOption.
     * 
     * @param taxExemptionAddTaxAllowYN
     */
    public void setTaxExemptionAddTaxAllowYN(int taxExemptionAddTaxAllowYN) {
        this.taxExemptionAddTaxAllowYN = taxExemptionAddTaxAllowYN;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof NTSSendOption)) return false;
        NTSSendOption other = (NTSSendOption) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.taxationOption == other.getTaxationOption() &&
            this.taxationAddTaxAllowYN == other.getTaxationAddTaxAllowYN() &&
            this.taxExemptionOption == other.getTaxExemptionOption() &&
            this.taxExemptionAddTaxAllowYN == other.getTaxExemptionAddTaxAllowYN();
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
        _hashCode += getTaxationOption();
        _hashCode += getTaxationAddTaxAllowYN();
        _hashCode += getTaxExemptionOption();
        _hashCode += getTaxExemptionAddTaxAllowYN();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(NTSSendOption.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "NTSSendOption"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxationOption");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxationOption"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxationAddTaxAllowYN");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxationAddTaxAllowYN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxExemptionOption");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxExemptionOption"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("taxExemptionAddTaxAllowYN");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxExemptionAddTaxAllowYN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
