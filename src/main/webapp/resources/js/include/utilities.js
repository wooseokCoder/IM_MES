/*
 * @(#)utilities.js 1.0 2014/08/01
 * 
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */

/**
 * 공통 기능을 지원하는 스크립트이다.
 *
 * @author C-NODE
 * @version 1.0 2014/08/01
 */

/**
 * 데이터를 처리하는 화면으로 이동한다.
 * 
 * @param options {Object} 옵션
 */
function goSubmit(options) {
    options.form   = options.form   || "";
    options.url    = options.url    || "";
    options.target = options.target || "_self";
    
    if (options.form.isBlank()) {
        return;
    }
    if (options.url.isBlank()) {
        return;
    }
    
    var form = $("#" + options.form);
    
    if (options.data) {
        for (var i = 0; i < options.data.length; i++) {
            form.find("[name=" + options.data[i].name + "]").val(options.data[i].value);
        }
    }
    
    form.attr("action", getUrl(options.url));
    form.attr("target", options.target);
    form.submit();
}

/**
 * URL을 반환한다.
 * 
 * @param url {String} URL
 * @returns {String} URL
 */
function getUrl(url) {
    return (context || "") + url;
}

/**
 * 타임 스탬프를 반환한다.
 * 
 * @returns {Number} 타임 스탬프
 */
function getTimestamp() {
    return new Date().getTime();
}

/**
 * 파일 이름을 반환한다.
 * 
 * @param path {String} 파일 경로
 * @returns {String} 파일 이름
 */
function getFileName(path) {
    return path.substring(path.replace(new RegExp("\\\\", "g"), "/").lastIndexOf("/") + 1);
}

/**
 * 파일 크기를 반환한다.
 * 
 * @param size {Number} 파일 크기
 * @returns {String} 파일 크기
 */
function getFileSize(size) {
    return Math.ceil(size / 1024).toString().toCurrency() + "KB";
}

/**
 * 값을 설정한다.
 * 
 * @param element {Element} 요소
 * @param value {String} 값
 */
function setValue(element, value) {
    switch (element.type) {
        case "file":
        case "image":
        case "reset":
        case "submit":
        case "button":
            break;
        case "radio":
        case "checkbox":
            if (element.value == value) {
                element.checked = true;
            }
            else {
                element.checked = false;
            }
            
            break;
        default:
            element.value = value;
            
            break;
    }
}

/**
 * 값을 복사한다.
 * 
 * @param source {Element} 원본 요소
 * @param destination {Element} 대상 요소
 */
function copyValue(source, destination) {
    switch (source.type) {
        case "file":
        case "image":
        case "reset":
        case "submit":
        case "button":
            break;
        case "radio":
            if (source.checked) {
                destination.value = source.value;
            }
            break;
        case "checkbox":
            if (source.checked) {
                destination.value = destination.value.isEmpty() ? source.value : destination.value + "," + source.value;
            }
            
            break;
        default:
            destination.value = source.value;
            
            break;
    }
}

//Cookie 설정  1000 * 3600 * 24 * 30 => 30일
function setCookie (name, value, expireDays) {
	
	var expires = new Date();
	// 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
	expires.setTime(expires.getTime() + 1000 * 3600 * 24 * expireDays); // 30일

	document.cookie = name + "=" + escape (value) +"; path=/; expires=" + expires.toGMTString();
}

/**
 * 쿠키 삭제
 * @param cookieName 삭제할 쿠키명
 */
function deleteCookie( cookieName ){
	var expireDate = new Date();
	//어제 날짜를 쿠키 소멸 날짜로 설정한다.
	expireDate.setDate( expireDate.getDate() - 1 );
	document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + "; path=/";
}

function getCookie(Name) {
	var search = Name + "="
	if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
		offset = document.cookie.indexOf(search)
		if (offset != -1) { // 쿠키가 존재하면

		  offset += search.length
		  // set index of beginning of value

		  end = document.cookie.indexOf(";", offset)
		  // 쿠키 값의 마지막 위치 인덱스 번호 설정

		  if (end == -1)
			end = document.cookie.length
		  return unescape(document.cookie.substring(offset, end))
		}
	}
	return "";
}

/**
 * 로딩 마스크를 보인다.
 */
function showLoadingMask() {
    $("#loading-mask").css({
        width:$("body").width() + "px",
        height:$(document).height() + "px"
    });
    
    $("#loading-mask").show();
    
    $("#loading-mask").focus();
}

/**
 * 로딩 마스크를 숨긴다.
 */
function hideLoadingMask() {
    $("#loading-mask").fadeOut("slow");
}

/**
 * 체크박스를 토글한다.
 * 
 * @param checkbox {Object} 체크박스
 * @param selector {String} 셀렉터
 */
function toggleCheckbox(checkbox, selector) {
    $(selector).each(function(index, element) {
        this.checked = checkbox.checked;
    });
}