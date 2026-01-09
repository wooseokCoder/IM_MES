<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)common.jsp 1.0 2014/07/30                                          --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ page import="com.wsc.framework.utils.LocaleUtil" %>

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 상위공통 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta content="width=1420" name="viewport" inital-scale="1.0">

<link rel="shortcut icon" href="<%=request.getContextPath() %>/resources/images/favicon.ico">
<title><spring:message code="system.title"/></title>

<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.min.css?v=250709A" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/font-awesome.min.css?v=250709A" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/media.css?v=250709A" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery/jquery-ui-1.11.4/jquery-ui.icons.css?v=250709A" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery/easyui-1.4/themes/icon.css?v=250709A" />" />
<!--
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery/easyui-1.4/themes/bootstrap/easyui.css" />" />
 -->
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery/easyui-1.4/themes/ui-pepper-grinder/easyui.css?v=250709A" />" />
<%-- <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/common2.css?v=250709A" />" /> --%>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery/font-awesome-4.7.0/css/font-awesome.min.css?v=250709A" />" />
<!-- TODO 김원국 수정 -->
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/custom.css?v=250709A" />" />

<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery/easyui-1.4/themes/color.css?v=250709A" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/cnodeCustom.css?v=250709A" />" />

<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/common.css?v=251107A" />" />

<!-- 프린터 레포트 변수 -->
<input type="hidden" name="reportUrl" id="reportUrl" value="${reportUrl}"/>

<script type="text/javascript">
//시스템 컨텍스트
var context = "<c:out value="${pageContext.request.contextPath}" />";
//시스템 상수
//TODO 김원국 수정
var gconsts = {
	TITLE:      '${progName}', //제목
	ADMIN:      '${admin}',    //관리자 여부
	SYS_ID:     '${sysId}',    //시스템 ID
	PAGE_SIZE:  '${sessionScope.rows}', //목록 기본 출력수
	TAB_PANEL:  '${tabPanel}'  //탭패널 사용여부
};

var ehelp = {};

</script>
<!--
<script type="text/javascript" src="<c:url value="/resources/jquery/jquery-1.11.1.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/upload-5.31/js/jquery.1.9.1.min.js" />"></script>
-->
<script type="text/javascript" src="<c:url value="/resources/jquery/easyui-1.4/jquery.min.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/bootstrap.min.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/easyui-1.4/easyloader.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/easyui-1.4/jquery.easyui.min.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/easyui-1.4/jquery.easyui.patch.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/easyui-1.4/jquery.easyui.detailview.js?v=250709A" />"></script>

<script type="text/javascript" src="<c:url value="/resources/jquery/jquery.form-3.51.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/jquery.json-2.3.js?v=250709A" />"></script>

<script type="text/javascript" src="<c:url value="/resources/js/include/extension.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/utilities.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/widget.js?v=250709A"    />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/business.js?v=250709A"  />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/common.js?v=250709A"    />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/include/jquery.number.min.js?v=250709A"    />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/fullcalendar-2.1.1/lib/moment.min.js?v=250709A"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/lightslider/js/lightslider.js?v=250709A" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/lsCommon.js?v=250709A" />"></script>
<%
if((LocaleUtil.getLocale(request)).toString().equals("ko")){
%>
	<script type="text/javascript" src="<c:url value="/resources/js/include/lang/message_ko.js?v=250725B"    />"></script>
	<script>
		var locale = 'ko';
	</script>
<%
}
%>

<%
if((LocaleUtil.getLocale(request)).toString().equals("en")){
%>
	<script type="text/javascript" src="<c:url value="/resources/js/include/lang/message_en.js?v=250807A"    />"></script>
	<script>
		var locale = 'en';
	</script>
<%
}
%>

<%
if((LocaleUtil.getLocale(request)).toString().equals("vi")){
%>
	<script type="text/javascript" src="<c:url value="/resources/js/include/lang/message_vi.js?v=250805"    />"></script>
	<script>
		var locale = 'vi';
	</script>
<%
}
if((LocaleUtil.getLocale(request)).toString().equals("pt")){
%>
	<script type="text/javascript" src="<c:url value="/resources/js/include/lang/message_pt.js?v=250807A"    />"></script>
	<script>
		var locale = 'pt';
	</script>
<%
}
%>

