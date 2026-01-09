/*
 * @(#)Record.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.model;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

import oracle.sql.BLOB;
import oracle.sql.CLOB;

import com.wsc.framework.base.BaseMap;
import com.wsc.framework.exception.SystemException;

/**
 * 레코드 모델 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class RecordMap extends BaseMap {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;
    
    /**
     * 바이트 배열을 처리한다.
     * 
     * @param byteArray 바이트 배열
     * @return 문자열
     */
    private String handleByteArray(byte[] byteArray) {
        try {
            return new String(byteArray, "UTF-8");
        }
        catch (UnsupportedEncodingException uee) {
            throw new SystemException("error.system", uee.getMessage());
        }
    }
    
    /**
     * 캐릭터 배열을 처리한다.
     * 
     * @param charArray 바이트 배열
     * @return 문자열
     */
    private String handleCharArray(char[] charArray) {
        return new String(charArray);
    }
    
    /**
     * BLOB을 처리한다.
     * 
     * @param blob BLOB
     * @return 문자열
     */
    private String handleBlob(BLOB blob) {
        BufferedReader br = null;
        
        try {
            br = new BufferedReader(new InputStreamReader(blob.getBinaryStream(), "UTF-8"));
            
            StringBuffer sb = new StringBuffer();
            
            while (true) {
                String line = br.readLine();
                
                if (line == null) {
                    break;
                }
                
                if (sb.length() > 0) {
                    sb.append("\n");
                }
                
                sb.append(line);
            }
            
            return sb.toString();
        }
        catch (SQLException sqle) {
            throw new SystemException("error.system", sqle.getMessage());
        }
        catch (UnsupportedEncodingException uee) {
            throw new SystemException("error.system", uee.getMessage());
        }
        catch (IOException ioe) {
            throw new SystemException("error.system", ioe.getMessage());
        }
        finally {
            if (br != null) {
                try {
                    br.close();
                }
                catch (IOException ioe) {
                }
            }
            if (blob != null) {
                try {
                    blob.close();
                }
                catch (SQLException sqle) {
                }
            }
        }
    }
    
    /**
     * CLOB을 처리한다.
     * 
     * @param clob CLOB
     * @return 문자열
     */
    private String handleClob(CLOB clob) {
        BufferedReader br = null;
        
        try {
            br = new BufferedReader(clob.getCharacterStream());
            
            StringBuffer sb = new StringBuffer();
            
            while (true) {
                String line = br.readLine();
                
                if (line == null) {
                    break;
                }
                
                if (sb.length() > 0) {
                    sb.append("\n");
                }
                
                sb.append(line);
            }
            
            return sb.toString();
        }
        catch (SQLException sqle) {
            throw new SystemException("error.system", sqle.getMessage());
        }
        catch (IOException ioe) {
            throw new SystemException("error.system", ioe.getMessage());
        }
        finally {
            if (br != null) {
                try {
                    br.close();
                }
                catch (IOException ioe) {
                }
            }
            if (clob != null) {
                try {
                    clob.close();
                }
                catch (SQLException sqle) {
                }
            }
        }
    }
    
    /* 
     * (non-Javadoc)
     * @see java.util.HashMap#put(java.lang.Object, java.lang.Object)
     */
    public Object put(Object key, Object value) {
        if (value instanceof byte[]) {
            return super.put(key, handleByteArray((byte[]) value));
        }
        if (value instanceof char[]) {
            return super.put(key, handleCharArray((char[]) value));
        }
        if (value instanceof BLOB) {
            return super.put(key, handleBlob((BLOB) value));
        }
        if (value instanceof CLOB) {
            return super.put(key, handleClob((CLOB) value));
        }
        
        return super.put(key, value);
    }
}