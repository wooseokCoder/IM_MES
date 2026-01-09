<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)login.jsp 1.0 2014/07/30                                           --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 비밀번호 변경 화면이다.                                                       	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<script type="text/javascript">
	 var context = "<c:out value="${pageContext.request.contextPath}" />";
</script>
<script type="text/javascript" src="<c:url value="/resources/js/exhibitionRegist.js" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/login.css" />" />

<script type="text/javascript">
	 doInit({
		message: '${exception.message}'
	});

</script>
<script>

$(function() {

	$('#language').on('change', function() {
		doLanguage();
	});
});

$(window).load(function() {
	//$(".wui-dialog").show();
});

</script>
</head>
	<!--<body bgcolor="#FFFFFF" text="#000000" background="<%=request.getContextPath() %>/resources/images/login/login_bkcolor.png" style=margin:0> -->
	<body class="login-body" style="margin:0; >
		<div class="backg">
			<input type="hidden" name="exhbnCode" id="h_exhbnCode" value="<%=request.getParameter("code") %>"/>
		</div>	
		
		
		<div class="img-section">
			<img src="/lsdp_data/upload/image/exhbn/<%=request.getParameter("code")%>.png" style="width:100%; height:90%;">
			<%-- <img src="/filepath/exhbn/<%=request.getParameter("code")%>.png" style="width:100%; height:90%;"> --%>
			<%-- <span>1111, <%=request.getParameter("code")%></span> --%>
			<div class="text-section">
				<form id="save-form">
					<fieldset> <!-- class="div-line-new"  -->
		        		<table cellpadding="5" class="search-table tableSearch-c non-board-search-table">
		        			<tr>
		        				<th colspan="3" class="h table-Search-h-left search-label-h" data-item="LAB_001" ><span>First Name</span><span style="color:red;">*</span></th>
		        			</tr>
		        			<tr>
		        				<td colspan="3" class="d">
									<input name="firstName" id="firstName" class="input_css"/>
								</td>
		        			</tr>
		        			<tr>
		        				<th colspan="3" class="h table-Search-h-left search-label-h" data-item="LAB_001" ><span>Last Name</span><span style="color:red;">*</span></th>
		        			</tr>
		        			<tr>
		        				<td colspan="3" class="d">
									<input name="lastName" id="lastName" class="input_css"/>
								</td>
		        			</tr>
		        			<tr>
		        				<th colspan="3" class="h table-Search-h-left search-label-h" data-item="LAB_001" ><span>Phone</span></th>
		        			</tr>
		        			<tr>
		        				<td colspan="3" class="d">
									<input type="text" name="phone" id="phone" class="input_css" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength='10'/>
								</td>
		        			</tr>
		        			<tr>
		        				<th colspan="3" class="h table-Search-h-left search-label-h" data-item="LAB_001" ><span>Country</span></th>
		        			</tr>
		        			<tr>
		        				<td colspan="3" class="d">
		        					<select class="input_css" name="country" ID="country" onChange="getStates()">
			                            <option value="">Select</option>
			                            <option value="US">US</option>
		                                <option value="CA">CA</option>
			                        </select>
									<!-- <input name="exhbnCode" id="s_exhbnCode" class="input_css"/> -->
								</td>
		        			</tr>
		        			<tr>
		        				<th colspan="3" class="h table-Search-h-left search-label-h" data-item="LAB_001" ><span>Address</span></th>
		        			</tr>
		        			<tr>
		        				<td colspan="3" class="d">
									<input class="input_css" name="addr" id="addr" autocomplete='off' />
								</td>
		        			</tr>
		        			<tr>
		        				<th class="h table-Search-h-left search-label-h" data-item="LAB_003"><span>City</span></th>
		        				<th class="h table-Search-h-left search-label-h" data-item="LAB_003"><span>States</span></th>
		        				<th class="h table-Search-h-left search-label-h" data-item="LAB_003"><span>Zipcode</span></th>
		        			</tr>
		        			<tr>
		        				<td class="d">
									<input class="input_css3" name="city" id="city"  data-options="height:30"/>
								</td>
								<td class="d">
									<select  class="input_css" name="state" ID="state">
										<option value="">Select</option>
										<c:forEach var="item" items="${getStates}">
											<option value="${item.codeCd}" >${item.codeCd}</option>
										</c:forEach>
			                        </select>
									<!-- <input class="input_css3" name="states" id="states"  data-options="height:30"/> -->
								</td>
								<td class="d">
									<input class="input_css3" name="zipCode" id="zipCode"  data-options="height:30" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength='5'/>
								</td>
		        			</tr>
		        			<tr>
		        				<th colspan="3" class="h table-Search-h-left search-label-h" data-item="LAB_001" ><span>Email</span><span style="color:red;">*</span></th>
		        			</tr>
		        			<tr>
		        				<td colspan="3" class="d">
									<input name="email" id="email" class="input_css"/>
								</td>
		        			</tr>
		        		</table>
		        	</fieldset>
		        	
			       	<div class="coupon_exp">
			        	<span id="coupon_code"></span>
			        	Coupon expires in
			        	<span id="coupon_date"></span>
		        	</div>
		        	
		        	<div class="save_btn_box">
		        		<a href="javascript:void(0)" id="save-button" class="easyui-linkbutton c6" data-item="BTN_001" >Submit & Request Coupon</a>
		        	</div>