<script type="text/javascript" src="<c:url value="/resources/js/module/jsort.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/module/jupload.js?v=250709C" />"></script>
<script>
function windowResizing(){
	var tempUrl = $(location).attr('pathname');
	if(tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'address.do' &&
			tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'bankSelect.do'&&
			tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'dealerSelect.do'&&
			tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'lstaSelect.do'&&
			tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'myViewSelect.do'&&
			tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'promoordercreate.do'&&
			tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'promoorderview.do'&&
			tempUrl.substring(tempUrl.lastIndexOf("/")+1,tempUrl.length) != 'promoorderadmin.do'){
		if(gconsts.TAB_PANEL == "Y"){
			var menuWidth;
			if(window.parent){
				menuWidth = $("#menu-region", parent.document).parent().css("left").replace(/[^-\d\.]/g, '');
			}else{
				menuWidth = $("#menu-region").parent().css("left").replace(/[^-\d\.]/g, '');
			}

			if(menuWidth == "0"){
			    $('.wui-body').css("width", "100%");
			    $('.wui-body').css("min-width", 800-230);
			}else{
			    $('.wui-body').css("width", "100%");
			    $('.wui-body').css("min-width", 800);
			}

		    var devHeight;
		    //devHeight = $(document).height();
			if(window.parent){
			    devHeight = $(".panel-fit", parent.document).css("height").replace(/[^-\d\.]/g, '');
			    devHeight -= 181;
			    if(devHeight >= 500){
			    	$('.wui-iframe', parent.document).css("height", devHeight+"px");
			    }else{
			    	$('.wui-iframe', parent.document).css("height", "500px");
			    }
			}else{
				devHeight = window.innerHeight;
			    devHeight -= 181;
			    if(devHeight >= 500){
			    	$('.wui-iframe').css("height", devHeight+"px");
			    }else{
			    	$('.wui-iframe').css("height", "500px");
			    }
			}
		}
		setTimeout("subMenuResize("+menuWidth+");", 300);
	}

	var tempUrl2 = $(location).attr('pathname');
	if(tempUrl2.substring(tempUrl2.lastIndexOf("/")+1,tempUrl2.length) == 'reportchart.do'){
		if(gconsts.TAB_PANEL == "Y"){
		    var devHeight;
		    //devHeight = $(document).height();
			if(window.parent){
			    devHeight = $(".panel-fit", parent.document).css("height").replace(/[^-\d\.]/g, '');
			    devHeight -= 182;
			    if(devHeight >= 408){
			    	$('#iReport', parent.document).css("height", devHeight+"px");
			    }else{
			    	$('#iReport', parent.document).css("height", "408px");
			    }
			}else{
				devHeight = window.innerHeight;
			    devHeight -= 182;
			    if(devHeight >= 408){
			    	$('#iReport').css("height", devHeight+"px");
			    }else{
			    	$('#iReport').css("height", "408px");
			    }
			}
		}
	}
}

//2016/10/04 김영진 화면 리사이즈시 메뉴 상태값에 따라 셋팅
function subMenuResize(menuWidth){
	var windowWidth;

		windowWidth = window.innerWidth;
		if(windowWidth < 460){
			$("#menu-folding-left").hide();
			$("#menu-folding-right").hide();
			$("#nav-main-logo").css("left", "0");
			$("#center-region").css("left", "0");
			if(sessionStorage.getItem('menuStat') == "open" && menuWidth == "0"){
				$("#main-layout").layout('collapse', 'west');
				$("#center-region").css("left", "0");
			}
		}else{
			var temp = $(location).attr('pathname');
			if(temp.substring(temp.lastIndexOf("/")+1,temp.length) == 'index.do'){
				$("#nav-main-logo").css("left", "0");
			}else{
				$("#nav-main-logo").css("left", "15px");/* 40px -> 15px 2019-07-12 */
			}

			if(sessionStorage.getItem('menuStat') == "open" && menuWidth == "-230"){
				$("#main-layout").layout('expand', 'west');
				$("#menu-folding-left").show();
				$("#menu-folding-right").hide();
				$("#center-region").css("left", "230px");
				sessionStorage.setItem('menuStat', 'open');
			}else if(sessionStorage.getItem('menuStat') == "close"){
				$("#menu-folding-left").hide();
				$("#menu-folding-right").show();
				$("#center-region").css("left", "0");
				sessionStorage.setItem('menuStat', 'close');
			}else if(sessionStorage.getItem('menuStat') == null){
				$("#menu-folding-left").hide();
				$("#menu-folding-right").show();
				$("#center-region").css("left", "0");
				$("#main-layout").layout('collapse', 'west');
				sessionStorage.setItem('menuStat', 'close');
			}
		}
	//}
}

