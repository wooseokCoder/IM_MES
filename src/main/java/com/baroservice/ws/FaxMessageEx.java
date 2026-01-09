/**
 * FaxMessageEx.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class FaxMessageEx  implements java.io.Serializable {
    private java.lang.String sendKey;

    private java.lang.String ID;

    private java.lang.String sendFileName;

    private int sendPageCount;

    private int successPageCount;

    private java.lang.String sendResult;

    private java.lang.String senderNum;

    private java.lang.String receiveCorp;

    private java.lang.String receiverName;

    private java.lang.String receiverNum;

    private java.lang.String sendDT;

    private java.lang.String refKey;

    private int sendState;

    private java.lang.String[] fileURLs;

    public FaxMessageEx() {
    }

    public FaxMessageEx(
           java.lang.String sendKey,
           java.lang.String ID,
           java.lang.String sendFileName,
           int sendPageCount,
           int successPageCount,
           java.lang.String sendResult,
           java.lang.String senderNum,
           java.lang.String receiveCorp,
           java.lang.String receiverName,
           java.lang.String receiverNum,
           java.lang.String sendDT,
           java.lang.String refKey,
           int sendState,
           java.lang.String[] fileURLs) {
           this.sendKey = sendKey;
           this.ID = ID;
           this.sendFileName = sendFileName;
           this.sendPageCount = sendPageCount;
           this.successPageCount = successPageCount;
           this.sendResult = sendResult;
           this.senderNum = senderNum;
           this.receiveCorp = receiveCorp;
           this.receiverName = receiverName;
           this.receiverNum = receiverNum;
           this.sendDT = sendDT;
           this.refKey = refKey;
           this.sendState = sendState;
           this.fileURLs = fileURLs;
    }


    /**
     * Gets the sendKey value for this FaxMessageEx.
     * 
     * @return sendKey
     */
    public java.lang.String getSendKey() {
        return sendKey;
    }


    /**
     * Sets the sendKey value for this FaxMessageEx.
     * 
     * @param sendKey
     */
    public void setSendKey(java.lang.String sendKey) {
        this.sendKey = sendKey;
    }


    /**
     * Gets the ID value for this FaxMessageEx.
     * 
     * @return ID
     */
    public java.lang.String getID() {
        return ID;
    }


    /**
     * Sets the ID value for this FaxMessageEx.
     * 
     * @param ID
     */
    public void setID(java.lang.String ID) {
        this.ID = ID;
    }


    /**
     * Gets the sendFileName value for this FaxMessageEx.
     * 
     * @return sendFileName
     */
    public java.lang.String getSendFileName() {
        return sendFileName;
    }


    /**
     * Sets the sendFileName value for this FaxMessageEx.
     * 
     * @param sendFileName
     */
    public void setSendFileName(java.lang.String sendFileName) {
        this.sendFileName = sendFileName;
    }


    /**
     * Gets the sendPageCount value for this FaxMessageEx.
     * 
     * @return sendPageCount
     */
    public int getSendPageCount() {
        return sendPageCount;
    }


    /**
     * Sets the sendPageCount value for this FaxMessageEx.
     * 
     * @param sendPageCount
     */
    public void setSendPageCount(int sendPageCount) {
        this.sendPageCount = sendPageCount;
    }


    /**
     * Gets the successPageCount value for this FaxMessageEx.
     * 
     * @return successPageCount
     */
    public int getSuccessPageCount() {
        return successPageCount;
    }


    /**
     * Sets the successPageCount value for this FaxMessageEx.
     * 
     * @param successPageCount
     */
    public void setSuccessPageCount(int successPageCount) {
        this.successPageCount = successPageCount;
    }


    /**
     * Gets the sendResult value for this FaxMessageEx.
     * 
     * @return sendResult
     */
    public java.lang.String getSendResult() {
        return sendResult;
    }


    /**
     * Sets the sendResult value for this FaxMessageEx.
     * 
     * @param sendResult
     */
    public void setSendResult(java.lang.String sendResult) {
        this.sendResult = sendResult;
    }


    /**
     * Gets the senderNum value for this FaxMessageEx.
     * 
     * @return senderNum
     */
    public java.lang.String getSenderNum() {
        return senderNum;
    }


    /**
     * Sets the senderNum value for this FaxMessageEx.
     * 
     * @param senderNum
     */
    public void setSenderNum(java.lang.String senderNum) {
        this.senderNum = senderNum;
    }


    /**
     * Gets the receiveCorp value for this FaxMessageEx.
     * 
     * @return receiveCorp
     */
    public java.lang.String getReceiveCorp() {
        return receiveCorp;
    }


    /**
     * Sets the receiveCorp value for this FaxMessageEx.
     * 
     * @param receiveCorp
     */
    public void setReceiveCorp(java.lang.String receiveCorp) {
        this.receiveCorp = receiveCorp;
    }


    /**
     * Gets the receiverName value for this FaxMessageEx.
     * 
     * @return receiverName
     */
    public java.lang.String getReceiverName() {
        return receiverName;
    }


    /**
     * Sets the receiverName value for this FaxMessageEx.
     * 
     * @param receiverName
     */
    public void setReceiverName(java.lang.String receiverName) {
        this.receiverName = receiverName;
    }


    /**
     * Gets the receiverNum value for this FaxMessageEx.
     * 
     * @return receiverNum
     */
    public java.lang.String getReceiverNum() {
        return receiverNum;
    }


    /**
     * Sets the receiverNum value for this FaxMessageEx.
     * 
     * @param receiverNum
     */
    public void setReceiverNum(java.lang.String receiverNum) {
        this.receiverNum = receiverNum;
    }


    /**
     * Gets the sendDT value for this FaxMessageEx.
     * 
     * @return sendDT
     */
    public java.lang.String getSendDT() {
        return sendDT;
    }


    /**
     * Sets the sendDT value for this FaxMessageEx.
     * 
     * @param sendDT
     */
    public void setSendDT(java.lang.String sendDT) {
        this.sendDT = sendDT;
    }


    /**
     * Gets the refKey value for this FaxMessageEx.
     * 
     * @return refKey
     */
    public java.lang.String getRefKey() {
        return refKey;
    }


    /**
     * Sets the refKey value for this FaxMessageEx.
     * 
     * @param refKey
     */
    public void setRefKey(java.lang.String refKey) {
        this.refKey = refKey;
    }


    /**
     * Gets the sendState value for this FaxMessageEx.
     * 
     * @return sendState
     */
    public int getSendState() {
        return sendState;
    }


    /**
     * Sets the sendState value for this FaxMessageEx.
     * 
     * @param sendState
     */
    public void setSendState(int sendState) {
        this.sendState = sendState;
    }


    /**
     * Gets the fileURLs value for this FaxMessageEx.
     * 
     * @return fileURLs
     */
    public java.lang.String[] getFileURLs() {
        return fileURLs;
    }


    /**
     * Sets the fileURLs value for this FaxMessageEx.
     * 
     * @param fileURLs
     */
    public void setFileURLs(java.lang.String[] fileURLs) {
        this.fileURLs = fileURLs;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof FaxMessageEx)) return false;
        FaxMessageEx other = (FaxMessageEx) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.sendKey==null && other.getSendKey()==null) || 
             (this.sendKey!=null &&
              this.sendKey.equals(other.getSendKey()))) &&
            ((this.ID==null && other.getID()==null) || 
             (this.ID!=null &&
              this.ID.equals(other.getID()))) &&
            ((this.sendFileName==null && other.getSendFileName()==null) || 
             (this.sendFileName!=null &&
              this.sendFileName.equals(other.getSendFileName()))) &&
            this.sendPageCount == other.getSendPageCount() &&
            this.successPageCount == other.getSuccessPageCount() &&
            ((this.sendResult==null && other.getSendResult()==null) || 
             (this.sendResult!=null &&
              this.sendResult.equals(other.getSendResult()))) &&
            ((this.senderNum==null && other.getSenderNum()==null) || 
             (this.senderNum!=null &&
              this.senderNum.equals(other.getSenderNum()))) &&
            ((this.receiveCorp==null && other.getReceiveCorp()==null) || 
             (this.receiveCorp!=null &&
              this.receiveCorp.equals(other.getReceiveCorp()))) &&
            ((this.receiverName==null && other.getReceiverName()==null) || 
             (this.receiverName!=null &&
              this.receiverName.equals(other.getReceiverName()))) &&
            ((this.receiverNum==null && other.getReceiverNum()==null) || 
             (this.receiverNum!=null &&
              this.receiverNum.equals(other.getReceiverNum()))) &&
            ((this.sendDT==null && other.getSendDT()==null) || 
             (this.sendDT!=null &&
              this.sendDT.equals(other.getSendDT()))) &&
            ((this.refKey==null && other.getRefKey()==null) || 
             (this.refKey!=null &&
              this.refKey.equals(other.getRefKey()))) &&
            this.sendState == other.getSendState() &&
            ((this.fileURLs==null && other.getFileURLs()==null) || 
             (this.fileURLs!=null &&
              java.util.Arrays.equals(this.fileURLs, other.getFileURLs())));
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
        if (getSendKey() != null) {
            _hashCode += getSendKey().hashCode();
        }
        if (getID() != null) {
            _hashCode += getID().hashCode();
        }
        if (getSendFileName() != null) {
            _hashCode += getSendFileName().hashCode();
        }
        _hashCode += getSendPageCount();
        _hashCode += getSuccessPageCount();
        if (getSendResult() != null) {
            _hashCode += getSendResult().hashCode();
        }
        if (getSenderNum() != null) {
            _hashCode += getSenderNum().hashCode();
        }
        if (getReceiveCorp() != null) {
            _hashCode += getReceiveCorp().hashCode();
        }
        if (getReceiverName() != null) {
            _hashCode += getReceiverName().hashCode();
        }
        if (getReceiverNum() != null) {
            _hashCode += getReceiverNum().hashCode();
        }
        if (getSendDT() != null) {
            _hashCode += getSendDT().hashCode();
        }
        if (getRefKey() != null) {
            _hashCode += getRefKey().hashCode();
        }
        _hashCode += getSendState();
        if (getFileURLs() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getFileURLs());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getFileURLs(), i);
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
        new org.apache.axis.description.TypeDesc(FaxMessageEx.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "FaxMessageEx"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sendKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SendKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sendFileName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SendFileName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sendPageCount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SendPageCount"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("successPageCount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SuccessPageCount"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sendResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SendResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("senderNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SenderNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("receiveCorp");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ReceiveCorp"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("receiverName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ReceiverName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("receiverNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ReceiverNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sendDT");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SendDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("refKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "RefKey"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sendState");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SendState"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fileURLs");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "fileURLs"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setItemQName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "string"));
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
