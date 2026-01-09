/**
 * SMSMessage.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class SMSMessage  implements java.io.Serializable {
    private java.lang.String sendKey;

    private java.lang.String ID;

    private java.lang.String senderNum;

    private java.lang.String receiverName;

    private java.lang.String receiverNum;

    private java.lang.String message;

    private java.lang.String sendDT;

    private java.lang.String refKey;

    private int sendState;

    public SMSMessage() {
    }

    public SMSMessage(
           java.lang.String sendKey,
           java.lang.String ID,
           java.lang.String senderNum,
           java.lang.String receiverName,
           java.lang.String receiverNum,
           java.lang.String message,
           java.lang.String sendDT,
           java.lang.String refKey,
           int sendState) {
           this.sendKey = sendKey;
           this.ID = ID;
           this.senderNum = senderNum;
           this.receiverName = receiverName;
           this.receiverNum = receiverNum;
           this.message = message;
           this.sendDT = sendDT;
           this.refKey = refKey;
           this.sendState = sendState;
    }


    /**
     * Gets the sendKey value for this SMSMessage.
     * 
     * @return sendKey
     */
    public java.lang.String getSendKey() {
        return sendKey;
    }


    /**
     * Sets the sendKey value for this SMSMessage.
     * 
     * @param sendKey
     */
    public void setSendKey(java.lang.String sendKey) {
        this.sendKey = sendKey;
    }


    /**
     * Gets the ID value for this SMSMessage.
     * 
     * @return ID
     */
    public java.lang.String getID() {
        return ID;
    }


    /**
     * Sets the ID value for this SMSMessage.
     * 
     * @param ID
     */
    public void setID(java.lang.String ID) {
        this.ID = ID;
    }


    /**
     * Gets the senderNum value for this SMSMessage.
     * 
     * @return senderNum
     */
    public java.lang.String getSenderNum() {
        return senderNum;
    }


    /**
     * Sets the senderNum value for this SMSMessage.
     * 
     * @param senderNum
     */
    public void setSenderNum(java.lang.String senderNum) {
        this.senderNum = senderNum;
    }


    /**
     * Gets the receiverName value for this SMSMessage.
     * 
     * @return receiverName
     */
    public java.lang.String getReceiverName() {
        return receiverName;
    }


    /**
     * Sets the receiverName value for this SMSMessage.
     * 
     * @param receiverName
     */
    public void setReceiverName(java.lang.String receiverName) {
        this.receiverName = receiverName;
    }


    /**
     * Gets the receiverNum value for this SMSMessage.
     * 
     * @return receiverNum
     */
    public java.lang.String getReceiverNum() {
        return receiverNum;
    }


    /**
     * Sets the receiverNum value for this SMSMessage.
     * 
     * @param receiverNum
     */
    public void setReceiverNum(java.lang.String receiverNum) {
        this.receiverNum = receiverNum;
    }


    /**
     * Gets the message value for this SMSMessage.
     * 
     * @return message
     */
    public java.lang.String getMessage() {
        return message;
    }


    /**
     * Sets the message value for this SMSMessage.
     * 
     * @param message
     */
    public void setMessage(java.lang.String message) {
        this.message = message;
    }


    /**
     * Gets the sendDT value for this SMSMessage.
     * 
     * @return sendDT
     */
    public java.lang.String getSendDT() {
        return sendDT;
    }


    /**
     * Sets the sendDT value for this SMSMessage.
     * 
     * @param sendDT
     */
    public void setSendDT(java.lang.String sendDT) {
        this.sendDT = sendDT;
    }


    /**
     * Gets the refKey value for this SMSMessage.
     * 
     * @return refKey
     */
    public java.lang.String getRefKey() {
        return refKey;
    }


    /**
     * Sets the refKey value for this SMSMessage.
     * 
     * @param refKey
     */
    public void setRefKey(java.lang.String refKey) {
        this.refKey = refKey;
    }


    /**
     * Gets the sendState value for this SMSMessage.
     * 
     * @return sendState
     */
    public int getSendState() {
        return sendState;
    }


    /**
     * Sets the sendState value for this SMSMessage.
     * 
     * @param sendState
     */
    public void setSendState(int sendState) {
        this.sendState = sendState;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SMSMessage)) return false;
        SMSMessage other = (SMSMessage) obj;
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
            ((this.senderNum==null && other.getSenderNum()==null) || 
             (this.senderNum!=null &&
              this.senderNum.equals(other.getSenderNum()))) &&
            ((this.receiverName==null && other.getReceiverName()==null) || 
             (this.receiverName!=null &&
              this.receiverName.equals(other.getReceiverName()))) &&
            ((this.receiverNum==null && other.getReceiverNum()==null) || 
             (this.receiverNum!=null &&
              this.receiverNum.equals(other.getReceiverNum()))) &&
            ((this.message==null && other.getMessage()==null) || 
             (this.message!=null &&
              this.message.equals(other.getMessage()))) &&
            ((this.sendDT==null && other.getSendDT()==null) || 
             (this.sendDT!=null &&
              this.sendDT.equals(other.getSendDT()))) &&
            ((this.refKey==null && other.getRefKey()==null) || 
             (this.refKey!=null &&
              this.refKey.equals(other.getRefKey()))) &&
            this.sendState == other.getSendState();
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
        if (getSenderNum() != null) {
            _hashCode += getSenderNum().hashCode();
        }
        if (getReceiverName() != null) {
            _hashCode += getReceiverName().hashCode();
        }
        if (getReceiverNum() != null) {
            _hashCode += getReceiverNum().hashCode();
        }
        if (getMessage() != null) {
            _hashCode += getMessage().hashCode();
        }
        if (getSendDT() != null) {
            _hashCode += getSendDT().hashCode();
        }
        if (getRefKey() != null) {
            _hashCode += getRefKey().hashCode();
        }
        _hashCode += getSendState();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(SMSMessage.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SMSMessage"));
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
        elemField.setFieldName("senderNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "SenderNum"));
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
        elemField.setFieldName("message");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Message"));
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