function doResize_Single(w, h){
	//if(gconsts.TAB_PANEL == 'N'){
	//	$('#main-layout>.layout-panel-center').css("overflow-x", "auto");
	//	$('#main-layout>.layout-panel-center').css("overflow-y", "visible");
    //
	//	var menuWidth = $("#menu-region").parent().css("left").replace(/[^-\d\.]/g, '');
	//	var contentWidth = 1180;
    //
	//	if(menuWidth == "0"){
	//		contentWidth -= 230;
	//	}
    //
	//	$(this).parent().parent().css("width", "100%");
	//	$(this).parent().parent().css("min-width", contentWidth);
	//	$(".topnav").css("min-width", contentWidth);
	//	var devHeight = window.innerHeight;
	//    devHeight -= 135;
	//	if(contentWidth >= w){
	//	    if(devHeight >= 530){
	//			$(this).css("height", devHeight-61); //469
	//			$(this).parent().css("height", devHeight-61); //469
	//			$(this).parent().parent().css("height", devHeight-61); //469
	//			$(this).parent().parent().css("padding-bottom", "18px");
	//			$(this).parent().parent().parent().css("height", devHeight-61); //469
	//			$(this).parent().parent().parent().parent().css("height", devHeight-18); //469
	//	    	$('#main-layout>.layout-panel-center>#center-region').css("height", devHeight-18);
	//	    	$('#main-layout>.layout-panel-center').css("height", devHeight);
	//	    }else{
	//			$(this).css("min-height", "469px"); //469
	//			$(this).parent().css("min-height", "469px"); //469
	//			$(this).parent().parent().css("min-height", "469px"); //469
	//			$(this).parent().parent().css("padding-bottom", "18px");
	//			$(this).parent().parent().parent().css("min-height", "469px"); //469
	//			$(this).parent().parent().parent().parent().css("min-height", "512px"); //469
	//	    	$('#main-layout>.layout-panel-center>#center-region').css("min-height", "512px");
	//	    	$('#main-layout>.layout-panel-center').css("min-height", "530px");
	//	    }
	//	}else{
	//	    if(devHeight >= 530){
	//			$(this).css("height", devHeight-43); //487
	//			$(this).parent().css("height", devHeight-43); //487
	//			$(this).parent().parent().css("height", devHeight-43); //487
	//			$(this).parent().parent().css("padding-bottom", "0");
	//			$(this).parent().parent().parent().css("height", devHeight-43); //487
	//			$(this).parent().parent().parent().parent().css("height", devHeight); //487
	//	    	$('#main-layout>.layout-panel-center>#center-region').css("height", devHeight);
	//	    	$('#main-layout>.layout-panel-center').css("height", devHeight);
	//	    }else{
	//			$(this).css("min-height", "487px"); //487
	//			$(this).parent().css("min-height", "487px"); //487
	//			$(this).parent().parent().css("min-height", "487px"); //487
	//			$(this).parent().parent().css("padding-bottom", "0");
	//			$(this).parent().parent().parent().css("min-height", "487px"); //487
	//			$(this).parent().parent().parent().parent().css("min-height", "530px"); //487
	//	    	$('#main-layout>.layout-panel-center>#center-region').css("min-height", "530px");
	//	    	$('#main-layout>.layout-panel-center').css("min-height", "530px");
	//	    }
	//	}
    //
	//	$(this).parent().css("width", "100%");
	//}
}

$(function () {

    $(window).resize(function () {
   		windowResizing();


   		// 2018-01-15 화면 리사이즈시 800X800 보다 작아질 경우 팝업위치 강제조정 박상후
   		 var dynamicHeight = 0;
		 var fixedHeight = 0;
		 var headerHeight = $("#navbar-inner").height();

		 dynamicHeight = window.innerHeight;
		 dynamicWidth = window.innerWidth;


// 		 console.log(headerHeight);

		 if(dynamicWidth<800){

			 $(".window").addClass("forcedLeft");
	 		 $(".window-shadow").addClass("forcedLeft");


		 }else{

			 $(".window").removeClass("forcedLeft");
	 		 $(".window-shadow").removeClass("forcedLeft");

		 }

		 if(dynamicHeight<700){

			 $(".window").addClass("forcedTop");
	 		 $(".window-shadow").addClass("forcedTop");

		 }else{

			 $(".window").removeClass("forcedTop");
	 		 $(".window-shadow").removeClass("forcedTop");

		 }





    });
    
    //콤보박스 LIKE 검색
    $.fn.combobox.defaults.filter = function(q,row){
        var opts = $(this).combobox('options');
        return row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) >= 0;
      };
});

 /* doEhelpInit({
	sysId:    'WSC',
	title:    'e-help',
	bordGrup: 'B10',
	bordType: 'HEP',
	pageSize: '50'
});   */
</script>

<%-- 탭패널 사용여부에 따른 레이아웃 관련 변수 정의 --%>
<c:set var="layoutYn" value="N"/>
<c:choose>
	<c:when test="${frameYn  == 'Y'}"><c:set var="layoutYn" value="Y"/></c:when>
	<c:when test="${tabPanel == 'N'}"><c:set var="layoutYn" value="Y"/></c:when>
	<c:otherwise>                     <c:set var="layoutYn" value="N"/></c:otherwise>
</c:choose>