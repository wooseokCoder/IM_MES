<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)north.jsp 1.0 2014/07/30                                           --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="com.wsc.framework.utils.LocaleUtil"%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 상단 섹션 화면이다.                                                    			--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%-- BBUG.ADD : 시스템로고 추가  --%>
<!-- <div id="top-line" >   <img src="<%=request.getContextPath()%>/resources/images/main_logo.png">
	<div id="top-buttons">
		<c:if test="${empty user.userId}">
			<a href="#none" class="home-button">Home</a>
		</c:if>
		<c:if test="${!empty user.userId}">
			<span><c:out value="${user.userName}" />님</span>&nbsp;
			<a href="#" class="easyui-linkbutton" id="home-button"   data-options="plain:true" style="color:#0B173B">Home</a>
			<a href="#" class="easyui-linkbutton" id="stmap-button"  data-options="plain:true" style="color:#0B173B">사이트맵</a>
			<a href="#" class="easyui-linkbutton" id="logout-button" data-options="plain:true" style="color:#0B173B">Logout</a> -->
<!--
			<a href="#" class="easyui-linkbutton" id="help-button"   data-options="plain:true,iconCls:'icon-help'">E-Help</a>
			<a href="#" class="easyui-linkbutton" id="mypage-button" data-options="plain:true,iconCls:'icon-man'" >My Page</a>
			 -->
<!-- </c:if>
	</div>
</div> -->

<link href="https://fonts.googleapis.com/css?family=Open+Sans:600,700"rel="stylesheet">
		
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery/easyui-1.4/themes/ui-pepper-grinder/easyui.css" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/common.css?v=251107A" />" />

<style>
#logout-button .l-btn-left .l-btn-text {
	font-family: 'Open Sans', sans-serif !important;
	font-weight: 600;
	font-size: 14px;
}

#paypal-button .l-btn-left .l-btn-text { line-height: 25px;}
#paypalme-button .l-btn-left .l-btn-text { line-height: 25px;}

/* 모바일페이지 페이팔 버튼 숨김  */
@media only screen and (max-width: 955px) {
    .paypal-buttons {
        display: none;
    }
    .mobTitle{
	    color: white;
	    font-size: 23px;
	    font-weight: bold;
	    display: flex !important; 
	    position: fixed;
	    left: 50%;
	    top:15px;
	    margin-left:5px;
	    transform: translate(-50%);
    }
    #nav-main-logo{
    	display: none;
    }
    #main-navbar-collapse{
    	padding-left: 0px !important;
    }
}

@media only screen and (max-width: 390px) {
.mobTitle{
	    display: none !important; 
    }
    
    .mobTitleShort{
	    color: white;
	    font-size: 18px;
	    font-weight: bold;
	    display: flex !important; 
	    position: fixed;
	    left: 50%;
	    top:19px;
	    margin-left:5px;
	    transform: translate(-50%);
    }
}

.layout-expand{
	width: 25px !important;
	left: 0 !important;
}

#userId {
      position: relative; /* 드롭다운 위치 기준 */
      display: inline-block;
      cursor: pointer;
    }

    #userId img {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      vertical-align: middle;
    }

    .dropdown-menu {
      display: none;
      position: absolute;
      top: 35px;
      /* right: -13px; */
      left: -113px !important;
      width: 150px;
      background-color: #fff;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
      z-index: 1000;
      min-width: 100px !important;
    }

    .dropdown-menu::before {
      content: "";
      position: absolute;
      top: -8px;
      right: 16px;
      border-width: 0 8px 8px 8px;
      border-style: solid;
      border-color: transparent transparent #fff transparent;
      filter: drop-shadow(0 -1px 1px rgba(0, 0, 0, 0.1));
    }

    .dropdown-menu a {
      display: block;
      padding: 5px 14px;
      font-size: 14px;
      color: #000;
      text-decoration: none;
      border-bottom: 1px solid #eee;
      height: 30px;
    }

    .dropdown-menu a:last-child {
      border-bottom: none;
    }

    .dropdown-menu a:hover {
      background-color: #f5f5f5;
    }
    
    * { font-family: "Pretendard" !important; }
    
    .noti_count {
    	position: absolute;top: -7px;right: -7px;z-index: 99;background-color: red;border-radius: 50%;width: 20px;height: 20px;text-align: center;padding: 2px;
    	background-color: #0a1e5a;
    	color: #ffffff;
    	font-size: 10px;
    }
    
    .dropdown-noti {
      position: fixed;
      height: calc(100dvh - 48px);
      top: 48px;
      right: -400px;
      width: 400px;
      background-color: #fff;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
      z-index: 1000;
      min-width: 100px !important;
      flex-direction: column;
      display: flex;
    }
    
    .dropdown-noti .noti_List {
    	padding: 20px;
    	flex: 1 1 auto;
	    overflow-y: auto;
	    scrollbar-width: thin;
    }
    
    .dropdown-noti  .noti_container {
    	border: 1px solid #747474;
	    padding:  10px 15px;
	    border-radius: 5px;
	    margin-bottom: 10px;
    }
    
    .dropdown-noti .noti_btn {
    	height: 40px;
    	border-bottom: 1px solid #ddd;
    	display: flex;
	    justify-content: space-between;
	    padding: 0 20px;
	    align-items: center;
	    flex: 0 0 auto;
	    z-index: 1;
    }
    
    .dropdown-noti .noti_btn .noti_tit {
    	font-size: 17px;
    	color: #0a1e5a;
    }
    
    .dropdown-noti .noti_btn .noti_cls {
    	display: flex;
    	gap: 20px;
    }
    
    .dropdown-noti .noti_title {
    	font-size: 16px;
    	margin-bottom: 5px;
    	font-weight: 500;
    	color: #000000;
    	white-space: nowrap;    /* 줄바꿈 방지 */
		  overflow: hidden;       /* 넘치는 텍스트 숨김 */
		  text-overflow: ellipsis;
    }
    
    .dropdown-noti .noti_content {
    	font-size: 15px;
    	color: #000000;
    	font-weight: 300;
    	white-space: nowrap;    /* 줄바꿈 방지 */
		  overflow: hidden;       /* 넘치는 텍스트 숨김 */
		  text-overflow: ellipsis;
    }
    
    .dropdown-noti .noti_date {
    	font-size: 12px;
    	padding-top: 12px;
    	font-weight: 300;
    }
    
    .dropdown-noti .noti_container:hover {
      background-color: #f5f5f5;
      cursor: pointer;
    }
    
    #noti_all {
    	color: #005abb !important;
    }
    
    .top-buttons a {
    	color: #8c8c8c !important;
    }
    
    .top-buttons a:hover {
    	color: #0a1e5a !important;
    	font-weight: 500;
    }
    
    .top-buttons .easyui-searchbox {
	  border-radius: 20px !important;
	  padding: 5px 35px 5px 12px !important; /* 왼쪽 여백 + 오른쪽 아이콘 공간 */
	  border: 1px solid #ccc !important;
	  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
	}
	
	/* 돋보기 아이콘 */
	.top-buttons .easyui-searchbox .textbox-button {
	  right: 8px !important;
	  background: transparent !important;
	  border: none !important;
	  width: 100%;
	}
	
	#topSearch + .searchbox {
	 	border-radius: 15px !important;
	 	width: 100% !important;
	 }
	 
	#topSearch + .searchbox .searchbox-button {
		display: none;
	}
	 
	.top-buttons .fa-search {
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #888;
      cursor: pointer;
      font-size: 15px;
    }
    
    .notiAddBtn {
    	border: none;
	    background: transparent;
	    cursor: pointer;
	    font-size: 18px;
	    line-height: 1;
	    text-decoration: none;
    }
    
