/*
 * @(#)extension.js 1.0 2014/08/01
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */

/**
 * 객체를 확장하는 스크립트이다.
 * 
 * 다음과 같은 객체를 확장한다.
 *
 * =============================================================================
 * Name             Description
 * -----------------------------------------------------------------------------
 * Date             날짜를 조작하는 기능을 제공한다.
 * String           문자를 조작하는 기능을 제공한다.
 * =============================================================================
 *
 * 다음과 같은 함수를 추가한다.
 * 
 * Date:
 * =============================================================================
 * Name             Description
 * -----------------------------------------------------------------------------
 * getLastDate      마지막 일자를 반환한다.
 * format           포맷한 날짜를 반환한다.
 * =============================================================================
 *
 * String:
 * =============================================================================
 * Name             Description
 * -----------------------------------------------------------------------------
 * bytes            문자열의 바이트 배열길이를 반환한다.
 * ellipsis         문자열의 일정한 길이만큼만 반환한다.
 * quota            문자열의 전역의 인용부호를 치환한다.
 * meta             문자열의 정규식 특수문자를 치환한다.
 * trim             문자열의 측면의 특정문자를 제거한다.
 * btrim            문자열의 양측의 특정문자를 제거한다.
 * ltrim            문자열의 좌측의 특정문자를 제거한다.
 * rtrim            문자열의 우측의 특정문자를 제거한다.
 * strip            문자열의 전역의 특정문자를 제거한다.
 * pad              문자열의 측면에 특정문자를 덧붙인다.
 * lpad             문자열의 좌측에 특정문자를 덧붙인다.
 * rpad             문자열의 우측에 특정문자를 덧붙인다.
 * isEmpty          문자열이 널 문자열인지 확인한다.
 * isBlank          문자열이 빈 문자열인지 확인한다.
 * isBytes          문자열의 바이트 배열길이를 확인한다.
 * isLength         문자열의 캐릭터 배열길이를 확인한다.
 * isNumeric        문자열이 숫자인지 확인한다.
 * isInteger        문자열이 정수인지 확인한다.
 * isDecimal        문자열이 실수인지 확인한다.
 * isDate           문자열이 날짜인지 확인한다.
 * isTime           문자열이 시간인지 확인한다.
 * isPhone          문자열이 유선전화번호인지 확인한다.
 * isMobile         문자열이 무선전화번호인지 확인한다.
 * isEmail          문자열이 전자우편주소인지 확인한다.
 * isPostcode       문자열이 배달우편번호인지 확인한다.
 * isResRegNo       문자열이 주민등록번호인지 확인한다.
 * isCorRegNo       문자열이 법인등록번호인지 확인한다.
 * isForRegNo       문자열이 외국인등록번호인지 확인한다.
 * isBizRegNo       문자열이 사업자등록번호인지 확인한다.
 * isIp             문자열이 아이피인지 확인한다.
 * isMac            문자열이 맥주소인지 확인한다.
 * isImage          문자열이 이미지 파일인지 확인한다.
 * isUpload         문자열이 업로드 파일인지 확인한다.
 * isAlpha          문자열이 영어인지 확인한다.
 * isKorean         문자열이 한글인지 확인한다.
 * isAlphaNumeric   문자열이 영어와 숫자인지 확인한다.
 * isKoreanNumeric  문자열이 한글과 숫자인지 확인한다.
 * toNumeric        문자열을 숫자로 변환한다.
 * toInteger        문자열을 정수로 변환한다.
 * toDecimal        문자열을 실수로 변환한다.
 * toCurrency       문자열을 통화로 변환한다.
 * toDate           문자열을 날짜로 변환한다.
 * toTime           문자열을 시간으로 변환한다.
 * toPhone          문자열을 유선전화번호로 변환한다.
 * toMobile         문자열을 무선전화번호로 변환한다.
 * toPostcode       문자열을 배달우편번호로 변환한다.
 * toResRegNo       문자열을 주민등록번호로 변환한다.
 * toCorRegNo       문자열을 법인등록번호로 변환한다.
 * toForRegNo       문자열을 외국인등록번호로 변환한다.
 * toBizRegNo       문자열을 사업자등록번호로 변환한다.
 * toMac            문자열을 맥주소로 변환한다.
 * =============================================================================
 *
 * @author C-NODE
 * @version 1.0 2014/08/01
 */

/**
 * 마지막 일자를 반환한다.
 *
 * Usage: date.getLastDate()
 * 
 * @returns {Number} 일자
 */
Date.prototype.getLastDate = function() {
    var month = this.getMonth() + 1;
   
    switch (month) {
        case 2:
            var year = this.getFullYear();
            
            if (year % 4 == 0 && year % 100 != 0) {
                return 29;
            }
            
            if (year % 400 == 0) {
                return 29;
            }
            
            return 28;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
    }
    
    return 31;
};

