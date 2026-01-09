/**
 * BaroService_SMS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public interface BaroService_SMS extends javax.xml.rpc.Service {

/**
 * 바로빌 SMS 발송서비스
 */
    public java.lang.String getBaroService_SMSSoapAddress();

    public com.baroservice.ws.BaroService_SMSSoap getBaroService_SMSSoap() throws javax.xml.rpc.ServiceException;

    public com.baroservice.ws.BaroService_SMSSoap getBaroService_SMSSoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