input.textbox-text.validatebox-text{
	width: calc(100% - 30px) !important;
}

#dropdownMenu .top-user-acc {
	height: 50px;
	/* background-color: #f7f9fb; */
	background-color: #a7a7a7;
    color: #fff !important;
}

#dropdownMenu .top-user-acc a:hover {
   	color: #0a1e5a !important;
   	font-weight: 500;
}

#dropdownMenu .top-user-acc:hover {
   	color: #0a1e5a !important;
   	background-color: #d7d7d7;
   	font-weight: 500;
}



.top-user-acc div{
	font-family: 'Amazon Ember',Arial,sans-serif!important;
	text-overflow: ellipsis; 
	overflow: hidden; 
	white-space: nowrap;
}

    
</style>

<!-- <div id="top-menu"></div> -->
<div id="main-navbar" class="navbar navbar-inverse bg-menu"
	role="navigation"
	style="background-color: rgba(0, 0, 0, 0); border: none; margin-bottom: 0px; min-height: 38px;">
	<div id="box-logo">
		<div id="" class="top-buttons dis_flex" style="height:100%; padding-right: 20px; justify-content: space-between; align-items: center; min-height: 48px; ">
			<div></div>
	
			<div class="dis_flex" style="height:100%; gap:10px; align-items: center; min-height: 48px;">
				<!-- <span class = "mobTitle" style="display: none">
					Dealer Portal
				</span>
				<span class = "mobTitleShort" style="display: none">
					Dealer Portal
				</span>
				<c:if test="${empty user.userId}">
					<a href="#none" class="home-button">Home</a>
				</c:if>
				 -->
				<c:if test="${!empty user.userId}">
					
					<c:if test="${groupIdC eq 'DEVADMIN4'}">
					</c:if>
					<c:choose>
						<c:when test="${paypalYn eq 'Y' && paypalMeYn eq 'Y'}">
							<span class="paypal-buttons">
								<a href="javascript:doOpenPayPalMe()" class="easyui-linkbutton" id="paypalme-button" data-options="plain:true" style="margin-right:5px;color:#ffffff;background:#ffc439;border-radius:5px 5px 5px 5px; line-height: nomal; height:30px; outline: none;
							 	   font-size: 14px; width: 90px; vertical-align: middle; line-height: normal; display: inline-block; padding: 1px; text-align: center; font-family: 'Amazon Ember',Arial,sans-serif!important;">
							 		<img style="height: 27px;max-height: 27px;min-height: 14px;" class="paypal-button-logo paypal-button-logo-paypal paypal-button-logo-gold" src="<%=request.getContextPath() %>/resources/images/PayPalMe.png" alt="" aria-label="paypal">
							 	</a>
							</span>
							<span class="paypal-buttons">
								<a href="javascript:doOpenPayPal()" class="easyui-linkbutton" id="paypal-button" data-options="plain:true" style="margin-right:104px;color:#ffffff;background:#ffc439;border-radius:5px 5px 5px 5px; line-height: nomal; height:30px; outline: none;
							 	   font-size: 14px; width: 90px; vertical-align: middle; line-height: normal; display: inline-block; padding: 1px; text-align: center; font-family: 'Amazon Ember',Arial,sans-serif!important;">
							 		<img style="height: 27px;max-height: 27px;min-height: 14px;" class="paypal-button-logo paypal-button-logo-paypal paypal-button-logo-gold" src="<%=request.getContextPath() %>/resources/images/PayPal.png" alt="" aria-label="paypal">
							 	</a>
							</span>
						</c:when>
						<c:when test="${paypalYn eq 'Y'}">
							<span class="paypal-buttons">
								<a href="javascript:doOpenPayPal()" class="easyui-linkbutton" id="paypal-button" data-options="plain:true" style="margin-right:104px;color:#ffffff;background:#ffc439;border-radius:5px 5px 5px 5px; line-height: nomal; height:30px; outline: none;
							 	   font-size: 14px; width: 90px; vertical-align: middle; line-height: normal; display: inline-block; padding: 1px; text-align: center; font-family: 'Amazon Ember',Arial,sans-serif!important;">
							 		<img style="height: 27px;max-height: 27px;min-height: 14px;" class="paypal-button-logo paypal-button-logo-paypal paypal-button-logo-gold" src="<%=request.getContextPath() %>/resources/images/PayPal.png" alt="" aria-label="paypal">
							 	</a>
							</span>
						</c:when>
						<c:when test="${paypalMeYn eq 'Y'}">
							<span class="paypal-buttons">
								<a href="javascript:doOpenPayPalMe()" class="easyui-linkbutton" id="paypalme-button" data-options="plain:true" style="margin-right:104px;color:#ffffff;background:#ffc439;border-radius:5px 5px 5px 5px; line-height: nomal; height:30px; outline: none;
							 	   font-size: 14px; width: 90px; vertical-align: middle; line-height: normal; display: inline-block; padding: 1px; text-align: center; font-family: 'Amazon Ember',Arial,sans-serif!important;">
							 		<img style="height: 27px;max-height: 27px;min-height: 14px;" class="paypal-button-logo paypal-button-logo-paypal paypal-button-logo-gold" src="<%=request.getContextPath() %>/resources/images/PayPalMe.png" alt="" aria-label="paypal">
							 	</a>
							</span>
						</c:when>
					</c:choose>

					<!-- <span class="paypal-buttons">
						<a href="javascript:doTopMemuGo('LS151')" id="create" title="Order Create" class="top-menu-icon"><i class="fa fa-shopping-cart fa-2x" aria-hidden="true" style="position:absolute; -webkit-transform:translate(-85px,0);"></i></a>
					</span> -->
				
					<span class="paypal-buttons">
		    	        <a href="https://lstractorusa.screenconnect.com/" target="_blank" ><img src="<%=request.getContextPath() %>/resources/images/icon_new/remote2.png" ></a>
					</span>
					
					<span id="userId" style="font-size: 13px; font-family: 'Amazon Ember',Arial,sans-serif!important;">
						<c:if test="${user.orgAuthCode eq 'DEAL'}">
							<img style="width:32px; height:32px; border-radius: 50%;" src="<%=request.getContextPath() %>/resources/images/icon_new/T.png" />
							<div class="dropdown-menu" id="dropdownMenu">
								<!-- <a href="javascript:jmenus.go('LS605');" id="" data-options="plain:true" class="top-user-acc" style="font-family: 'Amazon Ember',Arial,sans-serif!important; height: 50px;]"> -->
								<a href="javascript:myAccountMenu('${user.orgAuthCode}');" id="" data-options="plain:true" class="top-user-acc" style="font-family: 'Amazon Ember',Arial,sans-serif!important; height: 50px;]">
									<div>${user.userName}</div>
									<div>${user.userId}</div>
								</a>
						      <!-- <a href="#;" onclick="fnDashboardLoad('A');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-A</a>
						      <a href="#;" onclick="fnDashboardLoad('A_1');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-A-1</a>
						      <a href="#;" onclick="fnDashboardLoad('B');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-B</a>
						      <a href="#;" onclick="fnDashboardLoad('B_1');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-B-1</a>
						      <a href="#;" onclick="fnDashboardLoad('Iframe');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-iframe</a> -->
						      <a href="javascript:jmenus.go('LS601');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Change Password</a>
						      <a href="javascript:jmenus.go('LS602');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Q&A</a>
						      <!-- <a href="javascript:jmenus.go('LS605');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">My Account</a> -->
						      <a href="#" id="logout-button" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">
								<% if((LocaleUtil.getLocale(request)).toString().equals("ko")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;">Logout</span><%} %>
								<% if((LocaleUtil.getLocale(request)).toString().equals("en")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;"">Logout</span><%} %>
								<% if((LocaleUtil.getLocale(request)).toString().equals("vi")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;"">Đăng xuất</span><%} %>
								<% if((LocaleUtil.getLocale(request)).toString().equals("pt")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;"">Sair</span><%} %>
								</a> 
						    </div>
						</c:if>
						<c:if test="${user.orgAuthCode ne 'DEAL'}">
							<img style="width:32px; height:32px; border-radius: 50%;" src="<%=request.getContextPath() %>/resources/images/icon_new/T.png" />
							<div class="dropdown-menu" id="dropdownMenu">
								<!-- <a href="javascript:jmenus.go('LS605');" id="" data-options="plain:true" class="top-user-acc" style="font-family: 'Amazon Ember',Arial,sans-serif!important; height: 50px;"> -->
								<a href="javascript:myAccountMenu('${user.orgAuthCode}');" id="" data-options="plain:true" class="top-user-acc" style="font-family: 'Amazon Ember',Arial,sans-serif!important; height: 50px;]">
									<div>${user.userName}</div>
									<div>${user.userId}</div>
								</a>
						      <!-- <a href="#;" onclick="fnDashboardLoad('A');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-A</a>
						      <a href="#;" onclick="fnDashboardLoad('A_1');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-A-1</a>
						      <a href="#;" onclick="fnDashboardLoad('B');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-B</a>
						      <a href="#;" onclick="fnDashboardLoad('B_1');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-B-1</a>
						      <a href="#;" onclick="fnDashboardLoad('Iframe');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Dashboard-iframe</a> -->
						      <a href="javascript:jmenus.go('LS601');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Change Password</a>
						      <a href="javascript:jmenus.go('LS602');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">Q&A</a>
						      <!-- <a href="javascript:jmenus.go('LS605');" id="" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">My Account</a> -->
						      <a href="#" id="logout-button" data-options="plain:true" style="font-family: 'Amazon Ember',Arial,sans-serif!important;">
								<% if((LocaleUtil.getLocale(request)).toString().equals("ko")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;">Logout</span><%} %>
								<% if((LocaleUtil.getLocale(request)).toString().equals("en")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;"">Logout</span><%} %>
								<% if((LocaleUtil.getLocale(request)).toString().equals("vi")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;"">Đăng xuất</span><%} %>
								<% if((LocaleUtil.getLocale(request)).toString().equals("pt")){ %><span style="line-height: 29px; font-family: 'Amazon Ember',Arial,sans-serif!important;font-size: 14px;"">Sair</span><%} %>
								</a> 
						    </div>
						</c:if>
						<%-- <c:out value="${user.userName}" /> --%>
						<% if((LocaleUtil.getLocale(request)).toString().equals("ko")){ %><%} %>
					</span>&nbsp;
				</c:if>
			</div>
		</div>
	</div>
	<!-- 탑메뉴 사용체크 -->
	<c:choose>
		<c:when test="${topMenuYn == 'Y'}">
			<div class="navbar-inner" id="navbar-inner" style="border-bottom: 2px solid #4d4d4d; box-shadow: 0 1px 5px rgba(0, 0, 0, 0.15); min-height: 50px;">
			
				<div class="navbar-header" id="navbar-header"
					style="margin: 0 !important; padding-bottom: 0 !important; background-color: #fff;">
					<div>
						<button type="button" class="navbar-toggle collapsed"
							data-toggle="collapse" data-target="#main-navbar-collapse"
							style="margin-top: 13px; position: absolute; right: 10px;">
							<i class="navbar-icon fa fa-bars"></i>
						</button>
					</div>
				</div>
		
				<div data-options="region:'east',split:false,border:false" style="line-height: 54px; padding: 0 22px !important; position: absolute; top: 57px; left: 0px;">
					<a href="javascript:void(0)" id="menu-folding-left">
						<img src="<%=request.getContextPath()%>/resources/images/left-chevron.png" />
					</a>
					<a href="javascript:void(0)" id="menu-folding-right">
						<img src="<%=request.getContextPath()%>/resources/images/right-chevron.png" />
					</a>
				</div>
		
				<!-- 2016/10/04 김영진 --id추가 -->
				<%-- <div id="nav-main-logo" style="width: 230px; height: 54px; line-height: 54px; padding:0 0 0 10px !important; position: absolute; top: 57px; left: 50px;">
					<a href="<c:url value="/index.do" />">
						<img src="<%=request.getContextPath()%>/resources/images/dp_logo.png" style="width: 143px; height: 37px;" />
					</a>
				</div> --%>
				<div id="nav-main-logo" style="width:230px;height:54px;line-height:54px;padding:0px !important;position:absolute;top:57px;left:47px;">
					<a href="<c:url value="/index.do" />"><img src="<%=request.getContextPath() %>/resources/images/lsta_logo3.png" style="width:143px;height:37px;"/></a>
				</div>
				<div id="main-navbar-collapse" class="collapse navbar-collapse main-navbar-collapse menu-main main_navbar_bg " style="padding-left: 230px; padding-top: 6px;">
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="navbar-inner displayN" id="navbar-inner" style="border-bottom: 2px solid #4d4d4d; box-shadow: 0 1px 5px rgba(0, 0, 0, 0.15); min-height: 50px;">
				<div class="navbar-header" id="navbar-header" style="margin: 0 !important; padding-bottom: 0 !important; background-color: #fff;">
					<div>
						<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main-navbar-collapse" style="margin-top: 13px; position: absolute; right: 10px;">
							<i class="navbar-icon fa fa-bars"></i>
						</button>
					</div>
				</div>
		
				<div data-options="region:'east',split:false,border:false" style="line-height: 54px; padding: 0 22px !important; position: absolute; top: 57px; left: 0px;">
					<a href="javascript:void(0)" id="menu-folding-left">
						<img src="<%=request.getContextPath()%>/resources/images/left-chevron.png" />
					</a>
					<a href="javascript:void(0)" id="menu-folding-right">
						<img src="<%=request.getContextPath()%>/resources/images/right-chevron.png" />
					</a>
				</div>
		
				<%-- <div id="nav-main-logo" style="width: 230px; height: 54px; line-height: 54px; padding:0 0 0 10px !important; position: absolute; top: 57px; left: 50px;">
					<a href="<c:url value="/index.do" />">
						<img src="<%=request.getContextPath()%>/resources/images/dp_logo.png" style="width: 143px; height: 37px;" />
					</a>
				</div> --%>
				<div id="nav-main-logo" style="width:230px;height:54px;line-height:54px;padding:0px !important;position:absolute;top:57px;left:47px;">
					<a href="<c:url value="/index.do" />"><img src="<%=request.getContextPath() %>/resources/images/lsta_logo3.png" style="width:143px;height:37px;"/></a>
				</div>
				<div id="main-navbar-collapse" class="collapse navbar-collapse main-navbar-collapse menu-main main_navbar_bg " style="padding-left: 230px; padding-top: 6px;">
				</div>
			</div>
		</c:otherwise>
	</c:choose>
<div id="serverBorder" style="background-color: red; border: none; margin-bottom: 0px; min-height: 0px; display: none;">
</div>
</div>

<div id="noti-dialog" class="wui-dialog"	style="border-top-width: 1px; display: none;">
	<div id="" class="wui-toolbar" style="height: calc(100% - 40px); padding: 10px; overflow: auto; word-break: break-all; scrollbar-width: thin; font-size: 15px;">
		<span id="noti_content"></span>
		<input type="hidden" id="notiBordNo" value="" />
	</div>

	<div class="dialog-button dis_flex" style="text-align: center; padding-top: 10px; justify-content: center;">
		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="noti-detail-button" onclick="noti.notiDetail();">Detail</a>
		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="noti-confirm-button" data-item="BTN_012" onclick="noti.notiDialogClose();">Confirm</a>
	</div>
</div>

<form id="menu-form" name="menu-form" method="post">
	<input type="hidden" id="top_menuDesc" name="menuDesc" /> 
	<input type="hidden" id="top_menuKey" name="menuKey" /> 
	<input type="hidden" id="top_menuUrl" name="menuUrl" /> 
	<input type="hidden" id="top_parentDesc" name="parentDesc" />
	<input type="hidden" id="top_deal_params"   name="dealCode"  />
</form>

<iframe src="<c:url value="/menuOverEvent.do" />" style="display:none;"></iframe>


<script type="text/javascript">
  const contextPath = '<%= request.getContextPath() %>';
</script>


<script type="text/javascript">
function doTopMemuGo(key){
	jmenus.go(key);
}

function doTopMemuGo2(key,param){
	jmenus.go(key,param);
}

function topDealParams(){
	return $("#top_deal_params").val();
	
}
function doOpenPayPal() {
	/* if(host.substring(0,6) == 'dealer') {
		window.open('https://dealerportal.lstractorusa.com/lsdp/paypal.do');
	} else if(host.substring(0,2) == '52') {
		window.open('http://52.40.215.183:8080/lsdp/paypal.do');
	} else {
		window.open('http://localhost:8080/lsdp/paypal.do');
		//window.open('https://paypal.me/lstractorusa');
	} */
	window.open(context + '/paypal.do');
}

function doOpenPayPalMe() {
	window.open('https://paypal.me/lstractorusa');
}
/*20160929 박소현*/
var temp = $(location).attr('pathname');
var host = $(location).attr('host');

//개발과 운영의 차이를 위해 추가
if(host.substring(0,13) != 'dealerportal.') {
	//$("#logout-button").css("background-color","red");
	$("#serverBorder").css("min-height","4px");
	$("#navbar-inner").css("background-color","yellow");
	$("#main-navbar-collapse").css("background-color","yellow");
}

if(temp.substring(temp.lastIndexOf("/")+1,temp.length) == 'index.do'){
	//2016/10/19 김영진 -- index일때 좌측메뉴 비활성화
	$("#menu-folding-left").parent().attr("style", "display:none !important");
	$("#menu-folding-left").parent().attr("style", "display:none !important");
	//2016/10/04 김영진 -- 메인 로고 left값 조정
	$("#nav-main-logo").css("left", "0");
}else{
	//2016/10/04 김영진 --메뉴 세션 상태값에 따라 셋팅
	$("#menu-folding-left").hide();
	$("#menu-folding-right").hide();
	$("#nav-main-logo").css("left", "0");
	sessionStorage.setItem('menuStat', 'close');
}

$(function() {
	jcommon.init();
});

var reportWin = "";
/*20160929 박소현*/
$(function() {
	if(getCookie("reportLogin") == 'N') {
		//var reportWin = window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lsvs&reportUnit=/reports/lsvs/dummy_login&decorate=no&output=pdf&j_username=lspdiuser&j_password=lspdi1@3$','pdfReport', 'toolbar=no, width=1, height=1, top=5000, left=5000, directories=no, status=no, scrollorbars=yes, resizable=no');
		if(reportWin == "") {
			reportWin = window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lsdp&reportUnit=/reports/lsdp/dummy_login&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$','pdfReport', 'toolbar=no, width=1, height=1, top=5000, left=5000, directories=no, status=no, scrollorbars=yes, resizable=no');
		} else {
			reportWin.close();
			setCookie("reportLogin", "Y", 30);
		}
		setTimeout(function (){
			reportWin.close();
			setCookie("reportLogin", "Y", 30);
		},10000);		
	}
	
	$("#menu-folding-left").bind("click", function() {
		//메뉴접기
		$("#main-layout").layout('collapse', 'west');
		$("#menu-folding-left").hide();
		$("#menu-folding-right").show();


		//$('.panel-header').attr('style', 'left:-10px !important');
		//$('.panel-body').attr('style',  'left:-10px !important');

		//2016/10/04 김영진 --세션에 메뉴 상태값 저장
		sessionStorage.setItem('menuStat', 'close');
		$("#panel-tool-collapse").trigger("click");


	});

	$("#menu-folding-right").bind("click", function() {
		//메뉴열기
		$("#main-layout").layout('expand', 'west');
		$("#menu-folding-left").show();
		$("#menu-folding-right").hide();
		//$('.panel-header').attr('style', 'left:0px !important');
		//$('.panel-body').attr('style',  'left:0px !important');

		//2016/10/04 김영진 --세션에 메뉴 상태값 저장
		sessionStorage.setItem('menuStat', 'open');


		 $("#west-menu-new").css("height","300px");
		$("#left-hotmenu").css("height","230px");
		$("#left-hotmenu").show();
		if($("#west-menu-new div.panel.easyui-fluid div.panel-header div.panel-tool a.panel-tool-collapse").hasClass("panel-tool-expand")){
			$("#west-menu-new div.panel.easyui-fluid div.panel-header div.panel-tool a.panel-tool-collapse").removeClass("panel-tool-expand");
		}
		$("#left-region div.panel.layout-panel.layout-panel-center").css("top","300px");
		$("#left-submenu").css("height",($("#left-submenu").height())+"px");

		//20161214 김원국 추가
		/*  var hotMenuCnt = 0;
		$("#hot-menu > li").each(function(index){
			hotMenuCnt += $(this).height();
		});
		if(hotMenuCnt > 259){
			hotMenuCnt = 259;
		}

		$("#west-menu-new").css("height",(hotMenuCnt+41)+"px");
		$("#left-hotmenu").css("height",hotMenuCnt+"px");
		$("#left-region div.panel.layout-panel.layout-panel-center").css("top",(hotMenuCnt+41)+"px");
		$("#left-submenu").css("height",($("#left-submenu").height()-(hotMenuCnt+41) )+"px");  */
	});
	
	
	$("#topMenuCurrUnit").on('change',function(){
		var block = $(".panel.wui-tab");
		for(var i=0; i < block.length; i++){
			var dbView = block[i];
			if($(dbView).css("display") == 'block'){
				var frame = $(dbView).find("iframe");
				//create화면만 fnChExctRateCheck함수존재
				if( typeof $(frame)[0].contentWindow.fnChExctRate == 'function' ) {
				    $(frame)[0].contentWindow.fnChExctRate();
				}

			}
		}
		sessionStorage.setItem("nowDashCurrUnit", $("#topMenuCurrUnit option:selected").val());
	});
	
	if(sessionStorage.getItem( "currStat" ) =="Y"){
		$.ajax({
			url: getUrl('/common/user2/user2/dashBoardCurrUnit.json'),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {},
			success: function(data){
				if(data.rows[0] != null) {
					if(data.rows.length > 0) {
						 sessionStorage.setItem("dashCurrUnit", data.rows[0].currUnit);
						 $("#topMenuCurrUnit", parent.document).val(sessionStorage.getItem( "dashCurrUnit" ));
						 sessionStorage.setItem("currStat", "N");
						 sessionStorage.setItem("nowDashCurrUnit", $("#topMenuCurrUnit option:selected").val());
						 
		        	}
				} else {
				} 
				
			},
			error: function(){
			}
		});  
	}
	else{
		$("#topMenuCurrUnit", parent.document).val(sessionStorage.getItem( "nowDashCurrUnit" ));
	}
	
	$('#noti-dialog').dialog({
		title: 'Notification',
	    /* iconCls: 'icon-search', */
	    top:    10,
	    width: 590,
	    height: 415,
	    closed: true,
	    modal: true,
	    resizable: true
	});
	
	checkWindowSize();
});

$(window).resize(function() {
    checkWindowSize();
});
	
$(window).load(function() {
	
	$("#west-menu-new").css("background-color","#0a1e5a");
	$("#left-sitemap").css("background-color","#0a1e5a");
	$("#left-submenu").css("background-color","#0a1e5a");
	$("#left-submenu").css("color","white");
	$(".noAuth").css("background-color","#0a1e5a");
	$("#left-submenu li").css("background-color","#0d121e");
	$("#left-region").css("background-color","0d121e");
	$("#left-hotmenu").css("background-color","#0a1e5a");
	$(".layout-panel-center > #west-menu-new").css("background-color","#0a1e5a");
	//$(".tree-level2").css("background-color","#ffd600");
	
	$("#main-layout").layout('expand', 'west');
	$("#menu-folding-left").css('display', 'block').show();
    $("#menu-folding-right").hide();

    sessionStorage.setItem('menuStat', 'open');
    
    
	const userId = document.getElementById('userId');
    const dropdownMenu = document.getElementById('dropdownMenu');

    userId.addEventListener('click', function (e) {
      e.stopPropagation();
      const isVisible = dropdownMenu.style.display === 'block';
      dropdownMenu.style.display = isVisible ? 'none' : 'block';
    });

    document.addEventListener('click', function () {
      dropdownMenu.style.display = 'none';
    });
    
     $(".wui-dialog").show();
     
     //알림 리스트
     //noti.notiInit();
});


	function fnOrdrCLoase() {
		var ordrObj;
		var block = $(".panel.wui-tab");
		for (var i = 0; i < block.length; i++) {
			var dbView = block[i];
			if ($(dbView).css("display") == 'block') {
				var frame = $(dbView).find("iframe");
				ordrObj = $(frame)[0].contentWindow;
			}
		}

		var ordrIndex = ordrObj.$("#ordrIndex").val();
		$("#wui-tabs").tabs('close', Number(ordrIndex));
	}

	function fnOrdrCLoase2() {
		var ordrObj;
		var block = $(".panel.wui-tab");
		var blockIdx;
		for (var i = 0; i < block.length; i++) {
			var dbView = block[i];
			if ($(dbView).css("display") == 'block') {
				var frame = $(dbView).find("iframe");
				ordrObj = $(frame)[0].contentWindow;
				blockIdx = i;
			}
		}
		$("#wui-tabs").tabs('close', Number(blockIdx));
	}
	
	function doChgColor() {
		$("#logout-button").css("background-color","#0e4f87");
		$("#serverBorder").css("min-height","0px");
		$("#navbar-inner").css("background-color","#ffffff");
		$("#main-navbar-collapse").css("background-color","#ffffff");
	}
	function checkWindowSize() {
	    if ($(window).width() <= 955) {
	        $("#main-navbar-collapse").addClass("in");
	    } else {
	        $("#main-navbar-collapse").removeClass("in");
	    }
	}
	
	function fnDashboardLoad(type) {
		//const mainPageType = type; 
		const maxAgeSeconds = 60 * 60 * 24 * 30;

		document.cookie = "mainPageType="+type+"; path=/; max-age="+maxAgeSeconds;
		//document.location.href = contextPath + "/index"+type+".do";
		document.location.href = contextPath + "/index.do?type="+type;
	}
	
	let noti = {
			notiList : new Array(),
			notiInterval : function() {
				//setInterval(function() {
				//	//console.log("3분 test = " + new Date());
				//	noti.notiGetList();
				//}, 1000 * 60 * 3); //3분에 한번씩 알림 체크
			},
			notiInit : function() {
				//noti.notiGetList();
				//noti.notiInterval();
			},
			notiDisplay : function() {
				let notiPosi = $("#dropdownMenuNoti").css("right");
				let notiWidth = $("#dropdownMenuNoti").css("width");
				
				if(notiPosi == '0px') { //닫기
					$("#dropdownMenuNoti").css({
				        right: 0    // 시작 위치 (왼쪽에 숨겨져 있음)
				    }).animate({
				    	right: '-'+notiWidth             // 애니메이션으로 원래 위치로 이동
				    }, 400);
				}
				else { //열림
					//알림 데이터 불러오기
					noti.notiGetList();
				
					$("#dropdownMenuNoti").css({
				        right: '-'+notiWidth    // 시작 위치 (왼쪽에 숨겨져 있음)
				    }).animate({
				    	right: 0              // 애니메이션으로 원래 위치로 이동
				    }, 400);
				}
			},
			notiGetList : function() {
				$.ajax({
					url : getUrl('/common/board/notification/getNotiList.json'),
					dataType : 'json',
					async : true,
					type : 'post',
					data : {},
					success : function(data) {
						let notiCount = data.rows == undefined ? 0 : data.rows.length;
						
						$(".noti_List").html('');
						$(".noti_count").html(notiCount);
						
						if (notiCount > 0) {
							noti.notiList = data.rows;
							//noti_List
							for(var i=0;i<data.rows.length;i++) {
								let notiHtml = "";
								notiHtml += '<div class="noti_container dis_flex" onclick="noti.doOpenNodi('+i+');">'
								notiHtml += '<div style="width: calc(100% - 30px);"> '
								notiHtml += '<div class="noti_title">' + data.rows[i].BORD_TITLE + '</div>'
								notiHtml += '<div class="noti_content">' + data.rows[i].BORD_TEXT + '</div>'
								notiHtml += '<div class="noti_date">' + data.rows[i].FMT_DATE + '</div>'
								notiHtml += '</div>';
								
								notiHtml += '<div style="width: 30px; text-align: center; ">';
								notiHtml += '<span>';
								notiHtml += '<a class="notiAddBtn">&#8230;</a>';
								notiHtml += '</span>';
								notiHtml += '</div>';
								notiHtml += '</div>';
								
								$(".noti_List").append(notiHtml);
							}

						} else {
							let notiHtml = "";
							notiHtml += '<div class="tac">';
							notiHtml += '<span>No notification</span>'
							notiHtml += '</div>';
							
							$(".noti_List").append(notiHtml);
						}

					},
					error : function() {
					}
				});
			},
			doOpenNodi : function(notiIndex) { //알림
			 	//상세알림내용 오픈
			 	var notiD = $("#noti-dialog");
			 	//let notiCon = $(target).find(".noti_content").html();
			 	let notiCon = noti.notiList[notiIndex].BORD_TEXT;
			 	$("#noti_content").html(notiCon);
			 	
			 	$("#notiBordNo").val(noti.notiList[notiIndex].BORD_NO);
			 	
				notiD.dialog('center');
				notiD.dialog('open');
			},
			notiDialogClose : function() {
				$("#noti-dialog").dialog("close");
				
				//리스트에서 지우기 - 읽음처리
				noti.notiRead();
			},
			notiRead : function() {
				$.ajax({
					url : getUrl('/common/board/notification/updateNotiRead.json'),
					dataType : 'json',
					async : false,
					type : 'post',
					data : {
						bordNo: $("#notiBordNo").val()
					},
					success : function(data) {
						noti.notiGetList();
					},
					error : function() {
					}
				});
			},
			notiDetail : function() {
				//알림 상세화면 이동
				let selNoti = noti.notiList.find(({ BORD_NO }) => BORD_NO === $("#notiBordNo").val() );
				
				let params = {
						//title: selNoti.BORD_TITLE,
						title: "Notification",
						path: "/" + selNoti.LINK_URL
				}
				//alert(searchValue);
				noti.notiDialogClose();
				noti.notiDisplay();
				
				//화면 탭으로 열고, iframe에 검색화면 보여주기
				jmenus.goBlankTab(params);
			},
			notiAllRead : function() {
				$.ajax({
					url : getUrl('/common/board/notification/updateNotiRead.json'),
					dataType : 'json',
					async : false,
					type : 'post',
					/* data : {
						bordNo: $("#notiBordNo").val()
					}, */
					success : function(data) {
						noti.notiGetList();
					},
					error : function() {
					}
				});
				
			}
			
	}
	
	//메세지 받기
	window.addEventListener("message", function(event) {
	    if (event.origin !== "https://dealerportal.lstractorusa.com" 
	    		&& event.origin !== "https://dealerportaldev.lstractorusa.com") {
	        console.warn("허용되지 않은 origin:", event.origin);
	        return;
	    }

	    try {
	    	//type - IFURL : 화면이동 / HELP : 매뉴얼 팝업창 / RESPONSE_SSO_CHECK : sso 연결확인 응답
	    	//value - title :  이동할 메뉴/화면 Title / path : 이동할 메뉴/화면 URL
	    	/* 
	    	let data = {
	    	        type: "IFURL",
	    	        value: {
	    	            title: "이동할 메뉴/화면 Title",
	    	            path: "이동할 메뉴/화면 URL",
	    	        }
	    	};
	    	 */
	    	 
	    	 //'{"type":"IFURL","value":{"title":"Claim Status (LSTA)","path":"/lstaClaimList"}}'
	    	 
	        const message = JSON.parse(event.data);
	        console.log("부모가 받은 데이터:", message);
	        
	        if(message.type == 'HELP') {
	        	let helpValue = message.value;
	        	let helpTitle = encodeURIComponent(helpValue.title);
        		//경로에 파라미터 있으면 제거
        		let helpPath = helpValue.path.split("?")[0];
	        	
	        	var _width = '1200';
        	    var _height = '800';
        	 
        	    // 팝업을 가운데 위치시키기 위해 아래와 같이 값 구하기
        	    var _left = Math.ceil(( window.screen.width - _width )/2);
        	    var _top = Math.ceil(( window.screen.height - _height )/2); 
        		
        		let menualPop;
        		let menualUrl = "";
	        		
	        	if( gconsts.ADMIN == 'Y' ) {
	    			//1. 관리자일 경우 매뉴얼 등록 및 수정화면
	    			menualUrl = "/common/board/navHelp/form.do";
	    		}
	    		else {
	    			//2. 그 외에는 상세화면
	    			menualUrl = "/common/board/navHelp/view.do";
	    		}	
	    		
	    		//menualPop = window.open(context + menualUrl + '?bordNo='+helpPath+'&title='+helpTitle, 'menual_'+helpTitle,'width='+ _width +',height='+ _height +',left=' + _left + ',top='+ _top);
	    		menualPop = window.open(context + menualUrl + '?bordNo='+helpPath, 'menual_'+helpTitle,'width='+ _width +',height='+ _height +',left=' + _left + ',top='+ _top);
	    		
	    		return;
	        }
	        else { //IFURL
		        jmenus.goBlankTab(message.value);
	        }
	         
	    } catch (e) {
	        console.error("JSON 파싱 실패:", event.data);
	    }
	});
	
	function doMemuGo(key){
		jmenus.go(key);
	}
	
	function topSearch() {
		let searchValue = $("#topSearch").val();
		let params = {
				title: "Search",
				path: "",
				value: searchValue
		}
		//alert(searchValue);
		
		//화면 탭으로 열고, iframe에 검색화면 보여주기
		jmenus.goBlankTab(params);
	}
	
	
	function myAccountMenu(auth) {
		//관리자일 경우 MyAccount
		/* if(auth == 'ADMIN') {
			jmenus.go('LS605');
		} */
		if(auth == 'DEAL') {
			//dealer인 경우 My info
			jmenus.go('LS603');
		}
		else {
			//dealer가 아닌 경우 My Account
			//jmenus.go('LS601');
			jmenus.go('LS605');
		}
	}
	
	//로고 및 Home 메뉴 클릭 시 index 이동
	function goHome() {
		document.location.href = context + "/index.do";
	}



</script>

<iframe id="sfdcSsoFrame" name="sfdcSsoFrame" style="display:none;"></iframe>

<!-- sso 연결 확인을 위한 -->
<c:if test="${user.sfdcFlag == 'Y'}">
	<iframe id="sfdcSsoCon" name="sfdcSsoCon" style="display:none;"></iframe>
</c:if>

<!-- sfdc 로그인 자동 갱신 기능 임시 비활성화 -->
<%-- 
<c:if test="${!empty user.userId}">
<script type="text/javascript">
	let ssoStatus = false;
	let ssoMsg = "";
	
	//sso 확인 연결을 위한
    $("#sfdcSsoCon").attr("src", salesforseUrl + "/s/");

  async function checkSessionAndRenew() {
	  try {
	    const response = await fetch(getUrl("/saml/sessionCheck"));
	    const data = await response.json();
	    
	    if (data.status === "expired" && data.samlResponse) {
	      
	      const form = document.createElement("form");
	      form.method = "post";
	      form.action = data.acsUrl;
	      form.target = "sfdcSsoFrame";

	      const input = document.createElement("input");
	      input.type = "hidden";
	      input.name = "SAMLResponse";
	      input.value = data.samlResponse;
	      form.appendChild(input);

	      document.body.appendChild(form);
	      form.submit();

	      setTimeout(() => form.remove(), 1000);
	      
	      let ssoTime = new Date().getTime();
	      sessionStorage.setItem('ssoTime', ssoTime);
	      
	    }
	  } catch (err) {
	  }
	}

	// 2시간마다 실행 (7200초 = 2시간, ms 단위)
	let ssoTimer = setInterval(checkSessionAndRenew, 7200 * 1000);
	
	// 페이지 로딩 직후 한번 실행
	let sSsoTime = sessionStorage.getItem('ssoTime') || 0;
	let diff = 0;
	if(sSsoTime != 0) {
		const now = new Date().getTime();
		diff = now - parseInt(sSsoTime, 10);
	}
	let chkTime = 60 * 60 * 1000 * 2;
	
	if(sSsoTime==0 || diff > chkTime) {
		checkSessionAndRenew();
	}
</script>
</c:if>
--%>