<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)popupForm.jsp 1.0 2015/05/20                                       --%>
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
<%-- 팝업관리 화면(페이지 이동형태의 게시판).                                    			--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2015/05/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/board/popupForm.js" />"></script>
<script type="text/javascript">
	doInit({
		oper:     '${model.oper}',
		sysId:    '${model.sysId}',
		title:    '${model.bordName}',
		bordNo:   '${model.bordNo}',
		bordGrup: '${model.bordGrup}',
		bordType: '${model.bordType}'
	});
</script>
<style>
/*.panel-header{color:#000 !important; border-bottom:1px solid #ccc !important;border-top:1px solid #ccc !important;}*/
.panel-header{color:#000 !important;padding-left:0px;}
.adjust-select th{border-right:1px solid #ededed;}
#editor-area{padding-top:10px;padding-bottom:12px;}
.window{
    background-color: #F2F2F2;
    background: linear-gradient(to bottom,#ffffff 0,#F2F2F2 20%);
    background-repeat: repeat-x;
    border-color: #D4D4D4;
}
.panel-title {
    font-size: 12px;
    font-weight: bold;
    color: #777;
    height: 16px;
    line-height: 16px;
}
.panel{
margin: 0;
    border: 0;
}
iframe {
    border-width: 1px;
    border-style: inset;
    border-color: initial;
    border-image: initial;
}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%-- <%@ include file="/WEB-INF/views/include/topnav.jsp" %> --%>
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>
		<div id="regist-panel" class="easyui-panel brd_edit_h" data-options="fit:true" >

		    <form id="regist-form" method="post">

		    	<fieldset>
					<input type="hidden" name="oper"     id="r_oper"     value="${model.oper}"    />
					<input type="hidden" name="sysId"    id="r_sysId"    value="${model.sysId}"   />
					<input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
					<input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>
					<input type="hidden" name="bordType" id="r_bordType" value="${model.bordType}"/>
					<input type="hidden" name="openCls"  id="r_openCls"  value="${model.openCls}"/>

					<table class="adjust-select">
						<tr class="topnav_sty">
							<td colspan="4">
								<div>
									<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
								</div>
							</td>
						</tr>
				
						<tr>
							<th width="12%" data-item="POP_LAB_002"><span>Period</span></th>
							<td width="88%"><input class="easyui-datebox" name="bordBgn" id="r_bordBgn" value="${model.bordBgn}" data-options="required:true,validType:'validDate',width:120"/> ~
							    <input class="easyui-datebox" name="bordEnd" id="r_bordEnd" value="${model.bordEnd}" data-options="required:true,validType:'validDate',width:120"/>
								<input type="checkbox" name="justOne" id='r_justOne' onChange="doJustOne();" value="N" style='margin-left:30px;width:20px !important'/><label for='justOne' style="margin-bottom:0" >Just one look</label>
							</td>
						</tr>
						<tr>
							<th data-item="POP_LAB_003"><span>Type</span></th>
							<td><input name="openType" id="r_openType" style="width:100%"/></td>
						</tr>
						<tr>
							<th data-item="POP_LAB_001"><span>Title</span></th>
							<td><input class="easyui-textbox" name="bordTitle" id="r_bordTitle" style="width:100%" data-options="required:true,validType:'length[0,100]'"/></td>
						</tr>
						<tr>
							<th data-item="POP_LAB_001"><span>Display to</span></th>
							<td>
							<input type="checkbox" type="checkbox" name="typeKey"  onChange="doTargetChange(this);" value="ALL" style='margin-left:10px;'/><label style="margin-bottom:0" >All user</label>
							<input type="checkbox" type="checkbox" name="typeKey"  onChange="doTargetChange(this);" value="DLR" style='margin-left:10px;'/><label style="margin-bottom:0" >All dealer</label>
							<input type="checkbox" type="checkbox" name="typeKey"  onChange="doTargetChange(this);" value="LSA" style='margin-left:10px;'/><label style="margin-bottom:0" >LSTA</label>
							<input type="checkbox" type="checkbox" name="typeKey"  onChange="doTargetChange(this);" value="USR" style='margin-left:10px;'/><label style="margin-bottom:0" >Specific dealer</label>
							<input class="easyui-textbox" name="targetValue" id="r_targetValue" style="width:70%;margin-right:10px;" data-options="" />
							<a onclick="javascript:void(0)"><img id="search-dealer-button" style="cursor: pointer;" src="<c:url value="/resources/images/icon_new/Icon_search.png"/>"/></a>
							<input type="hidden" name="bordType"  id="r_bordType"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div id="editor-area">
									<textarea name="bordText" id="r_bordText" class="sceditor wui-editor"></textarea>
								</div>
			 				</td>
						</tr>
					</table>
		    	</fieldset>
		    </form>
		    <div style="text-align:center;padding:5px">
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"  id="save-button"   data-item="POP_BTN_005">Save</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"  id="remove-button" data-item="POP_BTN_006">Delete</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"  id="list-button"   data-item="POP_BTN_007">List</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton c6"  id="preview-button"data-item="POP_BTN_008">Preview</a>
		    </div>

		</div>

<form id="hidden-form" method="post">
	<input type="hidden" name="oper"       id="h_oper"       value=""/>
	<input type="hidden" name="bordNo"     id="h_bordNo"     value="${model.bordNo}"/>
	<input type="hidden" name="sysId"      id="h_sysId"      value="${model.sysId}"/>
	<input type="hidden" name="bordGrup"   id="h_bordGrup"   value="${model.bordGrup}"/>
	<input type="hidden" name="bordType"   id="h_bordType"   value="${model.bordType}"/>
	<input type="hidden" name="searchKey"  id="h_searchKey"  value="${model.searchKey}"/>
	<input type="hidden" name="searchText" id="h_searchText" value="${model.searchText}"/>
	<input type="hidden" name="openCls"    id="h_openCls"    value="${model.openCls}"/>
	<input type="hidden" name="rows"       id="h_rows"       value="${model.rows}"/>
	<input type="hidden" name="page"       id="h_page"       value="${model.page}"/>
</form>

<script type="text/javascript">

$(function() {                                           
	document.getElementById("dealer-iframe").src = context + "/common/board/dealerSearch/dealerSelect.do";
	$("#search-dealer-button").bind("click", function(){
		
		$("#dealer-popup").dialog("open");
		var iObj = document.getElementById('dealer-iframe').contentWindow;
		iObj.setTrList();
		var popupCustom = $("#dealer-popup").parent();
		var dynamicHeight = 0;
		var fixedHeight = 0;

		 dynamicWidth = window.innerWidth;
		 dynamicHeight = window.innerHeight;
	
		 resizeWidth = dynamicWidth/2 - 750/2;
		 resizeHeight = dynamicHeight/2 - 500/2;
	
		 if(dynamicWidth>800){
			 popupCustom.css("left",resizeWidth);
			 popupCustom.next(".window-shadow").css("left",resizeWidth);
		 }
	
		 if(dynamicHeight>700){
			 popupCustom.css("top",resizeHeight);
			 popupCustom.next(".window-shadow").css("top",resizeHeight);
		 }
	});
	doLangSettingPopTable();
});

</script>

<!-- 팝업용 레이어 -->
<div id="dealer-popup" class="easyui-dialog" data-options="
	 	width: 750,
	 	height: 535,
	 	closed: true,
	 	modal: true,
	 	title:'dealer select',
	 	iconCls:'icon-edit'">
	 <iframe id="dealer-iframe" src="" style="width:100%;height:100%; border: none;"></iframe>
</div>  
<!-- 팝업용 레이어 -->
<div id="popup-dialog"></div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
