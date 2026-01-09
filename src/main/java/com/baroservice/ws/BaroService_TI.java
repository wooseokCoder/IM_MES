/**
 * BaroService_TI.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.baroservice.ws;

public interface BaroService_TI extends javax.xml.rpc.Service {

/**
 * 바로빌 세금계산서 연동서비스
 */
    public java.lang.String getBaroService_TISoapAddress();

    public com.baroservice.ws.BaroService_TISoap getBaroService_TISoap() throws javax.xml.rpc.ServiceException;

    public com.baroservice.ws.BaroService_TISoap getBaroService_TISoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
