/*
 * @(#)BaseModel.java 1.0 2014/07/25
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.base;

import java.util.HashMap;
import java.util.List;

/**
 * 기본 모델 클래스이다.
 * 
 * @author C-NODE
 * @version 1.0 2014/07/25
 */
public class BaseMap extends HashMap<Object, Object> {
    /**
     * 시리얼 버전 아이디
     */
    private static final long serialVersionUID = 1L;

    /**
     * 논리값을 반환한다.
     * 
     * @param key 키
     * @return 논리값
     */
    public boolean getBoolean(String key) {
        return getBoolean(key, false);
    }
    
    /**
     * 논리값을 반환한다.
     * 
     * @param key 키
     * @param defaultValue 디폴트 논리값
     * @return 논리값
     */
    public boolean getBoolean(String key, boolean defaultValue) {
        Object value = get(key);
        
        if (value instanceof Object) {
            return value.toString().equalsIgnoreCase("true");
        }
        
        return defaultValue;
    }
    
    /**
     * 논리값 배열을 반환한다.
     * 
     * @param key 키
     * @return 논리값 배열
     */
    public boolean[] getBooleanArray(String key) {
        Object value = get(key);
        
        if (value instanceof Object[]) {
            Object[] values = (Object[]) value;
            
            boolean[] booleanValues = new boolean[values.length];
            
            for (int i = 0; i < values.length; i++) {
                booleanValues[i] = values[i].toString().equalsIgnoreCase("true");
            }
            
            return booleanValues;
        }
        
        if (value instanceof Object) {
            return new boolean[] { value.toString().equalsIgnoreCase("true") };
        }
        
        return new boolean[0];
    }
    
    /**
     * 정수값을 반환한다.
     * 
     * @param key 키
     * @return 정수값
     */
    public int getInt(String key) {
        return getInt(key, 0);
    }
    
    /**
     * 정수값을 반환한다.
     * 
     * @param key 키
     * @param defaultValue 디폴트 정수값
     * @return 정수값
     */
    public int getInt(String key, int defaultValue) {
        Object value = get(key);
        
        if (value instanceof Object) {
            return Integer.parseInt(value.toString());
        }
        
        return defaultValue;
    }
    
    /**
     * 정수값 배열을 반환한다.
     * 
     * @param key 키
     * @return 정수값 배열
     */
    public int[] getIntArray(String key) {
        Object value = get(key);
        
        if (value instanceof Object[]) {
            Object[] values = (Object[]) value;
            
            int[] intValues = new int[values.length];
            
            for (int i = 0; i < values.length; i++) {
                intValues[i] = Integer.parseInt(values[i].toString());
            }
            
            return intValues;
        }
        
        if (value instanceof Object) {
            return new int[] { Integer.parseInt(value.toString()) };
        }
        
        return new int[0];
    }
    
    /**
     * 정수값을 반환한다.
     * 
     * @param key 키
     * @return 정수값
     */
    public long getLong(String key) {
        return getLong(key, 0L);
    }
    
    /**
     * 정수값을 반환한다.
     * 
     * @param key 키
     * @param defaultValue 디폴트 정수값
     * @return 정수값
     */
    public long getLong(String key, long defaultValue) {
        Object value = get(key);
        
        if (value instanceof Object) {
            return Long.parseLong(value.toString());
        }
        
        return defaultValue;
    }
    
    /**
     * 정수값 배열을 반환한다.
     * 
     * @param key 키
     * @return 정수값 배열
     */
    public long[] getLongArray(String key) {
        Object value = get(key);
        
        if (value instanceof Object[]) {
            Object[] values = (Object[]) value;
            
            long[] longValues = new long[values.length];
            
            for (int i = 0; i < values.length; i++) {
                longValues[i] = Long.parseLong(values[i].toString());
            }
            
            return longValues;
        }
        
        if (value instanceof Object) {
            return new long[] { Long.parseLong(value.toString()) };
        }
        
        return new long[0];
    }
    
    /**
     * 실수값을 반환한다.
     * 
     * @param key 키
     * @return 실수값
     */
    public float getFloat(String key) {
        return getFloat(key, 0F);
    }
    
