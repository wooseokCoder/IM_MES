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
<%-- 사용자관리 화면이다.                                                      --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/report/reportchart.js" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
	 
	 
	 
</script>

</head>



<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<div id="search-toolbar" class="wui-toolbar">
<!-- fieldset 변경 20190628 박소현 -->
	<form id="search-form">
		<fieldset  class="div-line-new">
	        <table cellpadding="5" class="search-table tableSearch-c">
	            <tr>
					<th class="h table-Search-h"><span data-item="LAB_001">유형 </span></th>
					<td class="d">
						<input class="easyui-combobox" name="userType" id="s_userType"
							data-options="width:60,
										mode:'remote',
										editable:false,
										loader:jcombo.loader,
										params:{codeGrup:'USER_TYPE'}
										"
						/>
					</td>
					<th class="h"><span data-item="LAB_002">사용여부 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="useFlag" ID="s_useFlag">
							<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'USE_FLAG' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
							</c:forEach>
						</select>
					</td>
					<th class="h"><span data-item="LAB_003">사용자ID </span></th>
					<td class="d">
						<input type="text" class="easyui-textbox" name="userId" id="s_userId" data-options="width:120"></input>
					</td>
					<th class="h"><span data-item="LAB_004">사용자명 </span></th>
					<td class="d">
						<input type="text" class="easyui-textbox" name="userName" id="s_userName" data-options="width:120"></input>
					</td>
					<td class="b">
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">검색</a> 
						<input type="hidden" id="hdfIndex" value="-1" />
						<input type="hidden" id="hdfChk" value="" />
					</td>
	            </tr>
	        </table>
	      </fieldset>
	</form>
</div>

<iframe id="iReport" frameborder="0" src="" style="width:100%;height:90%;"></iframe>
<script>

var defaultParams = {};
var defaultReportUrl = "";

$.ajax({
    url: getUrl('/common/report/reportUrl.json'),
    dataType: 'json',
    async: false,
    type: 'post',
    data: defaultParams,
    success: function(data){
    	//console.log(data.reportUrl);
    	if (!data)
    		return;
    	
    	defaultReportUrl = data.reportUrl + "&reportUnit=/reports/easyFrame/reportCh"
    },
    error: function(){
    }
});

//console.log(defaultReportUrl);
document.getElementById('iReport').src = ""+defaultReportUrl;
</script>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