<!-- 		        	<div class="save_btn_box">
		        		<input type="button" class="easyui-linkbutton c6 submit_input" id="save-button2" value="Submit & Request Coupon">
		        	</div>
		        	<div class="save_btn_box">
		        		<div class="easyui-linkbutton c6 submit_btn" id="save-button3">Submit & Request Coupon</div>
		        	</div>
		        	<div class="save_btn_box">
		        		<input type="button" class="easyui-linkbutton c6 submit_input" onclick="doMailCheck();" value="Submit & Request Coupon">
		        	</div>
		        	<div class="save_btn_box">
		        		<div class="easyui-linkbutton c6 submit_btn" onclick="doMailCheck();">Submit & Request Coupon</div>
		        	</div> -->
		        </form>	
			</div>
				
		</div>
		
		<div id="background">
			<div class="popup_box" style="display: inline-block;">
				<img class="popup_img" src="<%=request.getContextPath() %>/resources/images/login/lsta_logo2.png" style="width: 60%;">
				<div class="popup_text">
				</div>
				<div class="popup_btn_box">
					<!-- <a href="javascript:void(0)" id="popup-button" class="easyui-linkbutton c6" data-item="BTN_002" >Ok</a> -->
					<a href="javascript:void(0)" id="popup-button2" class="easyui-linkbutton c6" data-item="BTN_002" style="display: none;">Ok</a>
				</div>
			</div>
		</div>
		
		
	</body>
</html>

<style>
.panel-title {
    font-weight: bold;
    height: 30px;
    line-height: 30px;
    color: #2985db;
	font-size: 4.5em;
	padding-bottom: 21px;
	padding-left: 18px;
}
.window {
    background-color: #ffffff;
}
.window, .window .window-body {
    border-color: #ffffff;
}

.login-section {height:510px !important;}
.search-table tr th{
	padding-top: 2%;
}
.text-section {
	width: 80%;
	height: 800px;
	position: absolute;
	left: 50%;
	transform: translate(-50%, 0);
}
.text-section span {
	color:#30456E;
}
.img-section {
	/* border: 1px solid black; */
	width: 90%; 
	/* height: 800px; */
	z-index: 99;
   	position: absolute;
   	top: 2%;
	left: 50%;
	transform: translate(-50%, 0);
}
.img-section span {
	color:#30456E;
}
.input_css{
	 border:1px solid #CBC7BD;
	 /* width:390px; */
	 width:100%;
	 height: 75px;
	 /* height: 25px; */
	 border-radius:4px;
	 color:black;
	 font-size: 4.5em;
}
.input_css3{
	 border:1px solid #CBC7BD;
	 /* width:114px; */
	 width:100%;
	 /* height: 25px; */
	 border-radius:4px;
	 color:black;
	 font-size: 4.5em;
}
.non-board-search-table {
	/* width: 400px; */
}

.non-board-search-table span{
	font-size: 4.5em;
}

.coupon_exp{
	color:black;
	margin-top: 10%;
	height:10%;
	text-align: center;
	line-height:30px;
	font-size: 3.7em;
	font-weight: 800;
}
.save_btn_box{
	margin-top: 5%;
	padding-bottom: 10%;
    height: 26%;
	text-align: center;
}
.save_btn_box a{
	width:100%;
	height:100%;
	display:inline-block;
	font-size: 3.0em;
	border-radius:10px;
}
.save_btn_box a span{
	height: 100%;
	display:inline-block;
	font-size: 1.3em;
	color:white !important;
}
.save_btn_box a span > span{
	top:50%;
	transform: translate(0%, 35%);
}

#background{
	z-index: 999;
   	position: fixed;
	width: 100%; 
	height: 100%;
	background-color: white;
}
.popup_box{
	/* border:1px solid black; */
	width:80%;
	height:35%;
	position: absolute;
	top:40%;
	left:50%;
	transform: translate(-50%, -50%);
	text-align: center;	
}
.popup_img{
	margin-top:2%;
}
.popup_text{
	margin-top:8%;
	color:black;
	font-size:4.5em;
	font-weight: 800;
}
.popup_btn_box{
	margin-top:10%;
	/* border:1px solid black; */
	height:15%;

}
.popup_btn_box a{
	width:60%;
	height:100%;
	display:inline-block;
	font-size: 3.0em;
	border-radius:15px;
}
.popup_btn_box a span{
	height: 100%;
	display:inline-block;
	font-size: 1.3em;
	color:white !important;
}
.popup_btn_box a span > span{
	top:50%;
	transform: translate(0%, 35%);
}

#popup-button2 {
	min-height: 100px;
}

#save-button{
	cursor:pointer;
}

.submit_btn{
	width:100%;
	height:100%;
	display:inline-block;
	font-size: 3.0em;
	border-radius:10px;
	text-align: center;
	cursor: pointer;
}
.submit_btn span{
	height: 100%;
	display:inline-block;
	font-size: 1.3em;
	line-height: 1.5em;
	text-align: center;
	color:white !important;
	cursor: pointer;
}

.submit_input{
	width:100%;
	height:100%;
	display:inline-block;
	border-radius:10px;
	text-align: center;
	cursor: pointer;
	font-size: 5.0em;
}
.submit_input:active, .submit_input:hover, .submit_btn:active, .submit_btn:hover{
	background: #24748f;
	cursor: pointer;
}




/* @media screen and (max-width: 760px) {	
	.img-section {
		border: 1px solid black;
		width: 350px; 
		height: 610px;
		z-index: 99;
    	position: absolute;
    	top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
	}
	

} */

</style>