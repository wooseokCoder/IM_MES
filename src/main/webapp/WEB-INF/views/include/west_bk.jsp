<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)menu.jsp 1.0 2014/07/30                                            --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 메뉴 및 알람 섹션 화면이다.                                               --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>


<div class="easyui-layout" fit="true">
    <div data-options="region:'center',split:false,border:false">
		<div class="easyui-layout" fit="true">
			<div data-options="region:'north',split:false,border:false" style="height:300px">
				<div id="left-hotmenu" class="wui-menu" style="border-bottom:none;border-top:1px solid #e1e8ed;border-left:1px solid #e1e8ed;border-right:1px solid #e1e8ed;">
					<ul  id="hot-menu"></ul>
					<div id="hot-context" class="easyui-menu" style="width:80px">
						<div onclick="jwidget.hotmenu.delByMenu();" iconCls="icon-cancel">핫메뉴삭제</div>
					</div>
				</div>
			</div>
		    <div data-options="region:'center',split:false,border:false,minHeight:230" style="margin-bottom:30px;">
				<c:choose>
					<c:when test="${fn:indexOf(uri, '/index.do') == 0}">
						<div id="left-alarm" 
						     class="easyui-panel wui-menu" 
						     data-options="
						     	iconCls:'ui-icon ui-icon-newwin',
						     	title:'Alarm',
						     	collapsible:true,
						     	fit:true
						     ">
							<p>알람 영역</p>
						</div>
					</c:when>
					<c:otherwise>
						<div id="left-submenu" class="wui-menu" style="border:1px solid #e1e8ed;">
							<ul  id="left-menu"></ul>
							<div id="left-context" class="easyui-menu" style="width:80px">
								<div onclick="jwidget.hotmenu.addByMenu()" iconCls="icon-ok">핫메뉴추가</div>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
		    </div>
		</div>
    </div>
    <%-- BBUG.CHG : 메뉴접기 이전 모습 Split영역 width:30px  ->  5px  근데... minValue = 10 이라서리...
                    jquery.easyui.min.js에서 강제 조정 --%>
    <div data-options="region:'east',split:false,border:false" style="width:5px">
    	<a href="javascript:void(0)" class="easyui-linkbutton" id="menu-folding"></a>
    </div>
</div>
<script type="text/javascript">
$(function() {
	
	$("#menu-folding").bind("click", function() {
		//메뉴접기
		$("#main-layout").layout('collapse', 'west');
	});
 	//BBUG.KWK 메인화면 접근시 바로 접기
/* 	var temp = $(location).attr('pathname');
	if(temp.substring(temp.lastIndexOf("/")+1,temp.length) == 'index.do'){
		$("#main-layout").layout('collapse', 'west');
	} */
});
</script>