/**
 * 포맷한 날짜를 반환한다.
 *
 * Usage: date.format()
 *        date.format(pattern)
 *
 * Pattern:
 * =============================================================================
 * Letters          Component
 * -----------------------------------------------------------------------------
 * yyyy             Year
 * MM               Month
 * dd               Date
 * HH               Hour
 * mm               Minute
 * ss               Second
 * SSS              Milli-Second
 * =============================================================================
 * 
 * @param pattern {String} 패턴
 * @returns {String} 날짜
 */
Date.prototype.format = function() {
    var pattern = arguments.length > 0 ? arguments[0] : "yyyy-MM-dd";
    
    var self = this;
    
    return pattern.replace(new RegExp("(yyyy|MM|dd|HH|mm|ss|SSS)", "g"), function($1) {
        switch ($1) {
            case "yyyy":
                var year = self.getFullYear();
                
                return year.toString().lpad(4);
            case "MM":
                var month = self.getMonth() + 1;
                
                return month.toString().lpad(2);
            case "dd":
                var date = self.getDate();
                
                return date.toString().lpad(2);
            case "HH":
                var hour = self.getHours();
                
                return hour.toString().lpad(2);
            case "mm":
                var minute = self.getMinutes();
                
                return minute.toString().lpad(2);
            case "ss":
                var second = self.getSeconds();
                
                return second.toString().lpad(2);
            case "SSS":
                var millisecond = self.getMilliseconds();
                
                return millisecond.toString().lpad(3);
        }
    });
};

/**
 * 문자열의 바이트 배열길이를 반환한다.
 *
 * Usage: string.bytes()
 * 
 * @returns {Number} 길이
 */
String.prototype.bytes = function() {
    return this.length + (escape(this) + "%u").match(new RegExp("%u", "g")).length - 1;
};

/**
 * 문자열의 일정한 길이만큼만 반환한다.
 *
 * Usage: string.ellipsis(length)
 *        string.ellipsis(length, suffix)
 * 
 * @param length {Number} 길이
 * @param suffix {String} 생략 부호
 * @returns {String} 문자열
 */
String.prototype.ellipsis = function(length) {
    var suffix = arguments.length > 1 ? arguments[1] : "...";
    
    if (this.length > length) {
        return this.substr(0, length) + suffix;
    }
    
    return this;
};

/**
 * 문자열의 전역의 인용부호를 치환한다.
 *
 * Usage: string.quota()
 * 
 * @returns {String} 문자열
 */
String.prototype.quota = function() {
    return this.replace(new RegExp("\"", "g"), "&#34;").replace(new RegExp("\'", "g"), "&#39;");
};

/**
 * 문자열의 정규식 특수문자를 치환한다.
 *
 * Usage: string.meta()
 * 
 * @returns {String} 문자열
 */
String.prototype.meta = function() {
    var replace = "";
    
    var pattern = new RegExp("([\\$\\(\\)\\*\\+\\.\\[\\]\\?\\\\\\^\\{\\}\\|]{1})", "");
    
    for (var i = 0; i < this.length; i++) {
        if (pattern.test(this.charAt(i))) {
            replace += this.charAt(i).replace(pattern, "\\$1");
        }
        else {
            replace += this.charAt(i);
        }
    }
    
    return replace;
};

/**
 * 문자열의 측면의 특정문자를 제거한다.
 *
 * Usage: string.trim()
 *        string.trim(character)
 *        string.trim(character, "both|left|right")
 * 
 * @param character {String} 문자
 * @param direction {String} 방향
 * @returns {String} 문자열
 */
String.prototype.trim = function() {
    var character = arguments.length > 0 ? arguments[0] : "\\s";
    var direction = arguments.length > 1 ? arguments[1] : "both";
    
    switch (direction) {
        case "both":
            return this.btrim(character);
        case "left":
            return this.ltrim(character);
        case "right":
            return this.rtrim(character);
    }
    
    return this;
};

/**
 * 문자열의 양측의 특정문자를 제거한다.
 *
 * Usage: string.btrim()
 *        string.btrim(character)
 * 
 * @param character {String} 문자
 * @returns {String} 문자열
 */
String.prototype.btrim = function() {
    var character = arguments.length > 0 ? arguments[0] : "\\s";
    
    character = character == "\\s" ? character : character.meta();
    
    return this.replace(new RegExp("(^" +character + "*)|(" + character + "*$)", "g"), "");
};

/**
 * 문자열의 좌측의 특정문자를 제거한다.
 *
 * Usage: string.ltrim()
 *        string.ltrim(character)
 * 
 * @param character {String} 문자
 * @returns {String} 문자열
 */
