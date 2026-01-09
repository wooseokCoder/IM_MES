<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)south.jsp 1.0 2014/07/30                                           --%>
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
<%-- 하단 섹션 화면이다.                                                    --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- 상세 화면 -->

<style type="text/css">
#loading-mask {
    position:absolute;
    top:0;
    left:0;
    z-index:30000;
    background-color:#ffffff;
    opacity:0.80;
    filter:alpha(opacity=80);
    display:none;
}
#ehelp-frame{
 /* position:fixed; */
 width:1014px;
 height:600px;
 border:0px;
/*  top:50%;
 left:50%;
 z-index:99999;
 transform:translate(-50%, -50%);
 display:none; */
} 
</style>
<div id="loading-mask"></div>
<iframe id="behind-iframe" name="behind-iframe" style="display:none;"></iframe>

<!-- 도움말 -->
<div id="ehelp" class="wui-dialog" style="display:none;">
	<div id="search-toolbar" class="wui-toolbar">
		<form id="move-form">
			<fieldset class="div-line-new" style="margin-bottom: 0px">
		        <table cellpadding="5" class="search-table tableSearch-c" >
		            <tr>
						<!-- <th class="h table-Search-h"></th> -->
						<td class="d" style="padding-left:5px;">
							<input type="hidden" name="text_ehelp_menuKey" id="text_ehelp_menuKey" value="N0001"/>
							<input type="radio" name="chkinfoView" value="manu" checked="checked" onclick="javascript:doEHelpMove();"><span data-popup="POP_LAB_901">메뉴얼</span>
							<input type="radio" name="chkinfoView" value="memo" onclick="javascript:doEHelpMove();"><span data-popup="POP_LAB_902">사용자메모</span>
							<c:if test="${groupIdC eq 'DEVADMIN'}">
								<a href="javascript:langTextPopSave();">언어저장</a>
							</c:if>
						</td>
						<!-- <td class="b">
							<a href="javascript:void(0)" class="easyui-linkbutton cgray" iconCls="icon-search" id="search-button">검색</a>
							<a href="javascript:void(0)" id="ehelp-save-button" class="easyui-linkbutton cgray">저장</a> 
						</td> -->
		            </tr>
		        </table>
		   </fieldset>
		</form>
	</div>
	<div id="ehelpmanu" style="display: none">
		<iframe id="ehelp-manu-frame" name="ehelp-manu-frame" ></iframe>
	</div>
	<div id="ehelpmemo" style="display: none">
		<iframe id="ehelp-meno-frame" name="ehelp-meno-frame" style=" width:100%;height:670px;border:0px;"></iframe>
	</div>
</div>

<form name="eHelpSend" method="POST">
	<input type="hidden" id="eHelpMenuKey" name="eHelpMenuKey" value="00001" />
</form>
<style type="text/css">
#ehelp-manu-frame{
 /* position:fixed; */
 width:100%;
 height:650px;
 border:0px;
/*  top:50%;
 left:50%;
 z-index:99999;
 transform:translate(-50%, -50%);
 display:none; */
} 

#ehelp-memo-frame{
 /* position:fixed; */
 width:1014px;
 height:600px;
 border:0px;
/*  top:50%;
 left:50%;
 z-index:99999;
 transform:translate(-50%, -50%);
 display:none; */
} 
</style>