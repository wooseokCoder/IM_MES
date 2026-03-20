package com.wsc.framework.utils;


public class MybatisUtils {

	public static boolean empty(Object o) {
		
		if (o == null)
			return true;
		else if (o.toString().length() == 0)
			return true;
		else if ("null".equals(o.toString()))
			return true;
		
		return false;
	}
    
   public static boolean notEmpty(Object o){
       return !empty(o);
   }
   
	public static boolean equal(Object o1, Object o2) {
		
		if (o1 == null && o2== null)
			return true;
		else if (o1.toString().length() == 0 && o2.toString().length()== 0 )
			return true;
		else if (o1.toString().equals(o2.toString()))
			return true;
		
		return false;
	}
	
    public static boolean notEqual(Object o1, Object o2){
        return !equal(o1, o2);
    }

    /**
     * List를 구분자로 연결하여 문자열로 반환
     * @param delimiter 구분자
     * @param list 연결할 리스트
     * @return 연결된 문자열 (list가 null이거나 비어있으면 null 반환)
     */
    public static String join(String delimiter, java.util.List<?> list) {
        if (list == null || list.isEmpty()) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(delimiter);
            sb.append(list.get(i));
        }
        return sb.toString();
    }

    /**
     * List를 구분자로 연결하여 각 항목을 작은따옴표로 감싼 문자열로 반환
     * SQL IN 절에 사용하기 위한 메서드
     * @param delimiter 구분자
     * @param list 연결할 리스트
     * @return 연결된 문자열 (예: 'a','b','c') (list가 null이거나 비어있으면 null 반환)
     */
    public static String joinQuoted(String delimiter, java.util.List<?> list) {
        if (list == null || list.isEmpty()) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(delimiter);
            sb.append("'").append(list.get(i)).append("'");
        }
        return sb.toString();
    }

    /**
     * 배열을 구분자로 연결하여 문자열로 반환
     * @param delimiter 구분자
     * @param array 연결할 배열
     * @return 연결된 문자열 (array가 null이거나 비어있으면 null 반환)
     */
    public static String joinArray(String delimiter, Object[] array) {
        if (array == null || array.length == 0) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < array.length; i++) {
            if (i > 0) sb.append(delimiter);
            sb.append(array[i]);
        }
        return sb.toString();
    }

    /**
     * 배열 또는 리스트를 구분자로 연결하여 문자열로 반환 (범용)
     * @param delimiter 구분자
     * @param obj 배열 또는 리스트
     * @return 연결된 문자열
     */
    public static String joinAny(String delimiter, Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof java.util.List) {
            return join(delimiter, (java.util.List<?>) obj);
        }
        if (obj.getClass().isArray()) {
            return joinArray(delimiter, (Object[]) obj);
        }
        return obj.toString();
    }

    /**
     * 배열 또는 리스트가 비어있지 않은지 확인
     * @param obj 배열 또는 리스트
     * @return 비어있지 않으면 true
     */
    public static boolean hasElements(Object obj) {
        if (obj == null) {
            return false;
        }
        if (obj instanceof java.util.List) {
            return !((java.util.List<?>) obj).isEmpty();
        }
        if (obj.getClass().isArray()) {
            return ((Object[]) obj).length > 0;
        }
        return false;
    }
}