String.prototype.ltrim = function() {
    var character = arguments.length > 0 ? arguments[0] : "\\s";
    
    character = character == "\\s" ? character : character.meta();
    
    return this.replace(new RegExp("(^" + character + "*)", "g"), "");
};

/**
 * 문자열의 우측의 특정문자를 제거한다.
 *
 * Usage: string.rtrim()
 *        string.rtrim(character)
 * 
 * @param character {String} 문자
 * @returns {String} 문자열
 */
String.prototype.rtrim = function() {
    var character = arguments.length > 0 ? arguments[0] : "\\s";
    
    character = character == "\\s" ? character : character.meta();
    
    return this.replace(new RegExp("(" + character + "*$)", "g"), "");
};

/**
 * 문자열의 전역의 특정문자를 제거한다.
 *
 * Usage: string.strip()
 *        string.strip(character)
 * 
 * @param character {String} 문자
 * @returns {String} 문자열
 */
String.prototype.strip = function() {
    var character = arguments.length > 0 ? arguments[0] : "\\s";
    
    character = character == "\\s" ? character : character.meta();
    
    return this.replace(new RegExp("[" + character + "]", "g"), "");
};

/**
 * 문자열의 측면에 특정문자를 덧붙인다.
 *
 * Usage: string.pad(length)
 *        string.pad(length, character)
 *        string.pad(length, character, "left|right")
 * 
 * @param length {Number} 길이
 * @param character {String} 문자
 * @param direction {String} 방향
 * @returns {String} 문자열
 */
String.prototype.pad = function(length) {
    var character = arguments.length > 1 ? arguments[1] : "0";
    var direction = arguments.length > 2 ? arguments[2] : "left";
    
    switch (direction) {
        case "left":
            return this.lpad(length, character);
        case "right":
            return this.rpad(length, character);
    }
    
    return this;
};

/**
 * 문자열의 좌측에 특정문자를 덧붙인다.
 *
 * Usage: string.lpad(length)
 *        string.lpad(length, character)
 * 
 * @param length {Number} 길이
 * @param character {String} 문자
 * @returns {String} 문자열
 */
String.prototype.lpad = function(length) {
    var character = arguments.length > 1 ? arguments[1] : "0";
    
    var padding = "";
    
    if (this.length < length) {
        for (var i = 0; i < length - this.length; i++) {
            padding += character;
        }
    }
    
    return padding + this;
};

/**
 * 문자열의 우측에 특정문자를 덧붙인다.
 *
 * Usage: string.rpad(length)
 *        string.rpad(length, character)
 * 
 * @param length {Number} 길이
 * @param character {String} 문자
 * @returns {String} 문자열
 */
String.prototype.rpad = function(length) {
    var character = arguments.length > 1 ? arguments[1] : "0";
    
    var padding = "";

    if (this.length < length) {
        for (var i = 0; i < length - this.length; i++) {
            padding += character;
        }
    }
    
    return this + padding;
};

/**
 * 문자열이 널 문자열인지 확인한다.
 *
 * Usage: string.isEmpty()
 * 
 * @returns {Boolean} 널 문자열 여부
 */
String.prototype.isEmpty = function() {
    return this == "";
};

/**
 * 문자열이 빈 문자열인지 확인한다.
 *
 * Usage: string.isBlank()
 * 
 * @returns {Boolean} 빈 문자열 여부
 */
String.prototype.isBlank = function() {
    return this.trim() == "";
};

/**
 * 문자열의 바이트 배열길이를 확인한다.
 *
 * Usage: string.isBytes()
 *        string.isBytes(minimum)
 *        string.isBytes(minimum, maximum)
 * 
 * @param minimum {Number} 최소값
 * @param maximum {Number} 최대값
 * @returns {Boolean} 길이 확인 여부
 */
String.prototype.isBytes = function() {
    var minimum = arguments.length > 0 ? arguments[0] : 0;
    var maximum = arguments.length > 1 ? arguments[1] : 0;
    
    if (minimum > 0 && this.bytes() < minimum) {
        return false;
    }
    
    if (maximum > 0 && this.bytes() > maximum) {
        return false;
    }
    
    return true;
};

/**
 * 문자열의 캐릭터 배열길이를 확인한다.
 *
 * Usage: string.isLength()
 *        string.isLength(minimum)
 *        string.isLength(minimum, maximum)
 * 
 * @param minimum {Number} 최소값
 * @param maximum {Number} 최대값
 * @returns {Boolean} 길이 확인 여부
 */
String.prototype.isLength = function() {
    var minimum = arguments.length > 0 ? arguments[0] : 0;
    var maximum = arguments.length > 1 ? arguments[1] : 0;
    
    if (minimum > 0 && this.length < minimum) {
        return false;
    }
    
    if (maximum > 0 && this.length > maximum) {
        return false;
    }
    
    return true;
};

