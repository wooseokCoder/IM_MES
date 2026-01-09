<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)code.jsp 1.0 2014/08/05                                            --%>
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
<%-- 코드관리 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/code2/code2.js" />"></script>
<!-- 2016/12/02 김영진 -- 하단 상세화면 타이틀 크기 조절 -->
<style>
	.sub-table-height26{margin-top:10px;border-top:2px solid #3879D9;}
	.sub-table-height26 > .easyui-fluid > .panel-header{height:26px;line-height:26px;padding:0;}
	.sub-table-height26 > .easyui-fluid > .panel-header > .panel-title{height:26px !important;line-height:26px !important;padding-left:25px;}
	.sub-table-height26 .select-table th{text-align:center;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true">



    <!-- [SOUTH] start -->
    <div data-options="region:'south',border:false" class="sub-table-height26">
		
		<div class="easyui-panel"
			data-options="
				title:'${progName} 상세',
				fit:true,
				iconCls:'icon-edit'
			" style="padding-bottom:31px;">
		    <form id="regist-form" method="post">
		    	<fieldset>
		    		<input type="hidden" name="sysId" id="r_sysId" />
		    		<input type="hidden" name="oper"  id="r_oper"  />

			        <table cellpadding="5" cellspacing="2" class="select-table">
			            <tr>
							<th style="width:100px;"><span data-item="LAB_001">코드</span><p class="essential"></p></th>
							<td style="width:25%;"><input class="easyui-textbox" name="codeCd" id="r_codeCd" data-options="width:100,required:true" /></td>
							<th style="width:100px;"><span data-item="LAB_002">코드그룹</span><p class="essential"></p></th>
							<td style="width:25%;"><input class="easyui-combobox" name="codeGrup" id="r_codeGrup" codeGrup="0" data-options="width:150,mode:'remote',required:true,editable:false,loader: jcombo.loader"/></td>
							<th style="width:100px;"><span data-item="LAB_003">사용유무</span></th>
							<td><input name="useFlag" type="radio" value="Y" id="r_useFlag1"/><label for="r_useFlag1" data-item='LAB_030'>사용중</label>
								<input name="useFlag" type="radio" value="N" id="r_useFlag2"/><label for="r_useFlag2" data-item='LAB_031'>중지</label>
							</td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_004">순서</span><p class="essential"></p></th>
							<td><input class="easyui-numberbox" name="sortSeq" id="r_sortSeq" data-options="width:100,min:0,required:true" /></td>
							<th><span data-item="LAB_005">코드명칭</span><p class="essential"></p></th>
							<td><input class="easyui-textbox" name="codeName" id="r_codeName" data-options="width:150,required:true" /></td>
							<th><span data-item="LAB_006">등록자ID</span></th>
							<td><span id="r_regiId"></span></td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_007">코드설명</span></th>
							<td><input class="easyui-textbox" name="codeDesc" id="r_codeDesc" style="width:100%;" data-options="validType:'length[0,100]'"/></td>
							<th><span data-item="LAB_008">코드명칭(영문)</span></th>
							<td><input class="easyui-textbox" name="codeNameEn" id="r_codeNameEn" style="width:100%;" /></td>
							<th><span data-item="LAB_009">수정일시</span></th>
							<td><span id="r_chngDate"></span></td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_010">기타정보</span></th>
							<td colspan="3"><input class="easyui-textbox" name="extText" id="r_extText" style="width:100%;" data-options="validType:'length[0,100]'" /></td>
							<th><span data-item="LAB_011">등록일시</span></th>
							<td><span id="r_regiDate"></span></td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_012">문자속성01</span></th><td><input class="easyui-textbox"   name="extChr01" id="r_extChr01" style="width:100%;" /></td>
							<th><span data-item="LAB_013">문자속성06</span></th><td><input class="easyui-textbox"   name="extChr06" id="r_extChr06" style="width:100%;" /></td>
							<th><span data-item="LAB_014">숫자속성01</span></th><td><input class="easyui-numberbox" name="extNum01" id="r_extNum01" style="width:100%;" data-options="min:0" /></td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_015">문자속성02</span></th><td><input class="easyui-textbox"   name="extChr02" id="r_extChr02" style="width:100%;" /></td>
							<th><span data-item="LAB_016">문자속성07</span></th><td><input class="easyui-textbox"   name="extChr07" id="r_extChr07" style="width:100%;" /></td>
							<th><span data-item="LAB_017">숫자속성02</span></th><td><input class="easyui-numberbox" name="extNum02" id="r_extNum02" style="width:100%;" data-options="min:0" /></td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_018">문자속성03</span></th><td><input class="easyui-textbox"   name="extChr03" id="r_extChr03" style="width:100%;" /></td>
							<th><span data-item="LAB_019">문자속성08</span></th><td><input class="easyui-textbox"   name="extChr08" id="r_extChr08" style="width:100%;" /></td>
							<th><span data-item="LAB_020">숫자속성03</span></th><td><input class="easyui-numberbox" name="extNum03" id="r_extNum03" style="width:100%;" data-options="min:0" /></td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_021">문자속성04</span></th><td><input class="easyui-textbox"   name="extChr04" id="r_extChr04" style="width:100%;" /></td>
							<th><span data-item="LAB_022">문자속성09</span></th><td><input class="easyui-textbox"   name="extChr09" id="r_extChr09" style="width:100%;" /></td>
							<th><span data-item="LAB_023">숫자속성04</span></th><td><input class="easyui-numberbox" name="extNum04" id="r_extNum04" style="width:100%;" data-options="min:0" /></td>
			            </tr>
			            <tr>
							<th><span data-item="LAB_024">문자속성05</span></th><td><input class="easyui-textbox"   name="extChr05" id="r_extChr05" style="width:100%;" /></td>
							<th><span data-item="LAB_025">문자속성10</span></th><td><input class="easyui-textbox"   name="extChr10" id="r_extChr10" style="width:100%;" /></td>
							<th><span data-item="LAB_026">숫자속성05</span></th><td><input class="easyui-numberbox" name="extNum05" id="r_extNum05" style="width:100%;" data-options="min:0" /></td>
			            </tr>
			        </table>
		    	</fieldset>
		    </form>

		</div>

    <!-- [SOUTH] end -->
	</div>

    <!-- [CENTER] start -->
    <div data-options="region:'center',border:false">

		<table id="search-grid">

			<thead data-options="frozen:true">
				<tr>
					<th data-options="field:'codeGrup',   halign:'center', width:100, sortable:true, data_item:'GRD_001'">코드그룹</th>
					<th data-options="field:'codeCd',     halign:'center', width:100, sortable:true, data_item:'GRD_002'">코드</th>
					<th data-options="field:'codeName',   halign:'center', width:150, sortable:true, data_item:'GRD_003'">코드명칭</th>
					<th data-options="field:'codeNameEn', halign:'center', width:150, sortable:true, data_item:'GRD_004'">코드명칭(영문)</th>
					<th data-options="field:'sortSeq',    halign:'center', width:50,  sortable:true, data_item:'GRD_005', align:'right'">순서</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th data-options="field:'codeDesc', halign:'center',width:250, data_item:'GRD_006'">코드설명</th>
					<th data-options="field:'extChr01', halign:'center',width:100, data_item:'GRD_007'">문자속성01</th>
					<th data-options="field:'extChr02', halign:'center',width:100, data_item:'GRD_008'">문자속성02</th>
					<th data-options="field:'extChr03', halign:'center',width:100, data_item:'GRD_009'">문자속성03</th>
					<th data-options="field:'extChr04', halign:'center',width:100, data_item:'GRD_010'">문자속성04</th>
					<th data-options="field:'extChr05', halign:'center',width:100, data_item:'GRD_011'">문자속성05</th>
					<th data-options="field:'extChr06', halign:'center',width:100, data_item:'GRD_012'">문자속성06</th>
					<th data-options="field:'extChr07', halign:'center',width:100, data_item:'GRD_013'">문자속성07</th>
					<th data-options="field:'extChr08', halign:'center',width:100, data_item:'GRD_014'">문자속성08</th>
					<th data-options="field:'extChr09', halign:'center',width:100, data_item:'GRD_015'">문자속성09</th>
					<th data-options="field:'extChr10', halign:'center',width:100, data_item:'GRD_016'">문자속성10</th>
					<th data-options="field:'extNum01', halign:'center',width:100, data_item:'GRD_017', align:'right'">숫자속성01</th>
					<th data-options="field:'extNum02', halign:'center',width:100, data_item:'GRD_018', align:'right'">숫자속성02</th>
					<th data-options="field:'extNum03', halign:'center',width:100, data_item:'GRD_019', align:'right'">숫자속성03</th>
					<th data-options="field:'extNum04', halign:'center',width:100, data_item:'GRD_020', align:'right'">숫자속성04</th>
					<th data-options="field:'extNum05', halign:'center',width:100, data_item:'GRD_021', align:'right'">숫자속성05</th>
					<th data-options="field:'extText' , halign:'center',width:250, data_item:'GRD_022'">기타정보</th>
				</tr>
			</thead>
		</table>

		<div id="search-toolbar" class="wui-toolbar">
			<form id="search-form">
				<fieldset class="div-line3-new Remake-div-line-new" >
			        <table cellpadding="4" class="search-table tableSearch-c wd-100" style="margin-top: 0;"  >
			        	<tr class="topnav_sty">
		            		<td colspan="8" >
		            			<div>
			            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
			            			<div>
										<a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001">검색</a>
			                        </div>
		                        </div>
		            		</td>
		            	</tr>
		            	
			            <tr>
							<th class="h table-Search-h"><span data-item="LAB_027">코드그룹 </span></th>
							<td class="d"><input class="easyui-combobox" name="codeGrup" id="s_codeGrup" codeGrup="0" data-options="mode:'remote',width:150,loader:jcombo.loader"/></td>
							<th class="h"><span data-item="LAB_028">사용여부 </span></th>
							<td class="d">
								<select class="easyui-combobox" name="useFlag" ID="s_useFlag" data-option="width:90">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'USE_FLAG' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
								</select>
								<!-- <span class="radio-span">
									<input name="useFlag" type="radio" value="Y" id="s_useFlag1"/><label for="s_useFlag1">사용중</label>
									<input name="useFlag" type="radio" value="N" id="s_useFlag2"/><label for="s_useFlag2">중지</label>
								</span> -->
							</td>
							<th class="h"><span data-item="LAB_029">정렬선택 </span></th>
							<td class="d"><input class="easyui-combobox" name="sort" id="s_sort" codeGrup="CODE_SORT" data-options="mode:'remote',width:100,loader:jcombo.loader"/></td>
							<td class="b">
								<!-- <a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001">검색</a> -->
							</td>
			            </tr>
			        </table>
			   </fieldset>
			   <fieldset class="div-line-new-sub">
			   <!-- <div class="div-line"></div> -->
			        <table cellpadding="5" class="search-table tableEtc-c">
			            <tr>
							<td class="h">
						        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_002">저장</a>
						        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">삭제</a>
								<a href="javascript:void(0)" class="easyui-linkbutton btn_print" iconCls=""  id="report-button-pdf" data-item="BTN_005" >인쇄&nbsp;
							    	<img src="<%=request.getContextPath() %>/resources/images/icon_new/print.png" />
							    </a>
							</td>
			            </tr>
			        </table>
				</fieldset>
			</form>
		</div>

    <!-- [CENTER] end -->
	</div>


<!-- [LAYOUT] end -->
</div>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
