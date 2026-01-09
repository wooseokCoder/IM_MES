<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)user.jsp 1.0 2014/08/12                                            --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 패스워드 초기화 화면이다.                                                         --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/saml/ssoservice.js?v=0618" />"></script>
<script type="text/javascript">
     doInit({
        domain: '<spring:eval expression="@app['domain.user']"/>'
    });
</script>

<style>
#cust-search-dialog {
display:none !important;
}
#remote-dialog .l-btn-text {
   display: inline-block;
   vertical-align: top;
   line-height: 30px;
   font-size: 22px !important;
   font-family: "Amazon Ember", Arial, sans-serif !important;
   font-weight: 600;
   padding: 0;
    /* margin: 0 4px; */
}
.changePw-div{
    margin-top: 138px !important;
    height: 246px !important;
    display:none;
}
</style>

<script>

</script>
</head>

<input type="hidden" name="gsUserId" id="gsUserId" value="${gsUserId}"/>
<input type="hidden" name="gsClientId" id="gsClientId" value="${selectClient.clientId}"/>
<input type="hidden" name="gsClientSecret" id="gsClientSecret" value="${selectClient.clientSecret}"/>
<input type="hidden" name="gsOrgAuthCode" id="gsOrgAuthCode" value="${selectClient.orgAuthCode}"/>
<input type="hidden" name="gsIdSproutLoud" id="gsIdSproutLoud" value="${selectClient.idSproutLoud}"/>

<input type="hidden" name="gsType" id="gsType" value="${selectClient.type}"/>  
<input type="hidden" name="gsFirstName" id="gsFirstName" value="${selectClient.firstName}"/> 
<input type="hidden" name="gsLastName" id="gsLastName" value="${selectClient.lastName}"/> 
<input type="hidden" name="gsAddress1" id="gsAddress1" value="${selectClient.address1}"/> 
<input type="hidden" name="gsCity" id="gsCity" value="${selectClient.city}"/> 
<input type="hidden" name="gsRegionCode" id="gsRegionCode" value="${selectClient.regionCode}"/> 
<input type="hidden" name="gsPostalCode" id="gsPostalCode" value="${selectClient.postalCode}"/> 
<input type="hidden" name="gsUserMail" id="gsUserMail" value="${selectClient.userMail}"/> 
<input type="hidden" name="gsUserHp" id="gsUserHp" value="${selectClient.userHp}"/> 
<input type="hidden" name="gsTargetUrl" id="gsTargetUrl" value="${selectClient.targetUrl}"/> 
<input type="hidden" name="gsMasterAccountId" id="gsMasterAccountId" value="${selectClient.masterAccountId}"/> 
<input type="hidden" name="gsUserType" id="gsUserType" value="${selectClient.userType}"/> 
<input type="hidden" name="gsSproutKey" id="gsSproutKey" value="${selectClient.sproutKey}"/> 
<input type="hidden" name="gsMemberAccountId" id="gsMemberAccountId" value="${selectClient.memberAccountId}"/>
<input type="hidden" name="gsCompanyName" id="gsCompanyName" value="${selectClient.companyName}"/>  
<input type="hidden" name="gsSsoUrl" id="gsSsoUrl" value="${selectClient.masterSsoUrl}"/> 
<input type="hidden" name="gsMasterHandUrl" id="gsMasterHandUrl" value="${selectClient.gsMasterHandUrl}"/>
<input type="hidden" name="gsMemberHandUrl" id="gsMemberHandUrl" value="${selectClient.gsMemberHandUrl}"/>   
<input type="hidden" name="gsTokenUrl" id="gsTokenUrl" value="${selectClient.gsTokenUrl}"/>
<input type="hidden" name="gsAssertion" id="gsAssertion" value="${selectClient.Assertion}"/>
<input type="hidden" name="gsAlertMessage" id="gsAlertMessage" value="${selectClient.alertMessage}"/>
<input type="hidden" name="gsAlertMessage2" id="gsAlertMessage2" value="${selectClient.alertMessage2}"/>


<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="overflow: hidden;" >
	<div class="changePw-div">
		<table class="changePw-table">
			<tr style="background:#0e4f87">
				<td class="changePw-title">
					<span data-item="LAB_001">Salesforce</span>
				</td>
			</tr>
			<tr>
				<td class="changePw-center changePw-img" id="alertPop" style="font-size: 20px;color: #002555;font-weight: 600;">
				</td>
			</tr>	
			<tr>
				<td class="changePw-center" style="padding-top:10px;">
			    	<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remote-back-button" data-item="BTN_001" style="width;100%">OK</a>
				</td>
			</tr>
		</table>
	</div>



<!-- [LAYOUT] end -->
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>


<form id ="myForm" action="" method="post" enctype="application/x-www-form-urlencoded">
    <input type="hidden" id="login_data" name="login_data" value="">
</form>


</html>