/**
 * 문자열이 숫자인지 확인한다.
 *
 * Usage: string.isNumeric()
 * 
 * @returns {Boolean} 숫자 여부
 */
String.prototype.isNumeric = function() {
    return new RegExp("^[0-9]+$", "").test(this);
};

/**
 * 문자열이 정수인지 확인한다.
 *
 * Usage: string.isInteger()
 * 
 * @returns {Boolean} 정수 여부
 */
String.prototype.isInteger = function() {
    return new RegExp("^\\-?[0-9]+$", "").test(this);
};

/**
 * 문자열이 실수인지 확인한다.
 *
 * Usage: string.isDecimal()
 * 
 * @returns {Boolean} 실수 여부
 */
String.prototype.isDecimal = function() {
    return new RegExp("^\\-?[0-9]*(\\.[0-9]*)?$", "").test(this);
};

/**
 * 문자열이 날짜인지 확인한다.
 *
 * Usage: string.isDate()
 *        string.isDate(pattern)
 *
 * Pattern:
 * =============================================================================
 * Letters          Component
 * -----------------------------------------------------------------------------
 * yyyy             Year
 * MM               Month
 * dd               Date
 * =============================================================================
 * 
 * @param pattern {String} 패턴
 * @returns {Boolean} 날짜 여부
 */
String.prototype.isDate = function() {
    var pattern = arguments.length > 0 ? arguments[0] : "yyyy-MM-dd";
    
    if (this.length != pattern.length) {
        return false;
    }
    
    var year  = pattern.indexOf("yyyy") >= 0 ? parseInt(this.substr(pattern.indexOf("yyyy"), 4), 10) : 0;
    var month = pattern.indexOf("MM")   >= 0 ? parseInt(this.substr(pattern.indexOf("MM"),   2), 10) : 0;
    var date  = pattern.indexOf("dd")   >= 0 ? parseInt(this.substr(pattern.indexOf("dd"),   2), 10) : 0;
    
    if (year < 1) {
        return false;
    }
    if (month < 1) {
        return false;
    }
    if (month > 12) {
        return false;
    }
    if (date < 1) {
        return false;
    }
    if (date > 31) {
        return false;
    }
    
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return date <= 31;
        case 2:
            if (year % 4 == 0 && year % 100 != 0) {
                return date <= 29;
            }
            
            if (year % 400 == 0) {
                return date <= 29;
            }
            
            return date <= 28;
        case 4:
        case 6:
        case 9:
        case 11:
            return date <= 30;
    }
    
    return false;
};

/**
 * 문자열이 시간인지 확인한다.
 *
 * Usage: string.isTime()
 *        string.isTime(pattern)
 *
 * Pattern:
 * =============================================================================
 * Letters          Component
 * -----------------------------------------------------------------------------
 * HH               Hour
 * mm               Minute
 * ss               Second
 * =============================================================================
 * 
 * @param pattern {String} 패턴
 * @returns {Boolean} 시간 여부
 */
String.prototype.isTime = function() {
    var pattern = arguments.length > 0 ? arguments[0] : "HH:mm";
    
    if (this.length != pattern.length) {
        return false;
    }
    
    var hour   = pattern.indexOf("HH") >= 0 ? parseInt(this.substr(pattern.indexOf("HH"), 2), 10) : 0;
    var minute = pattern.indexOf("mm") >= 0 ? parseInt(this.substr(pattern.indexOf("mm"), 2), 10) : 0;
    var second = pattern.indexOf("ss") >= 0 ? parseInt(this.substr(pattern.indexOf("ss"), 2), 10) : 0;
    
    if (hour < 0) {
        return false;
    }
    if (hour > 23) {
        return false;
    }
    if (minute < 0) {
        return false;
    }
    if (minute > 59) {
        return false;
    }
    if (second < 0) {
        return false;
    }
    if (second > 59) {
        return false;
    }
    
    return true;
};

/**
 * 문자열이 유선전화번호인지 확인한다.
 *
 * Usage: string.isPhone()
 *        string.isPhone(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 유선전화번호 여부
 */
String.prototype.isPhone = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "";
    
    delimiter = delimiter.meta();
    
    return new RegExp("(02|0[3-9]{1}[0-9]{1})" + delimiter + "[1-9]{1}[0-9]{2,3}" + delimiter + "[0-9]{4}$", "").test(this);
};

/**
 * 문자열이 무선전화번호인지 확인한다.
 *
 * Usage: string.isMobile()
 *        string.isMobile(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 무선전화번호 여부
 */
