package com.wsc.framework.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.RandomAccessFile;
import java.io.Reader;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;

@SuppressWarnings("unchecked")
public class BaseUtils {

    public static String toKor(String input) throws Exception {
    	String output = null;
    	if ( input != null ) {
    		output = new String(input.getBytes("8859_1"),"KSC5601");
    	}
    	return output;
    }

    public static String toAsc(String input) throws Exception {
    	String output = null;
    	if ( input != null ) {
    		output = new String(input.getBytes("KSC5601"),"8859_1");
    	}
    	return output;
    }
    
	public static String nl2br(String str) {
	  str= str.replaceAll("\r\n", "<br>");
	  str= str.replaceAll("\r", "<br>");
	  str= str.replaceAll("\n", "<br>");

	  return str;
	 }

	@SuppressWarnings("rawtypes")
	public static String createParameter(HttpServletRequest request,
			String[] excludedParameters) throws Exception {
		StringBuffer sb = new StringBuffer();

		Enumeration enums = request.getParameterNames();

		while (enums.hasMoreElements()) {
			String paramName = (String) enums.nextElement();

			if (contains(excludedParameters, paramName) != true) {
				sb.append(paramName);
				sb.append("=");
				//sb.append(StringUtils.toKor(request.getParameter(paramName)));
				sb.append(request.getParameter(paramName));
				sb.append("&&");
			}
		}

		return sb.toString();
	}

	private static boolean contains(String[] array, String str) {

		for (int i = 0; i < array.length; i++) {
			String string = array[i];

			if (string.equals(str)) {
				return true;
			}
		}

		return false;
	}
	// 특정일(yyyyMMdd) 에서 주어진 일자만큼 더한 날짜를 계산한다.
	public static String addDate(String date, String gubn, int rday) {
		if (date == null)
			return null;

		if (date.length() < 8)
			return ""; // 최소 8 자리

		String time = "";

		TimeZone kst = TimeZone.getTimeZone("JST");
		TimeZone.setDefault(kst);

		Calendar cal = Calendar.getInstance(kst); // 현재

		int yyyy = Integer.parseInt(date.substring(0, 4));
		int mm = Integer.parseInt(date.substring(4, 6));
		int dd = Integer.parseInt(date.substring(6, 8));

		cal.set(yyyy, mm - 1, dd); // 카렌더를 주어진 date 로 세팅하고
		cal.add(Calendar.DATE, rday); // 그 날자에서 주어진 rday 만큼 더한다.

		String strYear = Integer.toString(cal.get(Calendar.YEAR)); // 년도
		String strMonth = Integer.toString(cal.get(Calendar.MONTH) + 1); // 월
		String strDay = Integer.toString(cal.get(Calendar.DAY_OF_MONTH)); // 일

		if (strMonth.length() < 2)
			strMonth = "0" + strMonth;
		if (strDay.length() < 2)
			strDay = "0" + strDay;

		time = strYear + gubn + strMonth + gubn + strDay;

		return time;
	}

	// adds days to calendar by n.
	public static Calendar addDays(Calendar cal, int n) {
		Calendar res = Calendar.getInstance();
		res.setTime(cal.getTime());
		res.add(Calendar.DATE, n);
		return res;
	}

	public static String addDays(String strDate, int n) {
		String res = "";
		Calendar cal = strToCalendar(strDate);
		if (cal != null) {
			res = calendarToStr(addDays(cal, n));
		}
		return res;
	}

	// adds months to calendar by n.
	public static Calendar addMonths(Calendar cal, int n) {
		Calendar res = Calendar.getInstance();
		res.setTime(cal.getTime());
		res.add(Calendar.MONTH, n);
		return res;
	}

	public static String addMonths(String strDate, int n) {
		String res = "";
		Calendar cal = strToCalendar(strDate);
		if (cal != null) {
			res = calendarToStr(addMonths(cal, n));
		}
		return res;
	}

	// convert Calendar to string with default pattern; yyyyMMdd is default
	// date-format !!!
	public static String calendarToStr(Calendar cal) {
		return dateFormat("yyyyMMdd", cal);
	}

	public static char charAt(String str, int n) {
		if (str != null && str.length() > n)
			return str.charAt(n);
		return ' ';
	}

	public static boolean compare(String dt1, String dt2, String oper) {
		if ("<".equals(oper)) {
			if (isLessThan(dt1, dt2))
				return true; // dt1 < dt2
		} else if (">".equals(oper)) {
			if (isLessThan(dt2, dt1))
				return true; // dt1 > dt2
		} else if ("<=".equals(oper)) {
			if (isLessEqual(dt1, dt2))
				return true; // dt1 <= dt2
		} else if (">=".equals(oper)) {
			if (isLessEqual(dt2, dt1))
				return true; // dt1 >= dt2
		}
		return false;
	}

	public static String concat(String str, String pos) {
		if (str != null && pos != null) {
			if (pos.length() > str.length()) {
				return str;
			}
			int cut = str.length() - pos.length();
			String pre = str.substring(0, cut);
			return pre + pos;
		}
		return null;
	}

	// [COMMON] insert sepeartion string(or char) into the string.
	// sepString("0123456789",'-',4,5) => "0123-456789".
	public static String concat(String str, String sep, int[] ind) {
		String res = "";
		int s1 = 0, s2 = 0;
		try {
			for (int i = 0; i < ind.length; i++) {
				s2 += ind[i];
				res += str.substring(s1, s2);
				if (s2 < str.length())
					res += sep;
				s1 = s2;
			}
		} catch (Exception e) {
		}
		if (s1 < str.length())
			res += str.substring(s1);
		return res;
	}

	public static String concatComa(String[] arr) {
		String str = "";
		if (arr != null) {
			int n = 0;
			for (int i = 0; i < arr.length; i++) {
				if (!empty(arr[i])) {
					if (n > 0)
						str += ",";
					str += "'" + arr[i] + "'";
					n++;
				}
			}
		}
		return str;
	}

	//콤마로 묶어서 반환한다.
	public static String concatArray(String[] arr) {
		String str = "";
		if (arr != null) {
			int n = 0;
			for (int i = 0; i < arr.length; i++) {
				if (!empty(arr[i])) {
					if (n > 0)
						str += ",";
					str += arr[i];
					n++;
				}
			}
		}
		return str;
	}

	//콤마로 묶어서 반환한다.
    @SuppressWarnings("rawtypes")
	public static String concatList(List list) {
		String str = "";
		if (list != null) {
			int n = 0;
			for (int i = 0; i < list.size(); i++) {
				if (!empty((String)list.get(i))) {
					if (n > 0)
						str += ",";
					str += (String)list.get(i);
					n++;
				}
			}
		}
		return str;
	}

