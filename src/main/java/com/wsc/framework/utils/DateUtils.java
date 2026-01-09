package com.wsc.framework.utils;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Date util
 * @author
 * @version
 * @see
 */
public final class DateUtils {

    /**
     * @serviceId
     * @param
     * @return
     */
    public static final Calendar nowClearTime() {
        Calendar calendar = Calendar.getInstance();

        return clearTime(calendar);
    }

    /**
     * @serviceId
     * @param date
     * @return
     */
    public static final Date clearTime(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);

        return clearTime(calendar).getTime();
    }

    /**
     * @serviceId
     * @param calendar
     * @return
     */
    public static final Calendar clearTime(Calendar calendar) {
        calendar.set(Calendar.HOUR, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

        return calendar;
    }

    /**
     * @serviceId
     * @param date
     * @param when
     * @return
     */
    public static final boolean beforeOrEqual(Date date, Date when) {
        return date.compareTo(when) <= 0;
    }

    /**
     * @serviceId
     * @param date
     * @param when
     * @return
     */
    public static final boolean before(Date date, Date when) {
        return date.before(when);
    }

    /**
     * @serviceId
     * @param date
     * @param when
     * @return
     */
    public static final boolean afterOrEqual(Date date, Date when) {
        return date.compareTo(when) >= 0;
    }

    /**
     * @serviceId
     * @param date
     * @param when
     * @return
     */
    public static final boolean after(Date date, Date when) {
        return date.after(when);
    }

    /**
     * @serviceId
     * @param date
     * @param when1
     * @param when2
     * @return
     */
    public static final boolean between(Date date, Date when1, Date when2) {
        return afterOrEqual(date, when1) && beforeOrEqual(date, when2);
    }
    
    /**
	* 오늘날짜를 String 형으로 반환
	* @serviceId
	* @param FormatInt
	* 0:yyyy-MM-dd
	* 1:yyyy-MM-dd HH:mm:ss
	* 2:yyyy-MM
	* 3:yyyy
	* 4:MM
	* 5:yyMMddHHmmss
	* 6:yyyyMMddHHmmss
	* 7:yyyyMM
	* @return String
	*/
	public static String getToDate(int FormatInt){

		Date dt = new Date();
		String FormatStr = "yyyy-MM-dd";
		SimpleDateFormat df = null;
		
		if (FormatInt == 1){
			FormatStr = "yyyy-MM-dd HH:mm:ss";
		} else if (FormatInt == 2){
			FormatStr = "yyyy-MM";
		} else if (FormatInt == 3){
			FormatStr = "yyyy";
		} else if (FormatInt == 4){
			FormatStr = "MM";
		} else if (FormatInt == 5){
			FormatStr = "yyMMddHHmmss";
		} else if (FormatInt == 6){
			FormatStr = "yyyyMMddHHmmss";
		} else if (FormatInt == 7) {
			FormatStr = "yyyyMM";
        }else if(FormatInt == 8) {
            FormatStr = "yyyyMMdd";
        }else if(FormatInt == 9) {
            FormatStr = "M";
        }else if(FormatInt == 10) {
            FormatStr = "yyyy-MM-dd";
        }
		
		df = new SimpleDateFormat(FormatStr);
		
		return df.format(dt);

	}
	
    /**
    * 원하는 날짜를 String형으로 반환
    * @serviceId
    * @param FormatInt
    * 0:yyyy-MM-dd
    * 1:yyyy-MM-dd HH:mm:ss
    * 2:yyyy-MM
    * 3:yyyy
    * 4:MM
    * 5:yyMMddHHmmss
    * 6:yyyyMMddHHmmss
    * 7:yyyyMM
    * 8:yyyyMMdd
    * @param setYYYY
    * 연산할 년수의 정수 1, 0 ,-1
    * @param setMM
    * 연산할 월의 정수 1, 0 ,-1
    * @param setDD
    * 연산할 일의 정수 1, 0 ,-1
    * @return String
    */
    public static String getToDate(int FormatInt, int setYYYY, int setMM, int setDD){

        //Date dt = new Date();
        
        String FormatStr = "yyyy-MM-dd";
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat fm  = null;
        String strDate = "";
        
        if (FormatInt == 1){
            FormatStr = "yyyy-MM-dd HH:mm:ss";
        } else if (FormatInt == 2){
            FormatStr = "yyyy-MM";
        } else if (FormatInt == 3){
            FormatStr = "yyyy";
        } else if (FormatInt == 4){
            FormatStr = "MM";
        } else if (FormatInt == 5){
            FormatStr = "yyMMddHHmmss";
        } else if (FormatInt == 6){
            FormatStr = "yyyyMMddHHmmss";
        } else if (FormatInt == 7) {
            FormatStr = "yyyyMM";
        }else if(FormatInt == 8) {
            FormatStr = "yyyyMMdd";
        }else if(FormatInt == 9) {
            FormatStr = "M";
        }else if(FormatInt == 10) {
            FormatStr = "yyyy-MM-dd";
        }else if(FormatInt == 11) {
            FormatStr = "MM.dd.yyyy";
        }else if(FormatInt == 12) {
            FormatStr = "MM.yyyy";
        }else if(FormatInt == 13) {
            FormatStr = "MM.dd.yyyy HH:mm";
        }
        
        cal.setTime(new Date());
        cal.add(Calendar.YEAR, setYYYY); 
        cal.add(Calendar.MONTH, setMM);  
        cal.add(Calendar.DAY_OF_YEAR, setDD); 
         
        fm = new SimpleDateFormat(FormatStr);
        
        strDate = fm.format(cal.getTime());
        
        return strDate;
    }
	
    /*
	public static String removeTag(String str){		
		Matcher mat;  

		// script 처리 
		Pattern script = Pattern.compile("<(no)?script[^>]*>.*?</(no)?script>",Pattern.DOTALL);  
		mat = script.matcher(str);  
		str = mat.replaceAll("");  
		// style 처리
		Pattern style = Pattern.compile("<style[^>]*>.*</style>",Pattern.DOTALL);  
		mat = style.matcher(str);  
		str = mat.replaceAll("");  
		// tag 처리 
		Pattern tag = Pattern.compile("<(\"[^\"]*\"|\'[^\']*\'|[^\'\">])*>");  
		mat = tag.matcher(str);  
		str = mat.replaceAll("");  
		// ntag 처리 
		Pattern ntag = Pattern.compile("<\\w+\\s+[^<]*\\s*>");  
		mat = ntag.matcher(str);  
		str = mat.replaceAll("");  
		// entity ref 처리
		Pattern Eentity = Pattern.compile("&[^;]+;");  
		mat = Eentity.matcher(str);  
		str = mat.replaceAll("");
		// whitespace 처리 
		Pattern wspace = Pattern.compile("\\s\\s+");  
		mat = wspace.matcher(str); 
		str = mat.replaceAll(""); 	          

		return str ;		
	}
	*/
}