String.prototype.isMobile = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "";
    
    delimiter = delimiter.meta();
    
    return new RegExp("01[016789]" + delimiter + "[1-9]{1}[0-9]{2,3}" + delimiter + "[0-9]{4}$", "").test(this);
};

/**
 * 문자열이 전자우편주소인지 확인한다.
 *
 * Usage: string.isEmail()
 * 
 * @returns {Boolean} 전자우편주소 여부
 */
String.prototype.isEmail = function() {
    return new RegExp("\\w+([\\-\\+\\.]\\w+)*@\\w+([\\-\\.]\\w+)*\\.[a-zA-Z]{2,4}$", "").test(this);
};

/**
 * 문자열이 배달우편번호인지 확인한다.
 *
 * Usage: string.isPostcode()
 *        string.isPostcode(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 배달우편번호 여부
 */
String.prototype.isPostcode = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    delimiter = delimiter.meta();
    
    return new RegExp("^[0-9]{3}" + delimiter +"[0-9]{3}$", "").test(this);
};

/**
 * 문자열이 주민등록번호인지 확인한다.
 *
 * Usage: string.isResRegNo()
 *        string.isResRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 주민등록번 여부
 */
String.prototype.isResRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    delimiter = delimiter.meta();
    
    if (new RegExp("[0-9]{2}[01]{1}[0-9]{1}[0123]{1}[0-9]{1}" + delimiter + "[1234]{1}[0-9]{6}$", "").test(this)) {
        var number = this.toNumeric();
        
        var birthdate = number.substr(0, 6);
        
        var sex = number.charAt(6);
        
        switch (sex) {
            case "1":
            case "2":
                birthdate = "19" + birthdate;
                break;
            case "3":
            case "4":
                birthdate = "20" + birthdate;
                break;
            default:
                return false;
        }
        
        if (!birthdate.isDate("yyyyMMdd")) {
            return false;
        }
        
        var checksum = 0;
        
        for (var i = 0; i < 12; i++) {
            checksum += parseInt(number.charAt(i), 10) * (i % 8 + 2);
        }
        
        return (11 - checksum % 11) % 10 == parseInt(number.charAt(12), 10);
    }
    
    return false;
};

/**
 * 문자열이 법인등록번호인지 확인한다.
 *
 * Usage: string.isCorRegNo()
 *        string.isCorRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 법인등록번호 여부
 */
String.prototype.isCorRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    delimiter = delimiter.meta();
    
    if (new RegExp("[0-9]{6}" + delimiter + "[0-9]{7}$", "").test(this)) {
        var number = this.toNumeric();
        
        var checksum = 0;
        
        for (var i = 0; i < 12; i++) {
            checksum += parseInt(number.charAt(i), 10) * (i % 2 + 1);
        }
        
        return (10 - checksum % 10) % 10 == parseInt(number.charAt(12), 10);
    }
    
    return false;
};

/**
 * 문자열이 외국인등록번호인지 확인한다.
 *
 * Usage: string.isForRegNo()
 *        string.isForRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 외국인등록번호 여부
 */
String.prototype.isForRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    delimiter = delimiter.meta();
    
    if (new RegExp("[0-9]{2}[01]{1}[0-9]{1}[0123]{1}[0-9]{1}" + delimiter + "[5678]{1}[0-9]{1}[02468]{1}[0-9]{2}[6789]{1}[0-9]{1}$", "").test(this)) {
        var number = this.toNumeric();
        
        var birthdate = number.substr(0, 6);
        
        var sex = number.charAt(6);
        
        switch (sex) {
            case "5":
            case "6":
                birthdate = "19" + birthdate;
                break;
            case "7":
            case "8":
                birthdate = "20" + birthdate;
                break;
            default:
                return false;
        }
        
        if (!birthdate.isDate("yyyyMMdd")) {
            return false;
        }
        
        if (parseInt(number.substr(7, 2), 10) % 2 != 0) {
            return false;
        }
        
        var checksum = 0;
        
        for (var i = 0; i < 12; i++) {
            checksum += parseInt(number.charAt(i), 10) * (i % 8 + 2);
        }
        
        return ((11 - checksum % 11) % 10 + 2) %10 == parseInt(number.charAt(12), 10);
    }
    
    return false;
};

/**
 * 문자열이 사업자등록번호인지 확인한다.
 *
 * Usage: string.isBizRegNo()
 *        string.isBizRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 사업자등록번호 여부
 */