	public static String convertCharset(String str, String enc1, String enc2) {
		try {
			return new String(str.getBytes(enc1), enc2);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str;
	}

	// YYYY-MM-DD ==> YYYYMMDD format으로
	public static String convertDate(String date) {
		if(empty(date))
			return date;
		return formatDate("yyyyMMdd", date);
	}

	public static double currStrToDouble(String str) {
		return currStrToDouble(str, 0);
	}

	// converts a string value with ',' char to double value. //
	public static double currStrToDouble(String str, double defaultValue) {
		String s = "";
		for (int i = 0; i < str.length(); i++) {
			char c = str.charAt(i);
			if ((c >= '0' && c <= '9') || (c == '.') || (c == '-')
					|| (c == '+')) {
				s += c;
			}
		}
		return strToDouble(s, defaultValue);
	}

	public static int currStrToInt(String str) {
		return currStrToInt(str, 0);
	}

	// converts a string value with ',' char to integer value. //
	public static int currStrToInt(String str, int defaultValue) {
		String s = "";
		for (int i = 0; i < str.length(); i++) {
			char c = str.charAt(i);
			if ((c >= '0' && c <= '9') || (c == '.') || (c == '-')
					|| (c == '+')) {
				s += c;
			}
		}
		return strToInt(s, defaultValue);
	}

	public static long currStrToLong(String str) {
		return currStrToLong(str, 0);
	}

	// converts a string value with ',' char to long-integer value. //
	public static long currStrToLong(String str, long defaultValue) {
		String s = "";
		for (int i = 0; i < str.length(); i++) {
			char c = str.charAt(i);
			if ((c >= '0' && c <= '9') || (c == '.') || (c == '-')
					|| (c == '+')) {
				s += c;
			}
		}
		return strToLong(s, defaultValue);
	}

	public static String cut(String str, int start, int len) {
		if (isGreaterThan(str, start + len)) {
			return str.substring(start, start + len);
		} else if (isGreaterThan(str, start)) {
			return str.substring(start, str.length());
		}
		return "";
	}

	// Byte 단위로 문자를 자른다.
	public static String cutByte(String s, int begin, int end) {
		int rlen = 0;
		int sbegin = 0;
		int send = 0;

		for (sbegin = 0; sbegin < s.length(); sbegin++) {
			if (s.charAt(sbegin) > 0x007f) {
				rlen += 2;
				if (rlen > begin) {
					rlen -= 2;
					break;
				}
			} else {
				rlen++;
				if (rlen > begin) {
					rlen--;
					break;
				}
			}
		}

		for (send = sbegin; send < s.length(); send++) {
			if (s.charAt(send) > 0x007f) {
				rlen += 2;
			} else {
				rlen++;
			}
			if (rlen > end)
				break;
		}
		return s.substring(sbegin, send);
	}

	public static double cutDouble(String str, int start, int len) {
		str = cut(str, start, len).trim();
		return toDouble(str);
	}

	public static int cutInt(String str, int start, int len) {
		str = cut(str, start, len).trim();
		return toInt(str);
	}

	public static long cutLong(String str, int start, int len) {
		str = cut(str, start, len).trim();
		return toLong(str);
	}

	public static String cutLower(String str, int start, int len) {
		return cut(str, start, len).toLowerCase();
	}

	public static String cutRight(String str, int cnt) {
		if (str != null) {
			int len = str.length();
			if (cnt > len) {
				return str;
			}
			return str.substring(len - cnt, len);
		}
		return null;
	}

	// Title 자르기
	public static String cutTitle(String title, int len) {
		if (title != null && title.length() > len) {
			return title.substring(0, len) + "...";
		}
		return title;
	}

	public static String cutTrim(String str, int start, int len) {
		return cut(str, start, len).trim();
	}

	public static String cutUpper(String str, int start, int len) {
		return cut(str, start, len).toUpperCase();
	}

	// apply pattern to a Calendar
	public static String dateFormat(String pattern, Calendar cal) {
		String res;
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat(pattern, Locale.KOREA);
		res = formatter.format(cal.getTime());
		return res;
	}

	// apply pattern to a Date
	// y : year, M : month in year, d : day in month,
	// h : hour in am/pm (1~12), H : hour in day (0~23), m : minute in hour, s :
	// second in minute
	public static String dateFormat(String pattern, Date date) {
		String res;
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat(pattern, Locale.KOREA);
		res = formatter.format(date);
		return res;
	}

	// apply pattern to a String-date
	public static String dateFormat(String pattern, String strDate) {
		String res = "";
		Calendar cal = strToCalendar(strDate);
		if (cal != null) {
			res = dateFormat(pattern, cal);
		}
		return res;
	}

	// day difference between cal1 and cal2.
	public static int dayDiff(Calendar cal1, Calendar cal2) {
		long diff = cal2.getTime().getTime() - cal1.getTime().getTime();
		return (int) (diff / 24 / 60 / 60 / 1000);
	}

	public static int dayDiff(String strDate1, String strDate2) {
		int diff = dayDiff(strToCalendar(strDate2), strToCalendar(strDate1));
		return diff;
	}

	// days of month (daysOfMonth("2000-02-01") => 29)
	public static int daysOfMonth(Calendar cal) {
		Calendar nextMonth = addMonths(cal, 1);
		int yy = getYear(nextMonth);
		int mm = getMonth(nextMonth);
		return getDay(addDays(getCalendar(yy, mm, 1), -1));
	}

	public static int daysOfMonth(String strDate) {
		return daysOfMonth(strToCalendar(strDate));
	}

	// remove non-numeric char from a string.
	public static String delNonNum(String str) {
		String s = "";
		for (int i = 0; i < str.length(); i++) {
			char c = str.charAt(i);
			if (c >= '0' && c <= '9') {
				s += c;
			}
		}
		return s;
	}
	// remove non-numeric char from a string.
	public static String delNonDouble(String str) {
		String s = "";
		for (int i = 0; i < str.length(); i++) {
			char c = str.charAt(i);
			if (c >= '0' && c <= '9' || c == '.' || c == '-') {
				s += c;
			}
		}
		return s;
	}

	public static void deltFile(String fullName) {
		File f = new File(fullName);
		if (f.exists()) {
			f.delete();
		}
	}

	public static boolean empty(String str) {
		if (str == null || str.length() == 0)
			return true;
		return false;
	}

	public static String encode(String str, String from, String to) {
		String value = "";
		try {
			value = new String(str.getBytes(from), to);
		} catch (Exception e) {
		}
		return value;
	}

	public static boolean equal(String str1, String str2) {
		if (str1 == null && str2 == null)
			return true;
		if (str1 == null || str2 == null)
			return false;
		if (str1.equals(str2))
			return true;
		return false;
	}

	/**
	 * 입력받은 배열에 입력받은 문자열이 있는지 체크하여 있으면 TRUE를 반환한다.
	 *
	 * @param str
	 *            String[]
	 * @param s
	 * @return boolean
	 */
	public static boolean exist(String[] str, String s) {
		if (s != null && str != null && str.length > 0) {
			for (int i = 0; i < str.length; i++) {
				if (s.equals(str[i])) {
					return true;
				}
			}
		}
		return false;
	}

	public static boolean existFile(String fullName) {
		File f = new File(fullName);
		if (f.exists())
			return true;
		return false;
	}

	// 입력받은 배열에 입력받은 문자열이 있는지 체크하여 있으면 INDEX를 반환한다.
	public static int existIndex(String[] str, String s) {
		if (s != null && str != null && str.length > 0) {
			for (int i = 0; i < str.length; i++) {
				if (s.equals(str[i])) {
					return i;
				}
			}
		}
		return -1;
	}

	//String List 객체의 체크
    @SuppressWarnings("rawtypes")
	public static boolean existList(List list, String str) {
		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				String org = (String) list.get(i);
				if (equal(org, str)) {
					return true;
				}
			}
		}
		return false;
	}

	//Map List 객체의 체크
    @SuppressWarnings("rawtypes")
	public static boolean existList(List list, String str, String key) {
		if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				Map obj = (Map)list.get(i);
				String org = (String) obj.get(key);
				if (equal(org, str)) {
					return true;
				}
			}
		}
		return false;
	}

	public static String fill(char c, int len) {
		String ret = "";
		for (int i = 0; i < len; i++) {
			ret += c;
		}
		return ret;
	}

	/**
	 * [2006.03.21] 통화형식의 문자열로 변환하여 반환한다.
	 *
	 * @param n
	 *            long 타입의 변환할 숫자
	 * @return 통화형식으로 변환된 문자열 ( ex. 21000 → 21,000 )
	 */
	public static String format(long n) {
		NumberFormat nf = NumberFormat.getNumberInstance();
		return nf.format(n);
	}

	/**
	 * [2006.03.21] 통화형식의 문자열로 변환하여 반환한다.
	 *
	 * @paramstrn String 타입의 변환할 숫자
	 * @return 통화형식으로 변환된 문자열 ( ex. 21000 → 21,000 )
	 */
	public static String formatCrrency(String str) {
		if (str == null || str.length() == 0)
			return "0";
		str = replace(str, ",", "");
		long n = 0;
		try {
			n = Long.parseLong(str);
		} catch (NumberFormatException e) {
		}
		NumberFormat nf = NumberFormat.getNumberInstance();
		return nf.format(n);
	}

	// 현재날짜를 yyyyMMdd format 으로
	public static String formatCurDate() {
		return formatDate("yyyyMMdd", getCurCalendar());
	}
	// 현재시간을 HHmmss format 으로
	public static String formatCurTime() {
		return formatDate("HHmmss", getCurCalendar());
	}
	public static String formatCurDate(String pattern) {
		return formatDate(pattern, getCurCalendar());
	}
	
	//현재달의 첫째날을 YYYMMDD format으로
	public static String formatCurFirstDate() {
		return formatDate(getFirstDate(getCurCalendar()));
	}
	//현재달의 마지막날을 YYYMMDD format으로
	public static String formatCurLastDate() {
		return formatDate(getLastDate(getCurCalendar()));
	}
	
	// 현재날짜를 YYYY-MM-DD format으로
	public static String formatDate() {
		return formatDate("yyyy-MM-dd", getCurCalendar());
	}

	public static String formatCurMonh() {
		return formatDate("yyyyMM", getCurCalendar());
	}

	public static String formatDate(Calendar cal) {
		return formatDate("yyyyMMdd", cal);
	}

	/**
	 * [2006.03.21] 입력받은 문자열을 날짜 형식으로 변환하여 반환한다.
	 *
	 * @param str
	 *            날짜 문자열
	 * @return 일정포맷의 날짜 ( ex.20060101 -> 2006-01-01 )
	 */
	public static String formatDate(String str) {

		if (str == null)
			return "";

		String s = str.replaceAll("-", "");

		if (s.length() == 8) {
			return s.substring(0, 4) + "-" + s.substring(4, 6) + "-"
					+ s.substring(6, s.length());
		} else if (s.length() == 6) {
			return s.substring(0, 4) + "-" + s.substring(4, 6);
		}
		return str;
	}

	public static String formatDate(String pattern, Calendar cal) {
		SimpleDateFormat f = new SimpleDateFormat(pattern, Locale.KOREA);
		return f.format(cal.getTime());
	}

	// apply pattern to a Date
	// y : year, M : month in year, d : day in month,
	// h : hour in am/pm (1~12), H : hour in day (0~23), m : minute in hour, s :
	// second in minute
	public static String formatDate(String pattern, Date d) {
		SimpleDateFormat f = new SimpleDateFormat(pattern, Locale.KOREA);
		return f.format(d);
	}

	public static String formatDate(String pattern, String strDate) {
		if(strDate == null)
			return null;
		SimpleDateFormat f = new SimpleDateFormat(pattern, Locale.KOREA);
		Calendar cal = toCalendar(strDate);
		return f.format(cal.getTime());
	}

	// 입력받은 문자열을 날짜와 시간 형식으로 변환하여 반환한다. ( ex.20060101011330 -> 2006-01-01 01:13:30 )
	public static String formatDateTime(String str) {
		if (str == null)
			return "";
		String s = str.replaceAll("-", "");
		String ret = "";
		if (s.length() >= 6)
			ret = s.substring(0, 4) + "-" + s.substring(4, 6);
		if (s.length() >= 8)
			ret += "-" + s.substring(6, 8);
		if (s.length() >= 12) {
			ret += " " + s.substring(8, 10);
			ret += ":" + s.substring(10, 12);
		}
		if (s.length() >= 14)
			ret += ":" + s.substring(12, 14);
		return ret;
	}

	public static String formatDouble(double n) {
		return formatDouble("###,###,###,###,###,##0.00", n);
		// NumberFormat nf = NumberFormat.getNumberInstance();
		// nf.setParseIntegerOnly(true);
		// return nf.format(n);
	}

	public static String formatDouble(double n, int digit) {
		String s = fill('#', digit);
		DecimalFormat df = new DecimalFormat("#." + s);
		return df.format(n);
	}

	// apply pattern to a number formatDouble("###,###', 123456) => "123,456"
	public static String formatDouble(String pattern, double value) {
		DecimalFormat df = new DecimalFormat(pattern);
		df.setParseIntegerOnly(true);
		return df.format(value);
	}

	public static String formatDoubleNo(double seq, int len) {
		return lpad(String.valueOf(seq), len, "0");
	}

	public static String formatDSeq(double seq, int len) {
		return lpad(String.valueOf(seq), len, "0");
	}

	public static String formatInt(int n) {
		NumberFormat nf = NumberFormat.getNumberInstance();
		return nf.format(n);
	}

	public static String formatIntNo(int seq, int len) {
		return lpad(String.valueOf(seq), len, "0");
	}

	// 통화형식의 문자열로 변환하여 반환한다.
	// @param n long 타입의 변환할 숫자
	// @return 통화형식으로 변환된 문자열 ( ex. 21000 → 21,000 )
	public static String formatLong(long n) {
		NumberFormat nf = NumberFormat.getNumberInstance();
		return nf.format(n);
	}
	public static String formatLongTime(long longTime, String pattern) {
		java.util.Date dateTime     = new java.util.Date();
		SimpleDateFormat sdf 		= new SimpleDateFormat(pattern);

		dateTime.setTime(longTime);

		return sdf.format(dateTime);
	}
	public static String formatLongNo(long seq, int len) {
		return lpad(String.valueOf(seq), len, "0");
	}

	public static String formatSeq(long seq, int len) {
		return lpad(String.valueOf(seq), len, "0");
	}

	/**
	 * [2006.03.21] 입력받은 문자열을 주민등록번호 형식으로 변환하여 반환한다.
	 *
	 * @param str
	 *            주민등록번호 문자열
	 * @return 일정포맷의 주민등록번호 ( ex.800101-1035611 )
	 */
	public static String formatSSN(String str) {

		if (str == null)
			return "";

		String s = str.replaceAll("-", "");

		if (s.length() == 13) {
			return s.substring(0, 6) + "-" + s.substring(6, s.length());
		}
		return str;
	}


	/**
	 * 사업자번호를 해당 형식으로 변환(0000000000 -> 000-00-00000)
	 */
	public static String formatBSN(String str) {

		if (str == null)
			return "";

		String s = str.replaceAll("-", "");

		if (s.length() == 10) {
			return cut(s, 0, 3)+"-"+cut(s, 3, 2)+"-"+cut(s, 5, 5);
		}
		return str;
	}

	// apply pattern to a string : formatString("###,###", "123456") =>
	// "123,456"
	public static String formatString(String pattern, String value) {
		try {
			DecimalFormat df = new DecimalFormat(pattern);
			Double v = new Double(0.);
			v = Double.valueOf(value);
			return df.format(v.doubleValue());
		} catch (Exception e) {
		}
		return "";
	}

	// JSP에 Script문장으로 바꿀때 변환
	public static String forScript(String script) {
		String s = "";
		for (int i = 0; i < script.length(); i++) {
			char c = script.charAt(i);
			if (c == '\n') {
				s += "\\n";
			} else if (c == '\'') {
				s += "\\\'";
			} else if (c == '\"') {
				s += "\\\"";
			} else {
				s += c;
			}
		}
		return s;
	}

	// JSP에 Script문장을 만들때 CRLF를 "\n"의 String으로 변환.
	public static String forScriptCRLF(String script) {
		String s = "";
		for (int i = 0; i < script.length(); i++) {
			char c = script.charAt(i);
			if (c == '\n') {
				s += "\\n";
			} else {
				s += c;
			}
		}
		return s;
	}

	public static byte[] getAsciiBytes(String buf) {
		int size = buf.length();
		byte[] bytebuf = new byte[size];

		for (int i = 0; i < size; i++) {
			bytebuf[i] = (byte) buf.charAt(i);
		}
		return bytebuf;
	}

	public static String getAsciiString(byte[] bytebuf) {
		int size = bytebuf.length;
		StringBuffer buf = new StringBuffer();

		for (int i = 0; i < size; i++) {
			buf.append((char) bytebuf[i]);
		}
		return buf.toString();
	}

	// /////////////////////////////////////////////////////
	public static String getBBSDate() {
		// 날짜 계산..
		Calendar c = Calendar.getInstance();
		String date1 = "" + c.get(Calendar.YEAR) + "/";
		String month = "" + (c.get(Calendar.MONTH) + 1);
		if (month.length() == 1) {
			month = "0" + month;
		}
		date1 += month + "/";
		String date = "" + c.get(Calendar.DATE);
		if (date.length() == 1) {
			date = "0" + date;
		}
		date1 += date + "/";
		String hour = "" + c.get(Calendar.HOUR);
		if (hour.length() == 1) {
			hour = "0" + hour;
		}
		date1 += hour + "/";
		String min = "" + c.get(Calendar.MINUTE);
		if (min.length() == 1) {
			min = "0" + min;
		}
		date1 += min + "/";
		String am = "" + c.get(Calendar.AM_PM);
		date1 += am;
		// 날짜 계산 끝

		return date1;
	}

	public static Calendar getCalendar(int year, int month, int day) {
		Calendar cal = null;
		try {
			cal = Calendar.getInstance();
			cal.setLenient(false);
			cal.set(year, month - 1, day);
			cal.getTime();
		} catch (Exception e) {
		}
		return cal;
	}

	// ====================================================== Date & Calendar
	// Utils ======================================================
	public static Calendar getCurCalendar() {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		// Date current = new Date(System.currentTimeMillis() );
		return (cal);
	}

	public static Calendar getCurDate() {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		return (cal);
	}

	public static String getCurDateStr() {
		return (calendarToStr(getCurDate()));
	}

	// 현재 날짜를 YYYYMMDD format으로 Return
