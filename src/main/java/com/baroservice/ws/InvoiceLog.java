/**
 * InvoiceLog.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class InvoiceLog  implements java.io.Serializable {
    private int seq;

    private java.lang.String logType;

    private java.lang.String procCorpName;

    private java.lang.String procContactName;

    private java.lang.String logDateTime;

    private java.lang.String memo;

    public InvoiceLog() {
    }

    public InvoiceLog(
           int seq,
           java.lang.String logType,
           java.lang.String procCorpName,
           java.lang.String procContactName,
           java.lang.String logDateTime,
           java.lang.String memo) {
           this.seq = seq;
           this.logType = logType;
           this.procCorpName = procCorpName;
           this.procContactName = procContactName;
           this.logDateTime = logDateTime;
           this.memo = memo;
    }


    /**
     * Gets the seq value for this InvoiceLog.
     * 
     * @return seq
     */
    public int getSeq() {
        return seq;
    }


    /**
     * Sets the seq value for this InvoiceLog.
     * 
     * @param seq
     */
    public void setSeq(int seq) {
        this.seq = seq;
    }


    /**
     * Gets the logType value for this InvoiceLog.
     * 
     * @return logType
     */
    public java.lang.String getLogType() {
        return logType;
    }


    /**
     * Sets the logType value for this InvoiceLog.
     * 
     * @param logType
     */
    public void setLogType(java.lang.String logType) {
        this.logType = logType;
    }


    /**
     * Gets the procCorpName value for this InvoiceLog.
     * 
     * @return procCorpName
     */
    public java.lang.String getProcCorpName() {
        return procCorpName;
    }


    /**
     * Sets the procCorpName value for this InvoiceLog.
     * 
     * @param procCorpName
     */
    public void setProcCorpName(java.lang.String procCorpName) {
        this.procCorpName = procCorpName;
    }


    /**
     * Gets the procContactName value for this InvoiceLog.
     * 
     * @return procContactName
     */
    public java.lang.String getProcContactName() {
        return procContactName;
    }


    /**
     * Sets the procContactName value for this InvoiceLog.
     * 
     * @param procContactName
     */
    public void setProcContactName(java.lang.String procContactName) {
        this.procContactName = procContactName;
    }


    /**
     * Gets the logDateTime value for this InvoiceLog.
     * 
     * @return logDateTime
     */
    public java.lang.String getLogDateTime() {
        return logDateTime;
    }


    /**
     * Sets the logDateTime value for this InvoiceLog.
     * 
     * @param logDateTime
     */
    public void setLogDateTime(java.lang.String logDateTime) {
        this.logDateTime = logDateTime;
    }


    /**
     * Gets the memo value for this InvoiceLog.
     * 
     * @return memo
     */
    public java.lang.String getMemo() {
        return memo;
    }


    /**
     * Sets the memo value for this InvoiceLog.
     * 
     * @param memo
     */
    public void setMemo(java.lang.String memo) {
        this.memo = memo;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof InvoiceLog)) return false;
        InvoiceLog other = (InvoiceLog) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.seq == other.getSeq() &&
            ((this.logType==null && other.getLogType()==null) || 
             (this.logType!=null &&
              this.logType.equals(other.getLogType()))) &&
            ((this.procCorpName==null && other.getProcCorpName()==null) || 
             (this.procCorpName!=null &&
              this.procCorpName.equals(other.getProcCorpName()))) &&
            ((this.procContactName==null && other.getProcContactName()==null) || 
             (this.procContactName!=null &&
              this.procContactName.equals(other.getProcContactName()))) &&
            ((this.logDateTime==null && other.getLogDateTime()==null) || 
             (this.logDateTime!=null &&
              this.logDateTime.equals(other.getLogDateTime()))) &&
            ((this.memo==null && other.getMemo()==null) || 
             (this.memo!=null &&
              this.memo.equals(other.getMemo())));
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
        _hashCode += getSeq();
        if (getLogType() != null) {
            _hashCode += getLogType().hashCode();
        }
        if (getProcCorpName() != null) {
            _hashCode += getProcCorpName().hashCode();
        }
        if (getProcContactName() != null) {
            _hashCode += getProcContactName().hashCode();
        }
        if (getLogDateTime() != null) {
            _hashCode += getLogDateTime().hashCode();
        }
        if (getMemo() != null) {
            _hashCode += getMemo().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(InvoiceLog.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "InvoiceLog"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("seq");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Seq"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("logType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "LogType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procCorpName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ProcCorpName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procContactName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ProcContactName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("logDateTime");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "LogDateTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("memo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Memo"));
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