String.prototype.isBizRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    delimiter = delimiter.meta();
    
    if (new RegExp("[0-9]{3}" + delimiter + "[0-9]{2}" + delimiter.meta() + "[0-9]{5}$", "").test(this)) {
        var number = this.toNumeric();
        
        var checksum = parseInt(number.charAt(0), 10);
        
        for (var i = 1; i < 8; i++) {
            checksum += parseInt(number.charAt(i), 10) * ((i % 3) * (i % 3 + 1) + 1) % 10;
        }
        
        checksum += Math.floor(parseInt(number.charAt(8), 10) * 5 / 10);
        
        checksum += parseInt(number.charAt(8), 10) * 5 % 10;
        
        checksum += parseInt(number.charAt(9), 10);
        
        return checksum % 10 == 0;
    }
    
    return false;
};

/**
 * 문자열이 아이피인지 확인한다.
 *
 * Usage: string.isIp()
 * 
 * @returns {Boolean} 아이피 여부
 */
String.prototype.isIp = function() {
    return new RegExp("\\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b", "").test(this);
};

/**
 * 문자열이 맥주소인지 확인한다.
 *
 * Usage: string.isMac()
 *        string.isMac(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {Boolean} 맥주소 여부
 */
String.prototype.isMac = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    delimiter = delimiter.meta();
    
    return new RegExp("^([0-9a-fA-F][0-9a-fA-F]" + delimiter + "){5}([0-9a-fA-F][0-9a-fA-F])$", "").test(this);
};

/**
 * 문자열이 이미지 파일인지 확인한다.
 *
 * Usage: string.isImage()
 *        string.isImage(extensions)
 * 
 * @param extensions {Array} 이미지 확장자
 * @returns {Boolean} 이미지 파일 여부
 */
String.prototype.isImage = function() {
    var extensions = arguments.length > 0 ? arguments[0] : [ "jpeg", "jpg", "gif", "png", "bmp" ];
    
    var extension = "";
    
    for (var i = 0; i < extensions.length; i++) {
        if (i > 0) {
            extension += "|";
        }
        
        extension += extensions[i].meta();
    }
    
    return new RegExp("\\.(" + extension + ")$", "i").test(this);
};

/**
 * 문자열이 업로드 파일인지 확인한다.
 *
 * Usage: string.isUpload()
 *        string.isUpload(extensions)
 * 
 * @param extensions {Array} 제한된 확장자
 * @returns {Boolean} 업로드 파일 여부
 */
String.prototype.isUpload = function() {
    var extensions = arguments.length > 0 ? arguments[0] : [ "jsp", "php", "php3", "php5", "phtml", "asp", "aspx", "asc", "ascx", "cfm", "cfc", "pl", "bat", "exe", "dll", "reg", "cgi" ];
    
    var extension = "";
    
    for (var i = 0; i < extensions.length; i++) {
        if (i > 0) {
            extension += "|";
        }
        
        extension += extensions[i].meta();
    }
    
    return !new RegExp("\\.(" + extension + ")$", "i").test(this);
};

/**
 * 문자열이 영어인지 확인한다.
 *
 * Usage: string.isAlpha()
 *        string.isAlpha(ignores)
 * 
 * @param ignores {String} 허용된 문자
 * @returns {Boolean} 영어 여부
 */
String.prototype.isAlpha = function() {
    var ignores = arguments.length > 0 ? arguments[0] : "";
    
    return new RegExp("^[a-zA-Z]+$", "").test(this.strip(ignores));
};

/**
 * 문자열이 한글인지 확인한다.
 *
 * Usage: string.isKorean()
 *        string.isKorean(ignores)
 * 
 * @param ignores {String} 허용된 문자
 * @returns {Boolean} 한글 여부
 */
String.prototype.isKorean = function() {
    var ignores = arguments.length > 0 ? arguments[0] : "";
    
    return new RegExp("^[ㄱ-ㅎㅏ-ㅣ가-힣]+$", "").test(this.strip(ignores));
};

/**
 * 문자열이 영어와 숫자인지 확인한다.
 *
 * Usage: string.isAlphaNumeric()
 *        string.isAlphaNumeric(ignores)
 * 
 * @param ignores {String} 허용된 문자
 * @returns {Boolean} 영어와 숫자 여부
 */
String.prototype.isAlphaNumeric = function() {
    var ignores = arguments.length > 0 ? arguments[0] : "";
    
    return new RegExp("^[0-9a-zA-Z]+$", "").test(this.strip(ignores));
};

/**
 * 문자열이 한글과 숫자인지 확인한다.
 *
 * Usage: string.isKoreanNumeric()
 *        string.isKoreanNumeric(ignores)
 * 
 * @param ignores {String} 허용된 문자
 * @returns {Boolean} 한글과 숫자 여부
 */
String.prototype.isKoreanNumeric = function() {
    var ignores = arguments.length > 0 ? arguments[0] : "";
    
    return new RegExp("^[0-9ㄱ-ㅎㅏ-ㅣ가-힣]+$", "").test(this.strip(ignores));
};

/**
 * 문자열을 숫자로 변환한다.
 *
 * Usage: string.toNumeric()
 * 
 * @returns {String} 숫자
 */