//	public static String getCurDateString() {
//		return formatDate("yyyyMMdd", getCurCalendar());
//	}

	// 현재 날짜를 YYYY-MM-DD HH24:MI:SS format으로 Return
//	public static String getCurDateTime() {
//		return formatDate("yyyy-MM-dd HH:mm:ss", getCurCalendar());
//	}

	public static String getCurKorDate() {

		String s = "";
		Calendar c = getCurDate();

		s += c.get(Calendar.YEAR) + "년 ";
		s += (c.get(Calendar.MONTH) + 1) + "월 ";
		s += c.get(Calendar.DAY_OF_MONTH) + "일";

		return s;
	}

	public static String getCurrDate() {
		return (dateFormat("yyyyMMddHHmmss", new Date())).substring(0, 16);
	}

	public static int getCurrDay() {
		return getDay(getCurCalendar());
	}

	public static int getCurrYear() {
		return getYear(getCurCalendar());
	}
	public static int getCurrMonth() {
		return getMonth(getCurCalendar());
	}

	// 현재 날짜를 YYYYMMDDHH24MISS format으로 Return
	public static String getCurTimeString() {
		return formatDate("yyyyMMddHHmmss", getCurCalendar());
	}

	// 현재 시간
	public static String getCurrHour() {
		return formatDate("HH", getCurCalendar());
	}
	// 현재 분
	public static String getCurrMinute() {
		return formatDate("mm", getCurCalendar());
	}
	// 현재 초
	public static String getCurrSecond() {
		return formatDate("ss", getCurCalendar());
	}

	public static String getDate() {
		// 날짜 계산..
		Calendar c = Calendar.getInstance();
		String date1 = "" + c.get(Calendar.YEAR);
		String month = "" + (c.get(Calendar.MONTH) + 1);
		if (month.length() == 1) {
			month = "0" + month;
		}
		date1 += month;
		String date = "" + c.get(Calendar.DATE);
		if (date.length() == 1) {
			date = "0" + date;
		}
		date1 += date;
		String hour = "" + c.get(Calendar.HOUR_OF_DAY);
		if (hour.length() == 1) {
			hour = "0" + hour;
		}
		date1 += hour;
		String min = "" + c.get(Calendar.MINUTE);
		if (min.length() == 1) {
			min = "0" + min;
		}
		date1 += min;
		// 날짜 계산 끝

		return date1;
	}

	// get day of month from calendar.
	public static int getDay(Calendar cal) {
		int res = 0;
		if (cal != null)
			res = cal.get(Calendar.DATE);
		return res;
	}

	public static int getDay(String strDate) {
		return (getDay(strToCalendar(strDate)));
	}

	// get the days counted from the epoch.
	public static double getDaysValue(Calendar cal) {
		return cal.getTime().getTime() / (24 * 60 * 60 * 1000);
	}

	public static double getDaysValue(String strDate) {
		return getDaysValue(strToCalendar(strDate));
	}

	// 파일을 읽어서 ArrayList에 담아서 리턴.
    @SuppressWarnings("rawtypes")
	public static ArrayList getFileRead(String fileName) {
		RandomAccessFile rsFile = null;
		ArrayList array = new ArrayList();
		String contents = null;
		String dirFile = fileName;
		try {
			rsFile = new RandomAccessFile(dirFile, "r");// 파일 읽기

			while ((contents = rsFile.readLine()) != null) {
				array.add(contents);
			}
		} catch (FileNotFoundException fe) {
			fe.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			try {
				if (rsFile != null) {
					rsFile.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return array;
	}

	// 파일로 writing 할때 writer 를 생성한다.
	public static PrintWriter getFileWriter(String f) throws Exception {
		return getFileWriter(f, false);
	}

	// 파일로 writing 할때 writer 를 생성한다. 기존파일이 있는 경우에는 append 가 true 이면 이어서 write 하고
	// false 이면 내용를 지우고 새로 write 하게 된다.
	public static PrintWriter getFileWriter(String f, boolean add)
			throws Exception {
		PrintWriter out = null;
		try {
			out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(
					f, add), "KSC5601"));
		} catch (Exception e) {
		}
		return out;
	}

	public static Calendar getFirstDate(Calendar cal) {
		return getCalendar(getYear(cal), getMonth(cal), 1);
	}

	public static Calendar getFirstDate(String strDate) {
		return getFirstDate(strToCalendar(strDate));
	}

	public static String getDayOfWeek(Calendar cal) {
		return String.valueOf(cal.get(Calendar.DAY_OF_WEEK));
	}

	public static String getDayOfWeek(String strDate) {
		return getDayOfWeek(strToCalendar(strDate));
	}
	public static String getDayOfWeekKor(String strDate) {
		Calendar cal = strToCalendar(strDate);
		int week = cal.get(Calendar.DAY_OF_WEEK);
		String str = "";
		
		switch(week) {
			case Calendar.SUNDAY	: str = "일"; break;
			case Calendar.MONDAY	: str = "월"; break;
			case Calendar.TUESDAY	: str = "화"; break;
			case Calendar.WEDNESDAY	: str = "수"; break;
			case Calendar.THURSDAY	: str = "목"; break;
			case Calendar.FRIDAY	: str = "금"; break;
			case Calendar.SATURDAY	: str = "토"; break;
		}
		return str;
	}

	public static String getFirstDateStr(Calendar cal) {
		return calendarToStr(getFirstDate(cal));
	}

	public static String getFirstDateStr(String strDate) {
		return calendarToStr(getFirstDate(strDate));
	}

	public static Calendar getLastDate(Calendar cal) {
		return getCalendar(getYear(cal), getMonth(cal), daysOfMonth(cal));
	}

	public static Calendar getLastDate(String strDate) {
		return getLastDate(strToCalendar(strDate));
	}

	public static String getLastDateStr(Calendar cal) {
		return calendarToStr(getLastDate(cal));
	}

	public static String getLastDateStr(String strDate) {
		return calendarToStr(getLastDate(strDate));
	}

	//해당 일자가 속한 반기의 마지막날(YYYYMMDD)
	public static String getHalfLastDate(String strDate) {
		String str = strDate; 
		if(getMonth(strDate) < 7)
			str = getYear(strDate) + "0630";
		else
			str = getYear(strDate) + "1231";
		return str;
	}


	public static String getMonhStr(Calendar c) {
		int m = getMonth(c);
		if (m < 10)
			return "0" + m;
		return String.valueOf(m);
	}

	// get month of year from calendar.
	public static int getMonth(Calendar cal) {
		int res = 0;
		if (cal != null)
			res = cal.get(Calendar.MONTH) + 1;
		return res;
	}

	public static int getMonth(String strDate) {
		return (getMonth(strToCalendar(strDate)));
	}

	// get parameter value from request;safe mode.
	public static String getParam(javax.servlet.http.HttpServletRequest req,
			String name) {
		String value = "";
		if (req != null) {
			value = req.getParameter(name);
			if (value == null) {
				value = "";
			}
		}
		return value;
	}

	// get the seconds counted from the epoch.
	public static double getSecValue(Calendar cal) {
		return cal.getTime().getTime() / 1000;
	}

	public static double getSecValue(String strDate) {
		return getSecValue(strToCalendar(strDate));
	}

	public static String getSysDate() {
		return getCurTimeString();
	}

	// get year from calendar.
	public static int getYear(Calendar cal) {
		int res = 0;
		if (cal != null)
			res = cal.get(Calendar.YEAR);
		return res;
	}

	public static int getYear(String strDate) {
		return (getYear(strToCalendar(strDate)));
	}

	public static String getYearStr(Calendar c) {
		return String.valueOf(getYear(c));
	}

	public static boolean isCharAt(String str, int n, char c) {
		if (str != null && str.length() > n && str.charAt(n) == c)
			return true;
		return false;
	}

	public static boolean isDate(String strDate) {
		return (toCalendar(strDate) != null);
	}

	public static boolean isDouble(String str) {
		try {
			Double.parseDouble(str);
			return true;
		} catch (Exception e) {
		}
		return false;
	}

	// check if requested form has no parameters; i.e. first request from
	// web-browser.
	public static boolean isFirstReq(javax.servlet.http.HttpServletRequest req) {
		return ((req == null) || req.getParameterNames().hasMoreElements() == false);
	}

	public static boolean isGreaterEqual(String str, String org) {
		// str >= org : 0보다 크거나 같다
		if (str != null && str.compareTo(org) >= 0)
			return true;
		return false;
	}

	public static boolean isGreaterThan(String str, int n) {
		if (str != null && str.length() >= n)
			return true;
		return false;
	}

	public static boolean isInt(String str) {
		try {
			Integer.parseInt(str);
			return true;
		} catch (Exception e) {
		}
		return false;
	}

	public static boolean isLen(String str, int len) {
		if (str != null && str.trim().length() == len) {
			return true;
		}
		return false;
	}

	public static boolean isLessEqual(String str, String org) {
		// str <= org : 0보다 작거나 같다
		if (str != null && str.compareTo(org) <= 0)
			return true;
		return false;
	}

	public static boolean isLessThan(String str, int n) {
		if (str != null && str.length() < n)
			return true;
		return false;
	}

	public static boolean isLessThan(String str, String org) {
		// str <= org : 0보다 작거나 같다
		if (str != null && str.compareTo(org) < 0)
			return true;
		return false;
	}

	public static boolean isLong(String str) {
		try {
			Long.parseLong(str);
			return true;
		} catch (Exception e) {
		}
		return false;
	}

	// validate string-date.
	public static boolean isStrValidDate(String strDate) {
		return (strToCalendar(strDate) != null);
	}

	// check if a string is valid double.
	public static boolean isStrValidDouble(String str) {
		boolean res = false;
		try {
			Double.parseDouble(str);
			res = true;
		} catch (Exception e) {
		}
		return res;
	}

	// check if a string is valid integer.
	public static boolean isStrValidInt(String str) {
		boolean res = false;
		try {
			Integer.parseInt(str);
			res = true;
		} catch (Exception e) {
		}
		return res;
	}

	// check if a string is valid long-integer.
	public static boolean isStrValidLong(String str) {
		boolean res = false;
		try {
			Long.parseLong(str);
			res = true;
		} catch (Exception e) {
		}
		return res;
	}

	public static String lpad(String org, int len, String pad) {
		return pad(org, len, pad, 'L'); // 00000AAA
	}

	/*
	// lPad.
	public static String lPad(String orgStr, int len, String padStr) {
		String s = orgStr;
		while (s.length() < len) {
			s = padStr + s;
		}
		return s;
	}
	*/

	public static boolean notEmpty(String[] arr, boolean all) {
		boolean ret = false;
		if (arr != null) {
			for (int i = 0; i < arr.length; i++) {
				if (all) {
					if (empty(arr[i])) {
						ret = false;
						break;
					} else {
						ret = true;
					}
				} else {
					if (!empty(arr[i])) {
						ret = true;
						break;
					}
				}
			}
		}
		return ret;
	}

	// apply pattern to a number
	// numFormat("###,###', 123456) => "123,456"
	public static String numFormat(String pattern, double value) {
		DecimalFormat aFormatter = new DecimalFormat(pattern);
		return (aFormatter.format(value));
	}

	// change null string to blank string //
	public static String nvl(String str) {
		String value = "";
		if (str != null && str.length() > 0) {
			value = str;
		}
		return value;
	}

	public static String nvl(String str, String nvlStr) {
		String value = nvlStr;
		if (str != null && str.length() > 0) {
			value = str;
		}
		return value;
	}
	
	public static String nvlNum(String str) {
		if (str != null && str.length() > 0) {
			return str;
		}
		return "0";
	}

	// [2007.10.18 shlee] 여기부터 신규 메서드
	public static void out(String msg) {
		System.out.println(msg);
	}

	public static String pad(String org, int len, String pad, char pos) {
		String s = org;
		while (s.length() < len) {
			if (pos == 'L')
				s = pad + s;
			else
				s = s + pad;
		}
		return s;
	}

	public static void printout(String msg) {
		System.out.println(msg);
	}

	// put parameter value from request for out;
	public static String putParam(javax.servlet.http.HttpServletRequest req,
			String name) {
		return getParam(req, name);
	}

	// remove non-numeric char from a string.
	public static String removeChar(String str) {
		String s = "";
		for (int i = 0; i < str.length(); i++) {
			char c = str.charAt(i);
			if (c >= '0' && c <= '9') {
				s += c;
			}
		}
		return s;
	}

	public static String removeLine(String str) {
		if (str == null)
			return "";
		str = str.replaceAll("chr(13)&chr(10)", "");
		str = str.replaceAll("\n", "");
		return str;
	}

	public static String replace(String src, String find, String rep) {
		if (src == null)
			return null;
		if (find == null)
			return src;
		if (rep == null)
			rep = "";
		StringBuffer res = new StringBuffer();
		String sp[] = split(src, find);
		res.append(sp[0]);
		for (int i = 1; i < sp.length; i++) {
			res.append(rep);
			res.append(sp[i]);
		}
		return res.toString();
	}

	public static String rpad(String org, int len, String pad) {
		return pad(org, len, pad, 'R'); // AAA00000
	}

	// rPad.
	public static String rPad(String orgStr, int len, String padStr) {
		String s = orgStr;
		while (s.length() < len) {
			s = s + padStr;
		}
		return s;
	}

	// insert sepeartion string(or char) into the string.
	// sepString("0123456789",'-',4,5) => "0123-456789".
	public static String sepString(String str, String sep, int[] ind) {
		String res = "";
		int s1 = 0, s2 = 0;
		try {
			for (int i = 0; i < ind.length; i++) {
				s2 += ind[i];
				res += str.substring(s1, s2);
				if (s2 < str.length())
					res += sep;
				s1 = s2;
			}
		} catch (Exception e) {
		}
		if (s1 < str.length())
			res += str.substring(s1);
		return res;
	}

	/**
	 * 공백으로 byte 배열을 채운다.
	 *
	 * @param b
	 */
	public static void setSpace(byte[] b) {
		try {
			if (b != null) {
				for (int i = 0; i < b.length; i++) {
					b[i] = 32;
				}
			}
		} catch (Exception e) {
		}
	}

	// [COMMON] 공백으로 byte 배열을 채운다.
	public static void setSpaceBytes(byte[] b) {
		try {
			if (b != null) {
				for (int i = 0; i < b.length; i++) {
					b[i] = 32;
				}
			}
		} catch (Exception e) {
		}
	}

    @SuppressWarnings("rawtypes")
	public static String[] split(String src, String delim) {
		if (src == null || delim == null)
			return null;
		ArrayList list = new ArrayList();
		int start = 0, last = 0;
		String term;
		while ((start = src.indexOf(delim, last)) > -1) {
			term = src.substring(last, start);
			list.add(term);
			last = start + delim.length();
		}
		term = src.substring(last, src.length());
		list.add(term);
		String[] res = new String[list.size()];
		list.toArray(res);
		return res;
	}

	// apply pattern to a string
	// strFormat("###,###", "123456") => "123,456"
	public static String strFormat(String pattern, String value) {
		DecimalFormat aFormatter = new DecimalFormat(pattern);
		Double v = new Double(0.);
		String res = "";
		try {
			v = Double.valueOf(value);
			res = aFormatter.format(v.doubleValue());
		} catch (Exception e) {
			res = "";
		}
		return (res);
	}

	// convert string-date to Calendar.
	public static Calendar strToCalendar(String strDate) {
		int y, m, d;
		Calendar cal = null;
		try {
			if (isStrValidInt(strDate)) { // YYYYMMDD Format.
				y = strToInt(strDate.substring(0, 4));
				m = strToInt(strDate.substring(4, 6));
				d = strToInt(strDate.substring(6, 8));
			} else { // YYYY-MM-DD Format.
				int i = 0;
				int j = 0;
				j = strDate.indexOf('-', i);
				y = currStrToInt(strDate.substring(i, j));
				i = ++j;
				j = strDate.indexOf('-', i);
				m = currStrToInt(strDate.substring(i, j));
				i = ++j;
				j = strDate.length();
				d = currStrToInt(strDate.substring(i, j));
			}
			cal = getCalendar(y, m, d);
			cal.getTime();
		} catch (Exception e) {
			cal = null;
		}
		return cal;
	}

	public static double strToDouble(String str) {
		return strToDouble(str, 0);
	}

	// converts string value to double value. //
	public static double strToDouble(String str, double defaultValue) {
		double res = defaultValue;
		try {
			if (str == null || str.length() <= 0) {
				res	= defaultValue;
			} else {
				res = Double.parseDouble(delNonDouble(nvlTrim(str, "0")));
			}
		} catch (Exception e) {
		}
		return res;
	}

	public static int strToInt(String str) {
		return strToInt(str, 0);
	}

	// converts string value to integer value. //
	public static int strToInt(String str, int defaultValue) {
		int res = 0;
		try {
			if (str == null || str.length() <= 0) {
				res = defaultValue;
			} else {
				res = Integer.parseInt(delNonNum(nvlTrim(str, "0")));
			}
		} catch (Exception e) {
		}
		return res;
	}

	public static long strToLong(String str) {
		return strToLong(str, 0L);
	}

	// converts string value to long-integer value. //
	public static long strToLong(String str, long defaultValue) {
		long res = 0;
		try {
			if (str == null || str.length() <= 0) {
				res = defaultValue;
			} else {
				res = Long.parseLong(delNonNum(nvlTrim(str, "0")));
			}
		} catch (Exception e) {
		}
		return res;
	}

	// gbn(ex ",") 으로 한라인 문자를 잘라서 배열에 저장함
    @SuppressWarnings("rawtypes")
	public static String[] toArray(String str, String gbn) {
		String tmp = "";
		String[] retVal;
		Vector v = new Vector();
		StringTokenizer st = new StringTokenizer(str, gbn);
		while (st.hasMoreTokens()) {
			tmp = st.nextToken().trim();
			v.addElement(tmp);
		}
		retVal = new String[v.size()];
		v.copyInto(retVal);
		return retVal;
	}

	public static boolean toBoolean(String str) {
		if ("true".equals(str)) {
			return true;
		}
		return false;
	}

	// convert string-date to Calendar.
	public static Calendar toCalendar(String strDate) {
		int y, m, d;
		Calendar cal = null;
		try {
			// default : YYYYMMDD Format, 그외 : YYYY-MM-DD Format
			if (!isInt(strDate)) {
				strDate = strDate.replaceAll("-", "");
			}
			y = cutInt(strDate, 0, 4);
			m = cutInt(strDate, 4, 2);
			d = cutInt(strDate, 6, 2);
			cal = getCalendar(y, m, d);
			cal.getTime();
		} catch (Exception e) {
			cal = null;
		}
		return cal;
	}

	public static double toDouble(BigDecimal obj) {
		if (obj == null)
			return 0;
		return obj.doubleValue();
	}

	public static double toDouble(String str) {
		return toDouble(str, 0);
	}

	public static double toDouble(String str, double def) {
		try {
			return Double.parseDouble(str);
		} catch (NumberFormatException e) {
		}
		return def;
	}

	/**
	 * 전각문자로 변경한다.
	 *
	 * @param src
	 *            변경할값
	 * @return String 변경된값
	 */
	public static String toFullChar(String src) {
		// 입력된 스트링이 null 이면 null 을 리턴
		if (src == null)
			return null;
		// 변환된 문자들을 쌓아놓을 StringBuffer 를 마련한다
		StringBuffer strBuf = new StringBuffer();
		char c = 0;
		int nSrcLength = src.length();
		for (int i = 0; i < nSrcLength; i++) {
			c = src.charAt(i);
			// 영문이거나 특수 문자 일경우.
			if (c >= 0x21 && c <= 0x7e) {
				c += 0xfee0;
			}
			// 공백일경우
			else if (c == 0x20) {
				c = 0x3000;
			}
			// 문자열 버퍼에 변환된 문자를 쌓는다
			strBuf.append(c);
		}
		return strBuf.toString();
	}

	public static String toHalfChar(String src) {
		StringBuffer strBuf = new StringBuffer();
		char c = 0;
		int nSrcLength = src.length();
		for (int i = 0; i < nSrcLength; i++) {
			c = src.charAt(i);
			// 영문이거나 특수 문자 일경우.
			if (c >= '！' && c <= '～') {
				c -= 0xfee0;
			} else if (c == '　') {
				c = 0x20;
			}
			// 문자열 버퍼에 변환된 문자를 쌓는다
			strBuf.append(c);
		}
		return strBuf.toString();
	}

	public static String toHalfTrim(String src) {
		if (src == null)
			return null;
		String str = toHalfChar(src);
		if (str != null)
			return str.trim();
		return null;
	}

	public static String toHtml(String str) {
		if (str != null) {
			str = replace(str, "'", "&#39;");
			str = replace(str, ",", "&#44;");
		}
		return str;
	}

	public static int toInt(BigDecimal obj) {
		if (obj == null)
			return 0;
		return obj.intValue();
	}

	public static int toInt(String str) {
		return toInt(str, 0);
	}

	public static int toNumber(String str) {
		str = replace(str, ",", "");
		return toInt(str);
	}

	public static long toNumberLong(String str) {
		str = replace(str, ",", "");
		return toLong(str);
	}

	public static int toInt(String str, int def) {
		try {
			return Integer.parseInt(str);
		} catch (NumberFormatException e) {
		}
		return def;
	}

	public static long toLong(BigDecimal obj) {
		if (obj == null)
			return 0;
		return obj.longValue();
	}

	public static long toLong(String str) {
		return toLong(str, 0L);
	}

	public static long toLong(String str, long def) {
		try {
			return Long.parseLong(str);
		} catch (NumberFormatException e) {
		}
		return def;
	}

    @SuppressWarnings("rawtypes")
	public static String toString(HashMap map, String name) {
		if (map != null) {
			BigDecimal obj = (BigDecimal) map.get(name);
			if (obj != null) {
				return obj.toString();
			}
		}
		return "0";
	}

	public static String toText(String str) {
		if (str != null) {
			str = replace(str, "&#39;", "'");
			str = replace(str, "&#44;", ",");
		}
		return str;
	}

	public static String toUpper(String str) {
		if (str == null)
			return null;
		return str.toUpperCase();
	}

	public static String trim(String str) {
		return nvl(str).trim();
	}

	public static int trimSize(String str) {
		return nvl(str).trim().length();
	}

    @SuppressWarnings("rawtypes")
	public static void trimSpace(Object o, String def, String[] excludes) {
		try {
			Class c = o.getClass();

			Field[] fs = c.getDeclaredFields();

			for(int i=0; i<fs.length; i++) {
				if(fs[i].getType().equals(String.class)) {

					if(exist(excludes, fs[i].getName())) {
						continue;
					}
					if(fs[i].isAccessible()) {
						//fs[i].set(o, ((String)fs[i].get(o)).trim());
						fs[i].set(o, ((String)fs[i].get(o)));
						if(empty((String)fs[i].get(o))) {
							fs[i].set(o, def);
						}
					} else {
						String getName = getMethodName("get", fs[i].getName());
						String setName = getMethodName("set", fs[i].getName());
						String val = getMethodValue(o, getName);

						if(	val != null) {
							//setMethodValue(o, setName, val.trim());
							setMethodValue(o, setName, val);
						}
						if(	empty(getMethodValue(o, getName))) {
							setMethodValue(o, setName, def);
						}
					}
				}
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("rawtypes")
	public static boolean equalObject(Object o, Map m, String[] names) {
		
		if (o == null && m == null)
			return true;
		if (o == null)
			return false;
		if (m == null)
			return false;
		if (names == null)
			return false;
		
		for (String name : names) {
			
			if (m.containsKey(name) == false)
				continue;
			
			Object v1 = m.get(name);
			Object v2 = null;

			try {
				String getName = getMethodName("get", name);
				//[2015.06.03] 상위클래스의 메서드도 가져올 수 있도록 수정함.
				Method method = o.getClass().getMethod(getName);
				//Method method = o.getClass().getDeclaredMethod(getName);
				v2 = method.invoke(o);
			} catch (SecurityException e) {
			} catch (NoSuchMethodException e) {
			} catch (IllegalArgumentException e) {
			} catch (IllegalAccessException e) {
			} catch (InvocationTargetException e) {
			}
			
			if (v1 == null)
				continue;
			if (v2 == null)
				return false;
			
			if (v1 instanceof String) {
				
				String vs = (String)v1;
				
				if (v2 instanceof Integer) {
					if(Integer.valueOf(vs).equals(v2) == false)
						return false;
				}
				else if (v2 instanceof Long) {
					if(Long.valueOf(vs).equals(v2) == false)
						return false;
				}
				else if (v2 instanceof Double) {
					if(Double.valueOf(vs).equals(v2) == false)
						return false;
				}
				else {
					if (vs.equals(v2.toString()) == false)
						return false;
				}
			}
			else if (v1.toString().equals(v2.toString()) == false)
				return false;
		}
		return true;
	}
    
	public static void trimSpace(Object o, String def) {
		trimSpace(o, def, null);
	}

	public static String getMethodName(String prefix, String key) {
		if(key == null || key.length() == 0)
			return prefix;

		if(key.length()==1)
			return prefix + key.toUpperCase();

		return prefix+key.substring(0,1).toUpperCase()+key.substring(1);
	}

	public static String getMethodValue(Object o, String getName) {

		try {
			Method gm = o.getClass().getDeclaredMethod(getName);
			if(gm != null && gm.getReturnType().equals(String.class)) {
				return (String)gm.invoke(o);
			}
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static Object getObjectValue(Object o, String prefix, String key) {
		String getName = getMethodName(prefix, key);
		try {
			Method gm = o.getClass().getDeclaredMethod(getName);
			if(gm != null) {
				return gm.invoke(o);
			}
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return null;
	}

	private static void setMethodValue(Object o, String name, String value) {

		try {
			Method gm = o.getClass().getDeclaredMethod(name, new Class[] {String.class} );
			if(gm != null) {
				gm.invoke(o, (Object[])(new String[] { value }));
			}
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
	}

	/*#####################################################################################*/
	/*#***************************  ntarget 추가 부분        Start    **************************#*/
	/*#####################################################################################*/
	public static String nvlTrim(String str) {
		return nvl(str).trim();
	}

	public static String nvlTrim(String str, String defaultStr) {
		String rtn = "";
		if (nvl(str).trim().equals(""))
			rtn = defaultStr;
		else
			rtn = nvl(str).trim();

		return rtn;
	}

	public static String decodeAjax(String s, String charSet) {
		if(s != null) {
			try {
				return URLDecoder.decode(s, charSet);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return s;
	}
	public static String encodeAjax(String s, String charSet) {
		if(s != null) {
			try {
				return URLEncoder.encode(s, charSet);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return s;
	}

	public static String[] decodeAjax(String[] s, String charSet) {

		String[] ss = null;

		if(s != null && s.length > 0) {
			ss = new String[s.length];

			try {
				for (int n = 0; n < s.length; n++) {
					ss[n] = URLDecoder.decode(s[n], charSet);
				}

				return ss;
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return ss;
	}

	// [ntarget] 구분으로 오늘 날짜 가져오기 (한국)
	public static String getToday(String gubun) {
		java.util.Date cdCurrent     = new java.util.Date();
		SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
		String currDate = dateFormat2.format(cdCurrent);

		String strYear = currDate.substring(0,4);
		String strMonth = currDate.substring(4,6);;
		String strDay = currDate.substring(6,8);

		String strToday = strYear +gubun+ strMonth +gubun+ strDay;
		return strToday;
	}

	// [ntarget] gbn(ex ",") 으로 한라인 문자를 잘라서 배열에 저장함
    @SuppressWarnings("rawtypes")
	public static String[] makeToken(String str, String gbn) {

		String tmp="";
		String[] retVal;
		Vector v = new Vector();

		StringTokenizer st = new StringTokenizer(str,gbn);

		while (st.hasMoreTokens()){
				tmp = st.nextToken().trim();
				v.addElement(tmp);
		}
		retVal = new String[v.size()];
		v.copyInto(retVal);
		return retVal;
	}
    @SuppressWarnings("rawtypes")
	public static boolean empty(Object o) {
		if (o == null)
			return true;

        if     ( o instanceof String    ) return "".equals(o.toString().trim());
        else if( o instanceof List      ) return ((List)o).isEmpty();
        else if( o instanceof Map       ) return ((Map)o).isEmpty();
        else if( o instanceof Object[]  ) return Array.getLength(o)==0;
        else if( o instanceof BigDecimal) return ((BigDecimal)o).toString() != "0";

		return true;
	}

	public static int BigCompare(Object o1, Object o2) {
		BigDecimal b1 = (o1 instanceof BigDecimal ? (BigDecimal)o1 : new BigDecimal((String)o1));
		BigDecimal b2 = (o2 instanceof BigDecimal ? (BigDecimal)o2 : new BigDecimal((String)o2));
		return b1.compareTo(b2);
	}

	public static BigDecimal operate(Object o1, Object o2, char oper) {
		if(o1==null || o2==null)
			return null;

		BigDecimal b1 = (o1 instanceof BigDecimal ? (BigDecimal)o1 : new BigDecimal((String)o1));
		BigDecimal b2 = (o2 instanceof BigDecimal ? (BigDecimal)o2 : new BigDecimal((String)o2));
		BigDecimal b3 = null;

		switch(oper) {
			case '+' :  b3 = b1.add(b2);		break;
			case '-' :  b3 = b1.subtract(b2);	break;
			case '*' :  b3 = b1.multiply(b2);	break;
			case '/' :  b3 = b1.divide(b2, 0);	break;
		}
		return b3;
	}

	public static BigDecimal minusDecimal(Object o1, Object o2) {
		return operate(o1, o2, '-');
	}
	public static BigDecimal plusDecimal(Object o1, Object o2) {
		return operate(o1, o2, '+');
	}

	public static String minus(Object o1, Object o2) {
		BigDecimal b3 = minusDecimal(o1, o2);
		if(b3==null)
			return null;
		return b3.toString();
	}

	public static String plus(Object o1, Object o2) {
		BigDecimal b3 = plusDecimal(o1, o2);
		if(b3==null)
			return null;
		return b3.toString();
	}

	public static boolean isZero(Object o) {

		String s = "";

		if(o instanceof BigDecimal) {
			s = ((BigDecimal)o).toString();
		} else {
			s = o.toString();
		}
		if("0".equals(s)) {
			return true;
		}
		return false;
	}

	// Message Window Open
	public static void goMessage(HttpServletResponse res, String msg, String actType) throws IOException {
		PrintWriter out = res.getWriter();
		out.println("<script>");
		out.println(" 	var winW = 400;");
		out.println(" 	var winH = 180;");
		out.println(" 	var reSizeL = (screen.availWidth-winW)/2;");
		out.println(" 	var reSizeT = (screen.availHeight-winH)/2;");
		out.println(" 	var goUrl = \"/comm/message.jsp?msg="+msg+"&actType="+actType+"\"");
		if (!actType.equals("0")) {
			out.println("  	history.go("+actType+");");
		}
		out.println("	window.open(goUrl, 'message','toolbar=no,menubar=no,scrollbars=yes,width=400,height=150,left='+reSizeL+',top='+reSizeT);");
		out.println("</script>");
	}

    // Message Window Open
    public static void errShowModalWindow(HttpServletResponse res, String msg) throws IOException {
        PrintWriter out = res.getWriter();
        out.println(" 	showModalWindow('/com/message.jsp?msg="+msg+"', 'errorMessage', 'dialogHeight:150px;dialogWidth:400px;resizable:no;scroll:no;help:no;status:no;'); ");
    }

	public static void errWinMessage(HttpServletResponse response, String key) throws IOException {
		goMessage(response, key, "-1");
	}

	public static void alertMessage(HttpServletResponse response, String msg) throws IOException {
		PrintWriter out = response.getWriter();
		out.println(" <script>");
		out.println(" 	alert('"+msg+"'); ");
		out.println("  	history.go(-1);");
		out.println(" </script>");
	}

	// [ntarget] Byte 단위로 문자를 자른다.
	public static String substringByte( String s, int begin, int end ) {
		int rlen = 0;
		int sbegin = 0;
		int send = 0;

		for ( sbegin = 0; sbegin < s.length(); sbegin++ ) {
			if ( s.charAt( sbegin ) > 0x007f ) {
				rlen += 2;
				if ( rlen > begin ) {
					rlen -= 2;
					break;
				}
			} else {
				rlen++;
				if ( rlen > begin ) {
					rlen--;
					break;
				}
			}
		}

		for ( send = sbegin; send < s.length(); send++ ) {
			if ( s.charAt( send ) > 0x007f ) {
				rlen += 2;
			} else {
				rlen++;
			}

			if ( rlen > end )
				break;
		}
		return s.substring( sbegin, send );
	}

	// [ntarget] 2007-07-31
	public static String substring (String str, int start, int end) {
		String rtnValue = "";

		str = nvlTrim(str);

		if (str.length() >= end) {
			rtnValue = str.substring(start,end);
		}

		return rtnValue;
	}
	// [ntarget] 2007-07-31
	public static String substring (String str, int start) {
		String rtnValue = "";

		str = nvlTrim(str);

		if (str.length() >= start) {
			rtnValue = str.substring(start);
		}

		return rtnValue;
	}

    public static String Plus(String A, String B) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());
        return B_A.add(B_B).toString();
    }

    public static String Plus(String A, String B, int Scale) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());

        B_A = B_A.add(B_B).setScale(Scale, 1);

        return B_A.toString();
    }

    public static String Minus(String A, String B) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());

        B_A = B_A.add(B_B.negate());

        return B_A.toString();
    }

    public static String Minus(String A, String B, int Scale) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());

        B_A = B_A.add(B_B.negate()).setScale(Scale, 1);

        return B_A.toString();
    }

    public static String Multiply(String A, String B) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());

        B_A = B_A.multiply(B_B);

        return B_A.toString();
    }

    public static String Multiply(String A, String B, int Scale) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());

        B_A = B_A.multiply(B_B).setScale(Scale, 1);

        return B_A.toString();
    }

    public static String Divide(String A, String B) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
        int Scale = 30;
        if(A.equals("0") || B.equals("0")) return "0";

        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());

        B_A = B_A.divide(B_B, Scale, 1);

        return B_A.toString();
    }

    public static String Divide(String A, String B, int Scale) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
    	if(A.equals("0") || B.equals("0")) return "0";
        // Scale이 3일 경우 소수 셋째자리까지보여준다.
        BigDecimal B_A = new BigDecimal(A.trim());
        BigDecimal B_B = new BigDecimal(B.trim());

        B_A = B_A.divide(B_B, Scale, 1);

        return B_A.toString();
    }

    public static String DivideR(String A, String B, int Scale) {
    	A = nvlTrim(A, "0");
    	B = nvlTrim(B, "0");
    	if(A.equals("0") || B.equals("0")) return "0";
    	// Scale이 3일 경우 소수 셋째자리까지보여준다.
    	BigDecimal B_A = new BigDecimal(A.trim());
    	BigDecimal B_B = new BigDecimal(B.trim());

    	B_A = B_A.divide(B_B, Scale, BigDecimal.ROUND_HALF_UP);	// 반올림

    	return B_A.toString();
    }


	// [ntarget] UNIX 명령어 실행
    public static boolean runCommand(String asCmd) {
        try {
            Runtime rt = Runtime.getRuntime();
            Process procs = rt.exec(asCmd);
            procs.waitFor();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

	/*#####################################################################################*/
	/*#***************************  ntarget 추가 부분        End    **************************#*/
	/*#####################################################################################*/

    /**
     * 큰 실수 값을 반환한다.
     *
     * @param key 키
     * @param defaultValue 기본 값
     * @return 값
     */
    public static double getDouble(Object value, double defaultValue) {

        if (value == null) {
            return defaultValue;
        }
        if (value.toString().trim().length() == 0) {
            return defaultValue;
        }

        if(value instanceof Number)
        	return ((Number)value).doubleValue();
       	else
       		return Double.parseDouble(value.toString().trim());
    }


    /**
     * 실수 값을 반환한다.
     *
     * @param key 키
     * @param defaultValue 기본 값
     * @return 값
     */
    public static float getFloat(Object value, float defaultValue) {

        if (value == null) {
            return defaultValue;
        }
        if (value.toString().trim().length() == 0) {
            return defaultValue;
        }

        return Float.parseFloat(value.toString().trim());
    }

    /**
     * 정수 값을 반환한다.
     *
     * @param key 키
     * @param defaultValue 기본 값
     * @return 값
     */
    public static int getInt(Object value, int defaultValue) {

        if (value == null) {
            return defaultValue;
        }
        if (value.toString().trim().length() == 0) {
            return defaultValue;
        }

        return Integer.parseInt(value.toString().trim(), 10);
    }



    /**
     * 큰 정수 값을 반환한다.
     *
     * @param key 키
     * @param defaultValue 기본 값
     * @return 값
     */
    public static long getLong(Object value, long defaultValue) {

        if (value == null) {
            return defaultValue;
        }
        if (value.toString().trim().length() == 0) {
            return defaultValue;
        }

        return Long.parseLong(value.toString().trim(), 10);
    }

    public static boolean getBoolean(Object value, boolean defaultValue) {

        if (value == null) {
            return defaultValue;
        }
        if (String.valueOf(value).trim().length() == 0) {
            return defaultValue;
        }
        return Boolean.valueOf(String.valueOf(value)).booleanValue();
    }

    /**
     * 문자 값을 반환한다.
     *
     * @param key 키
     * @param defaultValue 기본 값
     * @return 값
     */
    public static String getString(Object value, String defaultValue) {

        if (value == null) {
            return defaultValue;
        }
        if (value.toString().trim().length() == 0) {
            return defaultValue;
        }
        return value.toString().trim();
    }
    
    @SuppressWarnings("rawtypes")
	public static double getDouble(Map map, Object key) {
        return getDouble(map.get(key), 0.0D);
    }
    @SuppressWarnings("rawtypes")
    public static float getFloat(Map map, Object key) {
        return getFloat(map.get(key), 0.0F);
    }
    @SuppressWarnings("rawtypes")
    public static int getInt(Map map, Object key) {
        return getInt(map.get(key), 0);
    }
    @SuppressWarnings("rawtypes")
    public static long getLong(Map map, Object key) {
        return getLong(map.get(key), 0L);
    }
    @SuppressWarnings("rawtypes")
    public static boolean getBoolean(Map map, Object key) {
        return getBoolean(map.get(key), false);
    }

    //2011.07 shlee 일자에 해당되는 주간의 첫째날(월요일) 날짜(yyyyMMdd)를 반환한다.
    public static String getWeekFirstDate(String curDate) {
    	
    	Calendar cal = null;
    	if(curDate == null)
    		cal = Calendar.getInstance();
    	else
    		cal = toCalendar(curDate);
    	
    	int week = cal.get(Calendar.DAY_OF_WEEK);	//1=일,2=월,...,7=토
    	int dnum = 0;
    	
    	if(week==Calendar.SUNDAY)
    		dnum = week - 7;
    	else
    		dnum = week-(week-1)*2;
    	
    	cal.add(Calendar.DATE, dnum);
    	
    	return calendarToStr(cal);
    }
    //2011.07 shlee 일자에 해당되는 주간의 마지막날(일요일) 날짜(yyyyMMdd)를 반환한다.
    public static String getWeekLastDate(String curDate) {
    	String fstDate = getWeekFirstDate(curDate);
    	return addDays(fstDate, 6);
    }

    //2011.07 shlee 일자에 해당되는 주간의 요일에 해당되는 날짜(yyyyMMdd)를 반환한다.
    //일 ~ 토 을 하나의 주간으로 간주한다.
    public static String getWeekDate(String curDate, int weekNum) {
    	Calendar cal = null;
    	if(curDate == null)
    		cal = Calendar.getInstance();
    	else
    		cal = toCalendar(curDate);
    	
    	int week = cal.get(Calendar.DAY_OF_WEEK);	//1=일,2=월,...,7=토
    	int dnum = weekNum - week;
    	
    	cal.add(Calendar.DATE, dnum);
    	
    	return calendarToStr(cal);
    }

    //2011.07 shlee 같은달인지 체크한다.
    public static boolean equalMonth(String date1, String date2) {
    	
    	int m1 = getMonth(date1);
    	int m2 = getMonth(date2);
    	
    	if(m1 == m2)
    		return true;
    	return false;
    }
    
    //2011.07 shlee 특정기간 안에 주단위 갯수를 반환한다.
    //stDate	시작기간의 일요일 날짜
    //enDate	종료기간의 토요일 날짜
    public static int getWeekCount(String stDate, String enDate) {
    	//날짜차이
    	int diff = dayDiff(stDate, enDate);
    	return (int)((diff+1) / 7);
    }

    //2011.08 shlee Map 을 List 로 변환한다.
    @SuppressWarnings("rawtypes")
	public static List toList(Map map) {
		
		List list = new ArrayList();
		Iterator it = map.keySet().iterator();
		
		while(it.hasNext()) {
			Map value = (Map)map.get((String)it.next());
			Map item  = new HashMap();
			item.putAll(value);
			
			list.add(item);
		}
		return list;
	}
	
	//2011.08 shlee Map의 빈값에 default값을 셋팅한다.
    @SuppressWarnings("rawtypes")
	public static void setDefaultMap(Map map, Object def) {
		
		Iterator it = map.keySet().iterator();
		
		while(it.hasNext()) {
			String key = (String)it.next();
			setDefaultMap(map, key, def);
		}
	}
	
	//2011.08 shlee Map의 빈값에 default값을 셋팅한다.
    @SuppressWarnings("rawtypes")
	public static void setDefaultMap(Map map, Object key, Object def) {
		
		Object value = map.get(key);

		if(	value == null )
			map.put(key, def);
	}
	
	//2011.08 shlee String byte size 반환
	public static long size(String str) {
		if(str == null || str.trim().length()==0)
			return 0;
		return str.getBytes().length;
	}

	public static long sizeUtf(String str) {
		return size(str, "UTF-8");
	}
	
	//2011.08 shlee String byte size 반환
	public static long size(String str, String encode) {
		if(str == null || str.trim().length()==0)
			return 0;
		try {
			return str.getBytes(encode).length;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str.getBytes().length;
	}

	//2011.09 shlee 고정사이즈만큼 빈 객체를 ADD한다.
    @SuppressWarnings("rawtypes")
	public static void defineFixList(List list, int maxCnt) {
    	
		if( list == null )
    		list = new ArrayList();
		
		int curCnt = list.size();
    	
    	if( curCnt < maxCnt ) {
    		for(int i=0; i < (maxCnt-curCnt); i++) 
    			list.add(new HashMap());
    	}
	}
	
	//2011.09 shlee MAC ADDRESS 가져오기
	public static String getMacAddress(String ipaddr) {
		
		String macAddr = "";
		try {
			InetAddress address = InetAddress.getByName(ipaddr);
			//InetAddress address = InetAddress.getByName("192.168.46.53");
			//InetAddress address = InetAddress.getLocalHost();
			
			//IP 주소가져오기
			//System.out.println("IP = " + address.getHostAddress());
			
			//호스트명 가져오기
			//System.out.println("HOST NAME = " + address.getHostName());
			
			//NetworkInterface를 이용하여 현재 로컬서버에 대한 H/W ADDR을 가져오기
			NetworkInterface ni = NetworkInterface.getByInetAddress(address);

//			ni.getHardwareAddress();
//			/*
			if (ni != null) {
				byte[] mac = ni.getHardwareAddress();
				if (mac != null) {
					for(int i=0; i<mac.length; i++) {
						macAddr += String.format("%02X%s", mac[i], (i < mac.length-1) ? "-" : "");
					}
				} 
				else {
					System.out.println("Address doesn't exist or is not accessible.");
				}
			} 
			else {
				System.out.println("Network Interface for the specified address is not found.");
			}
//			*/
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (SocketException e) {
			e.printStackTrace();
		}
		return macAddr;
	}
	
	// for debugging
    @SuppressWarnings("rawtypes")
	public static void PrintMap(Map map) {
		for (String k:((Map<String,Object>)map).keySet()) {
			System.out.println(k + "->" + map.get(k));
		}
	}
    
 	@SuppressWarnings({ "rawtypes" })
 	public static void removeNulls(List list) {
 		
 		if (list == null)
 			return;
 		
 		for (int i=0; i<list.size(); i++) {
 			Map o = (Map)list.get(i);
 			
 			if (o == null)
 				continue;
 			
 			Iterator it = o.keySet().iterator();
 			while (it.hasNext()) {
 				Object key = it.next();
 				Object val = o.get(key);
 				
 				if (val instanceof String &&
 					"null".equals((String)val))
 					o.put(key, null);
 			}
 		}
 	}
    
 	@SuppressWarnings("rawtypes")
	public static List getJsonList(Map params, String key) {
		if (params == null)
			return null;
		if (key == null)
			return null;
		if (!(params.get(key) instanceof String))
			return null;
		
		String str = (String)params.get(key);
		
		return getJsonList(str);
	}
 	
 	@SuppressWarnings("rawtypes")
	public static List getJsonList(String str) {
 		if (str == null)
 			return null;
 		try {
 			Reader br = new StringReader(str); 
 			JSONParser parser = new JSONParser();
 			Object o = parser.parse(br);
 			List list = null;
 			if (o instanceof JSONArray)
 				list = (JSONArray)o;
 			
 			if (list != null)
 				removeNulls(list);
 			
 			return list;
 			
 		} catch (Exception e) {
 			e.printStackTrace();
 		}
 		return null;
 	}
 	
 	public static final String ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
 	
 	
 	//특정번호(1부터 시작함)에 해당되는 엑셀칼럼의 알파벳 반환
 	public static String getExcelField(int n, boolean zero) {
 		
 		//zero 기준인 경우 
 		if (zero)
 			n++;

 		//알파벳 시작문자열: A (ascii : 65)
 		//알파벳 종료문자열: Z (ascii : 90)
 		//알파벳 문자갯수: 26
 		int len = ALPHA.length();
 		
 		//엑셀칼럼의 알파벳문자열
 		String s = "";
 		//나머지
 		int m = 0;
 		
 		while(n > 0) {
 			//나머지 구하기
 			m = (n - 1) % len;
 			//몫을 알파벳 갯수만큼 나누기
 			n = (n - m) / len;
 			//나머지에 해당되는 문자를 앞에 붙이기
 			s = ALPHA.charAt(m) + s;
 		}
 		return s;
 	}
 	
 	//코드값을 가져오기 위해 SQL IN형태로 만들어준다.
 	public static String codeArray(String[] codeGrupList){
 		StringBuffer result = new StringBuffer();
 		if(codeGrupList.length > 0){
 			for(int i = 0 ; i < codeGrupList.length; i++){
 				if(i == 0){
 					result.append("'");
 					result.append(codeGrupList[i]);
 					result.append("'");
 				}else{
 					result.append(",'");
 					result.append(codeGrupList[i]);
 					result.append("'");
 				}
 			}
 		}
 		return result.toString();
 	}
 	

}
