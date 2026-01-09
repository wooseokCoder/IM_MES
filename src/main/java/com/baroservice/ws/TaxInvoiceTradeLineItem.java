/**
 * TaxInvoiceTradeLineItem.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public class TaxInvoiceTradeLineItem  implements java.io.Serializable {
    private java.lang.String purchaseExpiry;

    private java.lang.String name;

    private java.lang.String information;

    private java.lang.String chargeableUnit;

    private java.lang.String unitPrice;

    private java.lang.String amount;

    private java.lang.String tax;

    private java.lang.String description;

    public TaxInvoiceTradeLineItem() {
    }

    public TaxInvoiceTradeLineItem(
           java.lang.String purchaseExpiry,
           java.lang.String name,
           java.lang.String information,
           java.lang.String chargeableUnit,
           java.lang.String unitPrice,
           java.lang.String amount,
           java.lang.String tax,
           java.lang.String description) {
           this.purchaseExpiry = purchaseExpiry;
           this.name = name;
           this.information = information;
           this.chargeableUnit = chargeableUnit;
           this.unitPrice = unitPrice;
           this.amount = amount;
           this.tax = tax;
           this.description = description;
    }


    /**
     * Gets the purchaseExpiry value for this TaxInvoiceTradeLineItem.
     * 
     * @return purchaseExpiry
     */
    public java.lang.String getPurchaseExpiry() {
        return purchaseExpiry;
    }


    /**
     * Sets the purchaseExpiry value for this TaxInvoiceTradeLineItem.
     * 
     * @param purchaseExpiry
     */
    public void setPurchaseExpiry(java.lang.String purchaseExpiry) {
        this.purchaseExpiry = purchaseExpiry;
    }


    /**
     * Gets the name value for this TaxInvoiceTradeLineItem.
     * 
     * @return name
     */
    public java.lang.String getName() {
        return name;
    }


    /**
     * Sets the name value for this TaxInvoiceTradeLineItem.
     * 
     * @param name
     */
    public void setName(java.lang.String name) {
        this.name = name;
    }


    /**
     * Gets the information value for this TaxInvoiceTradeLineItem.
     * 
     * @return information
     */
    public java.lang.String getInformation() {
        return information;
    }


    /**
     * Sets the information value for this TaxInvoiceTradeLineItem.
     * 
     * @param information
     */
    public void setInformation(java.lang.String information) {
        this.information = information;
    }


    /**
     * Gets the chargeableUnit value for this TaxInvoiceTradeLineItem.
     * 
     * @return chargeableUnit
     */
    public java.lang.String getChargeableUnit() {
        return chargeableUnit;
    }


    /**
     * Sets the chargeableUnit value for this TaxInvoiceTradeLineItem.
     * 
     * @param chargeableUnit
     */
    public void setChargeableUnit(java.lang.String chargeableUnit) {
        this.chargeableUnit = chargeableUnit;
    }


    /**
     * Gets the unitPrice value for this TaxInvoiceTradeLineItem.
     * 
     * @return unitPrice
     */
    public java.lang.String getUnitPrice() {
        return unitPrice;
    }


    /**
     * Sets the unitPrice value for this TaxInvoiceTradeLineItem.
     * 
     * @param unitPrice
     */
    public void setUnitPrice(java.lang.String unitPrice) {
        this.unitPrice = unitPrice;
    }


    /**
     * Gets the amount value for this TaxInvoiceTradeLineItem.
     * 
     * @return amount
     */
    public java.lang.String getAmount() {
        return amount;
    }


    /**
     * Sets the amount value for this TaxInvoiceTradeLineItem.
     * 
     * @param amount
     */
    public void setAmount(java.lang.String amount) {
        this.amount = amount;
    }


    /**
     * Gets the tax value for this TaxInvoiceTradeLineItem.
     * 
     * @return tax
     */
    public java.lang.String getTax() {
        return tax;
    }


    /**
     * Sets the tax value for this TaxInvoiceTradeLineItem.
     * 
     * @param tax
     */
    public void setTax(java.lang.String tax) {
        this.tax = tax;
    }


    /**
     * Gets the description value for this TaxInvoiceTradeLineItem.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this TaxInvoiceTradeLineItem.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof TaxInvoiceTradeLineItem)) return false;
        TaxInvoiceTradeLineItem other = (TaxInvoiceTradeLineItem) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.purchaseExpiry==null && other.getPurchaseExpiry()==null) || 
             (this.purchaseExpiry!=null &&
              this.purchaseExpiry.equals(other.getPurchaseExpiry()))) &&
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
            ((this.information==null && other.getInformation()==null) || 
             (this.information!=null &&
              this.information.equals(other.getInformation()))) &&
            ((this.chargeableUnit==null && other.getChargeableUnit()==null) || 
             (this.chargeableUnit!=null &&
              this.chargeableUnit.equals(other.getChargeableUnit()))) &&
            ((this.unitPrice==null && other.getUnitPrice()==null) || 
             (this.unitPrice!=null &&
              this.unitPrice.equals(other.getUnitPrice()))) &&
            ((this.amount==null && other.getAmount()==null) || 
             (this.amount!=null &&
              this.amount.equals(other.getAmount()))) &&
            ((this.tax==null && other.getTax()==null) || 
             (this.tax!=null &&
              this.tax.equals(other.getTax()))) &&
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription())));
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
        if (getPurchaseExpiry() != null) {
            _hashCode += getPurchaseExpiry().hashCode();
        }
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
        if (getInformation() != null) {
            _hashCode += getInformation().hashCode();
        }
        if (getChargeableUnit() != null) {
            _hashCode += getChargeableUnit().hashCode();
        }
        if (getUnitPrice() != null) {
            _hashCode += getUnitPrice().hashCode();
        }
        if (getAmount() != null) {
            _hashCode += getAmount().hashCode();
        }
        if (getTax() != null) {
            _hashCode += getTax().hashCode();
        }
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(TaxInvoiceTradeLineItem.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://ws.baroservice.com/", "TaxInvoiceTradeLineItem"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("purchaseExpiry");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "PurchaseExpiry"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("name");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("information");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Information"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("chargeableUnit");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "ChargeableUnit"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("unitPrice");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "UnitPrice"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("amount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Amount"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("tax");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Tax"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("http://ws.baroservice.com/", "Description"));
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