String.prototype.toNumeric = function() {
    return this.replace(new RegExp("[^0-9]", "g"), "");
};

/**
 * 문자열을 정수로 변환한다.
 *
 * Usage: string.toInteger()
 *        string.toInteger(radix)
 * 
 * @param radix {Number} 진법
 * @return {Number} 정수
 */
String.prototype.toInteger = function() {
    var radix = arguments.length > 0 ? arguments[0] : 10;
    
    return parseInt(this.replace(new RegExp("[^\\-0-9\\.]", "g"), ""), radix);
};

/**
 * 문자열을 실수로 변환한다.
 *
 * Usage: string.toDecimal()
 *        string.toDecimal(radix)
 * 
 * @param radix {Number} 진법
 * @return {Number} 실수
 */
String.prototype.toDecimal = function() {
    var radix = arguments.length > 0 ? arguments[0] : 10;
    
    return parseFloat(this.replace(new RegExp("[^\\-0-9\\.]", "g"), ""), radix);
};

/**
 * 문자열을 통화로 변환한다.
 *
 * Usage: string.toCurrency()
 *        string.toCurrency(fixed)
 *        string.toCurrency(fixed, round|floor|ceil)
 * 
 * @param fixed {Number} 소수점 자리수
 * @param round {String} 반올림
 * @return {String} 통화
 */
String.prototype.toCurrency = function() {
    var fixed = arguments.length > 0 ? arguments[0] : 0;
    var round = arguments.length > 1 ? arguments[1] : "round";
    
    var sign = 1;
    
    var decimal = this.toDecimal();
    
    if (decimal < 0) {
        sign = -1;
        
        decimal = Math.abs(decimal);
    }
    
    var power = Math.pow(10, fixed);
    
    switch (round) {
        case "round":
            decimal = Math.round(decimal * power) / power * sign;
            break;
        case "floor":
            decimal = Math.floor(decimal * power) / power * sign;
            break;
        case "ceil":
            decimal = Math.ceil(decimal * power) / power * sign;
            break;
        default:
            return this;
    }
    
    var number = decimal.toString();
    
    var extra = "";
    
    var index = number.indexOf(".");
    
    if (index > 0) {
        number = number.substring(0, index);
        
        extra = number.substring(index + 1);
    }
    
    if (fixed > 0) {
        extra = "." + extra.rpad("0", fixed);
    }
    
    var pattern = new RegExp("(\\-?[0-9]+)([0-9]{3})", "");
    
    while (pattern.test(number)) {
        number = number.replace(pattern, "$1,$2");
    }
    
    return number + extra;
};

/**
 * 문자열을 날짜로 변환한다.
 *
 * Usage: string.toDate()
 *        string.toDate(parsePattern)
 *        string.toDate(parsePattern, formatPattern)
 *
 * Pattern:
 * =============================================================================
 * Letters          Component
 * -----------------------------------------------------------------------------
 * yyyy             Year
 * MM               Month
 * dd               Date
 * =============================================================================
 * 
 * @param parsePattern {String} 파싱패턴
 * @param formatPattern {String} 포맷패턴
 * @returns {String} 날짜
 */
String.prototype.toDate = function() {
    var parsePattern  = arguments.length > 0 ? arguments[0] : "yyyyMMdd";
    var formatPattern = arguments.length > 1 ? arguments[1] : "yyyy-MM-dd";
    
    if (this.length != parsePattern.length) {
        return this;
    }
    
    var year  = parsePattern.indexOf("yyyy") >= 0 ? this.substr(parsePattern.indexOf("yyyy"), 4) : "";
    var month = parsePattern.indexOf("MM")   >= 0 ? this.substr(parsePattern.indexOf("MM"),   2) : "";
    var date  = parsePattern.indexOf("dd")   >= 0 ? this.substr(parsePattern.indexOf("dd"),   2) : "";
    
    return formatPattern.replace("yyyy", year).replace("MM", month).replace("dd", date);
};

/**
 * 문자열을 시간으로 변환한다.
 *
 * Usage: string.toTime()
 *        string.toTime(parsePattern)
 *        string.toTime(parsePattern, formatPattern)
 *
 * Pattern:
 * =============================================================================
 * Letters          Component
 * -----------------------------------------------------------------------------
 * HH               Hour
 * mm               Minute
 * ss               Second
 * =============================================================================
 * 
 * @param parsePattern {String} 파싱패턴
 * @param formatPattern {String} 포맷패턴
 * @returns {String} 시간
 */
