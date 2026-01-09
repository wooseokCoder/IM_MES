/**
 * AttachedFile.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class AttachedFile  implements java.io.Serializable {
    private int fileIndex;

    private java.lang.String fileName;

    private java.lang.String displayFileName;

    public AttachedFile() {
    }

    public AttachedFile(
           int fileIndex,
           java.lang.String fileName,
           java.lang.String displayFileName) {
           this.fileIndex = fileIndex;
           this.fileName = fileName;
           this.displayFileName = displayFileName;
    }


    /**
     * Gets the fileIndex value for this AttachedFile.
     * 
     * @return fileIndex
     */
    public int getFileIndex() {
        return fileIndex;
    }


    /**
     * Sets the fileIndex value for this AttachedFile.
     * 
     * @param fileIndex
     */
    public void setFileIndex(int fileIndex) {
        this.fileIndex = fileIndex;
    }


    /**
     * Gets the fileName value for this AttachedFile.
     * 
     * @return fileName
     */
    public java.lang.String getFileName() {
        return fileName;
    }


    /**
     * Sets the fileName value for this AttachedFile.
     * 
     * @param fileName
     */
    public void setFileName(java.lang.String fileName) {
        this.fileName = fileName;
    }


    /**
     * Gets the displayFileName value for this AttachedFile.
     * 
     * @return displayFileName
     */
    public java.lang.String getDisplayFileName() {
        return displayFileName;
    }


    /**
     * Sets the displayFileName value for this AttachedFile.
     * 
     * @param displayFileName
     */
    public void setDisplayFileName(java.lang.String displayFileName) {
        this.displayFileName = displayFileName;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AttachedFile)) return false;
        AttachedFile other = (AttachedFile) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.fileIndex == other.getFileIndex() &&
            ((this.fileName==null && other.getFileName()==null) || 
             (this.fileName!=null &&
              this.fileName.equals(other.getFileName()))) &&
            ((this.displayFileName==null && other.getDisplayFileName()==null) || 
             (this.displayFileName!=null &&
              this.displayFileName.equals(other.getDisplayFileName())));
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
        _hashCode += getFileIndex();
        if (getFileName() != null) {
            _hashCode += getFileName().hashCode();
        }
        if (getDisplayFileName() != null) {
            _hashCode += getDisplayFileName().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AttachedFile.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "AttachedFile"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fileIndex");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "FileIndex"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fileName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "FileName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("displayFileName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "DisplayFileName"));
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
