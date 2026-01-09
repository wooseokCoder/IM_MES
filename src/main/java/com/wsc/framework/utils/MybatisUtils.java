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
}