String.prototype.toTime = function() {
    var parsePattern  = arguments.length > 0 ? arguments[0] : "HHmm";
    var formatPattern = arguments.length > 1 ? arguments[1] : "HH:mm";
    
    if (this.length != parsePattern.length) {
        return this;
    }
    
    var hour   = parsePattern.indexOf("HH") >= 0 ? this.substr(parsePattern.indexOf("HH"), 2) : "";
    var minute = parsePattern.indexOf("mm") >= 0 ? this.substr(parsePattern.indexOf("mm"), 2) : "";
    var second = parsePattern.indexOf("ss") >= 0 ? this.substr(parsePattern.indexOf("ss"), 2) : "";
    
    return formatPattern.replace("HH", hour).replace("mm", minute).replace("ss", second);
};

/**
 * 문자열을 유선전화번호로 변환한다.
 *
 * Usage: string.toPhone()
 *        string.toPhone(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 유선전화번호
 */
String.prototype.toPhone = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var number = this.toNumeric();
    
    if (number.indexOf("02") == 0) {
        if (number.length == 10) {
            return number.substr(0, 2) + delimiter + number.substr(2, 4) + delimiter + number.substr(6, 4);
        }
        if (number.length == 9) {
            return number.substr(0, 2) + delimiter + number.substr(2, 3) + delimiter + number.substr(5, 4);
        }
    }
    else {
        if (number.length == 11) {
            return number.substr(0, 3) + delimiter + number.substr(3, 4) + delimiter + number.substr(7, 4);
        }
        if (number.length == 10) {
            return number.substr(0, 3) + delimiter + number.substr(3, 3) + delimiter + number.substr(6, 4);
        }
    }
    
    return this;
};

/**
 * 문자열을 무선전화번호로 변환한다.
 *
 * Usage: string.toMobile()
 *        string.toMobile(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 무선전화번호
 */
String.prototype.toMobile = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var number = this.toNumeric();
    
    if (number.length == 11) {
        return number.substr(0, 3) + delimiter + number.substr(3, 4) + delimiter + number.substr(7, 4);
    }
    if (number.length == 10) {
        return number.substr(0, 3) + delimiter + number.substr(3, 3) + delimiter + number.substr(6, 4);
    }
    
    return this;
};

/**
 * 문자열을 배달우편번호로 변환한다.
 *
 * Usage: string.toPostcode()
 *        string.toPostcode(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 배달우편번호
 */
String.prototype.toPostcode = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var number = this.toNumeric();
    
    if (number.length == 6) {
        return number.substr(0, 3) + delimiter + number.substr(3, 3);
    }
    
    return this;
};

/**
 * 문자열을 주민등록번호로 변환한다.
 *
 * Usage: string.toResRegNo()
 *        string.toResRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 주민등록번호
 */
String.prototype.toResRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var number = this.toNumeric();
    
    if (number.length == 13) {
        return number.substr(0, 6) + delimiter + number.substr(6, 7);
    }
    
    return this;
};

/**
 * 문자열을 법인등록번호로 변환한다.
 *
 * Usage: string.toCorRegNo()
 *        string.toCorRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 법인등록번호
 */
String.prototype.toCorRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var number = this.toNumeric();
    
    if (number.length == 13) {
        return number.substr(0, 6) + delimiter + number.substr(6, 7);
    }
    
    return this;
};

/**
 * 문자열을 외국인등록번호로 변환한다.
 *
 * Usage: string.toForRegNo()
 *        string.toForRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 외국인등록번호
 */
String.prototype.toForRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var number = this.toNumeric();
    
    if (number.length == 13) {
        return number.substr(0, 6) + delimiter + number.substr(6, 7);
    }
    
    return this;
};

/**
 * 문자열을 사업자등록번호로 변환한다.
 *
 * Usage: string.toBizRegNo()
 *        string.toBizRegNo(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 사업자등록번호
 */
String.prototype.toBizRegNo = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var number = this.toNumeric();
    
    if (number.length == 10) {
        return number.substr(0, 3) + delimiter + number.substr(3, 2) + delimiter + number.substr(5, 5);
    }
    
    return this;
};

/**
 * 문자열을 맥주소로 변환한다.
 *
 * Usage: string.toMac()
 *        string.toMac(delimiter)
 * 
 * @param delimiter {String} 구분자
 * @returns {String} 맥주소
 */
String.prototype.toMac = function() {
    var delimiter = arguments.length > 0 ? arguments[0] : "-";
    
    var letters = this.replace(new RegExp("[^0-9a-fA-F]", "g"), "").toUpperCase();
    
    if (letters.length == 12) {
        return letters.substr( 0, 2) + delimiter +
                letters.substr( 2, 2) + delimiter +
                letters.substr( 4, 2) + delimiter +
                letters.substr( 6, 2) + delimiter +
                letters.substr( 8, 2) + delimiter +
                letters.substr(10, 2);
    }
    
    return this;
};