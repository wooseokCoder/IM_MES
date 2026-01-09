<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)index.jsp 1.0 2014/07/30                                           --%>
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
<%-- 인덱스 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/mail/address.js" />"></script>
</head>

<body class="easyui-layout" id="main-layout">
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>
	<!-- [LAYOUT2] start -->
	<div class="easyui-layout" style="width:722px;height:435px;">
	    <!-- [WEST] start -->
	    <div data-options="region:'west',border:false" style="width:370px; ">
			<table id="search-grid" >
				<thead>
					<tr>
						<th data-options="field:'tgtUserId',   width:180, halign:'center', align:'left',editor:{type:'validatebox',options:{required:true}}, sortable:true, data_popup:'POP_GRD_001'">이메일</th>
						<th data-options="field:'tgtUserName', width:150, halign:'center', align:'left',editor:{type:'validatebox',options:{required:true}}, sortable:true, data_popup:'POP_GRD_002'">수신자명</th>
					</tr>
				</thead>
			</table>
			<div id="search-toolbar" class="wui-toolbar">
				<form id="search-form">
					<fieldset class="div-line-new" style="padding:8px 0px 10px 5px;">
						<input type="hidden" name="hdfIndex" id="hdfIndex" value="-1" />
						<input class="easyui-combobox" name="searchKey"  id="s_searchKey"  value="S01" codeGrup="ADDR_STYPE" data-options="mode:'remote',width:100,editable:false,loader:jcombo.loader"/>
						<input class="easyui-textbox"  name="searchText" id="r_searchText" style="width:150px"/>
						<a href="javascript:void(0)" class="easyui-linkbutton cgray l-btn l-btn-small" id="search-button" data-popup="POP_BTN_002">검색</a>
					</fieldset>
					<fieldset class="div-line-new-sub">
				        <table cellpadding="5" class="search-table  tableEtc-c" style="width:98%;">
				            <tr>
								<td>
									<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-popup="POP_BTN_003">추가</a>
									<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-popup="POP_BTN_004">삭제</a>
									<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"   data-popup="POP_BTN_005">저장</a>
								</td>
				            </tr>
				        </table>
					</fieldset>
				</form>
			</div>
		</div>
	    <!-- [CENTER] start -->
	    <div data-options="region:'center',border:false" style="width:50px;">
    		<div style="position:absolute;top:45%;left:-11px;;transform:translateY(-50%);">
    			<a href="javascript:void(0)" id="to_right_arow" style="padding:0 18px 0 18px;">
    				<img src="<%=request.getContextPath() %>/resources/images/addr_right-arrow.jpg" style="width:26px;"></img>
    			</a>
    			<a href="javascript:void(0)" id="to_left_arow" style="padding:0 18px 0 18px;">
    				<img src="<%=request.getContextPath() %>/resources/images/addr_left-arrow.jpg" style="width:26px;margin-top:15px;"></img>
    			</a>
   			</div>
   			<div style="position:absolute;top:85%;left:-11px;;transform:translateY(-50%);">
    			<a href="javascript:void(0)" id="cc_right_arow" style="padding:0 18px 0 18px;">
    				<img src="<%=request.getContextPath() %>/resources/images/addr_right-arrow.jpg" style="width:26px;"></img>
    			</a>
    			<a href="javascript:void(0)" id="cc_left_arow" style="padding:0 18px 0 18px;">
    				<img src="<%=request.getContextPath() %>/resources/images/addr_left-arrow.jpg" style="width:26px;margin-top:15px;"></img>
    			</a>
   			</div>
	    </div>
	    <div data-options="region:'east',border:false" style="width:310px;height:420px;">
	    	<div style="width:100%;height:46px;background-color:#fbf4ef;border-top:1px solid #dadada;border-bottom:1px solid #dadada;margin-top:1px;"></div>
	    	<div id="adder-toolbar" class="wui-toolbar datagrid-toolbar" >
				<form id="search-form"></form>
				<fieldset class="div-line-new-sub" style="padding-top:8px;">
			        <table cellpadding="5" class="search-table  tableEtc-c" style="width:95%;">
			            <tr>
							<td >
								<a href="javascript:void(0)" class="easyui-linkbutton c6" id="submit-button" style="float:right;" data-popup="POP_BTN_006">확인</a>
							</td>
			            </tr>
			        </table>
				</fieldset>
			</div>
	   			<p style="width:100%;height:25px;margin:0;font-weight:600;background-color:#E8E5E5;padding:3px 0px 3px 10px;" data-popup="POP_LAB_007">수신</p>
	   			<div style="border:1px solid #eee;width:100%;height:140px;overflow-y:auto;border-bottom:1px solid #8a8a8a;margin-bottom:9px;">
	    			<table id="to_list" style="width:100%;">
	    				
	    			</table>
	   			</div>
	    	
    			<p style="width:100%;height:25px;margin:0;font-weight:600;background-color:#E8E5E5;padding:3px 0px 3px 10px;" data-popup="POP_LAB_008">참조</p>
    			<div style="border:1px solid #eee;width:100%;height:140px;overflow-y:auto;border-bottom:1px solid #8a8a8a;">
	    			<table id="cc_list" style="width:100%;">
	    				
	    			</table>
    			</div>
    		</div>
	    			
	   	 </div>
	    		
	    </div>
<script type="text/javascript">

$(function() {
	doLangSettingPopTable();
});
</script>
</body>
</html>
