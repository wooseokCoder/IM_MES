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
<%-- SAP Interface Test 화면이다.                                             	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2024/01/18                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/user/sapinterface.js?v=0730A" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
<style>
.sendBox{
	margin: 50px auto 0;
	/* border: 1px solid black; */
	position: relative;
	width: 1254px;
	height: 400px;
}
.sendBox2{
	margin: 50px auto 0;
	/* border: 1px solid black; */
	position: relative;
	width: 1254px;
	/* height: 1000px; */
	height: 1020px;
}
.getBox{
	margin: 0px auto;
	/* border: 1px solid red; */
	position: relative;
	width: 1254px;
	height: 250px;
}
.sapInb{
	display: inline-block;
	position: relative;
	width: 400px;
	margin-right: 20px;
}
.sapAssy{
	display: inline-block;
	position: relative;
	width: 400px;
	margin-right: 20px;
}
.sapCnsl{
	display: inline-block;
	position: relative;
	width: 400px;
}
.sapOutb{
	display: inline-block;
	position: relative;
	width: 400px;
	margin-right: 20px;
}
.Send{
	/* border: 1px solid blue; */
	height: 360px;
}
.Get{
	/* border: 1px solid red;
	height: 200px;*/
}
.inbTable{
	/* border: 1px solid blue; */
}
.inbTable tr{
	height: 30px;
}
.inbTable label{
	font-size: 15px;
}
.assyTable tr{
	height: 30px;
}
.assyTable label{
	font-size: 15px;
}
.outbTable tr{
	height: 30px;
}
.outbTable label{
	font-size: 15px;
}
.rowGubun{
	height: 20px;
	border-bottom: 1px solid gray;
}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none;overflow: auto;">
	<table cellpadding="5" class="search-table tableSearch-c wd-100" >
		<tr class="topnav_sty">
       		<td colspan="" >
       			<div>
        			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
            	</div>
			</td>
		</tr>
    </table>    
    
	<div class="sendBox2">
		<span class="sapOutb Send">
			<table class="sapOutb Send outbTable">
				<tr>
					<td style="width: 140px;"><label for='oShipLoc'   style="margin-bottom:0"  data-item="LAB_301" >Warehouse</label></td>
					<td style="width: 260px;"><input type="text" class="textbox-text" name="oShipLoc" id="oShipLoc" placeholder="US10/US11/US12/US17" value="US10" style="width:100%!important; height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oActDate'    style="margin-bottom:0"  data-item="LAB_302" >Act. Ship Date</label></td>
					<td><input type="text" class="textbox-text" name="oActDate" id="oActDate" placeholder="mm.dd.yyyy" value="12.06.2023" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oPostDate'    style="margin-bottom:0"  data-item="LAB_326" >Ship Post Date</label></td>
					<td><input type="text" class="textbox-text" name="oPostDate" id="oPostDate" placeholder="mm.dd.yyyy" value="12.06.2023" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSapPoNo'   style="margin-bottom:0"  data-item="LAB_303" >SAP Deli No</label></td>
					<td><input type="text" class="textbox-text" name="oSapPoNo" id="oSapPoNo" value="6110849496" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oPoNo'   style="margin-bottom:0"  data-item="LAB_304" >PO No</label></td>
					<td><input type="text" class="textbox-text" name="oPoNo" id="oPoNo" value="DO2312010001" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oBolNo'   style="margin-bottom:0"  data-item="LAB_327" >BOL No</label></td>
					<td><input type="text" class="textbox-text" name="oBolNo" id="oBolNo" value="BL2312060002" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oAssyNo'   style="margin-bottom:0"  data-item="LAB_325" >Assy. No</label></td>
					<td><input type="text" class="textbox-text" name="oAssyNo" id="oAssyNo" value="AO-231204-0047" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode1'  style="margin-bottom:0"  data-item="LAB_305" >Item Code 01</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode1" id="oItemCode1" value="19002449" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo1'    style="margin-bottom:0"  data-item="LAB_306" >Serial No 01</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo1" id="oSeriNo1" value="2368000537" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode2'  style="margin-bottom:0"  data-item="LAB_307" >Item Code 02</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode2" id="oItemCode2" value="19001532" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo2'    style="margin-bottom:0"  data-item="LAB_308" >Serial No 02</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo2" id="oSeriNo2" value="FL78AF0091" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode3'  style="margin-bottom:0"  data-item="LAB_309" >Item Code 03</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode3" id="oItemCode3" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo3'    style="margin-bottom:0"  data-item="LAB_310" >Serial No 03</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo3" id="oSeriNo3" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode4'  style="margin-bottom:0"  data-item="LAB_311" >Item Code 04</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode4" id="oItemCode4" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo4'    style="margin-bottom:0"  data-item="LAB_312" >Serial No 04</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo4" id="oSeriNo4" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode5'  style="margin-bottom:0"  data-item="LAB_313" >Item Code 05</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode5" id="oItemCode5" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo5'    style="margin-bottom:0"  data-item="LAB_314" >Serial No 05</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo5" id="oSeriNo5" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode6'  style="margin-bottom:0"  data-item="LAB_315" >Item Code 06</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode6" id="oItemCode6" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo6'    style="margin-bottom:0"  data-item="LAB_316" >Serial No 06</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo6" id="oSeriNo6" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode7'  style="margin-bottom:0"  data-item="LAB_317" >Item Code 07</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode7" id="oItemCode7" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo7'    style="margin-bottom:0"  data-item="LAB_318" >Serial No 07</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo7" id="oSeriNo7" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode8'  style="margin-bottom:0"  data-item="LAB_319" >Item Code 08</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode8" id="oItemCode8" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo8'    style="margin-bottom:0"  data-item="LAB_320" >Serial No 08</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo8" id="oSeriNo8" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode9'  style="margin-bottom:0"  data-item="LAB_321" >Item Code 09</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode9" id="oItemCode9" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo9'    style="margin-bottom:0"  data-item="LAB_322" >Serial No 09</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo9" id="oSeriNo9" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oItemCode10'  style="margin-bottom:0"  data-item="LAB_323" >Item Code 10</label></td>
					<td><input type="text" class="textbox-text" name="oItemCode10" id="oItemCode10" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td><label for='oSeriNo10'    style="margin-bottom:0"  data-item="LAB_324" >Serial No 10</label></td>
					<td><input type="text" class="textbox-text" name="oSeriNo10" id="oSeriNo10" value="" style="width:100%!important;height: 30px;"></input></td>
				</tr>
				<tr>
					<td></td>
					<td colspan="1" style="padding-top: 10px;"> 
						<div class="dis_flex" style="justify-content: space-between;">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="outb-send-button" data-item="BTN_007" data-options="disabled:${INS}" style="">Send</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="outb-clear-button" data-item="BTN_008">Clear</a>
						</div>
					</td>
				</tr>
			</table>
		</span>
	</div>
	<div class="getBox">
		<span class="sapOutb Get">
			<span style="font-size: 20px; font-weight: 600;">Outbound Result</span>
			<textarea id="outbTextArea" style="width: 100%; height: 200px;"></textarea>
		</span>
	</div>
	
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

<!-- [LAYOUT] end -->
</div>
</html>