    /**
     * 실수값을 반환한다.
     * 
     * @param key 키
     * @param defaultValue 디폴트 실수값
     * @return 실수값
     */
    public float getFloat(String key, float defaultValue) {
        Object value = get(key);
        
        if (value instanceof Object) {
            return Float.parseFloat(value.toString());
        }
        
        return defaultValue;
    }
    
    /**
     * 실수값 배열을 반환한다.
     * 
     * @param key 키
     * @return 실수값 배열
     */
    public float[] getFloatArray(String key) {
        Object value = get(key);
        
        if (value instanceof Object[]) {
            Object[] values = (Object[]) value;
            
            float[] floatValues = new float[values.length];
            
            for (int i = 0; i < values.length; i++) {
                floatValues[i] = Float.parseFloat(values[i].toString());
            }
            
            return floatValues;
        }
        
        if (value instanceof Object) {
            return new float[] { Float.parseFloat(value.toString()) };
        }
        
        return new float[0];
    }
    
    /**
     * 실수값을 반환한다.
     * 
     * @param key 키
     * @return 실수값
     */
    public double getDouble(String key) {
        return getDouble(key, 0D);
    }
    
    /**
     * 실수값을 반환한다.
     * 
     * @param key 키
     * @param defaultValue 디폴트 실수값
     * @return 실수값
     */
    public double getDouble(String key, double defaultValue) {
        Object value = get(key);
        
        if (value instanceof Object) {
            return Double.parseDouble(value.toString());
        }
        
        return defaultValue;
    }
    
    /**
     * 실수값 배열을 반환한다.
     * 
     * @param key 키
     * @return 실수값 배열
     */
    public double[] getDoubleArray(String key) {
        Object value = get(key);
        
        if (value instanceof Object[]) {
            Object[] values = (Object[]) value;
            
            double[] doubleValues = new double[values.length];
            
            for (int i = 0; i < values.length; i++) {
                doubleValues[i] = Double.parseDouble(values[i].toString());
            }
            
            return doubleValues;
        }
        
        if (value instanceof Object) {
            return new double[] { Double.parseDouble(value.toString()) };
        }
        
        return new double[0];
    }
    
    /**
     * 문자열을 반환한다.
     * 
     * @param key 키
     * @return 문자열
     */
    public String getString(String key) {
        return getString(key, "");
    }
    
    /**
     * 문자열을 반환한다.
     * 
     * @param key 키
     * @param defaultValue 디폴트 문자열
     * @return 문자열
     */
    public String getString(String key, String defaultValue) {
        Object value = get(key);
        
        if (value instanceof Object) {
            return value.toString();
        }
        
        return defaultValue;
    }
    
    /**
     * 문자열 배열을 반환한다.
     * 
     * @param key 키
     * @return 문자열 배열
     */
    public String[] getStringArray(String key) {
        Object value = get(key);
        
        if (value instanceof Object[]) {
            Object[] values = (Object[]) value;
            
            String[] stringValues = new String[values.length];
            
            for (int i = 0; i < values.length; i++) {
                stringValues[i] = values[i].toString();
            }
            
            return stringValues;
        }
        
        if (value instanceof Object) {
            return new String[] { value.toString() };
        }
        
        return new String[0];
    }
    
    @SuppressWarnings("rawtypes")
	public List getList(String key) {
        return (List) get(key);
    }
    
    public static final String SYS_ID    = "sysId";
    public static final String REGI_ID   = "regiId";
    public static final String REGI_DATE = "regiDate";
    public static final String CHNG_ID   = "chngId";
    public static final String CHNG_DATE = "chngDate";
    public static final String USE_FLAG  = "useFlag";
    
	
	public String getSysId() {
		return getString(SYS_ID);
	}
	public String getRegiId() {
		return getString(REGI_ID);
	}
	public String getRegiDate() {
		return getString(REGI_DATE);
	}
	public String getChngId() {
		return getString(CHNG_ID);
	}
	public String getChngDate() {
		return getString(CHNG_DATE);
	}
	public String getUseFlag() {
		return getString(USE_FLAG);
	}
}