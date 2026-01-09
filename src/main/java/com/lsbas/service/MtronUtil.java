package com.lsbas.service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class MtronUtil {
    private static final Logger LOG = LoggerFactory.getLogger(MtronUtil.class);
    
    /** 
     * 변동성이 존재하는 파라미터를 String으로  리턴한다
     */
    public static String getStringValue(Object data) {
        if (data instanceof Double)
            return Double.toString((Double) data);
        else if (data instanceof Long)
            return Long.toString((Long) data);
        else if (data instanceof Integer)
            return Integer.toString((Integer) data);
        else if (data instanceof BigDecimal)
            return data.toString();
        else if (data instanceof String)
            return (String) data;
        return "";
    }
    /** 
     * ERP Flag 유형으로  리턴한다
     */
    public static String getErpFlagValue(Object data) {
        if("Y".equals(getStringValue(data))) {
            return "X";
        }
        
        return "";
    }
    /** 
     * ERP Code 유형  리턴한다
     */
    public static String getErpEmptyCodeValue(Object data) {
        String value = getStringValue(data);
        if("0".equals(getStringValue(value))) {
            return "";
        }
        
        return value;
    }
    /** 
     * ERP 수신 공백 값 Null 리턴한다 (Trim 외 작업이 있을 경우 여기에 일괄처리)
     */
    public static String getErpEmptyValue(String value) {
        if(value != null) {
            value = value.trim();
            if(value.isEmpty())
                return null;
        }
        return value;
    }
    /** 
     * 현재 시간을 가져온다
     */
 	public static String getCurrentDate() {
 		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
 		
	 	Date current = new Date(System.currentTimeMillis() );
	 	return dateFormat.format(current);
 	}
    /** 
     * - null, ""(빈 문자열), "NULL" -> ""
     * - 그 외 값은 그대로 반환
     */
 	public static String nullToEmpty(String value) {
 	    if (value == null || value.trim().isEmpty() || "NULL".equalsIgnoreCase(value.trim())) {
 	        return "";
 	    }
 	    return value;
 	}
 	
}