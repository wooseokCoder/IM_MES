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
<script type="text/javascript" src="<c:url value="/resources/js/common/user/user.js" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>

<%--  BBUG.TEST : grid Color 
<script>
	$(function(){
		$('#search-grid').datagrid({
			rowStyler:function(index,row){
				if (index % 2 == 0){
					return 'background-color:#ffffff;';
				}
				if (index % 2 == 1){
					return 'background-color:#fafafa;';
				}
			}
		});
	});
</script>
--%>
	

<%--  BBUG.TEST : grid Color
<style type = "text/css">
   tr:hover, tr.over { background-color: #ff0000; }
</style>
 --%>

<script>

/*$(function () {
    $(window).resize(function () {
        devHeight = window.innerHeight;
        if (devHeight >= 520) {
            //$('.datagrid-view').css('height', devHeight - 425);
            //scroll_check();
            
            $('#search-grid').resizable({
            	minHeight: 500
            });
        }
    });
});*/
</script>

</head>



<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<table id="search-grid">

	<thead data-options="frozen:true">
		<tr>
			<th data-options="field:'ck',       checkbox:true"></th>
			<th data-options="field:'userId',   width: 80, halign:'center', align:'center', data_item:'GRD_001', sortable:true">사용자ID</th>
			<th data-options="field:'userName', width:100, halign:'center', align:'center', data_item:'GRD_002', sortable:true">사용자명</th>
			<th data-options="field:'userType', width: 50, halign:'center', align:'center', data_item:'GRD_003', formatter:jformat.userType">유형</th>
		<c:if test="${admin == 'Y'}">
			<th data-options="field:'userLogin',width: 50, halign:'center', align:'center', data_item:'GRD_004', styler: function() {return {class:'icon-ok'};}">로그인</th>
		</c:if>
		</tr>
	</thead>
	<thead>
		<tr>
			<th data-options="field:'userPwd',       width: 80, halign:'center', align:'left',   data_item:'GRD_005'">비밀번호</th>
			<th data-options="field:'userTel',       width:120, halign:'center', align:'left',   data_item:'GRD_006'">전화번호</th>
			<th data-options="field:'userHp',        width:120, halign:'center', align:'left',   data_item:'GRD_007'">핸드폰</th>
			<th data-options="field:'userMail',      width:150, halign:'center', align:'left',   data_item:'GRD_008'">이메일</th>
			<th data-options="field:'userRemk',      width:200, halign:'center', align:'left',   data_item:'GRD_009'">비고</th>
			<th data-options="field:'emplNo',        width:100, halign:'center', align:'center', data_item:'GRD_010'">사번</th>
			<th data-options="field:'comCode',       width:100, halign:'center', align:'center', data_item:'GRD_011'">회사코드</th>
			<th data-options="field:'comName',       width:120, halign:'center', align:'left',   data_item:'GRD_012'">회사명</th>
			<th data-options="field:'deptCode',      width:100, halign:'center', align:'center', data_item:'GRD_013'">부서코드</th>
			<th data-options="field:'deptName',      width:100, halign:'center', align:'left',   data_item:'GRD_014'">부서명</th>
			<th data-options="field:'upprDeptCode',  width:100, halign:'center', align:'center', data_item:'GRD_015'">상위부서</th>
			<th data-options="field:'orgAuthCode',   width:100, halign:'center', align:'center', data_item:'GRD_016'">기본권한</th>
			<th data-options="field:'spcAuthCode',   width:100, halign:'center', align:'center', data_item:'GRD_017'">특별권한</th>
			<th data-options="field:'loginFailCnt',  width: 80, halign:'center', align:'center', data_item:'GRD_018'">로그인<br/>실패횟수</th>
			<th data-options="field:'pwdChngDate',   width:140, halign:'center', align:'center', data_item:'GRD_019'">비밀번호<br/>변경일자</th>
			<th data-options="field:'lastLoginDate', width:140, halign:'center', align:'center', data_item:'GRD_020'">최종<br/>로그인일자</th>
			<th data-options="field:'regiId',        width: 80, halign:'center', align:'center', data_item:'GRD_021'">등록자ID</th>
			<th data-options="field:'regiDate',      width:140, halign:'center', align:'center', data_item:'GRD_022'">등록일시</th>
			<th data-options="field:'chngId',        width: 80, halign:'center', align:'center', data_item:'GRD_023'">수정자ID</th>
			<th data-options="field:'chngDate',      width:140, halign:'center', align:'center', data_item:'GRD_024'">수정일시</th>
		</tr>
	</thead>
</table>

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
					<th class="h"><span data-item="LAB_002">부서&nbsp;</span></th>
					<td class="d">
						<input class="easyui-combobox" name="deptPrnt" id="s_deptPrnt" 
							data-options="width:120,
										mode:'remote',
										loader:jcombo.loader,
										params:{codeGrup:'DEPT_CODE',extNum01:1},
										child: {id:'s_deptCode',name:'deptCode'},
										onChange: jcombo.select
										"
						/><!-- ,
										icons:[{iconCls:'icon-cut',handler: function() {
												$('#s_deptPrnt').combobox('clear');
											}
										}] -->
						<input class="easyui-combobox" name="deptCode" id="s_deptCode" 
							data-options="width:120,
										mode:'remote',
										loader:jcombo.loader,
										params:{codeGrup:'DEPT_CODE',extNum01:2},
										parent:{id:'s_deptPrnt',name:'extChr01'}
										"
						/><!-- ,
										icons:[{iconCls:'icon-cut',handler: function() {
												$('#s_deptCode').combobox('clear');
											}
										}] -->
					</td>
					<th class="h"><span data-item="LAB_003">사용여부 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="useFlag" ID="s_useFlag">
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
					<td class="b">
						<!-- <a href="javascript:void(0)" class="easyui-linkbutton cgray" iconCls="icon-search" id="search-button">검색</a> -->
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">검색</a> 
						<input type="hidden" id="hdfIndex" value="-1" />
						<input type="hidden" id="hdfChk" value="" />
					</td>
	            </tr>
	        </table>
	      </fieldset>
	        <!-- <div class="div-line"></div> -->
	      <fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table  tableEtc-c" >
	            <tr>
					<td class="h" style="width:600px">
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002">추가</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">삭제</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button" data-item="BTN_004">엑셀</a>
					</td>
					<td class="h etctext" style="width:75%;" data-item="TXT_001"><span>상세 정보는 해당 행을 더블클릭하시면 확인 할수 있습니다.</span></td>
	            </tr>
	        </table>
	        <!--  <div class="div-line"></div> -->
		</fieldset>
	</form>
    <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="append-button">추가</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a> -->
    
	<!-- <div>
		<table>
			<tr>
				<td><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"    id="append-button">추가</a></td>
				<td><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" id="remove-button">삭제</a></td>
				<td style="width:100%; text-align: right; color:#0064FF"><span>상세 정보는 해당 행을 더블클릭하시면 확인 할수 있습니다.</span></td>
			</tr>
		</table>
	</div> -->
</div>
<!-- 2016/12/05 김영진 -- title 한영변환 재검토 -->
<div id="regist-popup" class="easyui-dialog" data-options="
	 	width: 800,
	 	height: 520,
	 	closed: true,
	 	title:'${progName} 상세',
	 	iconCls:'icon-edit',
	 	buttons:'#regist-buttons'
	 ">

    <form id="regist-form" method="post">
    	<fieldset>
    		<input type="hidden" name="sysId" id="r_sysId" />
    		<input type="hidden" name="oper"  id="r_oper"  />
    		
	        <table  cellpadding="5" cellspacing="2" class="select-table">
	            <tr>
					<th><span data-item="LAB_004">사용자ID:</span></th>
					<td><input class="easyui-textbox" name="userId" id="r_userId" data-options="required:true" /></td> 
					<th><span data-item="LAB_005">사용자명:</span></th>
					<td><input class="easyui-textbox" name="userName" id="r_userName" data-options="required:true" /></td> 
	            </tr>
	            <tr>
					<th><span data-item="LAB_006">비밀번호:</span></th>
					<td><input class="easyui-textbox" name="userPwd" id="r_userPwd" data-options="required:true" /></td> 
					<th><span data-item="LAB_007">유형:</span></th>
					<td><input class="easyui-textbox" name="userTypeCd" id="r_userTypeCd" data-options="width:45,readonly:true" />
					    <input class="easyui-combogrid" name="userType" id="r_userType" data-options="
							width:100,
							required:true,
							editable:false,
							fitColumns:true,
							panelWidth:150,
							textField:'codeName',
							idField:'codeCd',
							method:'post',
							url:'${context}/common/code/code.json',
							queryParams:{'codeGrup':'USER_TYPE'},
							onChange: function(newVal, oldVal) {
								$('#r_userTypeCd').textbox('setValue', newVal);	
							},
							columns: [[
							    {field:'codeCd',align:'center',width:50,title:'코드'},
							    {field:'codeName',align:'left',width:100,title:'코드명'}
							]]" /></td>
	            </tr>
				<tr>
					<th><span data-item="LAB_008">전화번호:</span></th>
					<td><input class="easyui-textbox" name="userTel" id="r_userTel" /></td> 
					<th><span data-item="LAB_009">핸드폰:</span></th>
					<td><input class="easyui-textbox" name="userHp" id="r_userHp" /></td> 
				</tr>
				<tr>
					<th><span data-item="LAB_010">이메일:</span></th>
					<td><input class="easyui-textbox" name="userMail" id="r_userMail" /></td> 
					<th><span data-item="LAB_011">비고:</span></th>
					<td><input class="easyui-textbox" name="userRemk" id="r_userRemk" /></td> 
				</tr>
				<tr>
					<th><span data-item="LAB_012">회사코드:</span></th>
					<td><input class="easyui-textbox" name="comCode" id="r_comCode" /></td> 
					<th><span data-item="LAB_013">회사명:</span></th>
					<td><input class="easyui-textbox" name="comName" id="r_comName" /></td> 
				</tr>
				<tr>
					<th><span data-item="LAB_014">부서코드:</span></th>
					<td><input class="easyui-textbox" name="deptCode" id="r_deptCode" /></td> 
					<th><span data-item="LAB_015">부서명:</span></th>
					<td><input class="easyui-textbox" name="deptName" id="r_deptName" /></td> 
				</tr>
				<tr>
					<th><span data-item="LAB_016">상위부서:</span></th>
					<td><input class="easyui-textbox" name="upprDeptCode" id="r_upprDeptCode" /></td> 
					<th><span data-item="LAB_017">사번:</span></th>
					<td><input class="easyui-textbox" name="emplNo" id="r_emplNo" /></td> 
				</tr>
				<tr>
					<th><span data-item="LAB_018">기본권한:</span></th>
					<td><input class="easyui-textbox" name="orgAuthCode" id="r_orgAuthCode" /></td> 
					<th><span data-item="LAB_019">특별권한:</span></th>
					<td><input class="easyui-textbox" name="spcAuthCode" id="r_spcAuthCode" /></td> 
				</tr>
	            <tr>
					<th><span data-item="LAB_020">사용유무:</span></th>
					<td><input name="useFlag" type="radio" value="Y" id="r_useFlag1"/><label for="r_useFlag1">사용중</label>
						<input name="useFlag" type="radio" value="N" id="r_useFlag2"/><label for="r_useFlag2">중지</label>
					</td>
					<th><span data-item="LAB_021">로그인실패횟수:</span></th><td><span id="r_loginFailCnt"></span></td>
	            </tr>
	            <tr>
					<th><span data-item="LAB_022">비밀번호변경일자:</span></th><td><span id="r_pwdChngDate"></span></td>
					<th><span data-item="LAB_023">최종로그인일자:</span></th><td><span id="r_lastLoginDate"></span></td>
	            </tr>
	            <tr>
					<th><span data-item="LAB_024">등록자ID:</span></th><td><span id="r_regiId"  ></span></td>
					<th><span data-item="LAB_025">등록일시:</span></th><td><span id="r_regiDate"></span></td>
	            </tr>
	            <tr>
					<th><span data-item="LAB_026">수정자ID:</span></th><td><span id="r_chngId"  ></span></td>
					<th><span data-item="LAB_027">수정일시:</span></th><td><span id="r_chngDate"></span></td>
	            </tr>
	        </table>
    	</fieldset>
    </form>

</div>
<div id="regist-buttons" style="padding:5px">
   <a href="javascript:void(0)" class="easyui-linkbutton c8" iconCls="icon-ok"     id="save-button" data-item="BTN_005">저장</a>
   <a href="javascript:void(0)" class="easyui-linkbutton"    iconCls="icon-cancel" id="cancel-button" data-item="BTN_006">취소</a>
</div>

<form id="login-form" name="login-form" method="post">
	<fieldset>
		<input type="hidden" id="j_system" name="j_system" />
		<input type="hidden" id="j_userid" name="j_userid" />
		<input type="hidden" id="j_secure" name="j_secure" />
	</fieldset>
</form>


<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
