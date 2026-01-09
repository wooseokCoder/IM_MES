/**
 * PagedTaxInvoiceEx.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class PagedTaxInvoiceEx  implements java.io.Serializable {
    private int currentPage;

    private int maxIndex;

    private int countPerPage;

    private int maxPageNum;

    private com.baroservice.ws.SimpleTaxInvoiceEx[] simpleTaxInvoiceExList;

    public PagedTaxInvoiceEx() {
    }

    public PagedTaxInvoiceEx(
           int currentPage,
           int maxIndex,
           int countPerPage,
           int maxPageNum,
           com.baroservice.ws.SimpleTaxInvoiceEx[] simpleTaxInvoiceExList) {
           this.currentPage = currentPage;
           this.maxIndex = maxIndex;
           this.countPerPage = countPerPage;
           this.maxPageNum = maxPageNum;
           this.simpleTaxInvoiceExList = simpleTaxInvoiceExList;
    }


    /**
     * Gets the currentPage value for this PagedTaxInvoiceEx.
     * 
     * @return currentPage
     */
    public int getCurrentPage() {
        return currentPage;
    }


    /**
     * Sets the currentPage value for this PagedTaxInvoiceEx.
     * 
     * @param currentPage
     */
    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }


    /**
     * Gets the maxIndex value for this PagedTaxInvoiceEx.
     * 
     * @return maxIndex
     */
    public int getMaxIndex() {
        return maxIndex;
    }


    /**
     * Sets the maxIndex value for this PagedTaxInvoiceEx.
     * 
     * @param maxIndex
     */
    public void setMaxIndex(int maxIndex) {
        this.maxIndex = maxIndex;
    }


    /**
     * Gets the countPerPage value for this PagedTaxInvoiceEx.
     * 
     * @return countPerPage
     */
    public int getCountPerPage() {
        return countPerPage;
    }


    /**
     * Sets the countPerPage value for this PagedTaxInvoiceEx.
     * 
     * @param countPerPage
     */
    public void setCountPerPage(int countPerPage) {
        this.countPerPage = countPerPage;
    }


    /**
     * Gets the maxPageNum value for this PagedTaxInvoiceEx.
     * 
     * @return maxPageNum
     */
    public int getMaxPageNum() {
        return maxPageNum;
    }


    /**
     * Sets the maxPageNum value for this PagedTaxInvoiceEx.
     * 
     * @param maxPageNum
     */
    public void setMaxPageNum(int maxPageNum) {
        this.maxPageNum = maxPageNum;
    }


    /**
     * Gets the simpleTaxInvoiceExList value for this PagedTaxInvoiceEx.
     * 
     * @return simpleTaxInvoiceExList
     */
    public com.baroservice.ws.SimpleTaxInvoiceEx[] getSimpleTaxInvoiceExList() {
        return simpleTaxInvoiceExList;
    }


    /**
     * Sets the simpleTaxInvoiceExList value for this PagedTaxInvoiceEx.
     * 
     * @param simpleTaxInvoiceExList
     */
    public void setSimpleTaxInvoiceExList(com.baroservice.ws.SimpleTaxInvoiceEx[] simpleTaxInvoiceExList) {
        this.simpleTaxInvoiceExList = simpleTaxInvoiceExList;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof PagedTaxInvoiceEx)) return false;
        PagedTaxInvoiceEx other = (PagedTaxInvoiceEx) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.currentPage == other.getCurrentPage() &&
            this.maxIndex == other.getMaxIndex() &&
            this.countPerPage == other.getCountPerPage() &&
            this.maxPageNum == other.getMaxPageNum() &&
            ((this.simpleTaxInvoiceExList==null && other.getSimpleTaxInvoiceExList()==null) || 
             (this.simpleTaxInvoiceExList!=null &&
              java.util.Arrays.equals(this.simpleTaxInvoiceExList, other.getSimpleTaxInvoiceExList())));
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
        _hashCode += getCurrentPage();
        _hashCode += getMaxIndex();
        _hashCode += getCountPerPage();
        _hashCode += getMaxPageNum();
        if (getSimpleTaxInvoiceExList() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getSimpleTaxInvoiceExList());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getSimpleTaxInvoiceExList(), i);
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
        new org.apache.axis.description.TypeDesc(PagedTaxInvoiceEx.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "PagedTaxInvoiceEx"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("currentPage");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "CurrentPage"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxIndex");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "MaxIndex"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("countPerPage");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "CountPerPage"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxPageNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "MaxPageNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("simpleTaxInvoiceExList");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SimpleTaxInvoiceExList"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SimpleTaxInvoiceEx"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setItemQName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SimpleTaxInvoiceEx"));
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
